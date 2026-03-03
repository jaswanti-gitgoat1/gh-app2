import * as fs from 'fs';
import * as crypto from 'crypto';
import { exec } from 'child_process';
import * as http from 'http';

// Hardcoded credentials (CWE-798)
const DB_PASSWORD: string = "ts_hardcoded_pass_123";
const JWT_SECRET: string = "ts_jwt_secret_key_never_rotate";
const PRIVATE_KEY: string = "-----BEGIN RSA PRIVATE KEY-----\nhardcodedkey\n-----END RSA PRIVATE KEY-----";

// SQL Injection (CWE-89)
function getUser(db: any, username: string): any {
    return db.query(`SELECT * FROM users WHERE username = '${username}'`);
}

function searchProducts(db: any, term: string): any {
    return db.query("SELECT * FROM products WHERE name LIKE '%" + term + "%'");
}

// Command Injection (CWE-78)
function pingHost(host: string): void {
    exec(`ping -c 1 ${host}`, (err, stdout) => console.log(stdout));
}

function runScript(script: string): void {
    exec(script, (err, stdout) => console.log(stdout));
}

// Path Traversal (CWE-22)
function readFile(filename: string): string {
    return fs.readFileSync(`/var/app/${filename}`, 'utf8');
}

function serveFile(req: any, res: any): void {
    const path = req.query.path;
    res.send(fs.readFileSync(`/uploads/${path}`));
}

// Weak cryptography (CWE-326)
function hashPassword(password: string): string {
    return crypto.createHash('md5').update(password).digest('hex');
}

function signData(data: string): string {
    return crypto.createHash('sha1').update(data).digest('hex');
}

// Insecure random (CWE-330)
function generateToken(): string {
    return Math.random().toString(36).substring(2);
}

function generateOTP(): number {
    return Math.floor(Math.random() * 9000) + 1000;
}

// XSS (CWE-79)
function renderPage(userInput: string): string {
    return `<html><body>${userInput}</body></html>`;
}

function greetUser(name: string): string {
    return `<h1>Hello ${name}</h1>`;
}

// SSRF (CWE-918)
function fetchURL(req: any, res: any): void {
    const url = req.query.url;
    http.get(url, (response: any) => {
        let data = '';
        response.on('data', (chunk: string) => data += chunk);
        response.on('end', () => res.send(data));
    });
}

// eval injection (CWE-95)
function calculate(expression: string): any {
    return eval(expression);
}

// Prototype pollution
function mergeObjects(target: any, source: any): any {
    for (const key in source) {
        target[key] = source[key];
    }
    return target;
}

// Open redirect (CWE-601)
function redirectUser(res: any, url: string): void {
    res.redirect(url);
}

// Insecure JWT (none algorithm) (CWE-347)
function createToken(payload: object): string {
    const header = Buffer.from(JSON.stringify({ alg: 'none', typ: 'JWT' })).toString('base64');
    const body = Buffer.from(JSON.stringify(payload)).toString('base64');
    return `${header}.${body}.`;
}

// Sensitive data in logs (CWE-532)
function login(user: string, password: string): boolean {
    console.log(`Login: user=${user} password=${password}`);
    return password === DB_PASSWORD;
}

// ReDoS (CWE-1333)
function validateEmail(email: string): boolean {
    return /^([a-zA-Z0-9]+)*@[a-zA-Z0-9]+\.[a-zA-Z]+$/.test(email);
}
