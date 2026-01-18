using System;
using System.Collections.Generic;
using System.Linq;

public partial class SellerProductAdd : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!SellerAuth.IsSignedIn())
        {
            Response.Redirect("/seller/login.aspx?returnUrl=" + Server.UrlEncode(Request.Url.PathAndQuery));
            return;
        }

        if (!IsPostBack)
        {
            BindDropdowns();
        }
    }

    private void BindDropdowns()
    {
        var sellerId = SellerAuth.GetSellerId();
        if (!sellerId.HasValue)
        {
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var categories = db.CfCategories
                .Where(c => c.Status && !c.ParentId.HasValue)
                .OrderBy(c => c.SortOrder)
                .ThenBy(c => c.CategoryName)
                .Select(c => new
                {
                    c.Id,
                    c.CategoryName
                })
                .ToList();

            CategoryDropdown.DataSource = categories;
            CategoryDropdown.DataTextField = "CategoryName";
            CategoryDropdown.DataValueField = "Id";
            CategoryDropdown.DataBind();

            CategoryDropdown.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Vui lòng chọn", ""));

            var brands = db.CfBrands
                .Where(b => b.Status)
                .OrderBy(b => b.SortOrder)
                .ThenBy(b => b.BrandName)
                .Select(b => new { b.Id, b.BrandName })
                .ToList();
            BrandDropdown.DataSource = brands;
            BrandDropdown.DataTextField = "BrandName";
            BrandDropdown.DataValueField = "Id";
            BrandDropdown.DataBind();
            BrandDropdown.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Vui lòng chọn", ""));

            var origins = db.CfOrigins
                .Where(o => o.Status)
                .OrderBy(o => o.SortOrder)
                .ThenBy(o => o.OriginName)
                .Select(o => new { o.Id, o.OriginName })
                .ToList();
            OriginDropdown.DataSource = origins;
            OriginDropdown.DataTextField = "OriginName";
            OriginDropdown.DataValueField = "Id";
            OriginDropdown.DataBind();
            OriginDropdown.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Vui lòng chọn", ""));

            var warehouses = db.CfShops
                .Where(s => s.SellerId == sellerId.Value)
                .OrderBy(s => s.ShopName)
                .Select(s => new { s.Id, s.ShopName })
                .ToList();
            WarehouseDropdown.DataSource = warehouses;
            WarehouseDropdown.DataTextField = "ShopName";
            WarehouseDropdown.DataValueField = "Id";
            WarehouseDropdown.DataBind();
            WarehouseDropdown.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Vui lòng chọn", ""));
        }
    }
}
