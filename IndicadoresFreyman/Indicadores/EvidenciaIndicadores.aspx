<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EvidenciaIndicadores.aspx.cs" Inherits="IndicadoresFreyman.Indicadores.EvidenciaIndicadores" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<%@ Import Namespace="System.Web.Services" %>

<!DOCTYPE html>
<style>

    .demo-container .RadUpload .ruUploadProgress {
        width: 210px;
        display: inline-block;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
        vertical-align: top;
    }

    html .demo-container .ruFakeInput {
        width: 220px;
    }



    .demo-container .uploaded-files {
    padding: 10px;
    width: 240px;
    height: 100%;
    border-radius: 10px;
    background: #e7f9ff;
    font-size: 12px;
    position: relative;
}
 
    .demo-container .uploaded-files ul {
        margin: 10px 0 0;
        padding: 0;
        list-style: none;
    }
 
    .demo-container .uploaded-files li {
        margin: 10px 0 0;
    }
 
 
    .demo-container .uploaded-files dl {
        zoom: 1;
    }
 
        .demo-container .uploaded-files dl:after {
            content: "";
            clear: both;
            display: block;
        }
 
    .demo-container .uploaded-files dt {
        margin: 2px 0 0 0;
        width: 70px;
        opacity: .7;
        float: left;
        clear: both;
    }
 
    .demo-container .uploaded-files dd {
        margin: 2px 0 0 0;
        width: 170px;
        float: left;
        overflow: hidden;
        text-overflow: ellipsis;
        vertical-align: top;
    }

    .label1 {
        margin-left: 50px;
        font-size:15px;
    }
    .label2{
        font-size:18px;
        margin-right:200px;
        float:right;
    }

</style>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
       <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <telerik:RadAjaxLoadingPanel runat="server" ID="RadAjaxLoadingPanel1"></telerik:RadAjaxLoadingPanel>
        <telerik:RadFormDecorator RenderMode="Lightweight" ID="RadFormDecorator1" runat="server" DecorationZoneID="demo" DecoratedControls="All" EnableRoundedCorners="false" />
        
        <div id="demo">
            <%--<telerik:RadListBox RenderMode="Lightweight" runat="server" ID="SavedChangesList" Width="600px" Height="200px" Visible="false"></telerik:RadListBox>--%>
            <telerik:RadGrid RenderMode="Lightweight" ID="gridEvidencias" GridLines="None" runat="server"
                CellSpacing="0" CellPadding="0" Font-Size="Smaller" Style="padding: 0; margin: 0 auto"
                AllowAutomaticInserts="True" PageSize="10" AllowAutomaticUpdates="True" AllowPaging="True" OnItemCreated="gridEvidencias_ItemCreated"
                AutoGenerateColumns="False" DataSourceID="SqlDataSource1" OnBatchEditCommand="gridEvidencias_BatchEditCommand" OnItemDataBound="gridEvidencias_ItemDataBound" ShowFooter="true">

                <MasterTableView  CommandItemDisplay="Top"  EditMode="Batch" AutoGenerateColumns="False" CellPadding="0" CellSpacing="0">
                    <CommandItemSettings ShowAddNewRecordButton="false"  />
                    <CommandItemTemplate>                        
                        <asp:Button ID="SaveChangesButton" runat="server" CommandName="BatchSave" Text="Guardar Cambios" />
                        <asp:Button ID="CancelChangesButton" runat="server" CommandName="BatchCancel" Text="Cancelar Cambios" />
                        <asp:Button ID="GuardarBorradorButton" OnClientClick="return guardarBorrador();" runat="server" Text="Guardar Borrador" />

                        <asp:Label ID="nombreColaborador" CssClass="label1" runat="server" Text="Texto"></asp:Label>

                        <asp:Label ID="mes" CssClass="label2" runat="server" Text="Texto"></asp:Label>
                    </CommandItemTemplate>
                    <Columns>
                        <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='20' UniqueName="indicadorId" DataField='indicadorId' SortExpression="indicadorId" HeaderText='ID' 
                            ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon='false' ReadOnly="true" HeaderStyle-HorizontalAlign="center"></telerik:GridBoundColumn>
                        <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='50' UniqueName="descripcionIndicador" DataField='descripcionIndicador' SortExpression="descripcionIndicador" 
                            HeaderText='Descripción' ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon='false' ReadOnly="true" HeaderStyle-HorizontalAlign="center"></telerik:GridBoundColumn>
                        <telerik:GridBoundColumn FilterControlWidth="80%" HeaderStyle-Width='20' UniqueName="ponderacion" DataField='ponderacion' SortExpression="ponderacion" HeaderText='Ponderación' 
                            ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon='false' ReadOnly="true" HeaderStyle-HorizontalAlign="center"></telerik:GridBoundColumn>
                        <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='20' UniqueName="indicadorMinimo" DataField='indicadorMinimo' SortExpression="indicadorMinimo" HeaderText='IndicadorMinimo' 
                            ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon='false' ReadOnly="true" HeaderStyle-HorizontalAlign="center"></telerik:GridBoundColumn>
                        <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='20' UniqueName="indicadorDeseable" DataField='indicadorDeseable' SortExpression="indicadorDeseable" 
                            HeaderText='IndicadorDeseable' ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon='false' ReadOnly="true" HeaderStyle-HorizontalAlign="center"></telerik:GridBoundColumn>
                        <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='20' UniqueName="resultado" DataField='resultado' SortExpression="resultado" HeaderText='Resultado' 
                            ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon='false' HeaderStyle-HorizontalAlign="center" ItemStyle-BackColor="#BFBBBB"></telerik:GridBoundColumn>
                        <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='20' UniqueName="cumplimientoObjetivo" DataField='cumplimientoObjetivo' SortExpression="cumplimientoObjetivo" 
                            HeaderText='CumplimientoObjetivo' ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon='false' ReadOnly="true" HeaderStyle-HorizontalAlign="center"></telerik:GridBoundColumn>
                        <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='50' UniqueName="evaluacionPonderada" DataField='evaluacionPonderada' SortExpression="evaluacionPonderada"
                            HeaderText='EvaluacionPonderada' ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon='false' ReadOnly="true"  HeaderStyle-HorizontalAlign="center"></telerik:GridBoundColumn>
                    </Columns>
                    <FooterStyle Height="30px" HorizontalAlign="Center" Font-Size="Medium" Font-Bold="true"/>
                </MasterTableView>
                <ClientSettings AllowKeyboardNavigation="true">
                    <ClientEvents OnBatchEditCellValueChanged="BatchEditCellValueChanged"/>
                </ClientSettings>
            </telerik:RadGrid>
             <!-- Hidden label to store the value from the database -->
            <asp:Label ID="HiddenLabel" runat="server" Visible="false"></asp:Label>
        </div>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="Server=187.174.147.102; User ID=sa; password=similares*3; DataBase=Indicadores;"
            SelectCommand="select pli.pIndicadorId as indicadorId, pli.descripcionIndicador, concat(i.ponderacion,'%')as ponderacion,i.indicadorMinimo,i.indicadorDeseable,isnull(e.resultado,0)as resultado, 
                            isnull(cumplimientoOBjetivo,0)as cumplimientoObjetivo, isnull(evaluacionPonderada,0)as evaluacionPonderada from Indicador i 
                            left join Asignacion a on i.asignacionId=a.asignacionId
                            left join PlantillaIndicador pli on pli.pIndicadorId=a.pIndicadorId
                            left join resultadoIndicador e on i.IndicadorId=e.indicadorId 
                            where a.empleadoId=3246 and mes=1;">

        </asp:SqlDataSource>
        <div class="demo-container no-bg">
            <telerik:RadFormDecorator RenderMode="Lightweight" ID="FormDecorator1" runat="server" Skin="Office2007" DecoratedControls="Textbox, Buttons" />
 
            <h3>Archivo Evidencia</h3>
 
            <div class="uploaded-files">
                <asp:Literal runat="server" ID="ltrNoResults" Visible="True" Text="<strong>No files uploaded</strong>" />
                <asp:Repeater runat="server" ID="Repeater1">
                    <HeaderTemplate>
                        <ul>
                    </HeaderTemplate>
                    <FooterTemplate></ul></FooterTemplate>
                    <ItemTemplate>
                        <li>
                            <dl>
                                <dt>Nombre:</dt>
                                <dd><%# DataBinder.Eval(Container.DataItem, "FileName").ToString() %></dd>
                                <dt>Tamaño:</dt>
                                <dd><%# DataBinder.Eval(Container.DataItem, "ContentLength").ToString() %></dd>
                            </dl>
                        </li>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
 
            <telerik:RadAsyncUpload RenderMode="Lightweight" runat="server" ID="RadAsyncUpload1" OnClientFileUploading="onClientFileUploading" OnClientFileUploaded="onClientFileUploaded" OnFileUploaded="RadAsyncUpload1_FileUploaded"
                MultipleFileSelection="Disabled" Skin="Office2007"  />
 
            <p class="buttons">
                <asp:Button runat="server" ID="button1" OnClick="button1_Click"  Text="Submit" />
            </p>
 
        </div>

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
                var cumplimientoObjetivoCell = row.cells[6]; // Ajusta el índice según la posición real de la celda
                var evaluacionPonderadaCell = row.cells[7]; // Ajusta el índice según la posición real de la celda

                cumplimientoObjetivoCell.innerText = cumplimientoObjetivo.toFixed(2);
                evaluacionPonderadaCell.innerText = evaluacionPonderada.toFixed(2);

                console.log("Values saved successfully");
                /*updateFooterTotal();*/
            },
            error: function (response) {
                // Manejar el error
                console.log("Error saving values: " + response);
            }
        });
        
    }

    function guardarBorrador() {
        
        var grid = $find("<%= gridEvidencias.ClientID %>");
        var masterTableView = grid.get_masterTableView();
        var rows = masterTableView.get_dataItems();
        var tableData = []; 

        var fileInput = document.getElementById('FileUploadControl');
        if (fileInput != null) {
            var file = fileInput.files[0];
        }

        for (var i = 0; i < rows.length; i++) {
            var cells = rows[i].get_element().cells;
            //if (cells[6].innerText.trim()!='0.00') {
            var rowData = {
                indicadorId: cells[0].innerText.trim(),
                resultado: cells[5].innerText.trim(),
                cumplimientoObjetivo: cells[6].innerText.trim(),
                evaluacionPonderada: cells[7].innerText.trim()
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

                var grid = $find("<%= gridEvidencias.ClientID %>");
                if (grid) {
                    grid.get_masterTableView().rebind();
                }

                return true;
            },
            error: function (response) {
                alert("Error al guardar los datos: " + response.responseText);
                return false;
            }
        });

        return false; // Prevent default form submission
    }

    (function () {

        window.onClientFileUploaded = function (radAsyncUpload, args) {
            var row = args.get_row(),
            label = createLabel(inputID),
            br = document.createElement('br');

            row.appendChild(br);
            row.appendChild(label);
        };

        function createLabel(forArrt) {
            var label = document.createElement('label');

            label.setAttribute('for', forArrt);
            label.innerHTML = 'File info: ';

            return label;
        }
    })();

    function onClientFileUploading(sender, args) {//Validacion de mas de un archivo
        var uploadedFiles = sender.getUploadedFiles();
        if (uploadedFiles.length > 0) {
            args.set_cancel(true);
            alert("Solo un archivo puede ser seleccionado.");
        }
    }

</script>
