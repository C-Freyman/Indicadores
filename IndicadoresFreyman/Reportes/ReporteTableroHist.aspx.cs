using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace IndicadoresFreyman.Reportes
{
    public partial class ReporteTableroHist : System.Web.UI.Page
    {
        Conexion con = new Conexion();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //RadGrid1.AutoGenerateColumns = true;
                //RadGrid1.ColumnCreated += RadGrid1_ColumnCreated;
                ObtenerInfo();
            }
        }
        protected DataTable ObtenerInfo()
        {
            DataTable dt = con.getDatatable("exec Indicadores .dbo.TableroHistorico 1,6,1 ");
            if (dt != null){ 

              RadGridHistorico.DataSource = dt;
              RadGridHistorico.Rebind();
              DataTable dtgrafica = con.getDatatable("exec Indicadores .dbo.TableroHistorico 1,6,0 ");
              GenerarPtosGrafica(dtgrafica);
            }
            return dt;
        }
        private void GenerarPtosGrafica(DataTable dt)
        {
            Telerik.Web.UI.RadHtmlChart GraficaLineas = RadHtmlChartIndicadores;
            Telerik.Web.UI.LineSeries S;
            GraficaLineas.PlotArea.XAxis.Items.Clear();
            GraficaLineas.PlotArea.Series.Clear();

            GraficaLineas.PlotArea.YAxis.LabelsAppearance.DataFormatString = "{0} %";

            for (int f = 0; f <= dt.Rows.Count - 1; f++)
            {
                S = new Telerik.Web.UI.LineSeries();
                for (int c = 0; c <= dt.Columns.Count - 1; c++)
                {
                    if (c > 1)
                    {
                        decimal x = (decimal)dt.Rows[f][c];
                        S.SeriesItems.Add(x);
                        if (f == 0)
                            GraficaLineas.PlotArea.XAxis.Items.Add(dt.Columns[c].ColumnName);
                    }
                }
                S.Name = (string)dt.Rows[f]["Nombre"];
                GraficaLineas.PlotArea.Series.Add(S);
                S.Items.Clear();
            }
        }

        protected void RadGridHistorico_ItemDataBound(object sender, Telerik.Web.UI.GridItemEventArgs e)
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

                    int idex = i+2;
                    //if (i == 2 || i==1) {
                    //    item[columnName].Width = 150;
                    //}
                    if ((i>=4 && i<=6)|| i==2) {
                        item[columnName].HorizontalAlign = HorizontalAlign.Center;
                    }
                    // Si el índice de la columna coincide con las que deseas formatear
                    if (i > 6)
                    {
                        item[columnName].HorizontalAlign = HorizontalAlign.Center;
                        double cellValue;
                        if (double.TryParse(cellText, out cellValue))
                        {
                            
                            if (cellValue>=80 && cellValue <=90)
                            {
                                e.Item.Cells[idex].BackColor = System.Drawing.ColorTranslator.FromHtml("#FBCEC0");//rojo
                            }
                            if (cellValue >90 && cellValue <=95 )
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

        protected void RadGridHistorico_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
            ObtenerInfo();
        }

        protected void RadGridHistorico_SortCommand(object sender, Telerik.Web.UI.GridSortCommandEventArgs e)
        {
            ObtenerInfo();
        }

        protected void RadGridHistorico_PreRender(object sender, EventArgs e)
        {
            // Add columns dynamically in PreRender if necessary
            if (RadGridHistorico.MasterTableView.Columns.Count == 0)
            {
                DataTable dt = ObtenerInfo();
                int i = 0;
                foreach (DataColumn column in dt.Columns)
                {
                    string columnName = column.ColumnName;
                    GridBoundColumn itemCol = new GridBoundColumn();
                    itemCol.DataField = columnName;
                    itemCol.UniqueName = columnName ;
                    itemCol.HeaderText = columnName;
                    itemCol.HeaderStyle.Width = 50;
                    itemCol.SortExpression = columnName;

                    itemCol.CurrentFilterFunction = GridKnownFunction.EqualTo;
                    itemCol.ShowFilterIcon = false;
                    itemCol.AutoPostBackOnFilter = true;
                    itemCol.AllowFiltering = true;

                    itemCol.AllowSorting = true;
                    //switch (columnName)
                    //{
                    //    case = "ponderacion":
                    //        Console.WriteLine($"Measured value is {measurement}; too low.");
                    //        break;

                    //    case > 15.0:
                    //        Console.WriteLine($"Measured value is {measurement}; too high.");
                    //        break;

                    //    case double.NaN:
                    //        Console.WriteLine("Failed measurement.");
                    //        break;
                    //}
                    //item["ponderacion"].BackColor = System.Drawing.ColorTranslator.FromHtml("#b39c82");
                    //item["indicadorMinimo"].BackColor = System.Drawing.ColorTranslator.FromHtml("#b8c99d");
                    //item["indicadorDeseable"].BackColor = System.Drawing.ColorTranslator.FromHtml("#f0d399");

                    RadGridHistorico.MasterTableView.Columns.Add(itemCol);
                    i = i + 1;
                }
                RadGridHistorico.Rebind();
            }
        }

        private List<int> columnsToHide = new List<int> { 2 };// {2,3,4,5,6}; // Índices de las columnas que desea ocultar
        private int columnIndexCounter = 0;
        protected void RadGridHistorico_ColumnCreated(object sender, Telerik.Web.UI.GridColumnCreatedEventArgs e)
        {
            if (columnsToHide.Contains(columnIndexCounter))
            {
                e.Column.Visible = false;
            }

            if (columnIndexCounter > 2)
            {
                // (e.Column as GridBoundColumn).DataField = e.Column.UniqueName;

                e.Column.CurrentFilterFunction = GridKnownFunction.EqualTo;
                e.Column.ShowFilterIcon = false;
                e.Column.AutoPostBackOnFilter = true;
                e.Column.HeaderStyle.Width = 50;
                //columnNames.Add(e.Column.UniqueName);
                // e.Column.HeaderText = e.Column.UniqueName;

                if (columnIndexCounter > 7)
                {
                    //(e.Column as GridBoundColumn).Aggregate = GridAggregateFunction.Sum;
                    //(e.Column as GridBoundColumn).FooterAggregateFormatString = "{0:C0}";
                }
                if (columnIndexCounter == 3 || columnIndexCounter == 4)
                {
                    e.Column.CurrentFilterFunction = GridKnownFunction.Contains;
                    e.Column.HeaderStyle.Width = Unit.Pixel(150);
                }

                //e.Column.AllowFiltering = false;
                e.Column.HeaderStyle.BackColor = System.Drawing.Color.Red;
            }

            columnIndexCounter++;
        }

    }
}