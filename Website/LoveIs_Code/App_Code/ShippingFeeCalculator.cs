using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;

public static class ShippingFeeCalculator
{
    public static decimal CalculateFee(string carrierCode, CfShippingMethod method, bool isInnerCity)
    {
        if (method == null)
        {
            return 0m;
        }

        var baseFee = isInnerCity ? method.InnerCityFee : method.BaseFee;
        return baseFee + GetCarrierAdjustment(carrierCode, baseFee);
    }

    public static decimal CalculateFee(string carrierCode, decimal baseFee)
    {
        return baseFee + GetCarrierAdjustment(carrierCode, baseFee);
    }

    private static decimal GetCarrierAdjustment(string carrierCode, decimal baseFee)
    {
        var code = (carrierCode ?? string.Empty).Trim().ToUpperInvariant();

        switch (code)
        {
            case "GHN":
                return Math.Round(baseFee * 0.10m, 2);
            case "GHTK":
                return Math.Round(baseFee * 0.05m, 2);
            case "VTPOST":
                return Math.Round(baseFee * 0.08m, 2);
            case "VNPOST":
                return Math.Round(baseFee * 0.06m, 2);
            default:
                return 0m;
        }
    }
}

public class ShopShippingFeeSummary
{
    public int ShopId { get; set; }
    public int ShippingMethodId { get; set; }
    public string ShippingMethodName { get; set; }
    public string ShippingEta { get; set; }
    public int? CarrierId { get; set; }
    public string CarrierCode { get; set; }
    public decimal ShippingFee { get; set; }
    public decimal Subtotal { get; set; }
    public bool FreeShippingApplied { get; set; }
}

public static class CheckoutShippingHelper
{
    public static CfShippingMethod GetDefaultShippingMethod(BeautyStoryContext db)
    {
        if (db == null)
        {
            return null;
        }

        return db.CfShippingMethods.AsNoTracking()
            .Where(m => m.Status)
            .OrderByDescending(m => m.IsDefault)
            .ThenBy(m => m.SortOrder)
            .ThenBy(m => m.Id)
            .FirstOrDefault();
    }

    public static Dictionary<int, ShopShippingFeeSummary> BuildShopShippingLookup(int? provinceId, int? wardId, int? shippingMethodIdOverride, List<CartService.CartItem> cart)
    {
        var result = new Dictionary<int, ShopShippingFeeSummary>();

        if (cart == null || cart.Count == 0)
        {
            return result;
        }

        using (var db = new BeautyStoryContext())
        {
            var variantIds = cart.Select(c => c.VariantId).Distinct().ToList();
            var variants = db.CfProductVariants.AsNoTracking()
                .Where(v => variantIds.Contains(v.Id))
                .ToList();
            var productIds = variants.Select(v => v.ProductId).Distinct().ToList();
            var products = db.CfProducts.AsNoTracking()
                .Where(p => productIds.Contains(p.Id))
                .ToList();

            var variantLookup = variants.ToDictionary(v => v.Id, v => v);
            var productLookup = products.ToDictionary(p => p.Id, p => p);

            string provinceName = null;
            if (provinceId.HasValue)
            {
                provinceName = db.CfProvinces.AsNoTracking()
                    .Where(p => p.Id == provinceId.Value)
                    .Select(p => p.ProvinceName)
                    .FirstOrDefault();
            }

            var isInnerCity = IsInnerCityWard(db, wardId, provinceId);

            foreach (var item in cart)
            {
                CfProductVariant variant;
                if (!variantLookup.TryGetValue(item.VariantId, out variant))
                {
                    continue;
                }

                CfProduct product;
                if (!productLookup.TryGetValue(variant.ProductId, out product))
                {
                    continue;
                }

                var shopId = product.ShopId ?? 0;
                if (shopId <= 0)
                {
                    continue;
                }

                ShopShippingFeeSummary summary;
                if (!result.TryGetValue(shopId, out summary))
                {
                    summary = new ShopShippingFeeSummary { ShopId = shopId };
                    result[shopId] = summary;
                }

                var price = GetEffectivePrice(variant.Price, variant.SalePrice);
                summary.Subtotal += price * item.Quantity;
            }

            if (result.Count == 0)
            {
                return result;
            }

            var defaultMethod = GetDefaultShippingMethod(db);
            var defaultCarrierId = GetDefaultCarrierId(db);
            var defaultCarrierCode = GetCarrierCodeById(db, defaultCarrierId);

            foreach (var summary in result.Values)
            {
                var config = GetShopShippingConfig(db, summary.ShopId);

                var methodId = config != null && config.DefaultShippingMethodId > 0
                    ? config.DefaultShippingMethodId
                    : (defaultMethod != null ? defaultMethod.Id : 0);

                if (shippingMethodIdOverride.HasValue && shippingMethodIdOverride.Value > 0)
                {
                    methodId = shippingMethodIdOverride.Value;
                }

                var method = methodId > 0
                    ? db.CfShippingMethods.AsNoTracking().FirstOrDefault(m => m.Id == methodId && m.Status)
                    : null;

                if (method == null && defaultMethod != null)
                {
                    method = defaultMethod;
                    methodId = defaultMethod.Id;
                }

                summary.ShippingMethodId = method != null ? method.Id : 0;
                summary.ShippingMethodName = method != null ? method.Name : string.Empty;
                summary.ShippingEta = method != null ? method.EtaText : string.Empty;

                var carrierId = config != null && config.DefaultShippingCarrierId.HasValue
                    ? config.DefaultShippingCarrierId
                    : defaultCarrierId;

                summary.CarrierId = carrierId;
                var carrierCode = GetCarrierCodeById(db, carrierId);
                summary.CarrierCode = !string.IsNullOrWhiteSpace(carrierCode) ? carrierCode : defaultCarrierCode;

                var fee = 0m;
                if (method != null)
                {
                    fee = ShippingFeeCalculator.CalculateFee(summary.CarrierCode, method, isInnerCity);
                }

                if (config != null && config.FreeShippingEnabled && summary.Subtotal >= config.FreeShippingMinOrder)
                {
                    summary.FreeShippingApplied = true;
                    summary.ShippingFee = 0m;
                }
                else
                {
                    summary.ShippingFee = fee;
                }
            }
        }

        return result;
    }

    private static CfShopShippingConfig GetShopShippingConfig(BeautyStoryContext db, int shopId)
    {
        if (db == null || shopId <= 0)
        {
            return null;
        }

        return db.CfShopShippingConfigs.AsNoTracking()
            .FirstOrDefault(c => c.ShopId == shopId && c.Status);
    }

    private static int? GetDefaultCarrierId(BeautyStoryContext db)
    {
        if (db == null)
        {
            return null;
        }

        var carrier = db.CfShippingCarriers.AsNoTracking()
            .Where(c => c.Status)
            .OrderByDescending(c => c.IsDefault)
            .ThenBy(c => c.SortOrder)
            .ThenBy(c => c.Id)
            .FirstOrDefault();

        return carrier != null ? (int?)carrier.Id : null;
    }

    private static string GetCarrierCodeById(BeautyStoryContext db, int? carrierId)
    {
        if (db == null || !carrierId.HasValue)
        {
            return null;
        }

        var carrier = db.CfShippingCarriers.AsNoTracking()
            .FirstOrDefault(c => c.Id == carrierId.Value);

        return carrier != null ? carrier.Code : null;
    }

    private static bool IsInnerCityWard(BeautyStoryContext db, int? wardId, int? provinceId)
    {
        if (db == null)
        {
            return false;
        }

        if (wardId.HasValue)
        {
            var ward = db.CfWards.AsNoTracking().FirstOrDefault(w => w.Id == wardId.Value);
            if (ward != null)
            {
                return ward.IsInnerCity;
            }
        }

        if (provinceId.HasValue)
        {
            var provinceName = db.CfProvinces.AsNoTracking()
                .Where(p => p.Id == provinceId.Value)
                .Select(p => p.ProvinceName)
                .FirstOrDefault();

            if (!string.IsNullOrWhiteSpace(provinceName))
            {
                var name = provinceName.ToLowerInvariant();
                return name.Contains("ho chi minh") || name.Contains("hcm") || name.Contains("ha noi") || name.Contains("hn");
            }
        }

        return false;
    }
private static decimal GetEffectivePrice(decimal price, decimal? salePrice)
    {
        var sale = salePrice.HasValue ? salePrice.Value : 0m;
        if (sale > 0 && sale < price)
        {
            return sale;
        }

        return price > 0 ? price : 0m;
    }
}

