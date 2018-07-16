using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dal
{
    public class DbHelper
    {
        private IDbInstance instance;
        private string Name;
        private DbControl control;
        private IDbCode Code;

        public DbHelper()
        {
            control = DbControl.getInstance();
        }

        public DbHelper createConnection(string Name, string ConnectionString, string type)
        {
            this.Name = Name;
            instance = control.createInstance(Name, ConnectionString, type);
            return this;
        }

        public DbHelper ExcuteString(Func<IDbCode, IDbCode> Fun)
        {
            Code = Fun(this.instance.Code);
            return this;
        }

        public DbHelper createTransation(string Name)
        {
            this.instance.Excute.BeginTransation(Name);
            return this;
        }

        public DbHelper Rollback()
        {
            this.instance.Excute.RollBack();
            return this;
        }
        public DbHelper Commit()
        {
            this.instance.Excute.Commit();
            return this;
        }


        public T ToModel<T>(CommandType Type = CommandType.Text)
            where T : class, new()
        {
            if (this.Code == null)
                return null;
            return this.instance.Excute.ToModel<T>(this.Code, Type);
        }
        List<T> ToList<T>(CommandType Type = CommandType.Text)
            where T : class, new()
        {
            if (this.Code == null)
                return null;
            return this.instance.Excute.ToList<T>(this.Code, Type);
        }
        object ToResult(CommandType Type = CommandType.Text)
        {
            if (this.Code == null)
                return null;
            return this.instance.Excute.ToResult(this.Code, Type);
        }
        int ExcuteResult(CommandType Type = CommandType.Text)
        {
            if (this.Code == null)
                return -1;
            return this.instance.Excute.ExcuteResult(this.Code, Type);
        }
        DataTable ToDataTable(CommandType Type = CommandType.Text)
        {
            if (this.Code == null)
                return null;
            return this.instance.Excute.ToDataTable(this.Code, Type);
        }
        DataSet ToDataSet(CommandType Type = CommandType.Text)
        {
            if (this.Code == null)
                return null;
            return this.instance.Excute.ToDataSet(this.Code, Type);
        }
    }
}
