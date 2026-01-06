using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;

public partial class AdminPermissionsDefault : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindRoles();
            BindPermissions();
            BindPermissionCatalog();
        }
    }

    protected void RoleSelect_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindPermissions();
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        FormMessage.Text = string.Empty;
        int roleId;
        if (!int.TryParse(RoleSelect.SelectedValue, out roleId) || roleId <= 0)
        {
            FormMessage.Text = "Vui lòng chọn role.";
            return;
        }

        var selectedPermissionIds = new List<int>();
        foreach (RepeaterItem item in PermissionRepeater.Items)
        {
            var check = (CheckBox)item.FindControl("PermissionCheck");
            var idField = (HiddenField)item.FindControl("PermissionId");
            int permissionId;
            if (check != null && check.Checked && int.TryParse(idField.Value, out permissionId))
            {
                selectedPermissionIds.Add(permissionId);
            }
        }

        using (var db = new BeautyStoryContext())
        {
            var existing = db.CfRolePermissions.Where(rp => rp.RoleId == roleId).ToList();
            foreach (var rp in existing)
            {
                db.CfRolePermissions.Remove(rp);
            }

            foreach (int permissionId in selectedPermissionIds)
            {
                var rp = new CfRolePermission
                {
                    RoleId = roleId,
                    PermissionId = permissionId,
                    Status = true,
                    CreatedAt = DateTime.UtcNow,
                    CreatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null,
                    SortOrder = 0
                };
                db.CfRolePermissions.Add(rp);
            }

            db.SaveChanges();
        }

        FormMessage.CssClass = "text-success small d-block mb-2";
        FormMessage.Text = "Lưu quyền thành công.";
        BindPermissions();
    }

    protected void ResetButton_Click(object sender, EventArgs e)
    {
        BindPermissions();
    }

    protected void PermissionSaveButton_Click(object sender, EventArgs e)
    {
        PermissionFormMessage.Text = string.Empty;

        string menuGroup = (MenuGroupInput.Text ?? string.Empty).Trim();
        string actionName = (ActionNameInput.Text ?? string.Empty).Trim();
        string permissionName = (PermissionNameInput.Text ?? string.Empty).Trim();
        string sortText = (PermissionSortOrderInput.Text ?? string.Empty).Trim();
        bool status = PermissionStatusInput.Checked;

        if (string.IsNullOrWhiteSpace(menuGroup) || string.IsNullOrWhiteSpace(actionName))
        {
            PermissionFormMessage.Text = "Vui lòng nhập Nhóm và Action.";
            return;
        }

        int sortOrder = 0;
        if (!string.IsNullOrWhiteSpace(sortText))
        {
            int.TryParse(sortText, out sortOrder);
        }

        int id;
        int.TryParse(PermissionEditId.Value, out id);

        using (var db = new BeautyStoryContext())
        {
            bool exists = db.CfPermissions.Any(p => p.MenuGroup == menuGroup && p.ActionName == actionName && p.Id != id);
            if (exists)
            {
                PermissionFormMessage.Text = "Quyền đã tồn tại.";
                return;
            }

            CfPermission permission;
            if (id > 0)
            {
                permission = db.CfPermissions.FirstOrDefault(p => p.Id == id);
                if (permission == null)
                {
                    PermissionFormMessage.Text = "Không tìm thấy quyền.";
                    return;
                }
            }
            else
            {
                permission = new CfPermission();
                permission.CreatedAt = DateTime.UtcNow;
                permission.CreatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
                db.CfPermissions.Add(permission);
            }

            permission.MenuGroup = menuGroup;
            permission.ActionName = actionName;
            permission.PermissionName = string.IsNullOrWhiteSpace(permissionName) ? null : permissionName;
            permission.SortOrder = sortOrder;
            permission.Status = status;
            permission.UpdatedAt = DateTime.UtcNow;
            permission.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;

            db.SaveChanges();
        }

        ResetPermissionForm();
        BindPermissionCatalog();
        BindPermissions();
        PermissionFormMessage.CssClass = "text-success small d-block mb-2";
        PermissionFormMessage.Text = "Lưu thành công.";
    }

    protected void PermissionResetButton_Click(object sender, EventArgs e)
    {
        ResetPermissionForm();
    }

    protected void PermissionCatalogRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int id;
        if (!int.TryParse(e.CommandArgument.ToString(), out id))
        {
            return;
        }

        if (e.CommandName == "EditPermission")
        {
            LoadPermissionToForm(id);
        }
        else if (e.CommandName == "DeletePermission")
        {
            DeletePermission(id);
            BindPermissionCatalog();
            BindPermissions();
        }
    }

    private void BindRoles()
    {
        RoleSelect.Items.Clear();
        RoleSelect.Items.Add(new ListItem("-- Chọn role --", "0"));
        using (var db = new BeautyStoryContext())
        {
            var roles = db.CfRoles.Where(r => r.Status)
                .OrderBy(r => r.SortOrder)
                .ThenBy(r => r.RoleName)
                .ToList();
            foreach (var role in roles)
            {
                RoleSelect.Items.Add(new ListItem(role.RoleName, role.Id.ToString()));
            }
        }
    }

    private void BindPermissions()
    {
        int roleId;
        int.TryParse(RoleSelect.SelectedValue, out roleId);

        using (var db = new BeautyStoryContext())
        {
            var permissions = db.CfPermissions
                .Where(p => p.Status)
                .OrderBy(p => p.MenuGroup)
                .ThenBy(p => p.ActionName)
                .ToList();

            var granted = new HashSet<int>();
            if (roleId > 0)
            {
                granted = new HashSet<int>(
                    db.CfRolePermissions.Where(rp => rp.RoleId == roleId && rp.Status)
                        .Select(rp => rp.PermissionId).ToList()
                );
            }

            var items = permissions.Select(p => new PermissionItem
            {
                Id = p.Id,
                MenuGroup = p.MenuGroup,
                ActionName = p.ActionName,
                PermissionName = p.PermissionName,
                IsGranted = granted.Contains(p.Id)
            }).ToList();

            PermissionRepeater.DataSource = items;
            PermissionRepeater.DataBind();
        }
    }

    private void BindPermissionCatalog()
    {
        using (var db = new BeautyStoryContext())
        {
            var permissions = db.CfPermissions
                .OrderBy(p => p.MenuGroup)
                .ThenBy(p => p.ActionName)
                .ToList();
            PermissionCatalogRepeater.DataSource = permissions;
            PermissionCatalogRepeater.DataBind();
        }
    }

    private void LoadPermissionToForm(int id)
    {
        using (var db = new BeautyStoryContext())
        {
            var permission = db.CfPermissions.FirstOrDefault(p => p.Id == id);
            if (permission == null)
            {
                return;
            }

            PermissionEditId.Value = permission.Id.ToString();
            MenuGroupInput.Text = permission.MenuGroup;
            ActionNameInput.Text = permission.ActionName;
            PermissionNameInput.Text = permission.PermissionName;
            PermissionSortOrderInput.Text = permission.SortOrder.ToString();
            PermissionStatusInput.Checked = permission.Status;
        }
    }

    private void DeletePermission(int id)
    {
        using (var db = new BeautyStoryContext())
        {
            var permission = db.CfPermissions.FirstOrDefault(p => p.Id == id);
            if (permission == null)
            {
                return;
            }

            bool usedByRoles = db.CfRolePermissions.Any(rp => rp.PermissionId == id);
            bool usedByMenus = db.CfMenuPermissions.Any(mp => mp.PermissionId == id);
            if (usedByRoles || usedByMenus)
            {
                PermissionFormMessage.Text = "Không thể xóa quyền đang được sử dụng.";
                return;
            }

            db.CfPermissions.Remove(permission);
            db.SaveChanges();
        }
    }

    private void ResetPermissionForm()
    {
        PermissionEditId.Value = string.Empty;
        MenuGroupInput.Text = string.Empty;
        ActionNameInput.Text = string.Empty;
        PermissionNameInput.Text = string.Empty;
        PermissionSortOrderInput.Text = "0";
        PermissionStatusInput.Checked = true;
        PermissionFormMessage.Text = string.Empty;
        PermissionFormMessage.CssClass = "text-danger small d-block mb-2";
    }

    private class PermissionItem
    {
        public int Id { get; set; }
        public string MenuGroup { get; set; }
        public string ActionName { get; set; }
        public string PermissionName { get; set; }
        public bool IsGranted { get; set; }
    }
}
