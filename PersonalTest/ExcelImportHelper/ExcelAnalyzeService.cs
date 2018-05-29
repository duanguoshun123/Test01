using NPOI.HSSF.UserModel;
using NPOI.SS.UserModel;
using NPOI.SS.Util;
using NPOI.XSSF.UserModel;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace ExcelImportHelper
{
    public abstract class ExcelAnalyzeService : ExcelParseBaseService, IExcelAnalyzeService
    {
        /// <summary>
        /// 验证返回excel版本
        /// </summary>
        /// <param name="fileName"></param>
        /// <returns></returns>
        public int GetExcelEdition(string fileName)
        {
            var edition = 0;
            string[] items = fileName.Split(new char[] { '.' });
            int count = items.Length;
            switch (items[count - 1])
            {
                case "xls":
                    edition = 3;
                    break;
                case "xlsx":
                    edition = 7;
                    break;
                default:
                    break;
            }

            return edition;
        }

        /// <summary>
        /// 根据EXCEL版本创建WorkBook
        /// </summary>
        /// <param name="edition">EXCEL版本</param>
        /// <param name="excelFileStream">EXCEL文件</param>
        /// <returns>excel文件对应workbook</returns>
        public IWorkbook CreateWorkBook(int edition, Stream excelFileStream)
        {
            switch (edition)
            {
                case 7:
                    return new XSSFWorkbook(excelFileStream);
                case 3:
                    return new HSSFWorkbook(excelFileStream);
                default:
                    return null;
            }
        }

        /// <summary>
        /// 解析并检查EXCEL表头数据
        /// </summary>
        /// <param name="sheet"></param>
        /// <param name="uploadExcelFileResult"></param>
        /// <param name="list"></param>
        /// <returns></returns>
        public Dictionary<int, string> GetExcelHeaders(ISheet sheet, ref UploadExcelFileResult uploadExcelFileResult,
            List<Regular> list)
        {
            int firstHeaderRowIndex = list.Find(e => e.HeaderRegular != null).HeaderRegular["firstHeaderRow"];
            int lastHeaderRowIndex = list.Find(e => e.HeaderRegular != null).HeaderRegular["lastHeaderRow"];

            var dict = new Dictionary<int, string>();

            try
            {
                // 循环获得表头
                for (int i = firstHeaderRowIndex - 1; i < lastHeaderRowIndex; i++)
                {
                    IRow headerRow = sheet.GetRow(i);
                    int cellCount = headerRow.LastCellNum;

                    for (int j = headerRow.FirstCellNum; j < cellCount; j++)
                    {
                        if (!string.IsNullOrEmpty(headerRow.GetCell(j).StringCellValue.Trim()))
                        {
                            // 根据 键－值 是否已存在做不同处理
                            //TODO 代码待重构！！！
                            try
                            {
                                string oldValue = dict[j];
                                dict.Remove(j);
                                dict.Add(j, oldValue + headerRow.GetCell(j).StringCellValue.Trim());
                            }
                            catch (Exception)
                            {
                                dict.Add(j, headerRow.GetCell(j).StringCellValue.Trim());
                            }
                        }
                    }
                }
                // 遍历表头字典，消除空格
                for (int i = 0; i < dict.Count; i++)
                {
                    var value = dict[i];
                    this.ReplaceSpace(ref value);
                    dict[i] = value;
                }
                // 检查表头模板是否被修改
                for (int count = 0; count < dict.Count; count++)
                {
                    Regular header = list.Find(h => h.HeaderText == dict[count]);

                    if (header == null)
                    {
                        uploadExcelFileResult.Success = false;
                        uploadExcelFileResult.Message = "读取EXCEL表头模板时发生错误，可能造成原因是：EXCEL模板被修改！请下载最新EXCEL模板！";
                    }
                }
            }
            catch (Exception e)
            {
                uploadExcelFileResult.Success = false;
                uploadExcelFileResult.Message = "读取EXCEL表头模板时发生错误，可能造成原因是：EXCEL模板被修改！请下载最新EXCEL模板！";
            }

            return dict;
        }

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
        public List<TableDTO> GetExcelDatas<TableDTO>(ISheet sheet, string sheetName, List<Regular> list,
            Dictionary<int, string> dict, int rowCount)
        {
            // 返回数据对象集合
            var resultList = new List<TableDTO>();
            // 表头结束行
            int lastHeaderRowIndex = list.Find(e => e.HeaderRegular != null).HeaderRegular["lastHeaderRow"];

            // 循环行数据
            for (int i = lastHeaderRowIndex; i <= rowCount; i++)
            {
                // 产生一个新的泛型对象
                var model = Activator.CreateInstance<TableDTO>();
                // 记录该行空值数
                int nullcount = 0;

                IRow dataRow = sheet.GetRow(i);
                int cellCount = dict.Count;

                if (dataRow != null)
                {
                    // 循环列数据
                    for (int j = dataRow.FirstCellNum; j < cellCount; j++)
                    {
                        string value = "";
                        Regular header = list.Find(h => h.HeaderText == dict[j]);
                        PropertyInfo prop = model.GetType().GetProperty(header.PropertyName);
                        //value = dataRow.GetCell(j).ToString();
                        switch (dataRow.GetCell(j).CellType)
                        {
                            case CellType.Formula:
                                value = dataRow.GetCell(j).StringCellValue.ToString();
                                break;
                            default:
                                value = dataRow.GetCell(j).ToString();
                                break;
                        }

                        // 去除空值
                        this.ReplaceSpace(ref value);

                        if (value == "")
                        {
                            nullcount++;
                        }

                        // 赋值
                        switch (header.DataType)
                        {
                            case "System.double":
                                double valueDecimal;
                                if (double.TryParse(value, out valueDecimal))
                                {
                                    prop.SetValue(model, valueDecimal, null);
                                }
                                break;
                            case "System.Int16":
                                short valueInt16;
                                if (Int16.TryParse(value, out valueInt16))
                                {
                                    prop.SetValue(model, valueInt16, null);
                                }
                                break;
                            case "System.Int32":
                                int valueInt32;
                                if (Int32.TryParse(value, out valueInt32))
                                {
                                    prop.SetValue(model, valueInt32, null);
                                }
                                break;
                            case "System.Boolean":
                                bool valueBoolean;
                                if (Boolean.TryParse(value, out valueBoolean))
                                {
                                    prop.SetValue(model, valueBoolean, null);
                                }
                                break;
                            case "System.DateTime":
                                DateTime valueDateTime;
                                if (DateTime.TryParse(value, out valueDateTime))
                                {
                                    prop.SetValue(model, valueDateTime, null);
                                }
                                break;
                            default:
                                prop.SetValue(model, value, null);
                                break;
                        }
                    }
                }

                // 添加非空行数据到DTO
                if (nullcount < cellCount)
                {
                    resultList.Add(model);
                }
            }

            return resultList;
        }

        /// <summary>
        /// 检查excel数据
        /// </summary>
        /// <param name="sheet">excel工作表</param>
        /// <param name="list">规则集</param>
        /// <param name="dict">表头</param>
        /// <param name="rowCount">总数据行数</param>
        /// <returns>检查结果</returns>
        public UploadExcelFileResult CheckExcelDatasEnableNull(ISheet sheet, List<Regular> list, Dictionary<int, string> dict, int rowCount)
        {
            var result = new UploadExcelFileResult();
            result.Success = true;

            // 记录单个sheet所有错误信息
            var sheetErrors = new List<ExcelFileErrorPosition>();
            // 表头结束行
            int lastHeaderRowIndex = list.Find(e => e.HeaderRegular != null).HeaderRegular["lastHeaderRow"];

            // 循环行数据
            for (int i = lastHeaderRowIndex; i <= rowCount; i++)
            {
                // 标注该行是否出错
                bool isrowfalse = false;
                // 记录该行数据临时对象
                var rowDatas = new List<string>();
                // 记录该行错误列
                var rowErrorCell = new List<int>();
                // 记录该行错误列具体错误信息
                var rowErrorMessages = new List<string>();
                // 记录该行空值数
                int nullcount = 0;


                IRow dataRow = sheet.GetRow(i);
                int cellCount = dict.Count;

                // 循环列数据
                for (int j = dataRow.FirstCellNum; j < cellCount; j++)
                {
                    string value = "";
                    Regular header = list.Find(h => h.HeaderText == dict[j]);
                    //value = dataRow.GetCell(j).ToString();
                    switch (dataRow.GetCell(j).CellType)
                    {
                        case CellType.Formula:
                            value = dataRow.GetCell(j).StringCellValue.ToString();
                            break;
                        default:
                            value = dataRow.GetCell(j).ToString();
                            break;
                    }

                    // 记录可能出错数据
                    rowDatas.Add(value);

                    // 检查空值
                    if (!this.CheckNull(value, ref nullcount))
                    {
                        // 检查类型
                        if (!this.CheckDataType(header.DataType, value))
                        {
                            isrowfalse = true;
                            result.Success = false;
                            // 记录该行错误信息
                            rowErrorCell.Add(j + 1);
                            rowErrorMessages.Add("读取EXCEL数据时发生数据格式错误，请检查该行该列数据格式！");
                        }
                        else
                        {
                            if (header.DataType == "System.string" || header.DataType == "System.String")
                            {
                                this.ReplaceSpace(ref value);
                            }
                        }
                    }
                }
                // 报错处理(空行不报错)
                if (isrowfalse && nullcount < cellCount)
                {
                    sheetErrors.Add(new ExcelFileErrorPosition
                    {
                        RowContent = rowDatas,
                        RowIndex = i + 1,
                        CellIndex = rowErrorCell,
                        ErrorMessage = rowErrorMessages
                    });
                }
            }
            result.ExcelFileErrorPositions = sheetErrors;
            return result;
        }

        /// <summary>
        /// 检查单元格数据类型
        /// </summary>
        /// <param name="cellType">类型</param>
        /// <param name="cellValue">单元格值</param>
        /// <returns>类型是否出错</returns>
        public override bool CheckDataType(string cellType, string cellValue)
        {
            if (cellValue.GetType().Name==cellType)
            {
                return true;
            }
            return false;
        }

        /// <summary>
        /// 检查单元格数据是否为空
        /// </summary>
        /// <param name="cellValue">单元格值</param>
        /// <param name="nullcount">行空值计数器</param>
        /// <returns>数据是否为空</returns>
        public override bool CheckNull(string cellValue, ref int nullcount)
        {
            if (string.IsNullOrEmpty(cellValue))
            {
                nullcount++;
                return true;
            }
            else
            {
                return false;
            }

        }

        /// <summary>
        /// 去除数据空格
        /// </summary>
        /// <param name="cellValue">单元格值</param>
        public override void ReplaceSpace(ref string cellValue)
        {
            cellValue = TruncateString(cellValue, new char[] { ' ' }, new char[] { '　' });
        }

        // 对字符串做空格剔除处理
        private string TruncateString(string originalWord, char[] spiltWord1, char[] spiltWord2)
        {
            var result = "";
            var valueReplaceDbcCase = originalWord.Split(spiltWord1);

            if (valueReplaceDbcCase.Count() > 1)
            {
                for (int i = 0; i < valueReplaceDbcCase.Count(); i++)
                {
                    if (valueReplaceDbcCase[i] != "" && valueReplaceDbcCase[i] != " " &&
                        valueReplaceDbcCase[i] != "　")
                    {
                        result += TruncateString(valueReplaceDbcCase[i], spiltWord2, new char[0]);
                    }
                }
            }
            else
            {
                if (spiltWord2.Any())
                {
                    result = TruncateString(originalWord, spiltWord2, new char[0]);
                }
                else
                {
                    result = originalWord;
                }
            }

            return result;
        }

        /// <summary>
        /// 判断当前单元格是否为合并单元格
        /// </summary>
        /// <param name="cellIndex">单元格所在列序号</param>
        /// <param name="rowIndex">单元格所在行序号</param>
        /// <param name="sheet">EXCEL工作表</param>
        /// <returns>合并单元格为true</returns>
        public override bool IsMergedRegionCell(int cellIndex, int rowIndex, ISheet sheet, ref int firstRegionRow)
        {
            bool isMerged = false;
            var regionLists = GetMergedCellRegion(sheet);

            foreach (var cellRangeAddress in regionLists)
            {
                for (int i = cellRangeAddress.FirstRow; i <= cellRangeAddress.LastRow; i++)
                {
                    if (rowIndex == i)
                    {
                        for (int j = cellRangeAddress.FirstColumn; j <= cellRangeAddress.LastColumn; j++)
                        {
                            if (cellIndex == j)
                            {
                                isMerged = true;
                                firstRegionRow = cellRangeAddress.FirstRow;
                                break;
                            }
                            else
                            {
                                continue;
                            }
                        }
                    }
                    else
                    {
                        continue;
                    }
                }
            }

            return isMerged;
        }

        /// <summary>
        /// 读取EXCEL XML配置信息集
        /// </summary>
        /// <param name="xmlpath">xml文件路径</param>
        /// <returns></returns>
        public override List<Regular> GetXMLInfo(string xmlpath)
        {
            var reader = new XmlTextReader(xmlpath);
            var doc = new XmlDocument();
            doc.Load(reader);

            var headerList = new List<Regular>();
            foreach (XmlNode node in doc.DocumentElement.ChildNodes)
            {
                var header = new Regular();

                if (node.Attributes["firstHeaderRow"] != null)
                    header.HeaderRegular.Add("firstHeaderRow", int.Parse(node.Attributes["firstHeaderRow"].Value));
                if (node.Attributes["lastHeaderRow"] != null)
                    header.HeaderRegular.Add("lastHeaderRow", int.Parse(node.Attributes["lastHeaderRow"].Value));
                if (node.Attributes["sheetCount"] != null)
                    header.HeaderRegular.Add("sheetCount", int.Parse(node.Attributes["sheetCount"].Value));

                if (node.Attributes["headerText"] != null)
                    header.HeaderText = node.Attributes["headerText"].Value;
                if (node.Attributes["propertyName"] != null)
                    header.PropertyName = node.Attributes["propertyName"].Value;
                if (node.Attributes["dataType"] != null)
                    header.DataType = node.Attributes["dataType"].Value;

                headerList.Add(header);
            }
            return headerList;
        }

        // 获取合并区域信息
        private List<CellRangeAddress> GetMergedCellRegion(ISheet sheet)
        {
            int mergedRegionCellCount = sheet.NumMergedRegions;
            var returnList = new List<CellRangeAddress>();

            for (int i = 0; i < mergedRegionCellCount; i++)
            {
                returnList.Add(sheet.GetMergedRegion(i));
            }

            return returnList;
        }
    }
}
