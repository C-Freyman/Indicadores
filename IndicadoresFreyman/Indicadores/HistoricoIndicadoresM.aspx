<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="HistoricoIndicadoresM.aspx.cs" Inherits="IndicadoresFreyman.Indicadores.HistoricoIndicadoresM" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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
 <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
 <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
 <script src="https://cdn.jsdelivr.net/npm/popper.js@1.12.9/dist/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
 <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="demo-container" style="margin:5px">
    <h3>Mes</h3>
    <telerik:RadDropDownList RenderMode="Lightweight" ID="RadDropDownList1" runat="server" Width="300" Height="200px" DropDownHeight="200px"
        DataTextField="" EnableVirtualScrolling="true" AutoPostBack="true" OnSelectedIndexChanged="RadDropDownList1_SelectedIndexChanged">
    </telerik:RadDropDownList>
</div>
<div class="demo">
    
    <telerik:RadAjaxLoadingPanel runat="server" ID="RadAjaxLoadingPanel1"></telerik:RadAjaxLoadingPanel>
    <telerik:RadFormDecorator RenderMode="Lightweight" ID="RadFormDecorator1" runat="server" DecorationZoneID="demo" DecoratedControls="All" EnableRoundedCorners="false" />
    <telerik:RadGrid RenderMode="Lightweight" ID="gridHistorico" GridLines="None" runat="server" OnItemDataBound="gridHistorico_ItemDataBound"
        CellSpacing="0" CellPadding="0" Font-Size="Smaller" Style="padding: 0; margin: 0 auto" OnItemCreated="gridHistorico_ItemCreated"
        AllowAutomaticInserts="True" PageSize="10" AllowAutomaticUpdates="True" AllowPaging="True" 
        AutoGenerateColumns="False" ShowFooter="true">

        <MasterTableView  CommandItemDisplay="Top" AutoGenerateColumns="False" CellPadding="0" CellSpacing="0">
            <CommandItemSettings ShowAddNewRecordButton="false" ShowCancelChangesButton="false" ShowSaveChangesButton="false" ShowRefreshButton="false"/>
            <CommandItemTemplate>                        
                <asp:Button ID="btnDescargarArchivo" runat="server" Text="Descargar Evidencia" OnClick="btnDescargarArchivo_Click" />
                <asp:Label ID="nombreColaborador" CssClass="label1" runat="server" Text="Texto"></asp:Label>
            </CommandItemTemplate>

            <Columns>
                <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='5%' HeaderStyle-Font-Bold="true" UniqueName="indicadorId" DataField='indicadorId' SortExpression="indicadorId" HeaderText='ID' 
                    ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon='false' HeaderStyle-HorizontalAlign="center"></telerik:GridBoundColumn>
                <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='30%' HeaderStyle-Font-Bold="true" UniqueName="descripcionIndicador" DataField='descripcionIndicador' SortExpression="descripcionIndicador" 
                    HeaderText='Descripción' ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon='false' HeaderStyle-HorizontalAlign="center"></telerik:GridBoundColumn>
                <telerik:GridBoundColumn FilterControlWidth="80%" HeaderStyle-Width='5%' HeaderStyle-Font-Bold="true" UniqueName="ponderacion" DataField='ponderacion' SortExpression="ponderacion" HeaderText='Ponderación' 
                    ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon='false' HeaderStyle-HorizontalAlign="center"></telerik:GridBoundColumn>
                <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='6%' HeaderStyle-Font-Bold="true" UniqueName="indicadorMinimo" DataField='indicadorMinimo' SortExpression="indicadorMinimo" HeaderText='Indicador Minimo (50 Pts.)' 
                    ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon='false' HeaderStyle-HorizontalAlign="center"></telerik:GridBoundColumn>
                <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='7%' HeaderStyle-Font-Bold="true" UniqueName="indicadorDeseable" DataField='indicadorDeseable' SortExpression="indicadorDeseable" 
                    HeaderText='Indicador Deseable (100 Pts.)' ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon='false' HeaderStyle-HorizontalAlign="center"></telerik:GridBoundColumn>
                <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='5%' HeaderStyle-Font-Bold="true" UniqueName="resultado" DataField='resultado' SortExpression="resultado" HeaderText='Resultado' 
                    ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon='false' HeaderStyle-HorizontalAlign="center" ItemStyle-BackColor="#BFBBBB"></telerik:GridBoundColumn>
                <telerik:GridTemplateColumn FilterControlWidth='80%' HeaderStyle-Width='8%' HeaderStyle-Font-Bold="true" UniqueName="cumplimientoObjetivo" DataField='cumplimientoObjetivo' SortExpression="cumplimientoObjetivo" 
                    HeaderText='Cumplimiento Objetivo (0-100 Pts.)' ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="false" CurrentFilterFunction="EqualTo" ShowFilterIcon='false' ReadOnly="true" HeaderStyle-HorizontalAlign="center">
                        <ItemTemplate>
                            <span style="font-size:13px" class='<%# CargarEstilosCumplimiento(Convert.ToDecimal(Eval("cumplimientoObjetivo")))%>'>  <%# Eval("cumplimientoObjetivo") %></span>
                        </ItemTemplate>
                </telerik:GridTemplateColumn>
                <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='10%' HeaderStyle-Font-Bold="true" UniqueName="evaluacionPonderada" DataField='evaluacionPonderada' SortExpression="evaluacionPonderada"
                    HeaderText='Evaluacion Ponderada' ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon='false'  HeaderStyle-HorizontalAlign="center"></telerik:GridBoundColumn>
            </Columns>
            <FooterStyle Height="30px" HorizontalAlign="Center" Font-Size="Medium" Font-Bold="true"/>
        </MasterTableView>
        <ClientSettings AllowKeyboardNavigation="true">
            <ClientEvents OnBatchEditCellValueChanged="BatchEditCellValueChanged"/>
        </ClientSettings>
    </telerik:RadGrid>
    <asp:Label ID="HiddenLabel" runat="server" Visible="false"></asp:Label>
</div>
</asp:Content>
