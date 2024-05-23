using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using Telerik.Web.UI.Map;

namespace IndicadoresFreyman
{
    public partial class crearIndicador : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                hdnArea.Value = "1";
            }
        }

        protected void radIndicador_ItemDeleted(object sender, GridDeletedEventArgs e)
        {

        }

        protected void radIndicador_ItemInserted(object sender, GridInsertedEventArgs e)
        {
            string error = "";
            if (e.Exception != null)
            {
                e.ExceptionHandled = true;

                error = e.Exception.Message;
                //NotifyUser("Product cannot be inserted. Reason: " + e.Exception.Message);
            }
            else
            {
                error = e.ToString();
                //("New product is inserted!");
            }
        }

        protected void radIndicador_PreRender(object sender, EventArgs e)
        {
            //RadNumericTextBox unitsNumericTextBox = (radIndicador.MasterTableView.GetBatchColumnEditor("UnitsInStock") as GridNumericColumnEditor).NumericTextBox;
            //unitsNumericTextBox.Width = Unit.Pixel(60);
        }

        protected void radIndicador_BatchEditCommand(object sender, GridBatchEditingEventArgs e)
        {
            SavedChangesList.Visible = true;
        }


        protected void radIndicador_ItemUpdated(object source, Telerik.Web.UI.GridUpdatedEventArgs e)
        {
            GridEditableItem item = (GridEditableItem)e.Item;
            hdnProyecto.Value= item.GetDataKeyValue("pIndicadorId").ToString();
            //string descripcionIndicador = item["descripcionIndicador"].Text;
           // string ponderacion = ((RadTextBox)item.FindControl("ponderacion")).Text; 
            //string indicadorMinimo = item["indicadorMinimo"].Text;
            //string indicadorDeseable = item["indicadorDeseable"].Text;

            if (e.Exception != null)
            {
                e.KeepInEditMode = true;
                e.ExceptionHandled = true;
                string error = e.Exception.Message;
                //NotifyUser("Product with ID " + id + " cannot be updated. Reason: " + e.Exception.Message);
            }
            else
            {
                string error = e.ToString();
                //NotifyUser("Product with ID " + id + " is updated!");
            }

        }

        protected void radIndicador_ItemCommand(object sender, GridCommandEventArgs e)
        {
            try
            {
                if (e.CommandName == RadGrid.SelectCommandName && e.Item is GridDataItem)
                {
                    GridDataItem item = (GridDataItem)e.Item;

                }

                if (e.CommandName == RadGrid.UpdateCommandName && e.Item is GridDataItem)
                {
                    GridDataItem item = (GridDataItem)e.Item;
                    hdnProyecto.Value = item.GetDataKeyValue("pIndicadorId").ToString();
                    //String id = item.GetDataKeyValue("pIndicadorId").ToString();
                    string descripcionIndicador = item["descripcionIndicador"].Text;
                    string ponderacion = item["ponderacion"].Text;
                    string indicadorMinimo = item["indicadorMinimo"].Text;
                    string indicadorDeseable = item["indicadorDeseable"].Text;
                    //string  Tipoid = ((RadDropDownList)item.FindControl("ddlTipo")).SelectedValue;


                }
            }
            catch (Exception ex)
            {
                string error = ex.Message;
            }
        }

        protected void SqlIndicador_Updating(object sender, SqlDataSourceCommandEventArgs e)
        {
            // gridDataItem item = (GridDataItem)e.Item;
            hdnProyecto.Value =  "1";//item.GetDataKeyValue("pIndicadorId").ToString();

        }
    }
}