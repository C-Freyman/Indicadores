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
            SelectCommand="select pli.pIndicadorId as indicadorId, pli.descripcionIndicador, concat(i.ponderacion,'%')as ponderacion,i.indicadorMinimo,i.indicadorDeseable,isnull(e.resultado,0)as resultado, 
                            isnull(cumplimientoOBjetivo,0)as cumplimientoObjetivo, isnull(evaluacionPonderada,0)as evaluacionPonderada from Indicador i 
                            left join Asignacion a on i.asignacionId=a.asignacionId
                            left join PlantillaIndicador pli on pli.pIndicadorId=a.pIndicadorId
                            left join Evidencia e on i.IndicadorId=e.indicadorId 
                            where a.empleadoId=3246 and mes=1;"
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
                // Manejar el éxito y actualizar las celdas correspondientes
                var data = response.d;
                var cumplimientoObjetivo = data.cumplimientoObjetivo;
                var evaluacionPonderada = data.evaluacionPonderada;

                // Asumiendo que las celdas de cumplimientoObjetivo y evaluacionPonderada están en la misma fila
                // Puedes cambiar esto según tu estructura de tabla
                var cumplimientoObjetivoCell = row.cells[7]; // Ajusta el índice según la posición real de la celda
                var evaluacionPonderadaCell = row.cells[8]; // Ajusta el índice según la posición real de la celda

                cumplimientoObjetivoCell.innerText = cumplimientoObjetivo.toFixed(2);
                evaluacionPonderadaCell.innerText = evaluacionPonderada.toFixed(2) + '%';

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
        var masterTableView = grid.get_masterTableView();
        var rows = masterTableView.get_dataItems();
        var tableData = [];

        for (var i = 0; i < rows.length; i++) {
            var cells = rows[i].get_element().cells;
            //if (cells[6].innerText.trim()!='0.00') {
            var rowData = {
                indicadorId: cells[0].innerText.trim(),
                resultado: cells[6].innerText.trim(),
                cumplimientoObjetivo: cells[7].innerText.trim(),
                evaluacionPonderada: cells[8].innerText.trim()
            };
            tableData.push(rowData);
            //}
        }

        $.ajax({
            type: "POST",
            url: "EvidenciaIndicadores.aspx/GuardarBorrador",
            data: JSON.stringify({ tableData: tableData }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                alert("Datos guardados exitosamente.");
            },
            error: function (response) {
                alert("Error al guardar los datos: " + response.responseText);
            }
        });

        return false; // Prevent default form submission
    }
</script>
