const express = require('express');
const mysql = require('mysql');
const exec = require('child_process').exec;
const fs = require('fs');
const crypto = require('crypto');
const serialize = require('node-serialize');

const app = express();

// Hardcoded credentials (CWE-798)
const DB_PASS = "hardcoded_db_pass_123";
const JWT_SECRET = "mysupersecretjwtkey";
const API_KEY = "sk-1234567890abcdefghijklmnopqrstuvwxyz";

// SQL Injection (CWE-89)
app.get('/user', (req, res) => {
    const conn = mysql.createConnection({ password: DB_PASS });
    const query = "SELECT * FROM users WHERE id = " + req.query.id;
    conn.query(query, (err, results) => res.json(results));
});

app.get('/search', (req, res) => {
    const conn = mysql.createConnection({});
    conn.query(`SELECT * FROM products WHERE name = '${req.query.name}'`, (err, r) => res.json(r));
});

// Command Injection (CWE-78)
app.get('/ping', (req, res) => {
    exec('ping -c 1 ' + req.query.host, (err, stdout) => res.send(stdout));
});

app.get('/exec', (req, res) => {
    exec(req.query.cmd, (err, stdout) => res.send(stdout));
});

// XSS (CWE-79)
app.get('/greet', (req, res) => {
    res.send('<h1>Hello ' + req.query.name + '</h1>');
});

app.get('/search-results', (req, res) => {
    res.send(`<p>Results for: ${req.query.q}</p>`);
});

// Path Traversal (CWE-22)
app.get('/file', (req, res) => {
    res.send(fs.readFileSync('/var/app/' + req.query.path));
});

app.get('/download', (req, res) => {
    res.sendFile('/uploads/' + req.query.filename);
});

// Insecure Deserialization (CWE-502)
app.post('/deserialize', (req, res) => {
    const obj = serialize.unserialize(req.body.data);
    res.json(obj);
});

// Weak cryptography (CWE-326)
function hashPassword(password) {
    return crypto.createHash('md5').update(password).digest('hex');
}

function weakEncrypt(data) {
    return crypto.createHash('sha1').update(data).digest('hex');
}

// Insecure random (CWE-330)
function generateToken() {
    return Math.random().toString(36).substring(2);
}

function generateSessionId() {
    return Math.floor(Math.random() * 1000000).toString();
}

// Open redirect (CWE-601)
app.get('/redirect', (req, res) => {
    res.redirect(req.query.url);
});

// ReDoS (CWE-1333)
function validateEmail(email) {
    const re = /^([a-zA-Z0-9]+)*@[a-zA-Z0-9]+\.[a-zA-Z]+$/;
    return re.test(email);
}

// Prototype pollution
function merge(target, source) {
    for (let key in source) {
        target[key] = source[key];
    }
    return target;
}

// SSRF (CWE-918)
const http = require('http');
app.get('/fetch', (req, res) => {
    http.get(req.query.url, (response) => {
        let data = '';
        response.on('data', chunk => data += chunk);
        response.on('end', () => res.send(data));
    });
});

// eval injection (CWE-95)
app.get('/calc', (req, res) => {
    res.send(eval(req.query.expr));
});

app.listen(3000);
