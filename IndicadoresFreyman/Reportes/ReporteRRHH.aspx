<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="ReporteRRHH.aspx.cs" Inherits="IndicadoresFreyman.Reportes.ReporteRRHH" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <telerik:RadGrid RenderMode="Lightweight" ID="RadGridRRHH" runat="server" CellSpacing="0" CellPadding="0" Font-Size="Smaller" Style="padding: 0; margin: 0 auto"
     GridLines="None" AllowSorting="true" shownosorticons="true" AllowFilteringByColumn="True" EnableHeaderContextFilterMenu="true"
     showfiltericon="false" OnItemDataBound="RadGridRRHH_ItemDataBound" OnSortCommand="RadGridRRHH_SortCommand" AllowPaging="false" OnItemCommand="RadGridRRHH_ItemCommand"
     PageSize="50" AllowAutomaticDeletes="False" AllowAutomaticInserts="False" OnColumnCreated="RadGridRRHH_ColumnCreated" AllowAutomaticUpdates="False" Culture="es-ES">
     <ClientSettings>
         <Animation AllowColumnReorderAnimation="true" />
         <Scrolling AllowScroll="True" UseStaticHeaders="true" ScrollHeight="370" />
         <Resizing AllowColumnResize="true" ResizeGridOnColumnResize="true" AllowResizeToFit="true" />
     </ClientSettings>
     <GroupingSettings CaseSensitive="false"></GroupingSettings>
     <HeaderStyle HorizontalAlign="Center" />
     <MasterTableView AutoGenerateColumns="true" ShowFooter="true" AllowFilteringByColumn="false"  CellPadding="0" CellSpacing="0">
         <Columns>
          </Columns>
     </MasterTableView>

 </telerik:RadGrid>
</asp:Content>
