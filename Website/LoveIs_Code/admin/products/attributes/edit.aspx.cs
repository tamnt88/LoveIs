using System;
using System.Linq;

public partial class AdminProductAttributesEdit : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            int id;
            if (int.TryParse(Request.QueryString["id"], out id) && id > 0)
            {
                LoadAttributeToForm(id);
            }

            BindValues();
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        FormMessage.Text = string.Empty;

        string name = (AttributeNameInput.Text ?? string.Empty).Trim();
        string description = (DescriptionInput.Text ?? string.Empty).Trim();
        string sortText = (SortOrderInput.Text ?? string.Empty).Trim();
        bool status = StatusInput.Checked;

        if (string.IsNullOrWhiteSpace(name))
        {
            FormMessage.Text = "Vui lòng nhập tên thuộc tính.";
            return;
        }

        int sortOrder = 0;
        if (!string.IsNullOrWhiteSpace(sortText))
        {
            int.TryParse(sortText, out sortOrder);
        }

        using (var db = new BeautyStoryContext())
        {
            CfVariantAttribute attribute;
            int id;
            if (int.TryParse(AttributeId.Value, out id) && id > 0)
            {
                attribute = db.CfVariantAttributes.FirstOrDefault(a => a.Id == id);
                if (attribute == null)
                {
                    FormMessage.Text = "Thuộc tính không tồn tại.";
                    return;
                }
            }
            else
            {
                attribute = new CfVariantAttribute();
                attribute.CreatedAt = DateTime.UtcNow;
                attribute.CreatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
                db.CfVariantAttributes.Add(attribute);
            }

            attribute.AttributeName = name;
            attribute.Description = string.IsNullOrWhiteSpace(description) ? null : description;
            attribute.SortOrder = sortOrder;
            attribute.Status = status;
            attribute.UpdatedAt = DateTime.UtcNow;
            attribute.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
            db.SaveChanges();

            AttributeId.Value = attribute.Id.ToString();
        }

        FormMessage.CssClass = "text-success small d-block mb-2";
        FormMessage.Text = "Lưu thành công.";
        BindValues();
    }

    protected void ResetButton_Click(object sender, EventArgs e)
    {
        ResetForm();
        BindValues();
    }

    protected void ValueSaveButton_Click(object sender, EventArgs e)
    {
        ValueMessage.Text = string.Empty;

        int attributeId;
        if (!int.TryParse(AttributeId.Value, out attributeId) || attributeId <= 0)
        {
            ValueMessage.Text = "Vui lòng lưu thuộc tính trước khi thêm giá trị.";
            return;
        }

        string name = (ValueNameInput.Text ?? string.Empty).Trim();
        string sortText = (ValueSortOrderInput.Text ?? string.Empty).Trim();
        bool status = ValueStatusInput.Checked;

        if (string.IsNullOrWhiteSpace(name))
        {
            ValueMessage.Text = "Vui lòng nhập tên giá trị.";
            return;
        }

        int sortOrder = 0;
        if (!string.IsNullOrWhiteSpace(sortText))
        {
            int.TryParse(sortText, out sortOrder);
        }

        using (var db = new BeautyStoryContext())
        {
            CfVariantAttributeValue value;
            int valueId;
            if (int.TryParse(ValueEditId.Value, out valueId) && valueId > 0)
            {
                value = db.CfVariantAttributeValues.FirstOrDefault(v => v.Id == valueId && v.AttributeId == attributeId);
                if (value == null)
                {
                    ValueMessage.Text = "Giá trị không tồn tại.";
                    return;
                }
            }
            else
            {
                value = new CfVariantAttributeValue();
                value.AttributeId = attributeId;
                value.CreatedAt = DateTime.UtcNow;
                value.CreatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
                db.CfVariantAttributeValues.Add(value);
            }

            value.ValueName = name;
            value.SortOrder = sortOrder;
            value.Status = status;
            value.UpdatedAt = DateTime.UtcNow;
            value.UpdatedBy = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : null;
            db.SaveChanges();
        }

        ValueMessage.CssClass = "text-success small d-block mb-2";
        ValueMessage.Text = "Lưu giá trị thành công.";
        ResetValueForm();
        BindValues();
    }

    protected void ValueResetButton_Click(object sender, EventArgs e)
    {
        ResetValueForm();
    }

    protected void ValueRepeater_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
    {
        int id;
        if (!int.TryParse(e.CommandArgument.ToString(), out id))
        {
            return;
        }

        if (e.CommandName == "EditValue")
        {
            LoadValueToForm(id);
        }
        else if (e.CommandName == "DeleteValue")
        {
            DeleteValue(id);
            BindValues();
        }
    }

    private void LoadAttributeToForm(int id)
    {
        using (var db = new BeautyStoryContext())
        {
            var attribute = db.CfVariantAttributes.FirstOrDefault(a => a.Id == id);
            if (attribute == null)
            {
                return;
            }

            AttributeId.Value = attribute.Id.ToString();
            AttributeNameInput.Text = attribute.AttributeName;
            DescriptionInput.Text = attribute.Description;
            SortOrderInput.Text = attribute.SortOrder.ToString();
            StatusInput.Checked = attribute.Status;
        }
    }

    private void BindValues()
    {
        int attributeId;
        if (!int.TryParse(AttributeId.Value, out attributeId) || attributeId <= 0)
        {
            ValueRepeater.DataSource = null;
            ValueRepeater.DataBind();
            return;
        }

        using (var db = new BeautyStoryContext())
        {
            var values = db.CfVariantAttributeValues
                .Where(v => v.AttributeId == attributeId)
                .OrderBy(v => v.SortOrder)
                .ThenBy(v => v.ValueName)
                .Select(v => new
                {
                    v.Id,
                    v.ValueName,
                    v.SortOrder,
                    v.Status
                })
                .ToList();

            ValueRepeater.DataSource = values;
            ValueRepeater.DataBind();
        }
    }

    private void LoadValueToForm(int id)
    {
        using (var db = new BeautyStoryContext())
        {
            var value = db.CfVariantAttributeValues.FirstOrDefault(v => v.Id == id);
            if (value == null)
            {
                return;
            }

            ValueEditId.Value = value.Id.ToString();
            ValueNameInput.Text = value.ValueName;
            ValueSortOrderInput.Text = value.SortOrder.ToString();
            ValueStatusInput.Checked = value.Status;
        }
    }

    private void DeleteValue(int id)
    {
        ValueMessage.Text = string.Empty;

        using (var db = new BeautyStoryContext())
        {
            var value = db.CfVariantAttributeValues.FirstOrDefault(v => v.Id == id);
            if (value == null)
            {
                ValueMessage.Text = "Giá trị không tồn tại.";
                return;
            }

            bool usedByProducts = db.CfProductVariantAttributes.Any(p => p.AttributeValueId == id);
            if (usedByProducts)
            {
                ValueMessage.Text = "Không thể xóa giá trị đang được sử dụng.";
                return;
            }

            db.CfVariantAttributeValues.Remove(value);
            db.SaveChanges();
        }

        ValueMessage.CssClass = "text-success small d-block mb-2";
        ValueMessage.Text = "Xóa giá trị thành công.";
        ResetValueForm();
    }

    private void ResetForm()
    {
        AttributeId.Value = string.Empty;
        AttributeNameInput.Text = string.Empty;
        DescriptionInput.Text = string.Empty;
        SortOrderInput.Text = "0";
        StatusInput.Checked = true;
        FormMessage.Text = string.Empty;
        FormMessage.CssClass = "text-danger small d-block mb-2";
        ResetValueForm();
    }

    private void ResetValueForm()
    {
        ValueEditId.Value = string.Empty;
        ValueNameInput.Text = string.Empty;
        ValueSortOrderInput.Text = "0";
        ValueStatusInput.Checked = true;
        ValueMessage.Text = string.Empty;
        ValueMessage.CssClass = "text-danger small d-block mb-2";
    }
}
