using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace IndicadoresFreyman
{
    public partial class Log : System.Web.UI.Page
    {
        Conexion con = new Conexion();
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void BtnIngresar_Click(object sender, EventArgs e)
        {
            string q = string.Format("select *from Vacaciones .dbo.AdministrativosNomiChecador where  usuario='{0}' and contraseña='{1}'", txtUsuario.Value, txtContraseña.Value);
            DataTable dtusuario = con.getDatatable  (q);

            if (dtusuario.Rows.Count > 0)
            {
               
                Session["Log"] = dtusuario.Rows[0]["IdEmpleado"];

                Response.Redirect("~/Default.aspx");

            }
            else
            {
                ClientScript.RegisterStartupScript(Page.GetType(), "msj", "<script>alert('El usuario y/o contraseña son incorrectos.');</script>");
            }
        }
    }
}