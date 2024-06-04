using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace IndicadoresFreyman
{
    public partial class MasterPage : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected override void OnInit(EventArgs e)
        {
            RadMenuItem currentItem = RadMenu1.FindItemByUrl(Request.Url.PathAndQuery);
            if (currentItem != null)
            {
                currentItem.HighlightPath();
                currentItem.Selected = true;

            
            }
            base.OnInit(e);
        }
        protected void btnDeslog_Click(object sender, ImageClickEventArgs e)
        {
            Session["Log"] = null;
            Response.Redirect("/Log.aspx");
        }

        protected void btnSalir_Click(object sender, EventArgs e)
        {
            Session["Log"] = null;
            Response.Redirect("/Log.aspx");
        }
    }
}