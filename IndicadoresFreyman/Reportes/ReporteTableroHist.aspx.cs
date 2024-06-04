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
        protected void ObtenerInfo()
        {
            DataTable dt = con.getDatatable("exec Indicadores .dbo.TableroHistorico 1,6,1 ");
            RadGridHistorico.DataSource = dt;
            RadGridHistorico.Rebind();
            DataTable dtgrafica = con.getDatatable("exec Indicadores .dbo.TableroHistorico 1,6,0 ");
            GenerarPtosGrafica(dtgrafica);
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
                //for (int i = 0; i < item.OwnerTableView.Columns.Count; i++)
                for (int i = 0; i < item.OwnerTableView.Columns.Count; i++)
                {
                    string columnName = item.OwnerTableView.Columns[i].UniqueName;
                    string cellText = item[columnName].Text;

                    // Si el índice de la columna coincide con las que deseas formatear
                    if (i > 7)
                    {
                        double cellValue;
                        if (double.TryParse(cellText, out cellValue))
                        {
                            e.Item.Cells[i].Text = (cellValue * 100).ToString().Split('.')[0] + " %";
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
                (e.Column as GridBoundColumn).DataField = e.Column.UniqueName;
                e.Column.CurrentFilterFunction = GridKnownFunction.EqualTo;
                e.Column.ShowFilterIcon = false;
                e.Column.AutoPostBackOnFilter = true;
                e.Column.HeaderStyle.Width = 50;
                //columnNames.Add(e.Column.UniqueName);
                e.Column.HeaderText = e.Column.UniqueName;
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