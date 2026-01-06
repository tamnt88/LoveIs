using System;
using System.Linq;
using System.Text.RegularExpressions;

public static class OAuthCustomerHelper
{
    public static CfCustomer GetOrCreateCustomer(string email, string name, string provider)
    {
        if (string.IsNullOrWhiteSpace(email))
        {
            return null;
        }

        var safeName = string.IsNullOrWhiteSpace(name) ? null : name.Trim();
        var safeEmail = email.Trim().ToLowerInvariant();

        using (var db = new BeautyStoryContext())
        {
            var existing = db.CfCustomers.FirstOrDefault(c => c.Email == safeEmail);
            if (existing != null)
            {
                existing.LastLoginAt = DateTime.UtcNow;
                if (!string.IsNullOrWhiteSpace(safeName) && string.IsNullOrWhiteSpace(existing.DisplayName))
                {
                    existing.DisplayName = safeName;
                }
                db.SaveChanges();
                return existing;
            }

            var username = GenerateUniqueUsername(db, safeEmail, provider);
            var password = Guid.NewGuid().ToString("N");

            byte[] salt;
            byte[] hash;
            int iterations = 100000;
            Pbkdf2Hasher.Create(password, iterations, out salt, out hash);

            var customer = new CfCustomer
            {
                Username = username,
                DisplayName = safeName,
                Email = safeEmail,
                Phone = null,
                PasswordSalt = salt,
                PasswordHash = hash,
                PasswordIterations = iterations,
                Status = true,
                EmailVerified = true,
                EmailVerifyToken = null,
                EmailVerifyExpiresAt = null,
                CreatedAt = DateTime.UtcNow,
                SortOrder = 0
            };

            db.CfCustomers.Add(customer);
            db.SaveChanges();
            return customer;
        }
    }

    private static string GenerateUniqueUsername(BeautyStoryContext db, string email, string provider)
    {
        var baseName = "user";
        var local = email.Split('@')[0];
        local = Regex.Replace(local, @"[^a-zA-Z0-9_\\.]", "");
        if (!string.IsNullOrWhiteSpace(local))
        {
            baseName = local.ToLowerInvariant();
        }

        var prefix = string.IsNullOrWhiteSpace(provider) ? "oauth" : provider.ToLowerInvariant();
        var candidate = baseName;
        int suffix = 0;

        while (db.CfCustomers.Any(c => c.Username == candidate))
        {
            suffix++;
            candidate = string.Format("{0}_{1}_{2}", baseName, prefix, suffix);
        }

        return candidate;
    }
}
