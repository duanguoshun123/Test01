using NPOI.HSSF.UserModel;
using NPOI.SS.UserModel;
using NPOI.SS.Util;
using NPOI.XSSF.UserModel;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Xml;

namespace ExcelImportHelper
{
    public class ExportHepler
    {
        /// <summary>
        /// 解析XML规则集文件
        /// </summary>
        /// <returns></returns>
        public static List<ExportRegular> GetExportRegulars(string xmlpath)
        {
            var result = new List<ExportRegular>();

            var reader = new XmlTextReader(xmlpath);
            var doc = new XmlDocument();
            //从指定的XMLReader加载XML文档
            doc.Load(reader);

            foreach (XmlNode node in doc.DocumentElement.ChildNodes)
            {
                var header = new ExportRegular();

                if (node.Attributes["PropertyName"] != null)
                    header.PropertyName = node.Attributes["PropertyName"].Value;
                if (node.Attributes["DataType"] != null)
                    header.DataType = node.Attributes["DataType"].Value;
                if (node.Attributes["ExportFieldName"] != null)
                    header.ExportFieldName = node.Attributes["ExportFieldName"].Value;

                result.Add(header);
            }

            return result;
        }

        /// <summary>
        /// 将数据转换成excel文件流输出  ->单表单导出接口
        /// </summary>
        /// <returns></returns>
        public static MemoryStream CreateExcelStreamByDatas<T>(List<T> objectDatas, KeyValuePair<string, string> excelHeader, string xmlPath)
        {
            // 返回对象
            var ms = new MemoryStream();

            // excel工作簿
            IWorkbook workbook = new XSSFWorkbook();
            //导入数据到sheet表单
            CreateExcelSheetByDatas(objectDatas, excelHeader.Key, excelHeader.Value, ref workbook, xmlPath);
            //文件夹不存在则创建
            DirectoryInfo TheFolder = new DirectoryInfo(System.Threading.Thread.GetDomain().BaseDirectory + "/Export/");
            if (!TheFolder.Exists)
            {
                Directory.CreateDirectory(System.Threading.Thread.GetDomain().BaseDirectory + "/Export/");
            }
            var savaPath = System.Threading.Thread.GetDomain().BaseDirectory + "/Export/" + excelHeader.Key + DateTime.Now.ToString("yyyyMMddHHmmss") + ".xlsx";
            //保存为Excel文件  
            using (FileStream fs = new FileStream(savaPath, FileMode.Create, FileAccess.Write))
            {
                workbook.Write(ms);
                //ms.Flush();
                var buf = ms.ToArray();
                KillSpecialExcel();
                fs.Write(buf, 0, buf.Length);
                fs.Flush();
                fs.Position = 0;
                fs.Close();
                fs.Dispose();
                // 导出成功后打开  
                System.Diagnostics.Process.Start(savaPath);
            }
            return ms;
        }

        /// <summary>
        /// 将数据转换成excel文件流输出  ->多表单导出接口
        /// </summary>
        /// <returns></returns>
        public static MemoryStream CreateExcelStreamByDatas<T>(List<KeyValuePair<List<T>, KeyValuePair<string, string>>> objectDatas, List<string> xmlPaths)
        {
            // 返回对象
            var ms = new MemoryStream();

            // excel工作簿
            IWorkbook workbook = new XSSFWorkbook();
            //导入数据到sheet表单
            foreach (KeyValuePair<List<T>, KeyValuePair<string, string>> keyValuePair in objectDatas)
            {
                //导入数据到sheet表单
                CreateExcelSheetByDatas(keyValuePair.Key, keyValuePair.Value.Key, keyValuePair.Value.Value, ref workbook, xmlPaths[objectDatas.IndexOf(keyValuePair)]);
            }

            //文件夹不存在则创建
            DirectoryInfo TheFolder = new DirectoryInfo(System.Threading.Thread.GetDomain().BaseDirectory + "/Export/");
            if (!TheFolder.Exists)
            {
                Directory.CreateDirectory(System.Threading.Thread.GetDomain().BaseDirectory + "/Export/");
            }
            var savaPath = System.Threading.Thread.GetDomain().BaseDirectory + "/Export/" + "信息" + DateTime.Now.ToString("yyyyMMddHHmmss") + ".xlsx";
            //保存为Excel文件  
            using (FileStream fs = new FileStream(savaPath, FileMode.Create, FileAccess.Write))
            {
                workbook.Write(ms);
                //ms.Flush();
                var buf = ms.ToArray();
                KillSpecialExcel();
                fs.Write(buf, 0, buf.Length);
                fs.Flush();
                fs.Position = 0;
                fs.Close();
                fs.Dispose();
                // 导出成功后打开  
                System.Diagnostics.Process.Start(savaPath);
            }
            return ms;
        }

        /// <summary>
        /// 根据传入数据新建sheet表单到指定workbook
        /// </summary>
        /// <param name="objectDatas"></param>
        /// <param name="excelHeader"></param>
        /// <param name="sheetName"></param>
        /// <param name="regulars"></param>
        /// <param name="workbook"></param>
        private static void CreateExcelSheetByDatas<T>(List<T> objectDatas, string excelHeader, string sheetName, ref IWorkbook workbook, string xmlPath)
        {
            var regulars = GetExportRegulars(xmlPath);

            // excel sheet表单
            ISheet sheet = workbook.CreateSheet(sheetName);
            // excel行数
            int rows = 0;

            #region 单元格 -表头格式

            #region 表头字体

            IFont fontTitle = workbook.CreateFont();
            fontTitle.FontHeightInPoints = 12;
            fontTitle.Boldweight = (short)FontBoldWeight.Bold;

            #endregion

            ICellStyle styleTitle = workbook.CreateCellStyle();
            styleTitle.Alignment = NPOI.SS.UserModel.HorizontalAlignment.Center;
            styleTitle.SetFont(fontTitle);
            styleTitle.VerticalAlignment = VerticalAlignment.Center;
            styleTitle.FillBackgroundColor = NPOI.HSSF.Util.HSSFColor.Yellow.Index; //XSSFColor
            styleTitle.FillPattern = FillPattern.SolidForeground;
            #endregion

            #region 单元格 -表体格式

            #region 表体字体

            IFont fontMessage = workbook.CreateFont();
            fontMessage.FontHeightInPoints = 10;

            #endregion

            ICellStyle styleMessage = workbook.CreateCellStyle();
            styleMessage.Alignment = HorizontalAlignment.Center;
            styleMessage.SetFont(fontMessage);
            styleMessage.VerticalAlignment = VerticalAlignment.Center;

            #endregion
            if (!string.IsNullOrEmpty(excelHeader))//表头存在
            {
                // 创建表头并赋值
                int firstRowCellCount = GetAttributeCount(objectDatas.First());
                IRow headerRow = sheet.CreateRow(rows);
                headerRow.HeightInPoints = 40;
                var headerCell = headerRow.CreateCell(0);
                headerCell.SetCellValue(excelHeader);

                // 合并表头
                var cellRangeAddress = new CellRangeAddress(rows, rows, 0, firstRowCellCount - 1);
                sheet.AddMergedRegion(cellRangeAddress);
                // 设置表头格式
                headerCell.CellStyle = styleTitle;
            }
            //生成表头(属性表头)
            if (objectDatas.Any())
            {
                rows++;
                // excel列数
                int cells = -1;
                // 创建数据行
                var firstRow = sheet.CreateRow(rows);
                firstRow.HeightInPoints = 16;
                var objectData = objectDatas.FirstOrDefault();
                foreach (System.Reflection.PropertyInfo p in objectData.GetType().GetProperties())
                {
                    cells++;
                    var regular = regulars.Find(t => t.PropertyName == p.Name);
                    if (regular == null)
                    {
                        throw new Exception("导出excel时，出现未配置字段。表：" + objectData.GetType().Name + ",字段：" + p.Name);
                    }
                    var firstRowCell = firstRow.CreateCell(cells);
                    firstRowCell.SetCellValue(regular.ExportFieldName);
                    sheet.SetColumnWidth(cells, regular.ExportFieldName.Length * 256 * 4);
                    firstRowCell.CellStyle = styleMessage;
                }
            }

            // 反射object对象，遍历字段
            foreach (var objectData in objectDatas)
            {
                rows++;
                // excel列数
                int cells = -1;
                // 创建数据行
                var messageRow = sheet.CreateRow(rows);
                messageRow.HeightInPoints = 16;
                foreach (System.Reflection.PropertyInfo p in objectData.GetType().GetProperties())
                {
                    cells++;
                    var regular = regulars.Find(t => t.PropertyName == p.Name);
                    var messageCell = messageRow.CreateCell(cells);
                    var value = p.GetValue(objectData);
                    if (value == null)
                    {
                        messageCell.SetCellValue("");
                    }
                    else
                    {
                        switch (regular.DataType)
                        {
                            case "datetime":
                                if (Convert.ToDateTime(value) == DateTime.MinValue)
                                {
                                    messageCell.SetCellValue("");
                                }
                                else
                                {
                                    messageCell.SetCellValue(
                                        Convert.ToDateTime(value).ToString("yyyy-MM-dd HH:mm:ss"));
                                }
                                break;
                            case "int":
                                messageCell.SetCellValue(Convert.ToInt32(value));
                                break;
                            case "double":
                                messageCell.SetCellValue(Convert.ToDouble(value));
                                break;
                            case "bool":
                                var setValue = "是";
                                if (!(bool)value)
                                {
                                    setValue = "否";
                                }
                                messageCell.SetCellValue(setValue);
                                break;
                            default:
                                messageCell.SetCellValue(value.ToString());
                                break;
                        }
                    }
                    messageCell.CellStyle = styleMessage;
                }
            }
        }

        public static int GetAttributeCount(object data)
        {
            Type t = data.GetType();
            int count = 0;//用来记录对象的属性个数
            foreach (PropertyInfo pi in t.GetProperties())
            {
                count++;
            }
            return count;
        }
        /// <summary>  
        /// 导出文件，使用文件流。该方法使用的数据源为DataTable,导出的Excel文件没有具体的样式。  
        /// </summary>  
        /// <param name="dt"></param>  
        public static string ExportToExcel(System.Data.DataTable dt, string path)
        {
            KillSpecialExcel();
            string result = string.Empty;
            try
            {
                // 实例化流对象，以特定的编码向流中写入字符。  
                StreamWriter sw = new StreamWriter(path, false, Encoding.GetEncoding("gb2312"));

                StringBuilder sb = new StringBuilder();
                for (int k = 0; k < dt.Columns.Count; k++)
                {
                    // 添加列名称  
                    sb.Append(dt.Columns[k].ColumnName.ToString() + "\t");
                }
                sb.Append(Environment.NewLine);
                // 添加行数据  
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    DataRow row = dt.Rows[i];
                    for (int j = 0; j < dt.Columns.Count; j++)
                    {
                        // 根据列数追加行数据  
                        sb.Append(row[j].ToString() + "\t");
                    }
                    sb.Append(Environment.NewLine);
                }
                sw.Write(sb.ToString());
                sw.Flush();
                sw.Close();
                sw.Dispose();

                // 导出成功后打开  
                //System.Diagnostics.Process.Start(path);  
            }
            catch (Exception)
            {
                result = "请保存或关闭可能已打开的Excel文件";
            }
            finally
            {
                dt.Dispose();
            }
            return result;
        }
        /// <summary>  
        /// 结束进程  
        /// </summary>  
        private static void KillSpecialExcel()
        {
            foreach (System.Diagnostics.Process theProc in System.Diagnostics.Process.GetProcessesByName("EXCEL"))
            {
                if (!theProc.HasExited)
                {
                    bool b = theProc.CloseMainWindow();
                    if (b == false)
                    {
                        theProc.Kill();
                    }
                    theProc.Close();
                }
            }
        }
    }
}
