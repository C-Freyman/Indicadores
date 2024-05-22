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

namespace IndicadoresFreyman.Indicadores
{
    public partial class EvidenciaIndicadores : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Llenar el RadGrid con datos de la base de datos
                //gridEvidencias.DataSource = ObtenerDatosDesdeDB();
                //gridEvidencias.DataBind();
                
            }
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            
        }

        private DataTable ObtenerDatosDesdeDB()
        {
            
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection("Server=34.203.98.187; User ID=sa; password=similares*3; DataBase=Indicadores;"))
            {
                string query = "select i.pIndicadorId,i.descripcionIndicador, i.ponderacion,i.indicadorMinimo,i.indicadorDeseable,isnull(e.resultado,0)as resultado,e.cumplimientoOBjetivo,e.evaluacionPonderada " +
                    "from Indicadores.dbo.plantillaIndicador i left join Indicadores.dbo.Asignacion a on i.pIndicadorId=a.indicadorId left join Indicadores.dbo.Evidencia e on a.asignacionId=e.asignacionId " +
                    "where empleadoId=13178;";
                using (SqlDataAdapter adapter = new SqlDataAdapter(query, conn))
                {
                    adapter.Fill(dt);
                }
            }
            return dt;
        }

        [WebMethod]
        public static void SaveEditorValue(string editorValue)
        {
            
            Debug.WriteLine("Editor Value: " + editorValue);
        }

        [WebMethod]
        public static void UploadFile()
        {
            HttpPostedFile file = HttpContext.Current.Request.Files["archivo"];
            if (file != null)
            {
                string savePath = HttpContext.Current.Server.MapPath("~/Uploads/") + file.FileName;
                file.SaveAs(savePath);

                // Aquí puedes agregar lógica adicional para guardar la información del archivo en la base de datos
                System.Diagnostics.Debug.WriteLine("Archivo guardado en: " + savePath);
            }
        }
    }
}