﻿<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="crearIndicadores.aspx.cs" Inherits="IndicadoresFreyman.crearIndicadores" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">

        function soloNumeros(e) {
            var key = window.Event ? e.which : e.keyCode
            
            var valido = (key >= 48 && key <= 57);
            calculaTipo();
            return valido;
        }



        function calculaTipo() {
            var minimo = parseInt(document.getElementById('txtindicadorMinimo').value) || 0;
            var deseable = parseInt(document.getElementById('txtindicadorDeseable').value) || 0;

            var mensaje = (minimo < deseable) ? 'Indicador Ascendente' : 'Indicador Descendente';
            mensaje = (minimo == 0 || deseable == 0) ? '  ' : mensaje;
            document.getElementById('lblTipoIndicador').innerText = mensaje;
        }

       
    </script>





</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <p id="divMsgs" runat="server">
        <asp:Label ID="Label1" runat="server" EnableViewState="False" Font-Bold="True" ForeColor="#FF8080"> </asp:Label>
        <asp:Label ID="Label2" runat="server" EnableViewState="False" Font-Bold="True" ForeColor="#00C000"> </asp:Label>
    </p>



    <telerik:RadWindowManager RenderMode="Lightweight" ID="RadWindowManager1" runat="server" EnableShadow="true" Localization-OK="Aceptar" Localization-Cancel="No">
    </telerik:RadWindowManager>




    <telerik:RadGrid RenderMode="Lightweight" ID="radGridIndicador" runat="server" CssClass="RadGrid" AllowPaging="true" PageSize="200"
        AllowSorting="True" AutoGenerateColumns="False" AllowFilteringByColumn="True"
        EnableHeaderContextFilterMenu="true"
        FilterDelay="4000" ShowFilterIcon="false"
        ShowStatusBar="True" AllowAutomaticDeletes="True" AllowAutomaticInserts="True"
        AllowAutomaticUpdates="True" DataSourceID="SqlIndicador" OnItemDeleted="radGridIndicador_ItemDeleted" OnItemDataBound ="radGridIndicador_ItemDataBound"
        OnItemInserted="radGridIndicador_ItemInserted" OnItemUpdated="radGridIndicador_ItemUpdated" OnItemCommand="radGridIndicador_ItemCommand"
        Culture="es-ES" Style="margin: 0px auto" Width="60%" AllowFiltering="true">

        <ExportSettings IgnorePaging="true" ExportOnlyData="true" FileName="Proyectos desarollo">
            <Excel Format="Xlsx" WorksheetName="Proyectos desarollo" DefaultCellAlignment="Left" />
        </ExportSettings>
        <GroupingSettings CaseSensitive="false"></GroupingSettings>
        <MasterTableView EditMode="PopUp" CommandItemDisplay="Top" DataSourceID="SqlIndicador" DataKeyNames="pIndicadorId" AllowFilteringByColumn="True">
            <CommandItemSettings ShowExportToWordButton="false" ShowExportToCsvButton="false" ShowAddNewRecordButton="true" ShowRefreshButton="true" ShowExportToExcelButton="true" />
            <RowIndicatorColumn ShowNoSortIcon="false"></RowIndicatorColumn>
            <SortExpressions>
                <telerik:GridSortExpression FieldName="pIndicadorId" SortOrder="Descending" />
            </SortExpressions>
            <Columns>

                <telerik:GridEditCommandColumn>
                    <ItemStyle Width="40px" />
                    <HeaderStyle Width="40px" />
                </telerik:GridEditCommandColumn>

                <telerik:GridBoundColumn UniqueName="tipo" HeaderText="Tipo" DataField="tipo" SortExpression="tipo"
                    FilterControlWidth="100%" AllowFiltering="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="false">
                    <ItemStyle Width="100px" />
                    <HeaderStyle Width="100px" Font-Bold="true" HorizontalAlign="Center" />
                </telerik:GridBoundColumn>

                <telerik:GridBoundColumn UniqueName="descripcionIndicador" HeaderText="Indicador" DataField="descripcionIndicador" SortExpression="descripcionIndicador"
                    FilterControlWidth="100%" AllowFiltering="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="false">
                    <ItemStyle Width="200px" />
                    <HeaderStyle Width="200px" Font-Bold="true" HorizontalAlign="Center" />
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn UniqueName="ponderacion" HeaderText="Ponderación" DataField="ponderacion" SortExpression="ponderacion"
                    FilterControlWidth="100%" AllowFiltering="false" AutoPostBackOnFilter="false" CurrentFilterFunction="Contains" ShowFilterIcon="false" DataFormatString="{0:N0}">
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


                <telerik:GridButtonColumn HeaderText="Eliminar" CommandName="Delete" Text="Delete" UniqueName="column" ConfirmText="Deseas borrar el indicador?" ConfirmDialogType="RadWindow">

                    <ItemStyle Width="80px" />
                    <HeaderStyle Width="80px" />
                </telerik:GridButtonColumn>

            </Columns>
            <EditFormSettings EditFormType="Template" PopUpSettings-Width="1070px" PopUpSettings-Modal="true">

                <EditColumn ShowNoSortIcon="False" UniqueName="EditCommandColumn1" FilterControlAltText="Filter EditCommandColumn1 column"></EditColumn>
                <FormTemplate>
                    <table id="Table2" cellspacing="2" cellpadding="1" border="0" rules="none"
                        style="border-collapse: collapse;">
                        <tr class="EditFormHeader">
                            <td colspan="2" style="font-size: larger; text-align: center">

                                <b>Crear indicador</b>
                            </td>
                        </tr>
                      
               

                                <tr>
                                    <td style="width: 50px">Tipo:
                                    </td>
                                    <td>


                                        <telerik:RadDropDownList RenderMode="Lightweight" ID="ddltipo" runat="server" DefaultMessage="Selecciona tipo"
                                            DropDownHeight="80px" SelectedValue='<%# Bind("tipoId") %>' DataValueField="tipoId"
                                            DataTextField="tipo" TabIndex="7" DataSourceID="SqlTipo" Width="250px">
                                        </telerik:RadDropDownList>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ErrorMessage="Tipo requerido" ControlToValidate="ddltipo" ForeColor="Red"></asp:RequiredFieldValidator>
                                    </td>
                                    <td colspan="2"></td>
                                </tr>






                                <tr>
                                    <td style="width: 50px">Indicador:
                                    </td>
                                    <td colspan="2">
                                        <asp:TextBox ID="txtdescripcionIndicador" runat="server" Text='<%# Bind("descripcionIndicador") %>' TabIndex="2" Width="250px" TextMode="MultiLine" Style="width: 900px; height: 60px">                                             
                                        </asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="indicador requerido" ControlToValidate="txtdescripcionIndicador" ForeColor="Red"></asp:RequiredFieldValidator>

                                    </td>
                                  
                                </tr>
                             </table>

                              <table id="Table3" cellspacing="2" cellpadding="1" border="0" rules="none" style="border-collapse: collapse;">
                                <tr>
                                    <td scolspan="2" style="width: 50px">Ponderacion:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtponderacion" runat="server" Text='<%# Bind("ponderacion") %>' TabIndex="2" Width="250px" onKeyPress="return soloNumeros(event)" onChange="calculaTipo()">
                                        </asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ErrorMessage="Ponderación requerido" ControlToValidate="txtponderacion" ForeColor="Red"></asp:RequiredFieldValidator>

                                    </td>

                                    <td style="width: 50px">Indicador Minimo:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtindicadorMinimo" ClientIDMode="Static" runat="server" Text='<%# Bind("indicadorMinimo") %>' TabIndex="2" Width="250px" onKeyPress="return soloNumeros(event)" onChange="calculaTipo()">
                                        </asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server" ErrorMessage="indicador Minimo requerido" ControlToValidate="txtindicadorMinimo" ForeColor="Red"></asp:RequiredFieldValidator>

                                        <%--  <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="Invalid input"
                                                ControlToValidate="txtindicadorMinimo" OnServerValidate="CustomValidator1_ServerValidate">
                                            </asp:CustomValidator>--%>

                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2"></td>

                                    <td>Indicador Deseable:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtindicadorDeseable" ClientIDMode="Static" runat="server" Text='<%# Bind("indicadorDeseable") %>' TabIndex="2" Width="250px" onKeyPress="return soloNumeros(event)" onBlur="calculaTipo()">
                                        </asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="indicador Deseable requerido" ControlToValidate="txtindicadorDeseable" ForeColor="Red"></asp:RequiredFieldValidator>

                                        <%--<asp:CustomValidator ID="cvIndicadorMinimo" runat="server" ErrorMessage="El Indicador Minimo no puede ser mayor que la Ponderación" ForeColor="Red" ControlToValidate="txtindicadorDeseable" OnServerValidate="cvIndicadorMinimo_ServerValidate"></asp:CustomValidator>--%>


                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">&nbsp;</td>
                                    <td colspan="2">
                                        <asp:Label ID="lblTipoIndicador" ClientIDMode="Static" runat="server" Text="   " ForeColor="DarkBlue"></asp:Label>
                                    </td>

                                    <%-- <td>
                                           <telerik:RadDropDownList RenderMode="Lightweight" ID="ddlAscendente" runat="server" DefaultMessage="Selecciona tipo"
                                                DropDownHeight="80px" SelectedValue='<%# Bind("esAscedente") %>' DataValueField="tipoId"
                                                DataTextField="tipo" TabIndex="7" DataSourceID="SqlTipo" Width="250px">                                               
                                            </telerik:RadDropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Tipo requerido" ControlToValidate="ddltipo" ForeColor="Red"></asp:RequiredFieldValidator>
                                        </td>--%>
                                </tr>

                                <%--   <tr>
                                        <td>Ordenamiento:
                                        </td>
<!--<<<<<< devAngeles-->
                                        <td>


                                            <telerik:RadDropDownList RenderMode="Lightweight" ID="ddlascendente" runat="server" DefaultMessage="Selecciona orden"
                                                DropDownHeight="80px" SelectedValue='<%# Bind("OrdenId") %>' DataValueField="OrdenId"
                                                DataTextField="orden" TabIndex="7" DataSourceID="sqlOrden" Width="250px">
                                            </telerik:RadDropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Ascendente requerido" ControlToValidate="ddlascendente" ForeColor="Red"></asp:RequiredFieldValidator>
                                        </td>--%>
                       </tr>
                  
<%--=======--%>
                                       <%-- <td >
                                            <asp:TextBox ID="txtdescripcionIndicador" runat="server" Text='<%# Bind("descripcionIndicador") %>' TabIndex="2" Width="250px" TextMode="MultiLine" style ="width: 900px; height:60px"  >                                             
                                            </asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Proyecto requerido" ControlToValidate="txtdescripcionIndicador" ForeColor="Red"></asp:RequiredFieldValidator>

                                        </td>
                                    </tr>


                                    <tr>
                                        <td>Ponderacion:
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtponderacion" runat="server" Text='<%# Bind("ponderacion") %>' TabIndex="2" Width="250px" onKeyPress="return soloNumeros(event)">
                                            </asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ErrorMessage="Objectivo requerido" ControlToValidate="txtponderacion" ForeColor="Red"></asp:RequiredFieldValidator>

                                        </td>
                                    </tr>
                                    <tr>
                                        <td>indicador Minimo:
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtindicadorMinimo" runat="server" Text='<%# Bind("indicadorMinimo") %>' TabIndex="2" Width="250px" onKeyPress="return soloNumeros(event)">
                                            </asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server" ErrorMessage="indicador Minimo requerido" ControlToValidate="txtindicadorMinimo"  ForeColor="Red"></asp:RequiredFieldValidator>

                                        </td>
                                    </tr>
                                    <tr>
                                        <td>indicador Deseable:
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtindicadorDeseable" runat="server" Text='<%# Bind("indicadorDeseable") %>' TabIndex="2" Width="250px" onKeyPress="return soloNumeros(event)" OnTextChanged ="txtindicadorDeseable_TextChanged">
                                            </asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="indicador Deseable requerido" ControlToValidate="txtindicadorDeseable" ForeColor="Red"></asp:RequiredFieldValidator>

                                        </td>
                                    </tr>

                                    <%-- <tr>
                                        <td>Ascendente:
                                        </td>
                                        <td>


                                            <telerik:RadDropDownList RenderMode="Lightweight" ID="RadDropDownList1" runat="server" DefaultMessage="Selecciona tipo"
                                                DropDownHeight="80px" SelectedValue='<%# Bind("tipoId") %>' DataValueField="tipoId"
                                                DataTextField="tipo" TabIndex="7" DataSourceID="SqlTipo" Width="250px">
                                            </telerik:RadDropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Tipo requerido" ControlToValidate="ddltipo" ForeColor="Red"></asp:RequiredFieldValidator>
                                        </td>
                                    </tr>--%>


                                <%--</table>--%>
<%-->>>>>>> main--%>

                    </td>
                        </tr>
                        <tr>
                            <td colspan="2"></td>
                        </tr>
                    <tr>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td align="right" colspan="2">
                            <asp:Button ID="btnUpdateIndicador" Text='<%# (Container is GridEditFormInsertItem) ? "Insertar" : "Actualizar" %>'
                                runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update" %>' ConfirmText="Deseas guaradar el indicador?" ConfirmDialogType="RadWindow"></asp:Button>&nbsp;
                                                        <asp:Button ID="btnCancelIndicador" Text="Cancelar" runat="server" CausesValidation="False"
                                                            CommandName="Cancel"></asp:Button>
                        </td>
                    </tr>
                    </table>


                </FormTemplate>
            </EditFormSettings>



        </MasterTableView>
        <GroupingSettings CollapseAllTooltip="Collapse all groups"></GroupingSettings>

        <ClientSettings Selecting-AllowRowSelect="true" EnablePostBackOnRowClick="true">
            <Selecting AllowRowSelect="true" />
            <Animation AllowColumnReorderAnimation="true" />
            <Scrolling AllowScroll="True" UseStaticHeaders="true" ScrollHeight="450" />
            <Resizing AllowColumnResize="true" ResizeGridOnColumnResize="true" AllowResizeToFit="true" />
        </ClientSettings>

        <FilterMenu RenderMode="Lightweight"></FilterMenu>

        <HeaderContextMenu RenderMode="Lightweight"></HeaderContextMenu>
    </telerik:RadGrid>






    <asp:SqlDataSource ID="SqlIndicador" runat="server" ConnectionString="<%$ ConnectionStrings:IndicadorConnectionString %>"
        SelectCommand="SELECT pIndicadorId,  descripcionIndicador, ponderacion, indicadorMinimo,indicadorDeseable, t.TipoId,tipo,area FROM [PlantillaIndicador] as i inner join TipoIndicador as t on t.tipoId = i.tipoId  where area = @area and estatus = 1"
        InsertCommand="insertPlantllaIndicador" InsertCommandType="StoredProcedure" OnInserting="SqlIndicador_Inserting"
        UpdateCommand="updatePlantllaIndicador" UpdateCommandType="StoredProcedure" OnUpdating="SqlIndicador_Updating"
        DeleteCommand="update PlantillaIndicador set estatus = 0  where pIndicadorId = @pIndicadorId " DeleteCommandType="Text">
        <InsertParameters>
            <asp:Parameter Name="descripcionIndicador" Type="String"></asp:Parameter>
            <asp:Parameter Name="ponderacion" Type="Decimal"></asp:Parameter>
            <asp:Parameter Name="indicadorMinimo" Type="Decimal"></asp:Parameter>
            <asp:Parameter Name="indicadorDeseable" Type="Decimal"></asp:Parameter>
            <asp:Parameter Name="Tipoid" Type="Int16"></asp:Parameter>
            <asp:ControlParameter Name="area" ControlID="hdnArea" PropertyName="Value" />
        </InsertParameters>

        <UpdateParameters>
            <asp:Parameter Name="descripcionIndicador" Type="String"></asp:Parameter>
            <asp:Parameter Name="ponderacion" Type="Decimal"></asp:Parameter>
            <asp:Parameter Name="indicadorMinimo" Type="Decimal"></asp:Parameter>
            <asp:Parameter Name="indicadorDeseable" Type="Decimal"></asp:Parameter>
            <asp:Parameter Name="Tipoid" Type="Int16"></asp:Parameter>
            <asp:Parameter Name="pIndicadorId" Type="Int32"></asp:Parameter>

        </UpdateParameters>

        <DeleteParameters>
            <asp:Parameter Name="pIndicadorId" Type="Int32"></asp:Parameter>
        </DeleteParameters>


        <SelectParameters>
            <asp:ControlParameter Name="area" ControlID="hdnArea" PropertyName="Value" />
        </SelectParameters>


    </asp:SqlDataSource>


    <asp:SqlDataSource ID="SqlTipo" runat="server" ConnectionString="<%$ ConnectionStrings:IndicadorConnectionString %>"
        SelectCommand="select * from TipoIndicador  order by tipo  "></asp:SqlDataSource>



    <%--    <asp:SqlDataSource ID="sqlOrden" runat="server" ConnectionString="<%$ ConnectionStrings:IndicadorConnectionString %>"
        SelectCommand="select OrdenId, Orden from ordenamiento  order by orden  "></asp:SqlDataSource>--%>

    <asp:HiddenField ID="hdnArea" runat="server" />
    <asp:HiddenField ID="hdnProyecto" runat="server" />
    <asp:HiddenField ID="hdnminimo" runat="server" />
    <asp:HiddenField ID="hdndeseable" runat="server" />
    <asp:HiddenField ID="hdnCorreo" runat="server" />


</asp:Content>
