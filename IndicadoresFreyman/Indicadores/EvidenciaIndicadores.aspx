<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EvidenciaIndicadores.aspx.cs" Inherits="IndicadoresFreyman.Indicadores.EvidenciaIndicadores" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <telerik:RadAjaxManager runat="server">
            <AjaxSettings>
                <telerik:AjaxSetting AjaxControlID="gridEvidencias">
                    <UpdatedControls>
                        <telerik:AjaxUpdatedControl ControlID="gridEvidencias" LoadingPanelID="RadAjaxLoadingPanel1" />
                        <telerik:AjaxUpdatedControl ControlID="SavedChangesList" />
                    </UpdatedControls>
                </telerik:AjaxSetting>
                <telerik:AjaxSetting AjaxControlID="ConfigurationPanel1">
                    <UpdatedControls>
                        <telerik:AjaxUpdatedControl ControlID="gridEvidencias" LoadingPanelID="RadAjaxLoadingPanel1" />
                        <telerik:AjaxUpdatedControl ControlID="ConfigurationPanel1"/>
                    </UpdatedControls>
                </telerik:AjaxSetting>
            </AjaxSettings>
        </telerik:RadAjaxManager>
        <telerik:RadAjaxLoadingPanel runat="server" ID="RadAjaxLoadingPanel1"></telerik:RadAjaxLoadingPanel>
        <telerik:RadFormDecorator RenderMode="Lightweight" ID="RadFormDecorator1" runat="server" DecorationZoneID="demo" DecoratedControls="All" EnableRoundedCorners="false" />
        <div id="demo">
            <telerik:RadListBox RenderMode="Lightweight" runat="server" ID="SavedChangesList" Width="600px" Height="200px" Visible="false"></telerik:RadListBox>
            <telerik:RadGrid RenderMode="Lightweight" ID="gridEvidencias" GridLines="None" runat="server"
                CellSpacing="0" CellPadding="0" Font-Size="Smaller" Style="padding: 0; margin: 0 auto"
                AllowAutomaticInserts="True" PageSize="10" AllowAutomaticUpdates="True" AllowPaging="True"
                AutoGenerateColumns="False" DataSourceID="SqlDataSource1">

                <MasterTableView  EditMode="Batch" AutoGenerateColumns="False" CellPadding="0" CellSpacing="0">
                   
                    <Columns>
                        <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='50' UniqueName="IndicadorId" DataField='IndicadorId' SortExpression="IndicadorId" HeaderText='ID' ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon='false' ReadOnly="true"></telerik:GridBoundColumn>
                        <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='50' UniqueName="descripcionIndicador" DataField='descripcionIndicador' SortExpression="descripcionIndicador" HeaderText='Descripción' ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon='false' ReadOnly="true"></telerik:GridBoundColumn>
                        <telerik:GridBoundColumn FilterControlWidth="80%" HeaderStyle-Width='50' UniqueName="ponderacion" DataField='ponderacion' SortExpression="ponderacion" HeaderText='Ponderación' ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon='false' ReadOnly="true"></telerik:GridBoundColumn>
                        <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='50' UniqueName="indicadorMinimo" DataField='indicadorMinimo' SortExpression="indicadorMinimo" HeaderText='IndicadorMinimo' ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon='false' ReadOnly="true"></telerik:GridBoundColumn>
                        <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='50' UniqueName="indicadorDeseable" DataField='indicadorDeseable' SortExpression="indicadorDeseable" HeaderText='IndicadorDeseable' ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon='false' ReadOnly="true"></telerik:GridBoundColumn>
                        <telerik:GridTemplateColumn HeaderText="Adjuntar Archivo" AllowFiltering="false" UniqueName="archivo" HeaderStyle-Width="150" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <input type="file" runat="server" id="FileUpload2" />
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>
                        <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='50' UniqueName="resultado" DataField='resultado' SortExpression="resultado" HeaderText='Resultado' ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon='false'></telerik:GridBoundColumn>
                        <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='50' UniqueName="cumplimientoObjetivo" DataField='cumplimientoObjetivo' SortExpression="cumplimientoObjetivo" HeaderText='CumplimientoObjetivo' ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon='false' ReadOnly="true"></telerik:GridBoundColumn>
                        <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='50' UniqueName="evaluacionPonderada" DataField='evaluacionPonderada' SortExpression="evaluacionPonderada" HeaderText='EvaluacionPonderada' ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon='false' ReadOnly="true"></telerik:GridBoundColumn>
                    </Columns>
                </MasterTableView>
                <ClientSettings AllowKeyboardNavigation="true">
                    <ClientEvents OnBatchEditCellValueChanged="BatchEditCellValueChanged"/>
                </ClientSettings>
            </telerik:RadGrid>
        </div>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="Server=34.203.98.187; User ID=sa; password=similares*3; DataBase=Indicadores;"
            SelectCommand="select i.IndicadorId, pli.descripcionIndicador, i.ponderacion,i.indicadorMinimo,i.indicadorDeseable,isnull(e.resultado,0)as resultado, 
                            isnull(cumplimientoOBjetivo,0)as cumplimientoObjetivo, isnull(evaluacionPonderada,0)as evaluacionPonderada from Indicador i 
                            left join Asignacion a on i.asignacionId=a.asignacionId
                            left join PlantillaIndicador pli on pli.pIndicadorId=a.pIndicadorId
                            left join Evidencia e on i.IndicadorId=e.indicadorId 
                            where a.empleadoId=13178 and mes=1;"
            UpdateCommand="">
            <InsertParameters>
                <asp:Parameter Name="IndicadorId" Type="Int32"></asp:Parameter>
                <asp:Parameter Name="resultado" Type="Decimal"></asp:Parameter>
                <asp:Parameter Name="cumplimientoObjetivo" Type="Decimal"></asp:Parameter>
                <asp:Parameter Name="evaluacionPonderada" Type="Decimal"></asp:Parameter>
                <asp:Parameter Name="archivo" Type="Object"></asp:Parameter>
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="indicadorId" Type="Int32"></asp:Parameter>
                <asp:Parameter Name="descripcionIndicador" Type="String"></asp:Parameter>
                <asp:Parameter Name="ponderacion" Type="Int32"></asp:Parameter>
                <asp:Parameter Name="indicadorMinimo" Type="Decimal"></asp:Parameter>
                <asp:Parameter Name="indicadorDeseable" Type="Decimal"></asp:Parameter>
                <asp:Parameter Name="resultado" Type="Decimal"></asp:Parameter>
                <asp:Parameter Name="cumplimientoObjetivo" Type="Decimal"></asp:Parameter>
                <asp:Parameter Name="evaluacionPonderada" Type="Decimal"></asp:Parameter>
            </UpdateParameters>
        </asp:SqlDataSource>
    </form>
</body>
</html>
 <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    function BatchEditCellValueChanged(sender, args) {
        debugger;
        var editorValue = args.get_editorValue();

        var columnUniqueName = args.get_columnUniqueName();

        if (columnUniqueName === "archivo") {
            editorValue = args.get_editorValue();

            // Obtén el control de archivo y su valor
            var inputFile = document.getElementById("FileUpload2");
            if (inputFile.files.length > 0) {
                var file = inputFile.files[0];

                // Crear un FormData para enviar el archivo al servidor
                var formData = new FormData();
                formData.append("archivo", file);

                // Realizar la llamada AJAX para enviar el archivo al servidor
                $.ajax({
                    type: "POST",
                    url: "YourPage.aspx/UploadFile",
                    data: formData,
                    processData: false,
                    contentType: false,
                    success: function (response) {
                        // Manejar la respuesta de éxito
                        console.log("Archivo subido correctamente");
                    },
                    error: function (response) {
                        // Manejar el error
                        console.log("Error al subir el archivo");
                    }
                });
            }
        }

        // Send the editor value to the server using AJAX
        $.ajax({
            type: "POST",
            url: "EvidenciaIndicadores.aspx/SaveEditorValue",
            data: JSON.stringify({ editorValue: editorValue }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                // Handle success
                console.log("Value saved successfully");
            },
            error: function (response) {
                // Handle error
                console.log("Error saving value: " + response);
            }
        });
    }
</script>
