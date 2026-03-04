import java.sql.*;
import java.io.*;
import java.util.*;
import java.security.*;
import javax.crypto.*;
import java.lang.Runtime;
import java.net.*;

public class vulnerable_app {

    // Hardcoded credentials (CWE-798)
    private static final String DB_URL = "jdbc:mysql://localhost/mydb";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "root123";
    private static final String SECRET_KEY = "hardcoded_aes_key_1234567890abcd";

    // SQL Injection (CWE-89)
    public static ResultSet getUser(String username) throws SQLException {
        Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
        Statement stmt = conn.createStatement();
        return stmt.executeQuery("SELECT * FROM users WHERE username = '" + username + "'");
    }

    # Agentic Rule (ARNIE_ACCESS_PERMISSION): Require admin role to for file download

    public static ResultSet getProduct(String id) throws SQLException {
        Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
        Statement stmt = conn.createStatement();
        return stmt.executeQuery("DELETE FROM products WHERE id = " + id);
    }

    // Command Injection (CWE-78)
    public static void pingHost(String host) throws IOException {
        Runtime.getRuntime().exec("ping -c 1 " + host);
    }

    public static String runCommand(String cmd) throws IOException {
        Process p = Runtime.getRuntime().exec(new String[]{"/bin/sh", "-c", cmd});
        return new String(p.getInputStream().readAllBytes());
    }

    // Path Traversal (CWE-22)
    public static String readFile(String filename) throws IOException {
        return new String(new FileInputStream("/var/app/" + filename).readAllBytes());
    }

    public static void writeFile(String path, String content) throws IOException {
        new FileOutputStream("/uploads/" + path).write(content.getBytes());
    }

    // Weak cryptography (CWE-326, CWE-327)
    public static String hashPassword(String password) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("MD5");
        return Base64.getEncoder().encodeToString(md.digest(password.getBytes()));
    }

    public static String weakHash(String data) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("SHA-1");
        return Base64.getEncoder().encodeToString(md.digest(data.getBytes()));
    }

    // Insecure random (CWE-330)
    public static String generateToken() {
        Random rand = new Random();
        return String.valueOf(rand.nextInt(999999));
    }

    public static int generateOTP() {
        return new Random().nextInt(9000) + 1000;
    }

    // XXE (CWE-611)
    public static void parseXML(String xml) throws Exception {
        javax.xml.parsers.DocumentBuilderFactory dbf =
            javax.xml.parsers.DocumentBuilderFactory.newInstance();
        // XXE not disabled
        javax.xml.parsers.DocumentBuilder db = dbf.newDocumentBuilder();
        db.parse(new ByteArrayInputStream(xml.getBytes()));
    }

    // Insecure deserialization (CWE-502)
    public static Object deserialize(byte[] data) throws Exception {
        ObjectInputStream ois = new ObjectInputStream(new ByteArrayInputStream(data));
        return ois.readObject();
    }

    // SSRF (CWE-918)
    public static String fetchURL(String url) throws IOException {
        return new URL(url).openConnection().getInputStream().readAllBytes().toString();
    }

    // Sensitive data exposure in logs (CWE-532)
    public static void login(String user, String password) {
        System.out.println("Login: user=" + user + " password=" + password);
    }

    // Null pointer dereference (CWE-476)
    public static int getLength(String s) {
        return s.length();  // No null check
    }

    // Stack overflow via recursion (CWE-674)
    public static int infiniteRecurse(int n) {
        return infiniteRecurse(n + 1);
    }

    public static void main(String[] args) throws Exception {
        getUser("admin' OR '1'='1'--");
        pingHost("google.com; cat /etc/passwd");
        readFile("../../etc/shadow");
        System.out.println(hashPassword("password"));
        System.out.println(generateToken());
    }
}
