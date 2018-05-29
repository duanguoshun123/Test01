using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using DesignModel.DesignModelClass.MediatorModel;

namespace MyTest
{
    [TestClass]
    public class DesignModelTest
    {
        [TestMethod]
        public void MediatorModelTest()
        {
            President mediator = new President();
            Market market = new Market(mediator);
            Development development = new Development(mediator);
            Financial financial = new Financial(mediator);

            mediator.SetFinancial(financial);
            mediator.SetDevelopment(development);
            mediator.SetMarket(market);

            market.Process();
            market.Apply();

            Console.Read();
        }
    }
}
