import java.sql.DriverManager
import java.security.MessageDigest
import java.io.File
import java.io.ObjectInputStream
import java.io.ByteArrayInputStream
import java.net.URL
import java.util.Random

// Hardcoded credentials (CWE-798)
const val DB_PASSWORD = "kotlin_hardcoded_pass_123"
const val API_KEY = "kotlin_hardcoded_api_key_abcdef"
const val JWT_SECRET = "kotlin_jwt_secret_never_rotate"

// SQL Injection (CWE-89)
fun getUser(username: String) {
    val conn = DriverManager.getConnection("jdbc:mysql://localhost/db", "root", DB_PASSWORD)
    val stmt = conn.createStatement()
    stmt.executeQuery("SELECT * FROM users WHERE username = '$username'")
}

fun searchOrders(term: String) {
    val conn = DriverManager.getConnection("jdbc:mysql://localhost/db", "root", DB_PASSWORD)
    val stmt = conn.createStatement()
    stmt.executeQuery("SELECT * FROM orders WHERE item LIKE '%$term%'")
}

// Command Injection (CWE-78)
fun pingHost(host: String) {
    Runtime.getRuntime().exec(arrayOf("/bin/sh", "-c", "ping -c 1 $host"))
}

fun runScript(script: String) {
    Runtime.getRuntime().exec(script)
}

// Path Traversal (CWE-22)
fun readFile(filename: String): String {
    return File("/var/app/$filename").readText()
}

fun writeFile(path: String, content: String) {
    File("/uploads/$path").writeText(content)
}

// Weak cryptography (CWE-326)
fun hashPassword(password: String): String {
    val md = MessageDigest.getInstance("MD5")
    return md.digest(password.toByteArray()).joinToString("") { "%02x".format(it) }
}

fun weakHash(data: String): String {
    val sha1 = MessageDigest.getInstance("SHA-1")
    return sha1.digest(data.toByteArray()).joinToString("") { "%02x".format(it) }
}

// Insecure Deserialization (CWE-502)
fun deserialize(data: ByteArray): Any {
    val ois = ObjectInputStream(ByteArrayInputStream(data))
    return ois.readObject()
}

// SSRF (CWE-918)
fun fetchURL(url: String): String {
    return URL(url).readText()
}

// Insecure Random (CWE-330)
fun generateToken(): Int {
    return Random().nextInt(999999)
}

fun generateOTP(): String {
    return String.format("%04d", Random().nextInt(10000))
}

// XSS (CWE-79)
fun renderPage(userInput: String): String {
    return "<html><body>$userInput</body></html>"
}

// Sensitive data in logs (CWE-532)
fun login(user: String, password: String): Boolean {
    println("Login attempt: user=$user password=$password")
    return password == DB_PASSWORD
}

// Null pointer dereference (CWE-476)
fun getLength(s: String?): Int {
    return s!!.length   // Force unwrap - can throw NPE
}

fun main() {
    getUser("admin' OR '1'='1'--")
    pingHost("google.com; cat /etc/passwd")
    readFile("../../etc/shadow")
    println(hashPassword("password"))
    println(generateToken())
}
