<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Crear.aspx.cs" Inherits="IndicadoresFreyman.Crear" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script src="js/jquery-1.8.2.min.js"></script>
    <link href="css/bootstrap.css" rel="stylesheet" />
    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <script src="js/bootstrap.bundle.js"></script>
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
            width: 850px;
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

    <script type="text/javascript">

        function soloNumeros(e) {
            var key = window.Event ? e.which : e.keyCode

            var valido = (key >= 48 && key <= 57);
            return valido;
        }


        function marcalleno() {
            if ($(this).val() != '') {
                $(this).addClass("is-valid");
            } else {
                $(this).removeClass("is-valid");
            }
        }



        function validaFormulario() {
            var valido = true;
            $("[data-required]").each(function () {
                if ($(this).val() == '') {
                    $(this).removeClass("is-valid");
                    $(this).addClass("is-invalid");
                    valido = false;
                }
            });
            //if (valido) $('.bgLoad').css('display', 'block');
            return valido;
        }

        $(function () {
            //cambia clase de control lleno
            $(".form-control, .form-select").live("change", marcalleno);
            $(".form-control, .form-select").each(marcalleno);

        });


        function calculaTipo() {
            var minimo = parseInt(document.getElementById('txtindicadorMinimo').value) || 0;
            var deseable = parseInt(document.getElementById('txtindicadorDeseable').value) || 0;

            var mensaje = (minimo < deseable) ? 'Ascendente' : 'Descendente';
            mensaje = (minimo == 0 || deseable == 0) ? '  ' : mensaje;
            document.getElementById('dllOrden').onselect = mensaje;
        }


    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">





    <h2>Crear</h2>

    <div class="divCenter">
        <telerik:RadDropDownList RenderMode="Lightweight" ID="radEstatus" runat="server" OnSelectedIndexChanged="radEstatus_SelectedIndexChanged"
            DropDownHeight="80px" AutoPostBack="true"
            TabIndex="7" Width="250px">
        </telerik:RadDropDownList>
    </div>


    <telerik:RadGrid RenderMode="Lightweight" ID="radGridIndicador" runat="server" CssClass="RadGrid" AllowPaging="true" PageSize="200"
        AllowSorting="True" AutoGenerateColumns="False" AllowFilteringByColumn="True"
        EnableHeaderContextFilterMenu="true"
        FilterDelay="4000" ShowFilterIcon="false" OnNeedDataSource="radGridIndicador_NeedDataSource" OnPreRender="radGridIndicador_PreRender"
        ShowStatusBar="True" Width="85%"
        Culture="es-ES" Style="margin: 0px auto" AllowFiltering="true">

        <ExportSettings IgnorePaging="true" ExportOnlyData="true" FileName="Proyectos desarollo">
            <Excel Format="Xlsx" WorksheetName="Proyectos desarollo" DefaultCellAlignment="Left" />
        </ExportSettings>
        <GroupingSettings CaseSensitive="false"></GroupingSettings>

        <MasterTableView AllowFilteringByColumn="True" DataKeyNames="pIndicadorId" CommandItemDisplay="Top">



            <CommandItemSettings ShowAddNewRecordButton="false" />
            <CommandItemTemplate>

                <telerik:RadButton RenderMode="Lightweight" ID="btnAgregar" runat="server" Text="Agregar indicador"
                    ButtonType="StandardButton" UseSubmitBehavior="true" OnClick="btnAgregar_Click" />
                <%--<asp:Button ID="btnAgregar" runat="server" Text="Agregar indicador" OnClick="btnAgregar_Click" />--%>
            </CommandItemTemplate>

            <%--<SortExpressions>
                <telerik:GridSortExpression FieldName="pIndicadorId" SortOrder="Descending" />
            </SortExpressions>--%>
            <Columns>

                <telerik:GridTemplateColumn UniqueName="EditarColumn" HeaderText="" ShowFilterIcon="false" AllowFiltering="false" AutoPostBackOnFilter="false" CurrentFilterFunction="Contains">
                    <ItemTemplate>
                        <asp:Button ID="btnEditar" runat="server" BorderStyle="None" ForeColor="#0000ff" Font-Underline="true" value='<%# (Eval("pIndicadorId")).ToString() %>'
                            OnClick="btnEditar_Click" Width="45px" Style='<%# cargaimagenEditar()%>' />
                    </ItemTemplate>
                    <HeaderStyle Font-Bold="true" Width="25px" HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Left" Width="25px" CssClass="nowrap" />
                </telerik:GridTemplateColumn>

                <telerik:GridBoundColumn UniqueName="pIndicadorId" HeaderText="Id" DataField="pIndicadorId" SortExpression="pIndicadorId"
                    FilterControlWidth="100%" AllowFiltering="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="false">
                    <ItemStyle Width="50px" />
                    <HeaderStyle Width="50px" Font-Bold="true" HorizontalAlign="Center" />
                </telerik:GridBoundColumn>

                <telerik:GridBoundColumn UniqueName="tipo" HeaderText="Tipo" DataField="tipo" SortExpression="tipo"
                    FilterControlWidth="100%" AllowFiltering="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="false">
                    <ItemStyle Width="100px" />
                    <HeaderStyle Width="100px" Font-Bold="true" HorizontalAlign="Center" />
                </telerik:GridBoundColumn>

                <telerik:GridBoundColumn UniqueName="descripcionIndicador" HeaderText="Indicador" DataField="descripcionIndicador" SortExpression="descripcionIndicador"
                    FilterControlWidth="100%" AllowFiltering="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="false">
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
                        <%-- <asp:Button ID="btnEstus" runat="server" BorderStyle="None" ForeColor="#0000ff" Font-Underline="true" Value='<%# Eval("pIndicadorId") %>'
                            OnClick="btnEstatus_Click" Width="45px" Style='<%# cargaimagen(Eval("estatus").ToString())%>' />--%>

                        <telerik:RadImageButton  runat="server" ID="btnEstus" OnClick="btnEstatus_Click" Width="45px" Image-Url ="~/Imagenes/basura.PNG"  Value='<%# Eval("pIndicadorId")%>'  Style  ="border:none;  width:1em; height:1.5em;" CssClass="coverImage">
                            <ConfirmSettings ConfirmText="Deseas eliminar el indicador?" />  
                        </telerik:RadImageButton>
                    </ItemTemplate>
                    <HeaderStyle Font-Bold="true" Width="25px" HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Left" Width="25px" CssClass="nowrap" />
                </telerik:GridTemplateColumn>


                <Telerik:GridTemplateColumn UniqueName="colActiva" HeaderText="" ShowFilterIcon="false" AllowFiltering="false" AutoPostBackOnFilter="false" CurrentFilterFunction="Contains">
                    <ItemTemplate>
                        <%-- <asp:Button ID="btnEstus" runat="server" BorderStyle="None" ForeColor="#0000ff" Font-Underline="true" Value='<%# Eval("pIndicadorId") %>'
                            OnClick="btnEstatus_Click" Width="45px" Style='<%# cargaimagen(Eval("estatus").ToString())%>' />--%>

                        <telerik:RadImageButton  runat="server" ID="btnActiva" OnClick="btnActiva_Click" Width="45px" Image-Url ="~/Imagenes/paloma.PNG"  Value='<%# Eval("pIndicadorId")%>'  Style  ="border:none;  width:1em; height:1.5em;" CssClass="coverImage">
                            <ConfirmSettings ConfirmText="Deseas habilitar el indicador?" />  
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


    <asp:HiddenField ID="hdnArea" runat="server" />
    <asp:HiddenField ID="hdnCorreo" runat="server" />
    <asp:HiddenField ID="hdnIndicadorId" runat="server" />


    <asp:Panel ID="pnlEditar" runat="server" Visible="false">
        <%--   <div class="modal fade" id="mdlEditar" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-contenidos2">--%>
        <div class="modales" id="mdlencuesta" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
            <div class="modal-contenidos2" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalEditar">
                            <asp:Label ID="lbltiulo" runat="server" Text="" Font-Bold="true" Font-Size="Larger"></asp:Label>
                        </h5>
                        <asp:Label ID="lblguarda" runat="server" Text="" Visible=" false"></asp:Label>
                        <asp:Button ID="btnclose" runat="server" Text="X" Font-Size="Smaller" BorderStyle="None" BackColor="Transparent" class="close" data-dismiss="modal" aria-label="Close" OnClick="btncerrarMdl_Click" />
                    </div>
                    <div class="modal-body">
                        <table id="Table2" cellspacing="2" cellpadding="1" border="0" rules="none" style="border-collapse: collapse;">


                            <tr>
                                <td style="width: 150px">Tipo:
                                </td>
                                <td>
                                    <telerik:RadDropDownList RenderMode="Lightweight" ID="ddltipo" runat="server"  CssClass="form-select" data-required="1"
                                        DropDownHeight="80px"
                                        TabIndex="7" Width="200px">
                                    </telerik:RadDropDownList>
                                    <div class="invalid-feedback">
                                        indicador requerido
                                    </div>
                                    <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ErrorMessage="Tipo requerido" ControlToValidate="ddltipo" ForeColor="Red"></asp:RequiredFieldValidator>--%>
                                </td>
                                <td colspan="2"></td>
                            </tr>






                            <tr>
                                <td style="width: 150px">Indicador:
                                </td>
                                <td colspan="2">
                                    <asp:TextBox ID="txtdescripcionIndicador" runat="server" Text='<%# Bind("descripcionIndicador") %>' TabIndex="2" Width="200px" TextMode="MultiLine" Style="width: 700px; height: 60px" CssClass="form-control" autocomplete="off" MaxLength="10" data-required="1">                                             
                                    </asp:TextBox>
                                    <div class="invalid-feedback">
                                        indicador requerido
                                    </div>
                                </td>

                            </tr>
                        </table>
                        <br />
                        <table id="Table3" cellspacing="2" cellpadding="1" border="0" rules="none" style="border-collapse: collapse;">
                            <tr>
                                <td style="width: 110px">Ponderación:
                                </td>
                                <td>
                                    <asp:TextBox ID="txtponderacion" runat="server" Text='<%# Bind("ponderacion") %>' TabIndex="2" Width="200px" onKeyPress="return soloNumeros(event)" onChange="calculaTipo()" CssClass="form-control" autocomplete="off" MaxLength="10" data-required="1">
                                    </asp:TextBox>
                                    <div class="invalid-feedback">
                                        Ponderación requerido
                                    </div>
                                </td>

                                <td style="width: 130px">&nbsp;  &nbsp;   Indicador Mínimo:
                                </td>
                                <td>
                                    <asp:TextBox ID="txtindicadorMinimo" ClientIDMode="Static" runat="server" Text='<%# Bind("indicadorMinimo") %>' TabIndex="2" Width="250px" onKeyPress="return soloNumeros(event)" onChange="calculaTipo()" CssClass="form-control" autocomplete="off" MaxLength="10" data-required="1"  >
                                    </asp:TextBox>
                                    <div class="invalid-feedback">
                                        indicador Minimo requerido
                                    </div>


                                </td>
                            </tr>
                            <tr>
                                <td colspan="2"></td>

                                <td style="width: 130px">&nbsp;  &nbsp;   Indicador Deseable:
                                </td>
                                <td>
                                    <asp:TextBox ID="txtindicadorDeseable" ClientIDMode="Static" runat="server" Text='<%# Bind("indicadorDeseable") %>' TabIndex="2" Width="200px" onKeyPress="return soloNumeros(event)" onBlur="calculaTipo()" CssClass="form-control" autocomplete="off" MaxLength="10" data-required="1">
                                    </asp:TextBox>
                                   <%-- <asp:Label ID="lblordrnamiento" runat="server" Text="Label"></asp:Label>--%>
                                    <div class="invalid-feedback">
                                        indicador Deseable requerido
                                    </div>


                                </td>
                            </tr>
                           <%-- <tr>
                                <td colspan="2"></td>
                                <td style="width: 150px">&nbsp;  &nbsp;   Ordenamiento</td>
                                <td>
                                    <%--<telerik:RadDropDownList RenderMode="Lightweight" ID="dllOrden" runat="server"
                                        DropDownHeight="80px"
                                        Width="200px">
                                    </telerik:RadDropDownList>
                                </td>
                            </tr>--%>
                        </table>

                    </div>
                    <div class="modal-footer">
                        <asp:Button ID="btnGuardaEditar" runat="server" Text="Guardar" OnClick="btnGuardaEditar_Click" OnClientClick="return validaFormulario()" />
                        <asp:Button ID="btncerrarMdl" runat="server" OnClick="btncerrarMdl_Click" Text="Cerrar" />

                    </div>
                </div>
            </div>
        </div>
    </asp:Panel>

    <telerik:RadWindowManager RenderMode="Lightweight" ID="RadWindowManager1" runat="server" EnableShadow="true" Localization-OK="Aceptar" Localization-Cancel="No">
        <Windows>
            <telerik:RadWindow RenderMode="Lightweight" runat="server" ID="RadWindow1">
            </telerik:RadWindow>
        </Windows>
    </telerik:RadWindowManager>

</asp:Content>
