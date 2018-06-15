﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ReflactionHepler
{
    [DeBugInfo(45, "Zara Ali", "12/8/2012",
    Message = "Return type mismatch")]
    [DeBugInfo(49, "Nuha Ali", "10/10/2012",
    Message = "Unused variable")]
    [DeBugInfo(78, "guoshun duan", "6/8/2018",
    Message = "add a function of to display Perimeter")]
    public class Rectangle
    {
        // 成员变量
        protected double length;
        protected double width;
        public Rectangle(double l, double w)
        {
            length = l;
            width = w;
        }
        [DeBugInfo(55, "Zara Ali", "19/10/2012",
         Message = "Return type mismatch")]
        public double GetArea()
        {
            return length * width;
        }
        [DeBugInfo(56, "Zara Ali", "19/10/2012")]
        public void Display()
        {
            Console.WriteLine("Length: {0}", length);
            Console.WriteLine("Width: {0}", width);
            Console.WriteLine("Area: {0}", GetArea());
            Console.WriteLine("Perimete: {0}", GetPerimeter());
        }
        [DeBugInfo(78, "guoshun duan", "6/8/2018",
         Message = "add a function of to display Perimeter")]
        public double GetPerimeter()
        {
            return 2 * (length + width);
        }
    }
}
