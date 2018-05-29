using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PersonalTest
{
    class ImageFile : AbstractFile//图片文件
    {
        private string name;

        public string Name
        {
            get { return name; }
            set { name = value; }
        }
        public ImageFile(string name)
        {
            this.name = name;
        }
        public override void Add(AbstractFile file)
        {
            Console.WriteLine("对不起，不支持该方法");
        }
        public override void Delete(AbstractFile file)
        {
            Console.WriteLine("对不起，不支持该方法");
        }
        public override AbstractFile GetChildFile(int i)
        {
            Console.WriteLine("对不起，不支持该方法");
            return null;
        }
        public override void KillVirue()
        {
            //模拟杀毒  
            Console.WriteLine("已经对{0}进行了杀毒", name);
        }
    }
}
