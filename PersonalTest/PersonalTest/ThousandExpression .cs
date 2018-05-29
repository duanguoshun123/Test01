using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PersonalTest
{
    /// <summary>
    /// A 'TerminalExpression' class
    /// <remarks>
    /// 用来核对罗马字符中的 M
    /// </remarks>
    /// </summary>
    class ThousandExpression : Expression
    {
        public override string One() { return "M"; }
        public override string Four() { return " "; }
        public override string Five() { return " "; }
        public override string Nine() { return " "; }
        public override int Multiplier() { return 1000; }
    }
}
