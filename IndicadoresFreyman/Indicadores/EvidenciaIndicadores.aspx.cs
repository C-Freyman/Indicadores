using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using Telerik.Web.UI.Skins;
using System.Collections;
using System.Diagnostics;
using System.Web.Services;
using Telerik.Web;
using System.IO;
using System.Web.UI.HtmlControls;
using Newtonsoft.Json;
using Telerik.Web.UI.Chat;
using System.Runtime.InteropServices.ComTypes;

namespace IndicadoresFreyman.Indicadores
{
    public partial class EvidenciaIndicadores : System.Web.UI.Page
    {
        static protected string conn = "Server = 187.174.147.102; User ID = sa; password=similares*3; DataBase=Indicadores;";
        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //string fileName = GetFileNameFromDatabase();
                //if (!string.IsNullOrEmpty(fileName))
                //{
                //    // Mostrar el nombre del archivo en un control de texto
                //    //lblFileName.Text = fileName;
                //}

                Session["UploadedFile"] = null;
                Session["UploadedFileName"] = null;
            }
 
        }

        private string GetFileNameFromDatabase()
        {
            string query = "SELECT nombreArchivo FROM Evidencia WHERE mes=1 and año=2024 and empleadoId=3246;";
            string fileName = null;

            using (SqlConnection connection = new SqlConnection(conn))
            {
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    connection.Open();
                    SqlDataReader reader = command.ExecuteReader();
                    if (reader.Read())
                    {
                        fileName = reader["nombreArchivo"].ToString();
                    }
                }
            }

            return fileName;
        }



        //private bool CargarArchivo(FileUpload fileUpload)
        //{
        //    string path = Server.MapPath("~/Indicadores/");
        //    bool fileOK = false;

        //    if (fileUpload.HasFile)
        //    {
        //        string fileExtension = System.IO.Path.GetExtension(fileUpload.FileName).ToLower();
        //         string[] allowedExtensions = { ".jpeg", ".jpg", ".png", ".pdf" };
        //        //string[] allowedExtensions = { ".pdf" };

        //        for (int i = 0; i < allowedExtensions.Length; i++)
        //        {
        //            if (fileExtension == allowedExtensions[i])
        //            {
        //                fileOK = true;
        //                break;
        //            }
        //        }

        //        if (fileOK)
        //        {
        //            byte[] fileBytes;
        //            using (MemoryStream ms = new MemoryStream())
        //            {
        //                fileUpload.FileContent.CopyTo(ms);
        //                fileBytes = ms.ToArray();
        //            }
        //            try
        //            {
        //                string nombreArchivo = fileUpload.FileName;
        //                string query = "if not exists(select* from Evidencia where mes=1 and año=2024 and empleadoId=3246) " +
        //                                    "begin " +
        //                                    "insert into Evidencia values(3246,1,2024,'" + nombreArchivo + "',null,@archivo); " +
        //                                "end " +
        //                                "else " +
        //                                    "begin " +
        //                                    "update Evidencia set nombreArchivo='" + nombreArchivo + "', archivo=@archivo where empleadoId=3246 and mes=1 and año=2024 " +
        //                                "end";

        //                using (SqlConnection connection = new SqlConnection(conn))
        //                {
        //                    using (SqlCommand command = new SqlCommand(query, connection))
        //                    {
        //                        command.Parameters.Add("@archivo", SqlDbType.VarBinary).Value = fileBytes;

        //                        connection.Open();
        //                        command.ExecuteNonQuery();
        //                    }
        //                }


        //            }
        //            catch (Exception)
        //            {
        //                return false;
        //            }
        //        }
        //        else
        //        {
        //            Response.Write("<script language='JavaScript'>alert('Este formato no es admitido. Solo se aceptan formato PDF');</script>");
        //        }
        //    }
        //    else
        //    {
              
        //    }
        //    return true;
        //}

        [WebMethod]
        public static void SaveEditorValue(string editorValue)
        {
            
            Debug.WriteLine("Editor Value: " + editorValue);
        }

        protected void gridEvidencias_BatchEditCommand(object sender, GridBatchEditingEventArgs e)
        {
            
        }
        

        public void calcularResultados(bool esAscendente, double valor, int indicadorMinimo, int indicadorDeseable, int ponderacion, out double cumplimientoObjetivo, out double evaluacionPonderada)
        {

            if (esAscendente)
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
            }
            else
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
            }
            evaluacionPonderada = Math.Round((ponderacion / 100.00) * cumplimientoObjetivo,2);

            
        }

        [WebMethod]
        public static object SaveRowValues(string filaHTML, string valorEditado)
        {
            string id = filaHTML.Substring(0, filaHTML.IndexOf('\t'));

            bool esAscendente = false;
            int ponderacion = 0, indicadorMinimo = 0, indicadorDeseable = 0;

            using (var con = new SqlConnection(conn))
            {
                con.Open();
                using (var command = new SqlCommand())
                {
                    command.Connection = con;
                    command.CommandText = "select pli.esAscendente, pli.TipoId,i.ponderacion,i.indicadorMinimo, i.indicadorDeseable from PlantillaIndicador pli" +
                        " left join Asignacion a on pli.pIndicadorId=a.pIndicadorId left join Indicador i on a.asignacionId=i.asignacionId where pli.pIndicadorId=" + id + ";";
                    command.CommandType = CommandType.Text;
                    SqlDataReader reader = command.ExecuteReader();
                    while (reader.Read())
                    {
                        esAscendente = Convert.ToBoolean(reader["esAscendente"]);
                        ponderacion = Convert.ToInt32(reader["ponderacion"]);
                        indicadorMinimo = Convert.ToInt32(reader["indicadorMinimo"]);
                        indicadorDeseable = Convert.ToInt32(reader["indicadorDeseable"]);
                    }
                }
            }
            double cumplimientoObjetivo, evaluacionPonderada;
            var obj = new EvidenciaIndicadores();
            obj.calcularResultados(esAscendente,Convert.ToDouble( valorEditado),indicadorMinimo,indicadorDeseable,ponderacion,out cumplimientoObjetivo, out evaluacionPonderada);
            return new
            {
                cumplimientoObjetivo,
                evaluacionPonderada
            };
        }

        [WebMethod]
        public static void GuardarBorrador(List<MyDataModel> tableData)
        {
            
            using (var con = new SqlConnection(conn))
            {
                con.Open();
                foreach (var row in tableData)
                {
                    using (var command = new SqlCommand())
                    {
                        command.Connection = con;
                        command.CommandText = "update resultadoIndicador set fechaBorrador=getdate(), resultado=" + row.Resultado + ", cumplimientoOBjetivo=" + row.CumplimientoObjetivo + ",evaluacionPonderada=" + row.EvaluacionPonderada.Replace("%", "") + " " +
                            "where indicadorId=(select indicadorId from Indicador where asignacionId=(select asignacionId from Asignacion where pIndicadorId=" + row.IndicadorId + ")) and mes=1 and año=2024";
                        command.CommandType = CommandType.Text;
                        command.ExecuteNonQuery();
                    }   
                }
            }
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

                footerItem["evaluacionPonderada"].Text = "TOTAL: " + totalEvaluacionPonderada.ToString("N2");
            }
        }

        //protected void archivos_Click(object sender, EventArgs e)
        //{
        //    CargarArchivo(FileUpload1);
        //}


        protected void RadAsyncUpload1_FileUploaded(object sender, FileUploadedEventArgs e)
        {
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
                    string query = "if not exists(select* from Evidencia where mes=1 and año=2024 and empleadoId=3246) " +
                                        "begin " +
                                        "insert into Evidencia values(3246,1,2024,'" + nombreArchivo + "',null,@archivo," + tamaño + "); " +
                                    "end " +
                                    "else " +
                                        "begin " +
                                        "update Evidencia set nombreArchivo='" + nombreArchivo + "', archivo=@archivo, tamaño=" + tamaño + " where empleadoId=3246 and mes=1 and año=2024 " +
                                    "end";

                    using (SqlConnection connection = new SqlConnection(conn))
                    {
                        using (SqlCommand command = new SqlCommand(query, connection))
                        {
                            command.Parameters.Add("@archivo", SqlDbType.VarBinary).Value = fileData;

                            connection.Open();
                            command.ExecuteNonQuery();
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
                ltrNoResults.Visible = true;
                Repeater1.Visible = false;
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
    }
}