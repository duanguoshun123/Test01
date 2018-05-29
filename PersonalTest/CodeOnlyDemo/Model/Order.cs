using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeOnlyDemo.Model
{
    public class Order
    {
        [Key]
        public Guid Id { get; set; }

        public DateTime InsertTime { get; set; }

        public string Type { get; set; }

        public Customer customer { get; set; }
    }
}
