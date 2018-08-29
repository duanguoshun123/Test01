using Microsoft.SqlServer.Management.Common;
using Microsoft.SqlServer.Management.Smo;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CreateDataBaseBySql
{
    public class ExecfileHelper
    {
        /// <summary>
        /// 执行数据库脚本文件
        /// </summary>
        /// <param name="filePath">脚本目录地址</param>
        /// <param name="dataSource">数据库源</param>
        /// <param name="userId">数据库登录名</param>
        /// <param name="passWord">数据库登录密码</param>
        /// <param name="dbName">执行脚本密码</param>
        public void ExeceFile(string filePath, string dataSource, string userId, string passWord, string dbName)
        {
            try
            {
                //string connStr = "data source={0};user id={1};password={2};persist security info=false;packet size=4096";
                // ExecuteSql(connStr, "master", "CREATE DATABASE " + "数据库名"); //这个数据库名是指你要新建的数据库名称 下同
                //System.Diagnostics.Process sqlProcess = new System.Diagnostics.Process();
                //sqlProcess.StartInfo.FileName = "osql.exe ";
                //string arguments = string.Format(" -U {0} -P {1} -d {2} -i {3}", userId, passWord, userId, filePath);
                //sqlProcess.StartInfo.Arguments = arguments;//" -U 数据库用户名 -P 密码 -d 数据库名 -i 存放sql文本的目录sql.sql";
                //sqlProcess.StartInfo.WindowStyle = System.Diagnostics.ProcessWindowStyle.Hidden;
                //sqlProcess.Start();
                //sqlProcess.WaitForExit();
                //sqlProcess.Close();
                string connStr = string.Format("data source={0};user id={1};password={2};initial catalog={3};persist security info=false;packet size=4096", dataSource, userId, passWord, dbName);
                if (dataSource == ".")
                {
                    connStr = string.Format("data source=.;initial catalog={0};integrated security=True;packet size=4096", dbName);
                }
                ExecuteSqlFile(filePath, connStr);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 执行数据库语句
        /// </summary>
        /// <param name="sqlStr"></param>
        /// <param name="dataSource"></param>
        /// <param name="userId"></param>
        /// <param name="passWord"></param>
        /// <param name="dbName"></param>
        public void ExeceSql(string sqlStr, string dataSource, string userId, string passWord, string dbName)
        {
            try
            {
                string connStr = string.Format("data source={0};user id={1};password={2};persist security info=false;packet size=4096", dataSource, userId, passWord);
                if (dataSource == ".")
                {
                    connStr = string.Format("data source=.;integrated security=True;packet size=4096");
                }
                ExecuteSql(connStr, dbName, sqlStr); //这个数据库名是指你要新建的数据库名称 下同
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        private void ExecuteSql(string conn, string DatabaseName, string Sql)
        {
            System.Data.SqlClient.SqlConnection mySqlConnection = new System.Data.SqlClient.SqlConnection(conn);
            System.Data.SqlClient.SqlCommand Command = new System.Data.SqlClient.SqlCommand(Sql, mySqlConnection);
            Command.Connection.Open();
            Command.Connection.ChangeDatabase(DatabaseName);
            try
            {
                Command.ExecuteNonQuery();
            }
            finally
            {
                Command.Connection.Close();
            }
        }
        private static SqlConnection MyConnection;

        /// <summary>
          /// 执行Sql文件
          /// </summary>
          /// <param name="varFileName"></param>
          /// <returns></returns>
        public static bool ExecuteSqlFile(string varFileName, string connectionStr)
        {
            if (!File.Exists(varFileName))
            {
                return false;
            }
            try
            {
                //执行脚本
                SqlConnection conn = new SqlConnection(connectionStr);
                Server server = new Server(new ServerConnection(conn));
                FileInfo file = new FileInfo(varFileName);
                string script = file.OpenText().ReadToEnd();
                int i = server.ConnectionContext.ExecuteNonQuery(script);
                if (i == 1)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
                //return false;
            }

        }
        private static void ExecuteCommand(ArrayList varSqlList)
        {
            MyConnection.Open();
            SqlTransaction varTrans = MyConnection.BeginTransaction();

            SqlCommand command = new SqlCommand();
            command.Connection = MyConnection;
            command.Transaction = varTrans;

            try
            {
                foreach (string varcommandText in varSqlList)
                {
                    command.CommandText = varcommandText;
                    command.ExecuteNonQuery();
                }
                varTrans.Commit();
            }
            catch (Exception ex)
            {
                varTrans.Rollback();
                throw ex;
            }
            finally
            {
                MyConnection.Close();
            }
        }
    }
}
