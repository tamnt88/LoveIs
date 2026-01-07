USE LoveIsDB;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_cf_product_Status_Category' AND object_id = OBJECT_ID('dbo.cf_product'))
BEGIN
    CREATE INDEX IX_cf_product_Status_Category
    ON dbo.cf_product (Status, CategoryId)
    INCLUDE (Id, ProductName, SortOrder, IsBestSelling, IsTrending, IsNewArrival);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_cf_product_Status_Brand' AND object_id = OBJECT_ID('dbo.cf_product'))
BEGIN
    CREATE INDEX IX_cf_product_Status_Brand
    ON dbo.cf_product (Status, BrandId)
    INCLUDE (Id, ProductName, SortOrder);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_cf_product_Status_Origin' AND object_id = OBJECT_ID('dbo.cf_product'))
BEGIN
    CREATE INDEX IX_cf_product_Status_Origin
    ON dbo.cf_product (Status, OriginId)
    INCLUDE (Id, ProductName, SortOrder);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_cf_product_Status_ProductName' AND object_id = OBJECT_ID('dbo.cf_product'))
BEGIN
    CREATE INDEX IX_cf_product_Status_ProductName
    ON dbo.cf_product (Status, ProductName)
    INCLUDE (Id);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_cf_product_variant_Product_Status' AND object_id = OBJECT_ID('dbo.cf_product_variant'))
BEGIN
    CREATE INDEX IX_cf_product_variant_Product_Status
    ON dbo.cf_product_variant (ProductId, Status)
    INCLUDE (Id, Price, SalePrice, SortOrder);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_cf_product_image_Product_Status' AND object_id = OBJECT_ID('dbo.cf_product_image'))
BEGIN
    CREATE INDEX IX_cf_product_image_Product_Status
    ON dbo.cf_product_image (ProductId, Status)
    INCLUDE (ImageUrl, IsPrimary, SortOrder);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_cf_category_filter_group_Category' AND object_id = OBJECT_ID('dbo.cf_category_filter_group'))
BEGIN
    CREATE INDEX IX_cf_category_filter_group_Category
    ON dbo.cf_category_filter_group (CategoryId)
    INCLUDE (GroupId);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_cf_filter_group_Status' AND object_id = OBJECT_ID('dbo.cf_filter_group'))
BEGIN
    CREATE INDEX IX_cf_filter_group_Status
    ON dbo.cf_filter_group (Status, SortOrder)
    INCLUDE (Id, GroupName);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_cf_filter_option_Group_Status' AND object_id = OBJECT_ID('dbo.cf_filter_option'))
BEGIN
    CREATE INDEX IX_cf_filter_option_Group_Status
    ON dbo.cf_filter_option (GroupId, Status, SortOrder)
    INCLUDE (Id, OptionName);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_cf_product_variant_attribute_Variant' AND object_id = OBJECT_ID('dbo.cf_product_variant_attribute'))
BEGIN
    CREATE INDEX IX_cf_product_variant_attribute_Variant
    ON dbo.cf_product_variant_attribute (VariantId)
    INCLUDE (AttributeId, AttributeValueId);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_cf_product_variant_attribute_Attribute' AND object_id = OBJECT_ID('dbo.cf_product_variant_attribute'))
BEGIN
    CREATE INDEX IX_cf_product_variant_attribute_Attribute
    ON dbo.cf_product_variant_attribute (AttributeId)
    INCLUDE (VariantId, AttributeValueId);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_cf_category_Status_Parent' AND object_id = OBJECT_ID('dbo.cf_category'))
BEGIN
    CREATE INDEX IX_cf_category_Status_Parent
    ON dbo.cf_category (Status, ParentId)
    INCLUDE (Id, CategoryName, SortOrder);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_cf_seo_slug_Entity' AND object_id = OBJECT_ID('dbo.cf_seo_slug'))
BEGIN
    CREATE INDEX IX_cf_seo_slug_Entity
    ON dbo.cf_seo_slug (EntityType, EntityId)
    INCLUDE (SeoSlug);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_cf_community_notification_Customer' AND object_id = OBJECT_ID('dbo.cf_community_notification'))
BEGIN
    CREATE INDEX IX_cf_community_notification_Customer
    ON dbo.cf_community_notification (CustomerId, IsRead, CreatedAt DESC);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_cf_community_message_Room_Status' AND object_id = OBJECT_ID('dbo.cf_community_message'))
BEGIN
    CREATE INDEX IX_cf_community_message_Room_Status
    ON dbo.cf_community_message (RoomId, Status, CreatedAt DESC)
    INCLUDE (SenderId);
END
GO
