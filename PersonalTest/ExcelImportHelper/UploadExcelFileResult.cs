using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExcelImportHelper
{
    /// <summary>
    /// EXCEL文件上传检查返回数据
    /// </summary>
    public class UploadExcelFileResult
    {
        /// <summary>
        /// 是否成功
        /// </summary>
        public bool Success { get; set; }

        /// <summary>
        /// 附带消息
        /// </summary>
        public string Message { get; set; }

        /// <summary>
        /// 文件基本信息
        /// </summary>
        public FileMessage FileMessage { get; set; }

        /// <summary>
        /// 解析失败后错误位置定位信息
        /// </summary>
        public List<ExcelFileErrorPosition> ExcelFileErrorPositions { get; set; }
    }
}
