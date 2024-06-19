using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing.Drawing2D;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using Telerik.Web.UI.Skins;
using Telerik.Windows.Documents.Flow.Model.Lists;

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

                string qD = "select distinct Departamento , iddepartamento  from Vacaciones .dbo.AdministrativosNomiChecador where iddepartamento not in (313,24,321) order by Departamento ";
                DataTable dtD = con.getDatatable(qD);
                radDepartamentos.DataSource = dtD;
                radDepartamentos.DataTextField = "Departamento";
                radDepartamentos.DataValueField = "iddepartamento";
                radDepartamentos.DataBind();
                radDepartamentos.Items.Add(new RadComboBoxItem("SELECCIONA", "-1"));
                radDepartamentos.SelectedValue = "-1";

                string qa = "select distinct año from [Indicadores] .dbo.[HistoricoEmpleadoIndicador] where año is not null order by año\r\n";
                DataTable dta = con.getDatatable(qa);
                radAñoDe.DataSource = dta;
                radAñoDe.DataTextField = "año";
                radAñoDe.DataValueField = "año";
                radAñoDe.DataBind();
               // radAñoDe.Items.Add(new RadComboBoxItem("SELECCIONA", "-1"));
               // radAñoDe.SelectedValue = "-1";

                string qa2 = "select distinct año from [Indicadores] .dbo.[HistoricoEmpleadoIndicador] where año is not null order by año\r\n";
                DataTable dta2 = con.getDatatable(qa2);
                radAñoA.DataSource = dta2;
                radAñoA.DataTextField = "año";
                radAñoA.DataValueField = "año";
                radAñoA.DataBind();
               // radAñoA.Items.Add(new RadComboBoxItem("SELECCIONA", "-1"));
               // radAñoA.SelectedValue = "-1";

                //radAñoA.SelectedValue = System.DateTime .Now .Year .ToString();
                //radAñoDe.SelectedValue = System.DateTime.Now.Year.ToString();

                obtenerInfo();
            }
            if (HidChecDepartamento .Value =="si") {
                if (radDepartamentos.CheckedItems.Count > 0)
                {
                    ObtenerEmpleados();
                    HidChecDepartamento.Value = "";
                }
            }
           
        }
        private  void obtenerInfo()
        {

            DateTime? FechaDe = RadMonthYearPicker1.SelectedDate;
            DateTime? FechaA = RadMonthYearPicker2.SelectedDate;
            DataTable dtA;
            DataTable dtM;
            DataTable dtAuxA = null;
            DataTable dtAuxM = null;
            try {
                dtM =  con.getDatatable(string.Format("exec Indicadores .dbo.TableroHistorico {0},{1},{2},{3},'" + rdlQuien.SelectedValue + "'", FechaDe.Value.Month, FechaDe.Value.Year, FechaA.Value.Month, FechaA.Value.Year));

                dtA = con.getDatatable(string.Format("exec Indicadores .dbo.TableroHistoricoAño {0},{1},'" + rdlQuien.SelectedValue + "'",  radAñoDe .SelectedValue ,  radAñoA .SelectedValue ));

                List<int> ListEmpleados = new List<int>();
                ListEmpleados= ShowCheckedItems(radEmpleados);

                dtAuxM = (from c in dtM.AsEnumerable() where ListEmpleados.Contains(c.Field<Int32>("IdEmpleado")) select c).CopyToDataTable();
                dtAuxA = (from c in dtA.AsEnumerable() where ListEmpleados.Contains(c.Field<Int32 >("IdEmpleado")) select c).CopyToDataTable();
                if (dtAuxM == null)
                {
                    dtAuxM = dtM;
                }
                if (dtAuxA == null)
                {
                    dtAuxA = dtA;
                }
                GenerarPtosGrafica(dtM, GraficaMesAño, 2);
                GraficaBarras(dtA, GraficaAño, 3);
            }
            catch (Exception ex) { }
          
           
            // GenerarPtosGrafica(dtgraficaMesAñoEmpleado, GraficaAñoEmpleado);

        }
        private DataTable GenerarTablaprueba() 
        {
            DataTable dt = new DataTable();
            dt.Columns.Add(new DataColumn("Nombre"));
            dt.Columns.Add(new DataColumn("2022"));
            dt.Columns.Add(new DataColumn("2023"));
            dt.Columns.Add(new DataColumn("2024"));
            dt.Rows.Add("José",80,74,96);
            dt.Rows.Add("Ana", 98, 70, 80);
            dt.Rows.Add("Juan", 96, 90, 76);
            dt.Rows.Add("Miriam", 74, 80, 90);
            return dt;
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
        private void GraficaBarras(DataTable dt, Telerik.Web.UI.RadHtmlChart GraficaBarra, int inicioDatos)
        {
            string[] ColoresH = { "#99c62a", "#7bcde0", "#7f57ba", "#3481cd", "#99c62a", "#7bcde0" };
          //  string[] Años = { "2022", "2023", "2024" };

            // Limpiar las series y los items del eje X
            GraficaBarra.PlotArea.Series.Clear();
            GraficaBarra.PlotArea.XAxis.Items.Clear();

            // Agregar nombres al eje X
            foreach (DataRow row in dt.Rows)
            {
                GraficaBarra.PlotArea.XAxis.Items.Add(row["Nombre"].ToString());
            }

            // Crear una serie de barras por cada año
            // for (int i = 0; i < Años.Length; i++)
            for (int i = inicioDatos; i < dt.Columns.Count; i++)
            {
                BarSeries bs = new BarSeries();
                string nombrecol=dt.Columns[i].ColumnName;
                bs.Name = nombrecol;//Años[i];

                for (int a = 0; a < dt.Rows.Count; a++)
                {
                    bs.SeriesItems.Add(new CategorySeriesItem(Convert.ToDecimal(dt.Rows[a][nombrecol])));
                }

                GraficaBarra.PlotArea.Series.Add(bs);
            }
            GraficaBarra.PlotArea.XAxis.LabelsAppearance.RotationAngle = 25;
        }
        private void GraficaBarras_prueba1(DataTable dt, Telerik.Web.UI.RadHtmlChart GraficaBarra, int inicioDatos)
        {
            string[] ColoresH = { "#99c62a", "#7bcde0", "#7f57ba", " #3481cd", "#99c62a", "#7bcde0" };
            BarSeries bs2 = new BarSeries();
            bs2 = (BarSeries)GraficaBarra.PlotArea.Series[0];
            bs2.SeriesItems.Clear();
            GraficaBarra.PlotArea.XAxis.Items.Clear();

            for (int a = 0; a < dt.Rows.Count; a++)
            {
               
                bs2.SeriesItems.Add(Convert.ToDecimal(dt.Rows[a]["2024"]), System.Drawing.ColorTranslator.FromHtml(ColoresH[a]));
                GraficaBarra.PlotArea.XAxis.Items.Add(dt.Rows[a]["Nombre"].ToString());
                // RadHtmlChartDVR.PlotArea.XAxis.LabelsAppearance.Position = HtmlChart.BarColumnLabelsPosition.InsideBase;
               GraficaBarra.PlotArea.XAxis.LabelsAppearance.RotationAngle = 25;
            }
        }
       

        protected void rdlQuien_SelectedIndexChanged(object sender, EventArgs e)
        {
            radDepartamentos.Visible = false;
            radEmpleados.Visible = false;
            if (rdlQuien .SelectedValue == "E")
            {
                radDepartamentos.Visible = true;
                radEmpleados.Visible = true;
            }
            if (rdlQuien.SelectedValue == "D")
            {
                radDepartamentos.Visible = true;
                radEmpleados.Visible = false;
            }
        }

        protected void btnActualizar_Click(object sender, ImageClickEventArgs e)
        {
            obtenerInfo();
        }
        private void ObtenerEmpleados() {
            string departamentos = string.Join(",", ShowCheckedItems(radDepartamentos));
            if (rdlQuien.SelectedValue == "E")
            {
                radEmpleados.Items.Clear ();    
                string q = string.Format("select idempleado, Nombre from Vacaciones .dbo.AdministrativosNomiChecador where iddepartamento in ({0}) order by nombre", departamentos);
                DataTable dt = con.getDatatable(q);
                radEmpleados.DataSource = dt;
                radEmpleados.DataTextField = "Nombre";
                radEmpleados.DataValueField = "idempleado";
                radEmpleados.DataBind();
                radEmpleados.Items.Add(new RadComboBoxItem("SELECCIONA", "-1"));
                radEmpleados.SelectedValue = "-1";
            }
        }
        private List<int > ShowCheckedItems(Telerik.Web.UI.RadComboBox comboBox)
        {
            List<int > miLista = new List<int>();
            var collection = comboBox.CheckedItems;

            if (collection.Count != 0)
            {
                foreach (var item in collection)
                    miLista.Add( int.Parse ( item.Value));
            }
            return miLista;
        }

       
    }
}