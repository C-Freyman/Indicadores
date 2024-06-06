using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using static Telerik.Web.UI.OrgChartStyles;

namespace IndicadoresFreyman
{
    public partial class crearIndicadores : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                hdnArea.Value = "1";
                radGridIndicador.MasterTableView.CommandItemSettings.AddNewRecordText = "Agregar indicador";
                radGridIndicador.MasterTableView.CommandItemSettings.RefreshText = "Refrescar";

              

            }
        }

       

        protected void radGridIndicador_ItemDeleted(object sender, Telerik.Web.UI.GridDeletedEventArgs e)
        {
            Label1.Text = "";
            Label2.Text = "";
            string error = "";
            if (e.Exception != null)
            {
                e.ExceptionHandled = true;
                DisplayMessage(true, "Indicador no puedo eliminar Debido: " + e.Exception.Message);

            }
            else
            {
                error = e.ToString();
                // DisplayMessage(true, "Indicador guardado");
                //NotifyUser("Indicador guardado");
                DisplayMessage(false, "Indicador se borro exitosamente");
            }
        }

        protected void radGridIndicador_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {

        }

        protected void radGridIndicador_ItemInserted(object sender, Telerik.Web.UI.GridInsertedEventArgs e)
        {
            Label1.Text = "";
            Label2.Text = "";
            string error = "";


            if (e.Exception != null)
            {
                e.ExceptionHandled = true;
                DisplayMessage(true, "Indicador no puedo ser guardado Debido: " + e.Exception.Message);

            }
            else
            {
                error = e.ToString();
                // DisplayMessage(true, "Indicador guardado");
                //NotifyUser("Indicador guardado");
                DisplayMessage(false, "Indicador guardado exitosamente");
            }
        }

        

        protected void radGridIndicador_ItemUpdated(object sender, Telerik.Web.UI.GridUpdatedEventArgs e)
        {
            Label1.Text = "";
            Label2.Text = "";
            GridEditableItem item = (GridEditableItem)e.Item;
            string id = item.GetDataKeyValue("pIndicadorId").ToString();
            string descripcionIndicador = item["descripcionIndicador"].Text;


            if (e.Exception != null)
            {
                e.KeepInEditMode = true;
                e.ExceptionHandled = true;
                string error = e.Exception.Message;
                DisplayMessage(true, "Indicador " + descripcionIndicador + " no se puede actualizar. Debido: " + e.Exception.Message);
                //NotifyUser("Product with ID " + id + " cannot be updated. Reason: " + e.Exception.Message);
            }
            else
            {
                DisplayMessage(false, "Indicador actualizado");

            }
        }

        private void DisplayMessage(string text)
        {
            radGridIndicador.Controls.Add(new LiteralControl(string.Format("<span style='color:red'>{0}</span>", text)));
        }


        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
        }


        protected void SqlIndicador_Updating(object sender, SqlDataSourceCommandEventArgs e)
        {
            // gridDataItem item = (GridDataItem)e.Item;
            hdnProyecto.Value = "1";//item.GetDataKeyValue("pIndicadorId").ToString();

        }

        protected void SqlIndicador_Inserting(object sender, SqlDataSourceCommandEventArgs e)
        {
            hdnProyecto.Value = "1";//item.GetDataKeyValue("pIndicadorId").ToString();
        }

        protected void txtindicadorDeseable_TextChanged(object sender, EventArgs e)
        {
            int minimo = 0;
        }
    }
}