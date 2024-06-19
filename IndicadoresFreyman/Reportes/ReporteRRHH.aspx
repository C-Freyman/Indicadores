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
    <span id="Titulo" runat ="server"  style="font-size :30px; margin :0 auto;  margin-bottom :10px; position :absolute " >Tablero</span>
    <div style="text-align: center">
        MES: &nbsp &nbsp<telerik:RadMonthYearPicker RenderMode="Lightweight" ID="RadMonthYearPicker1" runat="server" Width="238px" MinDate="2024-01-1">
        </telerik:RadMonthYearPicker>
        <asp:ImageButton ID="btnActualizar" ImageUrl="~/Imagenes/Actualizar.png" Style="position :absolute ;  margin-left: 5px" Width="25px" OnClick="btnActualizar_Click" runat="server" />
        <%--<telerik:RadButton runat="server" ID="RadButton3" Text="Exportar a Excel" AutoPostBack="false" OnClientClicked="exportToExcel" />--%>
                <asp:Image ID="btnExportar" runat="server" ImageUrl ="~/Imagenes/ExportarE.png" onclick="exportToExcel()" Width ="30" style ="position :absolute; margin-left :20%"/>
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
            <MasterTableView AutoGenerateColumns="false" ShowFooter="false" AllowFilteringByColumn="true" CellPadding="0" CellSpacing="0">
                <Columns>
                    <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='150' DataField='Departamento' SortExpression="Departamento" HeaderText='Departamento' ItemStyle-HorizontalAlign="left" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon='false'></telerik:GridBoundColumn>
                    <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='70' DataField='codigoempleado' SortExpression="codigoempleado" HeaderText='Código empleado' ItemStyle-HorizontalAlign="Center"  AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon='false'></telerik:GridBoundColumn>
                    <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='150' DataField='Nombre' SortExpression="Nombre" HeaderText='Nombre' ItemStyle-HorizontalAlign="left" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon='false'></telerik:GridBoundColumn>
                    <telerik:GridBoundColumn FilterControlWidth="80%" HeaderStyle-Width='70' DataField='Calificacion' SortExpression="Calificacion" HeaderText='Calificacion' AutoPostBackOnFilter='true' CurrentFilterFunction="EqualTo" ItemStyle-HorizontalAlign ="Center" ShowFilterIcon ="false"  ></telerik:GridBoundColumn>
                    <telerik:GridBoundColumn FilterControlWidth="80%" HeaderStyle-Width='70' DataField='Tamaño' SortExpression="Tamaño" HeaderText='Tamaño Archivo' AutoPostBackOnFilter='true' CurrentFilterFunction="Contains" ShowFilterIcon='false' AllowFiltering ="false"  ItemStyle-HorizontalAlign="Center"></telerik:GridBoundColumn>
                    <telerik:GridBoundColumn FilterControlWidth="80%" HeaderStyle-Width='100' DataField='fechaCerrado' SortExpression="fechaCerrado" HeaderText='Fecha Cerrado' AutoPostBackOnFilter='true' CurrentFilterFunction="Contains" AllowFiltering ="false" ShowFilterIcon='false' ></telerik:GridBoundColumn>
                    <telerik:GridBoundColumn FilterControlWidth="80%" HeaderStyle-Width='70' DataField='SumaPonderacion' SortExpression="SumaPonderacion" HeaderText='Suma de Ponderación' AutoPostBackOnFilter='true' CurrentFilterFunction="Contains" ShowFilterIcon='false' AllowFiltering ="false"  ItemStyle-HorizontalAlign="Center"></telerik:GridBoundColumn>
                </Columns>
            </MasterTableView>

        </telerik:RadGrid>
    </div>
</asp:Content>
