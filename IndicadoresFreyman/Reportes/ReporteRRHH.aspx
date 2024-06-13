<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="ReporteRRHH.aspx.cs" Inherits="IndicadoresFreyman.Reportes.ReporteRRHH" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        function exportToExcel(sender, args) {
            var masterTable = $find('<%= RadGridRRHH.ClientID %>').get_masterTableView();
            masterTable.exportToExcel();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div style="text-align: center">
        MES: &nbsp &nbsp<telerik:RadMonthYearPicker RenderMode="Lightweight" ID="RadMonthYearPicker1" runat="server" Width="238px" MinDate="2024-01-1">
        </telerik:RadMonthYearPicker>
        <asp:ImageButton ID="btnActualizar" ImageUrl="~/Imagenes/Actualizar.png" Style="margin-left: 5px" Width="30px" OnClick="btnActualizar_Click" runat="server" />
        <telerik:RadButton runat="server" ID="RadButton3" Text="Exportar a Excel" AutoPostBack="false" OnClientClicked="exportToExcel" />

        <telerik:RadGrid RenderMode="Lightweight" ID="RadGridRRHH" runat="server" CellSpacing="0" CellPadding="0" Font-Size="Smaller" Width="70%" Style="padding: 0; margin: 0 auto"
            GridLines="None" AllowSorting="true" shownosorticons="true" AllowFilteringByColumn="True" EnableHeaderContextFilterMenu="true"
            showfiltericon="false" OnItemDataBound="RadGridRRHH_ItemDataBound" OnSortCommand="RadGridRRHH_SortCommand" AllowPaging="false" OnItemCommand="RadGridRRHH_ItemCommand"
            PageSize="50" AllowAutomaticDeletes="False" AllowAutomaticInserts="False" AllowAutomaticUpdates="False" Culture="es-ES">
            <ExportSettings>
                <Excel Format="Xlsx" />
            </ExportSettings>
            <ClientSettings>
                <Animation AllowColumnReorderAnimation="true" />
                <Scrolling AllowScroll="True" UseStaticHeaders="true" ScrollHeight="370" />
                <Resizing AllowColumnResize="true" ResizeGridOnColumnResize="true" AllowResizeToFit="true" />
            </ClientSettings>
            <GroupingSettings CaseSensitive="false"></GroupingSettings>
            <HeaderStyle HorizontalAlign="Center" />
            <MasterTableView AutoGenerateColumns="false" ShowFooter="false" AllowFilteringByColumn="false" CellPadding="0" CellSpacing="0">
                <Columns>
                    <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='150' DataField='Departamento' SortExpression="Departamento" HeaderText='Departamento' ItemStyle-HorizontalAlign="left" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon='false'></telerik:GridBoundColumn>
                    <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='70' DataField='codigoempleado' SortExpression="codigoempleado" HeaderText='Código empleado' ItemStyle-HorizontalAlign="Center"  AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon='false'></telerik:GridBoundColumn>
                    <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='150' DataField='Nombre' SortExpression="Nombre" HeaderText='Nombre' ItemStyle-HorizontalAlign="left" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon='false'></telerik:GridBoundColumn>
                    <telerik:GridBoundColumn FilterControlWidth="80%" HeaderStyle-Width='70' DataField='Calificacion' SortExpression="Calificacion" HeaderText='Calificacion' AutoPostBackOnFilter='true' CurrentFilterFunction="Contains" ShowFilterIcon='false' ItemStyle-HorizontalAlign="center"></telerik:GridBoundColumn>
                    <telerik:GridBoundColumn FilterControlWidth="80%" HeaderStyle-Width='70' DataField='Tamaño' SortExpression="Tamaño" HeaderText='Tamaño Archivo' AutoPostBackOnFilter='true' CurrentFilterFunction="Contains" ShowFilterIcon='false' ItemStyle-HorizontalAlign="Center"></telerik:GridBoundColumn>
                    <telerik:GridBoundColumn FilterControlWidth="80%" HeaderStyle-Width='100' DataField='FechaArchivo' SortExpression="FechaArchivo" HeaderText='Fecha Archivo' AutoPostBackOnFilter='true' CurrentFilterFunction="Contains" ShowFilterIcon='false'></telerik:GridBoundColumn>
                </Columns>
            </MasterTableView>

        </telerik:RadGrid>
    </div>
</asp:Content>
