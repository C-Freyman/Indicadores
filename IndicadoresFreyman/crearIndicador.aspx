<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="crearIndicador.aspx.cs" Inherits="IndicadoresFreyman.crearIndicador" LCID="2058" %>

<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        li.rlbItem .rlbText {
            color: red;
        }

        .message {
            line-height: 37px;
        }

        .RadGrid .rgRow,
        .RadGrid .rgAltRow {
            height: 30px;
        }

        .RadGrid_Silk .rgRow,
        .RadGrid_Silk .rgAltRow,
        .RadGrid_Glow .rgRow,
        .RadGrid_Glow .rgAltRow {
            height: 36px;
        }

        .RadGrid_MetroTouch .rgRow,
        .RadGrid_MetroTouch .rgAltRow,
        .RadGrid_BlackMetroTouch .rgRow,
        .RadGrid_BlackMetroTouch .rgAltRow {
            height: 46px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <telerik:RadSkinManager ID="RadSkinManager1" runat="server" ShowChooser="true" />
    <%-- <telerik:MessageBox ID="InformationBox1" runat="server" Type="Info" Icon="Info">
        <p>
            Click on a cell/row to place it in edit mode. Use the Save changes or Cancel changes buttons to process/discard all changes at once.
        </p>
    </telerik:MessageBox>--%>
    <telerik:RadAjaxManager runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="radIndicador">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="radIndicador" LoadingPanelID="RadAjaxLoadingPanel1" />
                    <telerik:AjaxUpdatedControl ControlID="SavedChangesList" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="ConfigurationPanel1">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="radIndicador" LoadingPanelID="RadAjaxLoadingPanel1" />
                    <telerik:AjaxUpdatedControl ControlID="ConfigurationPanel1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>
    <telerik:RadAjaxLoadingPanel runat="server" ID="RadAjaxLoadingPanel1"></telerik:RadAjaxLoadingPanel>
    <telerik:RadFormDecorator RenderMode="Lightweight" ID="RadFormDecorator1" runat="server" DecorationZoneID="demo" DecoratedControls="All" EnableRoundedCorners="false" />
    <div id="demo" class="demo-container no-bg">
        <telerik:RadListBox RenderMode="Lightweight" runat="server" ID="SavedChangesList" Width="600px" Height="200px" Visible="false"></telerik:RadListBox>
        <telerik:RadGrid RenderMode="Lightweight" ID="radIndicador" GridLines="None" runat="server" AllowAutomaticDeletes="True"
            AllowAutomaticInserts="True" PageSize="10" OnItemDeleted="radIndicador_ItemDeleted" OnItemInserted="radIndicador_ItemInserted"
            OnItemUpdated="radIndicador_ItemUpdated" OnPreRender="radIndicador_PreRender" AllowAutomaticUpdates="False" AllowPaging="True"
            AutoGenerateColumns="False" OnBatchEditCommand="radIndicador_BatchEditCommand"  DataSourceID="SqlIndicador" OnItemCommand ="radIndicador_ItemCommand">
            <MasterTableView CommandItemDisplay="TopAndBottom" DataKeyNames="pIndicadorId"
                DataSourceID="SqlIndicador" HorizontalAlign="NotSet" EditMode="Batch" AutoGenerateColumns="False">
                <BatchEditingSettings EditType="Cell"  SaveAllHierarchyLevels="true" HighlightDeletedRows="true" OpenEditingEvent="DblClick"   />
               
                <SortExpressions>
                    <telerik:GridSortExpression FieldName="pIndicadorId" SortOrder="Descending" />
                </SortExpressions>
                <Columns>

                  

                     <telerik:GridTemplateColumn HeaderText="Tipo" HeaderStyle-Width="150px" UniqueName="Tipoid" DataField="Tipoid">
                        <ItemTemplate>
                            <%# Eval("Tipo") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <telerik:RadDropDownList RenderMode="Lightweight" runat="server" ID="ddlTipo" DataValueField="Tipoid"
                                DataTextField="tipo" DataSourceID="SqlTipo">
                            </telerik:RadDropDownList>
                        </EditItemTemplate>
                    </telerik:GridTemplateColumn>

<%--                    <telerik:GridDropDownColumn UniqueName="AccessLevelID" ListDataMember="AccessLevel"
  SortExpression="AccessLevelID" ListTextField="Description" ListValueField="DDL_AccessLevelID"
  HeaderText="AccessLevelID" DataField="GRID_AccessLevelID" />--%>

                <%--    <telerik:GridDropDownColumn HeaderText="Tipo" HeaderStyle-Width="150px" UniqueName="Tipoid" DataField="Tipoid" 
                        DataSourceID ="SqlTipo"  ListTextField="tipo"
                     
                    </telerik:GridDropDownColumn>--%>

                  

                    <telerik:GridBoundColumn DataField="descripcionIndicador" HeaderStyle-Width="210px" HeaderText="Inidicador" SortExpression="descripcionIndicador"
                        UniqueName="descripcionIndicador">
                        <ColumnValidationSettings EnableRequiredFieldValidation="true">
                            <RequiredFieldValidator ForeColor="Red" Text="*Indicador requerido" Display="Dynamic">
                            </RequiredFieldValidator>
                        </ColumnValidationSettings>
                    </telerik:GridBoundColumn>

                     <telerik:GridBoundColumn DataField="ponderacion" HeaderStyle-Width="80px" HeaderText="Ponderación" SortExpression="Ponderacion"
                        UniqueName="Ponderacion">
                        <ColumnValidationSettings EnableRequiredFieldValidation="true">
                            <RequiredFieldValidator ForeColor="Red" Text="*Indicador ponderación" Display="Dynamic">
                            </RequiredFieldValidator>
                        </ColumnValidationSettings>
                    </telerik:GridBoundColumn>
                   
                    
                    <telerik:GridBoundColumn HeaderText="Indicador Minimo" HeaderStyle-Width="80px" SortExpression="indicadorMinimo" UniqueName="indicadorMinimo"
                        DataField="indicadorMinimo">
                        <ColumnValidationSettings EnableRequiredFieldValidation="true">
                            <RequiredFieldValidator ForeColor="Red" Text="*Indicador Minimo" Display="Dynamic">
                            </RequiredFieldValidator>
                        </ColumnValidationSettings>
                    </telerik:GridBoundColumn>

                    
                    <telerik:GridBoundColumn HeaderText="Indicador Deseable" HeaderStyle-Width="80px" SortExpression="indicadorDeseable" UniqueName="indicadorDeseable"
                        DataField="indicadorDeseable">
                        <ColumnValidationSettings EnableRequiredFieldValidation="true">
                            <RequiredFieldValidator ForeColor="Red" Text="Indicador deseable" Display="Dynamic">
                            </RequiredFieldValidator>
                        </ColumnValidationSettings>
                    </telerik:GridBoundColumn>

                    <%--<telerik:GridTemplateColumn HeaderText="Indicador Deseable" HeaderStyle-Width="80px" SortExpression="indicadorDeseable" UniqueName="indicadorDeseable"
                        DataField="indicadorDeseable">
                        <ItemTemplate>
                            <asp:Label runat="server" ID="lblindicadorDeseable" Text='<%# Eval("indicadorDeseable") %>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <span>
                                <telerik:RadNumericTextBox RenderMode="Lightweight" Width="55px" runat="server" ID="tbindicadorDeseable">
                                </telerik:RadNumericTextBox>
                                <span style="color: Red">
                                    <asp:RequiredFieldValidator ID="RequiredFieldindicadorDeseable"
                                        ControlToValidate="tbindicadorDeseable" ErrorMessage="*Required" runat="server" Display="Dynamic">
                                    </asp:RequiredFieldValidator>
                                </span>
                            </span>
                        </EditItemTemplate>
                    </telerik:GridTemplateColumn>--%>
                    <telerik:GridButtonColumn ConfirmText="Delete this product?" ConfirmDialogType="RadWindow"
                        ConfirmTitle="Delete" HeaderText="Delete" HeaderStyle-Width="50px"
                        CommandName="Delete" Text="Delete" UniqueName="DeleteColumn">
                    </telerik:GridButtonColumn>
                </Columns>
            </MasterTableView>
            <ClientSettings AllowKeyboardNavigation="true"></ClientSettings>
        </telerik:RadGrid>
        <asp:SqlDataSource ID="SqlIndicador" runat="server" ConnectionString="<%$ ConnectionStrings:IndicadorConnectionString %>"
            SelectCommand="SELECT pIndicadorId,  descripcionIndicador, ponderacion, indicadorMinimo,indicadorDeseable, Tipo,area FROM [PlantillaIndicador] as i inner join TipoIndicador as t on t.tipoId = i.tipoId  where area = 1 "
            InsertCommand ="insertPlantllaIndicador" InsertCommandType ="StoredProcedure"
             UpdateCommand ="updatePlantllaIndicador" UpdateCommandType ="StoredProcedure" OnUpdating ="SqlIndicador_Updating"
           >
           

            <InsertParameters>
                 <asp:Parameter Name="descripcionIndicador" Type="String"></asp:Parameter>       
                 <asp:Parameter Name="ponderacion" Type="Decimal"></asp:Parameter> 
                 <asp:Parameter Name="indicadorMinimo" Type="Decimal"></asp:Parameter>
                 <asp:Parameter Name="indicadorDeseable" Type="Decimal"></asp:Parameter>
                 <asp:Parameter Name="Tipoid" Type="Int16"></asp:Parameter>
                          

            </InsertParameters>

            <UpdateParameters>      
                 <asp:Parameter Name="descripcionIndicador" Type="String"></asp:Parameter>       
                 <asp:Parameter Name="ponderacion" Type="Decimal"></asp:Parameter> 
                 <asp:Parameter Name="indicadorMinimo" Type="Decimal"></asp:Parameter>
                 <asp:Parameter Name="indicadorDeseable" Type="Decimal"></asp:Parameter>
                 <asp:Parameter Name="Tipoid" Type="Int16"></asp:Parameter>
                 <asp:Parameter Name="pIndicadorId" Type="Int32"></asp:Parameter>
            </UpdateParameters>



        </asp:SqlDataSource>


        <asp:SqlDataSource ID="SqlTipo" runat="server" ConnectionString="<%$ ConnectionStrings:IndicadorConnectionString %>"
            SelectCommand="select * from TipoIndicador  order by tipo  "></asp:SqlDataSource>
       
        
        <asp:HiddenField ID="hdnArea" runat="server" />
         <asp:HiddenField ID="hdnProyecto" runat="server" />
    </div>

</asp:Content>
