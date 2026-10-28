package com.example.app;

import com.sun.net.httpserver.HttpServer;
import com.sun.net.httpserver.HttpExchange;

import java.io.*;
import java.net.InetSocketAddress;
import java.net.URLDecoder;
import java.nio.file.Files;
import java.util.*;

public class WebServer {

    static UserDAO dao = new UserDAO();

    public static void main(String[] args) throws Exception {

        dao.createTable();

        HttpServer server = HttpServer.create(new InetSocketAddress(8080), 0);

        server.createContext("/", WebServer::handleIndex);
        server.createContext("/addUser", WebServer::handleAddUserPage);
        server.createContext("/add", WebServer::handleAddUser);

        server.setExecutor(null);
        server.start();

        System.out.println("🌐 Server started at http://localhost:8080");
    }

    private static void handleIndex(HttpExchange exchange) throws IOException {
        String html = Files.readString(new File("web/index.html").toPath());

        StringBuilder rows = new StringBuilder();
        for (User u : dao.getAllUsers()) {
            rows.append("<tr>")
                .append("<td>").append(u.getId()).append("</td>")
                .append("<td>").append(u.getName()).append("</td>")
                .append("<td>").append(u.getEmail()).append("</td>")
                .append("</tr>");
        }

        html = html.replace(
            "<!-- TABLE WILL BE INSERTED BY JAVA -->",
            "<table><tr><th>ID</th><th>Name</th><th>Email</th></tr>" +
            rows + "</table>"
        );

        sendResponse(exchange, html);
    }

    private static void handleAddUserPage(HttpExchange exchange) throws IOException {
        String html = Files.readString(new File("web/addUser.html").toPath());
        sendResponse(exchange, html);
    }

    private static void handleAddUser(HttpExchange exchange) throws IOException {
        if ("POST".equals(exchange.getRequestMethod())) {

            String body = new String(exchange.getRequestBody().readAllBytes());
            Map<String, String> data = parseFormData(body);

            dao.addUser(new User(0, data.get("name"), data.get("email")));

            exchange.getResponseHeaders().add("Location", "/");
            exchange.sendResponseHeaders(302, -1);
        }
    }

    private static Map<String, String> parseFormData(String body) throws UnsupportedEncodingException {
        Map<String, String> map = new HashMap<>();
        for (String pair : body.split("&")) {
            String[] parts = pair.split("=");
            map.put(parts[0], URLDecoder.decode(parts[1], "UTF-8"));
        }
        return map;
    }

    private static void sendResponse(HttpExchange exchange, String response) throws IOException {
        exchange.sendResponseHeaders(200, response.length());
        OutputStream os = exchange.getResponseBody();
        os.write(response.getBytes());
        os.close();
    }
}
