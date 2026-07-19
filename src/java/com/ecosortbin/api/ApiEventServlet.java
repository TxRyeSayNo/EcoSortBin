package com.ecosortbin.api;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class ApiEventServlet extends HttpServlet {
    
    // Static in-memory storage for MVP
    private static final List<String> recentEvents = Collections.synchronizedList(new ArrayList<>());
    
    // Statistics counters (initialized with dummy data from UI)
    private static int totalCount = 148;
    private static int plasticCount = 62;
    private static int metalCount = 47;
    private static int glassCount = 39;
    private static int unknownCount = 4;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Accept form-data from Python
        String wasteType = request.getParameter("wasteType");
        String confidence = request.getParameter("confidence");
        String deviceId = request.getParameter("deviceId");
        
        if (wasteType != null && !"UNKNOWN".equalsIgnoreCase(wasteType)) {
            String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("HH:mm:ss dd/MM/yyyy"));
            
            // Build JSON for Supabase (matching the table columns)
            String supabaseJson = String.format(
                "{\"bin_id\": \"%s\", \"waste_type\": \"%s\", \"confidence\": %s}",
                deviceId != null ? deviceId : "SMART_BIN_001",
                wasteType.toUpperCase(),
                confidence != null ? confidence : "0"
            );
            
            // Push to Supabase asynchronously to avoid blocking the API response
            new Thread(() -> {
                SupabaseClient.insert("events", supabaseJson);
            }).start();
            
            // Still keep in RAM for the Dashboard (optional, or we can fetch from Supabase later)
            String eventJson = String.format(
                "{\"wasteType\": \"%s\", \"confidence\": %s, \"deviceId\": \"%s\", \"timestamp\": \"%s\"}",
                wasteType, confidence != null ? confidence : "0", deviceId != null ? deviceId : "UNKNOWN", timestamp
            );
            recentEvents.add(0, eventJson); // Add to beginning
            if (recentEvents.size() > 20) { // Keep last 20 events
                recentEvents.remove(recentEvents.size() - 1);
            }
            
            // Update stats
            totalCount++;
            switch (wasteType.toUpperCase()) {
                case "PLASTIC": plasticCount++; break;
                case "METAL": metalCount++; break;
                case "GLASS": glassCount++; break;
            }
        }
        
        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().write("OK");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        // Build JSON response manually to avoid external dependencies for now
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"totalCount\":").append(totalCount).append(",");
        json.append("\"plastic\":").append(plasticCount).append(",");
        json.append("\"metal\":").append(metalCount).append(",");
        json.append("\"glass\":").append(glassCount).append(",");
        json.append("\"unknown\":").append(unknownCount).append(",");
        
        json.append("\"events\": [");
        synchronized (recentEvents) {
            for (int i = 0; i < recentEvents.size(); i++) {
                json.append(recentEvents.get(i));
                if (i < recentEvents.size() - 1) json.append(",");
            }
        }
        json.append("]");
        json.append("}");
        
        PrintWriter out = response.getWriter();
        out.print(json.toString());
        out.flush();
    }
}
