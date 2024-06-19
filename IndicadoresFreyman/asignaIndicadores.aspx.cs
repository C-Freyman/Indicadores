using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using Telerik.Web.UI.PivotGrid.Core;


namespace IndicadoresFreyman
{
    public partial class asignaIndicadores : System.Web.UI.Page
    {
        Conexion con = new Conexion();
        protected void Page_Load(object sender, EventArgs e)
        {
            hdnJefe.Value = Convert.ToString((int)Session["Log"]);
            hdnArea.Value = Convert.ToString((int)Session["Depto"]);
            hdnCorreo.Value = (string)Session["Correo"];

           
        }




       


        private DataTable consultaEmpleados()
        {
            DataTable dt;
            string strsql = String.Format("select IdEmpleado,nombre, DeptoId, Departamento ,isnull(sum(i.ponderacion),0) ponderacion from Vacaciones.dbo.AdministrativosNomiChecador as e " +
                                "left join  Indicador as i on e.IdEmpleado = i.empleadoId   and activo = 1 " +
                                "where jefeinmediato = '{0}' and puesto != 22" +
                                "group by IdEmpleado,nombre, DeptoId, Departamento order by nombre", hdnCorreo.Value);
            dt = con.getDatatable(strsql);
            if (hdnEmpleado.Value == "0")
            {
                if (dt.Rows.Count > 0)
                {
                    hdnEmpleado.Value = Convert.ToString((int)dt.Rows[0]["IdEmpleado"]);
                    hdnNomEmpleado.Value = (string)dt.Rows[0]["nombre"];


                }
            }
            

            return dt;

        
        }

        protected void radGridEmpleados_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            radGridEmpleados.DataSource = consultaEmpleados();
        }



        protected void radGridEmpleados_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridDataItem dataItem = (GridDataItem)radGridEmpleados.SelectedItems[0];
            if (dataItem != null)
            {
                var IdEmpleado = dataItem["IdEmpleado"].Text;
                hdnEmpleado.Value = IdEmpleado;
                hdnNomEmpleado.Value =  dataItem["nombre"].Text;
                hdnIndicador.Value = "0";
                radGridIndicador.DataSource = consultaIndicadores();
                radGridIndicador.Rebind();
                //suma();
                
            }
        }


        protected void radGridEmpleados_ItemDataBound(object sender, GridItemEventArgs e)
        {
            try
            {
                if (e.Item is GridDataItem)
                {
                    GridDataItem item = (GridDataItem)e.Item;
                    string nombre = item["nombre"].Text;
                    decimal  ponderacion = decimal.Parse(item["ponderacion"].Text);
                    //if (ponderacionStr != "")
                    //{
                    //int ponderacion = int.Parse(ponderacionStr);
                    HtmlGenericControl statusIcon = (HtmlGenericControl)item["IconColumn"].FindControl("StatusIcon");

                    if (ponderacion == 100)
                    {

                        statusIcon.Attributes["class"] = "bi bi-check-circle-fill Heading text-success"; // Icono para "Active"                    
                        statusIcon.Attributes["title"] = "Ponderacion";
                    }

                    if (ponderacion != 100)
                    {
                        statusIcon.Attributes["class"] = "bi bi-exclamation-triangle-fill  text-danger"; // Icono para "Active"
                        statusIcon.Attributes["title"] = "Ponderacion";
                    }
                    //}

                }
            }
            catch (Exception ex)
            {
                string error = ex.Message;
            }
        }

       



        /////////////indicadores asignados///////////////////


        protected void radGridIndicador_NeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            radGridIndicador.DataSource = consultaIndicadores();
           
        }


        private DataTable consultaIndicadores()
        {

            DataTable dt;
            string strsql = "";         
            strsql = String.Format(" select IndicadorId, i.pIndicadorId, descripcionIndicador, (i.ponderacion*1.0)/100 ponderacion, i.indicadorMinimo, i.indicadorDeseable,  CAST(activo AS BIT)  activo , empleadoId, esAscendente from Indicador as i inner join PlantillaIndicador as p on p.pIndicadorId = i.pIndicadorId    where empleadoId = {0} and activo = 1 union all select 0, p.pIndicadorId, descripcionIndicador, p.ponderacion/100 ponderacion, p.indicadorMinimo, p.indicadorDeseable, cast(0 as bit) activo ,0, esAscendente from PlantillaIndicador as p  where estatus = 1 and pIndicadorId in ({1})", hdnEmpleado.Value, hdnIndicador.Value);
            dt = con.getDatatable(strsql);
            return dt;
          
        }

        protected void btnAgregar_Click(object sender, EventArgs e)
        {
            pnlEditar.Visible = true;
            DataTable dt = consultaAsigna();
            if (dt.Rows.Count > 0)
            {
                radAsigna.DataSource = consultaAsigna();
                radAsigna.Rebind();
            }
            else
            {
                RadWindowManager1.RadAlert($"No hay indicadores para asignar", 0, 0, "", null);
            }

        }


        public string cargaimagen()
        {
            string estilo = "";

            estilo = "border:none; max-width: 15px; max-height: 15px; background-repeat:no-repeat; background-position: center; background-size: cover;";
            estilo += "background-image: url('imagenes/basura.png');";

            return estilo;
        }

        protected void btnGuardarIndicador_Click(object sender, EventArgs e)
        {

            decimal sumponderacion = 0; string plantillaId = "", strsql = "";
            foreach (GridDataItem fila in radGridIndicador.MasterTableView.Items)
            {

                string pIndicadorId = fila["pIndicadorId"].Text;
                string ponderacion = fila["ponderacion"].Text;
                if(ponderacion.Contains("%"))
                {
                    ponderacion = ponderacion.Replace("%", "");
                }
                sumponderacion += decimal.Parse(ponderacion);
                plantillaId = fila["pIndicadorId"].Text;
          

            }
            if (sumponderacion != 100)
            {
                RadWindowManager1.RadAlert($"La suma de las ponderaciones seleccionadas es diferente a 100, pero los indicadores asingados ya fueron guardados.", 0, 0, "", null);
                //lblsuma.Text = "Total ponderación: " + sumponderacion.ToString();
                //hdnSuma.Value = sumponderacion.ToString();
                strsql = cadenaInsert();
                con.Save(strsql);
                hdnIndicador.Value = "0";
                radGridIndicador.DataSource = consultaIndicadores();
                radGridIndicador.Rebind();
                radGridEmpleados.DataSource = consultaEmpleados();
                radGridEmpleados.Rebind();
                //return;
            }

            if (sumponderacion == 100)
            {


                strsql = cadenaInsert();
                con.Save(strsql);
                RadWindowManager1.RadAlert($"Los indicadores se han asignado correctamente", 0, 0, "", null);
                hdnIndicador.Value = "0";
                radGridIndicador.DataSource = consultaIndicadores();
                radGridIndicador.Rebind();
                radGridEmpleados.DataSource = consultaEmpleados();
                radGridEmpleados.Rebind();

            }


        }


        private string  cadenaInsert()
        {
            string strsql = "";
            foreach (GridDataItem fila in radGridIndicador.MasterTableView.Items)
            {
                string pIndicadorId = fila["pIndicadorId"].Text;              
                string ponderacion = fila["ponderacion"].Text.Replace("%","");
                string indicadorMinimo = fila["indicadorMinimo"].Text.Replace(",", "");
                string indicadorDeseable = fila["indicadorDeseable"].Text.Replace(",", "");
                strsql += String.Format("  exec guardaAsignacion {0}, {1}, {2}, {3}, {4}", pIndicadorId, hdnEmpleado.Value, ponderacion, indicadorMinimo, indicadorDeseable);
             

            }
            return strsql;
        }

        protected void btnBorrar_Click(object sender, EventArgs e)
        {
            RadImageButton bt = (RadImageButton)sender;
            string pIndicadorId = bt.Value;
            string indicadorId = pIndicadorId;
            DataTable dt;
            string strslq = String.Format("select* from Indicador where pIndicadorId = {0} and empleadoId = {1}", indicadorId, hdnEmpleado.Value);
            dt = con.getDatatable(strslq);
            if (dt.Rows.Count > 0)
            {
                strslq = "";
                strslq = String.Format("update  indicador set activo = 0 where  pIndicadorId = {0} and empleadoId = {1}", indicadorId, hdnEmpleado.Value);
                con.Save(strslq);
            }
            else
            {
                string indicadores = hdnIndicador.Value;
                if (indicadores.Contains(','))
                {
                    pIndicadorId = ", " + pIndicadorId;
                    indicadores = indicadores.Replace(pIndicadorId, " ");
                    hdnIndicador.Value = indicadores;
                }
                else
                {
                    indicadores = indicadores.Replace(pIndicadorId, " ");
                    hdnIndicador.Value = indicadores;
                }
            }
            radGridIndicador.DataSource = consultaIndicadores();
            radGridIndicador.Rebind();
            radGridEmpleados.DataSource = consultaEmpleados();
            radGridEmpleados.Rebind();

            
           //suma();
        }


        ///asigna indicadores
        ///
        protected void btnclose_Click(object sender, EventArgs e)
        {
            pnlEditar.Visible = false;
        }

        private DataTable consultaAsigna()
        {
            DataTable dt;
            string strsql = String.Format("select p.pIndicadorId, descripcionIndicador, (ponderacion*1.0)/100 ponderacion, p.indicadorMinimo, p.indicadorDeseable, cast(0 as bit)  activo  from PlantillaIndicador as p   where not exists (select * from  Indicador as a  where p.pIndicadorId = a.pIndicadorId  and empleadoId = {1} and activo = 1  ) and area ={0} and estatus = 1 and p.pIndicadorId  not in ({2})  and jefeId = {3}", hdnArea.Value, hdnEmpleado.Value, hdnIndicador.Value, hdnJefe.Value);
            dt = con.getDatatable(strsql);
            return dt;
        }      

        protected void radAsigna_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            radAsigna.DataSource = consultaAsigna();
        }

        protected void btncerrarMdl_Click(object sender, EventArgs e)
        {
            pnlEditar.Visible =false;
        }

        protected void btncerrarEdidar_Click(object sender, EventArgs e)
        {
            pnlEditar.Visible = false;
        }

        protected void btnAsignaIndicador_Click(object sender, EventArgs e)
        {
            double suma = 0;
            foreach (GridDataItem fila in radAsigna.MasterTableView.Items)
            {
                bool isChecked = fila.Selected;
                if (isChecked)
                {
                    string pIndicadorId = fila["pIndicadorId"].Text;
                    string ponderacion = fila["ponderacion"].Text.Replace("%","");
                    if (hdnIndicador.Value == "")
                        hdnIndicador.Value = pIndicadorId;
                    else
                        hdnIndicador.Value += ", " + pIndicadorId;
                    suma += double.Parse(ponderacion);
                    
                }
            }


           
            //lblsuma.Text = "Total ponderación: " + Convert.ToString(suma);
            //suma();
            radGridIndicador.DataSource = consultaIndicadores();
            radGridIndicador.Rebind();
            pnlEditar.Visible = false;
        }

       

        private void suma()
        {
            double suma = 0;
            foreach (GridDataItem fila in radGridIndicador.MasterTableView.Items)
            {
              
                    
                    string ponderacion = fila["ponderacion"].Text.Replace("%", "");
                   
                    suma += double.Parse(ponderacion);

               
            }
            //hdnSuma.Value = Convert.ToString(suma);
            //lblsuma.Text = "Total ponderación: " + Convert.ToString(suma);
        }


        protected void radGridIndicador_ItemDataBound(object sender, GridItemEventArgs e)
        {
            try
            {   
                


                if (e.Item is GridDataItem)
                {
                    GridDataItem item = (GridDataItem)e.Item;                    
                    double indicadorMinimo = double.Parse(item["indicadorMinimo"].Text);
                    double indicadorDeseable = double.Parse(item["indicadorDeseable"].Text);
                   
                    HtmlGenericControl statusIcon = (HtmlGenericControl)item["colOrdenamiento"].FindControl("StatusIcon");

                    if (indicadorMinimo > indicadorDeseable)
                    {

                        statusIcon.Attributes["class"] = "bi bi-arrow-down"; // Icono para "Active"                    
                        //statusIcon.Attributes["title"] = "Orn";
                    }

                    if (indicadorMinimo <= indicadorDeseable)
                    {
                        statusIcon.Attributes["class"] = "bi bi-arrow-up  "; // Icono para "Active"
                        //statusIcon.Attributes["title"] = "Ponderacion";
                    }
                   

                }
                
            }
            catch (Exception ex)
            {
                string error = ex.Message;
            }
        }

        protected void radGridIndicador_ItemCreated(object sender, GridItemEventArgs e)
        {
          
                if (e.Item is GridCommandItem)
                {
                   Label lblEmpleado = (Label)e.Item.FindControl("lblEmpleado");
                   Label lblEmpleadoId = (Label)e.Item.FindControl("lblEmpleado");
                //Label lblSuma = (Label)e.Item.FindControl("lblsuma");

                if (lblEmpleado != null)
                    {
                        lblEmpleado.Text = "Nombre del Colaborador: " + hdnNomEmpleado.Value;
                    }

                if (lblEmpleadoId != null)
                {
                    if (lblEmpleadoId.Text != "0")                    
                    hdnEmpleadoId.Value = lblEmpleadoId.Text;

                    if (lblEmpleadoId.Text == "0")
                    lblEmpleadoId.Text = hdnEmpleado.Value;
                }
            }
            
        }
    }



}