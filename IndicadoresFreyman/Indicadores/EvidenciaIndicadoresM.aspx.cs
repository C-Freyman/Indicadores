using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using System.Diagnostics;
using System.Web.Services;
using System.IO;
using System.Drawing;
using Telerik.Web.UI.PdfViewer;
using Telerik.Web.UI.Skins;
using System.Runtime.CompilerServices;
using System.Web;

namespace IndicadoresFreyman.Indicadores
{
    public partial class EvidenciaIndicadoresM : System.Web.UI.Page
    {
        static protected string conn = "Server = 187.174.147.102; User ID = sa; password=similares*3; DataBase=Indicadores;";
        public bool archivoGuardado;
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
               // Session["Log"] = "3246";
                ValidarTablaBD();//Procedure para validar si existe o no el registro del mes 
                
                DatosUsuario();//Carga el nombre de la persona en label

                if (Session["mes"]== null)
                {
                    Session["mes"] = DateTime.Now.AddMonths(-1).Month.ToString();
                    Session["año"] = DateTime.Now.Year.ToString();
                    cargarDatosEnGrid(Session["mes"]as string, Session["año"] as string);//Carga datos en grid
                    ValidarArchivoEvidencia(DateTime.Now.AddMonths(-1).Month, DateTime.Now.Year);//FileRepeater
                    
                }
                else
                {
                    cargarDatosEnGrid(Session["mes"].ToString(), Session["año"].ToString());
                    ValidarArchivoEvidencia(Convert.ToInt32(Session["mes"]), Convert.ToInt32(Session["año"]));
                }
            }
            else
            {
                cargarDatosEnGrid(Session["mes"].ToString(), Session["año"].ToString());
                ValidarArchivoEvidencia(Convert.ToInt32(Session["mes"]), Convert.ToInt32(Session["año"]));
            }
            ValidacionIndicadoresCerrado();

            ValidarIndicadoresPasados();

        }

        private void ValidarTablaBD()//Procedure para validar si existe o no el registro del mes 
        {
            try
            {
                using (var con = new SqlConnection(conn))
                {
                    con.Open();
                    using (var cmd = new SqlCommand("validarTablaResultado", con))
                    {
                        cmd.Connection = con;
                        cmd.Parameters.AddWithValue("empleadoId", Session["Log"]);
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {

            }
        }
        private void cargarDatosEnGrid(string mes, string año)
        {
            DataTable tb= new DataTable();
            tb = consultaTablaResultados(mes, año);
            gridEvidencias.DataSource = tb;
            gridEvidencias.DataBind();
        }

        private DataTable consultaTablaResultados(string mes, string año)
        {
            DataTable tb= new DataTable();
            tb.Columns.Add("indicadorId");
            tb.Columns.Add("descripcionIndicador");
            tb.Columns.Add("ponderacion");
            tb.Columns.Add("indicadorMinimo");
            tb.Columns.Add("indicadorDeseable");
            tb.Columns.Add("resultado");
            tb.Columns.Add("cumplimientoObjetivo");
            tb.Columns.Add("evaluacionPonderada");
            tb.Columns.Add("cumplimientoOBjetivoReal");
            try
            {
                using (var con = new SqlConnection(conn))
                {
                    con.Open();
                    using (var cmd = new SqlCommand("gridResultados", con))
                    {
                        cmd.Connection = con;
                        cmd.Parameters.AddWithValue("empleadoId", Session["Log"]);
                        cmd.Parameters.AddWithValue("mes", mes);
                        cmd.Parameters.AddWithValue("año", año);
                        cmd.CommandType = CommandType.StoredProcedure;

                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        da.Fill(tb);
                    }
                }
            }
            catch (Exception)
            {
                tb = new DataTable();
            }
            
            return tb;
        }

        public string CargarEstilosCumplimiento(decimal valor)//Estilos en columna Cumplimiento del Objetivo
        {
            string estilo = "";

            if (valor >= 90)
            {
                estilo = "badge badge-pill badge-success";
            }
            else if (valor >= 80)
            {
                estilo = "badge badge-pill badge-warning";
            }
            else
            {
                estilo = "badge badge-pill badge-danger";
            }

            return estilo;
        }

        private void ValidacionIndicadoresCerrado()
        {
            string query = "select top 1  isnull(cast(fechaCerrado as varchar(10)),'1') as fechaCerrado from resultadoIndicador ri left join Indicador i on ri.indicadorId=i.IndicadorId where mes=" + Session["mes"] + " and año=" + Session["año"] + " and activo=1 and empleadoId=" + Session["Log"];
            string cerrado = "";
            using (SqlConnection con = new SqlConnection(conn))
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        cerrado = reader["fechaCerrado"].ToString();
                    }
                }
            }
            if (cerrado != "1")
            {
                (gridEvidencias.MasterTableView.GetColumn("resultado") as GridBoundColumn).ReadOnly = true;
                gridEvidencias.MasterTableView.GetColumn("resultado").ItemStyle.BackColor = ColorTranslator.FromHtml("#74C99B");
                RadAsyncUpload1.Visible = false;
                button1.Visible = false;
                etiquetaCerrado.Visible = true;
            }
            else
            {
                etiquetaCerrado.Visible = false;
            }
        }

        private void DatosUsuario()//Datos del usuario
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

        private void ValidarArchivoEvidencia(int mes, int año)//Datos del mes
        {

            DataTable dt = ConsultaArchivo(mes, año);
            if (dt.Rows.Count > 0)
            {
                ltrNoResults.Visible = false;
                Repeater1.DataSource = dt;
                Repeater1.DataBind();
                archivoGuardado = true;
            }
            else
            {
                ltrNoResults.Visible = true;
                archivoGuardado = false;
            }
        }

        private DataTable ConsultaArchivo(int mes, int año)
        {
            DataTable dt = new DataTable();
            string query = "SELECT nombreArchivo as FileName, tamaño as ContentLength FROM Evidencia WHERE empleadoId =  " + Session["Log"] + " AND mes = " + mes + " AND año =" + año;

            using (SqlConnection con = new SqlConnection(conn))
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt);
                }
            }

            return dt;
        }

        private bool ValidarIndicadoresPasados()//Valida si tiene meses pasados sin subir indicadores
        {
            //En caso de tener pendientes se asigna true
            //En caso de no tener pendientes se asigna false
            bool result;
            try
            {
                string mes = DateTime.Now.AddMonths(-1).Month.ToString();
                string año = DateTime.Now.Year.ToString();
                using (var con = new SqlConnection(conn))
                {
                    con.Open();
                    using (var cmd = new SqlCommand("selecT mes, count(*) from Indicador i left join resultadoIndicador ri on i.IndicadorId=ri.indicadorId " +
                        "where ri.mes<" + mes + " and año="+ año +" and i.empleadoId=" + Session["Log"] + " group by mes;", con))
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.Text;
                        SqlDataReader reader = cmd.ExecuteReader();
                        if (reader.HasRows)
                        {
                            result = true;
                        }
                        else
                        {
                            result = false;
                        }
                    }
                }
            }
            catch 
            {
                result = false;
            }
            return result;
        }


        [WebMethod]
        public static void SaveEditorValue(string editorValue)
        {

            Debug.WriteLine("Editor Value: " + editorValue);
        }


        public void calcularResultados(bool esAscendente, double valor, int indicadorMinimo, int indicadorDeseable, int ponderacion, out double cumplimientoObjetivo, out double evaluacionPonderada, out double cumplimientoObjetivoReal)
        {
            cumplimientoObjetivo = 0;
            cumplimientoObjetivoReal = 0;
            if (indicadorMinimo>indicadorDeseable)
            {
                
                if (valor < indicadorMinimo)
                {
                    cumplimientoObjetivo = 0;
                }
                else if (valor >= indicadorMinimo && valor <= indicadorDeseable)
                {
                    cumplimientoObjetivo = Math.Round(((1 / ((indicadorDeseable - indicadorMinimo) * 2.00)) * (valor - indicadorMinimo) * 100.00) + 50.00, 2);
                }
                else
                {
                    cumplimientoObjetivo = 100;
                }
                cumplimientoObjetivoReal= Math.Round(((1 / ((indicadorDeseable - indicadorMinimo) * 2.00)) * (valor - indicadorMinimo) * 100.00) + 50.00, 2);
            }
            else if (indicadorMinimo < indicadorDeseable)
            {
                // Caso donde valorMinimo es mayor que valorDeseable
                if (valor > indicadorMinimo)
                {
                    cumplimientoObjetivo = 0;
                }
                else if (valor <= indicadorMinimo && valor >= indicadorDeseable)
                {
                    cumplimientoObjetivo = Math.Round(((1 / ((indicadorMinimo - indicadorDeseable) * 2.00)) * (indicadorMinimo - valor) * 100.00) + 50.00, 2);
                }
                else
                {
                    cumplimientoObjetivo = 100;
                }
                cumplimientoObjetivoReal = Math.Round(((1 / ((indicadorMinimo - indicadorDeseable) * 2.00)) * (indicadorMinimo - valor) * 100.00) + 50.00, 2);
            }
            else if (indicadorMinimo == indicadorDeseable)//Por actividad
            {
                if (valor >= indicadorDeseable)
                {
                    cumplimientoObjetivo = 100;
                    cumplimientoObjetivoReal = 100;
                }
                else if (valor < indicadorMinimo)
                {
                    cumplimientoObjetivo = 0;
                    cumplimientoObjetivoReal = 0;
                }
            }
            evaluacionPonderada = Math.Round((ponderacion / 100.00) * cumplimientoObjetivo, 2);


        }

        [WebMethod]
        public static object SaveRowValues(string filaHTML, string valorEditado)
        {
            string id = filaHTML.Substring(0, filaHTML.IndexOf('\t'));
            var obj = new EvidenciaIndicadoresM();

            bool esAscendente = false;
            int ponderacion = 0, indicadorMinimo = 0, indicadorDeseable = 0;

            using (var con = new SqlConnection(conn))
            {
                con.Open();
                using (var command = new SqlCommand())
                {
                    command.Connection = con;
                    command.CommandText = "select pli.esAscendente, pli.TipoId,i.ponderacion,i.indicadorMinimo, i.indicadorDeseable from PlantillaIndicador pli" +
                        " left join Indicador i on i.pIndicadorId=pli.pIndicadorId where i.pIndicadorId=" + id + " and i.activo=1 and pli.estatus=1 and empleadoId=" + obj.Session["Log"] + ";";
                    command.CommandType = CommandType.Text;
                    SqlDataReader reader = command.ExecuteReader();
                    while (reader.Read())
                    {
                        try
                        {
                            esAscendente = Convert.ToBoolean(reader["esAscendente"]);
                        }
                        catch
                        {
                            esAscendente = false;
                        }
                        ponderacion = Convert.ToInt32(reader["ponderacion"]);
                        indicadorMinimo = Convert.ToInt32(reader["indicadorMinimo"]);
                        indicadorDeseable = Convert.ToInt32(reader["indicadorDeseable"]);
                    }
                }
            }
            double cumplimientoObjetivo, evaluacionPonderada, cumplimientoObjetivoReal;

            obj.calcularResultados(esAscendente, Convert.ToDouble(valorEditado), indicadorMinimo, indicadorDeseable, ponderacion, out cumplimientoObjetivo, out evaluacionPonderada, out cumplimientoObjetivoReal);
            return new
            {
                cumplimientoObjetivo,
                evaluacionPonderada,
                cumplimientoObjetivoReal
            };
        }

        [WebMethod]
        public static void GuardarBorrador(List<MyDataModel> tableData)
        {
            string mes = HttpContext.Current.Session["mes"].ToString();
            string año = HttpContext.Current.Session["año"].ToString();
            var obj = new EvidenciaIndicadoresM();
            using (var con = new SqlConnection(conn))
            {
                con.Open();
                foreach (var row in tableData)
                {
                    using (var command = new SqlCommand())
                    {
                        command.Connection = con;
                        command.CommandText = "update resultadoIndicador set fechaBorrador=getdate(), resultado=" + row.Resultado + ", cumplimientoOBjetivo=" + row.CumplimientoObjetivo + ",evaluacionPonderada=" + row.EvaluacionPonderada.Replace("%", "") + ", cumplimientoOBjetivoReal= " + row.CumplimientoObjetivoReal +
                            " where indicadorId=(select indicadorId from Indicador where pIndicadorId=" + row.IndicadorId + "and activo=1 and empleadoId=" + obj.Session["Log"] + " ) and mes=" + mes + " and año=" + año + " and fechaCerrado is null";
                        command.CommandType = CommandType.Text;
                        command.ExecuteNonQuery();
                    }
                }
            }
        }

        [WebMethod]
        public static void cerrarCambios(List<MyDataModel> tableData)
        {
            var obj = new EvidenciaIndicadoresM();
            string mes = HttpContext.Current.Session["mes"].ToString();
            string año = HttpContext.Current.Session["año"].ToString();
            
            using (var con = new SqlConnection(conn))
            {
                con.Open();
                foreach (var row in tableData)
                {
                    using (var command = new SqlCommand())
                    {
                        command.Connection = con;
                        command.CommandText = "update resultadoIndicador set fechaCerrado=getdate(), resultado=" + row.Resultado + ", cumplimientoOBjetivo=" + row.CumplimientoObjetivo + ",evaluacionPonderada=" + row.EvaluacionPonderada.Replace("%", "") + " ,cumplimientoOBjetivoReal=" + row.CumplimientoObjetivoReal +
                            " where indicadorId=(select indicadorId from Indicador where pIndicadorId=" + row.IndicadorId + " and empleadoId=" + obj.Session["Log"] + " and activo=1 ) and mes=" + mes + " and año=" + año;
                        command.CommandType = CommandType.Text;
                        command.ExecuteNonQuery();
                    }
                }
            }
        }

        [WebMethod]
        public static void fechaRadMonthYearPicker(int mes, int año)
        {
            HttpContext.Current.Session["mes"] = mes.ToString();
            HttpContext.Current.Session["año"] = año.ToString();
        }

        protected void gridEvidencias_ItemDataBound(object sender, GridItemEventArgs e)
        {

            if (e.Item is GridFooterItem)
            {
                GridFooterItem footerItem = e.Item as GridFooterItem;
                decimal totalEvaluacionPonderada = 0;

                foreach (GridDataItem item in gridEvidencias.MasterTableView.Items)
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

                //< span class="badge badge-danger" style="font-size:15px;margin-right:10px; float:right">Danger</span>
            }
            if (e.Item is GridDataItem)
            {
                GridDataItem item = e.Item as GridDataItem;
                HiddenField HidcumplimientoObjetivoReal = item["cumplimientoOBjetivoReal"].FindControl("HidcumplimientoObjetivoReal") as HiddenField;
                item["cumplimientoObjetivo"].CssClass = HidcumplimientoObjetivoReal.Value;
                item["cumplimientoObjetivo"].ToolTip = HidcumplimientoObjetivoReal.Value;
            }
        }
        protected void RadAsyncUpload1_FileUploaded(object sender, FileUploadedEventArgs e)
        {
            if (RadAsyncUpload1.UploadedFiles.Count > 1)
            {
                // If more than one file is uploaded, show an error and return
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Solo se puede seleccionar un archivo');", true);
                return;
            }
            if (e.File != null)
            {
                // Convert file to byte array
                byte[] fileData;
                using (var ms = new MemoryStream())
                {
                    e.File.InputStream.CopyTo(ms);
                    fileData = ms.ToArray();
                }

                try
                {
                    string nombreArchivo = e.File.FileName;
                    long tamaño = e.File.ContentLength;

                    string query = "if (select top 1 fechaCerrado from resultadoIndicador where mes=" + Session["mes"] + " and año=" + Session["año"] + " and indicadorId=(select top 1 indicadorId from Indicador where empleadoId=" + Session["Log"] + " and activo=1)) is null begin " +
                                    "if not exists(select* from Evidencia where mes=" + Session["mes"] + " and año=" + Session["mes"] + " and empleadoId=" + Session["Log"] + ") " +
                                        "begin " +
                                        "insert into Evidencia values(" + Session["Log"] + "," + Session["mes"] + "," + Session["año"] + ",'" + nombreArchivo + "',null,@archivo," + tamaño + ", getdate() ); " +
                                    "end " +
                                    "else " +
                                        "begin " +
                                        "update Evidencia set nombreArchivo='" + nombreArchivo + "', archivo=@archivo, tamaño=" + tamaño + " where empleadoId=" + Session["Log"] + " and mes=" + Session["mes"] + " and año=" + Session["año"] + " " +
                                    "end end";

                    using (SqlConnection connection = new SqlConnection(conn))
                    {
                        using (SqlCommand command = new SqlCommand(query, connection))
                        {
                            command.Parameters.Add("@archivo", SqlDbType.VarBinary).Value = fileData;

                            connection.Open();
                            int i = command.ExecuteNonQuery();

                            archivoGuardado = (i > 0) ? true : false;
                        }
                    }


                }
                catch (Exception ex)
                {
                    // Register a script to display an alert with the error message
                    string errorMessage = ex.Message.Replace("'", "\\'"); // Escape single quotes
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('Error: {errorMessage}');", true);
                }
            }

        }

        protected void button1_Click(object sender, EventArgs e)
        {
            if (RadAsyncUpload1.UploadedFiles.Count > 0)
            {
                ltrNoResults.Visible = false;
                Repeater1.Visible = true;
                Repeater1.DataSource = RadAsyncUpload1.UploadedFiles;
                Repeater1.DataBind();
            }
            else
            {
                //ltrNoResults.Visible = true;
                //Repeater1.Visible = false;
            }
        }

        protected void gridEvidencias_ItemCreated(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridCommandItem)
            {
                Label labelNombre = (Label)e.Item.FindControl("nombreColaborador");
                if (labelNombre != null)
                {
                    labelNombre.Text = "Nombre del Colaborador: " + HiddenLabel.Text;
                }


                //Proceso para asignar la fecha del mes anterior al control radMonthyearpicker
                GridCommandItem commandItem = (GridCommandItem)e.Item;
                Telerik.Web.UI.RadMonthYearPicker radMonthYearPicker = (Telerik.Web.UI.RadMonthYearPicker)commandItem.FindControl("RadMonthYearPicker1");

                if (radMonthYearPicker != null)
                {
                    if (Session["mes"] == null)
                    {
                        radMonthYearPicker.SelectedDate = DateTime.Now.AddMonths(-1);
                    }
                    else
                    {
                        var mes = Session["mes"];
                        var año = Session["año"];
                        radMonthYearPicker.SelectedDate = new DateTime(Convert.ToInt32(año), Convert.ToInt32(mes), 1);
                    }
                }
            }
        }

    }
}
// Clase del modelo de datos
public class MyDataModel
{
    public string IndicadorId { get; set; }
    public string Resultado { get; set; }
    public string CumplimientoObjetivo { get; set; }
    public string EvaluacionPonderada { get; set; }
    public string CumplimientoObjetivoReal { get; set; }

}

