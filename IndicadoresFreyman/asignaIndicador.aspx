<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="asignaIndicador.aspx.cs" Inherits="IndicadoresFreyman.asignaIndicador" %>

<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href=" https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js" rel="stylesheet" />   
    <script src="js/bootstrap.min.js"></script>
    <link href="css/bootstrap-icons.css" rel="stylesheet" />
    <link href="css/bootstrap.css" rel="stylesheet" />
    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <link href="css/pantallaDivida.css" rel="stylesheet" />

     <script>
         function RowSelected(sender, eventArgs) {
             var e = eventArgs.get_domEvent();
             var index = eventArgs.get_itemIndexHierarchical();
             var gridView = $telerik.findControl(document, "radIndicador").get_masterTableView();
             var batchManager = $telerik.findControl(document, "radIndicador").get_batchEditingManager();
             
             var Rows = gridView.get_dataItems();
             //gridView.editItem(Rows[index].get_element());
             var celda = Rows[index].get_cell("activo");
             var seleccionada = Rows[index].get_selected();
             var contenido = celda.firstElementChild;
             //contenido.firstElementChild.firstElementChild.prop('readOnly', false);
             if (seleccionada) {
                 contenido.firstElementChild.firstElementChild.checked = true;
                 contenido.firstElementChild.firstElementChild.setAttribute('checked','');
             } else {
                 contenido.firstElementChild.firstElementChild.checked = false;
                 contenido.firstElementChild.firstElementChild.removeAttribute('checked');
             }

              batchManager.changeCellValue(celda, contenido.firstElementChild.firstElementChild.checked);
              
             // Obtener los valores actuales del lote
             //var batchCurrent = $find(gridView.get_id())._batchEditingManager.get_batchCurrent();

             // Marcar la celda como modificada en el lote
             //batchCurrent[rowIndex]["activo"] = checkbox.checked;

             // Forzar la actualización del lote
             //$find(gridView.get_id())._batchEditingManager.updateBatchCell(gridView.getCellByColumnUniqueName(row, "activo"));

             calculaTotal();
             // Actualizar el valor en el modo de edición por lotes
             //batchManager.changeCellValue(celda, contenido.firstElementChild.firstElementChild.checked);
             
            

             // Llamar a calculaTotal para actualizar el total
       
             
         }

         //function RowSelected(sender, eventArgs) {
         //    var index = eventArgs.get_itemIndexHierarchical();
         //    var gridView = $telerik.findControl(document, "radIndicador").get_masterTableView();
         //    var batchManager = $telerik.findControl(document, "radIndicador").get_batchEditingManager();

         //    var Rows = gridView.get_dataItems();
         //    var celda = Rows[index].get_cell("activo");
         //    var seleccionada = Rows[index].get_selected();
         //    var contenido = celda.firstElementChild;

         //    // Actualizar el estado del checkbox según la selección
         //    if (seleccionada) {
         //        contenido.firstElementChild.firstElementChild.checked = true;
         //        contenido.firstElementChild.firstElementChild.setAttribute('checked', '');
         //    } else {
         //        contenido.firstElementChild.firstElementChild.checked = false;
         //        contenido.firstElementChild.firstElementChild.removeAttribute('checked');
         //    }

         //    // Actualizar el valor en el modo de edición por lotes
         //    batchManager.changeCellValue(celda, contenido.firstElementChild.firstElementChild.checked);
         //}


        function calculaTotal() {
            if ($telerik.findControl(document, "radIndicador") == null) return;
            var gridView = $telerik.findControl(document, "radIndicador").get_masterTableView();
            var Rows = gridView.get_dataItems();
            var Total = 0;
            for (var i = 0; i < Rows.length; i++) {
                var seleccionada = Rows[i].get_selected();
                Total += seleccionada ? parseFloat(Rows[i].get_cell("Ponderacion").innerText) : 0;
                //if (seleccionada)
                    //gridView.updateItem(Rows[i].get_element());
            }
            document.getElementById("lblsuma").innerText = Total;
         }



         function OnBatchEditOpened(sender, args)
         {
             var grid = $find("<%=radIndicador.ClientID%>");
             var batchEditingManager = grid.get_batchEditingManager();
         }

</script>

    
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

     <p id="divMsgs" runat="server">
                <asp:Label ID="Label1" runat="server" EnableViewState="False" Font-Bold="True" ForeColor="#FF8080"> </asp:Label>
                <asp:Label ID="Label2" runat="server" EnableViewState="False" Font-Bold="True" ForeColor="#00C000"> </asp:Label>
            </p>


     <telerik:RadWindowManager RenderMode="Lightweight" ID="RadWindowManager1" runat="server" EnableShadow="true" Localization-OK="Si" Localization-Cancel="No">
    </telerik:RadWindowManager>


     <asp:Label ID="ErrorMessageLabel" runat="server" Text="Label"></asp:Label>

    <div class="split-screen">

        <div class="left-pane">

            <h3>&nbsp;</h3>

            <%--<div class="gridHeader">
                <div></div>
                <telerik:RadButton RenderMode="Lightweight" ID="SaveSettingsButton" runat="server" Skin="" Text="Save"
                    CssClass="saveButton" OnClick="SaveSettingsButton_Click" />
                <telerik:RadButton RenderMode="Lightweight" ID="LoadSettingsButton" runat="server" Skin="" Text="Load"
                    CssClass="loadButton" OnClick="LoadSettingsButton_Click" />
            </div>--%>



            <telerik:RadGrid RenderMode="Lightweight" ID="radGridEmpleados" GridLines="None" runat="server" AllowAutomaticDeletes="True"
                PageSize="20"
                AllowPaging="True"
                AutoGenerateColumns="False" Culture="bg-BG"  OnNeedDataSource ="radGridEmpleados_NeedDataSource"
                Style="margin: 0px auto" Width="50%" OnSelectedIndexChanged="radGridEmpleados_SelectedIndexChanged"  OnItemDataBound ="radGridEmpleados_ItemDataBound"> 
                <MasterTableView AutoGenerateColumns="false" AllowFilteringByColumn="False" ShowFooter="False"
                   HorizontalAlign="NotSet">
                    <%-- <BatchEditingSettings EditType="Cell" SaveAllHierarchyLevels="true" HighlightDeletedRows="true" OpenEditingEvent="DblClick" />--%>
                    <SortExpressions>
                        <telerik:GridSortExpression FieldName="nombre" SortOrder="Ascending" />

                    </SortExpressions>

                    <Columns>
                        <telerik:GridBoundColumn DataField="IdEmpleado" HeaderText="IdEmpleado" SortExpression="IdEmpleado" Visible="true"
                            UniqueName="IdEmpleado" ReadOnly="true">
                            <HeaderStyle Width="90px" />
                            <ItemStyle Width="90px" />
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="nombre" HeaderText="Nombre" SortExpression="nombre"
                            UniqueName="nombre" ReadOnly="true">
                            <HeaderStyle Width="350px" />
                            <ItemStyle Width="350px" />                            

                        </telerik:GridBoundColumn>


                        <telerik:GridBoundColumn DataField="ponderacion" HeaderText="Ponderación" SortExpression="ponderacion"
                            UniqueName="ponderacion" ReadOnly="true" Visible ="true">
                            <HeaderStyle Width="0px" />
                            <ItemStyle Width="0px" />                           
                        </telerik:GridBoundColumn>



                           <telerik:GridTemplateColumn UniqueName="IconColumn" HeaderText="Ponderación" DataField ="ponderacion" >
                            <ItemTemplate>  
                                
                                  <%--<span id="StatusIcon" runat="server">--%>
                                      <i id="StatusIcon"  runat ="server" style ="font-size:20px" ></i>
                                 <%-- </span>  --%>                                 
                                
                            </ItemTemplate>
                            <HeaderStyle  Font-Bold ="true" Width="80px"/>
                           <ItemStyle  HorizontalAlign ="Center"/>
                        </telerik:GridTemplateColumn>

                    </Columns>

                </MasterTableView>


                <ClientSettings Selecting-AllowRowSelect="true" EnablePostBackOnRowClick="true">

                    <Selecting AllowRowSelect="true" />
                    <Animation AllowColumnReorderAnimation="true" />
                    <Resizing AllowColumnResize="true" ResizeGridOnColumnResize="true" AllowResizeToFit="true" />
                </ClientSettings>
            </telerik:RadGrid>




           <%-- <asp:SqlDataSource ID="SqlEmpleados" runat="server" ConnectionString="<%$ ConnectionStrings:IndicadorConnectionString %>"
                SelectCommand="select IdEmpleado,nombre, DeptoId, Departamento ,isnull(sum(i.ponderacion),0) ponderacion from Vacaciones.dbo.AdministrativosNomiChecador as e 
                                left join  Indicador  as i on  e.IdEmpleado = i.empleadoId and activo = 1 
                                where DeptoId  = @DeptoId
                                group by IdEmpleado,nombre, DeptoId, Departamento">
                <SelectParameters>
                    <asp:ControlParameter Name="DeptoId" ControlID="hdnArea" PropertyName="Value" />
                </SelectParameters>
            </asp:SqlDataSource>--%>






        </div>
       
        <div class="right-pane">

           <asp:Label ID="lblsuma" runat="server" ClientIDMode="Static" Text=""></asp:Label>

            <telerik:RadGrid RenderMode="Lightweight" ID="radIndicador" GridLines="None" runat="server" AllowAutomaticDeletes="True"
                AllowAutomaticInserts="True" PageSize="50" Culture="bg-BG"
                OnItemUpdated="radIndicador_ItemUpdated" OnPreRender="radIndicador_PreRender" AllowAutomaticUpdates="True" AllowPaging="True" AllowMultiRowSelection="true" 
                AutoGenerateColumns="False" OnBatchEditCommand="radIndicador_BatchEditCommand" DataSourceID="SqlIndicador" OnItemDataBound="radIndicador_ItemDataBound"
                Width="75%" Style="margin: 0px auto;" >

               
                <MasterTableView CommandItemDisplay="TopAndBottom" DataKeyNames="pIndicadorId" TableLayout="Fixed"
                    DataSourceID="SqlIndicador" HorizontalAlign="NotSet" EditMode="Batch" AutoGenerateColumns="False" >
                    <%-- <BatchEditingSettings EditType="Cell"   SaveAllHierarchyLevels="true" HighlightDeletedRows="true" OpenEditingEvent="DblClick"  /> --%>
                    <BatchEditingSettings EditType="Cell" HighlightDeletedRows="true"  OpenEditingEvent="MouseDown"/>

                    <CommandItemSettings ShowAddNewRecordButton="false"/>

                    
                    <SortExpressions>
                        <telerik:GridSortExpression FieldName="pIndicadorId" SortOrder="Descending" />
                    </SortExpressions>
                    <ColumnGroups>
                        <telerik:GridColumnGroup HeaderText="Editables" Name="Editables" HeaderStyle-HorizontalAlign="Center"></telerik:GridColumnGroup>

                    </ColumnGroups>
                    <Columns>
                        <%-- <telerik:GridTemplateColumn HeaderText="Tipo" HeaderStyle-Width="150px" UniqueName="Tipoid" DataField="Tipoid">
                        <ItemTemplate>
                            <%# Eval("Tipo") %>
                        </ItemTemplate>
                        <HeaderStyle Width ="150px" />
                        <ItemStyle Width ="150px" />
                        <EditItemTemplate>
                            <telerik:RadDropDownList RenderMode="Lightweight" runat="server" ID="ddlTipo" DataValueField="Tipoid"
                                DataTextField="tipo" DataSourceID="SqlTipo" Width ="150px" >
                            </telerik:RadDropDownList>
                        </EditItemTemplate>
                    </telerik:GridTemplateColumn>--%>


                        <telerik:GridBoundColumn DataField="descripcionIndicador" HeaderStyle-Width="310px" HeaderText="Inidicador" SortExpression="descripcionIndicador"
                            UniqueName="descripcionIndicador" ReadOnly="true">
                            <ColumnValidationSettings EnableRequiredFieldValidation="true">
                                <RequiredFieldValidator ForeColor="Red" Text="*Indicador requerido" Display="Dynamic">
                                </RequiredFieldValidator>
                            </ColumnValidationSettings>
                            <HeaderStyle Width="410px" />
                            <ItemStyle Width="410px" />
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="ponderacion" HeaderStyle-Width="80px" HeaderText="Ponderación" SortExpression="Ponderacion" ColumnGroupName="Editables"
                            UniqueName="Ponderacion" DataFormatString="{0:N0}"  >

                            <ColumnValidationSettings EnableRequiredFieldValidation="true">
                                <RequiredFieldValidator ForeColor="Red" Text="*Indicador ponderación" Display="Dynamic">
                                </RequiredFieldValidator>
                            </ColumnValidationSettings>
                            <HeaderStyle Width="150px" />
                            <ItemStyle Width="150px" />
                        </telerik:GridBoundColumn>


                        <telerik:GridBoundColumn HeaderText="Indicador Minimo" HeaderStyle-Width="80px" SortExpression="indicadorMinimo" UniqueName="indicadorMinimo" ColumnGroupName="Editables"
                            DataField="indicadorMinimo" DataFormatString="{0:N0}">
                            <ColumnValidationSettings EnableRequiredFieldValidation="true">
                                <RequiredFieldValidator ForeColor="Red" Text="*Indicador Minimo" Display="Dynamic">
                                </RequiredFieldValidator>
                            </ColumnValidationSettings>
                            <HeaderStyle Width="150px" />
                            <ItemStyle Width="150px" />
                        </telerik:GridBoundColumn>


                        <telerik:GridBoundColumn HeaderText="Indicador Deseable" HeaderStyle-Width="80px" SortExpression="indicadorDeseable" UniqueName="indicadorDeseable" ColumnGroupName="Editables"
                            DataField="indicadorDeseable" DataFormatString="{0:N0}">
                            <ColumnValidationSettings EnableRequiredFieldValidation="true">
                                <RequiredFieldValidator ForeColor="Red" Text="Indicador deseable" Display="Dynamic">
                                </RequiredFieldValidator>
                            </ColumnValidationSettings>
                            <HeaderStyle Width="150px" />
                            <ItemStyle Width="150px" />
                        </telerik:GridBoundColumn>

                         <telerik:GridCheckBoxColumn DataField="activo" HeaderStyle-Width="80px" HeaderText="Activo" SortExpression="activo" HeaderStyle-HorizontalAlign="Center"  AllowSorting="true" Visible ="false"
                            UniqueName="activo">
                              <ItemStyle Width="0px" />
                              <ItemStyle Width="0px" />
                        </telerik:GridCheckBoxColumn>

                        <telerik:GridClientSelectColumn UniqueName="selectColumn">
                            <HeaderStyle Width="40px" />
                        </telerik:GridClientSelectColumn>



                        <%--<telerik:GridTemplateColumn HeaderText="Asignado" HeaderStyle-Width="150px" UniqueName="activo" DataField="activo"  >
                            <HeaderStyle Width="150px" />
                            <ItemTemplate>
                                <asp:CheckBox ID="chkAsignado" runat="server" AutoPostBack="true" OnCheckedChanged="chkAsignado_CheckedChanged" Checked='<%# Eval("activo") %>' />
                            </ItemTemplate>
                            <EditItemTemplate>
                                    <asp:CheckBox ID="chkAsignadoEdit" runat="server" Checked='<%# Bind("activo") %>' OnCheckedChanged="chkAsignado_CheckedChanged" />
                            </EditItemTemplate>
                        </telerik:GridTemplateColumn>--%>

                      

                      

                        <%--  <telerik:GridButtonColumn HeaderText="Eliminar" CommandName="Delete" Text="Delete" UniqueName="column" ConfirmText="Deseas borrar el proyecto?" ConfirmDialogType="RadWindow" >
                                <ItemStyle Width="80px" />
                                <HeaderStyle Width="80px" />
                            </telerik:GridButtonColumn>--%>
                    </Columns>
                </MasterTableView>
                <ClientSettings AllowKeyboardNavigation="true" >
                    <Selecting AllowRowSelect="true" UseClientSelectColumnOnly="true" />
                    <ClientEvents OnRowDeselected="RowSelected" OnRowSelected="RowSelected" OnGridCreated="calculaTotal" OnBatchEditCellValueChanged="calculaTotal"    />
                </ClientSettings>


                 
            </telerik:RadGrid>
        </div>
    </div>

    <asp:SqlDataSource ID="SqlIndicador" runat="server" ConnectionString="<%$ ConnectionStrings:IndicadorConnectionString %>"
        SelectCommand="consultaPlantillaIndicador" SelectCommandType="StoredProcedure"
        UpdateCommand="guardaAsignacion" UpdateCommandType="StoredProcedure" OnUpdating="SqlIndicador_Updating">
        <%-- DeleteCommand ="delete from PlantillaIndicador where pIndicadorId = @pIndicadorId "  DeleteCommandType ="Text">--%>

        <UpdateParameters>

            <asp:Parameter Name="descripcionIndicador" Type="String"></asp:Parameter>
            <asp:Parameter Name="indicadorMinimo" Type="Decimal"></asp:Parameter>
            <asp:Parameter Name="indicadorDeseable" Type="Decimal"></asp:Parameter>
            <asp:Parameter Name="Tipoid" Type="Int16"></asp:Parameter>
            <asp:Parameter Name="pIndicadorId" Type="Int32"></asp:Parameter>
            <asp:ControlParameter Name="DeptoId" ControlID="hdnArea" PropertyName="Value" />
            <asp:ControlParameter Name="empleadoId" ControlID="hdnEmpleado" PropertyName="Value" />
            <asp:Parameter Name="activo" Type="Boolean"></asp:Parameter>
            
        </UpdateParameters>

        <DeleteParameters>
            <asp:Parameter Name="pIndicadorId" Type="Int32"></asp:Parameter>
        </DeleteParameters>


        <SelectParameters>
            <asp:ControlParameter Name="DeptoId" ControlID="hdnArea" PropertyName="Value" />
            <asp:ControlParameter Name="empleadoId" ControlID="hdnEmpleado" PropertyName="Value" />
        </SelectParameters>


    </asp:SqlDataSource>


    <asp:SqlDataSource ID="SqlTipo" runat="server" ConnectionString="<%$ ConnectionStrings:IndicadorConnectionString %>"
        SelectCommand="select * from TipoIndicador  order by tipo  "></asp:SqlDataSource>

    <asp:HiddenField ID="htntotal" runat="server" Value="0" />
    <asp:HiddenField ID="hdneditar" runat="server" Value="0" />
    <asp:HiddenField ID="hdnArea" runat="server" />
    <asp:HiddenField ID="hdnEmpleado" runat="server" />

</asp:Content>
