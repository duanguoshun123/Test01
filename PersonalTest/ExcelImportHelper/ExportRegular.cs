using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExcelImportHelper
{
    /// <summary>
    /// 导出Excel中英文规则类
    /// </summary>
    public class ExportRegular
    {
        /// <summary>
        /// 属性名称（英文）
        /// </summary>
        public string PropertyName { get; set; }

        /// <summary>
        /// 数据类型
        /// </summary>
        public string DataType { get; set; }

        /// <summary>
        /// 导出名称（中文）
        /// </summary>
        public string ExportFieldName { get; set; }
    }
}
