using NPOI.SS.UserModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExcelImportHelper
{
    /// <summary>
    /// EXCEL解析基本服务接口
    /// </summary>
    public interface IExcelParseBaseService
    {
        /// <summary>
        /// 检查单元格数据类型
        /// </summary>
        /// <param name="cellType">类型</param>
        /// <param name="cellValue">单元格值</param>
        /// <returns>类型是否出错</returns>
        bool CheckDataType(string cellType, string cellValue);

        /// <summary>
        /// 检查单元格数据是否为空
        /// </summary>
        /// <param name="cellValue">单元格值</param>
        /// <param name="nullcount">行空值计数器</param>
        /// <returns>数据是否为空</returns>
        bool CheckNull(string cellValue, ref int nullcount);

        /// <summary>
        /// 去除数据空格
        /// </summary>
        /// <param name="cellValue">单元格值</param>
        void ReplaceSpace(ref string cellValue);

        /// <summary>
        /// 判断当前单元格是否为合并单元格
        /// </summary>
        /// <param name="cellIndex">单元格所在列序号</param>
        /// <param name="rowIndex">单元格所在行序号</param>
        /// <param name="sheet">EXCEL工作表</param>
        /// <returns>合并单元格为true</returns>
        bool IsMergedRegionCell(int cellIndex, int rowIndex, ISheet sheet, ref int firstRegionRow);

        /// <summary>
        /// 读取EXCEL XML配置信息集
        /// </summary>
        /// <param name="xmlpath">xml文件路径</param>
        /// <returns></returns>
        List<Regular> GetXMLInfo(string xmlpath);
    }
}
