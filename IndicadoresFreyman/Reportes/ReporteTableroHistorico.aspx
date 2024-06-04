<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReporteTableroHistorico.aspx.cs" Inherits="IndicadoresFreyman.Reportes.ReporteTableroHistorico" %>

<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <style>
        body {
        font-family:Calibri;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <table>
            <tr style="background-color: dimgray; color: white; font-weight: bold; text-align :center ">
                <td>Detalle</td>
                <td>Gráfico</td>
            </tr>
            <tr>
                <td style="width:70%">
                    <telerik:RadGrid RenderMode="Lightweight" ID="RadGridHistorico" runat="server" CellSpacing="0" CellPadding="0" Font-Size="Smaller" Style="padding: 0; margin: 0 auto"
                        GridLines="None" AllowSorting="true" shownosorticons="true" AllowFilteringByColumn="True" EnableHeaderContextFilterMenu="true"
                        showfiltericon="false" OnItemDataBound="RadGridHistorico_ItemDataBound" OnSortCommand="RadGridHistorico_SortCommand" AllowPaging="True" OnItemCommand="RadGridHistorico_ItemCommand"
                        PageSize="50" AllowAutomaticDeletes="False" AllowAutomaticInserts="False" OnColumnCreated="RadGridHistorico_ColumnCreated" AllowAutomaticUpdates="False" Culture="es-ES">
                        <ClientSettings>
                            <Animation AllowColumnReorderAnimation="true" />
                            <Scrolling AllowScroll="True" UseStaticHeaders="true" ScrollHeight="370" />
                            <Resizing AllowColumnResize="true" ResizeGridOnColumnResize="true" AllowResizeToFit="true" />
                        </ClientSettings>
                        <GroupingSettings CaseSensitive="false"></GroupingSettings>
                        <HeaderStyle HorizontalAlign="Center" />
                        <MasterTableView AutoGenerateColumns="true" ShowFooter="true" AllowFilteringByColumn="true"  CellPadding="0" CellSpacing="0">
                            <Columns>
                               <%-- <telerik:GridBoundColumn FilterControlWidth="80%" HeaderStyle-Width='150' SortExpression='Nombre' DataField='Nombre' HeaderText='Nombre' ItemStyle-HorizontalAlign="Left" AllowFiltering="true" ShowFilterIcon="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains"></telerik:GridBoundColumn>
                                <telerik:GridBoundColumn FilterControlWidth="80%" HeaderStyle-Width='180' SortExpression='descripcionIndicador' DataField='descripcionIndicador' HeaderText='Indicador' ItemStyle-HorizontalAlign="Left" AllowFiltering="true" ShowFilterIcon="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains"></telerik:GridBoundColumn>
                                <telerik:GridBoundColumn FilterControlWidth="80%" HeaderStyle-Width='50' SortExpression='indicadorMinimo' DataField='indicadorMinimo' HeaderText='Indicador Mínimo' ItemStyle-HorizontalAlign="Left" AllowFiltering="true" ShowFilterIcon="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains"></telerik:GridBoundColumn>
                                <telerik:GridBoundColumn FilterControlWidth="80%" HeaderStyle-Width='50' SortExpression='indicadorDeseable' DataField='indicadorDeseable' HeaderText='Indicador Deseable' ItemStyle-HorizontalAlign="Left" AllowFiltering="true" ShowFilterIcon="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains"></telerik:GridBoundColumn>
                                <telerik:GridBoundColumn FilterControlWidth="80%" HeaderStyle-Width='50' SortExpression='ponderacion' DataField='ponderacion' HeaderText='Ponderación' ItemStyle-HorizontalAlign="Left" AllowFiltering="true" ShowFilterIcon="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains"></telerik:GridBoundColumn>--%>
                            </Columns>
                        </MasterTableView>

                    </telerik:RadGrid></td>
                <td>
                    <telerik:RadHtmlChart runat="server" ID="RadHtmlChartIndicadores" Width="100%"   Transitions="true" >
                        <Appearance>
                            <FillStyle BackgroundColor="Transparent"></FillStyle>
                        </Appearance>
                        <Legend>
                            <Appearance BackgroundColor="Transparent" Position="Bottom">
                            </Appearance>
                        </Legend>
                        <PlotArea>
                            <Appearance>
                                <FillStyle BackgroundColor="Transparent"></FillStyle>
                            </Appearance>
                            <XAxis AxisCrossingValue="0" Color="black" MajorTickType="Outside" MinorTickType="Outside"
                                Reversed="false">

                                <LabelsAppearance DataFormatString="{0}" RotationAngle="0" Skip="0" Step="10">
                                </LabelsAppearance>

                            </XAxis>
                        </PlotArea>
                    </telerik:RadHtmlChart>
                </td>
            </tr>
        </table>

    </form>
</body>
</html>
