using System;
using System.Globalization;
using System.Linq;

public partial class ShopChatBuyNow : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        int productId = 0;
        int.TryParse(Request.QueryString["productId"], out productId);
        if (productId <= 0)
        {
            Response.Redirect("/gio-hang");
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var product = db.CfProducts.FirstOrDefault(p => p.Id == productId && p.Status);
            if (product == null)
            {
                Response.Redirect("/gio-hang");
                return;
            }

            var variant = db.CfProductVariants
                .Where(v => v.ProductId == productId && v.Status)
                .OrderBy(v => v.SortOrder)
                .ThenBy(v => v.Price)
                .FirstOrDefault();

            if (variant == null)
            {
                Response.Redirect("/gio-hang");
                return;
            }

            CartService.AddVariantWithResult(variant.Id, 1);
        }

        Response.Redirect("/gio-hang");
    }
}
