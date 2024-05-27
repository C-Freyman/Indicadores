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
                    //cumplimientoObjetivo = ((1 / ((indicadorDeseable - indicadorMinimo) * 2.00)) * (valor - indicadorMinimo) * 100.00) + 50.00;
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
                    //cumplimientoObjetivo = ((1 / ((indicadorMinimo - indicadorDeseable) * 2.00)) * (indicadorMinimo - valor) * 100.00) + 50.00;
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

            using (var con = new SqlConnection("Server=187.174.147.102; User ID=sa; password=similares*3; DataBase=Indicadores;"))
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
            using (var con = new SqlConnection("Server=187.174.147.102; User ID=sa; password=similares*3; DataBase=Indicadores;"))
            {
                con.Open();
                foreach (var row in tableData)
                {
                    using (var command = new SqlCommand())
                    {
                        command.Connection = con;
                        command.CommandText = "update Evidencia set fechaBorrador=getdate(), resultado=" + row.Resultado + ", cumplimientoOBjetivo=" + row.CumplimientoObjetivo + ",evaluacionPonderada=" + row.EvaluacionPonderada.Replace("%", "") + " " +
                            "where indicadorId=(select indicadorId from Indicador where asignacionId=(select asignacionId from Asignacion where pIndicadorId=" + row.IndicadorId + ")) and mes=1 and año=2024";
                        command.CommandType = CommandType.Text;
                        command.ExecuteNonQuery();
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
    }
}