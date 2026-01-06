using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

public partial class AdminDefault : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDashboard();
        }
    }

    private void LoadDashboard()
    {
        using (var db = new BeautyStoryContext())
        {
            var today = DateTime.Today;
            var tomorrow = today.AddDays(1);

            var ordersToday = db.CfOrders.Where(o => o.Status && o.CreatedAt >= today && o.CreatedAt < tomorrow);
            var ordersTodayCount = ordersToday.Count();
            var ordersTodayRevenue = ordersToday.Any() ? ordersToday.Sum(o => o.Total) : 0m;

            var ordersTotal = db.CfOrders.Count(o => o.Status);
            var ordersPending = db.CfOrders.Count(o => o.Status && (o.OrderStatusId == null || o.OrderStatusId == 0));

            var productsTotal = db.CfProducts.Count(p => p.Status);
            var customerTotal = db.CfOrders
                .Where(o => o.Status && o.Phone != null && o.Phone != "")
                .Select(o => o.Phone)
                .Distinct()
                .Count();

            var contactNew = db.CfContactMessages.Count(m => !m.Status);

            OrdersTodayLiteral.Text = ordersTodayCount.ToString("N0", CultureInfo.InvariantCulture);
            RevenueTodayLiteral.Text = ordersTodayRevenue.ToString("N0", CultureInfo.InvariantCulture) + " VND";
            OrdersTotalLiteral.Text = ordersTotal.ToString("N0", CultureInfo.InvariantCulture);
            OrdersPendingLiteral.Text = ordersPending.ToString("N0", CultureInfo.InvariantCulture);
            ProductsTotalLiteral.Text = productsTotal.ToString("N0", CultureInfo.InvariantCulture);
            CustomersTotalLiteral.Text = customerTotal.ToString("N0", CultureInfo.InvariantCulture);
            ContactNewLiteral.Text = contactNew.ToString("N0", CultureInfo.InvariantCulture);

            var recentOrders = db.CfOrders
                .OrderByDescending(o => o.CreatedAt)
                .Take(6)
                .ToList();

            var orderItems = new List<RecentOrderView>();
            foreach (var order in recentOrders)
            {
                orderItems.Add(new RecentOrderView
                {
                    Id = order.Id,
                    OrderCode = order.OrderCode,
                    CustomerName = order.CustomerName,
                    OrderStatus = string.IsNullOrWhiteSpace(order.OrderStatus) ? "Mới" : order.OrderStatus,
                    TotalText = order.Total.ToString("N0", CultureInfo.InvariantCulture) + " VND",
                    CreatedAtText = order.CreatedAt.ToString("dd/MM/yyyy HH:mm")
                });
            }

            RecentOrdersRepeater.DataSource = orderItems;
            RecentOrdersRepeater.DataBind();
            RecentOrdersEmpty.Visible = orderItems.Count == 0;

            var lowStockRaw = db.CfProductVariants
                .Where(v => v.Status && v.StockQty <= 5)
                .Join(
                    db.CfProducts,
                    variant => variant.ProductId,
                    product => product.Id,
                    (variant, product) => new
                    {
                        product.ProductName,
                        variant.VariantName,
                        variant.StockQty
                    })
                .OrderBy(item => item.StockQty)
                .Take(8)
                .ToList();

            var lowStock = lowStockRaw
                .Select(item => new LowStockView
                {
                    ProductName = item.ProductName,
                    VariantName = string.IsNullOrWhiteSpace(item.VariantName) ? "Mặc định" : item.VariantName,
                    StockQty = item.StockQty
                })
                .ToList();

            LowStockRepeater.DataSource = lowStock;
            LowStockRepeater.DataBind();
            LowStockEmpty.Visible = lowStock.Count == 0;

            var recentContacts = db.CfContactMessages
                .OrderByDescending(m => m.CreatedAt)
                .Take(6)
                .ToList();

            var contactItems = new List<RecentContactView>();
            foreach (var item in recentContacts)
            {
                contactItems.Add(new RecentContactView
                {
                    FullName = item.FullName,
                    Email = item.Email,
                    Subject = item.Subject,
                    CreatedAtText = item.CreatedAt.ToString("dd/MM/yyyy HH:mm")
                });
            }

            RecentContactsRepeater.DataSource = contactItems;
            RecentContactsRepeater.DataBind();
            RecentContactsEmpty.Visible = contactItems.Count == 0;
        }
    }

    private class RecentOrderView
    {
        public int Id { get; set; }
        public string OrderCode { get; set; }
        public string CustomerName { get; set; }
        public string OrderStatus { get; set; }
        public string TotalText { get; set; }
        public string CreatedAtText { get; set; }
    }

    private class LowStockView
    {
        public string ProductName { get; set; }
        public string VariantName { get; set; }
        public int StockQty { get; set; }
    }

    private class RecentContactView
    {
        public string FullName { get; set; }
        public string Email { get; set; }
        public string Subject { get; set; }
        public string CreatedAtText { get; set; }
    }
}
