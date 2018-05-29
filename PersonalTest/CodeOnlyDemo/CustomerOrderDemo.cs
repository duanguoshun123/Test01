using CodeOnlyDemo.Context;
using CodeOnlyDemo.Model;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace CodeOnlyDemo
{
    public partial class CustomerOrderDemo : Form
    {
        private static PageInfo page = new PageInfo();
        private static int curPage = 1;
        public CustomerOrderDemo()
        {
            InitializeComponent();
            page.PageSize = 10;
            page.CurPage = 1;
            this.cur_page_txt.Text = "1";
        }

        private void customerAdd_btn_Click(object sender, EventArgs e)
        {
            new CustomerDemo().Show();
            this.Hide();
        }

        private void CustomerOrderDemo_Load(object sender, EventArgs e)
        {
            BindData();
        }
        private async void BindData()
        {
            GetData();
        }
        private void GetData()
        {
            int.TryParse(this.cur_page_txt.Text, out curPage);
            page.CurPage = curPage;
            using (DemoContext context = new DemoContext())
            {
                var listAll = context.order.Join(context.customer, a => a.customer.Id, b => b.Id, (a, b) => new { 姓名 = b.Name, 商品类型 = a.Type, 插入时间 = a.InsertTime });
                page.RecordCount = listAll.ToList() == null ? 0 : listAll.ToList().Count;//总条数
                page.PageCount = page.RecordCount / page.PageSize;//总页数
                var customer_order_list = listAll.OrderByDescending(a => a.插入时间).Skip(page.PageSize * (page.CurPage - 1)).Take(page.PageSize).ToList();
                this.label_count.Text = "共" + page.RecordCount.ToString() + "条  共" + page.PageCount.ToString() + "页";
                this.customer_order_datagridview.DataSource = customer_order_list;

            }
        }
        private void pre_btn_Click(object sender, EventArgs e)
        {
            curPage = page.CurPage;
            if (curPage == 1)
            {
                MessageBox.Show("已经是第一页");
            }
            else
            {
                this.cur_page_txt.Text = (curPage - 1).ToString();
            }
            BindData();
        }

        private void next_btn_Click(object sender, EventArgs e)
        {
            curPage = page.CurPage;
            if (curPage == page.PageCount)
            {
                MessageBox.Show("已经是最后一页");
            }
            else
            {
                this.cur_page_txt.Text = (curPage + 1).ToString();
            }
            BindData();
        }

        private void First_btn_Click(object sender, EventArgs e)
        {
            this.cur_page_txt.Text = "1";
            page.CurPage = 1;
            BindData();
        }

        private void last_btn_Click(object sender, EventArgs e)
        {
            this.cur_page_txt.Text = page.PageCount.ToString();
            BindData();
        }

        private void to_btn_Click(object sender, EventArgs e)
        {
            string msg = "";
            if (int.TryParse(cur_page_txt.Text, out curPage))
            {
                if (curPage <= 0)
                {
                    cur_page_txt.Text = curPage.ToString();
                    msg = "页数必须为正整数";
                }
                else
                {
                    if (curPage > page.PageCount)
                    {
                        cur_page_txt.Text = page.PageCount.ToString();
                    }
                }
            }
            else
            {
                msg = "页数必须为整数";
            }
            BindData();
            if (!string.IsNullOrEmpty(msg))
            {
                MessageBox.Show(msg + " " + curPage);
            }
        }

        private void customer_order_datagridview_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void refresh_btn_Click(object sender, EventArgs e)
        {
            this.Refresh();
        }

        private void mu_btn_Click(object sender, EventArgs e)
        {
            MltAdd();
        }
        private async Task MltAdd()
        {
            await Task.Run(() => { AddAction(); });
        }
        private void AddAction()
        {
            var sucCount = 0;//用来记录添加成功的信息条数
            using (DemoContext context = new DemoContext())
            {
                //记录调用接口前的时间  
                TimeSpan startTime = new TimeSpan(DateTime.Now.Ticks);

                for (int i = 0; i < 1000; i++)
                {
                    string name = "User" + i;
                    string passWord = "AB123" + i;
                    string goodsName = "Goods" + i;
                    context.customer.Add(new Customer { Id = Guid.NewGuid(), Name = name, Password = passWord });
                    if (context.SaveChanges() > 0)
                    {
                        Customer customer1 = context.customer.Where(c => c.Name == name).FirstOrDefault();
                        context.order.Add(new Order { Id = Guid.NewGuid(), Type = goodsName, InsertTime = DateTime.Now, customer = customer1 });
                        if (context.SaveChanges() > 0)
                        {
                            sucCount++;
                        }
                    }
                    else
                    {

                    }
                }
                //记录调用接口后的时间  
                TimeSpan endTime = new TimeSpan(DateTime.Now.Ticks);
                TimeSpan ts = endTime.Subtract(startTime).Duration();

                //计算时间间隔，求出调用接口所需要的时间  
                String spanTime = ts.Hours.ToString() + "小时" + ts.Minutes.ToString() + "分" + ts.Seconds.ToString() + "秒" + ts.Milliseconds.ToString();
                //打印时间  
                var timeSpend = spanTime;
                string msg = string.Format("添加成功{0}条,花费{1}时间", sucCount.ToString(), spanTime);
                BindData();
                MessageBox.Show(msg);
            }
        }
    }
}
