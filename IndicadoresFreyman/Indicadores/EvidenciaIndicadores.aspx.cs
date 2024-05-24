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

        [WebMethod]
        public static void SaveEditorValue(string editorValue)
        {
            
            Debug.WriteLine("Editor Value: " + editorValue);
        }

        protected void gridEvidencias_BatchEditCommand(object sender, GridBatchEditingEventArgs e)
        {

        }

        protected void GuardarBorradorButton_Click(object sender, EventArgs e)
        {
            // Lógica para guardar el borrador
            // Obteniendo los datos del RadGrid

            List<MyDataModel> borradorData = new List<MyDataModel>();

            foreach (GridDataItem item in gridEvidencias.MasterTableView.Items)
            {
                string indicadorId = item["IndicadorId"].Text;
                string descripcionIndicador = item["descripcionIndicador"].Text;
                string ponderacion = item["ponderacion"].Text;
                string indicadorMinimo = item["indicadorMinimo"].Text;
                string indicadorDeseable = item["indicadorDeseable"].Text;
                string resultado = item["resultado"].Text;
                string cumplimientoObjetivo = item["cumplimientoObjetivo"].Text;
                string evaluacionPonderada = item["evaluacionPonderada"].Text;

                // Crear una instancia del modelo de datos y agregarla a la lista
                MyDataModel data = new MyDataModel
                {
                    IndicadorId = indicadorId,
                    DescripcionIndicador = descripcionIndicador,
                    Ponderacion = ponderacion,
                    IndicadorMinimo = indicadorMinimo,
                    IndicadorDeseable = indicadorDeseable,
                    Resultado = resultado,
                    CumplimientoObjetivo = cumplimientoObjetivo,
                    EvaluacionPonderada = evaluacionPonderada
                };

                borradorData.Add(data);
            }

            // Lógica para guardar el borrador en la base de datos o en una variable de sesión
            // Por ejemplo, guardar en una variable de sesión
            Session["BorradorData"] = borradorData;

            // Muestra un mensaje de confirmación
            ScriptManager.RegisterStartupScript(this, GetType(), "showalert", "alert('Borrador guardado exitosamente.');", true);
        }
        [WebMethod]
        public static void SaveRowValues(string filaHTML, string valorEditado)
        {
           
        }
        [System.Web.Services.WebMethod]
        public static void GuardarBorrador(List<Dictionary<string, object>> rows)
        {
            foreach (var row in rows)
            {
                // Procesa cada fila
                // Por ejemplo:
                string indicadorId = row["IndicadorId"].ToString();
                string descripcionIndicador = row["descripcionIndicador"].ToString();
                // Obtén otros campos de la fila

                // Guarda los cambios en la base de datos
                // Tu lógica de guardado aquí
            }
        }
    }
    // Clase del modelo de datos
    public class MyDataModel
    {
        public string IndicadorId { get; set; }
        public string DescripcionIndicador { get; set; }
        public string Ponderacion { get; set; }
        public string IndicadorMinimo { get; set; }
        public string IndicadorDeseable { get; set; }
        public string Resultado { get; set; }
        public string CumplimientoObjetivo { get; set; }
        public string EvaluacionPonderada { get; set; }
    }
}