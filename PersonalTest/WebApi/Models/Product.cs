using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApi.Models
{
    public class Product
    {
        public int Id { get; set; }
        public string SNumber { get; set; }
        public string Orin { get; set; }
        public string ProductName { get; set; }
    }
}