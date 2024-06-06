using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace IndicadoresFreyman.Reportes
{
    public partial class ReporteRRHH : System.Web.UI.Page
    {
        Conexion con = new Conexion();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //RadGrid1.AutoGenerateColumns = true;
                //RadGrid1.ColumnCreated += RadGrid1_ColumnCreated;
                ObtenerInfo();
            }
        }
        protected void ObtenerInfo()
        {
            DataTable dt = con.getDatatable("select *from Indicadores .dbo.ReporteRRHH  ");
            if (dt != null)
            {
                RadGridRRHH.DataSource = dt;
                RadGridRRHH.Rebind();
             
            }

        }

        protected void RadGridRRHH_SortCommand(object sender, Telerik.Web.UI.GridSortCommandEventArgs e)
        {

        }

        protected void RadGridRRHH_ColumnCreated(object sender, Telerik.Web.UI.GridColumnCreatedEventArgs e)
        {

        }

        protected void RadGridRRHH_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {

        }

        protected void RadGridRRHH_ItemDataBound(object sender, Telerik.Web.UI.GridItemEventArgs e)
        {

        }
    }
}