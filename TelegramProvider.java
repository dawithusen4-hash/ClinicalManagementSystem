package com.clinic.util; // Change to your package name

import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

public class TelegramProvider {
    // Replace with the token you got from BotFather
    private static final String BOT_TOKEN = "7890123456:AAHbYExampleToken_abc123";

    public static void sendNotification(String chatId, String message) {
        try {
            // Telegram API URL for sending messages
            String urlString = "https://api.telegram.org/bot" + BOT_TOKEN + "/sendMessage";
            URL url = new URL(urlString);
            
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            conn.setRequestProperty("Content-Type", "application/json");

            // Create JSON payload
            String jsonPayload = "{\"chat_id\": \"" + chatId + "\", \"text\": \"" + message + "\"}";

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonPayload.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            // Check if it worked (200 = Success)
            int responseCode = conn.getResponseCode();
            System.out.println("Telegram Notification Sent. Response Code: " + responseCode);
            
        } catch (Exception e) {
            System.out.println("Telegram Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}