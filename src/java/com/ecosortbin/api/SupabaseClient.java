package com.ecosortbin.api;

import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

public class SupabaseClient {
    
    public static void insert(String table, String jsonBody) {
        try {
            URL url = new URL(SupabaseConfig.URL + "/rest/v1/" + table);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("apikey", SupabaseConfig.KEY);
            conn.setRequestProperty("Authorization", "Bearer " + SupabaseConfig.KEY);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Prefer", "return=minimal");
            conn.setDoOutput(true);
            
            try(OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonBody.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }
            
            int code = conn.getResponseCode();
            if(code != 201 && code != 200) {
                System.out.println("Supabase Insert Error: " + code);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public static void upsert(String table, String jsonBody) {
        try {
            URL url = new URL(SupabaseConfig.URL + "/rest/v1/" + table);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("apikey", SupabaseConfig.KEY);
            conn.setRequestProperty("Authorization", "Bearer " + SupabaseConfig.KEY);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Prefer", "resolution=merge-duplicates,return=minimal");
            conn.setDoOutput(true);
            
            try(OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonBody.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }
            
            int code = conn.getResponseCode();
            if(code != 201 && code != 200) {
                System.out.println("Supabase Upsert Error: " + code);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public static void update(String table, String matchColumn, String matchValue, String jsonBody) {
        try {
            URL url = new URL(SupabaseConfig.URL + "/rest/v1/" + table + "?" + matchColumn + "=eq." + matchValue);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            // Workaround for Java 8 HttpURLConnection not supporting PATCH natively
            conn.setRequestMethod("POST");
            conn.setRequestProperty("X-HTTP-Method-Override", "PATCH");
            conn.setRequestProperty("apikey", SupabaseConfig.KEY);
            conn.setRequestProperty("Authorization", "Bearer " + SupabaseConfig.KEY);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);
            
            try(OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonBody.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }
            
            int code = conn.getResponseCode();
            if(code != 204 && code != 200) {
                System.out.println("Supabase Update Error: " + code);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
