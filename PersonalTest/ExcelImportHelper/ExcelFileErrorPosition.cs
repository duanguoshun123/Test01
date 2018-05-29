using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExcelImportHelper
{
    public class ExcelFileErrorPosition
    {
        /// <summary>
        /// 错误行
        /// </summary>
        public int RowIndex { get; set; }

        /// <summary>
        /// 错误列集
        /// </summary>
        public List<int> CellIndex { get; set; }

        /// <summary>
        /// 错误列具体错误信息
        /// </summary>
        public List<string> ErrorMessage { get; set; }

        /// <summary>
        /// 错误行数据
        /// </summary>
        public List<string> RowContent { get; set; }
    }
}
