<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Graficas.aspx.cs" Inherits="IndicadoresFreyman.Reportes.Graficas"  %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .ContenidoRecuadro {
            border-radius: 10px;
            border: 1px solid lightgray;
            box-shadow: 10px 10px 5px 0px rgba(214,214,214,1);
            padding: 10px;
            width: 90%;
            background-color: white;
            margin: 0 auto;
            padding: 0 auto;
            margin: 10px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div style="text-align: center">
        <div class="ContenidoRecuadro ">
            DE: &nbsp &nbsp<telerik:RadMonthYearPicker RenderMode="Lightweight" ID="RadMonthYearPicker1" runat="server" Width="238px" MinDate="2024-01-1">
            </telerik:RadMonthYearPicker>
            A: &nbsp &nbsp<telerik:RadMonthYearPicker RenderMode="Lightweight" ID="RadMonthYearPicker2" runat="server" Width="238px" MinDate="2024-01-1">
            </telerik:RadMonthYearPicker>

            <telerik:RadComboBox RenderMode="Lightweight" ID="radEmpleados" runat="server" CheckBoxes="true" EnableCheckAllItemsCheckBox="true"
                Width="400" Label="Empleados:">
                <Items>
                </Items>
            </telerik:RadComboBox>
            <asp:Literal ID="itemsClientSide" runat="server" />
            <telerik:RadButton RenderMode="Lightweight" ID="btnActualizar" runat="server" Text="Actualizar" OnClick="btnActualizar_Click" />
        </div>

        <table style="width: 100%">
            <tr>
                <td style="width: 50%">
                    <div class="ContenidoRecuadro ">
                        <telerik:RadHtmlChart runat="server" ID="GraficaMesAñoEmpleado" Width="100%" Transitions="true">
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
                    </div>
                </td>
                <td>
                    <div class="ContenidoRecuadro ">
                        <telerik:RadHtmlChart runat="server" ID="GraficaAñoEmpleado" Width="100%" Style="top: -7px" Transitions="true">
                            <Legend>
                                <Appearance BackgroundColor="Transparent" Position="Bottom" Visible="false"></Appearance>
                            </Legend>

                            <PlotArea>
                                <Series>
                                    <telerik:DonutSeries StartAngle="60" HoleSize="58" DataFieldY="Valor" NameField="Descripcion">
                                        <%--ColorField="Color"--%>
                                        <LabelsAppearance Position="Center" DataFormatString="{0} %" Visible="false"></LabelsAppearance>
                                        <TooltipsAppearance Color="White" DataFormatString="{0} %"></TooltipsAppearance>
                                    </telerik:DonutSeries>
                                </Series>
                            </PlotArea>
                        </telerik:RadHtmlChart>
                    </div>
                </td>
            </tr>
        </table>
    </div>


</asp:Content>
