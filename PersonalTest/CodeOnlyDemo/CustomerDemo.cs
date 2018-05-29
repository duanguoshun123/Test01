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
    public partial class CustomerDemo : Form
    {
        public CustomerDemo()
        {
            InitializeComponent();
        }

        private void CustomerDemo_Load(object sender, EventArgs e)
        {

        }
        private void btn_add_click(object sender, EventArgs e)
        {
            string username = this.txt_username.Text.Trim();
            string password = this.txt_password.Text;
            using (DemoContext context = new DemoContext())
            {
                context.customer.Add(new Customer { Id = Guid.NewGuid(), Name = username, Password = password });
                if (context.SaveChanges() > 0)
                {
                    MessageBox.Show("用户添加成功");
                    new OrderDemo(username).Show();
                    this.Dispose(false);
                }
            }
        }
    }
}
