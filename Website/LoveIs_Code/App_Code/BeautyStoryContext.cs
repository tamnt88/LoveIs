using System.Data.Entity;

public class BeautyStoryContext : DbContext
{
    public BeautyStoryContext() : base("name=BeautyStoryDb")
    {
    }

    public DbSet<CfUser> CfUsers { get; set; }
    public DbSet<CfRole> CfRoles { get; set; }
    public DbSet<CfPermission> CfPermissions { get; set; }
    public DbSet<CfUserRole> CfUserRoles { get; set; }
    public DbSet<CfRolePermission> CfRolePermissions { get; set; }
    public DbSet<CfMenu> CfMenus { get; set; }
    public DbSet<CfMenuPermission> CfMenuPermissions { get; set; }
    public DbSet<CfAuditLog> CfAuditLogs { get; set; }
    public DbSet<CfProvince> CfProvinces { get; set; }
    public DbSet<CfWard> CfWards { get; set; }
    public DbSet<CfCategory> CfCategories { get; set; }
    public DbSet<CfBrand> CfBrands { get; set; }
    public DbSet<CfOrigin> CfOrigins { get; set; }
    public DbSet<CfSeoSlug> CfSeoSlugs { get; set; }
    public DbSet<CfShippingMethod> CfShippingMethods { get; set; }
    public DbSet<CfPaymentMethod> CfPaymentMethods { get; set; }
    public DbSet<CfOrderStatus> CfOrderStatuses { get; set; }
    public DbSet<CfPaymentStatus> CfPaymentStatuses { get; set; }
    public DbSet<CfProduct> CfProducts { get; set; }
    public DbSet<CfProductVariant> CfProductVariants { get; set; }
    public DbSet<CfProductImage> CfProductImages { get; set; }
    public DbSet<CfVariantAttribute> CfVariantAttributes { get; set; }
    public DbSet<CfVariantAttributeValue> CfVariantAttributeValues { get; set; }
    public DbSet<CfProductVariantAttribute> CfProductVariantAttributes { get; set; }
    public DbSet<CfFilterGroup> CfFilterGroups { get; set; }
    public DbSet<CfFilterOption> CfFilterOptions { get; set; }
    public DbSet<CfCategoryFilterGroup> CfCategoryFilterGroups { get; set; }
    public DbSet<CfProductFilter> CfProductFilters { get; set; }
    public DbSet<CfStockMovement> CfStockMovements { get; set; }
    public DbSet<CfOrder> CfOrders { get; set; }
    public DbSet<CfOrderItem> CfOrderItems { get; set; }
    public DbSet<CfOrderHistory> CfOrderHistories { get; set; }
    public DbSet<CfCustomer> CfCustomers { get; set; }
    public DbSet<CfCustomerAddress> CfCustomerAddresses { get; set; }
    public DbSet<CfCustomerBank> CfCustomerBanks { get; set; }
    public DbSet<CfSeller> CfSellers { get; set; }
    public DbSet<CfShop> CfShops { get; set; }
    public DbSet<CfShopUser> CfShopUsers { get; set; }
    public DbSet<CfShopOrder> CfShopOrders { get; set; }
    public DbSet<CfShopOrderHistory> CfShopOrderHistories { get; set; }
    public DbSet<CfReturnRequest> CfReturnRequests { get; set; }
    public DbSet<CfReturnItem> CfReturnItems { get; set; }
    public DbSet<CfPaymentTransaction> CfPaymentTransactions { get; set; }
    public DbSet<CfShippingTracking> CfShippingTrackings { get; set; }
    public DbSet<CfProductReview> CfProductReviews { get; set; }
    public DbSet<CfShopReview> CfShopReviews { get; set; }
    public DbSet<CfSystemSetting> CfSystemSettings { get; set; }
    public DbSet<CfContactInfo> CfContactInfos { get; set; }
    public DbSet<CfContactMessage> CfContactMessages { get; set; }
    public DbSet<CfEmailAccount> CfEmailAccounts { get; set; }
    public DbSet<CfSocialLink> CfSocialLinks { get; set; }
    public DbSet<CfTrackingCode> CfTrackingCodes { get; set; }
    public DbSet<CfFooterMenu> CfFooterMenus { get; set; }
    public DbSet<CfBanner> CfBanners { get; set; }
    public DbSet<CfBrandShowcase> CfBrandShowcases { get; set; }
    public DbSet<CfBrandShowcaseBanner> CfBrandShowcaseBanners { get; set; }
    public DbSet<CfPostCategory> CfPostCategories { get; set; }
    public DbSet<CfPost> CfPosts { get; set; }
    public DbSet<CfPostTag> CfPostTags { get; set; }
    public DbSet<CfPostTagMap> CfPostTagMaps { get; set; }
    public DbSet<CfStaticPage> CfStaticPages { get; set; }
    public DbSet<CfSystemPage> CfSystemPages { get; set; }
    public DbSet<CfCommunityPost> CfCommunityPosts { get; set; }
    public DbSet<CfCommunityPostImage> CfCommunityPostImages { get; set; }
    public DbSet<CfCommunityComment> CfCommunityComments { get; set; }
    public DbSet<CfCommunityLike> CfCommunityLikes { get; set; }
    public DbSet<CfCommunityRoom> CfCommunityRooms { get; set; }
    public DbSet<CfCommunityRoomMember> CfCommunityRoomMembers { get; set; }
    public DbSet<CfCommunityMessage> CfCommunityMessages { get; set; }
    public DbSet<CfCommunityNotification> CfCommunityNotifications { get; set; }
    public DbSet<CfCommunityActionLog> CfCommunityActionLogs { get; set; }

    protected override void OnModelCreating(DbModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<CfCategory>()
            .HasOptional(c => c.Parent)
            .WithMany(p => p.Children)
            .HasForeignKey(c => c.ParentId)
            .WillCascadeOnDelete(false);

        modelBuilder.Entity<CfProduct>()
            .HasRequired(p => p.Category)
            .WithMany(c => c.Products)
            .HasForeignKey(p => p.CategoryId)
            .WillCascadeOnDelete(false);

        modelBuilder.Entity<CfProduct>()
            .HasOptional(p => p.Brand)
            .WithMany(b => b.Products)
            .HasForeignKey(p => p.BrandId)
            .WillCascadeOnDelete(false);

        modelBuilder.Entity<CfProduct>()
            .HasOptional(p => p.Origin)
            .WithMany(o => o.Products)
            .HasForeignKey(p => p.OriginId)
            .WillCascadeOnDelete(false);

        modelBuilder.Entity<CfProductVariant>()
            .HasRequired(v => v.Product)
            .WithMany(p => p.Variants)
            .HasForeignKey(v => v.ProductId)
            .WillCascadeOnDelete(false);

        modelBuilder.Entity<CfProductImage>()
            .HasRequired(i => i.Product)
            .WithMany(p => p.Images)
            .HasForeignKey(i => i.ProductId)
            .WillCascadeOnDelete(false);

        modelBuilder.Entity<CfProductImage>()
            .HasOptional(i => i.Variant)
            .WithMany(v => v.Images)
            .HasForeignKey(i => i.VariantId)
            .WillCascadeOnDelete(false);

        modelBuilder.Entity<CfVariantAttributeValue>()
            .HasRequired(v => v.Attribute)
            .WithMany(a => a.Values)
            .HasForeignKey(v => v.AttributeId)
            .WillCascadeOnDelete(false);

        modelBuilder.Entity<CfProductVariantAttribute>()
            .HasRequired(p => p.Variant)
            .WithMany(v => v.VariantAttributes)
            .HasForeignKey(p => p.VariantId)
            .WillCascadeOnDelete(false);

        modelBuilder.Entity<CfProductVariantAttribute>()
            .HasRequired(p => p.Attribute)
            .WithMany(a => a.ProductVariantAttributes)
            .HasForeignKey(p => p.AttributeId)
            .WillCascadeOnDelete(false);

        modelBuilder.Entity<CfProductVariantAttribute>()
            .HasRequired(p => p.AttributeValue)
            .WithMany(v => v.ProductVariantAttributes)
            .HasForeignKey(p => p.AttributeValueId)
            .WillCascadeOnDelete(false);

        modelBuilder.Entity<CfFilterOption>()
            .HasRequired(o => o.Group)
            .WithMany(g => g.Options)
            .HasForeignKey(o => o.GroupId)
            .WillCascadeOnDelete(false);

        modelBuilder.Entity<CfCategoryFilterGroup>()
            .HasRequired(c => c.Category)
            .WithMany(cg => cg.CategoryFilterGroups)
            .HasForeignKey(c => c.CategoryId)
            .WillCascadeOnDelete(false);

        modelBuilder.Entity<CfCategoryFilterGroup>()
            .HasRequired(c => c.Group)
            .WithMany(g => g.CategoryFilterGroups)
            .HasForeignKey(c => c.GroupId)
            .WillCascadeOnDelete(false);

        modelBuilder.Entity<CfProductFilter>()
            .HasRequired(p => p.Product)
            .WithMany(pf => pf.Filters)
            .HasForeignKey(p => p.ProductId)
            .WillCascadeOnDelete(false);

        modelBuilder.Entity<CfProductFilter>()
            .HasRequired(p => p.Group)
            .WithMany(g => g.ProductFilters)
            .HasForeignKey(p => p.GroupId)
            .WillCascadeOnDelete(false);

        modelBuilder.Entity<CfProductFilter>()
            .HasRequired(p => p.Option)
            .WithMany(o => o.ProductFilters)
            .HasForeignKey(p => p.OptionId)
            .WillCascadeOnDelete(false);

        modelBuilder.Entity<CfStockMovement>()
            .HasRequired(m => m.Variant)
            .WithMany(v => v.StockMovements)
            .HasForeignKey(m => m.VariantId)
            .WillCascadeOnDelete(false);

        modelBuilder.Entity<CfOrderItem>()
            .HasRequired(i => i.Order)
            .WithMany(o => o.Items)
            .HasForeignKey(i => i.OrderId)
            .WillCascadeOnDelete(false);

        modelBuilder.Entity<CfOrderHistory>()
            .HasRequired(h => h.Order)
            .WithMany(o => o.Histories)
            .HasForeignKey(h => h.OrderId)
            .WillCascadeOnDelete(false);

        modelBuilder.Entity<CfBrandShowcaseBanner>()
            .HasRequired(b => b.Showcase)
            .WithMany(s => s.Banners)
            .HasForeignKey(b => b.ShowcaseId)
            .WillCascadeOnDelete(false);

        modelBuilder.Entity<CfPostCategory>()
            .HasOptional(c => c.Parent)
            .WithMany(p => p.Children)
            .HasForeignKey(c => c.ParentId)
            .WillCascadeOnDelete(false);

        modelBuilder.Entity<CfSystemPage>()
            .HasOptional(p => p.StaticPage)
            .WithMany(s => s.SystemPages)
            .HasForeignKey(p => p.StaticPageId)
            .WillCascadeOnDelete(false);
    }
}
