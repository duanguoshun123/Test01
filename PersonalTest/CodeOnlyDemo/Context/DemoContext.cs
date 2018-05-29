using CodeOnlyDemo.Model;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeOnlyDemo.Context
{
    public class DemoContext : DbContext
    {
        public DemoContext()
            : base("name=ConnCodeFirst")
        {

        }
        public DbSet<Order> order { get; set; }
        public DbSet<Customer> customer { get; set; }
    }
}
