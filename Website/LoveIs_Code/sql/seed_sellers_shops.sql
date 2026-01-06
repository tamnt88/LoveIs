USE LoveIsDB;
GO
DECLARE @Now DATETIME = GETDATE();
INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller001', N'Noi y Elegance', N'seller001@loveis.local', N'090001001', 0x6e20b2126c0ef44d46a7317675609ee6d33ad1360a54b2d87b2fc47f41b9e4a8, 0x7c00f6de45e00fc42bb35d0e84b17659, 100000, 1, @Now, 1);
DECLARE @SellerId1 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId1, N'SHOP001', N'Noi y Elegance', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 1);
DECLARE @ShopId1 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId1, @SellerId1, N'Owner', 1, @Now, 1);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller002', N'Lace & Glow', N'seller002@loveis.local', N'090002002', 0x289f9290978953f3c07320c6283524cca9972d57ccde18d71822a7e13ca86727, 0xc30526de913412f081fd00a78b5d831d, 100000, 1, @Now, 2);
DECLARE @SellerId2 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId2, N'SHOP002', N'Lace & Glow', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 2);
DECLARE @ShopId2 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId2, @SellerId2, N'Owner', 1, @Now, 2);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller003', N'Silk Whisper', N'seller003@loveis.local', N'090003003', 0x668310a2306300557aedf0c0248841c89fc7d482159144c8cab4998b26a0dacc, 0xac2123258fb1c10ba6a48d6a2451915b, 100000, 1, @Now, 3);
DECLARE @SellerId3 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId3, N'SHOP003', N'Silk Whisper', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 3);
DECLARE @ShopId3 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId3, @SellerId3, N'Owner', 1, @Now, 3);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller004', N'Vanilla Lace', N'seller004@loveis.local', N'090004004', 0x3952ea4b19859ec40b72a0702a5e7f83be5cb40814b84da575863230662806ae, 0xe4ab385574019f6ef14de5d04343f3fb, 100000, 1, @Now, 4);
DECLARE @SellerId4 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId4, N'SHOP004', N'Vanilla Lace', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 4);
DECLARE @ShopId4 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId4, @SellerId4, N'Owner', 1, @Now, 4);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller005', N'Nude Bloom', N'seller005@loveis.local', N'090005005', 0x35e412afeb89a7e26088520581d1dc7da8421849bf61d7c26ff454d58d4cf61d, 0x783af7eeb41c77f0b90b78d68942fe79, 100000, 1, @Now, 5);
DECLARE @SellerId5 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId5, N'SHOP005', N'Nude Bloom', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 5);
DECLARE @ShopId5 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId5, @SellerId5, N'Owner', 1, @Now, 5);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller006', N'Rose Curve', N'seller006@loveis.local', N'090006006', 0xfa01e5049d47bfbc5d0823a408ddff42aa348dc339d123d56fa7d648e3600953, 0xc7d75ec574e9a1498301fc02d8032e12, 100000, 1, @Now, 6);
DECLARE @SellerId6 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId6, N'SHOP006', N'Rose Curve', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 6);
DECLARE @ShopId6 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId6, @SellerId6, N'Owner', 1, @Now, 6);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller007', N'Moonlit Intimates', N'seller007@loveis.local', N'090007007', 0x602f1d84c035f56a92226b4c4b0ab2ec962da738d39de0360bf224e5d45d6863, 0xe36a6d20b1a83fa8cb3312a2d5019eb9, 100000, 1, @Now, 7);
DECLARE @SellerId7 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId7, N'SHOP007', N'Moonlit Intimates', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 7);
DECLARE @ShopId7 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId7, @SellerId7, N'Owner', 1, @Now, 7);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller008', N'Velvet Kiss', N'seller008@loveis.local', N'090008008', 0x96412299c2a56f042ef32dee645e27c0705b92f5f2ddf34b541592c13b6f9c7d, 0x91bf91503b8109a3442d5c8f321a9dfa, 100000, 1, @Now, 8);
DECLARE @SellerId8 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId8, N'SHOP008', N'Velvet Kiss', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 8);
DECLARE @ShopId8 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId8, @SellerId8, N'Owner', 1, @Now, 8);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller009', N'Lotus Secret', N'seller009@loveis.local', N'090009009', 0x6af796ceacb21b0c42c25595c33797f4db0681200c938232a1054961e76a04d3, 0x0188d0f7604671c3de55240d42d58a7d, 100000, 1, @Now, 9);
DECLARE @SellerId9 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId9, N'SHOP009', N'Lotus Secret', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 9);
DECLARE @ShopId9 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId9, @SellerId9, N'Owner', 1, @Now, 9);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller010', N'Pearl Intimate', N'seller010@loveis.local', N'090010010', 0xb9b41c03c9a9b6b6c8b122d1fed3f97229ca31c19a5788bf5830959592c0eeac, 0xa90bd7b3558f14b20bacfef408033c0a, 100000, 1, @Now, 10);
DECLARE @SellerId10 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId10, N'SHOP010', N'Pearl Intimate', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 10);
DECLARE @ShopId10 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId10, @SellerId10, N'Owner', 1, @Now, 10);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller011', N'Soft Muse', N'seller011@loveis.local', N'090011011', 0x9dc1cadfb27068830d9702b1976c47674b588308383e926716b68e194f3d2af1, 0xe3d0b4113c19fe272fd0a7542cbc153e, 100000, 1, @Now, 11);
DECLARE @SellerId11 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId11, N'SHOP011', N'Soft Muse', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 11);
DECLARE @ShopId11 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId11, @SellerId11, N'Owner', 1, @Now, 11);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller012', N'Satin Bloom', N'seller012@loveis.local', N'090012012', 0x84a8954e16f8a529d1291a6edce63dec5255f6bf7b5b5b086380cab1bb61ba52, 0x1a1595f39151e8e40b729ca95111631c, 100000, 1, @Now, 12);
DECLARE @SellerId12 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId12, N'SHOP012', N'Satin Bloom', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 12);
DECLARE @ShopId12 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId12, @SellerId12, N'Owner', 1, @Now, 12);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller013', N'Ivory Curve', N'seller013@loveis.local', N'090013013', 0x786c2dd23dd8985d06c6e78519a4ba973c1602d454e8f83218e14cfd08557258, 0x65b9fa92a7157a5724f2017a72bb9e2a, 100000, 1, @Now, 13);
DECLARE @SellerId13 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId13, N'SHOP013', N'Ivory Curve', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 13);
DECLARE @ShopId13 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId13, @SellerId13, N'Owner', 1, @Now, 13);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller014', N'Midnight Lace', N'seller014@loveis.local', N'090014014', 0x607398d2d8e6657368fb6dd08ece589e574268f684dbc7f17b37325134e8543d, 0x0a766331081e0b3af7d36f28d89b4e43, 100000, 1, @Now, 14);
DECLARE @SellerId14 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId14, N'SHOP014', N'Midnight Lace', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 14);
DECLARE @ShopId14 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId14, @SellerId14, N'Owner', 1, @Now, 14);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller015', N'Petal Intimates', N'seller015@loveis.local', N'090015015', 0xb6c0125943a61dac8c2025ee4fae19399400ccd83d548fc55404ddadd2f578f8, 0x37aeb9f4e23915d103ce09f59491c7e0, 100000, 1, @Now, 15);
DECLARE @SellerId15 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId15, N'SHOP015', N'Petal Intimates', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 15);
DECLARE @ShopId15 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId15, @SellerId15, N'Owner', 1, @Now, 15);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller016', N'Belle Under', N'seller016@loveis.local', N'090016016', 0xa01108a7d723cc2a544f9c71148f3f94f69f2368a9f605266378d40a7e7a7182, 0xb824464790eb868cf2733b05d2ff78a4, 100000, 1, @Now, 16);
DECLARE @SellerId16 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId16, N'SHOP016', N'Belle Under', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 16);
DECLARE @ShopId16 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId16, @SellerId16, N'Owner', 1, @Now, 16);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller017', N'Luna Secret', N'seller017@loveis.local', N'090017017', 0x9d7aff663c2b3c06f170a5ab9d2ef9ced5d430648364bd55a1ef1d3fac445264, 0xc8b72575fa11a864aea7fd0d00fda6a0, 100000, 1, @Now, 17);
DECLARE @SellerId17 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId17, N'SHOP017', N'Luna Secret', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 17);
DECLARE @ShopId17 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId17, @SellerId17, N'Owner', 1, @Now, 17);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller018', N'Amber Lace', N'seller018@loveis.local', N'090018018', 0x86605df0249b5b51ca62957022cf19668918fb98df8e4d29b18f8538fdb8e687, 0xe2560e3c2474ee379c2085f4ec0befc9, 100000, 1, @Now, 18);
DECLARE @SellerId18 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId18, N'SHOP018', N'Amber Lace', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 18);
DECLARE @ShopId18 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId18, @SellerId18, N'Owner', 1, @Now, 18);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller019', N'Serene Silk', N'seller019@loveis.local', N'090019019', 0xa6a8ec4f5973a607e15dbe35d8658e0a5a5c0c6d0739a1b2a40cad395033de92, 0xa0e8c71a4f35f73bb7fac79b65a6f97f, 100000, 1, @Now, 19);
DECLARE @SellerId19 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId19, N'SHOP019', N'Serene Silk', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 19);
DECLARE @ShopId19 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId19, @SellerId19, N'Owner', 1, @Now, 19);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller020', N'Honey Glow', N'seller020@loveis.local', N'090020020', 0x9958f2a28853b243d65f7d8576840284f3ce1e393d07be8badc062225c6acbfc, 0xb10b22363d46d7e35911df9f2904abe5, 100000, 1, @Now, 20);
DECLARE @SellerId20 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId20, N'SHOP020', N'Honey Glow', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 20);
DECLARE @ShopId20 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId20, @SellerId20, N'Owner', 1, @Now, 20);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller021', N'Ruby Curve', N'seller021@loveis.local', N'090021021', 0x064002c67f5af34cca9a44a237a41da05ab57457e92b0f1b72e742a8b5ba6ad5, 0x0f80ff84a38c4250af5afd54043f4964, 100000, 1, @Now, 21);
DECLARE @SellerId21 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId21, N'SHOP021', N'Ruby Curve', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 21);
DECLARE @ShopId21 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId21, @SellerId21, N'Owner', 1, @Now, 21);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller022', N'Dream Lace', N'seller022@loveis.local', N'090022022', 0x445f648c0987a3d7023a2b29c8dc380248859d13a684f24939c5bf945cdc7292, 0xa8670a9495302f14e31945c15f64b1cf, 100000, 1, @Now, 22);
DECLARE @SellerId22 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId22, N'SHOP022', N'Dream Lace', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 22);
DECLARE @ShopId22 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId22, @SellerId22, N'Owner', 1, @Now, 22);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller023', N'Opal Under', N'seller023@loveis.local', N'090023023', 0xbe78419171e5dfd1c2c5254c917183ccb49e3f718495abeea1e3948a3b4870d7, 0x5f4d45d502f6c9bc19d73b112578ad95, 100000, 1, @Now, 23);
DECLARE @SellerId23 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId23, N'SHOP023', N'Opal Under', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 23);
DECLARE @ShopId23 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId23, @SellerId23, N'Owner', 1, @Now, 23);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller024', N'Radiant Silk', N'seller024@loveis.local', N'090024024', 0x82831ab42a64b6133db01be5b16c7948eec2bfd42337107ffac011f14ab727e0, 0x70c91f52523c2cbd0967bd681ac43d87, 100000, 1, @Now, 24);
DECLARE @SellerId24 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId24, N'SHOP024', N'Radiant Silk', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 24);
DECLARE @ShopId24 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId24, @SellerId24, N'Owner', 1, @Now, 24);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller025', N'Bloom Intimates', N'seller025@loveis.local', N'090025025', 0x4b5720c17209e581c8d90eee6973816c82e1b33c089942f68cad6df83aaab084, 0x9905f1abcaf76f9e92283d41e1fb94ad, 100000, 1, @Now, 25);
DECLARE @SellerId25 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId25, N'SHOP025', N'Bloom Intimates', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 25);
DECLARE @ShopId25 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId25, @SellerId25, N'Owner', 1, @Now, 25);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller026', N'Lily Whisper', N'seller026@loveis.local', N'090026026', 0x87f11eafcb4c6d030e218733517819b8f0c4607c42cc545ec91f5774cd205b67, 0xb3ed154b7d02d24135edd73f309285d9, 100000, 1, @Now, 26);
DECLARE @SellerId26 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId26, N'SHOP026', N'Lily Whisper', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 26);
DECLARE @ShopId26 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId26, @SellerId26, N'Owner', 1, @Now, 26);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller027', N'Dawn Lace', N'seller027@loveis.local', N'090027027', 0x8d8f0d5f7c87ec7e3314357d8de34a36a61e1a6bb8172cca91fb3af585c05739, 0x00a16bf732d5419facb322dec3950790, 100000, 1, @Now, 27);
DECLARE @SellerId27 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId27, N'SHOP027', N'Dawn Lace', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 27);
DECLARE @ShopId27 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId27, @SellerId27, N'Owner', 1, @Now, 27);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller028', N'Ivory Muse', N'seller028@loveis.local', N'090028028', 0x2a661509b035bf08a5a45eb7918384823fe4640d14b2777b99ac79b28b04304b, 0x8c6b5fd5e20821677d213b6b3ba0c657, 100000, 1, @Now, 28);
DECLARE @SellerId28 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId28, N'SHOP028', N'Ivory Muse', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 28);
DECLARE @ShopId28 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId28, @SellerId28, N'Owner', 1, @Now, 28);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller029', N'Clover Intimate', N'seller029@loveis.local', N'090029029', 0x77509877ec504aa4d737182f3bdecfdaf4d70477e83848307fb791bb57ac9b43, 0x493c7efca52e336ae2f411b2892b257e, 100000, 1, @Now, 29);
DECLARE @SellerId29 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId29, N'SHOP029', N'Clover Intimate', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 29);
DECLARE @ShopId29 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId29, @SellerId29, N'Owner', 1, @Now, 29);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller030', N'Eden Curve', N'seller030@loveis.local', N'090030030', 0xc9b18971ba5df6a5f63cc0a5ef0d9017c09939d8437b86c980fb0d296c26f060, 0x204401623c9407cef01dca1af7899508, 100000, 1, @Now, 30);
DECLARE @SellerId30 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId30, N'SHOP030', N'Eden Curve', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 30);
DECLARE @ShopId30 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId30, @SellerId30, N'Owner', 1, @Now, 30);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller031', N'Mist Lace', N'seller031@loveis.local', N'090031031', 0xb8befd21300d426accf67c0b7fb6175d455641f96113bccf0e7fa88a85aaa838, 0xc17949759fa9d237597d01ec833307c3, 100000, 1, @Now, 31);
DECLARE @SellerId31 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId31, N'SHOP031', N'Mist Lace', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 31);
DECLARE @ShopId31 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId31, @SellerId31, N'Owner', 1, @Now, 31);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller032', N'Grace Under', N'seller032@loveis.local', N'090032032', 0xf485fbdf98732f92ab7d6e7b0a1160912c186e0961196d508174cb0ccdd539a2, 0x05983e6244715bafbed92882f872d3a7, 100000, 1, @Now, 32);
DECLARE @SellerId32 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId32, N'SHOP032', N'Grace Under', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 32);
DECLARE @ShopId32 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId32, @SellerId32, N'Owner', 1, @Now, 32);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller033', N'Velour Secret', N'seller033@loveis.local', N'090033033', 0x645b00cce6b0886f4cbb201daf01ff35b7f54fbd2e241298c77416a79a39cdad, 0x69e5a235f6e284dd26d25a545dfd659a, 100000, 1, @Now, 33);
DECLARE @SellerId33 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId33, N'SHOP033', N'Velour Secret', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 33);
DECLARE @ShopId33 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId33, @SellerId33, N'Owner', 1, @Now, 33);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller034', N'Sunny Silk', N'seller034@loveis.local', N'090034034', 0xf1fc8d8764fe37ef8ea8d73fede1855ff1682129505c7a6cabf7b9fdb9025577, 0xc7daa15b8ac2818619b29d061f9837b5, 100000, 1, @Now, 34);
DECLARE @SellerId34 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId34, N'SHOP034', N'Sunny Silk', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 34);
DECLARE @ShopId34 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId34, @SellerId34, N'Owner', 1, @Now, 34);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller035', N'Aura Lace', N'seller035@loveis.local', N'090035035', 0xd393a56f37ea889cd6dae098b048e4b4b975d94c062baef71bfc9febd81d2d2a, 0x67d03b4be936e471226613f787735ce4, 100000, 1, @Now, 35);
DECLARE @SellerId35 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId35, N'SHOP035', N'Aura Lace', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 35);
DECLARE @ShopId35 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId35, @SellerId35, N'Owner', 1, @Now, 35);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller036', N'Muse Intimates', N'seller036@loveis.local', N'090036036', 0xf734414cdf89e438cfaabc53f92549364f9703c6701df3d4c7f7e4a81169f291, 0xee7d7d7c902f69b5c4460d815069b157, 100000, 1, @Now, 36);
DECLARE @SellerId36 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId36, N'SHOP036', N'Muse Intimates', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 36);
DECLARE @ShopId36 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId36, @SellerId36, N'Owner', 1, @Now, 36);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller037', N'Rosy Curve', N'seller037@loveis.local', N'090037037', 0x18e4a893d64158e2b7eb45be47cc5ae8ab3064277301bc4e8287644d050ca274, 0x8c2be6e8f9680935ddd7692c67a2333a, 100000, 1, @Now, 37);
DECLARE @SellerId37 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId37, N'SHOP037', N'Rosy Curve', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 37);
DECLARE @ShopId37 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId37, @SellerId37, N'Owner', 1, @Now, 37);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller038', N'Petite Lace', N'seller038@loveis.local', N'090038038', 0xfeb4d71a4e8faf28918fbdaba898dc91afe8ff41777c039dc4b80bae0c08c3fa, 0xde409e5a7c45b555a1aa47c1c9a1e62d, 100000, 1, @Now, 38);
DECLARE @SellerId38 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId38, N'SHOP038', N'Petite Lace', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 38);
DECLARE @ShopId38 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId38, @SellerId38, N'Owner', 1, @Now, 38);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller039', N'Feather Silk', N'seller039@loveis.local', N'090039039', 0x6a14f2142f38e2d06e460eba6e04c361716068c85aa540675f8fc28c6d2973c5, 0x7ee90cee85e2453c4b6009521f702d33, 100000, 1, @Now, 39);
DECLARE @SellerId39 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId39, N'SHOP039', N'Feather Silk', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 39);
DECLARE @ShopId39 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId39, @SellerId39, N'Owner', 1, @Now, 39);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller040', N'Glow Under', N'seller040@loveis.local', N'090040040', 0x7c5e0178031c36f5062aab66b25d416b2674f04cbf397b9cdc07da31300e6a75, 0x5b0e850e1f3c21c4fa8992fdb1d022ea, 100000, 1, @Now, 40);
DECLARE @SellerId40 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId40, N'SHOP040', N'Glow Under', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 40);
DECLARE @ShopId40 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId40, @SellerId40, N'Owner', 1, @Now, 40);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller041', N'Pearl Muse', N'seller041@loveis.local', N'090041041', 0xa8faf83df322a6d2549216b3a2acf1e3dff50612ebeeb71768e865dc85889632, 0x22c4ae2854f958995f0f4d4c149a19ec, 100000, 1, @Now, 41);
DECLARE @SellerId41 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId41, N'SHOP041', N'Pearl Muse', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 41);
DECLARE @ShopId41 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId41, @SellerId41, N'Owner', 1, @Now, 41);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller042', N'Chic Lace', N'seller042@loveis.local', N'090042042', 0xb5ad4c425228e4b5bc01f9db69dafe34d5813598d79730b4106c7197bd846b2c, 0xacac8e240b86c9b84b7fdf5b5735c94e, 100000, 1, @Now, 42);
DECLARE @SellerId42 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId42, N'SHOP042', N'Chic Lace', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 42);
DECLARE @ShopId42 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId42, @SellerId42, N'Owner', 1, @Now, 42);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller043', N'Noir Bloom', N'seller043@loveis.local', N'090043043', 0xf77df14f96155c74b5c75b1344cdc575b6a946d66349e0aaeba266abcd7e6297, 0xfb337ef9abb11017f042eedf7d936b14, 100000, 1, @Now, 43);
DECLARE @SellerId43 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId43, N'SHOP043', N'Noir Bloom', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 43);
DECLARE @ShopId43 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId43, @SellerId43, N'Owner', 1, @Now, 43);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller044', N'Golden Curve', N'seller044@loveis.local', N'090044044', 0x10a8d522761ef17780892ae42a74c49b08b35b583de80c80d35863bceb7fbaa8, 0x9d8ae8704076f9e1c2d8a80c35ab0e8c, 100000, 1, @Now, 44);
DECLARE @SellerId44 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId44, N'SHOP044', N'Golden Curve', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 44);
DECLARE @ShopId44 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId44, @SellerId44, N'Owner', 1, @Now, 44);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller045', N'Swan Intimates', N'seller045@loveis.local', N'090045045', 0x8168fb397f9c77e9d4419526254ccd40a4f4e753ca7a41aedf4deeb9b13ca601, 0x096bb04bd3bf58b87ff6b04394131c55, 100000, 1, @Now, 45);
DECLARE @SellerId45 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId45, N'SHOP045', N'Swan Intimates', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 45);
DECLARE @ShopId45 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId45, @SellerId45, N'Owner', 1, @Now, 45);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller046', N'Cloud Lace', N'seller046@loveis.local', N'090046046', 0x1b3f4db0ea6fa277ffed46a94c6a4fd2d6f96ba742c6a79dbf7f279921d43dda, 0x5261b7de9f3dbb3df7c2fc6b4ab8a544, 100000, 1, @Now, 46);
DECLARE @SellerId46 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId46, N'SHOP046', N'Cloud Lace', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 46);
DECLARE @ShopId46 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId46, @SellerId46, N'Owner', 1, @Now, 46);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller047', N'Softline', N'seller047@loveis.local', N'090047047', 0x3e61c36197423529f0953823bdf480a5928d3ac4734c6108708dcd737c018bd0, 0x67c74ca9f955bb72c41ec2eba6d8cfc8, 100000, 1, @Now, 47);
DECLARE @SellerId47 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId47, N'SHOP047', N'Softline', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 47);
DECLARE @ShopId47 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId47, @SellerId47, N'Owner', 1, @Now, 47);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller048', N'Aria Intimates', N'seller048@loveis.local', N'090048048', 0x48675ed3781cbc9ad40e26440d55e2436fddca423ec478be960fc5c60c8e5cbf, 0x085910540e7217b363ecb4d6a92d671f, 100000, 1, @Now, 48);
DECLARE @SellerId48 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId48, N'SHOP048', N'Aria Intimates', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 48);
DECLARE @ShopId48 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId48, @SellerId48, N'Owner', 1, @Now, 48);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller049', N'Vivid Lace', N'seller049@loveis.local', N'090049049', 0x1aeec9c7c7516f7e67f9e389945d64845a4a26ecce95ef21a752e9aca1055450, 0xedb835868f98dc0c76c5606f7d8ec7b6, 100000, 1, @Now, 49);
DECLARE @SellerId49 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId49, N'SHOP049', N'Vivid Lace', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 49);
DECLARE @ShopId49 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId49, @SellerId49, N'Owner', 1, @Now, 49);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller050', N'Eve Under', N'seller050@loveis.local', N'090050050', 0xee59cfac02944114a769ff1cbc6353b6ab199fcacf5492dd99df86fb8b1d6ec9, 0xdc40703ed211e0b2a5d5d6e262f0a387, 100000, 1, @Now, 50);
DECLARE @SellerId50 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId50, N'SHOP050', N'Eve Under', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 50);
DECLARE @ShopId50 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId50, @SellerId50, N'Owner', 1, @Now, 50);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller051', N'Charm Silk', N'seller051@loveis.local', N'090051051', 0xfbe0024729fae99f57a5b0900b22e26ba759f07138b8b42eb67f2577f513b483, 0x1b83b384a1015b57720dccea6f051faf, 100000, 1, @Now, 51);
DECLARE @SellerId51 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId51, N'SHOP051', N'Charm Silk', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 51);
DECLARE @ShopId51 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId51, @SellerId51, N'Owner', 1, @Now, 51);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller052', N'Luxe Lace', N'seller052@loveis.local', N'090052052', 0xe0d66e6cdf32b1ebcdd252a1471eda2c7db2e000aa469e7cc2a5596b39bf456c, 0xb5fb3be5b42da5af4e20a54a2440baa0, 100000, 1, @Now, 52);
DECLARE @SellerId52 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId52, N'SHOP052', N'Luxe Lace', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 52);
DECLARE @ShopId52 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId52, @SellerId52, N'Owner', 1, @Now, 52);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller053', N'Ivory Secret', N'seller053@loveis.local', N'090053053', 0xbba80a38ded139623090004efb3c71db1ba4fa2db040263bc8bb3a4e2c5d55ce, 0xf112ca6ad7553c3b7600d2f5507ef732, 100000, 1, @Now, 53);
DECLARE @SellerId53 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId53, N'SHOP053', N'Ivory Secret', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 53);
DECLARE @ShopId53 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId53, @SellerId53, N'Owner', 1, @Now, 53);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller054', N'Pure Curve', N'seller054@loveis.local', N'090054054', 0x5444b28035857f52aec3f57f41617be8073e2d40848e28de5712608e7f1119cb, 0x3944ca2248c081cefc331715304d5b06, 100000, 1, @Now, 54);
DECLARE @SellerId54 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId54, N'SHOP054', N'Pure Curve', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 54);
DECLARE @ShopId54 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId54, @SellerId54, N'Owner', 1, @Now, 54);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller055', N'Gentle Bloom', N'seller055@loveis.local', N'090055055', 0x87c1ecf25add4c7bf12aaef004f070e056625eaf5092c8000c3213c43ea9de63, 0x229301485f4e2d62757c0b26346d7581, 100000, 1, @Now, 55);
DECLARE @SellerId55 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId55, N'SHOP055', N'Gentle Bloom', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 55);
DECLARE @ShopId55 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId55, @SellerId55, N'Owner', 1, @Now, 55);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller056', N'Sage Intimates', N'seller056@loveis.local', N'090056056', 0x803bf0f73154e09cdee7031eb211297ad1ade64beb0fa603dc44ec89266aa5fd, 0x70e0fb4654b5cdc7302a205f583694a3, 100000, 1, @Now, 56);
DECLARE @SellerId56 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId56, N'SHOP056', N'Sage Intimates', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 56);
DECLARE @ShopId56 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId56, @SellerId56, N'Owner', 1, @Now, 56);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller057', N'Tide Lace', N'seller057@loveis.local', N'090057057', 0x28a31217e4990e683a07fd7ad9174d44b501966239984626a8145494f6f6954a, 0x589123c63041637c62cb5ddc6f9717dc, 100000, 1, @Now, 57);
DECLARE @SellerId57 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId57, N'SHOP057', N'Tide Lace', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 57);
DECLARE @ShopId57 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId57, @SellerId57, N'Owner', 1, @Now, 57);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller058', N'Halo Under', N'seller058@loveis.local', N'090058058', 0xad48d65ec7fcb74fae8d00c3c03a646b7e34febaa5aec2b98cdfe0d79aed56c1, 0x30801a6102149e85b2dede3d73acc6b4, 100000, 1, @Now, 58);
DECLARE @SellerId58 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId58, N'SHOP058', N'Halo Under', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 58);
DECLARE @ShopId58 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId58, @SellerId58, N'Owner', 1, @Now, 58);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller059', N'Shine Silk', N'seller059@loveis.local', N'090059059', 0x0c705244600e53c763690ac369d928b468971e35fb0b3c9200429f78a3c45445, 0xe4c958c4b30cbd2bb98116a556bd618f, 100000, 1, @Now, 59);
DECLARE @SellerId59 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId59, N'SHOP059', N'Shine Silk', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 59);
DECLARE @ShopId59 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId59, @SellerId59, N'Owner', 1, @Now, 59);

INSERT INTO dbo.cf_seller (Username, DisplayName, Email, Phone, PasswordHash, PasswordSalt, PasswordIterations, Status, CreatedAt, SortOrder)
VALUES (N'seller060', N'Dream Curve', N'seller060@loveis.local', N'090060060', 0x6e645cd86e21f5934c8ba37d89e8f46a88eefcc39855354c4bf8ff7acf47fbb9, 0x5bd0ce39e778d8708c9396c76de67560, 100000, 1, @Now, 60);
DECLARE @SellerId60 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop (SellerId, ShopCode, ShopName, Description, AddressLine, WardName, ProvinceName, Status, CreatedAt, SortOrder)
VALUES (@SellerId60, N'SHOP060', N'Dream Curve', N'Shop noi y dep va tinh te', N'Thanh pho Ho Chi Minh', N'Thanh pho Thu Duc', N'Ho Chi Minh', N'Active', @Now, 60);
DECLARE @ShopId60 INT = SCOPE_IDENTITY();
INSERT INTO dbo.cf_shop_user (ShopId, SellerId, UserRole, Status, CreatedAt, SortOrder)
VALUES (@ShopId60, @SellerId60, N'Owner', 1, @Now, 60);

;WITH Shops AS (
    SELECT Id, ROW_NUMBER() OVER (ORDER BY Id) AS rn
    FROM dbo.cf_shop
), Products AS (
    SELECT Id, ROW_NUMBER() OVER (ORDER BY Id) AS rn
    FROM dbo.cf_product
)
UPDATE p
SET ShopId = s.Id
FROM dbo.cf_product p
JOIN Products pr ON pr.Id = p.Id
JOIN Shops s ON ((pr.rn - 1) % (SELECT COUNT(*) FROM dbo.cf_shop)) + 1 = s.rn;

