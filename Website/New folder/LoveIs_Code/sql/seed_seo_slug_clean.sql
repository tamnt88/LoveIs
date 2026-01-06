-- Rebuild SEO slugs without diacritics (UTF-8)
USE BeautyStoryDB;
GO

DELETE FROM dbo.cf_seo_slug WHERE EntityType IN (N'Category', N'Brand', N'Origin', N'Product');

INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 167, N'cham-soc-da-167', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 168, N'sua-rua-mat-168', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 169, N'tay-trang-169', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 170, N'toner-nuoc-can-bang-170', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 171, N'serum-171', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 172, N'kem-duong-172', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 173, N'mat-na-173', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 174, N'tay-te-bao-chet-174', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 175, N'duong-mat-175', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 176, N'trang-iem-176', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 177, N'kem-nen-177', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 178, N'phan-phu-178', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 179, N'son-moi-179', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 180, N'ke-mat-180', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 181, N'mascara-181', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 182, N'ma-hong-182', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 183, N'che-khuyet-iem-183', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 184, N'co-trang-iem-184', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 185, N'cham-soc-toc-185', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 186, N'dau-goi-186', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 187, N'dau-xa-187', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 188, N'u-toc-188', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 189, N'tinh-dau-duong-toc-189', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 190, N'xit-duong-190', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 191, N'tao-kieu-191', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 192, N'serum-toc-192', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 193, N'nhuom-toc-193', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 194, N'cham-soc-co-the-194', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 195, N'sua-tam-195', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 196, N'tay-te-bao-chet-body-196', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 197, N'duong-the-197', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 198, N'khu-mui-198', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 199, N'cham-soc-tay-199', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 200, N'cham-soc-chan-200', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 201, N'duong-moi-201', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 202, N'chong-nut-got-202', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 203, N'chong-nang-203', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 204, N'kem-chong-nang-204', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 205, N'sua-chong-nang-205', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 206, N'xit-chong-nang-206', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 207, N'chong-nang-body-207', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 208, N'chong-nang-nang-tong-208', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 209, N'nuoc-hoa-209', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 210, N'nuoc-hoa-nu-210', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 211, N'nuoc-hoa-nam-211', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 212, N'nuoc-hoa-unisex-212', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 213, N'xit-thom-body-213', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 214, N'set-qua-nuoc-hoa-214', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 215, N'duoc-my-pham-215', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 216, N'tri-mun-216', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 217, N'phuc-hoi-da-217', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 218, N'giam-kich-ung-218', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 219, N'lam-sang-da-219', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 220, N'duong-am-sau-220', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 221, N'cham-soc-nam-221', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 222, N'sua-rua-mat-nam-222', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 223, N'kem-duong-nam-223', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 224, N'tao-kieu-toc-nam-224', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 225, N'lan-khu-mui-nam-225', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 226, N'nuoc-hoa-nam-226', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 227, N'me-be-227', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 228, N'tam-goi-cho-be-228', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 229, N'duong-da-cho-be-229', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 230, N'chong-ham-230', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 231, N'cham-soc-me-bau-231', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 232, N'khan-uot-232', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 233, N'thiet-bi-lam-ep-233', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 234, N'may-rua-mat-234', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 235, N'may-ay-tinh-chat-235', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 236, N'may-massage-236', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 237, N'may-triet-long-237', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 238, N'may-say-toc-238', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 239, N'may-uon-toc-239', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 240, N'thuc-pham-bo-sung-240', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 241, N'collagen-241', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 242, N'vitamin-tong-hop-242', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 243, N'vien-uong-ep-da-243', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 244, N'ho-tro-toc-mong-244', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 245, N'ho-tro-giac-ngu-245', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 246, N'qua-tang-set-246', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 247, N'set-duong-da-247', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 248, N'set-trang-iem-248', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 249, N'set-cham-soc-toc-249', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 250, N'set-co-the-250', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Category', 251, N'set-mini-travel-251', 1, GETDATE(), N'Seed', 0);

INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Brand', 44, N'l-oreal-44', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Brand', 45, N'maybelline-45', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Brand', 46, N'innisfree-46', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Brand', 47, N'the-face-shop-47', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Brand', 48, N'laneige-48', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Brand', 49, N'la-roche-posay-49', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Brand', 50, N'vichy-50', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Brand', 51, N'eucerin-51', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Brand', 52, N'bioderma-52', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Brand', 53, N'hada-labo-53', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Brand', 54, N'some-by-mi-54', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Brand', 55, N'anessa-55', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Brand', 56, N'shiseido-56', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Brand', 57, N'sk-ii-57', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Brand', 58, N'kiehl-s-58', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Brand', 59, N'paula-s-choice-59', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Brand', 60, N'neutrogena-60', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Brand', 61, N'cetaphil-61', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Brand', 62, N'simple-62', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Brand', 63, N'the-ordinary-63', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Brand', 64, N'mac-64', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Brand', 65, N'clinique-65', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Brand', 66, N'dior-66', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Brand', 67, N'chanel-67', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Brand', 68, N'nivea-68', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Brand', 69, N'senka-69', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Brand', 70, N'cosrx-70', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Brand', 71, N'nature-republic-71', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Brand', 72, N'garnier-72', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Brand', 73, N'cerave-73', 1, GETDATE(), N'Seed', 0);

INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Origin', 18, N'han-quoc-18', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Origin', 19, N'nhat-ban-19', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Origin', 20, N'phap-20', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Origin', 21, N'my-21', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Origin', 22, N'uc-22', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Origin', 23, N'thai-lan-23', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Origin', 24, N'trung-quoc-24', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Origin', 25, N'anh-25', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Origin', 26, N'uc-26', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Origin', 27, N'y-27', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Origin', 28, N'canada-28', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Origin', 29, N'tay-ban-nha-29', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Origin', 30, N'thuy-si-30', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Origin', 31, N'ha-lan-31', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Origin', 32, N'viet-nam-32', 1, GETDATE(), N'Seed', 0);

INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 231, N'sua-rua-mat-diu-nhe-231', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 232, N'gel-rua-mat-kiem-dau-232', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 233, N'nuoc-tay-trang-micellar-233', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 234, N'toner-can-bang-da-234', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 235, N'serum-vitamin-c-sang-da-235', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 236, N'serum-phuc-hoi-da-236', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 237, N'kem-duong-am-ban-em-237', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 238, N'mat-na-duong-am-238', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 239, N'tay-te-bao-chet-diu-nhe-239', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 240, N'kem-duong-mat-giam-tham-240', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 241, N'kem-nen-lau-troi-241', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 242, N'phan-phu-kiem-dau-242', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 243, N'son-kem-li-243', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 244, N'mascara-day-mi-244', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 245, N'but-ke-mat-chong-nuoc-245', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 246, N'ma-hong-dang-kem-246', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 247, N'che-khuyet-iem-a-nang-247', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 248, N'bo-co-trang-iem-co-ban-248', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 249, N'dau-goi-phuc-hoi-toc-249', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 250, N'dau-xa-suon-muot-250', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 251, N'u-toc-keratin-251', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 252, N'tinh-dau-duong-toc-252', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 253, N'xit-duong-toc-mem-muot-253', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 254, N'gel-tao-kieu-254', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 255, N'serum-toc-bong-khoe-255', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 256, N'mau-nhuom-toc-tai-nha-256', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 257, N'sua-tam-huong-hoa-257', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 258, N'tay-te-bao-chet-body-258', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 259, N'kem-duong-the-trang-da-259', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 260, N'lan-khu-mui-260', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 261, N'kem-duong-da-tay-261', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 262, N'kem-duong-got-chan-262', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 263, N'son-duong-moi-263', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 264, N'kem-chong-nut-got-264', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 265, N'kem-chong-nang-spf50-265', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 266, N'sua-chong-nang-diu-nhe-266', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 267, N'xit-chong-nang-tien-loi-267', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 268, N'chong-nang-body-268', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 269, N'chong-nang-nang-tong-269', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 270, N'nuoc-hoa-nu-thanh-lich-270', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 271, N'nuoc-hoa-nam-manh-me-271', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 272, N'nuoc-hoa-unisex-272', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 273, N'xit-thom-body-273', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 274, N'set-qua-nuoc-hoa-274', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 275, N'kem-tri-mun-275', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 276, N'kem-phuc-hoi-da-276', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 277, N'serum-giam-kich-ung-277', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 278, N'tinh-chat-lam-sang-da-278', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 279, N'kem-duong-am-sau-279', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 280, N'sua-rua-mat-nam-280', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 281, N'kem-duong-nam-281', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 282, N'sap-tao-kieu-toc-nam-282', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 283, N'lan-khu-mui-nam-283', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 284, N'nuoc-hoa-nam-ca-tinh-284', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 285, N'sua-tam-goi-cho-be-285', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 286, N'kem-duong-da-cho-be-286', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 287, N'kem-chong-ham-287', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 288, N'kem-cham-soc-me-bau-288', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 289, N'khan-uot-diu-nhe-289', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 290, N'may-rua-mat-mini-290', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 291, N'may-ay-tinh-chat-291', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 292, N'may-massage-mat-292', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 293, N'may-triet-long-293', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 294, N'may-say-toc-294', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 295, N'may-uon-toc-295', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 296, N'vien-uong-collagen-296', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 297, N'vitamin-tong-hop-297', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 298, N'vien-uong-ep-da-298', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 299, N'vien-ho-tro-toc-mong-299', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 300, N'vien-ho-tro-giac-ngu-300', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 301, N'set-duong-da-co-ban-301', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 302, N'set-trang-iem-co-ban-302', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 303, N'set-cham-soc-toc-303', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 304, N'set-cham-soc-co-the-304', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 305, N'set-mini-travel-305', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 306, N'tinh-chat-duong-am-1-306', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 307, N'tinh-chat-duong-am-2-307', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 308, N'tinh-chat-duong-am-3-308', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 309, N'tinh-chat-duong-am-4-309', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 310, N'tinh-chat-duong-am-5-310', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 311, N'tinh-chat-duong-am-6-311', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 312, N'tinh-chat-duong-am-7-312', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 313, N'tinh-chat-duong-am-8-313', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 314, N'tinh-chat-duong-am-9-314', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 315, N'tinh-chat-phuc-hoi-10-315', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 316, N'tinh-chat-phuc-hoi-11-316', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 317, N'tinh-chat-phuc-hoi-12-317', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 318, N'tinh-chat-phuc-hoi-13-318', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 319, N'tinh-chat-phuc-hoi-14-319', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 320, N'tinh-chat-phuc-hoi-15-320', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 321, N'tinh-chat-phuc-hoi-16-321', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 322, N'tinh-chat-phuc-hoi-17-322', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 323, N'tinh-chat-phuc-hoi-18-323', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 324, N'kem-duong-ban-ngay-19-324', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 325, N'kem-duong-ban-ngay-20-325', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 326, N'kem-duong-ban-ngay-21-326', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 327, N'kem-duong-ban-ngay-22-327', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 328, N'kem-duong-ban-ngay-23-328', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 329, N'kem-duong-ban-ngay-24-329', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 330, N'kem-duong-ban-ngay-25-330', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 331, N'kem-duong-ban-ngay-26-331', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 332, N'kem-duong-ban-ngay-27-332', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 333, N'kem-duong-ban-em-28-333', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 334, N'kem-duong-ban-em-29-334', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 335, N'kem-duong-ban-em-30-335', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 336, N'kem-duong-ban-em-31-336', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 337, N'kem-duong-ban-em-32-337', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 338, N'kem-duong-ban-em-33-338', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 339, N'kem-duong-ban-em-34-339', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 340, N'kem-duong-ban-em-35-340', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 341, N'kem-duong-ban-em-36-341', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 342, N'gel-tay-te-bao-chet-37-342', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 343, N'gel-tay-te-bao-chet-38-343', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 344, N'gel-tay-te-bao-chet-39-344', 1, GETDATE(), N'Seed', 0);
INSERT INTO dbo.cf_seo_slug (EntityType, EntityId, SeoSlug, Status, CreatedAt, CreatedBy, SortOrder)
VALUES (N'Product', 345, N'gel-tay-te-bao-chet-40-345', 1, GETDATE(), N'Seed', 0);
