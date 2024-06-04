<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Paramentros.aspx.cs" Inherits="IndicadoresFreyman.Paramentros" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <p id="divMsgs" runat="server">
        <asp:Label ID="Label1" runat="server" EnableViewState="False" Font-Bold="True" ForeColor="#FF8080"> </asp:Label>
        <asp:Label ID="Label2" runat="server" EnableViewState="False" Font-Bold="True" ForeColor="#00C000"> </asp:Label>
    </p>

     <telerik:RadWindowManager RenderMode="Lightweight" ID="RadWindowManager1" runat="server" EnableShadow="true"  Localization-OK ="Si" Localization-Cancel ="No"> 
    </telerik:RadWindowManager>

    <telerik:RadGrid RenderMode="Lightweight" ID="radGrParamentros" runat="server" CssClass="RadGrid"  AllowPaging="true" PageSize="200"
        AllowSorting="True" AutoGenerateColumns="False" AllowFilteringByColumn="True"
        EnableHeaderContextFilterMenu="true"
        FilterDelay="4000" ShowFilterIcon="false"
        ShowStatusBar="True" AllowAutomaticDeletes="True" AllowAutomaticInserts="True"
        AllowAutomaticUpdates="True" DataSourceID="SqlIndicador" OnItemDeleted="radGrParamentros_ItemDeleted"
        OnItemInserted="radGrParamentros_ItemInserted" OnItemUpdated="radGrParamentros_ItemUpdated" OnItemCommand="radGrParamentros_ItemCommand"
        Culture="es-ES" Style="margin: 0px auto" Width="60%" AllowFiltering="true">

        <ExportSettings IgnorePaging="true" ExportOnlyData="true" FileName="Proyectos desarollo">
            <Excel Format="Xlsx" WorksheetName="Proyectos desarollo" DefaultCellAlignment="Left" />
        </ExportSettings>
        <GroupingSettings CaseSensitive="false"></GroupingSettings>       
        <MasterTableView EditMode="PopUp" CommandItemDisplay="Top" DataSourceID="SqlIndicador" DataKeyNames="parametroId" AllowFilteringByColumn="True">
            <CommandItemSettings ShowExportToWordButton="false" ShowExportToCsvButton="false" ShowAddNewRecordButton="true" ShowRefreshButton="true" ShowExportToExcelButton="true" />
            <RowIndicatorColumn ShowNoSortIcon="false"></RowIndicatorColumn>
             
            <Columns>

                <telerik:GridEditCommandColumn>
                    <ItemStyle Width="40px" />
                    <HeaderStyle Width="40px" />
                </telerik:GridEditCommandColumn>

                <telerik:GridBoundColumn UniqueName="parametro" HeaderText="Parametro" DataField="parametro" SortExpression="parametro"
                    FilterControlWidth="100%" AllowFiltering="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="false">
                    <ItemStyle Width="100px" />
                    <HeaderStyle Width="100px" Font-Bold="true" HorizontalAlign="Center" />
                </telerik:GridBoundColumn>

                <telerik:GridBoundColumn UniqueName="valor" HeaderText="Valor" DataField="Valor" SortExpression="Valor"
                    FilterControlWidth="100%" AllowFiltering="false" AutoPostBackOnFilter="false" CurrentFilterFunction="Contains" ShowFilterIcon="false">
                    <ItemStyle Width="100px" HorizontalAlign = "Center" />
                    <HeaderStyle Width="100px" Font-Bold="true" HorizontalAlign="Center" />
                </telerik:GridBoundColumn>
                


                  <telerik:GridButtonColumn HeaderText="Eliminar" CommandName="Delete" Text="Delete" UniqueName="column" ConfirmText="Deseas borrar el proyecto?" ConfirmDialogType="RadWindow">
                        <ItemStyle Width="80px" />
                        <HeaderStyle Width="80px" />
                    </telerik:GridButtonColumn>

            </Columns>
            <EditFormSettings EditFormType="Template">
                <EditColumn ShowNoSortIcon="False" UniqueName="EditCommandColumn1" FilterControlAltText="Filter EditCommandColumn1 column"></EditColumn>
                <FormTemplate>
                    <table id="Table2" cellspacing="2" cellpadding="1" border="0" rules="none"
                        style="border-collapse: collapse;">
                        <tr class="EditFormHeader">
                            <td colspan="2">
                                <b>Parametros</b>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table id="Table3">

                                   





                                    <tr>
                                        <td>Parametro:
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtparametro" runat="server" Text='<%# Bind("parametro") %>' TabIndex="2" Width="250px" >                                             
                                            </asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Parametro requerido" ControlToValidate="txtparametro" ForeColor="Red"></asp:RequiredFieldValidator>

                                        </td>
                                    </tr>


                                     <tr>
                                        <td>Valor:
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtvalor" runat="server" Text='<%# Bind("valor") %>' TabIndex="2" Width="250px" >                                             
                                            </asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Valor requerido" ControlToValidate="txtvalor" ForeColor="Red"></asp:RequiredFieldValidator>

                                        </td>
                                    </tr>


                                </table>

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
                                <asp:Button ID="btnUpdateParametro" Text='<%# (Container is GridEditFormInsertItem) ? "Insertar" : "Actualizar" %>'
                                    runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update" %>'></asp:Button>&nbsp;
                               <asp:Button ID="btnCanceParametro" Text="Cancelar" runat="server" CausesValidation="False"
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
        SelectCommand="SELECT parametroId, parametro, valor  FROM [parametros] where activo = 1"
        InsertCommand="insertParamentro" InsertCommandType="StoredProcedure" 
        UpdateCommand="updateParamentro" UpdateCommandType="StoredProcedure"
        DeleteCommand="deleteParamentro"  DeleteCommandType="StoredProcedure">
        <InsertParameters>
            <asp:Parameter Name="parametro" Type="String"></asp:Parameter>
            <asp:Parameter Name="valor" Type="String"></asp:Parameter>          
            
        </InsertParameters>

        <UpdateParameters>
            <asp:Parameter Name="parametro" Type="String"></asp:Parameter>
            <asp:Parameter Name="valor" Type="String"></asp:Parameter>   
            <asp:Parameter Name="parametroId" Type="Int32"></asp:Parameter>         
            
        </UpdateParameters>

        <DeleteParameters>
            <asp:Parameter Name="parametroId" Type="Int32"></asp:Parameter>       
        </DeleteParameters>


    </asp:SqlDataSource>


    

   
</asp:Content>
