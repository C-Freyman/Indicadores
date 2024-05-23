using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;

/// <summary>
/// Descripción breve de Conexion
/// </summary>
public class Conexion
{

    private const String strConection = "Server=192.168.0.76;Database=Indicadores;Uid=sa;Pwd=similares*3;";
  
    private SqlConnection con;

    public Conexion()
    {
        con = new SqlConnection(strConection);
    }

    private void openConection() {
        try
        {
            if (con.State != ConnectionState.Open)
            {
                con.Open();
            }
        }
        catch (Exception)
        {
        }
    }
    private void closeConection()
    {
        try
        {
            if (con.State != ConnectionState.Closed)
            {
                con.Close();
            }
        }
        catch (Exception)
        {
        }
    }
    public DataTable getDatatable(String strQuery) {
        SqlDataAdapter da = new SqlDataAdapter(strQuery, con);
        DataTable dt = new DataTable();

        this.openConection();

        try
        {
            da.Fill(dt);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally {
            this.closeConection();
        }
        return dt;

    }

   


        public SqlDataReader getReader(string strQuery)
        {
            SqlDataReader dr;
            this.openConection();
            SqlCommand com = new SqlCommand(strQuery, con);
            dr = com.ExecuteReader(CommandBehavior.CloseConnection);
            return dr;
        }
        //SqlDataReader dr;        
        //this.openConection();
        //SqlCommand com = new SqlCommand(strQuery, con);
        //dr = com.ExecuteReader(CommandBehavior.CloseConnection);
        //return dr;

        //try
        //{
        //    dr = com.ExecuteReader(CommandBehavior.CloseConnection);
        //}
        //catch (Exception)
        //{

        //    throw;
        //}
        //finally
        //{
        //    this.closeConection();
        //}

        //return dr;


   // }

    public SqlDataAdapter getAdapter(string strQuery)
    {
        this.openConection();
        SqlCommand com = new SqlCommand(strQuery, con);
        SqlDataAdapter da = new SqlDataAdapter(com);
        DataSet ds = new DataSet();
        da.Fill(ds);
        try
        {
            da.Fill(ds);
        }
        catch (Exception)
        {

            throw;
        }
        finally
        {
            this.closeConection();
        }

        return da;

    }



    public void Save(string strQuery)
    {
        string error = "BEGIN CATCH ROLLBACK TRANSACTION; DECLARE @ErrorMensaje NVARCHAR(4000);   DECLARE @ErrorSeveridad INT; DECLARE @ErrorEstado INT; SELECT @ErrorMensaje = ERROR_MESSAGE(), @ErrorSeveridad = ERROR_SEVERITY(),  @ErrorEstado = ERROR_STATE();   RAISERROR(@ErrorMensaje, @ErrorSeveridad,@ErrorEstado); END CATCH; ";
        System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand();
        cmd.CommandType = System.Data.CommandType.Text;
        cmd.CommandText = "BEGIN TRY BEGIN TRAN " + strQuery + " COMMIT TRAN END TRY  " + error;
        cmd.Connection = con;
        this.openConection();
        
        try
        {
            cmd.ExecuteNonQuery();
           
        }
        catch (Exception)
        {

            throw;
            
        }
        finally
        {
            this.closeConection();
        }
        
       
    }
    
}