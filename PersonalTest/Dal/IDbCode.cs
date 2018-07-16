using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dal
{
    public interface IDbCode
    {
        /// <summary>
        /// 数据库执行表、视图、存储过程等对象
        /// </summary>
        /// <param name="Object">名称</param>
        /// <returns></returns>
        IDbCode From(object Object);

        /// <summary>
        /// 查询
        /// </summary>
        /// <param name="Fields">查询的字段</param>
        /// <returns></returns>
        IDbCode Select(string Fields = "*");

        /// <summary>
        /// 删除
        /// </summary>
        /// <returns></returns>
        IDbCode Delete();

        /// <summary>
        /// 更新
        /// </summary>
        /// <param name="model">更新对象</param>
        /// <param name="Fields">更新字段</param>
        /// <returns></returns>
        IDbCode Update(object model, string Fields = "");

        /// <summary>
        /// 插入
        /// </summary>
        /// <param name="model">插入对象</param>
        /// <param name="Fields">插入字段</param>
        /// <returns></returns>
        IDbCode Insert(object model, string Fields = "");

        /// <summary>
        /// 与条件
        /// </summary>
        /// <param name="Where">条件字符串</param>
        /// <returns></returns>
        IDbCode AndWhere(string Where);
        /// <summary>
        /// 与条件
        /// </summary>
        /// <param name="Field">字段</param>
        /// <param name="Value">值</param>
        /// <returns></returns>
        IDbCode AndWhere(string Field, object Value);

        /// <summary>
        /// 与条件
        /// </summary>
        /// <param name="Field">条件字段</param>
        /// <param name="Select">嵌套查询条件委托</param>
        /// <returns></returns>
        IDbCode AndWhere(string Field, Func<IDbCode, string> Select);

        /// <summary>
        /// 与条件
        /// </summary>
        /// <typeparam name="T">值的类型</typeparam>
        /// <param name="Field">条件字段</param>
        /// <param name="Values">值</param>
        /// <returns></returns>
        IDbCode AndWhere<T>(string Field, List<T> Values);

        /// <summary>
        /// 或条件
        /// </summary>
        /// <param name="Where">条件字符串</param>
        /// <returns></returns>
        IDbCode OrWhere(string Where);

        /// <summary>
        /// 或条件
        /// </summary>
        /// <param name="Field">条件字段</param>
        /// <param name="Value">值</param>
        /// <returns></returns>
        IDbCode OrWhere(string Field, object Value);

        /// <summary>
        /// 或条件
        /// </summary>
        /// <param name="Field">条件字段</param>
        /// <param name="Select">嵌套条件</param>
        /// <returns></returns>
        IDbCode OrWhere(string Field, Func<IDbCode, string> Select);

        /// <summary>
        /// 或条件
        /// </summary>
        /// <typeparam name="T">值类型</typeparam>
        /// <param name="Field">条件字段</param>
        /// <param name="Values">值</param>
        /// <returns></returns>
        IDbCode OrWhere<T>(string Field, List<T> Values);

        /// <summary>
        /// Top 语句
        /// </summary>
        /// <param name="topCount"></param>
        /// <returns></returns>
        IDbCode Top(int topCount);

        /// <summary>
        /// 排序从小到大
        /// </summary>
        /// <param name="Field">排序字段</param>
        /// <returns></returns>
        IDbCode OrderByAsc(string Field);

        /// <summary>
        /// 排序从大到小
        /// </summary>
        /// <param name="Field">排序字段</param>
        /// <returns></returns>
        IDbCode OrderByDesc(string Field);

        /// <summary>
        /// 多表查询时候必须加的条件
        /// </summary>
        /// <param name="Fields">在两张表中的相同字段</param>
        /// <returns></returns>
        IDbCode ForMulTable(string Fields);

        string ToString();

        /// <summary>
        /// 清空缓存
        /// </summary>
        /// <returns></returns>
        IDbCode Clear();

        IDbCode CreateCode(string sql);

        object Paras
        {
            get;
        }
        void Dispose();
    }
}
