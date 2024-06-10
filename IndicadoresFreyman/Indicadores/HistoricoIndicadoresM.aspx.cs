using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using Telerik.Web.UI.Skins;
using System.Text;
using Telerik.Web;
//using Telerik.Windows.Documents.Spreadsheet.Expressions.Functions;

namespace IndicadoresFreyman.Indicadores
{
    public partial class HistoricoIndicadoresM : System.Web.UI.Page
    {
        static protected string conn = "Server = 187.174.147.102; User ID = sa; password=similares*3; DataBase=Indicadores;";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["empleadoId"] = "3246";// "4178";
                ValidarPuesto();
                // Obtener el mes anterior
                DateTime mesAnterior = DateTime.Now.AddMonths(-1);
                int mesAnteriorNumero = mesAnterior.Month;

                // Llenar el RadDropDownList con los meses
                CultureInfo cultura = new CultureInfo("es-ES");
                DateTimeFormatInfo formatoFecha = cultura.DateTimeFormat;
                for (int i = 1; i <= 12; i++)
                {
                    string nombreMes = formatoFecha.GetMonthName(i);
                    RadDropDownList1.Items.Add(new DropDownListItem(nombreMes, i.ToString()));
                }

                // Seleccionar el mes anterior
                RadDropDownList1.SelectedValue = mesAnteriorNumero.ToString();
                if (Convert.ToBoolean(Session["esGerente"]))
                {
                    Literal1.Text = "<script>document.getElementById('divColaboradores').style.display = 'inline-block';</script>";
                }
                else
                {
                    LoadDataFromDatabase();
                }
                CargarDatosEnGrid();
            }
        }



        private void ValidarPuesto()
        {
            string query = "select IdEmpleado, Nombre_ from Vacaciones.dbo.AdministrativosNomiChecador where JefeInmediato=(select Correo from Vacaciones.dbo.AdministrativosNomiChecador where IdEmpleado=" + Session["empleadoId"] +");";
            using (SqlConnection con = new SqlConnection(conn))
            {
                con.Open();
                using(SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Connection = con;
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.HasRows)
                    {
                        Session["esGerente"] = true;
                        RadDropDownList2.Items.Add(new DropDownListItem("Todos", "1"));
                        while (reader.Read())
                        {
                            RadDropDownList2.Items.Add(new DropDownListItem(reader["Nombre_"].ToString(), reader["IdEmpleado"].ToString()));
                        }
                    }
                    else
                    {
                        Session["esGerente"] = false;
                    }
                }
            }
        }

        private void LoadDataFromDatabase()//Datos del usuario
        {
            string query = "select nombre from MovimientosEmpleados.dbo.EmpleadosNOMI_Todos where idempleado=" + Session["empleadoId"] + ";";

            using (SqlConnection con = new SqlConnection(conn))
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        // Assuming your data is a string
                        string dataFromDb = reader["nombre"].ToString();
                        HiddenLabel.Text = dataFromDb; // Assigning to a hidden label
                    }
                }
            }
        }

        public string CargarEstilosCumplimiento(decimal valor)//Estilos en columna Cumplimiento del Objetivo
        {
            string estilo = "";

            if (valor >= 90)
            {
                estilo = "badge badge-pill badge-success";
            }
            else if (valor >= 75)
            {
                estilo = "badge badge-pill badge-warning";
            }
            else
            {
                estilo = "badge badge-pill badge-danger";
            }

            return estilo;
        }

        private void CargarDatosEnGrid()
        {
            // Aquí debes cargar los datos en el grid
            // Ejemplo:
            DataTable dt = ObtenerDatos(Convert.ToInt32(RadDropDownList1.SelectedValue));
            gridHistorico.DataSource = dt;
            gridHistorico.DataBind();
        }


        private DataTable ObtenerDatos(int mes)
        {
            DataTable dt = new DataTable();
            try
            {
                dt.Columns.Add("ID");
                dt.Columns.Add("Descripción");
                dt.Columns.Add("Ponderación");
                dt.Columns.Add("Indicador Minimo (50 Pts.)");
                dt.Columns.Add("Indicador Deseable (100 Pts.)");
                dt.Columns.Add("Resultado");
                dt.Columns.Add("Cumplimiento Objetivo (0-100 Pts.)");
                dt.Columns.Add("Evaluacion Ponderada");

                string query;

                if (Convert.ToBoolean(Session["esGerente"]))
                {
                    query = "select pli.pIndicadorId as indicadorId, pli.descripcionIndicador, concat(i.ponderacion,'%')as ponderacion,i.indicadorMinimo,i.indicadorDeseable,isnull(e.resultado,0)as resultado, " +
                        "isnull(cumplimientoOBjetivo, 0) as cumplimientoObjetivo, isnull(evaluacionPonderada, 0) as evaluacionPonderada from Indicador i " +
                        "left join PlantillaIndicador pli on pli.pIndicadorId = i.pIndicadorId left join resultadoIndicador e on i.IndicadorId = e.indicadorId " +
                        "where empleadoId in(select IdEmpleado from Vacaciones.dbo.AdministrativosNomiChecador " +
                        "where JefeInmediato = (select Correo from Vacaciones.dbo.AdministrativosNomiChecador where empleadoId = 4178)) and mes = 6";
                }
                else
                {
                    query = "select pli.pIndicadorId as indicadorId, pli.descripcionIndicador, concat(i.ponderacion,'%')as ponderacion,i.indicadorMinimo,i.indicadorDeseable,isnull(e.resultado,0)as resultado, " +
                    "isnull(cumplimientoOBjetivo,0)as cumplimientoObjetivo, isnull(evaluacionPonderada,0)as evaluacionPonderada from Indicador i " +
                    "left join PlantillaIndicador pli on pli.pIndicadorId=i.pIndicadorId left join resultadoIndicador e on i.IndicadorId=e.indicadorId where empleadoId=" + Session["empleadoId"] + " and mes=" + mes + ";";
                }
                

                using (SqlConnection con = new SqlConnection(conn))
                {
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        con.Open();
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        da.Fill(dt);
                    }
                }
            }
            catch (Exception)
            {
                dt= new DataTable();
            }
            
            return dt;

        }

        protected void RadDropDownList1_SelectedIndexChanged(object sender, DropDownListEventArgs e)
        {
            CargarDatosEnGrid();
        }

        protected void btnDescargarArchivo_Click(object sender, EventArgs e)
        {
            int selectedMonth = int.Parse(RadDropDownList1.SelectedValue);
            DescargarArchivo(selectedMonth);

        }
        private void DescargarArchivo(int mes)
        {
            string query = "select nombreArchivo, archivo from Evidencia where empleadoId=" + Session["empleadoId"] + " and mes=" + mes + " and año=2024;";

            using (SqlConnection conn_ = new SqlConnection(conn))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn_))
                {
                    conn_.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        string fileName = reader["nombreArchivo"].ToString();
                        byte[] fileData = (byte[])reader["archivo"];

                        // Enviar el archivo al cliente
                        Response.Clear();
                        Response.AddHeader("Content-Disposition", $"attachment; filename={fileName}");
                        Response.OutputStream.Write(fileData, 0, fileData.Length);
                        Response.Flush();
                        Response.End();
                    }
                }
            }
        }

        protected void gridHistorico_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridFooterItem)
            {
                GridFooterItem footerItem = e.Item as GridFooterItem;
                decimal totalEvaluacionPonderada = 0;

                foreach (GridDataItem item in gridHistorico.MasterTableView.Items)
                {
                    if (decimal.TryParse(item["evaluacionPonderada"].Text, out decimal value))
                    {
                        totalEvaluacionPonderada += value;
                    }
                }
                string resultado = "";

                if (totalEvaluacionPonderada >= 90)
                {
                    resultado = "<span style='Font-size:17px' class='badge badge-success'>" + totalEvaluacionPonderada + "</span>";
                }
                else if (totalEvaluacionPonderada >= 80)
                {
                    resultado = "<span style='Font-size:17px' class='badge badge-warning'>" + totalEvaluacionPonderada + "</span>";
                }
                else
                {
                    resultado = "<span style='Font-size:17px' class='badge badge-danger'>" + totalEvaluacionPonderada + "</span>";
                }
                //footerItem["cumplimientoObjetivo"].Text = "Evaluación Mensual: ";
                footerItem["cumplimientoObjetivo"].Text = "<div style='text-align: right;'>Evaluación Mensual: </div>";
                footerItem["evaluacionPonderada"].Text = resultado;
            }
        }

        protected void gridHistorico_ItemCreated(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridCommandItem)
            {
                Label labelNombre = (Label)e.Item.FindControl("nombreColaborador");
                if (labelNombre != null)
                {
                    labelNombre.Text = "Nombre del Colaborador: " + HiddenLabel.Text;
                }

                Label mes = (Label)e.Item.FindControl("mes");
                if (mes != null)
                {
                    mes.Text = DateTime.Now.ToString("MMMM-yyyy", new System.Globalization.CultureInfo("es-ES"));
                }
            }
        }
        protected void gridHistorico_SortCommand(object sender, GridSortCommandEventArgs e)
        {
            ObtenerDatos(Convert.ToInt32(RadDropDownList1.SelectedValue));
        }


        protected void txtFilter_TextChanged(object sender, EventArgs e)
        {
            string filterText = txtFilter.Text.Trim();
            if (!string.IsNullOrEmpty(filterText))
            {
                // Filtrar datos en el grid basado en el texto del TextBox
                DataTable dt = ObtenerDatos(Convert.ToInt32(RadDropDownList1.SelectedValue));
                DataView dv = dt.DefaultView;

                string filterExpression = string.Format(
            "Convert(indicadorId, 'System.String') LIKE '%{0}%' OR " +
            "Convert(descripcionIndicador, 'System.String') LIKE '%{0}%' OR " +
            "Convert(ponderacion, 'System.String') LIKE '%{0}%' OR " +
            "Convert(indicadorMinimo, 'System.String') LIKE '%{0}%' OR " +
            "Convert(indicadorDeseable, 'System.String') LIKE '%{0}%' OR " +
            "Convert(resultado, 'System.String') LIKE '%{0}%' OR " +
            "Convert(cumplimientoObjetivo, 'System.String') LIKE '%{0}%' OR " +
            "Convert(evaluacionPonderada, 'System.String') LIKE '%{0}%'",
            filterText);

                dv.RowFilter = filterExpression;
                gridHistorico.DataSource = dv;
                gridHistorico.DataBind();
            }
            else
            {
                // Si no hay filtro, simplemente recargar los datos originales
                CargarDatosEnGrid();
            }
        }

        protected void RadDropDownList2_SelectedIndexChanged(object sender, DropDownListEventArgs e)
        {
            CargarDatosEnGrid();
        }
    }
}