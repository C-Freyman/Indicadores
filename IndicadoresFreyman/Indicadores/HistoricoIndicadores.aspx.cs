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

namespace IndicadoresFreyman.Indicadores
{
    public partial class HistoricoIndicadores : System.Web.UI.Page
    {
        static protected string conn = "Server = 187.174.147.102; User ID = sa; password=similares*3; DataBase=Indicadores;";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["empleadoId"] = "3246";
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
                LoadDataFromDatabase();
                CargarDatos(1);
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


        private void CargarDatos(int mes)
        {
            DataTable dt = new DataTable();
            string query = "select pli.pIndicadorId as indicadorId, pli.descripcionIndicador, concat(i.ponderacion,'%')as ponderacion,i.indicadorMinimo,i.indicadorDeseable,isnull(e.resultado,0)as resultado, " +
                "isnull(cumplimientoOBjetivo,0)as cumplimientoObjetivo, isnull(evaluacionPonderada,0)as evaluacionPonderada from Indicador i " +
                "left join PlantillaIndicador pli on pli.pIndicadorId=i.pIndicadorId left join resultadoIndicador e on i.IndicadorId=e.indicadorId where empleadoId=" + Session["empleadoId"] + " and mes=" + mes + ";";

            using (SqlConnection con = new SqlConnection(conn))
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt);
                }
            }

            gridHistorico.DataSource = dt;
            gridHistorico.DataBind();
            
        }

        protected void RadDropDownList1_SelectedIndexChanged(object sender, DropDownListEventArgs e)
        {
            // Obtener el valor seleccionado (número de mes)
            string selectedValue = RadDropDownList1.SelectedValue;

            // Convertir el valor a un número entero
            int mesSeleccionado = int.Parse(selectedValue);

            CargarDatos(mesSeleccionado);
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
    }
}