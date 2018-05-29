using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DesignModelClass.MemorandumModel
{
    /// <summary>
    /// 发起人
    /// </summary>
    public class MobileOwner
    {
        public List<ContactPerson> ContactPersons { get; set; }
        public MobileOwner(List<ContactPerson> persons)
        {
            ContactPersons = persons;
        }

        // 创建备忘录，将当期要保存的联系人列表导入到备忘录中 
        public ContactMemento CreateMemento()
        {
            // 这里也应该传递深拷贝，new List方式传递的是浅拷贝，
            // 因为ContactPerson类中都是string类型,所以这里new list方式对ContactPerson对象执行了深拷贝
            // 如果ContactPerson包括非string的引用类型就会有问题，所以这里也应该用序列化传递深拷贝  已修改为深拷贝
            return new ContactMemento(DeepShallowCopy.DeepCopyAchieve.DeepCopyWithXmlSerializer<List<ContactPerson>>(new List<ContactPerson>(this.ContactPersons)));
        }

        // 将备忘录中的数据备份导入到联系人列表中
        public void RestoreMemento(ContactMemento memento)
        {
            if (memento != null)
            {
                // 下面这种方式是错误的，因为这样传递的是引用，
                // 则删除一次可以恢复，但恢复之后再删除的话就恢复不了.
                // 所以应该传递contactPersonBack的深拷贝，深拷贝可以使用序列化来完成 已修改为深拷贝
                this.ContactPersons = DeepShallowCopy.DeepCopyAchieve.DeepCopyWithXmlSerializer<List<ContactPerson>>(memento.ContactPersonBack);
            }
        }
        public void Show()
        {
            Console.WriteLine("联系人列表中有{0}个人，他们是:", ContactPersons.Count);
            foreach (ContactPerson p in ContactPersons)
            {
                Console.WriteLine("姓名: {0} 号码为: {1}", p.Name, p.MobileNum);
            }
        }
    }
}
