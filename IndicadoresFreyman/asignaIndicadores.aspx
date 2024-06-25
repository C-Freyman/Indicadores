<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="asignaIndicadores.aspx.cs" Inherits="IndicadoresFreyman.asignaIndicadores" LCID="2058" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script src="js/bootstrap.min.js"></script>
    <link href="css/bootstrap-icons.css" rel="stylesheet" />
    <link href="css/bootstrap.css" rel="stylesheet" />
    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <link href="css/pantallaDivida.css" rel="stylesheet" />


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

        .coverImage {
            background-size: cover;
            background-repeat: no-repeat;
            background-position: center;
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
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <telerik:RadWindowManager RenderMode="Lightweight" ID="RadWindowManager1" runat="server" EnableShadow="true" Localization-OK="Si" Localization-Cancel="No">
    </telerik:RadWindowManager>

   
    <h2>Asignar</h2>

    <div class="split-screen">

        <div class="left-pane">

          

           

            <telerik:RadGrid RenderMode="Lightweight" ID="radGridEmpleados" GridLines="None" runat="server" AllowAutomaticDeletes="True"
                PageSize="20"
                AllowPaging="True"
                AutoGenerateColumns="False" Culture="bg-BG" OnNeedDataSource="radGridEmpleados_NeedDataSource" 
                Style="margin: 0px auto" Width="60%" OnSelectedIndexChanged="radGridEmpleados_SelectedIndexChanged" OnItemDataBound="radGridEmpleados_ItemDataBound">
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
              <div class ="divCenter" >
           
              
            </div>
            
              
        </div>


        <div class="right-pane">
            <div class="divCenter">
               
            </div>
           

            <telerik:RadGrid RenderMode="Lightweight" ID="radGridIndicador" runat="server" CssClass="RadGrid" AllowPaging="true" PageSize="200"
                AllowSorting="True" AutoGenerateColumns="False" AllowFilteringByColumn="false" OnItemCreated ="radGridIndicador_ItemCreated"
                EnableHeaderContextFilterMenu="true" ShowFooter ="true"
                FilterDelay="4000" ShowFilterIcon="false" OnNeedDataSource="radGridIndicador_NeedDataSource" OnItemDataBound="radGridIndicador_ItemDataBound"
                ShowStatusBar="True" Width="98%"
                Culture="es-ES" Style="margin: 0px auto" AllowFiltering="true">


                <GroupingSettings CaseSensitive="false"></GroupingSettings>

                <MasterTableView AllowFilteringByColumn="False" DataKeyNames="pIndicadorId" CommandItemDisplay="Top" >
                    <CommandItemSettings ShowAddNewRecordButton="false" />
                    <CommandItemTemplate>
                        <telerik:RadButton RenderMode="Lightweight" ID="btnAgregar" runat="server" Text="Agregar indicador"
                            ButtonType="StandardButton" UseSubmitBehavior="true" OnClick="btnAgregar_Click" />
                        <telerik:RadButton RenderMode="Lightweight" ID="btnGuardarIndicador" runat="server" Text="Guardar"
                            ButtonType="StandardButton" UseSubmitBehavior="true" OnClick="btnGuardarIndicador_Click" />
                        <asp:Label ID="lblEmpleado" runat="server" ClientIDMode="Static" Text="" Font-Bold="true" Font-Size="Larger" ForeColor="White"  ></asp:Label>
                        <asp:Label ID="lblsuma" runat="server" ClientIDMode="Static" Text="" Font-Bold="true" Font-Size="Larger" ForeColor="White"  CssClass ="label2"></asp:Label>
                         <asp:Label ID="lblEmpleadoId" runat="server" ClientIDMode="Static" Text="0" Visible ="false"></asp:Label>
                    </CommandItemTemplate>

                    <%--<SortExpressions>
                <telerik:GridSortExpression FieldName="pIndicadorId" SortOrder="Descending" />
            </SortExpressions>--%>
                    <Columns>


                        <telerik:GridBoundColumn UniqueName="pIndicadorId" HeaderText="Id" DataField="pIndicadorId" SortExpression="pIndicadorId"
                            FilterControlWidth="100%" AllowFiltering="false" AutoPostBackOnFilter="false" CurrentFilterFunction="Contains" ShowFilterIcon="false">
                            <ItemStyle Width="50px"  />
                            <HeaderStyle Width="50px" Font-Bold="true" HorizontalAlign="Center" />
                        </telerik:GridBoundColumn>


                        <telerik:GridBoundColumn UniqueName="descripcionIndicador" HeaderText="Indicador" DataField="descripcionIndicador" SortExpression="descripcionIndicador"
                            FilterControlWidth="100%" AllowFiltering="false" AutoPostBackOnFilter="false" CurrentFilterFunction="Contains" ShowFilterIcon="false" FooterText ="Total" FooterStyle-HorizontalAlign ="Right" FooterStyle-Font-Size ="18px" FooterStyle-Font-Bold ="true" FooterStyle-ForeColor ="White">
                            <ItemStyle Width="400px" />
                            <HeaderStyle Width="400px" Font-Bold="true" HorizontalAlign="Center" />
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="esAscendente" HeaderText="esAscendente" SortExpression="esAscendente"
                            UniqueName="esAscendente" ReadOnly="true" Visible="true">
                            <HeaderStyle Width="0px" />
                            <ItemStyle Width="0px" />
                        </telerik:GridBoundColumn>


                        <telerik:GridTemplateColumn UniqueName="colOrdenamiento" HeaderText="" DataField="esAscendente" FilterControlWidth="100%" AllowFiltering="false" AutoPostBackOnFilter="false" CurrentFilterFunction="Contains" ShowFilterIcon="false"  >
                            <ItemTemplate>

                                <%--<span id="StatusIcon" runat="server">--%>
                                <i id="StatusIcon" runat="server" style="font-size: 20px"></i>
                                <%-- </span>  --%>
                            </ItemTemplate>
                            <HeaderStyle Font-Bold="true" Width="30px" />
                            <ItemStyle HorizontalAlign="Center" Width="30px" />
                        </telerik:GridTemplateColumn>
                        <telerik:GridBoundColumn UniqueName="ponderacion" HeaderText="Ponderación" DataField="ponderacion" SortExpression="ponderacion" Aggregate ="Sum" FooterStyle-HorizontalAlign ="Center" FooterStyle-Font-Size ="24px" FooterStyle-Font-Bold ="true" FooterStyle-ForeColor ="White"
                            FilterControlWidth="100%" AllowFiltering="false" AutoPostBackOnFilter="false" CurrentFilterFunction="Contains" ShowFilterIcon="false" DataFormatString="{0:P0}">
                            <ItemStyle Width="70px" HorizontalAlign="Center" />
                            <HeaderStyle Width="70px" Font-Bold="true" HorizontalAlign="Center" />
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn UniqueName="indicadorMinimo" HeaderText="Indicador Minimo" DataField="indicadorMinimo" SortExpression="indicadorMinimo"
                            FilterControlWidth="100%" AllowFiltering="false" AutoPostBackOnFilter="false" CurrentFilterFunction="Contains" ShowFilterIcon="false" DataFormatString="{0:N1}">
                            <ItemStyle Width="70px" HorizontalAlign="Center" />
                            <HeaderStyle Width="70px" Font-Bold="true" HorizontalAlign="Center" />
                        </telerik:GridBoundColumn> 
                        <telerik:GridBoundColumn UniqueName="indicadorDeseable" HeaderText="Indicador Deseable" DataField="indicadorDeseable" SortExpression="indicadorDeseable"
                            FilterControlWidth="100%" AllowFiltering="false" AutoPostBackOnFilter="false" CurrentFilterFunction="Contains" ShowFilterIcon="false" DataFormatString="{0:N1}">
                            <ItemStyle Width="70px" HorizontalAlign="Center" />
                            <HeaderStyle Width="70px" Font-Bold="true" HorizontalAlign="Center" />
                        </telerik:GridBoundColumn>

                        <telerik:GridTemplateColumn UniqueName="Estatus" HeaderText="" ShowFilterIcon="false" AllowFiltering="false" AutoPostBackOnFilter="false" CurrentFilterFunction="Contains">
                            <ItemTemplate>
                                <telerik:RadImageButton runat="server" ID="btnBorrar" OnClick="btnBorrar_Click" Width="45px" Image-Url="~/Imagenes/basura.PNG" Value='<%# Eval("pIndicadorId")%>' Style="border: none; width: 1em; height: 1.5em;" CssClass="coverImage">
                                    <ConfirmSettings ConfirmText="Deseas quitar la asignación del indicador?" />
                                </telerik:RadImageButton>
                            </ItemTemplate>
                            <HeaderStyle Font-Bold="true" Width="25px" HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Left" Width="25px" CssClass="nowrap" />
                        </telerik:GridTemplateColumn>

                    </Columns>
                </MasterTableView>
                <GroupingSettings CollapseAllTooltip="Collapse all groups"></GroupingSettings>


                <ClientSettings EnablePostBackOnRowClick="true">

                    <Scrolling AllowScroll="True" UseStaticHeaders="true" ScrollHeight ="450px" />
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
                            AllowAutomaticInserts="True" PageSize="50" Culture="bg-BG" AllowMultiRowSelection="true"  
                            OnNeedDataSource="radAsigna_NeedDataSource"
                            AutoGenerateColumns="False"
                            Sytle ="overflow-x:auto; overflow-y:auto; width:100%; height: auto;">


                            <MasterTableView CommandItemDisplay="Top" DataKeyNames="pIndicadorId" AllowFilteringByColumn ="true"
                                HorizontalAlign="NotSet" AutoGenerateColumns="False">
                                <%-- <BatchEditingSettings EditType="Cell"   SaveAllHierarchyLevels="true" HighlightDeletedRows="true" OpenEditingEvent="DblClick"  /> --%>


                                <CommandItemSettings ShowAddNewRecordButton="false" />

                                <CommandItemTemplate>
                                    <telerik:RadButton RenderMode="Lightweight" ID="btnAsignaIndicador" runat="server" Text="Asignar indicador"
                                        ButtonType="StandardButton" UseSubmitBehavior="true" OnClick="btnAsignaIndicador_Click" BorderStyle="None" />
                                    <telerik:RadButton RenderMode="Lightweight" ID="btncerrarEdidar" runat="server" Text="Cerrar"
                                        ButtonType="StandardButton" UseSubmitBehavior="true" OnClick="btncerrarEdidar_Click" />
                                </CommandItemTemplate>


                                <Columns>

                                    <telerik:GridBoundColumn DataField="pIndicadorId" HeaderText="Id" SortExpression="pIndicadorId"
                                        UniqueName="pIndicadorId">
                                        <HeaderStyle Width="50px" />
                                        <ItemStyle Width="50px" />
                                    </telerik:GridBoundColumn>

                                    <telerik:GridBoundColumn DataField="descripcionIndicador" HeaderStyle-Width="310px" HeaderText="Inidicador" SortExpression="descripcionIndicador"
                                        UniqueName="descripcionIndicador" ReadOnly="true" FilterControlWidth="100%" AllowFiltering="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="false">
                                        <ColumnValidationSettings EnableRequiredFieldValidation="true">
                                            <RequiredFieldValidator ForeColor="Red" Text="*Indicador requerido" Display="Dynamic">
                                            </RequiredFieldValidator>
                                        </ColumnValidationSettings>
                                        <HeaderStyle Width="450px" />
                                        <ItemStyle Width="400px" />
                                    </telerik:GridBoundColumn>

                                    <telerik:GridBoundColumn DataField="ponderacion" HeaderStyle-Width="80px" HeaderText="Ponderación" SortExpression="Ponderacion"
                                        UniqueName="Ponderacion" DataFormatString="{0:P0}" ReadOnly="true" AllowFiltering="false" AutoPostBackOnFilter="false" CurrentFilterFunction="Contains" ShowFilterIcon="false">

                                        <ColumnValidationSettings EnableRequiredFieldValidation="true">
                                            <RequiredFieldValidator ForeColor="Red" Text="*Indicador ponderación" Display="Dynamic">
                                            </RequiredFieldValidator>
                                        </ColumnValidationSettings>
                                        <HeaderStyle Width="120px" />
                                        <ItemStyle Width="120px" HorizontalAlign="center" />
                                    </telerik:GridBoundColumn>


                                    <telerik:GridBoundColumn HeaderText="Indicador Minimo" HeaderStyle-Width="80px" SortExpression="indicadorMinimo" UniqueName="indicadorMinimo"
                                        DataField="indicadorMinimo" DataFormatString="{0:N1}" ReadOnly="true" AllowFiltering="false" AutoPostBackOnFilter="false" CurrentFilterFunction="Contains" ShowFilterIcon="false">
                                        <ColumnValidationSettings EnableRequiredFieldValidation="true">
                                            <RequiredFieldValidator ForeColor="Red" Text="*Indicador Minimo" Display="Dynamic">
                                            </RequiredFieldValidator>
                                        </ColumnValidationSettings>
                                        <HeaderStyle Width="120px" />
                                        <ItemStyle Width="120px" HorizontalAlign="center" />
                                    </telerik:GridBoundColumn>


                                    <telerik:GridBoundColumn HeaderText="Indicador Deseable" HeaderStyle-Width="80px" SortExpression="indicadorDeseable" UniqueName="indicadorDeseable"
                                        DataField="indicadorDeseable" DataFormatString="{0:N1}" ReadOnly="true" AllowFiltering="false" AutoPostBackOnFilter="false" CurrentFilterFunction="Contains" ShowFilterIcon="false">
                                        <ColumnValidationSettings EnableRequiredFieldValidation="true">
                                            <RequiredFieldValidator ForeColor="Red" Text="Indicador deseable" Display="Dynamic">
                                            </RequiredFieldValidator>
                                        </ColumnValidationSettings>
                                        <HeaderStyle Width="120px" />
                                        <ItemStyle Width="120px" HorizontalAlign="center" />
                                    </telerik:GridBoundColumn>


                                    <telerik:GridClientSelectColumn UniqueName="selectColumn">
                                        <HeaderStyle Width="40px" />
                                    </telerik:GridClientSelectColumn>






                                </Columns>
                            </MasterTableView>
                            <ClientSettings AllowKeyboardNavigation="true">
                                <Selecting AllowRowSelect="true" UseClientSelectColumnOnly="true" />
                                <Scrolling AllowScroll="True" UseStaticHeaders="true" ScrollHeight ="350px"  />
                                
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
    <asp:HiddenField ID="hdnEmpleado" runat="server" Value ="0" />
    <asp:HiddenField ID="hdnEmpleadoId" runat="server" Value ="0" />
    <asp:HiddenField ID="hdnCorreo" runat="server" />
    <asp:HiddenField ID="hdnIndicador" runat="server" Value="0" />
    <asp:HiddenField ID="hdnNomEmpleado" runat="server" Value="0" />
    <asp:HiddenField ID="hdnSuma" runat="server" Value="0" />
     <asp:HiddenField ID="hdnJefe" runat="server"  />

</asp:Content>
