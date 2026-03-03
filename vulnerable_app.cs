using System;
using System.Data.SqlClient;
using System.IO;
using System.Security.Cryptography;
using System.Diagnostics;
using System.Web;
using System.Runtime.Serialization.Formatters.Binary;
using System.Xml;

namespace VulnerableApp
{
    public class VulnerableApp
    {
        // Hardcoded credentials (CWE-798)
        private const string DbPassword = "cs_hardcoded_pass_123";
        private const string ApiKey = "cs_api_key_hardcoded_1234567890";
        private const string ConnectionString = "Server=localhost;Database=mydb;User Id=sa;Password=sa123;";

        // SQL Injection (CWE-89)
        public static void GetUser(string username)
        {
            using var conn = new SqlConnection(ConnectionString);
            var cmd = new SqlCommand("SELECT * FROM Users WHERE Username = '" + username + "'", conn);
            conn.Open();
            cmd.ExecuteReader();
        }

        public static void DeleteRecord(string id)
        {
            using var conn = new SqlConnection(ConnectionString);
            var cmd = new SqlCommand($"DELETE FROM Records WHERE Id = {id}", conn);
            conn.Open();
            cmd.ExecuteNonQuery();
        }

        // Command Injection (CWE-78)
        public static string RunCommand(string input)
        {
            var proc = new Process
            {
                StartInfo = new ProcessStartInfo
                {
                    FileName = "cmd.exe",
                    Arguments = "/c " + input,     // Unsanitized input
                    UseShellExecute = false,
                    RedirectStandardOutput = true
                }
            };
            proc.Start();
            return proc.StandardOutput.ReadToEnd();
        }

        // Path Traversal (CWE-22)
        public static string ReadFile(string filename)
        {
            return File.ReadAllText("C:\\app\\" + filename);
        }

        public static void WriteFile(string path, string content)
        {
            File.WriteAllText("C:\\uploads\\" + path, content);
        }

        // Weak cryptography (CWE-326)
        public static string HashPassword(string password)
        {
            using var md5 = MD5.Create();
            var bytes = md5.ComputeHash(System.Text.Encoding.UTF8.GetBytes(password));
            return BitConverter.ToString(bytes);
        }

        public static string WeakEncrypt(string data)
        {
            using var sha1 = SHA1.Create();
            var bytes = sha1.ComputeHash(System.Text.Encoding.UTF8.GetBytes(data));
            return BitConverter.ToString(bytes);
        }

        // Insecure Deserialization (CWE-502)
        public static object Deserialize(byte[] data)
        {
            var formatter = new BinaryFormatter();   // Insecure
            using var ms = new MemoryStream(data);
            return formatter.Deserialize(ms);
        }

        // XXE (CWE-611)
        public static XmlDocument ParseXml(string xml)
        {
            var doc = new XmlDocument();
            doc.XmlResolver = new XmlUrlResolver(); // XXE enabled
            doc.LoadXml(xml);
            return doc;
        }

        // XSS (CWE-79)
        public static string RenderPage(string userInput)
        {
            return $"<html><body>{userInput}</body></html>"; // No encoding
        }

        // Insecure Random (CWE-330)
        public static string GenerateToken()
        {
            var rng = new Random();                  // Not cryptographic
            return rng.Next(999999).ToString();
        }

        // Open Redirect (CWE-601)
        public static void Redirect(HttpResponse response, string url)
        {
            response.Redirect(url);                  // Unvalidated redirect
        }

        // Sensitive Data in Logs (CWE-532)
        public static bool Login(string user, string password)
        {
            Console.WriteLine($"Login: user={user} password={password}");
            return password == DbPassword;
        }

        // Integer Overflow (CWE-190)
        public static int CalcSize(int userInput)
        {
            return userInput * 1024 * 1024;          // Can overflow
        }

        // Null Reference without check (CWE-476)
        public static int GetLength(string s)
        {
            return s.Length;                         // No null check
        }

        static void Main(string[] args)
        {
            GetUser("admin' OR '1'='1'--");
            RunCommand("dir C:\\ & whoami");
            ReadFile("../../windows/system32/config/sam");
            Console.WriteLine(HashPassword("password"));
            Console.WriteLine(GenerateToken());
        }
    }
}
