import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

public class TestSupabase {
    public static void main(String[] args) {
        try {
            String URL_STR = "https://tstnufzxpdnmxdbciawt.supabase.co/rest/v1/events";
            String KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRzdG51Znp4cGRubXhkYmNpYXd0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODQ0NDE3NjIsImV4cCI6MjEwMDAxNzc2Mn0.hsgP-XGp64ANtTehutxHXmWDw6CRM4ctWNLpuqkb4Y4";
            URL url = new URL(URL_STR);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("apikey", KEY);
            conn.setRequestProperty("Authorization", "Bearer " + KEY);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Prefer", "return=minimal");
            conn.setDoOutput(true);
            
            String jsonBody = "{\"bin_id\": \"SMART_BIN_001\", \"waste_type\": \"PLASTIC\", \"confidence\": 99.9}";
            try(OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonBody.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }
            
            int code = conn.getResponseCode();
            System.out.println("Code: " + code);
            java.io.InputStream is = code < 400 ? conn.getInputStream() : conn.getErrorStream();
            java.util.Scanner s = new java.util.Scanner(is).useDelimiter("\\A");
            String result = s.hasNext() ? s.next() : "";
            System.out.println("Body: " + result);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
