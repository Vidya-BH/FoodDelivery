package com.food.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

public class DBConnection {
    private static String url;
    private static String username;
    private static String password;
    private static String driver;

    static {
        try {
            Properties props = new Properties();
            try (InputStream is = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
                if (is != null) {
                    props.load(is);
                    url = props.getProperty("db.url");
                    username = props.getProperty("db.username");
                    password = props.getProperty("db.password");
                    driver = props.getProperty("db.driver", "com.mysql.cj.jdbc.Driver");
                } else {
                    // Fallbacks
                    url = "jdbc:mysql://localhost:3306/smartfooddb?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
                    username = "root";
                    password = "";
                    driver = "com.mysql.cj.jdbc.Driver";
                }
            }
            Class.forName(driver);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws Exception {
        return DriverManager.getConnection(url, username, password);
    }
}
