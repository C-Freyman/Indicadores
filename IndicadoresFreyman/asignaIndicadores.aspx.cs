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
    public partial class asignaIndicadores : System.Web.UI.Page
    {
        Conexion con = new Conexion();
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            foreach (GridDataItem fila in radIndicador.MasterTableView.Items)
            {
                bool isChecked = ((CheckBox)fila.FindControl("chkAsignado")).Checked;
                if (isChecked)
                {

                    string descripciondescripcionIndicador = fila["descripcionIndicador"].Text;
                    string ponderacion = ((TextBox)fila.FindControl("txtponderacion")).Text;

                }
            }
        }


        private DataTable consulta()
        {
            DataTable dt;
            string strsql = "exec consultaPlantillaIndicador " + 1 +  ",  " + 3246;
            dt = con.getDatatable(strsql);
            return dt;
        }

        protected void radIndicador_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            radIndicador.DataSource = consulta();
        }

        protected void chkAsignado_CheckedChanged(object sender, EventArgs e)
        {

        }
    }


    
}