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
    public partial class OrderDemo : Form
    {
        public string username;
        public OrderDemo()
        {
            InitializeComponent();
        }
        public OrderDemo(string username)
            : this()
        {
            this.current_lable2.Text = username;
            this.username = username;
        }
        private void btn_submit_Click(object sender, EventArgs e)
        {
            string name = this.goods_txt.Text.Trim();
            using (DemoContext context = new DemoContext())
            {
                Customer customer1 = context.customer.Where(c => c.Name == username).FirstOrDefault();
                context.order.Add(new Order { Id = Guid.NewGuid(), Type = name, InsertTime = DateTime.Now, customer = customer1 });
                if (context.SaveChanges() > 0)
                {
                    MessageBox.Show("添加成功");
                    new CustomerOrderDemo().Show();
                    this.Dispose(false);
                }
            }
        }
    }
}
