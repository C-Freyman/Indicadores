<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="asignaIndicadores.aspx.cs" Inherits="IndicadoresFreyman.asignaIndicadores" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script src="js/bootstrap.min.js"></script>
    <link href="css/bootstrap-icons.css" rel="stylesheet" />
    <link href="css/bootstrap.css" rel="stylesheet" />
    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <link href="css/pantallaDivida.css" rel="stylesheet" />
    </script>

    <style type="text/css">
        .modal-contenidos {
            background-color: white;
            width: 750px;
            padding: 5px 5px;
            margin: 3% auto;
            position: relative;
            height: auto;
        }

        .modal-contenidos2 {
            background-color: white;
            width: 1050px;
            padding: 5px 5px;
            margin: 3% auto;
            position: relative;
            height: auto;
        }

        .modales {
            background-color: rgba(0,0,0,.4);
            position: fixed;
            top: 0;
            right: 0;
            bottom: 0;
            left: 0;
        }

        .RadGrid .rgRow, .RadGrid .rgAltRow, .RadGrid .rgEditRow, .RadGrid .rgFooter, .RadGrid .rgGroupHeader {
            height: 5px !important;
        }

            RadGrid .rgRow > td, .RadGrid .rgAltRow > td, .RadGrid .rgEditRow > td, .RadGrid .rgFooter > td, .RadGrid .rgGroupHeader > td {
                padding-top: 0px !important;
                padding-bottom: 0px !important;
                /*font-size: 14px !important;*/
            }

        .divCenter {
            display: flex;
            justify-content: center;
        }

         .coverImage{
            background-size:cover;
            background-repeat:no-repeat; 
            background-position: center;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <telerik:RadWindowManager RenderMode="Lightweight" ID="RadWindowManager1" runat="server" EnableShadow="true" Localization-OK="Si" Localization-Cancel="No">
    </telerik:RadWindowManager>



    <div class="split-screen">

        <div class="left-pane">

            <h3>&nbsp;</h3>

            <telerik:RadGrid RenderMode="Lightweight" ID="radGridEmpleados" GridLines="None" runat="server" AllowAutomaticDeletes="True"
                PageSize="20"
                AllowPaging="True"
                AutoGenerateColumns="False" Culture="bg-BG" OnNeedDataSource="radGridEmpleados_NeedDataSource"
                Style="margin: 0px auto" Width="50%" OnSelectedIndexChanged="radGridEmpleados_SelectedIndexChanged" OnItemDataBound="radGridEmpleados_ItemDataBound">
                <MasterTableView AutoGenerateColumns="false" AllowFilteringByColumn="False" ShowFooter="False"
                    HorizontalAlign="NotSet">
                    <%-- <BatchEditingSettings EditType="Cell" SaveAllHierarchyLevels="true" HighlightDeletedRows="true" OpenEditingEvent="DblClick" />--%>
                    <SortExpressions>
                        <telerik:GridSortExpression FieldName="nombre" SortOrder="Ascending" />

                    </SortExpressions>

                    <Columns>
                        <telerik:GridBoundColumn DataField="IdEmpleado" HeaderText="IdEmpleado" SortExpression="IdEmpleado" Visible="true"
                            UniqueName="IdEmpleado" ReadOnly="true">
                            <HeaderStyle Width="0px" />
                            <ItemStyle Width="0px" />
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="nombre" HeaderText="Nombre" SortExpression="nombre"
                            UniqueName="nombre" ReadOnly="true">
                            <HeaderStyle Width="350px" />
                            <ItemStyle Width="350px" />

                        </telerik:GridBoundColumn>


                        <telerik:GridBoundColumn DataField="ponderacion" HeaderText="Ponderación" SortExpression="ponderacion"
                            UniqueName="ponderacion" ReadOnly="true" Visible="true">
                            <HeaderStyle Width="0px" />
                            <ItemStyle Width="0px" />
                        </telerik:GridBoundColumn>



                        <telerik:GridTemplateColumn UniqueName="IconColumn" HeaderText="Ponderación" DataField="ponderacion">
                            <ItemTemplate>

                                <%--<span id="StatusIcon" runat="server">--%>
                                <i id="StatusIcon" runat="server" style="font-size: 20px"></i>
                                <%-- </span>  --%>
                            </ItemTemplate>
                            <HeaderStyle Font-Bold="true" Width="100px" />
                            <ItemStyle HorizontalAlign="Center" />
                        </telerik:GridTemplateColumn>

                    </Columns>

                </MasterTableView>


                <ClientSettings Selecting-AllowRowSelect="true" EnablePostBackOnRowClick="true">

                    <Selecting AllowRowSelect="true" />
                    <Animation AllowColumnReorderAnimation="true" />
                    <Resizing AllowColumnResize="true" ResizeGridOnColumnResize="true" AllowResizeToFit="true" />
                </ClientSettings>
            </telerik:RadGrid>
        </div>


        <div class="right-pane">
            <div class="divCenter">
                <asp:Label ID="lblsuma" runat="server" ClientIDMode="Static" Text="" Font-Bold="true" Font-Size="Larger" ForeColor="Green"></asp:Label>
            </div>

            <telerik:RadGrid RenderMode="Lightweight" ID="radGridIndicador" runat="server" CssClass="RadGrid" AllowPaging="true" PageSize="200"
                AllowSorting="True" AutoGenerateColumns="False" AllowFilteringByColumn="false"
                EnableHeaderContextFilterMenu="true"
                FilterDelay="4000" ShowFilterIcon="false" OnNeedDataSource="radGridIndicador_NeedDataSource"
                ShowStatusBar="True" Width="85%"
                Culture="es-ES" Style="margin: 0px auto" AllowFiltering="true">

                
                <GroupingSettings CaseSensitive="false"></GroupingSettings>

                <MasterTableView AllowFilteringByColumn="True" DataKeyNames="pIndicadorId" CommandItemDisplay="Top">
                    <CommandItemSettings ShowAddNewRecordButton="false" />
                    <CommandItemTemplate>
                        <telerik:RadButton RenderMode="Lightweight" ID="btnAgregar" runat="server" Text="Agregar indicador"
                            ButtonType="StandardButton" UseSubmitBehavior="true" OnClick="btnAgregar_Click" />
                        <telerik:RadButton RenderMode="Lightweight" ID="btnGuardarIndicador" runat="server" Text="Guardar"
                            ButtonType="StandardButton" UseSubmitBehavior="true" OnClick="btnGuardarIndicador_Click" />
                    </CommandItemTemplate>

                    <%--<SortExpressions>
                <telerik:GridSortExpression FieldName="pIndicadorId" SortOrder="Descending" />
            </SortExpressions>--%>
                    <Columns>


                        <telerik:GridBoundColumn UniqueName="pIndicadorId" HeaderText="pIndicadorId" DataField="pIndicadorId" SortExpression="pIndicadorId"
                            FilterControlWidth="100%" AllowFiltering="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="false">
                            <ItemStyle Width="0px" />
                            <HeaderStyle Width="0px" Font-Bold="true" HorizontalAlign="Center" />
                        </telerik:GridBoundColumn>


                        <telerik:GridBoundColumn UniqueName="descripcionIndicador" HeaderText="Indicador" DataField="descripcionIndicador" SortExpression="descripcionIndicador"
                            FilterControlWidth="100%" AllowFiltering="false" AutoPostBackOnFilter="false" CurrentFilterFunction="Contains" ShowFilterIcon="false">
                            <ItemStyle Width="400px" />
                            <HeaderStyle Width="400px" Font-Bold="true" HorizontalAlign="Center" />
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn UniqueName="ponderacion" HeaderText="Ponderación" DataField="ponderacion" SortExpression="ponderacion"
                            FilterControlWidth="100%" AllowFiltering="false" AutoPostBackOnFilter="false" CurrentFilterFunction="Contains" ShowFilterIcon="false" DataFormatString="{0:P0}">
                            <ItemStyle Width="70px" HorizontalAlign="Center" />
                            <HeaderStyle Width="70px" Font-Bold="true" HorizontalAlign="Center" />
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn UniqueName="indicadorMinimo" HeaderText="Indicador Minimo" DataField="indicadorMinimo" SortExpression="indicadorMinimo"
                            FilterControlWidth="100%" AllowFiltering="false" AutoPostBackOnFilter="false" CurrentFilterFunction="Contains" ShowFilterIcon="false" DataFormatString="{0:N0}">
                            <ItemStyle Width="70px" HorizontalAlign="Center" />
                            <HeaderStyle Width="70px" Font-Bold="true" HorizontalAlign="Center" />
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn UniqueName="indicadorDeseable" HeaderText="Indicador Deseable" DataField="indicadorDeseable" SortExpression="indicadorDeseable"
                            FilterControlWidth="100%" AllowFiltering="false" AutoPostBackOnFilter="false" CurrentFilterFunction="Contains" ShowFilterIcon="false" DataFormatString="{0:N0}">
                            <ItemStyle Width="70px" HorizontalAlign="Center" />
                            <HeaderStyle Width="70px" Font-Bold="true" HorizontalAlign="Center" />
                        </telerik:GridBoundColumn>

                        <telerik:GridTemplateColumn UniqueName="Estatus" HeaderText="" ShowFilterIcon="false" AllowFiltering="false" AutoPostBackOnFilter="false" CurrentFilterFunction="Contains">
                            <ItemTemplate>
                              <%--  <asp:Button ID="btnBorrar" runat="server" BorderStyle="None" ForeColor="#0000ff" Font-Underline="true" Value='<%# Eval("pIndicadorId") %>'
                                    OnClick="btnBorrar_Click" Width="45px" Style='<%# cargaimagen()%>' />--%>
                                
                        <telerik:RadImageButton  runat="server" ID="btnBorrar" OnClick="btnBorrar_Click" Width="45px" Image-Url ="~/Imagenes/basura.PNG"  Value='<%# Eval("pIndicadorId")%>'  Style  ="border:none;  width:1em; height:1.5em;" CssClass="coverImage">
                            <ConfirmSettings ConfirmText="Deseas quitar la asignación el indicador?" />  
                        </telerik:RadImageButton>
                            </ItemTemplate>
                            <HeaderStyle Font-Bold="true" Width="25px" HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Left" Width="25px" CssClass="nowrap" />
                        </telerik:GridTemplateColumn>

                    </Columns>
                </MasterTableView>
                <GroupingSettings CollapseAllTooltip="Collapse all groups"></GroupingSettings>


                <ClientSettings EnablePostBackOnRowClick="true">

                    <Scrolling AllowScroll="True" UseStaticHeaders="true" ScrollHeight="450" />
                    <Resizing AllowColumnResize="true" ResizeGridOnColumnResize="true" AllowResizeToFit="true" />
                </ClientSettings>



                <FilterMenu RenderMode="Lightweight"></FilterMenu>

                <HeaderContextMenu RenderMode="Lightweight"></HeaderContextMenu>
            </telerik:RadGrid>
        </div>
    </div>


    <asp:Panel ID="pnlEditar" runat="server" Visible="false">

        <div class="modales" id="mdlencuesta" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
            <div class="modal-contenidos2" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalEditar">
                            <asp:Label ID="lbltiulo" runat="server" Text="Asignar Indicadores" Font-Bold="true" Font-Size="Larger"></asp:Label>
                        </h5>
           
                        <asp:Button ID="btncerrarMdl" runat="server" Text="X" Font-Size="Smaller" BorderStyle="None" BackColor="Transparent" class="close" data-dismiss="modal" aria-label="Close" OnClick="btncerrarMdl_Click" />
                    </div>
                    <div class="modal-body">
                        <telerik:RadGrid RenderMode="Lightweight" ID="radAsigna" GridLines="None" runat="server" AllowAutomaticDeletes="True"
                            AllowAutomaticInserts="True" PageSize="50" Culture="bg-BG" AllowMultiRowSelection ="true"
                            OnNeedDataSource="radAsigna_NeedDataSource" 
                            AutoGenerateColumns="False"
                            Width="75%" Style="margin: 0px auto;">
                            

                            <MasterTableView CommandItemDisplay="Top" DataKeyNames="pIndicadorId"
                                HorizontalAlign="NotSet" AutoGenerateColumns="False">
                                <%-- <BatchEditingSettings EditType="Cell"   SaveAllHierarchyLevels="true" HighlightDeletedRows="true" OpenEditingEvent="DblClick"  /> --%>
                        

                                <CommandItemSettings ShowAddNewRecordButton="false" />

                                <CommandItemTemplate>
                                    <telerik:RadButton RenderMode="Lightweight" ID="btnAsignaIndicador" runat="server" Text="Asingar indicador"
                                        ButtonType="StandardButton" UseSubmitBehavior="true" OnClick="btnAsignaIndicador_Click"  BorderStyle ="None"/>
                                    <telerik:RadButton RenderMode="Lightweight" ID="btncerrarEdidar" runat="server" Text="Cerrar"
                                        ButtonType="StandardButton" UseSubmitBehavior="true" OnClick="btncerrarEdidar_Click" />
                                </CommandItemTemplate>
                               

                                <Columns>

                                    <telerik:GridBoundColumn DataField="pIndicadorId" HeaderText="Id" SortExpression="pIndicadorId"
                                        UniqueName="pIndicadorId" >
                                        <HeaderStyle Width="0px" />
                                        <ItemStyle Width="0px" />
                                    </telerik:GridBoundColumn>

                                    <telerik:GridBoundColumn DataField="descripcionIndicador" HeaderStyle-Width="310px" HeaderText="Inidicador" SortExpression="descripcionIndicador"
                                        UniqueName="descripcionIndicador" ReadOnly="true">
                                        <ColumnValidationSettings EnableRequiredFieldValidation="true">
                                            <RequiredFieldValidator ForeColor="Red" Text="*Indicador requerido" Display="Dynamic">
                                            </RequiredFieldValidator>
                                        </ColumnValidationSettings>
                                        <HeaderStyle Width="410px" />
                                        <ItemStyle Width="410px" />
                                    </telerik:GridBoundColumn>

                                    <telerik:GridBoundColumn DataField="ponderacion" HeaderStyle-Width="80px" HeaderText="Ponderación" SortExpression="Ponderacion"
                                        UniqueName="Ponderacion" DataFormatString="{0:P0}" ReadOnly="true">

                                        <ColumnValidationSettings EnableRequiredFieldValidation="true">
                                            <RequiredFieldValidator ForeColor="Red" Text="*Indicador ponderación" Display="Dynamic">
                                            </RequiredFieldValidator>
                                        </ColumnValidationSettings>
                                        <HeaderStyle Width="150px" />
                                        <ItemStyle Width="150px" HorizontalAlign ="center" />
                                    </telerik:GridBoundColumn>


                                    <telerik:GridBoundColumn HeaderText="Indicador Minimo" HeaderStyle-Width="80px" SortExpression="indicadorMinimo" UniqueName="indicadorMinimo"
                                        DataField="indicadorMinimo" DataFormatString="{0:N0}" ReadOnly="true">
                                        <ColumnValidationSettings EnableRequiredFieldValidation="true">
                                            <RequiredFieldValidator ForeColor="Red" Text="*Indicador Minimo" Display="Dynamic">
                                            </RequiredFieldValidator>
                                        </ColumnValidationSettings>
                                        <HeaderStyle Width="150px" />
                                        <ItemStyle Width="150px" HorizontalAlign ="center" />
                                    </telerik:GridBoundColumn>


                                    <telerik:GridBoundColumn HeaderText="Indicador Deseable" HeaderStyle-Width="80px" SortExpression="indicadorDeseable" UniqueName="indicadorDeseable"
                                        DataField="indicadorDeseable" DataFormatString="{0:N0}" ReadOnly="true">
                                        <ColumnValidationSettings EnableRequiredFieldValidation="true">
                                            <RequiredFieldValidator ForeColor="Red" Text="Indicador deseable" Display="Dynamic">
                                            </RequiredFieldValidator>
                                        </ColumnValidationSettings>
                                        <HeaderStyle Width="150px" />
                                        <ItemStyle Width="150px" HorizontalAlign ="center"/>
                                    </telerik:GridBoundColumn>


                                    <telerik:GridClientSelectColumn UniqueName="selectColumn">
                                        <HeaderStyle Width="40px" />
                                    </telerik:GridClientSelectColumn>






                                </Columns>
                            </MasterTableView>
                            <ClientSettings AllowKeyboardNavigation="true" >
                                <Selecting AllowRowSelect="true" UseClientSelectColumnOnly="true" />
                                
                            </ClientSettings>



                        </telerik:RadGrid>
                    </div>

                </div>
            </div>

        </div>
    </asp:Panel>


    <asp:HiddenField ID="htntotal" runat="server" Value="0" />
    <asp:HiddenField ID="hdneditar" runat="server" Value="0" />
    <asp:HiddenField ID="hdnArea" runat="server" />
    <asp:HiddenField ID="hdnEmpleado" runat="server" />
    <asp:HiddenField ID="hdnCorreo" runat="server" />
    <asp:HiddenField ID="hdnIndicador" runat="server" Value ="0" />
</asp:Content>
