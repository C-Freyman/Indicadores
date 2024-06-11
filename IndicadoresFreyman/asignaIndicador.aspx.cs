using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using Telerik.Web.UI.Skins;
using System.Data;
using Telerik.Windows.Documents.Spreadsheet.Expressions.Functions;

namespace IndicadoresFreyman
{

   
    public partial class asignaIndicador : System.Web.UI.Page
    {
        Conexion con = new Conexion();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                hdnArea.Value = "1";
                //radIndicador.MasterTableView.CommandItemSettings.AddNewRecordText = "Agregar indicador";
                radIndicador.MasterTableView.CommandItemSettings.RefreshText = "Refrescar";
                radIndicador.MasterTableView.CommandItemSettings.SaveChangesText = "Guardar";
                radIndicador.MasterTableView.CommandItemSettings.CancelChangesText = "Cancelar";
            }
        }


        protected void radGridEmpleados_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
          


        }


        protected void radIndicador_ItemUpdated(object sender, GridUpdatedEventArgs e)
        {

          
                GridEditableItem item = (GridEditableItem)e.Item;
                string id = item.GetDataKeyValue("pIndicadorId").ToString();
                string descripcionIndicador = item["descripcionIndicador"].Text;


                if (e.Exception != null)
                {
                    e.KeepInEditMode = true;
                    e.ExceptionHandled = true;
                   
                //DisplayMessage(true, "Indicador " + descripcionIndicador + " no pudo ser asignado. Debido: " + e.Exception.Message);
                RadWindowManager1.RadAlert($"Indicador no puedo eliminar Debido:: {e.Exception.Message}", 0, 0, "", null);
                //NotifyUser("Product with ID " + id + " cannot be updated. Reason: " + e.Exception.Message);
            }
                else
                {
                //DisplayMessage(false, "Guardado exitosamente");
                RadWindowManager1.RadAlert($"Guardado exitosamente", 0, 0, "", null);
                radGridEmpleados.DataSource = consulta();
                    radGridEmpleados.Rebind();

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


        protected void radIndicador_PreRender(object sender, EventArgs e)
        {

        }


        protected void radGridEmpleados_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridDataItem dataItem = (GridDataItem)radGridEmpleados.SelectedItems[0];
            if (dataItem != null)
            {
                var IdEmpleado = dataItem["IdEmpleado"].Text;
                hdnEmpleado.Value = IdEmpleado;


            }
        }

        protected void radIndicador_BatchEditCommand(object sender, GridBatchEditingEventArgs e)
        {
            //int totalPonderacion = 0, totalItem = 0;
            //Dictionary<string, int> ponderaciones = new Dictionary<string, int>();
            //var grid = sender as Telerik.Web.UI.RadGrid;
            ////Obten los numeros de columna por el nombre del campo
            //var numColumnaPonderacion = grid.Columns.FindByDataField("ponderacion").OrderIndex;
            //var numColumnaActivo = grid.Columns.FindByDataField("activo").OrderIndex;
            //var numColumnaDescripcion = grid.Columns.FindByDataField("descripcionIndicador").OrderIndex;

            //var items = grid.Items;
            ////recorres item previamente activos
            //foreach (GridItem item in items)
            //{

            //    if (item.Cells[numColumnaActivo].Controls.Count == 0)
            //        break;
            //    CheckBox chkActivo = item.Cells[numColumnaActivo].Controls[0] as CheckBox;
            //    if (!chkActivo.Checked)
            //        break;

            //    if (int.TryParse(item.Cells[numColumnaPonderacion].Text, out int ponderacion))
            //        ponderaciones[item.Cells[numColumnaDescripcion].Text] = ponderacion;
            //}

            //// Recorrer todos los items actualizados
            //foreach (GridBatchEditingCommand command in e.Commands)
            //{
            //    if (command.Type == GridBatchEditingCommandType.Update)
            //    {
            //        Hashtable newValues = command.NewValues;


            //        if (newValues.ContainsKey("ponderacion"))
            //        {
            //            int ponderacion;
            //            if (int.TryParse(newValues["ponderacion"].ToString(), out ponderacion))
            //            {
            //                totalPonderacion += ponderacion;
            //                ponderaciones[command.Item.Cells[numColumnaDescripcion].Text] = ponderacion;
            //            }
            //        }
            //    }
            //}

            //totalPonderacion = ponderaciones.Sum(p => p.Value);



            //// Validar que la suma de ponderación sea igual a 100
            //if (totalPonderacion != 100)
            //{
            //    // Cancelar la actualización y mostrar un mensaje de error
            //    e.Canceled = true;
            //    //radIndicador.MasterTableView.ClearEditItems();
            //    //radIndicador.MasterTableView.Rebind();
            //    // ShowErrorMessage("La suma de las ponderaciones debe ser igual a 100." + totalPonderacion);
            //    lblSumPonderacion.Text = totalPonderacion.ToString();
            //}

        }


        private void ShowErrorMessage(string message)
        {
            // Puedes usar un Label, Literal, o cualquier otro control para mostrar el mensaje
            ErrorMessageLabel.Text = message;
            ErrorMessageLabel.Visible = true;
        }

        protected void radIndicador_ItemCommand(object sender, GridCommandEventArgs e)
        {


            if (e.CommandName == Telerik.Web.UI.RadGrid.UpdateEditedCommandName)
            {
                //    // Obtener la suma del campo "Value"
                int total = 0;
               





                if (e.Item is GridDataItem)
                {
                    //foreach (GridDataItem dataItem in radIndicador.Items)
                    foreach (GridDataItem dataItem in radIndicador.MasterTableView.Items)
                    {
                        string indicador = dataItem["descripcionIndicador"].Text;
                        int value = int.Parse(dataItem["ponderacion"].Text);
                        // Encontrar el control CheckBox dentro de la celda
                        CheckBox chkBox = (CheckBox)dataItem["Activo"].Controls[0];
                        if (chkBox != null && chkBox.Checked)
                        {
                            total += value;
                        }
                    }
                }

                //            // Validar si la suma es igual a 100
                if (total != 100)
                {
                    // Cancelar la operación y mostrar un mensaje de error
                    e.Canceled = true;
                    radIndicador.Controls.Add(new LiteralControl("<div class='alert alert-danger'>La suma de la ponderación debe ser igual a 100. La suma actual es " + total + ".</div>"));
                }

            }


        }

        protected void radIndicador_ItemDataBound(object sender, GridItemEventArgs e)
        {

            //CalculateSumPonderacion();
            if (e.Item is GridDataItem)
            {
                GridDataItem dataItem = (GridDataItem)e.Item;
                DataRowView fila = dataItem.DataItem as DataRowView;
                bool estaSeleccionado = bool.Parse(fila["activo"].ToString());
                dataItem.Selected = estaSeleccionado;

            }
            //if (e.Item is GridDataItem)
                //{
                //    GridDataItem dataItem = (GridDataItem)e.Item;

                //    // Obtener el CheckBox en la columna
                //    CheckBox checkBox = (CheckBox)dataItem["activo"].Controls[0];

                //    // Verificar si está checado
                //    bool isChecked = checkBox.Checked;

                //    // Hacer algo con el valor checado
                //    if (isChecked)
                //    {
                //        // Lógica si el CheckBox está checado
                //        dataItem.BackColor = System.Drawing.Color.LightGreen;
                //    }
                //    else
                //    {
                //        // Lógica si el CheckBox no está checado
                //        dataItem.BackColor = System.Drawing.Color.LightCoral;
                //    }
                //}

                // Obtener la suma del campo "Value"
                //int total = 0;



                //try
                //{

                //    if (e.Item is GridDataItem)
                //    { 
                //        foreach (GridDataItem itemE in radIndicador.MasterTableView.Items)
                //        {
                //            string indicador = itemE["descripcionIndicador"].Text;
                //            int value = int.Parse(itemE["ponderacion"].Text);
                //            // Encontrar el control CheckBox dentro de la celda
                //            CheckBox chkBox = (CheckBox)itemE["Activo"].Controls[0];
                //            if (chkBox != null && chkBox.Checked)
                //            {
                //                total = int.Parse(htntotal.Value);
                //                total += value;
                //                htntotal.Value = total.ToString();

                //            }
                //        }
                //  }


                //if (e.Item is GridDataItem)
                //{
                //    // Cast the item to a GridDataItem
                //    GridDataItem dataItem = (GridDataItem)e.Item;

                //    string indicador = dataItem["descripcionIndicador"].Text;
                //    int value = int.Parse(dataItem["ponderacion"].Text);
                //    // Encontrar el control CheckBox dentro de la celda
                //    CheckBox chkBox = (CheckBox)dataItem["Activo"].Controls[0];
                //    if (chkBox != null && chkBox.Checked)
                //    {
                //        total = int.Parse(htntotal.Value);
                //        total += value;
                //        htntotal.Value = total.ToString();

                //    }
                //}



                //if (e.Item is GridDataItem)
                //{
                //    foreach (GridDataItem dataItem in radIndicador.Items)
                //    {
                //        string indicador = dataItem["descripcionIndicador"].Text;
                //        int value = int.Parse(dataItem["ponderacion"].Text);
                //        // Encontrar el control CheckBox dentro de la celda
                //        CheckBox chkBox = (CheckBox)dataItem["Activo"].Controls[0];
                //        if (chkBox != null && chkBox.Checked)
                //        {
                //            total += value;
                //            htntotal.Value = total.ToString();

                //        }

                //    }
                //}

                //Validar si la suma es igual a 100
                //if (total != 100)
                //{

                //    // Cancelar la operación y mostrar un mensaje de error
                //    //e.Canceled = true;
                //    //radIndicador.Controls.Add(new LiteralControl("<div class='alert alert-danger'>La suma de la ponderación debe ser igual a 100. La suma actual es " + total + ".</div>"));
                //}




                //}
                //}

                //catch (Exception ex)
                //{
                //    string error = ex.Message;
                //}


            }

        protected void SqlIndicador_Updating(object sender, SqlDataSourceCommandEventArgs e)
        {
            
        }

        

        protected void chkAsignado_CheckedChanged(object sender, EventArgs e)
        {
            

            //// Recalcular la suma de las ponderaciones
            CalculateSumPonderacion();
            CheckBox chk = (CheckBox)sender;
            GridDataItem item = (GridDataItem)chk.NamingContainer;
        }


        private void CalculateSumPonderacion()
        {
            double totalPonderacion = 0;

            foreach (GridDataItem item in radIndicador.MasterTableView.Items)
            {
                CheckBox chkAsignado = (CheckBox)item.FindControl("chkAsignado");
                if (chkAsignado != null && chkAsignado.Checked)
                {
                    double ponderacion;
                    if (double.TryParse(item["Ponderacion"].Text, out ponderacion))
                    {
                        totalPonderacion += ponderacion;
                    }
                }
            }

            //lblSumPonderacion.Text = "Total Ponderación: " + totalPonderacion.ToString();
        }

      

        protected void radGridEmpleados_ItemDataBound(object sender, GridItemEventArgs e)
        {
            try
            {
                if (e.Item is GridDataItem)
                {
                    GridDataItem item = (GridDataItem)e.Item;
                    string nombre = item["nombre"].Text;
                    int ponderacion = int.Parse(item["ponderacion"].Text);
                    //if (ponderacionStr != "")
                    //{
                    //int ponderacion = int.Parse(ponderacionStr);
                    HtmlGenericControl statusIcon = (HtmlGenericControl)item["IconColumn"].FindControl("StatusIcon");

                    if (ponderacion == 100)
                    {

                        statusIcon.Attributes["class"] = "bi bi-check-circle-fill Heading text-success"; // Icono para "Active"                    
                        statusIcon.Attributes["title"] = "Ponderacion";
                    }

                    if (ponderacion < 100)
                    {
                        statusIcon.Attributes["class"] = "bi bi-check-circle-fill text-warning"; // Icono para "Active"
                        statusIcon.Attributes["title"] = "Ponderacion";
                    }
                    //}

                }
            }
            catch(Exception ex)
            {
                string error = ex.Message;
            }
        }



        private DataTable  consulta()
        {
            DataTable dt;
            string strsql = String.Format("select IdEmpleado,nombre, DeptoId, Departamento ,isnull(sum(i.ponderacion),0) ponderacion from Vacaciones.dbo.AdministrativosNomiChecador as e " +
                                "left join  Indicador as i on e.IdEmpleado = i.empleadoId and activo = 1" +
                                "where DeptoId = {0}" + 
                                "group by IdEmpleado,nombre, DeptoId, Departamento", hdnArea.Value);
            dt = con.getDatatable(strsql);
            return dt;
        }

        protected void radGridEmpleados_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            radGridEmpleados.DataSource = consulta();
        }

        

        protected void radIndicador_CustomAggregate(object sender, GridCustomAggregateEventArgs e)
        {

            if (e.Column.UniqueName == "Ponderacion")
            {
                int totalPonderacion = 0;
                foreach (GridDataItem item in radIndicador.MasterTableView.Items)
                {
                    totalPonderacion += (item["activo"].Controls[0] as CheckBox).Checked ? int.Parse(item["ponderacion"].Text) : 0;
                }
                e.Result = totalPonderacion;
            }
        }
    }
}