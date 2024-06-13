<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="TableroHistorico.aspx.cs" Inherits="IndicadoresFreyman.Reportes.TableroHistorico" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="HidTipoTablero" runat="server" />
    <div style="text-align: center">
        DE: &nbsp &nbsp<telerik:RadMonthYearPicker RenderMode="Lightweight" ID="RadMonthYearPicker1" runat="server" Width="238px" MinDate="2024-01-1">
        </telerik:RadMonthYearPicker>
        A: &nbsp &nbsp<telerik:RadMonthYearPicker RenderMode="Lightweight" ID="RadMonthYearPicker2" runat="server" Width="238px" MinDate="2024-01-1">
        </telerik:RadMonthYearPicker>
        <asp:ImageButton ID="btnActualizar" ImageUrl="~/Imagenes/Actualizar.png" Style="position: absolute; margin-left: 5px" Width="30px" OnClick="btnActualizar_Click" runat="server" />

    </div>

    <%--<telerik:RadGrid RenderMode="Lightweight" ID="RadGridHistorico" runat="server" />--%>
    <asp:PlaceHolder ID="PlaceHolder1" runat="server" />
</asp:Content>
