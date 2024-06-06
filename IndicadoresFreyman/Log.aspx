<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Log.aspx.cs" Inherits="IndicadoresFreyman.Log" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
        <style>
          body {
            background: rgba(203,204,126,1);
            background: -moz-linear-gradient(45deg, rgba(203,204,126,1) 0%, rgba(117,189,209,1) 28%, rgba(16,99,122,1) 100%);
            background: -webkit-gradient(left bottom, right top, color-stop(0%, rgba(203,204,126,1)), color-stop(28%, rgba(117,189,209,1)), color-stop(100%, rgba(16,99,122,1)));
            background: -webkit-linear-gradient(45deg, rgba(203,204,126,1) 0%, rgba(117,189,209,1) 28%, rgba(16,99,122,1) 100%);
            background: -o-linear-gradient(45deg, rgba(203,204,126,1) 0%, rgba(117,189,209,1) 28%, rgba(16,99,122,1) 100%);
            background: -ms-linear-gradient(45deg, rgba(203,204,126,1) 0%, rgba(117,189,209,1) 28%, rgba(16,99,122,1) 100%);
            background: linear-gradient(45deg, rgba(203,204,126,1) 0%, rgba(117,189,209,1) 28%, rgba(16,99,122,1) 100%);
            filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#cbcc7e', endColorstr='#10637a', GradientType=1 );
            height: 100%; /*Tambien al Body 100%*/
            margin: 0;
            background-repeat: no-repeat; /*Evita que se repita*/
            background-attachment: fixed;
           
        }

        .contenedor {
            margin: 0 auto;
            background-color: white;
            background: rgba(255,255,255, 0.3);
            /*opacity :0.5;*/
            height: 300px;
            width: 450px;
            margin-top: 100px;
            border-radius: 23px 23px 23px 23px;
            -moz-border-radius: 23px 23px 23px 23px;
            -webkit-border-radius: 23px 23px 23px 23px;
            border: 0px solid #000000;
        }

        .btn {
            width: 80%;
            background-color: rgba(22,178,225, 0.9);
            color: white;
            text-shadow: 3px 5px 5px gray;
            height: 50px;
            border: none;
            /*font-weight:bold ;*/
            font-size: 15pt;
            margin: 10px;
            border-radius: 10px 10px 10px 10px;
            -moz-border-radius: 10px 10px 10px 10px;
            -webkit-border-radius: 10px 10px 10px 10px;
            border: 0px solid #000000;
            border: 1px solid silver;
        }

        .txt {
            height: 50px;
            width: 80%;
            color: Gray;
            border: none;
            margin: 10px;
            font-size: 15pt;
            border-radius: 10px 10px 10px 10px;
            -moz-border-radius: 10px 10px 10px 10px;
            -webkit-border-radius: 10px 10px 10px 10px;
            border: 0px solid #000000;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
         <div style="text-align: center">
            <div class="contenedor ">
                <asp:Image ID="img" runat="server" ImageUrl="usuario.png" Style="width: 100px; margin-top: -50px" /><br />
                <%--  <asp:TextBox ID="txtUsuario" runat="server" CssClass="txt" ></asp:TextBox>
                    <asp:TextBox ID="TextBox1" runat="server" CssClass="txt"></asp:TextBox>--%>
                <input id="txtUsuario" type="text" runat="server" class="txt" placeholder="   Usuario" />
                <input type="password" id="txtContraseña" runat="server" class="txt" placeholder="   Contraseña" />
                <asp:Button ID="BtnIngresar" runat="server" Text="INGRESAR" CssClass="btn" OnClick ="BtnIngresar_Click" />
            </div>
        </div>
    </form>
</body>
</html>
