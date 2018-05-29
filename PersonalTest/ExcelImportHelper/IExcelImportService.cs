using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExcelImportHelper
{
    /// <summary>
    /// Excel 导入基础服务接口
    /// </summary>
    public interface IExcelImportService
    {
        /// <summary>
        /// 综合验证Excel表格符合性
        /// </summary>
        /// <returns></returns>
        UploadExcelFileResult ValidateExcel();

        /// <summary>
        /// 导入EXCEL文件
        /// </summary>
        /// <typeparam name="TableDTO">数据对象DTO</typeparam>
        /// <returns>EXCEL数据集合</returns>
        List<TableDTO> Import<TableDTO>();
    }
}
