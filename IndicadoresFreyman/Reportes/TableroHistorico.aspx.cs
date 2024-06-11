using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using Telerik.Web.UI.Skins;
using Telerik.Windows.Documents.Flow.Model.StructuredDocumentTags;
using RadGrid = Telerik.Web.UI.RadGrid;

namespace IndicadoresFreyman.Reportes
{
    public partial class TableroHistorico : System.Web.UI.Page
    {
        Conexion con = new Conexion();
        protected void Page_Load(object sender, EventArgs e)
        {
           
            if (IsPostBack == false)
            {
            }

        }
        protected void Page_Init(object sender, EventArgs e)
        {
            string TipoTablero = Request.QueryString["TipoTablero"];
            HidTipoTablero.Value = TipoTablero;

            RadMonthYearPicker1.MaxDate = (DateTime)DateTime.Now;
            RadMonthYearPicker1.SelectedDate = (DateTime)DateTime.Now.AddMonths(-5);

            RadMonthYearPicker2.MaxDate = (DateTime)DateTime.Now;
            RadMonthYearPicker2.SelectedDate = (DateTime)DateTime.Now;
            crearGridColumna();
        }
        protected DataTable ObtenerInfo()
        {
            DataTable dtAux;

            DateTime? FechaDe = RadMonthYearPicker1.SelectedDate;
            DateTime? FechaA = RadMonthYearPicker2.SelectedDate;
            DataTable dt=null;
            if (HidTipoTablero.Value=="I") {
                dt = con.getDatatable(string.Format("exec Indicadores .dbo.TableroHistorico2 {0},{1},{2},{3},1 ", FechaDe.Value.Month, FechaDe.Value.Year, FechaA.Value.Month, FechaA.Value.Year));
            }
            if (HidTipoTablero.Value == "E")
            {
                dt = con.getDatatable(string.Format("exec Indicadores .dbo.TableroHistorico2 {0},{1},{2},{3},0 ", FechaDe.Value.Month, FechaDe.Value.Year, FechaA.Value.Month, FechaA.Value.Year));
            }
            //FechaDe.Value.ToString("dd/MM/yyyy")
            //if (HidFiltro.Value != "") {
            //    DataView dv = dt.DefaultView;
            //    dv.RowFilter = HidFiltro .Value ;
            //    dt = dv.ToTable() ;
            //}
            //var dtCOMPAÑEROS = con.getDatatable(@"select IdEmpleado from Vacaciones.dbo.AdministrativosNomiChecador as a1 where a1.Departamento = 
            //(select a2.Departamento from Vacaciones.dbo.AdministrativosNomiChecador as a2 where idempleado=" + Session["LogFar"] + @") 
            //union all 
            //select a1.IdEmpleado from Vacaciones.dbo.AdministrativosNomiChecador as a1 where Jefe2 = 
            //(select correo from Vacaciones.dbo.AdministrativosNomiChecador as a2 where IdEmpleado =" + Session["LogFar"] + @") 
            //or jefeinmediato= 
            //(select correo from Vacaciones.dbo.AdministrativosNomiChecador as a2 where IdEmpleado  =" + Session["LogFar"] + @")");

            //var lst = (from c in dtCOMPAÑEROS.AsEnumerable() select c.Field<int>("IdEmpleado")).ToList();
            //dtAux = (from c in dt.AsEnumerable() where lst.Contains(c.Field<int>("IdEmpleado")) select c).CopyToDataTable();

           // string EMpleados = string.Join(",", lst);

            //if (dtAux == null)
            //{
            //    dtAux = dt;
            //}
            return dt;
        }
       
        protected void crearGridColumna()
        {
            PlaceHolder1.Controls.Clear();
            DataTable dt = ObtenerInfo();
            if (dt.Rows.Count > 0) {
                RadGrid RadGridHistorico = new RadGrid();
                RadGridHistorico.AutoGenerateColumns = false;
                RadGridHistorico.AllowSorting = true;
                RadGridHistorico.AllowFilteringByColumn = true;
                RadGridHistorico.ItemCommand += new GridCommandEventHandler(RadGridHistorico_ItemCommand);
                RadGridHistorico.ItemDataBound += new GridItemEventHandler(RadGridHistorico_ItemDataBound);
             RadGridHistorico.NeedDataSource += new GridNeedDataSourceEventHandler(RadGridHistorico_NeedDataSource);
                //RadGridHistorico.DataSource = dt;
                RadGridHistorico.RenderMode = RenderMode.Lightweight;
                RadGridHistorico.CellSpacing = 0;
                RadGridHistorico.Font.Size = 9;
                RadGridHistorico.CellPadding = 0;
                RadGridHistorico.AllowAutomaticDeletes = false;
                RadGridHistorico.AllowAutomaticInserts = false;
                RadGridHistorico.AllowAutomaticUpdates = false;

                List<int> columnsNumero = new List<int> { 3, 5, 6, 7 };
                int i = 0;
                foreach (DataColumn column in dt.Columns)
                {
                    if (column.ColumnName != "IdEmpleado")
                    {
                        GridBoundColumn boundColumn1 = new GridBoundColumn();
                        boundColumn1.DataField = column.ColumnName;
                        boundColumn1.UniqueName = column.ColumnName;
                        boundColumn1.HeaderText = column.ColumnName;
                        boundColumn1.AllowFiltering = true;
                        boundColumn1.AutoPostBackOnFilter = true;
                        boundColumn1.FilterControlWidth = Unit.Percentage(80);
                        boundColumn1.ShowFilterIcon = false;

                        if (columnsNumero.Contains(i))
                        {
                            boundColumn1.CurrentFilterFunction = GridKnownFunction.EqualTo;
                        }
                        else
                        {
                            boundColumn1.CurrentFilterFunction = GridKnownFunction.Contains;
                        }

                        RadGridHistorico.MasterTableView.Columns.Add(boundColumn1);
                    }
                    i++;
                }
                RadGridHistorico.DataSource = dt;
                RadGridHistorico .Rebind();

                PlaceHolder1.Controls.Add(RadGridHistorico);
            }
          
        }
        protected void RadGridHistorico_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            RadGrid RadGridHistorico = sender as RadGrid;
            RadGridHistorico.DataSource = ObtenerInfo();
        }

        protected void RadGridHistorico_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
           
            //if (e.CommandName == RadGrid.FilterCommandName)
            //{
            //    RadGrid RadGridHistorico = sender as RadGrid;
            //    GridFilteringItem filteringItem = e.Item as GridFilteringItem;

            //    foreach (GridColumn column in RadGridHistorico.MasterTableView.Columns)
            //    {
            //        if (column is GridBoundColumn)
            //        {
            //            GridBoundColumn boundColumn = column as GridBoundColumn;
            //            string filterValue = (filteringItem[boundColumn.UniqueName].Controls[0] as TextBox).Text.ToLower();

            //            if (!string.IsNullOrEmpty(filterValue))
            //            {
            //                double valor;
            //                if (double.TryParse(filterValue, out valor))
            //                { }
            //                else
            //                {
            //                    //TextBox x;
            //                    //x = (filteringItem[boundColumn.UniqueName].Controls[0] as TextBox);
            //                    //x.Text = filterValue;
            //                    DataTable dt = ObtenerInfo();
            //                    dt.CaseSensitive = false;
            //                    DataView dv = dt.DefaultView;
            //                    string filterExpression = $"[{boundColumn.DataField}] LIKE '%{(string)filterValue}%'";
            //                    dv.RowFilter = filterExpression;
            //                    //CrearRadGrid(dv.ToTable ());
            //                    //RadGridHistorico.DataSource = null;//.ToTable();
            //                    //RadGridHistorico.Rebind();
            //                    RadGridHistorico.DataSource = dv;//.ToTable();
            //                    RadGridHistorico.Rebind();
            //                    //HidFiltro.Value = filterExpression;

            //                    return;
            //                }
            //            }
            //        }
            //    }
            //}

        }

        protected void RadGridHistorico_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem item = e.Item as GridDataItem;
                if (HidTipoTablero.Value == "I")
                { 
                    item["ponderacion"].BackColor = System.Drawing.ColorTranslator.FromHtml("#D8E8E5");
                    item["indicadorMinimo"].BackColor = System.Drawing.ColorTranslator.FromHtml("#D8E8E5");
                    item["indicadorDeseable"].BackColor = System.Drawing.ColorTranslator.FromHtml("#D8E8E5");

                    item["ponderacion"].Font.Bold = true;
                    item["indicadorMinimo"].Font.Bold = true;
                    item["indicadorDeseable"].Font.Bold = true;

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
                                double cellValue;
                                string cellText = valor.Split('_')[1];
                                item[columnName].ToolTip = cellText;
                                if (double.TryParse(cellText, out cellValue))
                                {

                                    if (cellValue >= 0 && cellValue <= 80)
                                    {
                                        e.Item.Cells[idex].BackColor = System.Drawing.ColorTranslator.FromHtml("#FBCEC0");//rojo
                                    }
                                    if (cellValue > 80 && cellValue <= 90)
                                    {
                                        e.Item.Cells[idex].BackColor = System.Drawing.ColorTranslator.FromHtml("#FBF8C0");//amarillo
                                    }
                                    if (cellValue > 90)
                                    {
                                        e.Item.Cells[idex].BackColor = System.Drawing.ColorTranslator.FromHtml("#C0FBEF");//azul
                                    }
                                    //e.Item.Cells[i].Text = e.Item.Cells[i].Text + " %";

                                }
                            }
                            item[columnName].Text = item[columnName].Text.Split('_')[0];

                        }
                    }

                }
                  
            }
        }


        protected void btnActualizar_Click(object sender, ImageClickEventArgs e)
        {
            crearGridColumna();
        }
    }

}