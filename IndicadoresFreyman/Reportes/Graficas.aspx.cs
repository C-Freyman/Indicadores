using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using Telerik.Web.UI.Skins;

namespace IndicadoresFreyman.Reportes
{
    public partial class Graficas : System.Web.UI.Page
    {
        Conexion con = new Conexion();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                RadMonthYearPicker1.MaxDate = (DateTime)DateTime.Now;
                RadMonthYearPicker1.SelectedDate = (DateTime)DateTime.Now.AddMonths(-5);

                RadMonthYearPicker2.MaxDate = (DateTime)DateTime.Now;
                RadMonthYearPicker2.SelectedDate = (DateTime)DateTime.Now;

                string q = "select idempleado, Nombre   from Vacaciones .dbo.AdministrativosNomiChecador order by nombre";
                DataTable dt = con.getDatatable(q);
                radEmpleados.DataSource = dt;
                radEmpleados.DataTextField = "Nombre";
                radEmpleados.DataValueField = "idempleado";
                radEmpleados.DataBind();
                radEmpleados.Items.Add(new RadComboBoxItem("SELECCIONA", "-1"));
                radEmpleados.SelectedValue = "-1";

                obtenerInfo();
            }
        }
        private  void obtenerInfo()
        {
            DateTime? FechaDe = RadMonthYearPicker1.SelectedDate;
            DateTime? FechaA = RadMonthYearPicker2.SelectedDate;

            DataTable dtMesAñoEmpleado =  con.getDatatable(string.Format("exec Indicadores .dbo.TableroHistorico {0},{1},{2},{3},'E','MA'", FechaDe.Value.Month, FechaDe.Value.Year, FechaA.Value.Month, FechaA.Value.Year));
            GenerarPtosGrafica(dtMesAñoEmpleado, GraficaMesAñoEmpleado,3);
           
            DataTable dtAñoEmpleado = con.getDatatable(string.Format("exec Indicadores .dbo.TableroHistorico {0},{1},{2},{3},'E','A'", FechaDe.Value.Month, FechaDe.Value.Year, FechaA.Value.Month, FechaA.Value.Year));
            GenerarPtosGrafica(dtAñoEmpleado, GraficaAñoEmpleado,3);
            // GenerarPtosGrafica(dtgraficaMesAñoEmpleado, GraficaAñoEmpleado);

        }
        private void GenerarPtosGrafica(DataTable dt, Telerik.Web.UI.RadHtmlChart grafica,int inicioDatos )
        {
            Telerik.Web.UI.RadHtmlChart GraficaLineas = grafica;
            Telerik.Web.UI.LineSeries S;
            GraficaLineas.PlotArea.XAxis.Items.Clear();
            GraficaLineas.PlotArea.Series.Clear();

            GraficaLineas.PlotArea.YAxis.LabelsAppearance.DataFormatString = "{0} %";

            for (int f = 0; f <= dt.Rows.Count - 1; f++)
            {
                S = new Telerik.Web.UI.LineSeries();
                for (int c = 0; c <= dt.Columns.Count - 1; c++)
                {
                    if (c > inicioDatos)
                    {
                        decimal x = (decimal)dt.Rows[f][c];
                        S.SeriesItems.Add(x);
                        if (f == 0)
                            GraficaLineas.PlotArea.XAxis.Items.Add(dt.Columns[c].ColumnName);
                    }
                }
                S.Name = (string)dt.Rows[f]["Nombre"];
                GraficaLineas.PlotArea.Series.Add(S);
                S.Items.Clear();
            }
        }

        private static void ShowCheckedItems(Telerik.Web.UI.RadComboBox comboBox, Literal literal)
        {
            var sb = new StringBuilder();
            var collection = comboBox.CheckedItems;

            if (collection.Count != 0)
            {
                sb.Append("<h3>Checked Items:</h3><ul class=\"results\">");

                foreach (var item in collection)
                    sb.Append("<li>" + item.Text + "</li>");

                sb.Append("</ul>");

                literal.Text = sb.ToString();
            }
            else
            {
                literal.Text = "<p>No items selected</p>";
            }

        }

        protected void btnActualizar_Click(object sender, EventArgs e)
        {
            ShowCheckedItems(radEmpleados, itemsClientSide);
        }
    }
}