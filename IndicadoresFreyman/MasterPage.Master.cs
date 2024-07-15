using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace IndicadoresFreyman
{
    public partial class MasterPage : System.Web.UI.MasterPage
    {
        Conexion con =new Conexion();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (Session["Log"] == null)
                {
                    Response.Redirect("~/Log.aspx");
                }
            }
            catch (Exception ex)
            {
                // Manejar la excepción si es necesario
            }
            //Session["Log"] = 1356;// 5273;

            int empleado = (int)Session["Log"];
            var dtJefe = con.getDatatable ("select * from Vacaciones.dbo.AdministrativosNomiChecador where (Departamento ='RECURSOS HUMANOS' or departamento='CONTRALORIA') and idempleado=" + Session["Log"] );
            if (dtJefe.Rows.Count == 0)//solo si es de RRHH o arturo
            {
                RadMenu1.Items[2].Items[2].Visible = false;
            }

            //oculata menu de crear Indicadores
            DataTable dt;
            string strsql = String.Format("select IdEmpleado,nombre, DeptoId, Departamento from  Vacaciones.dbo.AdministrativosNomiChecador where JefeInmediato = (select correo from Vacaciones.dbo.AdministrativosNomiChecador where IdEmpleado = {0})", empleado);
            dt = con.getDatatable(strsql);
            if (dt.Rows.Count == 0)
            {
                RadMenu1.Items[0].Visible = false;
            }
        }
        protected override void OnInit(EventArgs e)
        {
            RadMenuItem currentItem = RadMenu1.FindItemByUrl(Request.Url.PathAndQuery);
            if (currentItem != null)
            {
                currentItem.HighlightPath();
                currentItem.Selected = true;

            
            }
            base.OnInit(e);
        }
        protected void btnDeslog_Click(object sender, ImageClickEventArgs e)
        {
            Session["Log"] = null;
            Response.Redirect("/Log.aspx");
        }

        protected void btnSalir_Click(object sender, EventArgs e)
        {
            Session["Log"] = null;
            Response.Redirect("/Log.aspx");
        }

        protected void btnManual_Click(object sender, ImageClickEventArgs e)
        {

        }
    }
}