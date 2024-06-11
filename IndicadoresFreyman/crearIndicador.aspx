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


    <script type="text/javascript">
        function soloNumeros(e) {
            var key = window.Event ? e.which : e.keyCode
            return (key >= 48 && key <= 57)
        }


        function validaVacio(valor) {
            valor = valor.replace("&nbsp;", "");
            valor = valor == undefined ? "" : valor;
            if (!valor || 0 === valor.trim().length) {
                return true;
            }
            else {
                return false;
            }
        }

        function validarEsrequerido(valEl, args) {
            args.IsValid = validaVacio(args.Value);
        }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">




  

    <telerik:RadSkinManager ID="RadSkinManager1" runat="server" ShowChooser="true" />
    

    <p id="divMsgs" runat="server">
        <asp:Label ID="Label1" runat="server" EnableViewState="False" Font-Bold="True" ForeColor="#FF8080"> </asp:Label>
        <asp:Label ID="Label2" runat="server" EnableViewState="False" Font-Bold="True" ForeColor="#00C000"> </asp:Label>
    </p>

    <telerik:RadWindowManager RenderMode="Lightweight" ID="RadWindowManager1" runat="server" EnableShadow="true">
    </telerik:RadWindowManager>

    <asp:Button ID="btnguardar" runat="server" Text="Guardar"  OnClick="btnguardar_Click"/>

    <telerik:RadAjaxManager runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="radIndicador">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="radIndicador" LoadingPanelID="RadAjaxLoadingPanel1" />
                    <telerik:AjaxUpdatedControl ControlID="SavedChangesList" />
                    <telerik:AjaxUpdatedControl ControlID="divMsgs" />

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
    <%--<telerik:RadFormDecorator RenderMode="Lightweight" ID="RadFormDecorator1" runat="server" DecorationZoneID="demo" DecoratedControls="All" EnableRoundedCorners="false" />--%>
    <div id="demo" class="demo-container no-bg">
        <telerik:RadListBox RenderMode="Lightweight" runat="server" ID="SavedChangesList" Width="600px" Height="200px" Visible="false"></telerik:RadListBox>
        <asp:Button runat="server" Text="Button"></asp:Button>
        <telerik:RadGrid RenderMode="Lightweight" ID="radIndicador" GridLines="None" runat="server" AllowAutomaticDeletes="True" Culture="bg-BG"
            AllowAutomaticInserts="True" PageSize="10" OnItemDeleted="radIndicador_ItemDeleted" OnItemInserted="radIndicador_ItemInserted"
            OnItemUpdated="radIndicador_ItemUpdated" OnPreRender="radIndicador_PreRender" AllowAutomaticUpdates="True" AllowPaging="True" OnItemCreated ="radIndicador_ItemCreated"
            AutoGenerateColumns="False" DataSourceID="SqlIndicador" OnItemCommand="radIndicador_ItemCommand" OnInsertCommand="radIndicador_InsertCommand"          
            Width="75%" Style="margin: 0px auto" >
            <MasterTableView CommandItemDisplay="TopAndBottom" DataKeyNames="pIndicadorId"
                DataSourceID="SqlIndicador" HorizontalAlign="NotSet" EditMode="Batch" AutoGenerateColumns="False">
                <BatchEditingSettings EditType="Cell" SaveAllHierarchyLevels="true" HighlightDeletedRows="true" OpenEditingEvent="DblClick" />
                <SortExpressions>
                    <telerik:GridSortExpression FieldName="pIndicadorId" SortOrder="Descending" />
                </SortExpressions>
                <Columns>
                    <telerik:GridTemplateColumn HeaderText="Tipo" HeaderStyle-Width="150px" UniqueName="Tipoid" DataField="Tipoid">
                        <ItemTemplate>
                            <%# Eval("Tipo") %>
                        </ItemTemplate>
                        <HeaderStyle Width="150px" />
                        <ItemStyle Width="150px" />
                        <EditItemTemplate>
                            <telerik:RadDropDownList RenderMode="Lightweight" runat="server" ID="ddlTipo" DataValueField="Tipoid"
                                DataTextField="tipo" DataSourceID="SqlTipo" Width="150px">
                            </telerik:RadDropDownList>
                        </EditItemTemplate>
                    </telerik:GridTemplateColumn>

                    <telerik:GridBoundColumn DataField="descripcionIndicador" HeaderStyle-Width="310px" HeaderText="Inidicador" SortExpression="descripcionIndicador"
                        UniqueName="descripcionIndicador">
                      <%--  <ColumnValidationSettings EnableRequiredFieldValidation="true">
                            <RequiredFieldValidator ForeColor="Red" Text="*Indicador requerido" Display="Dynamic">
                            </RequiredFieldValidator>
                        </ColumnValidationSettings>--%>
                        <HeaderStyle Width="410px" />
                        <ItemStyle Width="410px" />
                    </telerik:GridBoundColumn>




                    <telerik:GridNumericColumn DataField="ponderacion" HeaderStyle-Width="80px" HeaderText="Ponderación"
                        SortExpression="ponderacion" UniqueName="ponderacion" DataFormatString="{0:N0}">
                    </telerik:GridNumericColumn>

                    <telerik:GridNumericColumn DataField="indicadorMinimo" HeaderStyle-Width="80px" HeaderText="Indicador Minimo"
                        SortExpression="indicadorMinimo" UniqueName="indicadorMinimo" DataFormatString="{0:N0}">
                    </telerik:GridNumericColumn>

                    <telerik:GridNumericColumn DataField="indicadorDeseable" HeaderStyle-Width="80px" HeaderText="Indicador Deseable"
                        SortExpression="indicadorDeseable" UniqueName="indicadorDeseable" DataFormatString="{0:N0}">
                    </telerik:GridNumericColumn>


                    <telerik:GridButtonColumn HeaderText="Eliminar" CommandName="Delete" Text="Delete" UniqueName="column" ConfirmText="Deseas borrar el proyecto?" ConfirmDialogType="RadWindow">
                        <ItemStyle Width="80px" />
                        <HeaderStyle Width="80px" />
                    </telerik:GridButtonColumn>

                </Columns>
            </MasterTableView>
            <ClientSettings AllowKeyboardNavigation="true">
              <%--  <ClientEvents OnBatchEditCellValueChanged="BatchEditCellValueChanged"/>--%>
            </ClientSettings>
        </telerik:RadGrid>
        <asp:SqlDataSource ID="SqlIndicador" runat="server" ConnectionString="<%$ ConnectionStrings:IndicadorConnectionString %>"
            SelectCommand="SELECT pIndicadorId,  descripcionIndicador, ponderacion, indicadorMinimo,indicadorDeseable, Tipo,area FROM [PlantillaIndicador] as i inner join TipoIndicador as t on t.tipoId = i.tipoId  where area = 1 "
            InsertCommand="insertPlantllaIndicador" InsertCommandType="StoredProcedure"
            UpdateCommand="updatePlantllaIndicador" UpdateCommandType="StoredProcedure" OnUpdating="SqlIndicador_Updating"
            DeleteCommand="delete from PlantillaIndicador where pIndicadorId = @pIndicadorId " DeleteCommandType="Text">
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

            <DeleteParameters>
                <asp:Parameter Name="pIndicadorId" Type="Int32"></asp:Parameter>
            </DeleteParameters>


        </asp:SqlDataSource>


        <asp:SqlDataSource ID="SqlTipo" runat="server" ConnectionString="<%$ ConnectionStrings:IndicadorConnectionString %>"
            SelectCommand="select * from TipoIndicador  order by tipo  "></asp:SqlDataSource>


        <asp:HiddenField ID="hdnArea" runat="server" />
        <asp:HiddenField ID="hdnProyecto" runat="server" />

    </div>
    <div class="demo-container no-bg">&nbsp;</div>

  





</asp:Content>
