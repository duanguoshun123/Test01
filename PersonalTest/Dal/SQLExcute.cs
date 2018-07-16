using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace Dal
{
    public class SQLExcute : IDbExcute
    {
        SqlConnection conn;
        Dictionary<string, List<PropertyInfo>> pro;
        Dictionary<string, SqlCommand> command;
        SqlTransaction tran = null;

        public SQLExcute(SqlConnection conn, Dictionary<string, List<PropertyInfo>> pro)
        {
            this.conn = conn;
            this.pro = pro;
            command = new Dictionary<string, SqlCommand>();
        }

        public List<T> ToList<T>(IDbCode code, CommandType type = CommandType.Text)
            where T : class, new()
        {
            List<T> list = new List<T>();
            string name = DateTime.Now.ToString();
            command.Add(name, new SqlCommand());
            SqlCommand com = command[name];
            com.Connection = conn;
            com.CommandText = code.ToString();
            com.CommandType = type;
            setCommand(com, (List<SqlParameter>)code.Paras);


            Type t = typeof(T);
            List<PropertyInfo> pros;
            if (pro.ContainsKey(t.Name))
            {
                pros = pro[t.Name];
            }
            else
            {
                pros = t.GetProperties().ToList();
                pro.Add(t.Name, pros);
            }

            try
            {
                this.OpenConnection();
                using (SqlDataReader reader = com.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        T model = new T();
                        pros.ForEach(o =>
                        {
                            if (ReaderExists(reader, o.Name))
                            {
                                o.SetValue(model, reader[o.Name], null);
                            }
                        });
                        list.Add(model);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                this.Dispose(name);
                this.CloseConnection();
            }

            return list;
        }

        public bool ReaderExists(SqlDataReader reader, string columnName)
        {
            //reader.GetSchemaTable().DefaultView.RowFilter = "ColumnName= '" + columnName + "'";
            //return (reader.GetSchemaTable().DefaultView.Count > 0);
            return reader.GetSchemaTable().Select("ColumnName='" + columnName + "'").Length > 0;
        }
        public void Dispose(string name)
        {
            if (command.ContainsKey(name))
            {
                SqlCommand com = command[name];
                command.Remove(name);
                com.Dispose();
            }
            if (command.Count <= 0)
                this.CloseConnection();
        }

        public void Dispose(object tran)
        {
            List<string> list = command.Keys.ToList();
            list.ForEach(o =>
            {
                if (command[o].Transaction != null && command[o].Transaction == (SqlTransaction)tran)
                {
                    this.Dispose(o);
                }
            });
        }

        public object ToResult(IDbCode code, CommandType type = CommandType.Text)
        {
            string name = DateTime.Now.ToString();
            command.Add(name, new SqlCommand());
            SqlCommand com = command[name];
            com.Connection = conn;
            com.CommandText = code.ToString();
            com.CommandType = type;
            setCommand(com, (List<SqlParameter>)code.Paras);


            object result = null;
            try
            {
                this.OpenConnection();
                result = com.ExecuteScalar();
            }
            catch (Exception ex)
            {
                DoException();
                throw ex;
            }
            finally
            {
                this.Dispose(name);
                this.CloseConnection();
            }

            return result;
        }

        private void DoException()
        {
            new DbException().Done();
        }

        public int ExcuteResult(IDbCode code, CommandType type = CommandType.Text)
        {
            string name = DateTime.Now.ToString();
            command.Add(name, new SqlCommand());
            SqlCommand com = command[name];
            com.Connection = conn;
            com.CommandText = code.ToString();
            com.CommandType = type;
            setCommand(com, (List<SqlParameter>)code.Paras);


            int result = 0;
            try
            {
                this.OpenConnection();
                if (tran != null)
                    com.Transaction = (SqlTransaction)tran;
                result = com.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                DoException();
                throw ex;
            }
            finally
            {
                if (tran == null)
                    Dispose(name);
                this.CloseConnection();
            }
            return result;
        }

        public DataTable ToDataTable(IDbCode code, CommandType type = CommandType.Text)
        {
            string name = DateTime.Now.ToString();
            command.Add(name, new SqlCommand());
            SqlCommand com = command[name];
            com.Connection = conn;
            com.CommandText = code.ToString();
            com.CommandType = type;
            setCommand(com, (List<SqlParameter>)code.Paras);

            DataTable dt = new DataTable();
            try
            {
                using (SqlDataAdapter adapter = new SqlDataAdapter(com))
                {
                    adapter.Fill(dt);
                }
            }
            catch (Exception ex)
            {
                DoException();
                throw ex;
            }
            finally
            {
                Dispose(name);
            }

            return dt;
        }

        public void setCommand(SqlCommand com, List<SqlParameter> paras)
        {
            paras.ForEach(o =>
            {
                com.Parameters.Add(o);
            });
        }


        public DataSet ToDataSet(IDbCode code, CommandType type = CommandType.Text)
        {
            string name = DateTime.Now.ToString();
            command.Add(name, new SqlCommand());
            SqlCommand com = command[name];
            com.Connection = conn;
            com.CommandText = code.ToString();
            com.CommandType = type;
            setCommand(com, (List<SqlParameter>)code.Paras);

            DataSet dt = new DataSet();
            try
            {
                using (SqlDataAdapter adapter = new SqlDataAdapter(com))
                {
                    adapter.Fill(dt);
                }
            }
            catch (Exception ex)
            {
                DoException();
                throw ex;
            }
            finally
            {
                Dispose(name);
            }

            return dt;
        }

        public T ToModel<T>(IDbCode code, CommandType type = CommandType.Text)
            where T : class, new()
        {
            string name = DateTime.Now.ToString();
            command.Add(name, new SqlCommand());
            SqlCommand com = command[name];
            com.Connection = conn;
            com.CommandText = code.ToString();
            com.CommandType = type;
            setCommand(com, (List<SqlParameter>)code.Paras);


            Type t = typeof(T);
            List<PropertyInfo> p = null;
            if (pro.ContainsKey(t.Name))
            {
                p = pro[t.Name];
            }
            else
            {
                p = t.GetProperties().ToList();
                pro.Add(t.Name, p);
            }
            T model = new T();

            try
            {
                this.OpenConnection();
                using (SqlDataReader reader = com.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        p.ForEach(o =>
                        {
                            if (ReaderExists(reader, o.Name))
                            {
                                o.SetValue(model, reader[o.Name], null);
                            }
                        });
                    }
                }
            }
            catch (Exception ex)
            {
                DoException();
                throw ex;
            }
            finally
            {
                Dispose(name);
                this.CloseConnection();
            }

            return model;
        }

        public void OpenConnection()
        {
            if (this.conn.State != ConnectionState.Open)
                this.conn.Open();
        }

        public void CloseConnection()
        {
            command.Values.ToList().ForEach(o =>
            {
                if (o.Transaction != null)
                    return;
            });

            if (this.conn.State != ConnectionState.Closed)
                this.conn.Close();
        }

        public void BeginTransation(string Name)
        {
            tran = conn.BeginTransaction(Name);
        }

        public void Commit()
        {
            tran.Commit();
            Dispose(tran);
            tran = null;
        }

        public void RollBack()
        {
            tran.Rollback();
            Dispose(tran);
            tran = null;
        }
    }
}
