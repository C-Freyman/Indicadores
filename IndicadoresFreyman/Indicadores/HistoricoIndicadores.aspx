<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HistoricoIndicadores.aspx.cs" Inherits="IndicadoresFreyman.Indicadores.HistoricoIndicadores" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<!DOCTYPE html>

<style>
    .demo-container {
        float: left;
        margin-right: 50px;
        font: 400 14px / 1.4 Arial, Helvetica, sans-serif;
        font-style: normal;
        margin: 40px auto;
        padding: 20px;
        border: 1px solid #e2e4e7;
    }
</style>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <telerik:RadScriptManager runat="server" ID="RadScriptManager1" />
 
        <div class="demo-container">
            <h3>Mes</h3>
            <telerik:RadDropDownList RenderMode="Lightweight" ID="RadDropDownList1" runat="server" Width="300" Height="200px" DropDownHeight="200px"
                DataTextField="ContactName" EnableVirtualScrolling="true" AutoPostBack="true" OnSelectedIndexChanged="RadDropDownList1_SelectedIndexChanged">
            </telerik:RadDropDownList>
        </div>
        <div class="grid">
            
            <telerik:RadAjaxLoadingPanel runat="server" ID="RadAjaxLoadingPanel1"></telerik:RadAjaxLoadingPanel>
            <telerik:RadFormDecorator RenderMode="Lightweight" ID="RadFormDecorator1" runat="server" DecorationZoneID="demo" DecoratedControls="All" EnableRoundedCorners="false" />
            <telerik:RadGrid RenderMode="Lightweight" ID="gridHistorico" GridLines="None" runat="server"
                CellSpacing="0" CellPadding="0" Font-Size="Smaller" Style="padding: 0; margin: 0 auto"
                AllowAutomaticInserts="True" PageSize="10" AllowAutomaticUpdates="True" AllowPaging="True" 
                AutoGenerateColumns="False" ShowFooter="true">

                <MasterTableView  CommandItemDisplay="Top" AutoGenerateColumns="False" CellPadding="0" CellSpacing="0">
                    <CommandItemSettings ShowAddNewRecordButton="false" ShowCancelChangesButton="false" ShowSaveChangesButton="false" ShowRefreshButton="false"/>

                    <Columns>
                        <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='20' UniqueName="indicadorId" DataField='indicadorId' SortExpression="indicadorId" HeaderText='ID' 
                            ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon='false' HeaderStyle-HorizontalAlign="center"></telerik:GridBoundColumn>
                        <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='80' UniqueName="descripcionIndicador" DataField='descripcionIndicador' SortExpression="descripcionIndicador" 
                            HeaderText='Descripción' ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon='false' HeaderStyle-HorizontalAlign="center"></telerik:GridBoundColumn>
                        <telerik:GridBoundColumn FilterControlWidth="80%" HeaderStyle-Width='20' UniqueName="ponderacion" DataField='ponderacion' SortExpression="ponderacion" HeaderText='Ponderación' 
                            ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon='false' HeaderStyle-HorizontalAlign="center"></telerik:GridBoundColumn>
                        <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='20' UniqueName="indicadorMinimo" DataField='indicadorMinimo' SortExpression="indicadorMinimo" HeaderText='IndicadorMinimo' 
                            ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon='false' HeaderStyle-HorizontalAlign="center"></telerik:GridBoundColumn>
                        <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='20' UniqueName="indicadorDeseable" DataField='indicadorDeseable' SortExpression="indicadorDeseable" 
                            HeaderText='IndicadorDeseable' ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon='false' HeaderStyle-HorizontalAlign="center"></telerik:GridBoundColumn>
                        <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='20' UniqueName="resultado" DataField='resultado' SortExpression="resultado" HeaderText='Resultado' 
                            ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon='false' HeaderStyle-HorizontalAlign="center" ItemStyle-BackColor="#BFBBBB"></telerik:GridBoundColumn>
                        <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='20' UniqueName="cumplimientoObjetivo" DataField='cumplimientoObjetivo' SortExpression="cumplimientoObjetivo" 
                            HeaderText='CumplimientoObjetivo' ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon='false' HeaderStyle-HorizontalAlign="center"></telerik:GridBoundColumn>
                        <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='50' UniqueName="evaluacionPonderada" DataField='evaluacionPonderada' SortExpression="evaluacionPonderada"
                            HeaderText='EvaluacionPonderada' ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon='false'  HeaderStyle-HorizontalAlign="center"></telerik:GridBoundColumn>
                    </Columns>
                    <FooterStyle Height="30px" HorizontalAlign="Center" Font-Size="Medium" Font-Bold="true"/>
                </MasterTableView>
                <ClientSettings AllowKeyboardNavigation="true">
                    <ClientEvents OnBatchEditCellValueChanged="BatchEditCellValueChanged"/>
                </ClientSettings>
            </telerik:RadGrid>
        </div>
    </form>
</body>
</html>
