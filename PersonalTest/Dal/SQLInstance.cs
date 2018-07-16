using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace Dal
{
    public class SQLInstance : IDbInstance
    {
        private SqlConnection conn;
        private IDbExcute excute;
        Dictionary<string, List<PropertyInfo>> pro;
        private string name;
        private string connectionString;
        private SqlTransaction tran = null;
        public SQLInstance(string Name, Dictionary<string, List<PropertyInfo>> pro, string ConnectionString)
        {
            this.name = Name;
            this.connectionString = ConnectionString;
            conn = new SqlConnection(ConnectionString);
            this.pro = pro;
            excute = new SQLExcute(conn, pro);
        }

        public string Name
        {
            get
            {
                return this.name;
            }
        }
        public IDbExcute Excute
        {
            get
            {
                return this.excute;
            }
        }

        public string ConnectionString
        {
            get
            {
                return this.connectionString;
            }
        }

        public object getTransation(string TranName)
        {
            return this.conn.BeginTransaction(TranName);
        }

        public IDbCode Code
        {
            get
            {
                return new SQLCode(pro);
            }
        }
    }
}
