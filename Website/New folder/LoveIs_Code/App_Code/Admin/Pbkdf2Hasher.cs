using System.Security.Cryptography;

public static class Pbkdf2Hasher
{
    public static void Create(string password, int iterations, out byte[] salt, out byte[] hash)
    {
        salt = new byte[16];
        using (var rng = RandomNumberGenerator.Create())
        {
            rng.GetBytes(salt);
        }

        using (var pbkdf2 = new Rfc2898DeriveBytes(password, salt, iterations, HashAlgorithmName.SHA256))
        {
            hash = pbkdf2.GetBytes(32);
        }
    }

    public static bool Verify(string password, byte[] salt, byte[] expectedHash, int iterations)
    {
        using (var pbkdf2 = new Rfc2898DeriveBytes(password, salt, iterations, HashAlgorithmName.SHA256))
        {
            byte[] hash = pbkdf2.GetBytes(expectedHash.Length);
            return ConstantTimeEquals(hash, expectedHash);
        }
    }

    private static bool ConstantTimeEquals(byte[] a, byte[] b)
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
