using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace IndicadoresFreyman.Reportes
{
    public partial class ReporteRRHH : System.Web.UI.Page
    {
        Conexion con = new Conexion();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                RadMonthYearPicker1.MaxDate = (DateTime)DateTime.Now;
                RadMonthYearPicker1.SelectedDate = (DateTime)DateTime.Now.AddMonths(-1);

                //RadGrid1.AutoGenerateColumns = true;
                //RadGrid1.ColumnCreated += RadGrid1_ColumnCreated;
                ObtenerInfo();
            }
        }
        protected void ObtenerInfo()
        {
            DateTime? FechaDe = RadMonthYearPicker1.SelectedDate;
            DataTable dt = con.getDatatable(string.Format("select *from Indicadores .dbo.ReporteRRHH  where mes ={0} and año ={1}", FechaDe.Value.Month, FechaDe.Value.Year));
            if (dt != null)
            {
                RadGridRRHH.DataSource = dt;
                RadGridRRHH.Rebind();

            }

        }

        protected void RadGridRRHH_SortCommand(object sender, Telerik.Web.UI.GridSortCommandEventArgs e)
        {
            ObtenerInfo();
        }


        protected void RadGridRRHH_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
            ObtenerInfo();
        }

        protected void RadGridRRHH_ItemDataBound(object sender, Telerik.Web.UI.GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem item = e.Item as GridDataItem;
                try 
                {
                    if (item["fechaCerrado"].Text !="&nbsp;") {
                         DateTime fechaCerrado = DateTime.Parse(item["fechaCerrado"].Text);
                    
                        if (fechaCerrado.Day > 7)
                        {
                            item["fechaCerrado"].BackColor = System.Drawing.ColorTranslator.FromHtml("#FBCEC0");
                        }
                    }
                
                } catch { }
            }
        }
        protected void btnActualizar_Click(object sender, ImageClickEventArgs e)
        {
            ObtenerInfo();
        }
    }
}