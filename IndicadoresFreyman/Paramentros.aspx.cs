using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace IndicadoresFreyman
{
    public partial class Paramentros : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
               
                radGrParamentros.MasterTableView.CommandItemSettings.AddNewRecordText = "Agregar paramentro";
                radGrParamentros.MasterTableView.CommandItemSettings.RefreshText = "Refrescar";



            }
        }

        protected void radGrParamentros_ItemDeleted(object sender, Telerik.Web.UI.GridDeletedEventArgs e)
        {
            Label1.Text = "";
            Label2.Text = "";
            string error = "";
            if (e.Exception != null)
            {
                e.ExceptionHandled = true;
                DisplayMessage(true, "el Paramentro no puedo eliminar Debido: " + e.Exception.Message);

            }
            else
            {
                error = e.ToString();
                // DisplayMessage(true, "Indicador guardado");
                //NotifyUser("Indicador guardado");
                DisplayMessage(false, "Paramentro se borro exitosamente");
            }
        }

        protected void radGrParamentros_ItemUpdated(object sender, Telerik.Web.UI.GridUpdatedEventArgs e)
        {
            Label1.Text = "";
            Label2.Text = "";
            GridEditableItem item = (GridEditableItem)e.Item;
            string id = item.GetDataKeyValue("parametroId").ToString();
            string parametro = item["parametro"].Text;


            if (e.Exception != null)
            {
                e.KeepInEditMode = true;
                e.ExceptionHandled = true;
                string error = e.Exception.Message;
                DisplayMessage(true, "Paramentro " + parametro + " no se puede actualizar. Debido: " + e.Exception.Message);
                //NotifyUser("Product with ID " + id + " cannot be updated. Reason: " + e.Exception.Message);
            }
            else
            {
                DisplayMessage(false, "Paramentro actualizado");

            }
        }

        protected void radGrParamentros_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {

        }

        protected void radGrParamentros_ItemInserted(object sender, Telerik.Web.UI.GridInsertedEventArgs e)
        {
            Label1.Text = "";
            Label2.Text = "";
            string error = "";


            if (e.Exception != null)
            {
                e.ExceptionHandled = true;
                DisplayMessage(true, "Paramentro no puedo ser guardado Debido: " + e.Exception.Message);

            }
            else
            {
                error = e.ToString();
                // DisplayMessage(true, "Indicador guardado");
                //NotifyUser("Indicador guardado");
                DisplayMessage(false, "Paramentro guardado exitosamente");
            }
        }


        private void DisplayMessage(string text)
        {
            radGrParamentros.Controls.Add(new LiteralControl(string.Format("<span style='color:red'>{0}</span>", text)));
        }


        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
        }
    }
}