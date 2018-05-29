using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PersonalTest
{
    class Context
    {
        private string _input;
        private int _output;
        public Context(string input)
        {
            this._input = input;
        }
        public string Input
        {
            get { return _input; }
            set { _input = value; }
        }
        public int Output
        {
            get { return _output; }
            set { _output = value; }
        }
    }
}
