using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing.Drawing2D;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Charting;
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
                HidEmpleado.Value = Session["log"]?.ToString();
                CualesEmpleadosVer();
                RadMonthYearPicker1.MaxDate = (DateTime)DateTime.Now;
                RadMonthYearPicker1.SelectedDate = (DateTime)DateTime.Now.AddMonths(-5);

                RadMonthYearPicker2.MaxDate = (DateTime)DateTime.Now;
                RadMonthYearPicker2.SelectedDate = (DateTime)DateTime.Now;
                string qEmpleados = "";

                if (hidAccesoEmpleados.Value != "")
                {
                    qEmpleados = string.Format(" and idempleado in({0}) ", hidAccesoEmpleados.Value);
                }

                string qD = string .Format ( "select distinct Departamento , iddepartamento  from Vacaciones .dbo.AdministrativosNomiChecador where iddepartamento not in (313,24,321,39) {0} order by Departamento ", qEmpleados );
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
                               
                radAñoA.DataSource = dta;
                radAñoA.DataTextField = "año";
                radAñoA.DataValueField = "año";
                radAñoA.DataBind();

                string qj = "select *from Directorio .dbo.jerarquias";
                DataTable dtj = con.getDatatable(qj);
                RadJerarquia.DataSource = dtj;
                RadJerarquia.DataTextField = "Descripcion";
                RadJerarquia.DataValueField = "Id";
                RadJerarquia.DataBind();
                // radAñoA.Items.Add(new RadComboBoxItem("SELECCIONA", "-1"));
                // radAñoA.SelectedValue = "-1";

                //radAñoA.SelectedValue = System.DateTime .Now .Year .ToString();
                //radAñoDe.SelectedValue = System.DateTime.Now.Year.ToString();

                obtenerInfo();
            }

        }
      
        private void obtenerInfo()
        {

            DateTime? FechaDe = RadMonthYearPicker1.SelectedDate;
            DateTime? FechaA = RadMonthYearPicker2.SelectedDate;
            DataTable dtA;
            DataTable dtM;
            DataTable dtAuxA = null;
            DataTable dtAuxM = null;
            int inicioDatosM=0;
            int inicioDatosA = 0;
            if (rdlQuien.SelectedValue == "D")
            {
                inicioDatosA = 1;
                inicioDatosM = 0;
            }
            else {
                inicioDatosA = 3;
                inicioDatosM = 2;
            }
            try
            {
                List<int> ListJerarquia = new List<int>();
                ListJerarquia = ShowCheckedItems(RadJerarquia);
                string Jerarquias = string.Join(",", ListJerarquia );

                dtM = con.getDatatable(string.Format("exec Indicadores .dbo.TableroHistorico {0},{1},{2},{3},'" + rdlQuien.SelectedValue + "','{4}','{5}'", FechaDe.Value.Month, FechaDe.Value.Year, FechaA.Value.Month, FechaA.Value.Year, Jerarquias, hidAccesoEmpleados .Value ));

                dtA = con.getDatatable(string.Format("exec Indicadores .dbo.TableroHistoricoAño {0},{1},'" + rdlQuien.SelectedValue + "','{2}','{3}'", radAñoDe.SelectedValue, radAñoA.SelectedValue, Jerarquias, hidAccesoEmpleados.Value));
                

                List<int> ListEmpleados = new List<int>();
                ListEmpleados = ShowCheckedItems(radEmpleados);

                List<string> ListDepartamentos = new List<string>();
                ListDepartamentos = ShowCheckedItemsText(radDepartamentos);

                try
                {
                    
                    if (rdlQuien .SelectedValue =="E" ) {
                        dtAuxM = (from c in dtM.AsEnumerable() where ListEmpleados.Contains(c.Field<Int32>("IdEmpleado")) select c).CopyToDataTable();
                        dtAuxA = (from c in dtA.AsEnumerable() where ListEmpleados.Contains(c.Field<Int32>("IdEmpleado")) select c).CopyToDataTable();
                    }
                    if (rdlQuien.SelectedValue == "D")
                    {
                        dtAuxM = (from c in dtM.AsEnumerable() where ListDepartamentos.Contains(c.Field<string>("Nombre")) select c).CopyToDataTable();
                        dtAuxA = (from c in dtA.AsEnumerable() where ListDepartamentos.Contains(c.Field<string>("Nombre")) select c).CopyToDataTable();
                    }
                }
                catch (Exception ex)
                {
                    int x = 9;
                }

                if (dtAuxM == null)
                {
                    dtAuxM = dtM;
                }
                if (dtAuxA == null)
                {
                    dtAuxA = dtA;
                }
                GraficaBarras(dtAuxA,ref GraficaAño, inicioDatosA);
                GenerarPtosGrafica(dtAuxM,ref GraficaMesAño, inicioDatosM);
                //GraficaBarras(GenerarTablaprueba(), GraficaAño, 3);
            }
            catch (Exception ex)
            {
                int x = 9;
            }


            // GenerarPtosGrafica(dtgraficaMesAñoEmpleado, GraficaAñoEmpleado);

        }
        private void CualesEmpleadosVer()  
        {
            var dtJerarquia = con.getDatatable("select Jerarquia from Vacaciones .dbo.AdministrativosNomiChecador where IdEmpleado = " + HidEmpleado.Value);
            if ((int)dtJerarquia.Rows[0]["Jerarquia"] != 1 && (int)dtJerarquia.Rows[0]["Jerarquia"] != 2)
            {
                 var dtCOMPAÑEROS = con.getDatatable(@"select IdEmpleado from Vacaciones.dbo.AdministrativosNomiChecador as a1 where a1.Departamento = 
                (select a2.Departamento from Vacaciones.dbo.AdministrativosNomiChecador as a2 where idempleado=" + HidEmpleado.Value + @") 
                union all 
                select a1.IdEmpleado from Vacaciones.dbo.AdministrativosNomiChecador as a1 where Jefe2 = 
                (select correo from Vacaciones.dbo.AdministrativosNomiChecador as a2 where IdEmpleado =" + HidEmpleado.Value + @") 
                or jefeinmediato= 
                (select correo from Vacaciones.dbo.AdministrativosNomiChecador as a2 where IdEmpleado  =" + HidEmpleado.Value + @")");

                var lst = (from c in dtCOMPAÑEROS.AsEnumerable() select c.Field<int>("IdEmpleado")).ToList();

                hidAccesoEmpleados.Value = string.Join(",", lst );
            }
           
           

        }
        private DataTable GenerarTablaprueba()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add(new DataColumn("Nombre"));
            dt.Columns.Add(new DataColumn("2022"));
            dt.Columns.Add(new DataColumn("2023"));
            dt.Columns.Add(new DataColumn("2024"));
            dt.Rows.Add("José", 80, 74, 96);
            dt.Rows.Add("Ana", 98, 70, 80);
            dt.Rows.Add("Juan", 96, 90, 76);
            dt.Rows.Add("Miriam", 74, 80, 90);
            return dt;
        }
        private void GenerarPtosGrafica(DataTable dt,ref Telerik.Web.UI.RadHtmlChart grafica, int inicioDatos)
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
        private void GraficaBarras(DataTable dt, ref Telerik.Web.UI.RadHtmlChart GraficaBarra, int inicioDatos)
        {
            string[] ColoresH = { "#99c62a", "#7bcde0", "#7f57ba", "#3481cd", "#99c62a", "#7bcde0" };

            // Limpiar las series
            GraficaBarra.PlotArea.Series.Clear();
            GraficaBarra.PlotArea.XAxis.Items.Clear();
            // Limpiar y configurar el eje Y
            GraficaBarra.PlotArea.YAxis.LabelsAppearance.DataFormatString = "{0}";

            // Agregar etiquetas al eje Y
            var xAxisLabels = new List<string>();
            foreach (DataRow row in dt.Rows)
            {
                xAxisLabels.Add(row["Nombre"].ToString());
            }
            GraficaBarra.PlotArea.XAxis.Items.AddRange(xAxisLabels.Select(label => new AxisItem { LabelText = label }).ToArray());
            // GraficaBarra.PlotArea.YAxis.LabelsAppearance.Items.AddRange(yAxisLabels.ToArray());
            //GraficaBarra.PlotArea.YAxis.Equals(yAxisLabels.ToArray());
            // Crear una serie de columnas por cada año
            for (int i = inicioDatos; i < dt.Columns.Count; i++)
            {
                ColumnSeries cs = new ColumnSeries();
                string nombrecol = dt.Columns[i].ColumnName;
                cs.Name = nombrecol;

                for (int a = 0; a < dt.Rows.Count; a++)
                {
                    cs.SeriesItems.Add(new CategorySeriesItem(Convert.ToDecimal(dt.Rows[a][nombrecol])));
                }

                GraficaBarra.PlotArea.Series.Add(cs);
            }

            // Ajustar la apariencia de los ejes
            GraficaBarra.PlotArea.XAxis.TitleAppearance.Text = "Nombres"; // Agregar título al eje X
            GraficaBarra.PlotArea.YAxis.TitleAppearance.Text = "Valores"; // Agregar título al eje Y
            GraficaBarra.PlotArea.XAxis.LabelsAppearance.RotationAngle = 45; // Ajustar la rotación de las etiquetas del eje X si es necesario
        }
        private void GraficaBarrasAcostada(DataTable dt,ref Telerik.Web.UI.RadHtmlChart GraficaBarra, int inicioDatos)
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
                string nombrecol = dt.Columns[i].ColumnName;
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
            RadJerarquia .Visible =false;
            if (rdlQuien.SelectedValue == "E")
            {
                radDepartamentos.Visible = true;
                radEmpleados.Visible = true;
                RadJerarquia.Visible = true;
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
        private void ObtenerEmpleados()
        {
            string departamentos = string.Join(",", ShowCheckedItems(radDepartamentos));
            string qEmpleados = "";
            if (hidAccesoEmpleados.Value !="") 
            {
                 qEmpleados = string.Format(" and idempleado in({0}) ", hidAccesoEmpleados.Value );
            }
            List<int> ListJerarquia = new List<int>();
            ListJerarquia = ShowCheckedItems(RadJerarquia);
            string Jerarquias = "";
            if (ListJerarquia .Count>0)
            {
               Jerarquias=string .Format (" and jerarquia in ({0}) ", string.Join(",", ListJerarquia));
            }
            
            if (rdlQuien.SelectedValue == "E")
            {
                string qdepartamento = "";
                if (departamentos !="") {
                    qdepartamento = string.Format(" and iddepartamento in ({0}) ", departamentos);
                }
                radEmpleados.Items.Clear();
                string q = string.Format("select idempleado, Nombre_ as Nombre from Vacaciones .dbo.AdministrativosNomiChecador where 1=1 {0} {1} {2} order by Departamento", qdepartamento, qEmpleados, Jerarquias);
                DataTable dt = con.getDatatable(q);
                radEmpleados.DataSource = dt;
                radEmpleados.DataTextField = "Nombre";
                radEmpleados.DataValueField = "idempleado";
                radEmpleados.DataBind();
                radEmpleados.Items.Add(new RadComboBoxItem("SELECCIONA", "-1"));
                radEmpleados.SelectedValue = "-1";
            }
        }
        private List<int> ShowCheckedItems(Telerik.Web.UI.RadComboBox comboBox)
        {
            List<int> miLista = new List<int>();
            var collection = comboBox.CheckedItems;

            if (collection.Count != 0)
            {
                foreach (var item in collection)
                    miLista.Add(int.Parse(item.Value));
            }
            return miLista;
        }
        private List<string> ShowCheckedItemsText(Telerik.Web.UI.RadComboBox comboBox)
        {
            List<string> miLista = new List<string>();
            var collection = comboBox.CheckedItems;

            if (collection.Count != 0)
            {
                foreach (var item in collection)
                    miLista.Add(item.Text );
            }
            return miLista;
        }
        protected void btnAux_Click(object sender, EventArgs e)
        {
            if (radDepartamentos.CheckedItems.Count > 0 || RadJerarquia .CheckedItems .Count >0 )
            {
                ObtenerEmpleados();

            }
        }

        protected void RadMonthYearPicker1_SelectedDateChanged(object sender, Telerik.Web.UI.Calendar.SelectedDateChangedEventArgs e)
        {
            obtenerInfo();
        }

        protected void radDepartamentos_CheckAllCheck(object sender, RadComboBoxCheckAllCheckEventArgs e)
        {
            ObtenerEmpleados();
        }

        protected void RadJerarquia_CheckAllCheck(object sender, RadComboBoxCheckAllCheckEventArgs e)
        {
            ObtenerEmpleados();
        }
    }
}