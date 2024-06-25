using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Web;

namespace IndicadoresFreyman.Indicadores.MailServer
{
    public abstract class MasterServer
    {
        private SmtpClient smtpClient;
        protected string mail { get; set; }
        protected string password { get; set; }
        protected string host { get; set; }
        protected int puerto { get; set; }
        protected bool ssl { get; set; }
        protected void InitializeSmtpClient()// inicializa el cliente smtp
        {
            smtpClient = new SmtpClient();
            smtpClient.Credentials = new NetworkCredential(mail, password);
            smtpClient.Host = host;
            smtpClient.Port = puerto;
            smtpClient.EnableSsl = ssl;
        }
        public void EnviarMail(string asunto, string cuerpo, List<string> MailReceptor)
        {
            var MailMensaje = new MailMessage();
            try
            {
                MailMensaje.From = new MailAddress(mail);
                foreach (string mail in MailReceptor)
                {
                    MailMensaje.To.Add(mail);
                }
                MailMensaje.Subject = asunto;
                MailMensaje.Body = cuerpo;
                MailMensaje.IsBodyHtml = true;
                MailMensaje.Priority = MailPriority.Normal;
                smtpClient.Send(MailMensaje);
            }
            catch (Exception) { }
            finally
            {
                MailMensaje.Dispose();
                smtpClient.Dispose();
            }
        }
    }
}