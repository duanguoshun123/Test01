using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dal
{
    public interface IDbInstance
    {
        /// <summary>
        /// 数据库名称
        /// </summary>
        string Name
        {
            get;
        }

        /// <summary>
        /// 获取执行语句类
        /// </summary>
        IDbExcute Excute
        {
            get;
        }

        /// <summary>
        /// 获取连接字符串
        /// </summary>
        string ConnectionString
        {
            get;
        }
        /// <summary>
        /// 开启事务
        /// </summary>
        /// <param name="TranName">事务名称</param>
        /// <returns></returns>
        object getTransation(string TranName);

        /// <summary>
        /// 获取拼写字符串类
        /// </summary>
        IDbCode Code
        {
            get;
        }
    }
}
