package com.ecosortbin.api;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

public class HeartbeatServlet extends HttpServlet {
    
    // Initial dummy data
    private static int glassLevel = 15;
    private static int metalLevel = 30;
    private static int plasticLevel = 60;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String glassStr = request.getParameter("glass");
        String metalStr = request.getParameter("metal");
        String plasticStr = request.getParameter("plastic");
        String deviceId = request.getParameter("deviceId");
        
        // If parameters exist, this is an update from ESP32
        if (glassStr != null && metalStr != null && plasticStr != null) {
            // Build JSON for Supabase PATCH
            String supabaseJson = String.format(
                "{\"capacity_plastic\": %s, \"capacity_metal\": %s, \"capacity_glass\": %s, \"last_updated\": \"now()\"}",
                plasticStr, metalStr, glassStr
            );
            
            // Push to Supabase asynchronously
            new Thread(() -> {
                SupabaseClient.update("bins", "id", deviceId != null ? deviceId : "SMART_BIN_001", supabaseJson);
            }).start();

            try {
                glassLevel = Integer.parseInt(glassStr);
                metalLevel = Integer.parseInt(metalStr);
                plasticLevel = Integer.parseInt(plasticStr);
            } catch (NumberFormatException e) {
                // Ignore parsing errors
            }
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("OK");
        } 
        // If no parameters, this is a read request from Browser (Dashboard)
        else {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            String json = String.format(
                "{\"glass\": %d, \"metal\": %d, \"plastic\": %d}",
                glassLevel, metalLevel, plasticLevel
            );
            
            PrintWriter out = response.getWriter();
            out.print(json);
            out.flush();
        }
    }
}
