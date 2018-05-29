using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExcelImportHelper.UserModel
{
    public class AccountDetailsReport
    {
        /// <summary>
        /// 回单登记号
        /// </summary>
        public string ReceiptRegisterNumber { get; set; }
        /// <summary>
        /// 年度
        /// </summary>
        public string Year { get; set; }
        /// <summary>
        /// 公司代码
        /// </summary>
        public string Corporation { get; set; }
        /// <summary>
        /// 公司名称
        /// </summary>
        public string CorporationName { get; set; }
        /// <summary>
        /// 登记日期
        /// </summary>
        public DateTime? RegisterDate { get; set; }
        /// <summary>
        /// 交易日期
        /// </summary>
        public DateTime? TradeDate { get; set; }
        /// <summary>
        /// 收付属性
        /// </summary>
        public string RevenueAndExpenditureAttribute { get; set; }
        /// <summary>
        /// 币种
        /// </summary>
        public string Currency { get; set; }
        /// <summary>
        /// 交易金额
        /// </summary>
        public decimal? TradeAmount { get; set; }
        /// <summary>
        /// 我方账号
        /// </summary>
        public string OurAccount { get; set; }
        /// <summary>
        /// 我方开户户名
        /// </summary>
        public string OurOpenAccountName { get; set; }
        /// <summary>
        /// 我方银行户名
        /// </summary>
        public string OurBankAccountName { get; set; }
        /// <summary>
        /// 我方所属银行
        /// </summary>
        public string OurBankAttribute { get; set; }
        /// <summary>
        /// 我方银行类别
        /// </summary>
        public string OurBankType { get; set; }
        /// <summary>
        /// 我方银行经营分类
        /// </summary>
        public string OurBankManageClass { get; set; }
        /// <summary>
        /// 对方银行账号
        /// </summary>
        public string OtherBankAccount { get; set; }
        /// <summary>
        /// 对方银行户名
        /// </summary>
        public string OtherBankAccountName { get; set; }
        /// <summary>
        /// 对方开户银行
        /// </summary>
        public string OtherOpenAccountBank { get; set; }
        /// <summary>
        /// 摘要
        /// </summary>
        public string Summary { get; set; }
    }
}
