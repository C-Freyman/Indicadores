<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Tablero.aspx.cs" Inherits="IndicadoresFreyman.Reportes.Tablero" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        function exportToExcel(sender, args) {
            var masterTable = $find('<%= RadGridHistorico.ClientID %>').get_masterTableView();
            masterTable.exportToExcel();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="HidTipoTablero" runat="server" />
    <asp:HiddenField ID="HidEmpleado" runat="server" />
    <div style="text-align: center">
        DE: &nbsp &nbsp<telerik:RadMonthYearPicker RenderMode="Lightweight" ID="RadMonthYearPicker1" runat="server" Width="238px" MinDate="2024-01-1">
        </telerik:RadMonthYearPicker>
        A: &nbsp &nbsp<telerik:RadMonthYearPicker RenderMode="Lightweight" ID="RadMonthYearPicker2" runat="server" Width="238px" MinDate="2024-01-1">
        </telerik:RadMonthYearPicker>
        <asp:ImageButton ID="btnActualizar" ImageUrl="~/Imagenes/Actualizar.png" Style="position :absolute ;  margin-left: 5px" Width="25px" OnClick="btnActualizar_Click" runat="server" />
        <asp:Image ID="btnExportar" runat="server" ImageUrl ="~/Imagenes/ExportarE.png" onclick="exportToExcel()" Width ="30" style ="position :absolute; margin-left :20%"/>
        <%--<asp:ImageButton ID="btnExportar" Width="30" ToolTip="Exportar Reporte" style="margin-left:100px" ImageUrl="../Imagenes/ExportarE.png" runat="server"  AutoPostBack="false" OnClientClicked="exportToExcel" />--%>
        <%--<telerik:RadButton runat="server" ID="RadButton3" Text="Exportar a Excel" AutoPostBack="false" OnClientClicked="exportToExcel"  />--%>
    </div>
    <%--Skin="Metro"--%>
    <telerik:RadGrid ID="RadGridHistorico" RenderMode="Lightweight" Width="90%" runat="server" CellPadding="0" CellSpacing="0" Font-Size="Small" Style="margin: 0 auto;" AutoGenerateColumns="False" OnItemDataBound="RadGridHistorico_ItemDataBound" OnItemCommand="RadGridHistorico_ItemCommand" OnSortCommand="RadGridHistorico_SortCommand">
        <ExportSettings>
            <Excel Format="Xlsx" />
        </ExportSettings>
        <ClientSettings>
            <Animation AllowColumnReorderAnimation="true" />
            <Scrolling AllowScroll="true" UseStaticHeaders="true" FrozenColumnsCount="2" ScrollHeight="470" />
            <Resizing AllowColumnResize="true" ResizeGridOnColumnResize="true" AllowResizeToFit="true" />
        </ClientSettings>
        <MasterTableView AutoGenerateColumns="false" AllowSorting="true" AllowFilteringByColumn="True" ShowFooter="false" CellPadding="0" CellSpacing="0">
        </MasterTableView>
    </telerik:RadGrid>

</asp:Content>
