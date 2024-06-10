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
        protected DataTable ObtenerInfo()
        {
            DateTime? FechaDe = RadMonthYearPicker1.SelectedDate;
            DateTime? FechaA = RadMonthYearPicker2.SelectedDate;
            //FechaDe.Value.ToString("dd/MM/yyyy")
            DataTable dt = con.getDatatable(string.Format("exec Indicadores .dbo.TableroHistorico2 {0},{1},{2},{3},1 ", FechaDe.Value.Month, FechaDe.Value.Year, FechaA.Value.Month, FechaA.Value.Year));
            return dt;
        }
        protected void Page_Init(object sender, EventArgs e)
        {
            RadMonthYearPicker1.MaxDate = (DateTime)DateTime.Now;
            RadMonthYearPicker1.SelectedDate = (DateTime)DateTime.Now.AddMonths(-5);

            RadMonthYearPicker2.MaxDate = (DateTime)DateTime.Now;
            RadMonthYearPicker2.SelectedDate = (DateTime)DateTime.Now;
            crearGridColumna();
        }
        protected void crearGridColumna()
        {
            PlaceHolder1.Controls.Clear();
            RadGrid RadGridHistorico = new RadGrid();
            RadGridHistorico.AutoGenerateColumns = false;
            DataTable dt = ObtenerInfo();
            RadGridHistorico.DataSource = dt;
            RadGridHistorico.AllowSorting = true;
            RadGridHistorico.AllowFilteringByColumn = true;
            RadGridHistorico.ItemCommand += new GridCommandEventHandler(RadGridHistorico_ItemCommand);
            RadGridHistorico.ItemDataBound += new GridItemEventHandler(RadGridHistorico_ItemDataBound);
            RadGridHistorico.RenderMode = RenderMode.Lightweight;
            RadGridHistorico.CellSpacing = 0;
            RadGridHistorico.Font.Size = 9;
            RadGridHistorico.CellPadding = 0;
            RadGridHistorico.AllowAutomaticDeletes = false;
            RadGridHistorico.AllowAutomaticInserts = false;
            RadGridHistorico.AllowAutomaticUpdates = false;
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
                    if (i > 3)
                    { boundColumn1.CurrentFilterFunction = GridKnownFunction.EqualTo; }
                    else { boundColumn1.CurrentFilterFunction = GridKnownFunction.Custom; }

                    boundColumn1.AutoPostBackOnFilter = true;
                    boundColumn1.FilterControlWidth = Unit.Percentage(80);
                    boundColumn1.ShowFilterIcon = false;
                    RadGridHistorico.MasterTableView.Columns.Add(boundColumn1);
                }

                i = i + 1;
            }

            PlaceHolder1.Controls.Add(RadGridHistorico);
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
            //                //TextBox x;
            //                //x = (filteringItem[boundColumn.UniqueName].Controls[0] as TextBox);
            //                //x.Text = filterValue;
            //                DataTable dt = ObtenerInfo();
            //                DataView dv = dt.DefaultView;
            //                string filterExpression = $"[{boundColumn.DataField}] LIKE '%{(string)filterValue}%'";
            //                dv.RowFilter = filterExpression;
            //                //CrearRadGrid(dv.ToTable ());
            //                RadGridHistorico.DataSource = dv;//.ToTable();
            //                RadGridHistorico.Rebind();
            //                return;
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
                    string cellText = item[columnName].Text;
                    int idex = i + 2;
                    //if (i == 2 || i==1) {
                    //    item[columnName].Width = 150;
                    //}
                    if ((i >= 4 && i <= 6) || i == 2)
                    {
                        item[columnName].HorizontalAlign = HorizontalAlign.Center;
                    }
                    // Si el índice de la columna coincide con las que deseas formatear
                    if (i > 6)
                    {
                        item[columnName].HorizontalAlign = HorizontalAlign.Center;
                        double cellValue;
                        if (double.TryParse(cellText, out cellValue))
                        {

                            if (cellValue >= 80 && cellValue <= 90)
                            {
                                e.Item.Cells[idex].BackColor = System.Drawing.ColorTranslator.FromHtml("#FBCEC0");//rojo
                            }
                            if (cellValue > 90 && cellValue <= 95)
                            {
                                e.Item.Cells[idex].BackColor = System.Drawing.ColorTranslator.FromHtml("#FBF8C0");//amarillo
                            }
                            if (cellValue > 95)
                            {
                                e.Item.Cells[idex].BackColor = System.Drawing.ColorTranslator.FromHtml("#C0FBEF");//azul
                            }
                            //e.Item.Cells[i].Text = e.Item.Cells[i].Text + " %";

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