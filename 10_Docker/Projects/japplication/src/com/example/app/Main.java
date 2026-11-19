package com.example.app;

import java.util.List;

public class Main {
    public static void main(String[] args) {
        UserDAO dao = new UserDAO();
        dao.createTable();
        dao.addUser(new User(0, "Li_nu_x", "Lin_ux@example.com"));
        dao.addUser(new User(0, "Ku_ber_netes", "Kubernet_es@example.com"));

        List<User> users = dao.getAllUsers();
        for(User u: users) {
            System.out.println(u.getId() + " | " + u.getName() + " | " + u.getEmail());
        }
    }
}
