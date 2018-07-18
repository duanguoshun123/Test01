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
        public static string dbName { get; set; }
        public static  string GetConnection(string name)
        {
            var connectionString = "server=.;uid=sa;pwd=Miss20170129;database="+name;
            return connectionString;
        }
        //public DemoContext()
        //    : base("name=ConnCodeFirst_Copy1")
        //{

        //}
        public DemoContext(string name)
           : base(name)
        {

        }
        public DbSet<Order> order { get; set; }
        public DbSet<Customer> customer { get; set; }
    }
}
