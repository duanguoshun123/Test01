using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dal
{
    public interface IDbExcute
    {
        T ToModel<T>(IDbCode code, CommandType type = CommandType.Text)
            where T : class, new();

        List<T> ToList<T>(IDbCode code, CommandType type = CommandType.Text)
            where T : class, new();

        object ToResult(IDbCode code, CommandType type = CommandType.Text);

        int ExcuteResult(IDbCode code, CommandType type = CommandType.Text);

        DataTable ToDataTable(IDbCode code, CommandType type = CommandType.Text);

        DataSet ToDataSet(IDbCode code, CommandType type = CommandType.Text);

        void OpenConnection();
        void CloseConnection();

        void Dispose(object tran);

        void BeginTransation(string Name);
        void Commit();
        void RollBack();
    }
}
