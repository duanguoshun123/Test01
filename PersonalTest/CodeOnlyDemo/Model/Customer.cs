using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeOnlyDemo.Model
{
    public class Customer
    {
        [Key]
        public Guid Id { get; set; }
        public string Name { get; set; }
        public string Password { get; set; }
        public ICollection<Order> Order { get; set; }
    }
}
