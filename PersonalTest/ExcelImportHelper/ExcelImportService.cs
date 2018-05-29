using NPOI.SS.UserModel;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExcelImportHelper
{
    public class ExcelImportService : ExcelAnalyzeService, IExcelImportService
    {
        private string _filePath;
        private string _xmlPath;
        private Dictionary<int, int> _rowCount = new Dictionary<int, int>();
        private List<Regular> _list;// 规则集

        /// <summary>
        /// 构造方法
        /// </summary>
        /// <param name="filePath">excel文件路径</param>
        /// <param name="xmlPath">配置文件路径</param>
        public ExcelImportService(string filePath, string xmlPath)
        {
            _filePath = filePath;
            _xmlPath = xmlPath;
            _list = this.GetXMLInfo(_xmlPath);
        }

        // excel所有单元格数据验证
        public UploadExcelFileResult ValidateExcel()
        {
            var result = new UploadExcelFileResult();
            result.Success = true;

            _rowCount = new Dictionary<int, int>();

            Stream fileStream = new FileStream(_filePath, FileMode.Open);
            int edition = this.GetExcelEdition(_filePath);
            if (edition != 0)
            {
                IWorkbook workbook = this.CreateWorkBook(edition, fileStream);
                int sheetCount = _list.Find(e => e.HeaderRegular != null).HeaderRegular["sheetCount"];

                for (int i = 0; i < sheetCount; i++)
                {
                    ISheet sheet = workbook.GetSheetAt(i);
                    Dictionary<int, string> dict = this.GetExcelHeaders(sheet, ref result, _list);
                    if (result.Success)
                    {
                        _rowCount.Add(i, sheet.LastRowNum);
                        result = this.CheckExcelDatasEnableNull(sheet, _list, dict, _rowCount[i]);
                    }
                    else
                    {
                        break;
                    }
                }
            }
            else
            {
                result.Success = false;
                result.Message = "文件类型错误!";
            }

            fileStream.Close();
            return result;
        }

        // 解析excel数据到DTO
        public List<TableDTO> Import<TableDTO>()
        {
            var uploadExcelFileResult = new UploadExcelFileResult();
            var resultList = new List<TableDTO>();

            Stream fileStream = new FileStream(_filePath, FileMode.Open);
            int edition = this.GetExcelEdition(_filePath);
            IWorkbook workbook = this.CreateWorkBook(edition, fileStream);
            int sheetCount = _list.Find(e => e.HeaderRegular != null).HeaderRegular["sheetCount"];
            ValidateExcel();
            for (int i = 0; i < sheetCount; i++)
            {
                ISheet sheet = workbook.GetSheetAt(i);
                string sheetName = sheet.SheetName;
                Dictionary<int, string> dict = this.GetExcelHeaders(sheet, ref uploadExcelFileResult, _list);
                var sheetLists = this.GetExcelDatas<TableDTO>(sheet, sheetName, _list, dict, _rowCount[i]);
                resultList.AddRange(sheetLists);
            }

            fileStream.Close();
            return resultList;
        }

    }
}
