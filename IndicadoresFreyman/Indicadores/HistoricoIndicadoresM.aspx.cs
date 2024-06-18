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
using Telerik.Windows.Documents.Flow.Model.Styles;
using System.Web.Services;
using System.Runtime.CompilerServices;

namespace IndicadoresFreyman.Indicadores
{
    public partial class HistoricoIndicadoresM : System.Web.UI.Page
    {
        static protected string conn = "Server = 187.174.147.102; User ID = sa; password=similares*3; DataBase=Indicadores;";
        static public string mes;
        static public string año;
        static private bool cambioDeMes;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //Session["Log"] = "42";//;// ;"3246""42""1935"
                ValidarPuesto();

                // Obtener el mes anterior
                DateTime mesAnterior = DateTime.Now.AddMonths(-1);
                int mesAnteriorNumero = mesAnterior.Month;
                if(mes == null)
                {
                    mes = mesAnteriorNumero.ToString();
                    año = mesAnterior.Year.ToString();

                    cambioDeMes = false;
                }
                else
                {
                    cambioDeMes = true;
                }

                

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
                
                CargarDatosEnGrid();
            }
        }

        private void ValidarPuesto()
        {
            //Puestos= 0-colaborador////1-gerente/////2-Contralor
            if (Session["Log"] as string == "42")//Contralor
            {
                Session["puesto"] = "2";
                Literal1.Text = "<script>document.getElementById('divColaboradores').style.display = 'inline-block';</script>";
                gridHistorico.MasterTableView.GetColumn("Nombre_").Visible = true;
                gridHistorico.MasterTableView.GetColumn("Departamento").Visible = true;
                

                using (SqlConnection con = new SqlConnection(conn))
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand("select distinct Departamento from Vacaciones.dbo.AdministrativosNomiChecador;", con))
                    {
                        cmd.Connection = con;
                        SqlDataReader reader = cmd.ExecuteReader();
                        RadDropDownList3.Items.Add(new DropDownListItem("SELECCIONA UNA OPCIÓN", ""));
                        while (reader.Read())
                        {
                            RadDropDownList3.Items.Add(new DropDownListItem(reader["Departamento"].ToString(), reader["Departamento"].ToString()));
                        }
                    }
                }
            }
            else
            {
                string query = "select IdEmpleado, Nombre_ from Vacaciones.dbo.AdministrativosNomiChecador where JefeInmediato=(select Correo from Vacaciones.dbo.AdministrativosNomiChecador where IdEmpleado=" + Session["Log"] + ");";
                using (SqlConnection con = new SqlConnection(conn))
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Connection = con;
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.HasRows)//Si es gerente
                        {
                            Session["puesto"] = "1";
                            Literal1.Text = "<script>document.getElementById('divColaboradores').style.display = 'inline-block';</script>";
                            gridHistorico.MasterTableView.GetColumn("Nombre_").Visible = true;
                            RadDropDownList2.Items.Add(new DropDownListItem("TODOS", "1"));
                            while (reader.Read())
                            {
                                RadDropDownList2.Items.Add(new DropDownListItem(reader["Nombre_"].ToString(), reader["IdEmpleado"].ToString()));
                            }

                            RadDropDownList2.Enabled = true;
                        }
                        else//Colaborador 
                        {
                            Session["puesto"] = "0";
                            LoadDataFromDatabase();
                            gridHistorico.MasterTableView.GetColumn("Evidencia").Visible = false;
                        }
                    }
                }
            }
        }

        private void LoadDataFromDatabase()//Datos del usuario
        {
            string query = "select nombre from MovimientosEmpleados.dbo.EmpleadosNOMI_Todos where idempleado=" + Session["Log"] + ";";

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

        private void CargarDatosEnGrid()//Carga datos en grid
        {
            DataTable dt = new DataTable();
            //si es gerente ejecuta un metodo diferente al de un colaborador no gerente
            if (Session["puesto"] as string == "2")//Contralor
            {
                dt = ObtenerDatosContralor(Convert.ToInt32(RadDropDownList1.SelectedValue), RadDropDownList3.SelectedValue.ToString(), RadDropDownList2.SelectedValue.ToString());
            }
            else if (Session["puesto"] as string == "1")
            {
                dt = ObtenerDatosGerente(Convert.ToInt32(RadDropDownList1.SelectedValue), Convert.ToInt32(RadDropDownList2.SelectedValue));
            }
            else
            {
                dt = ObtenerDatos(Convert.ToInt32(RadDropDownList1.SelectedValue));
            }

            gridHistorico.DataSource = dt;
            gridHistorico.DataBind();
        }

        private DataTable ObtenerDatosContralor(int mes, string departamento, string empleadoId)//Consulta los datos en la base de datos
        {
            DataTable dt = new DataTable();
            try
            {
                dt.Columns.Add("ID");
                dt.Columns.Add("Departamento");
                dt.Columns.Add("Nombre");
                dt.Columns.Add("Descripción");
                dt.Columns.Add("Ponderación");
                dt.Columns.Add("Indicador Minimo (50 Pts.)");
                dt.Columns.Add("Indicador Deseable (100 Pts.)");
                dt.Columns.Add("Resultado");
                dt.Columns.Add("Cumplimiento Objetivo (0-100 Pts.)");
                dt.Columns.Add("Evaluacion Ponderada");

                string query;

                if (departamento == "" && empleadoId == "")
                {
                    query = "select pli.pIndicadorId as indicadorId,  anc.Departamento, anc.Nombre_ ,pli.descripcionIndicador, concat(i.ponderacion,'%')as ponderacion,i.indicadorMinimo,i.indicadorDeseable,isnull(e.resultado,0)as resultado, " +
                        "isnull(cumplimientoOBjetivo, 0) as cumplimientoObjetivo, isnull(evaluacionPonderada, 0) as evaluacionPonderada from Indicador i " +
                        "left join PlantillaIndicador pli on pli.pIndicadorId = i.pIndicadorId left join resultadoIndicador e on i.IndicadorId = e.indicadorId " +
                        "left join Vacaciones.dbo.AdministrativosNomiChecador anc on i.empleadoId = anc.IdEmpleado where i.activo = 1 and mes = " + mes + " and año=" + año + " order by anc.Nombre_";
                }
                else if (empleadoId == "")//consulta el acumulado de todos los colaboradores de un gerente
                {
                    query = "select pli.pIndicadorId as indicadorId, anc.Departamento, anc.Nombre_ ,pli.descripcionIndicador, concat(i.ponderacion,'%')as ponderacion,i.indicadorMinimo,i.indicadorDeseable,isnull(e.resultado,0)as resultado, " +
                        "isnull(cumplimientoOBjetivo, 0) as cumplimientoObjetivo, isnull(evaluacionPonderada, 0) as evaluacionPonderada from Indicador i " +
                        "left join PlantillaIndicador pli on pli.pIndicadorId = i.pIndicadorId left join resultadoIndicador e on i.IndicadorId = e.indicadorId " +
                        "left join Vacaciones.dbo.AdministrativosNomiChecador anc on i.empleadoId = anc.IdEmpleado where i.activo = 1 and mes = " + mes + " and año=" + año + " and anc.Departamento='" + departamento + "' order by anc.Nombre_";
                }
                else //Filtrado por un colaborador en especifico
                {
                    query = "select pli.pIndicadorId as indicadorId, anc.Departamento, anc.Nombre_ ,pli.descripcionIndicador, concat(i.ponderacion,'%')as ponderacion,i.indicadorMinimo,i.indicadorDeseable,isnull(e.resultado,0)as resultado, " +
                        "isnull(cumplimientoOBjetivo, 0) as cumplimientoObjetivo, isnull(evaluacionPonderada, 0) as evaluacionPonderada from Indicador i " +
                        "left join PlantillaIndicador pli on pli.pIndicadorId = i.pIndicadorId left join resultadoIndicador e on i.IndicadorId = e.indicadorId " +
                        "left join Vacaciones.dbo.AdministrativosNomiChecador anc on i.empleadoId = anc.IdEmpleado where i.activo = 1 and mes = " + mes + " and año=" + año + " and anc.IdEmpleado=" + empleadoId + " order by anc.Nombre_";
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
                dt = new DataTable();
            }

            return dt;

        }

        private DataTable ObtenerDatosGerente(int mes, int empleadoId)//Consulta los datos en la base de datos
        {
            DataTable dt = new DataTable();
            try
            {
                dt.Columns.Add("ID");
                dt.Columns.Add("Nombre");
                dt.Columns.Add("Descripción");
                dt.Columns.Add("Ponderación");
                dt.Columns.Add("Indicador Minimo (50 Pts.)");
                dt.Columns.Add("Indicador Deseable (100 Pts.)");
                dt.Columns.Add("Resultado");
                dt.Columns.Add("Cumplimiento Objetivo (0-100 Pts.)");
                dt.Columns.Add("Evaluacion Ponderada");

                string query;

                if (empleadoId == 1)//consulta el acumulado de todos los colaboradores de un gerente
                {
                    query = "select pli.pIndicadorId as indicadorId, anc.Nombre_ ,pli.descripcionIndicador, concat(i.ponderacion,'%')as ponderacion,i.indicadorMinimo,i.indicadorDeseable,isnull(e.resultado,0)as resultado, " +
                        "isnull(cumplimientoOBjetivo, 0) as cumplimientoObjetivo, isnull(evaluacionPonderada, 0) as evaluacionPonderada from Indicador i left join PlantillaIndicador pli on pli.pIndicadorId = i.pIndicadorId " +
                        "left join resultadoIndicador e on i.IndicadorId = e.indicadorId left join Vacaciones.dbo.AdministrativosNomiChecador anc on i.empleadoId = anc.IdEmpleado " +
                        "where empleadoId in(select IdEmpleado from Vacaciones.dbo.AdministrativosNomiChecador " +
                        "where JefeInmediato = (select a.Correo from Vacaciones.dbo.AdministrativosNomiChecador a where a.IdEmpleado = " + Session["Log"] + ")) and i.activo=1 and mes = " + mes+ " and año=" + año + " order by anc.Nombre_";
                }
                else //Filtrado por un colaborador en especifico
                {
                    query = "select pli.pIndicadorId as indicadorId, anc.Nombre_ ,pli.descripcionIndicador, concat(i.ponderacion,'%')as ponderacion,i.indicadorMinimo,i.indicadorDeseable,isnull(e.resultado,0)as resultado, " +
                        "isnull(cumplimientoOBjetivo, 0) as cumplimientoObjetivo, isnull(evaluacionPonderada, 0) as evaluacionPonderada from Indicador i left join PlantillaIndicador pli on pli.pIndicadorId = i.pIndicadorId " +
                        "left join resultadoIndicador e on i.IndicadorId = e.indicadorId left join Vacaciones.dbo.AdministrativosNomiChecador anc on i.empleadoId = anc.IdEmpleado " +
                        "where empleadoId in(select IdEmpleado from Vacaciones.dbo.AdministrativosNomiChecador " +
                        "where JefeInmediato = (select a.Correo from Vacaciones.dbo.AdministrativosNomiChecador a where a.IdEmpleado = " + Session["Log"] + ")) and i.activo=1 and mes = " + mes + " and año=" + año + " and empleadoId=" + empleadoId;
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
                dt = new DataTable();
            }

            return dt;

        }

        private DataTable ObtenerDatos(int mes)//Consulta en la base de datos datos de un colaborador
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

                query = "select pli.pIndicadorId as indicadorId, pli.descripcionIndicador, concat(i.ponderacion,'%')as ponderacion,i.indicadorMinimo,i.indicadorDeseable,isnull(e.resultado,0)as resultado, " +
                "isnull(cumplimientoOBjetivo,0)as cumplimientoObjetivo, isnull(evaluacionPonderada,0)as evaluacionPonderada from Indicador i " +
                "left join PlantillaIndicador pli on pli.pIndicadorId=i.pIndicadorId left join resultadoIndicador e on i.IndicadorId=e.indicadorId where i.activo=1 and empleadoId=" + Session["Log"] + " and mes=" + mes + " and año=" + año + ";";
                

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
            string query = "select nombreArchivo, archivo from Evidencia where empleadoId=" + Session["Log"] + " and mes=" + mes + " and año=" + año + ";";

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

            //if (e.Item is GridDataItem)
            //{
            //    GridDataItem dataItem = (GridDataItem)e.Item;
            //    int currentRowIndex = dataItem.ItemIndex;

            //    if (currentRowIndex > 0)
            //    {
            //        GridDataItem previousDataItem = (GridDataItem)gridHistorico.Items[currentRowIndex - 1];

            //        if (dataItem["Nombre_"].Text == previousDataItem["Nombre_"].Text)
            //        {
            //            dataItem["Nombre_"].Visible = false;
            //            dataItem["Evidencia"].RowSpan = previousDataItem["Evidencia"].RowSpan + 1;
            //            previousDataItem["Evidencia"].RowSpan += 1;
            //        }
            //    }
            //}
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

                Label mes_ = (Label)e.Item.FindControl("mes");
                if (mes_ != null)
                {
                    mes_.Text = DateTime.Now.ToString("MMMM-yyyy", new System.Globalization.CultureInfo("es-ES"));
                }

                //Proceso para asignar la fecha del mes anterior al control radMonthyearpicker
                GridCommandItem commandItem = (GridCommandItem)e.Item;
                Telerik.Web.UI.RadMonthYearPicker radMonthYearPicker = (Telerik.Web.UI.RadMonthYearPicker)commandItem.FindControl("RadMonthYearPicker1");

                if (radMonthYearPicker != null)
                {
                    if (!cambioDeMes)
                    {
                        radMonthYearPicker.SelectedDate = DateTime.Now.AddMonths(-1);
                        cambioDeMes = true;
                    }
                    else
                    {
                        radMonthYearPicker.SelectedDate = new DateTime(Convert.ToInt32(año), Convert.ToInt32(mes), 1);
                    }
                }
            }
        }
        [WebMethod]
        public static void fechaRadMonthYearPicker(int mes, int año)
        {
            HistoricoIndicadoresM.mes = mes.ToString();
            HistoricoIndicadoresM.año = año.ToString();
        }

        protected void txtFilter_TextChanged(object sender, EventArgs e)
        {
            string filterText = txtFilter.Text.Trim();
            if (!string.IsNullOrEmpty(filterText))
            {
                string filterExpression;
                DataTable dt = new DataTable();
                // Filtrar datos en el grid basado en el texto del TextBox
                if (Session["puesto"] as string == "2")//Contralor
                {
                    dt = ObtenerDatosContralor(Convert.ToInt32(RadDropDownList1.SelectedValue), RadDropDownList3.SelectedValue.ToString(), RadDropDownList2.SelectedValue.ToString());
                    filterExpression = string.Format(
                        "Convert(indicadorId, 'System.String') LIKE '%{0}%' OR " +
                        "Convert(Departamento, 'System.String') LIKE '%{0}%' OR " +
                        "Convert(Nombre_, 'System.String') LIKE '%{0}%' OR " +
                        "Convert(descripcionIndicador, 'System.String') LIKE '%{0}%' OR " +
                        "Convert(ponderacion, 'System.String') LIKE '%{0}%' OR " +
                        "Convert(indicadorMinimo, 'System.String') LIKE '%{0}%' OR " +
                        "Convert(indicadorDeseable, 'System.String') LIKE '%{0}%' OR " +
                        "Convert(resultado, 'System.String') LIKE '%{0}%' OR " +
                        "Convert(cumplimientoObjetivo, 'System.String') LIKE '%{0}%' OR " +
                        "Convert(evaluacionPonderada, 'System.String') LIKE '%{0}%'",
                        filterText);
                }
                else if (Session["puesto"] as string == "1")
                {
                    dt = ObtenerDatosGerente(Convert.ToInt32(RadDropDownList1.SelectedValue), Convert.ToInt32(RadDropDownList2.SelectedValue));
                    filterExpression = string.Format(
                        "Convert(indicadorId, 'System.String') LIKE '%{0}%' OR " +
                        "Convert(Nombre_, 'System.String') LIKE '%{0}%' OR " +
                        "Convert(descripcionIndicador, 'System.String') LIKE '%{0}%' OR " +
                        "Convert(ponderacion, 'System.String') LIKE '%{0}%' OR " +
                        "Convert(indicadorMinimo, 'System.String') LIKE '%{0}%' OR " +
                        "Convert(indicadorDeseable, 'System.String') LIKE '%{0}%' OR " +
                        "Convert(resultado, 'System.String') LIKE '%{0}%' OR " +
                        "Convert(cumplimientoObjetivo, 'System.String') LIKE '%{0}%' OR " +
                        "Convert(evaluacionPonderada, 'System.String') LIKE '%{0}%'",
                        filterText);
                }
                else
                {
                    dt = ObtenerDatos(Convert.ToInt32(RadDropDownList1.SelectedValue));
                    filterExpression = string.Format(
                        "Convert(indicadorId, 'System.String') LIKE '%{0}%' OR " +
                        "Convert(descripcionIndicador, 'System.String') LIKE '%{0}%' OR " +
                        "Convert(ponderacion, 'System.String') LIKE '%{0}%' OR " +
                        "Convert(indicadorMinimo, 'System.String') LIKE '%{0}%' OR " +
                        "Convert(indicadorDeseable, 'System.String') LIKE '%{0}%' OR " +
                        "Convert(resultado, 'System.String') LIKE '%{0}%' OR " +
                        "Convert(cumplimientoObjetivo, 'System.String') LIKE '%{0}%' OR " +
                        "Convert(evaluacionPonderada, 'System.String') LIKE '%{0}%'",
                        filterText);
                }
                DataView dv = dt.DefaultView;

                

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

        protected void RadDropDownList3_SelectedIndexChanged(object sender, DropDownListEventArgs e)
        {

            RadDropDownList2.Items.Clear();//Limpia los items anteriores 
            if (RadDropDownList3.Items[0].Text== "SELECCIONA UNA OPCIÓN")//quita el primer indice default
            {
                RadDropDownList3.Items.RemoveAt(0);
            }
            

            using (var con = new SqlConnection(conn))
            {
                con.Open();
                using (var cmd = new SqlCommand("selecT Nombre_, IdEmpleado from Vacaciones.dbo.AdministrativosNomiChecador where Departamento='" + RadDropDownList3.SelectedValue + "';", con))
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.Text;
                    SqlDataReader reader = cmd.ExecuteReader();
                    RadDropDownList2.Items.Add(new DropDownListItem("SELECCIONA UNA OPCIÓN", ""));//Valor default
                    while (reader.Read())
                    {
                        RadDropDownList2.Items.Add(new DropDownListItem(reader["Nombre_"].ToString(), reader["IdEmpleado"].ToString()));
                    }
                }
            }
            CargarDatosEnGrid();
        }

        protected void gridHistorico_ItemCommand(object sender, GridCommandEventArgs e)
        {
            if (e.CommandName == "Evidencia")
            {
                string indicadorId = e.CommandArgument.ToString();
                // Aquí puedes manejar el comando, por ejemplo, mostrar una ventana modal con la evidencia
                // o redirigir a otra página.
                // Response.Redirect($"Evidencia.aspx?id={indicadorId}");
                // O mostrar un popup/modal
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", $"alert('Ver evidencia para ID: {indicadorId}');", true);
            }
        }
    }
}