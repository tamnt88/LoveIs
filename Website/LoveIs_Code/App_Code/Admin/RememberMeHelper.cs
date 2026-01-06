using System;
using System.Configuration;
using System.Security.Cryptography;
using System.Text;

public static class RememberMeHelper
{
    public static string BuildToken(int userId, string username, byte[] passwordHash)
    {
        string secret = ConfigurationManager.AppSettings["AdminRememberSecret"] ?? string.Empty;
        string hashHex = ToHex(passwordHash);
        string payload = userId + "|" + username + "|" + hashHex + "|" + secret;
        return ComputeSha256Hex(payload);
    }

    public static bool IsTokenValid(int userId, string username, byte[] passwordHash, string token)
    {
        if (string.IsNullOrWhiteSpace(token))
        {
            return false;
        }

        string expected = BuildToken(userId, username, passwordHash);
        return SlowEquals(expected, token);
    }

    private static string ComputeSha256Hex(string input)
    {
        using (var sha = SHA256.Create())
        {
            byte[] bytes = sha.ComputeHash(Encoding.UTF8.GetBytes(input));
            return ToHex(bytes);
        }
    }

    private static string ToHex(byte[] bytes)
    {
        if (bytes == null)
        {
            return string.Empty;
        }

        var sb = new StringBuilder(bytes.Length * 2);
        for (int i = 0; i < bytes.Length; i++)
        {
            sb.Append(bytes[i].ToString("x2"));
        }

        return sb.ToString();
    }

    private static bool SlowEquals(string a, string b)
    {
        if (a == null || b == null || a.Length != b.Length)
        {
            return false;
        }

        int diff = 0;
        for (int i = 0; i < a.Length; i++)
        {
            diff |= a[i] ^ b[i];
        }

        return diff == 0;
    }
}
