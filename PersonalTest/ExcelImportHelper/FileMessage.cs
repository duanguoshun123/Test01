using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExcelImportHelper
{
    public class FileMessage
    {
        /// <summary>
        /// 上传文件名称
        /// </summary>
        public string FileName { get; set; }

        /// <summary>
        /// 文件大小
        /// </summary>
        public int Length { get; set; }

        /// <summary>
        /// 文件类型
        /// </summary>
        public string Type { get; set; }
    }
}
