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
    /// 用来核对罗马字符中的C, CD, D or CM；
    /// </remarks>
    /// </summary>
    class HundredExpression : Expression
    {
        public override string One() { return "C"; }
        public override string Four() { return "CD"; }
        public override string Five() { return "D"; }
        public override string Nine() { return "CM"; }
        public override int Multiplier() { return 100; }
    }
}
