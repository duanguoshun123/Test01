using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
namespace DbFirst
{
    public static class DataUtil
    {
        #region ReadUncommitted

        //public static int ExecuteProcedureReadUncommitted(bool isReadUncommitted, Func<int> sp)
        //{
        //    if (!isReadUncommitted)
        //    {
        //        return sp();
        //    }

        //    using (var scope = new System.Transactions.TransactionScope(System.Transactions.TransactionScopeOption.Required,
        //        new System.Transactions.TransactionOptions
        //        {
        //            IsolationLevel = System.Transactions.IsolationLevel.ReadUncommitted,
        //        }))
        //    {
        //        var result = sp();
        //        scope.Complete();
        //        return result;
        //    }
        //}

        //public static List<TElement> ExecuteProcedureReadUncommitted<TElement>(bool isReadUncommitted, Func<IEnumerable<TElement>> sp)
        //{
        //    if (!isReadUncommitted)
        //    {
        //        return sp().ToList();
        //    }

        //    using (var scope = new System.Transactions.TransactionScope(System.Transactions.TransactionScopeOption.Required,
        //        new System.Transactions.TransactionOptions
        //        {
        //            IsolationLevel = System.Transactions.IsolationLevel.ReadUncommitted,
        //        }))
        //    {
        //        var result = sp().ToList();
        //        scope.Complete();
        //        return result;
        //    }
        //}

        #endregion ReadUncommitted

        #region Use Transaction


        ///// <summary>
        ///// 不应用来做增删改操作，只用于查询
        ///// </summary>
        //public static void UseReadUncommittedTransaction(bool isUseReadUncommitted, Action callback)
        //{
        //    if (!isUseReadUncommitted)
        //    {
        //        callback();
        //        return;
        //    }
        //    using (var scope = new System.Transactions.TransactionScope(
        //        System.Transactions.TransactionScopeOption.Required,
        //        new System.Transactions.TransactionOptions()
        //        {
        //            IsolationLevel = System.Transactions.IsolationLevel.ReadUncommitted,
        //        }))
        //    {
        //        callback();
        //        scope.Complete();
        //    }
        //}

        internal static Func<System.Transactions.TransactionScope> DefaultNewScopeFunc(System.Transactions.IsolationLevel isolationLevel, System.Transactions.TransactionScopeOption transactionScopeOption)
        {
            return () => new System.Transactions.TransactionScope(transactionScopeOption, new System.Transactions.TransactionOptions
            {
                IsolationLevel = isolationLevel,
            });
        }

        internal static Func<System.Transactions.TransactionScope> DefaultNewScopeFunc(System.Transactions.IsolationLevel isolationLevel, bool isAlwaysNewScope)
        {
            var scopeOption = isAlwaysNewScope ? System.Transactions.TransactionScopeOption.RequiresNew : System.Transactions.TransactionScopeOption.Required;
            var transactionOptions = new System.Transactions.TransactionOptions
            {
                IsolationLevel = isolationLevel,
            };
            return () => new System.Transactions.TransactionScope(scopeOption, transactionOptions);
        }


        /// <summary>
        /// wrap Func&lt;ReturnInfo&gt; callback, ( 应该使用异常，而不是 ReturnInfo ， Func&lt;ReturnInfo&gt; 要改造成 Action)
        /// </summary>


        #endregion Use Transaction

        public static System.Transactions.IsolationLevel GetTransactionsIsolationLevel(this System.Data.IsolationLevel isolationLevel)
        {
            switch (isolationLevel)
            {
                case System.Data.IsolationLevel.Unspecified:
                    return System.Transactions.IsolationLevel.Unspecified;

                case System.Data.IsolationLevel.Chaos:
                    return System.Transactions.IsolationLevel.Chaos;

                case System.Data.IsolationLevel.ReadUncommitted:
                    return System.Transactions.IsolationLevel.ReadUncommitted;

                case System.Data.IsolationLevel.ReadCommitted:
                    return System.Transactions.IsolationLevel.ReadCommitted;

                case System.Data.IsolationLevel.RepeatableRead:
                    return System.Transactions.IsolationLevel.RepeatableRead;

                case System.Data.IsolationLevel.Serializable:
                    return System.Transactions.IsolationLevel.Serializable;

                case System.Data.IsolationLevel.Snapshot:
                    return System.Transactions.IsolationLevel.Snapshot;

                default:
                    throw new ArgumentOutOfRangeException();
            }
        }

        public static System.Data.IsolationLevel? GetCurrentTransactionDataIsolationLevel()
        {
            return System.Transactions.Transaction.Current?.IsolationLevel.GetDataIsolationLevel();
        }

        public static System.Data.IsolationLevel GetDataIsolationLevel(this System.Transactions.IsolationLevel isolationLevel)
        {
            switch (isolationLevel)
            {
                case System.Transactions.IsolationLevel.Serializable:
                    return System.Data.IsolationLevel.Serializable;

                case System.Transactions.IsolationLevel.RepeatableRead:
                    return System.Data.IsolationLevel.RepeatableRead;

                case System.Transactions.IsolationLevel.ReadCommitted:
                    return System.Data.IsolationLevel.ReadCommitted;

                case System.Transactions.IsolationLevel.ReadUncommitted:
                    return System.Data.IsolationLevel.ReadUncommitted;

                case System.Transactions.IsolationLevel.Snapshot:
                    return System.Data.IsolationLevel.Snapshot;

                case System.Transactions.IsolationLevel.Chaos:
                    return System.Data.IsolationLevel.Chaos;

                case System.Transactions.IsolationLevel.Unspecified:
                    return System.Data.IsolationLevel.Unspecified;

                default:
                    throw new ArgumentOutOfRangeException();
            }
        }

        //[Obsolete]
        //private static System.Transactions.IsolationLevel _LegacyDefaultIsolationLevel { get; } = System.Transactions.IsolationLevel.ReadCommitted;

        [Obsolete]
        internal static System.Data.IsolationLevel LegacyDefaultIsolationLevel { get; } = System.Data.IsolationLevel.ReadCommitted;
    }
}
