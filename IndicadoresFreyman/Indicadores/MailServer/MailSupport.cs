using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IndicadoresFreyman.Indicadores.MailServer
{
    public class MailSupport : MasterServer
    {
        public MailSupport()
        {
            mail = "webmaster@lofasociados.com.mx";
            password = "P4$$w0rd.Fr3y";
            host = "smtp.gmail.com";
            puerto = 587;
            ssl = true;
            InitializeSmtpClient();
        }
    }
}