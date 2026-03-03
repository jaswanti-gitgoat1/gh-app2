import Foundation
import CryptoKit
import CommonCrypto

// Hardcoded credentials (CWE-798)
let DB_PASSWORD = "swift_hardcoded_pass_123"
let API_KEY = "swift_api_key_hardcoded_abcdef"
let AWS_SECRET = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYSWEXAMPLE"

// SQL Injection via string interpolation (CWE-89)
func getUser(username: String) -> String {
    return "SELECT * FROM users WHERE username = '\(username)'"
}

func searchProducts(term: String) -> String {
    return "SELECT * FROM products WHERE name LIKE '%\(term)%'"
}

// Command Injection (CWE-78)
func pingHost(host: String) {
    let task = Process()
    task.launchPath = "/bin/sh"
    task.arguments = ["-c", "ping -c 1 \(host)"]   // Unsanitized
    task.launch()
}

func runScript(script: String) {
    let task = Process()
    task.launchPath = "/bin/sh"
    task.arguments = ["-c", script]                  // Direct execution
    task.launch()
}

// Path Traversal (CWE-22)
func readFile(filename: String) -> String? {
    let path = "/var/app/\(filename)"
    return try? String(contentsOfFile: path)
}

func writeFile(path: String, content: String) {
    try? content.write(toFile: "/uploads/\(path)", atomically: false, encoding: .utf8)
}

// Weak cryptography - MD5 (CWE-326)
func hashPassword(_ password: String) -> String {
    let data = Data(password.utf8)
    var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
    data.withUnsafeBytes { CC_MD5($0.baseAddress, CC_LONG(data.count), &digest) }
    return digest.map { String(format: "%02x", $0) }.joined()
}

// Insecure random (CWE-330)
func generateToken() -> Int {
    return Int.random(in: 0...999999)               // Not cryptographically secure for tokens
}

// SSRF (CWE-918)
func fetchURL(urlString: String) -> Data? {
    guard let url = URL(string: urlString) else { return nil }
    return try? Data(contentsOf: url)               // User-controlled URL
}

// Sensitive data in logs (CWE-532)
func login(user: String, password: String) -> Bool {
    print("Login: user=\(user) password=\(password)")
    return password == DB_PASSWORD
}

// Force unwrap - crash risk (CWE-476)
func parseJSON(data: Data) -> [String: Any] {
    return try! JSONSerialization.jsonObject(with: data) as! [String: Any]
}

// Insecure URL scheme check - allows HTTP (CWE-319)
func loadWebContent(urlString: String) -> URLRequest {
    let url = URL(string: urlString)!               // Allows http:// (cleartext)
    return URLRequest(url: url)
}

// XSS in WebView (CWE-79)
func renderHTML(userInput: String) -> String {
    return "<html><body>\(userInput)</body></html>" // No sanitization
}

// Hardcoded private key in source
let PRIVATE_KEY = """
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEA2a2rwplBQLzHPZe5TNJAA6sB2OuQKgRUBPFIoFNE/qTBjwRC
hardcoded_private_key_content_for_testing
-----END RSA PRIVATE KEY-----
"""
