<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EvidenciaIndicadores.aspx.cs" Inherits="IndicadoresFreyman.Indicadores.EvidenciaIndicadores" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<%@ Import Namespace="System.Web.Services" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
       <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <telerik:RadAjaxLoadingPanel runat="server" ID="RadAjaxLoadingPanel1"></telerik:RadAjaxLoadingPanel>
        <telerik:RadFormDecorator RenderMode="Lightweight" ID="RadFormDecorator1" runat="server" DecorationZoneID="demo" DecoratedControls="All" EnableRoundedCorners="false" />
        <div id="demo">
            <telerik:RadListBox RenderMode="Lightweight" runat="server" ID="SavedChangesList" Width="600px" Height="200px" Visible="false"></telerik:RadListBox>
            <telerik:RadGrid RenderMode="Lightweight" ID="gridEvidencias" GridLines="None" runat="server"
                CellSpacing="0" CellPadding="0" Font-Size="Smaller" Style="padding: 0; margin: 0 auto"
                AllowAutomaticInserts="True" PageSize="10" AllowAutomaticUpdates="True" AllowPaging="True"
                AutoGenerateColumns="False" DataSourceID="SqlDataSource1" OnBatchEditCommand="gridEvidencias_BatchEditCommand">

                <MasterTableView  CommandItemDisplay="TopAndBottom"  EditMode="Batch" AutoGenerateColumns="False" CellPadding="0" CellSpacing="0">
                    <CommandItemSettings ShowAddNewRecordButton="false"  />
                    <CommandItemTemplate>
                        
                        <asp:Button ID="SaveChangesButton" runat="server" CommandName="BatchSave" Text="Guardar Cambios" />
                        <asp:Button ID="CancelChangesButton" runat="server" CommandName="BatchCancel" Text="Cancelar Cambios" />
                        <asp:Button ID="GuardarBorradorButton" OnClientClick="return guardarBorrador();" runat="server" Text="Guardar Borrador" />
                    </CommandItemTemplate>
                    <Columns>
                        <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='50' UniqueName="indicadorId" DataField='indicadorId' SortExpression="indicadorId" HeaderText='ID' ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon='false' ReadOnly="true"></telerik:GridBoundColumn>
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
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="Server=187.174.147.102; User ID=sa; password=similares*3; DataBase=Indicadores;"
            SelectCommand="select i.indicadorId, pli.descripcionIndicador, i.ponderacion,i.indicadorMinimo,i.indicadorDeseable,isnull(e.resultado,0)as resultado, 
                            isnull(cumplimientoOBjetivo,0)as cumplimientoObjetivo, isnull(evaluacionPonderada,0)as evaluacionPonderada from Indicador i 
                            left join Asignacion a on i.asignacionId=a.asignacionId
                            left join PlantillaIndicador pli on pli.pIndicadorId=a.pIndicadorId
                            left join Evidencia e on i.IndicadorId=e.indicadorId 
                            where a.empleadoId=13178 and mes=1;"
            UpdateCommand="">
            <InsertParameters>
                <asp:Parameter Name="indicadorId" Type="Int32"></asp:Parameter>
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
        var cell = args.get_cell();
        var row = cell.parentNode;
        var filaHTML = row.innerText;
        var valorEditado = cell.innerText;

        // Enviar los valores de la fila al servidor usando AJAX
        $.ajax({
            type: "POST",
            url: "EvidenciaIndicadores.aspx/SaveRowValues",
            data: JSON.stringify({ filaHTML: filaHTML, valorEditado: valorEditado }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                // Manejar el éxito
                console.log("Values saved successfully");
            },
            error: function (response) {
                // Manejar el error
                console.log("Error saving values: " + response);
            }
        });
    }
    function guardarBorrador() {
        debugger;
        var grid = $find("<%= gridEvidencias.ClientID %>");
        var batchManager = grid.get_batchEditingManager();
        var changes = batchManager.get_changes();

        // Crear un array para almacenar las filas modificadas
        var modifiedRows = [];

        for (var i = 0; i < changes.length; i++) {
            var change = changes[i];
            var dataItem = change.get_tableView().get_dataItems()[change.get_dataItemIndex()];

            // Crear un objeto para almacenar los valores de la fila
            var rowData = {};
            for (var j = 0; j < dataItem.get_cellElements().length; j++) {
                var columnName = grid.get_masterTableView().get_columns()[j].get_uniqueName();
                rowData[columnName] = dataItem[columnName];
            }

            modifiedRows.push(rowData);
        }

        // Enviar los cambios al servidor usando AJAX
        $.ajax({
            type: "POST",
            url: "EvidenciaIndicadores.aspx/GuardarBorrador",
            data: JSON.stringify({ rows: modifiedRows }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                alert("Cambios guardados correctamente.");
            },
            error: function (response) {
                alert("Error al guardar los cambios: " + response.responseText);
            }
        });

        return false; // Para evitar el postback
    }
</script>
