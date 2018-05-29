using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PersonalTest
{
    //抽象构件，它是叶子和容器共同的父类，并且声明了叶子和容器的所有方法  
    abstract class AbstractFile
    {
        public abstract void Add(AbstractFile file);//新增文件  
        public abstract void Delete(AbstractFile file);//删除文件  
        public abstract AbstractFile GetChildFile(int i);//获取子构件（可以使文件，也可以是文件夹）  
        public abstract void KillVirue();//对文件进行杀毒 
    }
}
