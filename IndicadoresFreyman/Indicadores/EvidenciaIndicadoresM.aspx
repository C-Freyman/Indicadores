<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="EvidenciaIndicadoresM.aspx.cs" Inherits="IndicadoresFreyman.Indicadores.EvidenciaIndicadoresM" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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
    width: 300px;
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

    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.12.9/dist/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
     <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>

    function BatchEditCellValueChanged(sender, args) {
        debugger;
        var cell = args.get_cell();
        var row = cell.parentNode;
        var filaHTML = row.innerText;
        var valorEditado = cell.innerText;
        //row.cells[6].innerText = "11";
        //row.cells[6].Attributes.Add("title", "holaaaa");
        // Enviar los valores de la fila al servidor usando AJAX
        $.ajax({
            type: "POST",
            url: "EvidenciaIndicadoresM.aspx/SaveRowValues",
            data: JSON.stringify({ filaHTML: filaHTML, valorEditado: valorEditado }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
               
                // Manejar el éxito y actualizar las celdas correspondientes
                var data = response.d;
                var cumplimientoObjetivo = data.cumplimientoObjetivo;
                var evaluacionPonderada = data.evaluacionPonderada;
                var cumplimientoObjetivoReal = data.cumplimientoObjetivoReal;

                // Asumiendo que las celdas de cumplimientoObjetivo y evaluacionPonderada están en la misma fila
                // Puedes cambiar esto según tu estructura de tabla
                var cumplimientoObjetivoCell = row.cells[6]; // Ajusta el índice según la posición real de la celda
                var evaluacionPonderadaCell = row.cells[7]; // Ajusta el índice según la posición real de la celda
                var cumplimientoObjetivoRealCell = row.cells[8];
               
                cumplimientoObjetivoCell.className = cumplimientoObjetivoReal;
                cumplimientoObjetivoCell.title = cumplimientoObjetivoReal;
                cumplimientoObjetivoCell.innerText = cumplimientoObjetivo.toFixed(2);
                evaluacionPonderadaCell.innerText = evaluacionPonderada.toFixed(2);
                cumplimientoObjetivoRealCell.innerText = cumplimientoObjetivoReal.toFixed(2);
               // cumplimientoObjetivoCell.Attributes.Add("title","holaaaa" );

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
                resultado: cells[5].innerText.trim(),
                cumplimientoObjetivo: cells[6].innerText.trim(),
                evaluacionPonderada: cells[7].innerText.trim(),
                cumplimientoObjetivoReal: (cells[6].className == '') ? 0 : cells[6].className //cells[8].innerText.trim()
            };
            tableData.push(rowData);
            //}
        }

        $.ajax({
            type: "POST",
            url: "EvidenciaIndicadoresM.aspx/GuardarBorrador",
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

    function cerrarCambios() {
        var seleccion = confirm("¿Desea cerrar los indicadores del mes? \n\n\tYa no podrá realizar cambios.");

        if (seleccion) {
            var grid = $find("<%= gridEvidencias.ClientID %>");

            var masterTableView = grid.get_masterTableView();
            var rows = masterTableView.get_dataItems();
            var tableData = [];

            for (var i = 0; i < rows.length; i++) {
                var cells = rows[i].get_element().cells;
                var rowData = {
                    indicadorId: cells[0].innerText.trim(),
                    resultado: cells[5].innerText.trim(),
                    cumplimientoObjetivo: cells[6].innerText.trim(),
                    evaluacionPonderada: cells[7].innerText.trim(),
                    cumplimientoObjetivoReal: (cells[6].className == '') ? 0 : cells[6].className //cells[8].innerText.trim()
                };
                tableData.push(rowData);
            }

            $.ajax({
                type: "POST",
                url: "EvidenciaIndicadoresM.aspx/CerrarCambios",
                data: JSON.stringify({ tableData: tableData}),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    masterTableView.rebind();
                },
                error: function (response) {
                    alert("Error al guardar los datos: " + response.responseText);
                }
            });
        }

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
            url: "EvidenciaIndicadoresM.aspx/fechaRadMonthYearPicker",
            data: JSON.stringify({ mes: selectedMonth, año: selectedYear }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                // Forzar un postback para actualizar el grid
                __doPostBack('<%= gridEvidencias.ClientID %>', '');
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
    <h1 style="display:inline-block;">Subir Indicadores</h1>
    
    <telerik:RadAjaxLoadingPanel runat="server" ID="RadAjaxLoadingPanel1"></telerik:RadAjaxLoadingPanel>
    <telerik:RadFormDecorator RenderMode="Lightweight" ID="RadFormDecorator1" runat="server" DecorationZoneID="demo" DecoratedControls="All" EnableRoundedCorners="false" />
  
    <div id="demo" style="margin-top:20px">
      
      <telerik:RadGrid RenderMode="Lightweight" ID="gridEvidencias" GridLines="None" runat="server"
          CellSpacing="0" CellPadding="0" Font-Size="Smaller" Style="padding: 0; margin: 0 auto"
          AllowAutomaticInserts="True" PageSize="10" AllowAutomaticUpdates="True" AllowPaging="True" OnItemCreated="gridEvidencias_ItemCreated"
          AutoGenerateColumns="False" OnItemDataBound="gridEvidencias_ItemDataBound" ShowFooter="true">

          <MasterTableView  CommandItemDisplay="Top"  EditMode="Batch" AutoGenerateColumns="False" CellPadding="0" CellSpacing="0">
              <CommandItemSettings ShowAddNewRecordButton="false"  />
              <CommandItemTemplate>                        
                  <asp:Button ID="SaveChangesButton" runat="server" OnClientClick="return cerrarCambios();" Text="Enviar Indicadores" />
                  
                  <asp:Button ID="GuardarBorradorButton" OnClientClick="return guardarBorrador();" runat="server" Text="Guardar Borrador" />

                  <asp:Label ID="nombreColaborador" CssClass="label1" runat="server" Text="Texto"></asp:Label>

                  
                  <telerik:RadMonthYearPicker RenderMode="Lightweight" ID="RadMonthYearPicker1" runat="server" Width="238px" MinDate="2024-01-1" CssClass="label2">
                      <ClientEvents OnDateSelected="OnDateSelected"></ClientEvents>
                  </telerik:RadMonthYearPicker>
              </CommandItemTemplate>
              <Columns>
                  <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='10' HeaderStyle-Font-Bold="true" UniqueName="indicadorId" DataField='indicadorId' SortExpression="indicadorId" HeaderText='ID' 
                      ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon='false' ReadOnly="true" HeaderStyle-HorizontalAlign="center"></telerik:GridBoundColumn>
                  <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='50' HeaderStyle-Font-Bold="true" UniqueName="descripcionIndicador" DataField='descripcionIndicador' SortExpression="descripcionIndicador" 
                      HeaderText='Descripción' ItemStyle-HorizontalAlign="Left" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon='false' ReadOnly="true" HeaderStyle-HorizontalAlign="center"></telerik:GridBoundColumn>
                  <telerik:GridBoundColumn FilterControlWidth="80%" HeaderStyle-Width='10' HeaderStyle-Font-Bold="true" UniqueName="ponderacion" DataField='ponderacion' SortExpression="ponderacion" HeaderText='Ponderación' 
                      ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon='false' ReadOnly="true" HeaderStyle-HorizontalAlign="center"></telerik:GridBoundColumn>
                  <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='12' HeaderStyle-Font-Bold="true" UniqueName="indicadorMinimo" DataField='indicadorMinimo' SortExpression="indicadorMinimo" HeaderText='Indicador Minimo (50 Pts.)' 
                      ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon='false' ReadOnly="true" HeaderStyle-HorizontalAlign="center"></telerik:GridBoundColumn>
                  <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='12' HeaderStyle-Font-Bold="true" UniqueName="indicadorDeseable" DataField='indicadorDeseable' SortExpression="indicadorDeseable" 
                      HeaderText='Indicador Deseable (100 Pts.)' ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon='false' ReadOnly="true" HeaderStyle-HorizontalAlign="center"></telerik:GridBoundColumn>
                  <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='20' HeaderStyle-Font-Bold="true" UniqueName="resultado" DataField='resultado' SortExpression="resultado" HeaderText='Resultado' 
                      ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon='false' HeaderStyle-HorizontalAlign="center" ItemStyle-BackColor="#BFBBBB"></telerik:GridBoundColumn>
                  <telerik:GridTemplateColumn FilterControlWidth='80%' HeaderStyle-Width='15' HeaderStyle-Font-Bold="true" UniqueName="cumplimientoObjetivo" DataField='cumplimientoObjetivo' SortExpression="cumplimientoObjetivo" 
                      HeaderText='Cumplimiento Objetivo (0-100 Pts.)' ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="false" CurrentFilterFunction="EqualTo" ShowFilterIcon='false' ReadOnly="true" HeaderStyle-HorizontalAlign="center">
                          <ItemTemplate>
                              <span style="font-size:13px"  class='<%# CargarEstilosCumplimiento(Convert.ToDecimal(Eval("cumplimientoObjetivo")))%>'>  <%# Eval("cumplimientoObjetivo") %></span>
                              <asp:HiddenField ID="HidcumplimientoObjetivoReal" Value='<%# Eval("cumplimientoOBjetivoReal") %>' runat="server" />
                          </ItemTemplate>
                  </telerik:GridTemplateColumn>
                  <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='15' HeaderStyle-Font-Bold="true" UniqueName="evaluacionPonderada" DataField='evaluacionPonderada' SortExpression="evaluacionPonderada"
                      HeaderText='Evaluacion Ponderada' ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon='false' ReadOnly="true"  HeaderStyle-HorizontalAlign="center"></telerik:GridBoundColumn>
                  <telerik:GridBoundColumn FilterControlWidth='80%' HeaderStyle-Width='15' Visible ="false"  HeaderStyle-Font-Bold="true" UniqueName="cumplimientoOBjetivoReal" DataField='cumplimientoOBjetivoReal' SortExpression="cumplimientoOBjetivoReal"
                    HeaderText='cumplimientoOBjetivoReal' ItemStyle-HorizontalAlign="center" AutoPostBackOnFilter="true" ReadOnly="true"  HeaderStyle-HorizontalAlign="center"></telerik:GridBoundColumn>
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
  <div class="demo-container no-bg">
      <telerik:RadFormDecorator RenderMode="Lightweight" ID="FormDecorator1" runat="server" DecoratedControls="Textbox, Buttons" />
 
      
 
      <div class="uploaded-files" style="margin:10px">
          <h3>Archivo Evidencia</h3>
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
          MultipleFileSelection="Disabled" />
 
      <p class="buttons">
          <asp:Button runat="server" ID="button1" OnClick="button1_Click"  Text="Guardar Archivo" />
      </p>
 
  </div>

</asp:Content>


