using System;
using System.Web.UI;

public class CommunityPageBase : Page
{
    protected virtual bool RequireCommunityLogin
    {
        get { return true; }
    }

    protected override void OnLoad(EventArgs e)
    {
        if (RequireCommunityLogin && !CommunityUserHelper.EnsureCommunityLogin())
        {
            return;
        }

        base.OnLoad(e);
    }
}
