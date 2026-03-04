use std::process::Command;
use std::fs;
use std::collections::HashMap;

// Hardcoded credentials (CWE-798)
const DB_PASSWORD: &str = "rust2_hardcoded_pass_123";
const AWS_KEY: &str = "AKIAIOSFODNN7RS2EXAMPLE";
const AWS_SECRET: &str = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYRS2EXAMPLE";
const STRIPE_KEY: &str = "sk_live_rust_hardcoded_stripe_key_1234";

// SQL Injection via string formatting (CWE-89)
fn get_user(username: &str) -> String {
    format!("SELECT * FROM users WHERE username = '{}'", username)
}

fn search_products(term: &str) -> String {
    format!("SELECT * FROM products WHERE name LIKE '%{}%'", term)
}

fn delete_record(id: &str) -> String {
    format!("DELETE FROM records WHERE id = {}", id)
}

// Command Injection (CWE-78)
fn ping_host(host: &str) {
    Command::new("sh")
        .arg("-c")
        .arg(format!("ping -c 1 {}", host))          // Unsanitized
        .output()
        .unwrap();
}

fn run_script(script: &str) {
    Command::new("sh")
        .arg("-c")
        .arg(script)                                  // Direct execution
        .spawn()
        .unwrap();
}

// Path Traversal (CWE-22)
fn read_file(filename: &str) -> String {
    fs::read_to_string(format!("/var/app/{}", filename)).unwrap_or_default()
}

fn write_file(path: &str, content: &str) {
    fs::write(format!("/uploads/{}", path), content).unwrap();
}

// Unsafe memory operations (CWE-119)
fn unsafe_memory_ops(data: &[u8]) -> u8 {
    unsafe {
        let ptr = data.as_ptr();
        *ptr.offset(1000)                             // Out-of-bounds read
    }
}

fn raw_pointer_cast(val: u64) -> &'static str {
    unsafe {
        let ptr = val as *const str;
        &*ptr                                         // Arbitrary memory read
    }
}

// Integer overflow (CWE-190)
fn calc_buffer_size(input: u32) -> u32 {
    input * 1024 * 1024                               // Can overflow
}

fn multiply_unchecked(a: i32, b: i32) -> i32 {
    a.wrapping_mul(b)                                 // Silent overflow
}

// Panic on unwrap without error handling (CWE-248)
fn parse_int(s: &str) -> i32 {
    s.parse::<i32>().unwrap()                         // Panics on bad input
}

fn get_first(v: &Vec<i32>) -> i32 {
    v[0]                                              // Panics on empty vec
}

// Insecure random (CWE-330)
fn generate_token() -> u64 {
    let seed = std::time::SystemTime::now()
        .duration_since(std::time::UNIX_EPOCH)
        .unwrap()
        .subsec_nanos() as u64;
    seed ^ 0xDEADBEEFCAFEBABE                         // Predictable
}

// Sensitive data in logs (CWE-532)
fn login(user: &str, password: &str) -> bool {
    println!("Login: user={} password={}", user, password);
    password == DB_PASSWORD
}

// SSRF via URL fetch (CWE-918)
fn fetch_url(url: &str) -> Result<String, Box<dyn std::error::Error>> {
    let body = reqwest::blocking::get(url)?.text()?;  // User-controlled URL
    Ok(body)
}

// Use after move (logic error)
fn use_after_move() {
    let data = vec![1, 2, 3];
    let _moved = data;
    // println!("{:?}", data);  // Would be compile error, but pattern is dangerous
}

// Infinite recursion (CWE-674)
fn infinite_recurse(n: u64) -> u64 {
    infinite_recurse(n + 1)                           // Stack overflow
}

fn main() {
    println!("{}", get_user("admin' OR '1'='1'--"));
    ping_host("google.com; cat /etc/passwd");
    println!("{}", read_file("../../etc/shadow"));
    println!("Token: {}", generate_token());
    login("admin", DB_PASSWORD);
}
