using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExcelImportHelper
{
    /// <summary>
    /// 模板规则类
    /// </summary>
    public class Regular
    {
        /// <summary>
        /// 表头文本
        /// </summary>
        public string HeaderText { set; get; }

        /// <summary>
        /// 属性名称
        /// </summary>
        public string PropertyName { set; get; }

        /// <summary>
        /// 数据类型
        /// </summary>
        public string DataType { set; get; }

        private Dictionary<string, int> _regular = new Dictionary<string, int>();

        /// <summary>
        /// 表头规则
        /// </summary>
        public Dictionary<string, int> HeaderRegular
        {
            get { return _regular; }
            set { _regular = value; }
        }
    }
}
