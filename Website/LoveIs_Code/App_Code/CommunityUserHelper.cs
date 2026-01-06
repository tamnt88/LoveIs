using System;
using System.Linq;

public static class CommunityUserHelper
{
    public static int? EnsureCommunityCustomerId()
    {
        var customerId = CustomerAuth.GetCustomerId();
        if (customerId.HasValue)
        {
            return customerId;
        }

        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            return null;
        }

        return EnsureCustomerForSellerId(sellerId.Value, true);
    }

    public static int? EnsureCustomerForSellerId(int sellerId, bool signIn)
    {
        using (var db = new BeautyStoryContext())
        {
            var seller = db.CfSellers.FirstOrDefault(s => s.Id == sellerId);
            if (seller == null)
            {
                return null;
            }

            var existingBySeller = db.CfCustomers.FirstOrDefault(c => c.SellerId == seller.Id);
            if (existingBySeller != null)
            {
                if (signIn)
                {
                    CustomerAuth.SignIn(existingBySeller);
                }
                return existingBySeller.Id;
            }

            var email = string.IsNullOrWhiteSpace(seller.Email) ? null : seller.Email.Trim().ToLowerInvariant();
            CfCustomer customer = null;

            if (!string.IsNullOrWhiteSpace(email))
            {
                customer = db.CfCustomers.FirstOrDefault(c => c.Email == email && (c.SellerId == null || c.SellerId == seller.Id));
            }

            if (customer == null)
            {
                var baseUsername = seller.Username;
                var username = baseUsername;
                int suffix = 0;
                while (db.CfCustomers.Any(c => c.Username == username))
                {
                    suffix++;
                    username = baseUsername + "_" + suffix;
                }

                byte[] salt;
                byte[] hash;
                int iterations = 100000;
                Pbkdf2Hasher.Create(Guid.NewGuid().ToString("N"), iterations, out salt, out hash);

                customer = new CfCustomer
                {
                    Username = username,
                    DisplayName = string.IsNullOrWhiteSpace(seller.DisplayName) ? seller.Username : seller.DisplayName,
                    Email = email,
                    Phone = seller.Phone,
                    PasswordSalt = salt,
                    PasswordHash = hash,
                    PasswordIterations = iterations,
                    Status = true,
                    EmailVerified = true,
                    CreatedAt = DateTime.UtcNow,
                    SortOrder = 0,
                    IsSeller = true,
                    SellerId = seller.Id
                };

                db.CfCustomers.Add(customer);
                db.SaveChanges();
            }
            else if (string.IsNullOrWhiteSpace(customer.DisplayName) && !string.IsNullOrWhiteSpace(seller.DisplayName))
            {
                customer.DisplayName = seller.DisplayName;
                if (!customer.IsSeller || customer.SellerId != seller.Id)
                {
                    customer.IsSeller = true;
                    customer.SellerId = seller.Id;
                }
                db.SaveChanges();
            }

            if (signIn)
            {
                CustomerAuth.SignIn(customer);
            }
            return customer.Id;
        }
    }
}
