<?php

// Hardcoded credentials (CWE-798)
define('DB_PASS', 'php_hardcoded_pass_123');
define('SECRET_KEY', 'php_secret_key_abcdef1234567890');
define('API_TOKEN', 'Bearer eyJhbGciOiJub25lIn0.hardcoded.token');

// SQL Injection (CWE-89)
function getUser($username) {
    $conn = new mysqli("localhost", "root", DB_PASS, "mydb");
    $result = $conn->query("SELECT * FROM users WHERE username = '$username'");
    return $result->fetch_all();
}

function getProduct($id) {
    $conn = new mysqli("localhost", "root", DB_PASS, "mydb");
    $result = $conn->query("SELECT * FROM products WHERE id = " . $id);
    return $result->fetch_all();
}

function deleteUser($id) {
    $conn = new mysqli("localhost", "root", DB_PASS, "mydb");
    $conn->query("DELETE FROM users WHERE id = " . $_GET['id']);
}

// Command Injection (CWE-78)
function pingHost($host) {
    echo shell_exec("ping -c 1 " . $host);
}

function runCommand($cmd) {
    return system($_GET['cmd']);
}

function listFiles($dir) {
    return exec("ls " . $dir);
}

// XSS (CWE-79)
function greetUser($name) {
    echo "<h1>Hello " . $name . "</h1>";
}

function showSearch($query) {
    echo "<p>Results for: " . $_GET['q'] . "</p>";
}

// Path Traversal (CWE-22)
function readFile($filename) {
    return file_get_contents("/var/app/" . $filename);
}

function includeFile($page) {
    include("/pages/" . $_GET['page'] . ".php");
}

// Weak cryptography (CWE-326)
function hashPassword($password) {
    return md5($password);
}

function weakEncrypt($data) {
    return sha1($data);
}

// Insecure deserialization (CWE-502)
function loadObject($data) {
    return unserialize($data);
}

function loadUserPrefs() {
    return unserialize($_COOKIE['prefs']);
}

// Insecure random (CWE-330)
function generateToken() {
    return rand(0, 999999);
}

function generateSessionId() {
    return mt_rand();
}

// SSRF (CWE-918)
function fetchURL($url) {
    return file_get_contents($_GET['url']);
}

// File upload without validation (CWE-434)
function uploadFile() {
    move_uploaded_file($_FILES['file']['tmp_name'], '/uploads/' . $_FILES['file']['name']);
}

// Open redirect (CWE-601)
function redirect() {
    header("Location: " . $_GET['url']);
}

// Code injection via eval (CWE-95)
function calculate($expr) {
    eval('$result = ' . $expr . ';');
    return $result;
}

// Sensitive data in logs (CWE-532)
function login($user, $password) {
    error_log("Login: user=$user password=$password");
    return $password == DB_PASS;
}

// XXE via simplexml (CWE-611)
function parseXML($xmlString) {
    return simplexml_load_string($xmlString, 'SimpleXMLElement', LIBXML_NOENT);
}

// LDAP Injection (CWE-90)
function ldapSearch($username) {
    $ldap = ldap_connect("ldap://localhost");
    ldap_search($ldap, "dc=example,dc=com", "uid=" . $username);
}

// Sensitive data in URL (CWE-598)
function sendRequest($token) {
    file_get_contents("https://api.example.com/data?token=" . $token . "&user=" . DB_PASS);
}

?>
