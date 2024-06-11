<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="asignaIndicadores.aspx.cs" Inherits="IndicadoresFreyman.asignaIndicadores" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Button ID="Button1" runat="server" Text="Button"  OnClick="Button1_Click"/>
           
            <telerik:RadGrid RenderMode="Lightweight" ID="radIndicador" GridLines="None" runat="server" AllowAutomaticDeletes="True"
                AllowAutomaticInserts="True" PageSize="50" Culture="bg-BG" OnNeedDataSource ="radIndicador_NeedDataSource"
                 AllowAutomaticUpdates="True" AllowPaging="True"
                AutoGenerateColumns="False" 
                Width="75%" Style="margin: 0px auto;" >
               
                <MasterTableView     CommandItemDisplay="TopAndBottom" DataKeyNames="pIndicadorId" TableLayout="Fixed"
                     HorizontalAlign="NotSet" EditMode="Batch" AutoGenerateColumns="False" ShowFooter="true" >
                    <%-- <BatchEditingSettings EditType="Cell"   SaveAllHierarchyLevels="true" HighlightDeletedRows="true" OpenEditingEvent="DblClick"  /> --%>
                    <BatchEditingSettings EditType="Cell" HighlightDeletedRows="true"  OpenEditingEvent="MouseDown"/>
                    <CommandItemSettings ShowAddNewRecordButton="false" />                    
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

                   <%--     <telerik:GridBoundColumn DataField="ponderacion" HeaderStyle-Width="80px" HeaderText="Ponderación" SortExpression="Ponderacion" ColumnGroupName="Editables"
                            UniqueName="Ponderacion" DataFormatString="{0:N0}"   >
                            <ColumnValidationSettings EnableRequiredFieldValidation="true">
                                <RequiredFieldValidator ForeColor="Red" Text="*Indicador ponderación" Display="Dynamic">
                                </RequiredFieldValidator>
                            </ColumnValidationSettings>
                            <HeaderStyle Width="150px" />
                            <ItemStyle Width="150px" />
                        </telerik:GridBoundColumn>--%>


                        <telerik:GridTemplateColumn HeaderText="UnitPrice" HeaderStyle-Width="80px" SortExpression="UnitPrice" UniqueName="TemplateColumn"
                        DataField="UnitPrice">
                        <ItemTemplate>
                            <asp:Label runat="server" ID="lblUnitPrice" Text='<%# Eval("ponderacion") %>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <span>
                              <%--  <telerik:RadNumericTextBox RenderMode="Lightweight" Width="55px" runat="server" ID="tbUnitPrice">
                                </telerik:RadNumericTextBox>--%>
                                <asp:TextBox ID="txtponderacion" runat="server" ></asp:TextBox>
                                <%--<span style="color: Red">
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1"
                                        ControlToValidate="tbUnitPrice" ErrorMessage="*Required" runat="server" Display="Dynamic">
                                    </asp:RequiredFieldValidator>
                                </span>--%>
                            </span>
                        </EditItemTemplate>
                    </telerik:GridTemplateColumn>


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

                   <%--      <telerik:GridCheckBoxColumn DataField="activo" HeaderStyle-Width="80px" HeaderText="Activo" SortExpression="activo" HeaderStyle-HorizontalAlign="Center"
                            UniqueName="activo">
                        </telerik:GridCheckBoxColumn>--%>


                        <telerik:GridTemplateColumn HeaderText="Asignado" HeaderStyle-Width="150px" UniqueName="activo" DataField="activo"  >
                            <HeaderStyle Width="150px" />
                            <ItemTemplate>
                                <asp:CheckBox ID="chkAsignado" runat="server" AutoPostBack="true" OnCheckedChanged="chkAsignado_CheckedChanged" Checked='<%# Eval("activo") %>' />
                            </ItemTemplate>
                       <%--     <EditItemTemplate>
                                    <asp:CheckBox ID="chkAsignadoEdit" runat="server" Checked='<%# Bind("activo") %>' OnCheckedChanged="chkAsignado_CheckedChanged" />
                            </EditItemTemplate>--%>
                        </telerik:GridTemplateColumn>


                      

                        <%--  <telerik:GridButtonColumn HeaderText="Eliminar" CommandName="Delete" Text="Delete" UniqueName="column" ConfirmText="Deseas borrar el proyecto?" ConfirmDialogType="RadWindow" >
                                <ItemStyle Width="80px" />
                                <HeaderStyle Width="80px" />
                            </telerik:GridButtonColumn>--%>
                    </Columns>
                </MasterTableView>
                <ClientSettings AllowKeyboardNavigation="true">
                </ClientSettings>
            </telerik:RadGrid>
      

    


    <asp:SqlDataSource ID="SqlTipo" runat="server" ConnectionString="<%$ ConnectionStrings:IndicadorConnectionString %>"
        SelectCommand="select * from TipoIndicador  order by tipo  "></asp:SqlDataSource>

    <asp:HiddenField ID="htntotal" runat="server" Value="0" />
    <asp:HiddenField ID="hdneditar" runat="server" Value="0" />
    <asp:HiddenField ID="hdnArea" runat="server" />
    <asp:HiddenField ID="hdnEmpleado" runat="server" />
</asp:Content>
