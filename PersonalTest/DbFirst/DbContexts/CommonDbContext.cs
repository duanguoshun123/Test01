using DbFirst.Model;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DbFirst.DbContexts
{
    public partial class CommonDbContext : DbContext
    {
        public CommonDbContext(string name) 
            : base(name)
        {

        }
        public virtual DbSet<Courses> Courses { get; set; }
        public virtual DbSet<StuCousers> StuCousers { get; set; }
        public virtual DbSet<Students> Students { get; set; }
    }
}
