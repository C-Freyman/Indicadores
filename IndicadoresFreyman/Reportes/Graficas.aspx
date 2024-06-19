<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Graficas.aspx.cs" Inherits="IndicadoresFreyman.Reportes.Graficas" %>

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
            text-align: center;
        }
    </style>
    <script>
        function OnClientItemChecked(sender, eventArgs) {
            //document.getElementById("HidChecDepartamento").value = "si";
             __doPostBack(sender.get_id(), "");
            //document.getElementById('btnAux').click();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="HidChecDepartamento" runat="server" />
    <div style="text-align: center">
        <div class="ContenidoRecuadro ">
            <table style="border-spacing: 0;">
                <tr>
                    <td style="padding-left: 10px; background: #465a6b; color: white">AGRUPAMIENTO:</td>
                    <td style="border: 1px solid silver; border-top-right-radius: 10px; border-bottom-right-radius: 10px;">
                        <asp:RadioButtonList ID="rdlQuien" runat="server" RepeatDirection="Horizontal" AutoPostBack="true" Style="margin: 0 auto;" OnSelectedIndexChanged="rdlQuien_SelectedIndexChanged">
                            <asp:ListItem Text="Por Empleado" Value="E" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="Por Departamento" Value="D"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                    <td style="width: 50px;"></td>
                    <td style="padding-left: 10px; background: #465a6b; color: white">FILTROS:</td>
                    <td style="border: 1px solid silver; border-top-right-radius: 10px; border-bottom-right-radius: 10px;">
                        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                            <ContentTemplate>
                                <telerik:RadComboBox RenderMode="Lightweight" ID="radDepartamentos" runat="server" CheckBoxes="true" EnableCheckAllItemsCheckBox="true" AutoPostBack="true" OnClientItemChecked="OnClientItemChecked"
                                    Width="400" Label="Departamentos:">
                                </telerik:RadComboBox>
                                <telerik:RadComboBox RenderMode="Lightweight" ID="radEmpleados" runat="server" CheckBoxes="true" EnableCheckAllItemsCheckBox="true"
                                    Width="400" Label="Empleados:">
                                </telerik:RadComboBox>
                                <asp:ImageButton ID="btnActualizar" ImageUrl="~/Imagenes/Actualizar.png" Style="margin-left: 5px" Width="25px" OnClick="btnActualizar_Click" runat="server" />

                            </ContentTemplate>
                        </asp:UpdatePanel>


                        <asp:Literal ID="itemsClientSide" runat="server" />
                    </td>
                </tr>
            </table>

        </div>

        <table style="width: 100%">
            <tr>
                <td style="width: 50%">
                    <div class="ContenidoRecuadro ">
                        DE: &nbsp &nbsp<telerik:RadMonthYearPicker RenderMode="Lightweight" ID="RadMonthYearPicker1" runat="server" Width="238px" MinDate="2024-01-1">
                        </telerik:RadMonthYearPicker>
                        A: &nbsp &nbsp<telerik:RadMonthYearPicker RenderMode="Lightweight" ID="RadMonthYearPicker2" runat="server" Width="238px" MinDate="2024-01-1">
                        </telerik:RadMonthYearPicker>
                        <telerik:RadHtmlChart runat="server" ID="GraficaMesAño" Width="100%" Transitions="true">
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
                        <telerik:RadComboBox RenderMode="Lightweight" ID="radAñoDe" runat="server" CheckBoxes="false"
                            Width="150" Label="Año de:">
                        </telerik:RadComboBox>
                        <telerik:RadComboBox RenderMode="Lightweight" ID="radAñoA" runat="server" CheckBoxes="false"
                            Width="150" Label="Año a:">
                        </telerik:RadComboBox>
                        <telerik:RadHtmlChart runat="server" ID="GraficaAño" Width="100%">
                            <PlotArea>
                                <Series>
                                    <telerik:ColumnSeries>
                                        <TooltipsAppearance Color="black" />
                                        <LabelsAppearance DataFormatString="{0}" Color="black" Position="Center">
                                        </LabelsAppearance>
                                        <TooltipsAppearance DataFormatString="{0} Farmacias" Color="black"></TooltipsAppearance>
                                    </telerik:ColumnSeries>
                                </Series>
                                <XAxis DataLabelsField="DVR_" Color="Gray">
                                    <TitleAppearance>
                                        <TextStyle Margin="20" Color="Gray" />
                                    </TitleAppearance>
                                    <MajorGridLines Visible="false" />
                                    <MinorGridLines Visible="false" />
                                </XAxis>
                                <YAxis Color="Gray">
                                    <MinorGridLines Visible="false" />
                                    <MajorGridLines Visible="false" />
                                </YAxis>
                            </PlotArea>

                        </telerik:RadHtmlChart>


                    </div>
                </td>
            </tr>
        </table>
    </div>


</asp:Content>
