using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PersonalTest
{
    class Folder : AbstractFile
    {
        private List<AbstractFile> fileList = new List<AbstractFile>();
        private string name;
        public Folder(string name)
        {
            this.name = name;
        }
        public string Name
        {
            get { return name; }
            set { name = value; }
        }
        public override void Add(AbstractFile file)
        {
            fileList.Add(file);
        }

        public override void Delete(AbstractFile file)
        {
            fileList.Remove(file);
        }

        public override AbstractFile GetChildFile(int i)
        {
            return fileList[i] as AbstractFile;
        }

        public override void KillVirue()
        {
            Console.WriteLine("对文件夹{0}进行杀毒", name);
            foreach (AbstractFile obj in fileList)
            {
                obj.KillVirue();
            }
        }
    }
}
