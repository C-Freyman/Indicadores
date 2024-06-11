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
                RadWindowManager1.RadAlert($"Indicador no puedo eliminar Debido:: {e.Exception.Message}", 0, 0, "", null);
            }
            else
            {
               
                // DisplayMessage(true, "Indicador guardado");
                //NotifyUser("Indicador guardado");
                error = e.ToString();
                RadWindowManager1.RadAlert($"Indicador guardado exitosamente", 0, 0, "", null);
            }
        }

        protected void radGridIndicador_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
            if (e.CommandName == "Update" || e.CommandName == "PerformInsert")
            {
                GridEditableItem editedItem = e.Item as GridEditableItem;

                // Obtener los valores de los controles dentro del EditTemplate
                RadDropDownList ddlTipo = editedItem.FindControl("ddltipo") as RadDropDownList;
                TextBox txtDescripcionIndicador = editedItem.FindControl("txtdescripcionIndicador") as TextBox;
                TextBox txtPonderacion = editedItem.FindControl("txtponderacion") as TextBox;
                TextBox txtIndicadorMinimo = editedItem.FindControl("txtindicadorMinimo") as TextBox;
                TextBox txtIndicadorDeseable = editedItem.FindControl("txtindicadorDeseable") as TextBox;
                Label lblasc = editedItem.FindControl("lblascedente") as Label;
                //RadDropDownList ddlorden = editedItem.FindControl("ddlascendente") as RadDropDownList;
                string tipoId = ddlTipo.SelectedValue;
                string descripcionIndicador = txtDescripcionIndicador.Text;
                string ponderacion = txtPonderacion.Text;
                string indicadorMinimo = txtIndicadorMinimo.Text;
                string indicadorDeseable = txtIndicadorDeseable.Text;
                //string orden = ddlorden.SelectedValue;
                //if (int.Parse(txtIndicadorMinimo.Text) < int.Parse(txtIndicadorDeseable.Text))
                //    lblasc.Text = "ordenamiento Ascendente";
                //else
                //    lblasc.Text = "ordenamiento Descendente";
                //e.Canceled = true;
            }


         

        }

        protected void radGridIndicador_ItemInserted(object sender, Telerik.Web.UI.GridInsertedEventArgs e)
        {
            Label1.Text = "";
            Label2.Text = "";
            string error = "";
            try
            {
                GridEditableItem insertedItem = e.Item as GridEditableItem;

                // Obtener el valor del TextBox txtponderacion
                TextBox txtindicadorMinimo = insertedItem.FindControl("txtindicadorMinimo") as TextBox;
                TextBox txtindicadorDeseable = insertedItem.FindControl("txtindicadorDeseable") as TextBox;
                if (txtindicadorMinimo != null)
                {
                    string valorPonderacion = txtindicadorMinimo.Text;
                    // Procesar el valor de ponderación según sea necesario
                    // Ejemplo: Guardar en la base de datos, validar, etc.
                }
            }
            catch (Exception ex)
            {
                // Manejar cualquier excepción que ocurra
            }

            if (e.Exception != null)
            {
                e.ExceptionHandled = true;
                RadWindowManager1.RadAlert($"Indicador no pudo ser guardado Debido: {e.Exception.Message}",0,0,"",null);
                //DisplayMessage(true, "Indicador no puedo ser guardado Debido: " + e.Exception.Message);
            }
            else
            {
                error = e.ToString();
                RadWindowManager1.RadAlert($"Indicador guardado exitosamente", 0, 0, "",  null);
                // DisplayMessage(true, "Indicador guardado");
                //NotifyUser("Indicador guardado");
                //DisplayMessage(false, "Indicador guardado exitosamente");
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
                
                RadWindowManager1.RadAlert($"Indicador {descripcionIndicador} no pudo ser actualizad. Debido: {e.Exception.Message}", 0, 0, "",  null);
                //lblMessage.Text = "Indicador " + descripcionIndicador + " no se puede actualizar. Debido: " + e.Exception.Message;
                //NotifyUser("Product with ID " + id + " cannot be updated. Reason: " + e.Exception.Message);
                //ShowMessage("Este es un mensaje de ejemplo");

            }
            else
            {
                RadWindowManager1.RadAlert($"Indicador actualizado exitosamente", 0, 0, "",  null);
                // ShowMessage("Este es un mensaje de ejemplo");
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



    
            protected void ShowAlert(string message)
            {
                string script = $"alert('{message}');";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowAlertScript", script, true);
            }
        

        protected void Button1_Click(object sender, EventArgs e)
        {
            string script = $"window.alert('Este es un ejemplo');";
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "ShowAlertScript", script, true);
        }

       

        protected void CustomValidator1_ServerValidate(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
        {
            //var minimo = args.Value;
            //Int64 deseable = 0;
            //hdnminimo.Value = minimo;
            //if (hdndeseable.Value != "")
            //{
            //    deseable = int.Parse(hdndeseable.Value);
            //}
            //Int64 min = int.Parse(hdnminimo.Value);
            //if (args.Value.StartsWith("4"))
            //{
            //    args.IsValid = true;
            //}
        }

        protected void cvIndicadorMinimo_ServerValidate(object source, ServerValidateEventArgs args)
        {

            //GridEditableItem editItem = (GridEditableItem)((CustomValidator)source).NamingContainer;

            //// Obtén los controles TextBox de la fila de edición
            //TextBox txtIndicadorMinimo = (TextBox)editItem.FindControl("txtindicadorMinimo");
            //TextBox txtIndicadorDeseable = (TextBox)editItem.FindControl("txtindicadorDeseable");

            //Label lblasc = (Label)editItem.FindControl("lblascedente");
            
            ////    Validar que no sean nulos
            //if (txtIndicadorDeseable != null && txtIndicadorMinimo != null)
            //{
            //    // Convertir los valores a números
            //    if (decimal.TryParse(txtIndicadorDeseable.Text, out decimal deseable) && decimal.TryParse(txtIndicadorMinimo.Text, out decimal indicadorMinimo))
            //    {
            //        // Realizar la validación
            //        if (indicadorMinimo > deseable)
            //        {
            //            lblasc.Text = "Ascendente";
            //           return;
            //        }
            //        else
            //        {
            //            lblasc.Text = "Descendente";
            //            //args.IsValid = true;
            //            return;
            //        }
            //    }
            //    else
            //    {
            //        // Manejar el error de conversión
            //        //args.IsValid = false;
            //    }
            //}
            //else
            //{
            //    args.IsValid = false;
            //}
        }

        protected void radGridIndicador_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridEditableItem && e.Item.IsInEditMode)
            {
                GridEditableItem editItem = (GridEditableItem)e.Item;

                Label lblTipoindicador = editItem.FindControl("lblTipoIndicador") as Label;
                if (lblTipoindicador != null)
                {
                    TextBox txtMinimo = editItem.FindControl("txtindicadorMinimo") as TextBox;
                    TextBox txtDeseable = editItem.FindControl("txtindicadorDeseable") as TextBox;

                    if (float.TryParse(txtMinimo.Text, out float minimo)
                        && float.TryParse(txtDeseable.Text, out float maximo))
                    {
                        lblTipoindicador.Text = $"Indicador {(minimo < maximo ? "Ascendente" : "Descendente")}";
                    }

                }
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            //GridEditableItem editItem = radGridIndicador.EditItems ;

            //// Obtén los controles TextBox de la fila de edición
            //TextBox txtIndicadorMinimo = (TextBox)editItem.FindControl("txtindicadorMinimo");
            //TextBox txtIndicadorDeseable = (TextBox)editItem.FindControl("txtindicadorDeseable");

        }
    }
}