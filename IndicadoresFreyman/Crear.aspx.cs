using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Telerik.Web.UI;
using System.Runtime.Remoting.Messaging;
using Telerik.Web.UI.Map;


namespace IndicadoresFreyman
{
    public partial class Crear : System.Web.UI.Page
    {
        Conexion con = new Conexion();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                

               
                hdnArea.Value = Convert.ToString((int)Session["Depto"]);
                hdnCorreo.Value = (string)Session["Correo"];
                int empleado = (int)Session["Log"];
                hdnJefe.Value = Convert.ToString(empleado);

                DataTable dt;
                string strsql = String.Format("select IdEmpleado,nombre, DeptoId, Departamento from  Vacaciones.dbo.AdministrativosNomiChecador where JefeInmediato = (select correo from Vacaciones.dbo.AdministrativosNomiChecador where IdEmpleado = {0})", empleado);
                dt = con.getDatatable(strsql);
                if (dt.Rows.Count == 0)
                {
                    Response.Redirect("~/Default.aspx");
                }

                tipo();
                estatus();
                cargaOrdenamiento();
            }
        }


        private void estatus()
        {
            string strsql = "select * from estatus   order by estatus";
            radEstatus.DataSource = con.getReader(strsql);
            radEstatus.DataTextField = "estatus";
            radEstatus.DataValueField = "estatusId";
            radEstatus.DataBind();
            radEstatus.SelectedValue = "1";
        }


        private void tipo()
        {
            string strsql = "select tipoId, tipo from TipoIndicador  order by tipo";
            ddltipo.DataSource = con.getReader(strsql);
            ddltipo.DataTextField = "tipo";
            ddltipo.DataValueField = "tipoId";
            ddltipo.DataBind();
            //ddltipo.SelectedValue = "1";
            ddltipo.Items.Insert(0,"Selecciona tipo");
      
        }


        private void cargaOrdenamiento()
        {
            string strsql = "select * from Ordenamiento order by orden";
            dllOrden.DataSource = con.getReader(strsql);
            dllOrden.DataTextField = "orden";
            dllOrden.DataValueField = "ordenId";
            dllOrden.DataBind();
            dllOrden.Items.Insert(0, "Selecciona orden");

        }


        protected void radGridIndicador_NeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            radGridIndicador.DataSource = consulta();
        }


        private DataTable consulta()
        {

            DataTable dt;
            string strsql = "";
            string selectedValue = radEstatus.SelectedText;

            if (selectedValue == "Activo")
            {
                strsql = String.Format("SELECT pIndicadorId, descripcionIndicador, ponderacion/100 ponderacion, indicadorMinimo, indicadorDeseable, t.TipoId,tipo,area,estatus FROM[PlantillaIndicador] as i inner join TipoIndicador as t on t.tipoId = i.tipoId  where area ={0} and estatus = 1  and jefeId = {1}", hdnArea.Value, hdnJefe.Value);
            }
            else
            {
                strsql = String.Format("SELECT pIndicadorId, descripcionIndicador, ponderacion/100 ponderacion, indicadorMinimo, indicadorDeseable, t.TipoId,tipo,area, estatus FROM[PlantillaIndicador] as i inner join TipoIndicador as t on t.tipoId = i.tipoId  where area = {0} and estatus = 0 and jefeId = {1}", hdnArea.Value, hdnJefe.Value);
            }
            dt = con.getDatatable(strsql);
            return dt;
        }

        protected void btnEstatus_Click(object sender, EventArgs e)
        {
            DataTable dt = new DataTable();
            RadImageButton bt = (RadImageButton)sender;
            string pIndicadorId = bt.Value;

            actualizaEstatus(int.Parse(pIndicadorId));
            radGridIndicador.DataSource = consulta();
            radGridIndicador.Rebind();



        }



        private void actualizaEstatus(int pIndicadorId)
        {

            string strsql = "";
            string selectedValue = radEstatus.SelectedText;


            if (selectedValue == "Activo")
            {
                int val = validaAsignacion(pIndicadorId);
                if (val == 0)
                {
                    strsql = String.Format("update plantillaIndicador set estatus = 0 where pIndicadorId = {0}", pIndicadorId);
                    con.Save(strsql);
                    RadWindowManager1.RadAlert("Indicador se inactivo", 0, 0, "", null);
                }
            }
            else
            {
                strsql = String.Format("update plantillaIndicador set estatus = 1 where pIndicadorId = {0}", pIndicadorId);
                con.getDatatable(strsql);
                RadWindowManager1.RadAlert($"Indicador se activo", 0, 0, "", null);
            }


        }

        private int validaAsignacion(int pIndicadorId)
        {
            DataTable dt; 
            string strsql = String.Format("select * from indicador where activo = 1 and pIndicadorId = {0} ", pIndicadorId);
            dt = con.getDatatable(strsql);
            if (dt.Rows.Count  > 0)
            {
                //string indicador = (string)dt.Rows[0]["descripcionIndicador"];
                RadWindowManager1.RadAlert($"El indicador esta asignado, por lo tanto no lo puedes borrar hasta que se elimine la asignación", 0, 0, "", null);
                return 1;
            }
            return 0;
        }

        protected void radEstatus_SelectedIndexChanged(object sender, DropDownListEventArgs e)
        {
            radGridIndicador.DataSource = consulta();
            radGridIndicador.Rebind();
        }


        public string cargaimagen(string estatus)
        {
            string estilo = "";

            estilo = "border:none;  width:1em; height:1.5em;";           
            estilo += estatus == "0" ? "background-image: url('imagenes/paloma.png');" : "background-image: url('imagenes/basura.png');";

           return estilo;
        }

        public string cargaimagenEditar()
        {
            string estilo = "";

            estilo = "border:none; max-width: 15px; max-height: 15px; background-repeat:no-repeat; background-position: center; background-size: cover;";
            estilo +=  "background-image: url('imagenes/editar2.png')";

            return estilo;
        }

        protected void btnAgregar_Click(object sender, EventArgs e)
        {
            lblguarda.Text = "1";
            lbltiulo.Text = "Crear Indicador";
            pnlEditar.Visible = true;
            btnGuardaEditar.Text = "Guardar";
            //dllOrden.SelectedValue = "0";
            ordenamientos.Visible = false;
            lblErrororden.Visible = false;
        }

        private DataTable consultaEditar(string pIndicadorId)
        {
            DataTable dt;
            string strsql = String.Format("SELECT pIndicadorId, descripcionIndicador, ponderacion, indicadorMinimo, indicadorDeseable, t.TipoId,tipo,area,estatus, case when cast(esAscendente as bit) = 1 then 1 else 0 end  esAscendente FROM[PlantillaIndicador] as i inner join TipoIndicador as t on t.tipoId = i.tipoId  where area ={0} and estatus = 1 and pIndicadorId = {1}", hdnArea.Value, pIndicadorId);
            dt = con.getDatatable(strsql);
            return dt;
        }

        protected void btnEditar_Click(object sender, EventArgs e)
        {
            lbltiulo.Text = "Actualiza indicador";
            lblguarda.Text = "0";
            pnlEditar.Visible = true;            
            Button bt = (Button)sender;
            string pIndicadorId = bt.Attributes["value"];
            hdnIndicadorId.Value = pIndicadorId;
            DataTable dt;
            dt = consultaEditar(pIndicadorId);            
            txtdescripcionIndicador.Text = (string)dt.Rows[0]["descripcionIndicador"];
            txtponderacion.Text = Convert.ToString((decimal)dt.Rows[0]["ponderacion"]);
            txtindicadorMinimo.Text = Convert.ToString((decimal)dt.Rows[0]["indicadorMinimo"]);
            txtindicadorDeseable.Text = Convert.ToString((decimal)dt.Rows[0]["indicadorDeseable"]);
            if (txtindicadorMinimo.Text.Replace(".00","") == txtindicadorDeseable.Text.Replace(".00", ""))
            {
                ordenamientos.Visible = true;
            }
            else
            {
                ordenamientos.Visible = false;
                lblErrororden.Visible = false;
            }

            ddltipo.SelectedValue = Convert.ToString((int)dt.Rows[0]["Tipoid"]);
            dllOrden.SelectedValue = Convert.ToString((int)dt.Rows[0]["esAscendente"]);
            btnGuardaEditar.Text = "Actualizar";
        }

        protected void btnGuardaEditar_Click(object sender, EventArgs e)
        {

            visibleOrdenamiento();
           
            string descripcionIndicador = txtdescripcionIndicador.Text;
            string ponderacion = txtponderacion.Text;
            string indicadorMinimo = txtindicadorMinimo.Text.Replace(",","");
            string indicadorDeseable  = txtindicadorDeseable.Text.Replace(",", "");
            string Tipoid = ddltipo.SelectedValue;
            string area = hdnArea.Value;
            string strsql = "";

            if (ddltipo.SelectedIndex == 0)
            {
                lblErrortipo.Visible = true;
                return;
            }
            else
            {
                lblErrortipo.Visible = false;
            }
        

            if (txtindicadorMinimo.Text.Replace(".00","") == txtindicadorDeseable.Text.Replace(".00",""))
            {
                if (dllOrden.SelectedIndex == 0)
                {
                    //RadWindowManager1.RadAlert("Selecciona el ordenamiento de indicador", 0, 0, "", null);
                    lblErrororden.Visible = true;
                    return;
                }
                else
                {
                    lblErrororden.Visible = false;
                }
            }
            else
            {
                dllOrden.SelectedValue = "1";
            }

            if (lblguarda.Text == "1")
            {
                
                strsql = String.Format("exec insertPlantllaIndicador  '{0}',   '{1}',  '{2}', '{3}', '{4}', '{5}', {6}, {7}", descripcionIndicador, ponderacion, indicadorMinimo, indicadorDeseable, Tipoid, area, hdnJefe.Value, dllOrden.SelectedValue);
                con.Save(strsql);
                pnlEditar.Visible = false;
                RadWindowManager1.RadAlert("Guardado exitosamente", 0, 0, "", null);
            }

            if (lblguarda.Text == "0")
            {
                strsql = String.Format("exec updatePlantllaIndicador  '{0}',   {1},  {2}, {3}, {4}, {5}, {6}", descripcionIndicador, ponderacion, indicadorMinimo, indicadorDeseable, Tipoid,  hdnIndicadorId.Value,  dllOrden.SelectedValue);
                con.Save(strsql);
                pnlEditar.Visible = false;
                RadWindowManager1.RadAlert("Actualizado exitosamente", 0, 0, "", null);
            }
            radGridIndicador.DataSource = consulta();
            radGridIndicador.Rebind();
            limpiar();
            ordenamientos.Visible = false;
        }

        protected void btncerrarMdl_Click(object sender, EventArgs e)
        {
           
            pnlEditar.Visible = false;
            limpiar();
           
            
            

        }

        private void visibleOrdenamiento()
        {
            decimal minimo = 0;
            decimal deseable = 0;
            if (txtindicadorMinimo.Text != "")
            {
                minimo = decimal.Parse(txtindicadorMinimo.Text);
            }
            if (txtindicadorDeseable.Text != "")
            {
                deseable = decimal.Parse(txtindicadorDeseable.Text);
            }

            if (minimo == deseable)
            {
                ordenamientos.Visible = true;
              
            }
            else
            {
                ordenamientos.Visible = false;
              
            }
        }

        protected void txtindicadorMinimo_TextChanged(object sender, EventArgs e)
        {
            decimal minimo = 0;
            decimal deseable = 0;
            if (txtindicadorMinimo.Text != "")
            {
                minimo = decimal.Parse(txtindicadorMinimo.Text);
            }
            if (txtindicadorDeseable.Text != "")
            {
                deseable = decimal.Parse(txtindicadorDeseable.Text);
            }

            if (minimo == deseable)
            {
                ordenamientos.Visible = true;
                lblErrororden.Visible = true;

            }
            else
            {
                ordenamientos.Visible = false;
                lblErrororden.Visible = false;

            }

        }

        protected void txtindicadorDeseable_TextChanged(object sender, EventArgs e)
        {
            decimal minimo = 0;
            decimal deseable = 0;
            if (txtindicadorMinimo.Text != "")
            {
                minimo = decimal.Parse(txtindicadorMinimo.Text);
            }
            if (txtindicadorDeseable.Text != "")
            {
                deseable = decimal.Parse(txtindicadorDeseable.Text);
            }

            if (minimo == deseable)
            {
                ordenamientos.Visible = true;
                lblErrororden.Visible = true;
            }
            else
            {
                ordenamientos.Visible=false;
                lblErrororden.Visible = false;
            }


        }


        private void limpiar()
        {
            txtdescripcionIndicador.Text = "";
            txtponderacion.Text = "";
            txtindicadorMinimo.Text = "";
            txtindicadorDeseable.Text = "";
            ddltipo.SelectedIndex = 0;

        }

        protected void radGridIndicador_PreRender(object sender, EventArgs e)
        {
            string selectedValue = radEstatus.SelectedText;
            if (selectedValue == "Activo")
            {
                radGridIndicador.MasterTableView.GetColumn("EditarColumn").Visible = true;
                radGridIndicador.MasterTableView.GetColumn("EditarColumn").HeaderText = "Eliminar";
                radGridIndicador.MasterTableView.GetColumn("Estatus").Visible = true;
                radGridIndicador.MasterTableView.GetColumn("Estatus").HeaderText = "Eliminar";
                radGridIndicador.MasterTableView.GetColumn("colActiva").Visible = false;
                radGridIndicador.MasterTableView.GetColumn("colActiva").HeaderText = "Activar";



            }
            else if (selectedValue == "Inactivo")
            {
                radGridIndicador.MasterTableView.GetColumn("EditarColumn").Visible = false;
                radGridIndicador.MasterTableView.GetColumn("EditarColumn").HeaderText = "Activar";
                radGridIndicador.MasterTableView.GetColumn("Estatus").Visible = false;
                radGridIndicador.MasterTableView.GetColumn("Estatus").HeaderText = "Eliminar";
                radGridIndicador.MasterTableView.GetColumn("colActiva").Visible = true;
                radGridIndicador.MasterTableView.GetColumn("colActiva").HeaderText = "Activar";


            }
        }

        protected void btnActiva_Click(object sender, ImageButtonClickEventArgs e)
        {
            DataTable dt = new DataTable();
            RadImageButton bt = (RadImageButton)sender;
            string pIndicadorId = bt.Value;

            actualizaEstatus(int.Parse(pIndicadorId));
            radGridIndicador.DataSource = consulta();
            radGridIndicador.Rebind();
        }
    }
}