﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using Telerik.Web.UI.Gantt;

namespace IndicadoresFreyman.Reportes
{
    public partial class Tablero : System.Web.UI.Page
    {
        Conexion con = new Conexion();
        private double calificacionMinima;
        protected void Page_Load(object sender, EventArgs e)
        {
            ConfiguracionIndicadores();
            string TipoTablero = Request.QueryString["TipoTablero"];
            HidTipoTablero.Value = TipoTablero;

            HidEmpleado.Value = Session["log"]?.ToString();
            if (!IsPostBack)
            {
                if (HidTipoTablero.Value == "I")
                {
                    Titulo.InnerText = "Tablero por Indicadores";
                }
                else
                {
                    Titulo.InnerText = "Tablero por Empleado";
                }
                RadMonthYearPicker1.MaxDate = (DateTime)DateTime.Now;
                RadMonthYearPicker1.SelectedDate = (DateTime)DateTime.Now.AddMonths(-5);

                RadMonthYearPicker2.MaxDate = (DateTime)DateTime.Now;
                RadMonthYearPicker2.SelectedDate = (DateTime)DateTime.Now;
                ObtenerInfo();
            }
           
            
        }
        private void ConfiguracionIndicadores()
        {

            using (var con = new SqlConnection("Server = 192.168.0.76; User ID = sa; password=similares*3; DataBase=Indicadores;"))

            {
                con.Open();
                using (var cmd = new SqlCommand("SELECT *FROM (SELECT idConfiguracion, valor FROM Configuraciones) as SourceTable PIVOT (MAX(valor)FOR idConfiguracion IN ([1], [2])) as PivotTable;"))
                {
                    cmd.Connection = con;
                    SqlDataReader reader = cmd.ExecuteReader();
                    while (reader.Read())
                    {
                        calificacionMinima = Convert.ToDouble(reader["2"]);//calificacion minima
                    }
                }
            }
        }
        protected DataTable ObtenerInfo()
        {

                  DataTable dtAux=null;
            try
            {
               

            DateTime? FechaDe = RadMonthYearPicker1.SelectedDate;
            DateTime? FechaA = RadMonthYearPicker2.SelectedDate;
            DataTable dt = null;

            dt = con.getDatatable(string.Format("exec Indicadores .dbo.TableroHistorico {0},{1},{2},{3},'"+ HidTipoTablero.Value + "'", FechaDe.Value.Month, FechaDe.Value.Year, FechaA.Value.Month, FechaA.Value.Year));

                var dtCOMPAÑEROS = con.getDatatable(@"select IdEmpleado from Vacaciones.dbo.AdministrativosNomiChecador as a1 where a1.Departamento = 
                (select a2.Departamento from Vacaciones.dbo.AdministrativosNomiChecador as a2 where idempleado=" + HidEmpleado.Value + @") 
                union all 
                select a1.IdEmpleado from Vacaciones.dbo.AdministrativosNomiChecador as a1 where Jefe2 = 
                (select correo from Vacaciones.dbo.AdministrativosNomiChecador as a2 where IdEmpleado =" + HidEmpleado.Value + @") 
                or jefeinmediato= 
                (select correo from Vacaciones.dbo.AdministrativosNomiChecador as a2 where IdEmpleado  =" + HidEmpleado.Value + @")");

                var lst = (from c in dtCOMPAÑEROS.AsEnumerable() select c.Field<int>("IdEmpleado")).ToList();
                dtAux = (from c in dt.AsEnumerable() where lst.Contains(c.Field<int>("IdEmpleado")) select c).CopyToDataTable();

                if (dtAux == null || HidEmpleado.Value == "42")
                {
                    dtAux = dt;
                }
                GenerarColumnas(dtAux);
                RadGridHistorico.DataSource = dtAux;
                RadGridHistorico.Rebind();
                return dtAux;
            }
            catch (Exception ex) { }
            return dtAux;
        }
        private void GenerarColumnas(DataTable dt)
        {
            RadGridHistorico.Columns.Clear();
            List<int> columnsNumero = new List<int> { 3, 5, 6, 7 };
            int indextipo;
            if (HidTipoTablero.Value == "I")
            { indextipo = 8; }
            else { indextipo = 3; }
                int i = 0;
            foreach (DataColumn c in dt.Columns)
            {
                if (c.ColumnName != "IdEmpleado")
                {
                    GridBoundColumn campo = new GridBoundColumn();

                    if (i >= indextipo)
                    {
                        campo.HeaderStyle.Width = 70;
                        DateTime fecha = Convert.ToDateTime("1/" + c.ColumnName.Split('_')[0] + "/" + c.ColumnName.Split('_')[1]);
                       
                        campo.HeaderText = fecha.ToString("MMMM /yyyy");
                        campo.SortExpression = c.ColumnName;
                        campo.AllowFiltering = true;
                        campo.AllowSorting = true;
                        campo.CurrentFilterFunction = GridKnownFunction.Contains;
                        campo.AutoPostBackOnFilter = true;
                        campo.ShowFilterIcon = false;
                        campo.FilterControlWidth = Unit.Percentage(80);
                    }
                    else
                    {
                        campo.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
                        campo.HeaderText = c.ColumnName;
                        campo.SortExpression = c.ColumnName;
                        campo.ShowFilterIcon = false;
                        campo.CurrentFilterFunction = GridKnownFunction.Contains;
                        campo.AutoPostBackOnFilter = true;
                        campo.FilterControlWidth = Unit.Percentage(80);
                    }
                    if (columnsNumero.Contains(i))
                    {
                        campo.CurrentFilterFunction = GridKnownFunction.EqualTo;
                        campo.HeaderStyle.Width = 80;

                    }
                  
                    else
                    {
                        campo.CurrentFilterFunction = GridKnownFunction.Contains;
                    }

                    campo.DataField = c.ColumnName;
                    RadGridHistorico.Columns.Add(campo);
                }

                i++;
            }
        }

        protected void btnActualizar_Click(object sender, ImageClickEventArgs e)
        {
            ObtenerInfo();
        }

        protected void RadGridHistorico_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                double mid = (calificacionMinima + 100) / 2;

                GridDataItem item = e.Item as GridDataItem;
                if (HidTipoTablero.Value == "I")
                {
                    item["Ponderación"].BackColor = System.Drawing.ColorTranslator.FromHtml("#D8E8E5");
                    item["Indicador Mínimo"].BackColor = System.Drawing.ColorTranslator.FromHtml("#D8E8E5");
                    item["Indicador Deseable"].BackColor = System.Drawing.ColorTranslator.FromHtml("#D8E8E5");

                    item["Ponderación"].Font.Bold = true;
                    item["Indicador Mínimo"].Font.Bold = true;
                    item["Indicador Deseable"].Font.Bold = true;


                    //for (int i = 0; i < item.OwnerTableView.Columns.Count; i++)
                    for (int i = 0; i < item.OwnerTableView.Columns.Count; i++)
                    {
                        string columnName = item.OwnerTableView.Columns[i].UniqueName;

                        int idex = i + 2;

                        if ((i >= 4 && i <= 6) || i == 2)
                        {
                            item[columnName].HorizontalAlign = HorizontalAlign.Center;
                        }
                        // Si el índice de la columna coincide con las que deseas formatear
                        if (i > 6)
                        {
                            //el valor text, esta en dos partes(resultado, cumplimientoObjetivo) el valor es resultado y el cumplimientoObjetivo es el color
                            string valor = (string)item[columnName].Text;
                            int cantval = (int)item[columnName].Text.Split('_').Length;
                            if (cantval >= 2)
                            {

                                item[columnName].HorizontalAlign = HorizontalAlign.Center;
                                double cellValue=0;
                                string cellText = valor.Split('_')[1];
                                 item[columnName].ToolTip ="Resultado:" + (string)valor.Split('_')[0] + " Calificación: " +cellText  ;

                                if (double.TryParse(valor.Split('_')[1], out cellValue))
                                {
                                    if (cellValue >= 0 && cellValue < calificacionMinima)
                                    {
                                        e.Item.Cells[idex].BackColor = System.Drawing.ColorTranslator.FromHtml("#FBCEC0");//rojo
                                    }
                                    if (cellValue >= calificacionMinima && cellValue < mid)
                                    {
                                        e.Item.Cells[idex].BackColor = System.Drawing.ColorTranslator.FromHtml("#FBF8C0");//amarillo
                                    }

                                    if (cellValue >= mid && cellValue <=100)

                                    {
                                        e.Item.Cells[idex].BackColor = System.Drawing.ColorTranslator.FromHtml("#CCF7C3");//verde
                                    }
                                    if (cellValue >100) {
                                        e.Item.Cells[idex].BackColor = System.Drawing.ColorTranslator.FromHtml("#C0FBEF");//azul
                                    }
                                    //e.Item.Cells[i].Text = e.Item.Cells[i].Text + " %";

                                }
                            }
                            item[columnName].Text = item[columnName].Text.Split('_')[0];

                        }
                    }

                }
                if (HidTipoTablero.Value == "E")
                {
                    for (int i = 0; i < item.OwnerTableView.Columns.Count; i++)
                    {
                        string columnName = item.OwnerTableView.Columns[i].UniqueName;
                        int idex = i + 2;
                        string cellText = (string)item[columnName].Text;
                        double cellValue;
                        if (double.TryParse(cellText, out cellValue))
                        {
                            if (cellValue >= 0 && cellValue < calificacionMinima)
                            {
                                e.Item.Cells[idex].BackColor = System.Drawing.ColorTranslator.FromHtml("#FBCEC0");//rojo
                            }
                            if (cellValue >= calificacionMinima && cellValue < mid)
                            {
                                e.Item.Cells[idex].BackColor = System.Drawing.ColorTranslator.FromHtml("#FBF8C0");//amarillo
                            }

                            if (cellValue >= mid && cellValue <= 100)
                            {
                                e.Item.Cells[idex].BackColor = System.Drawing.ColorTranslator.FromHtml("#CCF7C3");//verde
                            }
                            //e.Item.Cells[i].Text = e.Item.Cells[i].Text + " %";

                        }
                    }
                }
            }
        }
      

        protected void RadGridHistorico_ItemCommand(object sender, GridCommandEventArgs e)
        {
            if (e.CommandName == RadGrid.FilterCommandName)
            {
                Pair laPaire = (Pair)e.CommandArgument;
                try
                {
                    TextBox txtdescripcionIndicador = (TextBox)(((GridFilteringItem)e.Item)["Nombre"].Controls[0]);
                    txtdescripcionIndicador.Text = txtdescripcionIndicador.Text.ToUpper();

                    TextBox txtDepartamento = (TextBox)(((GridFilteringItem)e.Item)["Departamento"].Controls[0]);
                    txtDepartamento.Text = txtDepartamento.Text.ToUpper();
                }
                catch (Exception ex)
                {
                    int c = 9;
                }

            }
            ObtenerInfo();
        }

        protected void RadGridHistorico_SortCommand(object sender, GridSortCommandEventArgs e)
        {
            ObtenerInfo();
        }
    }
}