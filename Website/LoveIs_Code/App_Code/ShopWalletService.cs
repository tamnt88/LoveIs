using System;
using System.Collections.Generic;
using System.Linq;

public static class ShopWalletService
{
    public static void AddPendingForPaidOrder(BeautyStoryContext db, CfOrder order, IEnumerable<CfShopOrder> shopOrders, string actor)
    {
        if (db == null || order == null || shopOrders == null)
        {
            return;
        }

        var holdDays = GetHoldDays(db);
        var releaseAt = DateTime.Now.AddDays(holdDays);

        foreach (var shopOrder in shopOrders)
        {
            if (shopOrder == null)
            {
                continue;
            }

            var exists = db.CfShopWalletTxns.Any(t =>
                t.ShopId == shopOrder.ShopId &&
                t.ShopOrderId == shopOrder.Id &&
                t.Type == "PENDING_IN");
            if (exists)
            {
                continue;
            }

            var wallet = db.CfShopWallets.FirstOrDefault(w => w.ShopId == shopOrder.ShopId);
            if (wallet == null)
            {
                wallet = new CfShopWallet
                {
                    ShopId = shopOrder.ShopId,
                    Balance = 0m,
                    AvailableBalance = 0m,
                    PendingBalance = 0m,
                    Status = true,
                    CreatedAt = DateTime.Now,
                    CreatedBy = actor,
                    SortOrder = 0
                };
                db.CfShopWallets.Add(wallet);
                db.SaveChanges();
            }

            var amount = shopOrder.Total;
            var balanceBefore = wallet.Balance;
            var availableBefore = wallet.AvailableBalance;
            var pendingBefore = wallet.PendingBalance;

            wallet.Balance = balanceBefore + amount;
            wallet.PendingBalance = pendingBefore + amount;
            wallet.UpdatedAt = DateTime.Now;
            wallet.UpdatedBy = actor;

            db.CfShopWalletTxns.Add(new CfShopWalletTxn
            {
                ShopId = shopOrder.ShopId,
                OrderId = order.Id,
                ShopOrderId = shopOrder.Id,
                Type = "PENDING_IN",
                Amount = amount,
                BalanceBefore = balanceBefore,
                BalanceAfter = wallet.Balance,
                AvailableBefore = availableBefore,
                AvailableAfter = wallet.AvailableBalance,
                PendingBefore = pendingBefore,
                PendingAfter = wallet.PendingBalance,
                Note = "Cộng tiền cho đơn hàng đã thanh toán",
                CreatedAt = DateTime.Now,
                CreatedBy = actor
            });

            db.CfShopWalletReleases.Add(new CfShopWalletRelease
            {
                ShopId = shopOrder.ShopId,
                OrderId = order.Id,
                ShopOrderId = shopOrder.Id,
                Amount = amount,
                ReleaseAt = releaseAt,
                Status = "Pending",
                Note = "Chờ admin duyệt giải ngân",
                CreatedAt = DateTime.Now,
                CreatedBy = actor,
                SortOrder = 0
            });
        }
    }

    private static int GetHoldDays(BeautyStoryContext db)
    {
        if (db == null)
        {
            return 7;
        }

        try
        {
            var setting = db.CfSystemSettings
                .FirstOrDefault(s => s.Status && (s.Key ?? string.Empty).Trim().ToUpper() == "WALLETHOLDDAYS");
            if (setting != null)
            {
                int days;
                if (int.TryParse((setting.Value ?? string.Empty).Trim(), out days) && days >= 0)
                {
                    return days;
                }
            }
        }
        catch
        {
        }

        return 7;
    }

    public static CfShopPayoutRequest CreatePayoutRequest(BeautyStoryContext db, int shopId, int bankAccountId, decimal amount, string actor, string note)
    {
        if (db == null || shopId <= 0 || bankAccountId <= 0 || amount <= 0)
        {
            return null;
        }

        var wallet = db.CfShopWallets.FirstOrDefault(w => w.ShopId == shopId);
        if (wallet == null || wallet.AvailableBalance < amount)
        {
            return null;
        }

        var balanceBefore = wallet.Balance;
        var availableBefore = wallet.AvailableBalance;
        var pendingBefore = wallet.PendingBalance;

        wallet.AvailableBalance = availableBefore - amount;
        wallet.UpdatedAt = DateTime.Now;
        wallet.UpdatedBy = actor;

        var request = new CfShopPayoutRequest
        {
            ShopId = shopId,
            BankAccountId = bankAccountId,
            Amount = amount,
            Status = "Requested",
            Note = note,
            RequestedAt = DateTime.Now,
            RequestedBy = actor,
            CreatedAt = DateTime.Now,
            CreatedBy = actor,
            SortOrder = 0
        };
        db.CfShopPayoutRequests.Add(request);

        db.CfShopWalletTxns.Add(new CfShopWalletTxn
        {
            ShopId = shopId,
            Type = "PAYOUT_HOLD",
            Amount = amount,
            BalanceBefore = balanceBefore,
            BalanceAfter = wallet.Balance,
            AvailableBefore = availableBefore,
            AvailableAfter = wallet.AvailableBalance,
            PendingBefore = pendingBefore,
            PendingAfter = wallet.PendingBalance,
            Note = "Giữ tiền cho lệnh rút tiền",
            CreatedAt = DateTime.Now,
            CreatedBy = actor
        });

        return request;
    }

    public static bool MarkPayoutPaid(BeautyStoryContext db, int payoutRequestId, string actor, string note)
    {
        if (db == null || payoutRequestId <= 0)
        {
            return false;
        }

        var request = db.CfShopPayoutRequests.FirstOrDefault(r => r.Id == payoutRequestId);
        if (request == null)
        {
            return false;
        }

        var wallet = db.CfShopWallets.FirstOrDefault(w => w.ShopId == request.ShopId);
        if (wallet == null)
        {
            return false;
        }

        var balanceBefore = wallet.Balance;
        var availableBefore = wallet.AvailableBalance;
        var pendingBefore = wallet.PendingBalance;

        wallet.Balance = balanceBefore - request.Amount;
        wallet.UpdatedAt = DateTime.Now;
        wallet.UpdatedBy = actor;

        request.Status = "Paid";
        request.PaidAt = DateTime.Now;
        request.PaidBy = actor;
        request.UpdatedAt = DateTime.Now;
        request.UpdatedBy = actor;
        if (!string.IsNullOrWhiteSpace(note))
        {
            request.Note = note;
        }

        db.CfShopWalletTxns.Add(new CfShopWalletTxn
        {
            ShopId = request.ShopId,
            Type = "PAYOUT_OUT",
            Amount = request.Amount,
            BalanceBefore = balanceBefore,
            BalanceAfter = wallet.Balance,
            AvailableBefore = availableBefore,
            AvailableAfter = wallet.AvailableBalance,
            PendingBefore = pendingBefore,
            PendingAfter = wallet.PendingBalance,
            Note = "Chi tiền rút về ngân hàng",
            CreatedAt = DateTime.Now,
            CreatedBy = actor
        });

        return true;
    }

    public static bool RejectPayoutRequest(BeautyStoryContext db, int payoutRequestId, string actor, string note)
    {
        if (db == null || payoutRequestId <= 0)
        {
            return false;
        }

        var request = db.CfShopPayoutRequests.FirstOrDefault(r => r.Id == payoutRequestId);
        if (request == null)
        {
            return false;
        }

        var wallet = db.CfShopWallets.FirstOrDefault(w => w.ShopId == request.ShopId);
        if (wallet == null)
        {
            return false;
        }

        var balanceBefore = wallet.Balance;
        var availableBefore = wallet.AvailableBalance;
        var pendingBefore = wallet.PendingBalance;

        wallet.AvailableBalance = availableBefore + request.Amount;
        wallet.UpdatedAt = DateTime.Now;
        wallet.UpdatedBy = actor;

        request.Status = "Rejected";
        request.UpdatedAt = DateTime.Now;
        request.UpdatedBy = actor;
        request.Note = note;

        db.CfShopWalletTxns.Add(new CfShopWalletTxn
        {
            ShopId = request.ShopId,
            Type = "ADJUST_IN",
            Amount = request.Amount,
            BalanceBefore = balanceBefore,
            BalanceAfter = wallet.Balance,
            AvailableBefore = availableBefore,
            AvailableAfter = wallet.AvailableBalance,
            PendingBefore = pendingBefore,
            PendingAfter = wallet.PendingBalance,
            Note = "Hủy lệnh rút, trả lại số dư khả dụng",
            CreatedAt = DateTime.Now,
            CreatedBy = actor
        });

        return true;
    }

    public static bool AddPayoutProof(BeautyStoryContext db, int payoutRequestId, string fileUrl, string fileName, string actor)
    {
        if (db == null || payoutRequestId <= 0 || string.IsNullOrWhiteSpace(fileUrl))
        {
            return false;
        }

        db.CfShopPayoutProofs.Add(new CfShopPayoutProof
        {
            PayoutRequestId = payoutRequestId,
            FileUrl = fileUrl,
            FileName = fileName,
            UploadedAt = DateTime.Now,
            UploadedBy = actor,
            Status = true
        });

        return true;
    }

    public static bool ApproveRelease(BeautyStoryContext db, int releaseId, string actor, string note)
    {
        if (db == null || releaseId <= 0)
        {
            return false;
        }

        var release = db.CfShopWalletReleases.FirstOrDefault(r => r.Id == releaseId);
        if (release == null || release.Status != "Pending")
        {
            return false;
        }

        release.Status = "Released";
        release.ApprovedAt = DateTime.Now;
        release.ApprovedBy = actor;
        release.UpdatedAt = DateTime.Now;
        release.UpdatedBy = actor;
        if (!string.IsNullOrWhiteSpace(note))
        {
            release.Note = note;
        }

        return true;
    }

    public static bool ReleaseToAvailable(BeautyStoryContext db, int releaseId, string actor)
    {
        if (db == null || releaseId <= 0)
        {
            return false;
        }

        var release = db.CfShopWalletReleases.FirstOrDefault(r => r.Id == releaseId);
        if (release == null || release.Status != "Released")
        {
            return false;
        }

        var wallet = db.CfShopWallets.FirstOrDefault(w => w.ShopId == release.ShopId);
        if (wallet == null)
        {
            return false;
        }

        var balanceBefore = wallet.Balance;
        var availableBefore = wallet.AvailableBalance;
        var pendingBefore = wallet.PendingBalance;

        wallet.PendingBalance = Math.Max(0, pendingBefore - release.Amount);
        wallet.AvailableBalance = availableBefore + release.Amount;
        wallet.UpdatedAt = DateTime.Now;
        wallet.UpdatedBy = actor;

        db.CfShopWalletTxns.Add(new CfShopWalletTxn
        {
            ShopId = release.ShopId,
            OrderId = release.OrderId,
            ShopOrderId = release.ShopOrderId,
            Type = "AVAILABLE_IN",
            Amount = release.Amount,
            BalanceBefore = balanceBefore,
            BalanceAfter = wallet.Balance,
            AvailableBefore = availableBefore,
            AvailableAfter = wallet.AvailableBalance,
            PendingBefore = pendingBefore,
            PendingAfter = wallet.PendingBalance,
            Note = "Giải ngân về số dư khả dụng",
            CreatedAt = DateTime.Now,
            CreatedBy = actor
        });

        release.Status = "Available";
        release.ReleasedAt = DateTime.Now;
        release.ReleasedBy = actor;
        release.UpdatedAt = DateTime.Now;
        release.UpdatedBy = actor;

        return true;
    }

    public static int ReleaseDue(BeautyStoryContext db, string actor)
    {
        if (db == null)
        {
            return 0;
        }

        var now = DateTime.Now;
        var releases = db.CfShopWalletReleases
            .Where(r => r.Status == "Pending" && r.ReleaseAt <= now)
            .ToList();

        var count = 0;
        foreach (var release in releases)
        {
            if (!ApproveRelease(db, release.Id, actor, "Auto approve"))
            {
                continue;
            }

            if (ReleaseToAvailable(db, release.Id, actor))
            {
                count++;
            }
        }

        return count;
    }
}
