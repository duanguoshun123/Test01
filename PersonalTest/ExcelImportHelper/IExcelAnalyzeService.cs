using NPOI.SS.UserModel;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExcelImportHelper
{
    /// <summary>
    /// EXCEL 解析基础服务
    /// </summary>
    public interface IExcelAnalyzeService
    {
        /// <summary>
        /// 获取指定excel文件版本
        /// </summary>
        /// <param name="fileName">EXCEL文件名称</param>
        /// <returns></returns>
        int GetExcelEdition(string fileName);

        /// <summary>
        /// 根据EXCEL版本创建WorkBook
        /// </summary>
        /// <param name="edition">EXCEL版本</param>
        /// <param name="excelFileStream">EXCEL文件</param>
        /// <returns>excel文件对应workbook</returns>
        IWorkbook CreateWorkBook(int edition, Stream excelFileStream);

        /// <summary>
        /// 解析并检查EXCEL表头数据
        /// </summary>
        /// <param name="sheet"></param>
        /// <param name="uploadExcelFileResult"></param>
        /// <param name="list"></param>
        /// <returns></returns>
        Dictionary<int, string> GetExcelHeaders(ISheet sheet, ref UploadExcelFileResult uploadExcelFileResult,
            List<Regular> list);

        /// <summary>
        /// 读取EXCEL数据
        /// </summary>
        /// <typeparam name="TableDTO">数据对象</typeparam>
        /// <param name="sheet">工作簿对应工作表</param>
        /// <param name="sheetName">excel工作表名称</param>
        /// <param name="list">该excel规则集</param>
        /// <param name="dict">表头字典</param>
        /// <param name="rowCount">总数据行数</param>
        /// <returns>解析后的Excel数据集</returns>
        List<TableDTO> GetExcelDatas<TableDTO>(ISheet sheet, string sheetName, List<Regular> list,
            Dictionary<int, string> dict, int rowCount);

        /// <summary>
        /// 检查excel数据
        /// </summary>
        /// <param name="sheet">excel工作表</param>
        /// <param name="list">规则集</param>
        /// <param name="dict">表头</param>
        /// <param name="rowCount">总数据行数</param>
        /// <returns>检查结果</returns>
        UploadExcelFileResult CheckExcelDatasEnableNull(ISheet sheet, List<Regular> list, Dictionary<int, string> dict, int rowCount);
    }
}
