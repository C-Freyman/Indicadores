using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using Telerik.Web.UI.Map;
using Telerik.Web.UI.Skins;
using static Telerik.Web.UI.OrgChartStyles;

namespace IndicadoresFreyman
{
    public partial class crearIndicador : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                hdnArea.Value = "1";
                radIndicador.MasterTableView.CommandItemSettings.AddNewRecordText = "Agregar indicador";
                radIndicador.MasterTableView.CommandItemSettings.RefreshText = "Refrescar";
                radIndicador.MasterTableView.CommandItemSettings.SaveChangesText = "Guardar";
                radIndicador.MasterTableView.CommandItemSettings.CancelChangesText = "Cancelar";

            }
        }

        protected void radIndicador_ItemDeleted(object sender, GridDeletedEventArgs e)
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

        protected void radIndicador_ItemInserted(object sender, GridInsertedEventArgs e)
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


       


        private void NotifyUser(string message)
        {
            RadListBoxItem commandListItem = new RadListBoxItem();
            commandListItem.Text = message;
            SavedChangesList.Items.Add(commandListItem);
        }


        protected void radIndicador_PreRender(object sender, EventArgs e)
        {
            RadNumericTextBox ponderacion = (radIndicador.MasterTableView.GetBatchColumnEditor("ponderacion") as GridNumericColumnEditor).NumericTextBox;
            ponderacion.Width = Unit.Pixel(60);
            RadNumericTextBox indicadorMinimo = (radIndicador.MasterTableView.GetBatchColumnEditor("indicadorMinimo") as GridNumericColumnEditor).NumericTextBox;
            indicadorMinimo.Width = Unit.Pixel(60);
            RadNumericTextBox indicadorDeseable = (radIndicador.MasterTableView.GetBatchColumnEditor("indicadorDeseable") as GridNumericColumnEditor).NumericTextBox;
            indicadorDeseable.Width = Unit.Pixel(60);

        }

        protected void radIndicador_BatchEditCommand(object sender, GridBatchEditingEventArgs e)
        {
            GridEditableItem item = e.Item as GridEditableItem;
            GridTextBoxColumnEditor editor = (GridTextBoxColumnEditor)item.EditManager.GetColumnEditor("descripcionIndicador");
            if (string.IsNullOrEmpty(editor.TextBoxControl.Text))
            {
                e.Canceled = true;
                RadAjaxManager.GetCurrent(Page).Alert("La descripción no puede estar vacía.");
            }
        }


        protected void radIndicador_ItemUpdated(object source, Telerik.Web.UI.GridUpdatedEventArgs e)
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
            radIndicador.Controls.Add(new LiteralControl(string.Format("<span style='color:red'>{0}</span>", text)));
        }


        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
        }


        protected void radIndicador_ItemCommand(object sender, GridCommandEventArgs e)
        {

            //if (e.CommandName == radIndicador.UpdateCommand && e.Item is GridDataItem)
            //{
            //    GridEditableItem editedItem = e.Item as GridEditableItem;
            //    TextBox nameTextBox = editedItem["NameColumn"].Controls[0] as TextBox;

            //    if (string.IsNullOrWhiteSpace(nameTextBox.Text))
            //    {
            //        e.Canceled = true;
            //        radIndicador.Controls.Add(new LiteralControl("<span style='color:red;'>Name column cannot be empty.</span>"));
            //    }
            //}

            //try
            //{
            //    if (e.CommandName == RadGrid.SelectCommandName && e.Item is GridDataItem)
            //    {
            //        GridDataItem item = (GridDataItem)e.Item;

            //    }

            //    if (e.CommandName == RadGrid.UpdateCommandName && e.Item is GridDataItem)
            //    {
            //        GridDataItem item = (GridDataItem)e.Item;
            //        hdnProyecto.Value = item.GetDataKeyValue("pIndicadorId").ToString();
            //        //String id = item.GetDataKeyValue("pIndicadorId").ToString();
            //        string descripcionIndicador = item["descripcionIndicador"].Text;
            //        string ponderacion = item["ponderacion"].Text;
            //        string indicadorMinimo = item["indicadorMinimo"].Text;
            //        string indicadorDeseable = item["indicadorDeseable"].Text;
            //        //string  Tipoid = ((RadDropDownList)item.FindControl("ddlTipo")).SelectedValue;


            //    }
            //}
            //catch (Exception ex)
            //{
            //    string error = ex.Message;
            //}
        }

        protected void SqlIndicador_Updating(object sender, SqlDataSourceCommandEventArgs e)
        {
            // gridDataItem item = (GridDataItem)e.Item;
            hdnProyecto.Value =  "1";//item.GetDataKeyValue("pIndicadorId").ToString();

        }

        protected void btnguardar_Click(object sender, EventArgs e)
        {

        }

        protected void radIndicador_InsertCommand(object sender, GridCommandEventArgs e)
        {
            //GridEditableItem item = e.Item as GridEditableItem;
            //GridTextBoxColumnEditor editor = (GridTextBoxColumnEditor)item.EditManager.GetColumnEditor("descripcionIndicador");
            //if (string.IsNullOrEmpty(editor.TextBoxControl.Text))
            //{
            //    e.Canceled = true;
            //    RadAjaxManager.GetCurrent(Page).Alert("La descripción no puede estar vacía.");
            //}

           

        }

        protected void radIndicador_ItemCreated(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem item = (GridDataItem)e.Item;
                string  descripcion = (item["descripcionIndicador"].Text);
                string ponderacion = (item["ponderacion"].Text);
                string indicadorMinimo = (item["indicadorMinimo"].Text);
                string  indicadorDeseable = (item["indicadorDeseable"].Text);

                if (string.IsNullOrEmpty(descripcion) || descripcion == "&nbsp;")
                {
                    e.Canceled = true;
                    DisplayMessage(true, "LLena todos los campos");
                    return;
                }

                if (string.IsNullOrEmpty(ponderacion) || ponderacion == "&nbsp;")
                {
                    e.Canceled = true;
                    DisplayMessage(true, "LLena todos los campos");
                    return;
                }

                if (string.IsNullOrEmpty(indicadorMinimo) || indicadorMinimo == "&nbsp;")
                {
                    e.Canceled = true;
                    DisplayMessage(true, "LLena todos los campos");
                    return;
                }

                if (string.IsNullOrEmpty(indicadorDeseable) || indicadorDeseable == "&nbsp;")
                {
                    e.Canceled = true;
                    DisplayMessage(true, "LLena todos los campos");
                    return;
                }
            }
        }
    }
}