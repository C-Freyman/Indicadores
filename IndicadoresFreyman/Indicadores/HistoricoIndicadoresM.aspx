<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="HistoricoIndicadoresM.aspx.cs" Inherits="IndicadoresFreyman.Indicadores.HistoricoIndicadoresM" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<style>

    .label2 {
        font-size: 18px;
        margin-right: 200px;
        float: right;
    }
</style>

    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.12.9/dist/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
     <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <script>
        function OnDateSelected(sender, e) {
            debugger;
            // Obtener la fecha seleccionada del objeto sender
            var selectedDate = sender.get_selectedDate();

            // Obtener el número del mes seleccionado
            var selectedMonth = selectedDate.getMonth() + 1; // getMonth() devuelve 0-11, por eso sumamos 1

            // Obtener el año seleccionado
            var selectedYear = selectedDate.getFullYear();

            // Llamar al WebMethod usando AJAX
            $.ajax({
                type: "POST",
                url: "HistoricoIndicadoresM.aspx/fechaRadMonthYearPicker",
                data: JSON.stringify({ mes: selectedMonth, año: selectedYear }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    // Forzar un postback para actualizar el grid
                    __doPostBack('<%= gridHistorico.ClientID %>', '');
                    location.reload();
                },
                failure: function (response) {
                    alert("Error al actualizar la fecha seleccionada.");
                }
            });
        }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <h2>Histórico</h2>
<div class="demo" style="margin-left:20px; margin-right:20px;">


    <asp:Literal ID="Literal1" runat="server"></asp:Literal>

     <%if (Session["puesto"]as string == "2"){%>
    <div id="divAreas" style="display: inline-block">
        <h3>Departamento</h3>
            <telerik:RadDropDownList RenderMode="Lightweight" ID="RadDropDownList3" runat="server" Width="300" Height="200px" DropDownHeight="200px"
                DataTextField="" EnableVirtualScrolling="true" AutoPostBack="true" OnSelectedIndexChanged="RadDropDownList3_SelectedIndexChanged">
            </telerik:RadDropDownList>
    </div>
    <% } %>
    
    <%if (Session["puesto"]as string == "1" || Session["puesto"]as string == "2"){%>
    <div id="divColaboradores" style="display: inline-block;">
        <h3>Colaborador</h3>
        <telerik:RadDropDownList RenderMode="Lightweight" ID="RadDropDownList2" runat="server" Width="300" Height="200px" DropDownHeight="200px"
            DataTextField="Texto" EnableVirtualScrolling="true" AutoPostBack="true" OnSelectedIndexChanged="RadDropDownList2_SelectedIndexChanged">
        </telerik:RadDropDownList>
    </div>
     <% } %>
   
    <div style="text-align: right; margin-bottom: 10px;">
        <asp:TextBox ID="txtFilter" Width="200px" runat="server" AutoPostBack="True" OnTextChanged="txtFilter_TextChanged" placeholder="Buscar en la tabla..."></asp:TextBox>
    </div>
    <telerik:RadAjaxLoadingPanel runat="server" ID="RadAjaxLoadingPanel1"></telerik:RadAjaxLoadingPanel>
    <telerik:RadFormDecorator RenderMode="Lightweight" ID="RadFormDecorator1" runat="server" DecorationZoneID="demo" DecoratedControls="All" EnableRoundedCorners="false" />
    <telerik:RadGrid RenderMode="Lightweight" ID="gridHistorico" GridLines="None" runat="server" OnItemDataBound="gridHistorico_ItemDataBound"
        CellSpacing="0" CellPadding="0" Font-Size="Smaller" Style="padding: 0; margin: 0 auto" OnItemCreated="gridHistorico_ItemCreated"
        AllowAutomaticInserts="True" PageSize="10" AllowAutomaticUpdates="True" AllowPaging="True" OnItemCommand="gridHistorico_ItemCommand" OnPageIndexChanged="gridHistorico_PageIndexChanged" OnPageSizeChanged="gridHistorico_PageSizeChanged"
        AutoGenerateColumns="False" ShowFooter="true" >

        <MasterTableView  CommandItemDisplay="Top" AutoGenerateColumns="False" CellPadding="0" CellSpacing="0">
            <CommandItemSettings ShowAddNewRecordButton="false" ShowCancelChangesButton="false" ShowSaveChangesButton="false" ShowRefreshButton="false"/>
            <CommandItemTemplate>                        
                <%if (Session["puesto"]as string == "0"){%> <asp:Button ID="btnDescargarArchivo" runat="server" Text="Descargar Evidencia" OnClick="btnDescargarArchivo_Click" /> <% } %>
                <asp:Label ID="nombreColaborador" CssClass="label1" runat="server" Text="Texto"></asp:Label>

                <telerik:RadMonthYearPicker RenderMode="Lightweight" ID="RadMonthYearPicker1" runat="server" Width="238px" MinDate="2024-01-1" CssClass="label2">
                    <ClientEvents OnDateSelected="OnDateSelected"></ClientEvents>
                </telerik:RadMonthYearPicker>
            </CommandItemTemplate>
            <Columns>
                <telerik:GridBoundColumn HeaderStyle-Width='3%' HeaderStyle-Font-Bold="true" UniqueName="pIndicadorId" DataField='pIndicadorId' SortExpression="pIndicadorId" HeaderText='ID' 
                    ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" ShowFilterIcon='false' HeaderStyle-HorizontalAlign="center"></telerik:GridBoundColumn>
                <telerik:GridBoundColumn HeaderStyle-Width='7%' HeaderStyle-Font-Bold="true" UniqueName="Departamento" DataField='Departamento' SortExpression="Departamento" HeaderText='Departamento' 
                    ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" ShowFilterIcon='false' HeaderStyle-HorizontalAlign="center" Visible="false"></telerik:GridBoundColumn>
                <telerik:GridBoundColumn HeaderStyle-Width='7%' HeaderStyle-Font-Bold="true" UniqueName="Nombre_" DataField='Nombre_' SortExpression="Nombre_" HeaderText='Colaborador' 
                    ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" ShowFilterIcon='false' HeaderStyle-HorizontalAlign="center" Visible="false"></telerik:GridBoundColumn>
                <telerik:GridBoundColumn HeaderStyle-Width='30%' HeaderStyle-Font-Bold="true" UniqueName="descripcionIndicador" DataField='descripcionIndicador' SortExpression="descripcionIndicador" 
                    HeaderText='Descripción' ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true"  ShowFilterIcon='false' HeaderStyle-HorizontalAlign="center"></telerik:GridBoundColumn>
                <telerik:GridBoundColumn HeaderStyle-Width='5%' HeaderStyle-Font-Bold="true" UniqueName="ponderacion" DataField='ponderacion' SortExpression="ponderacion" HeaderText='Ponderación' DataFormatString="{0:P0}" 
                    ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" ShowFilterIcon='false' HeaderStyle-HorizontalAlign="center"></telerik:GridBoundColumn>
                <telerik:GridBoundColumn HeaderStyle-Width='6%' HeaderStyle-Font-Bold="true" UniqueName="indicadorMinimo" DataField='indicadorMinimo' SortExpression="indicadorMinimo" HeaderText='Indicador Minimo (50 Pts.)'  DataFormatString="{0:N1}"
                    ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" ShowFilterIcon='false' HeaderStyle-HorizontalAlign="center"></telerik:GridBoundColumn>
                <telerik:GridBoundColumn HeaderStyle-Width='7%' HeaderStyle-Font-Bold="true" UniqueName="indicadorDeseable" DataField='indicadorDeseable' SortExpression="indicadorDeseable"  DataFormatString="{0:N1}"
                    HeaderText='Indicador Deseable (100 Pts.)' ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" ShowFilterIcon='false' HeaderStyle-HorizontalAlign="center"></telerik:GridBoundColumn>
                <telerik:GridBoundColumn HeaderStyle-Width='5%' HeaderStyle-Font-Bold="true" UniqueName="resultado" DataField='resultado' SortExpression="resultado" HeaderText='Resultado' 
                    ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" ShowFilterIcon='false' HeaderStyle-HorizontalAlign="center" ItemStyle-BackColor="#74C99B"></telerik:GridBoundColumn>
                <telerik:GridTemplateColumn HeaderStyle-Width='8%' HeaderStyle-Font-Bold="true" UniqueName="cumplimientoObjetivo" DataField='cumplimientoObjetivo' SortExpression="cumplimientoObjetivo" 
                    HeaderText='Cumplimiento Objetivo (0-100 Pts.)' ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="false" ShowFilterIcon='false' ReadOnly="true" HeaderStyle-HorizontalAlign="center">
                    <ItemTemplate>
                        <span style="font-size:13px" class='<%# CargarEstilosCumplimiento(Convert.ToDecimal(Eval("cumplimientoObjetivo")))%>'>  <%# Eval("cumplimientoObjetivo") %></span>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>
                <telerik:GridBoundColumn HeaderStyle-Width='10%' HeaderStyle-Font-Bold="true" UniqueName="evaluacionPonderada" DataField='evaluacionPonderada' SortExpression="evaluacionPonderada"
                    HeaderText='Evaluacion Ponderada' ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" ShowFilterIcon='false'  HeaderStyle-HorizontalAlign="center"></telerik:GridBoundColumn>
                <telerik:GridTemplateColumn HeaderStyle-Width='10%' HeaderStyle-Font-Bold="true" UniqueName="Evidencia" HeaderText='Evidencia'>
                    <ItemTemplate>
                        <asp:Button ID="btnEvidencia" runat="server" Text="Ver Evidencia" CommandName="Evidencia" CommandArgument='<%# Eval("indicadorId") %>' />
                    </ItemTemplate>
                </telerik:GridTemplateColumn>
            </Columns>
            <FooterStyle Height="30px" HorizontalAlign="Center" Font-Size="Medium" Font-Bold="true"/>
        </MasterTableView>
        <ClientSettings AllowKeyboardNavigation="true">
        </ClientSettings>
    </telerik:RadGrid>
    <asp:Label ID="HiddenLabel" runat="server" Visible="false"></asp:Label>
</div>
</asp:Content>
