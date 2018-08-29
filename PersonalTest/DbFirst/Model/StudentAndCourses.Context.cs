﻿//------------------------------------------------------------------------------
// <auto-generated>
//     此代码已从模板生成。
//
//     手动更改此文件可能导致应用程序出现意外的行为。
//     如果重新生成代码，将覆盖对此文件的手动更改。
// </auto-generated>
//------------------------------------------------------------------------------

namespace DbFirst.Model
{
    using System;
    using System.Data;
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;

    public partial class StuAndCourseEntities : DbContext
    {
        public StuAndCourseEntities()
            : this("StuAndCourseEntities")
        {

        }
        public StuAndCourseEntities(string name)
            : base(name)
        {
            //this.Configuration.LazyLoadingEnabled = false;

            //this.Configuration.ProxyCreationEnabled = false;

            //this.Database.Connection.StateChange += this.OnStateChange;

        }
        //public StuAndCourseEntities()
        //        : base("name=StuAndCourseEntities")l
        //{
        //}
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();

        }

        public virtual DbSet<Courses> Courses { get; set; }
        public virtual DbSet<StuCousers> StuCousers { get; set; }
        public virtual DbSet<Students> Students { get; set; }
        private static bool _ReadCommittedSnapshot { get; } = true;
        private static bool _AllowSnapshotIsolation { get; } = true;
        private const string CommandTextGetTransactionIsolationLevel = "select transaction_isolation_level from sys.dm_exec_sessions where session_id = @@spid";
        private static System.Data.IsolationLevel _DefaultIsolationLevel { get; } = _AllowSnapshotIsolation ? IsolationLevel.Snapshot : IsolationLevel.ReadCommitted;

        public string CommandTextSetTransactionIsolationLevel(System.Data.IsolationLevel isolationLevel)
        {
            switch (isolationLevel)
            {
                case System.Data.IsolationLevel.Unspecified:
                    throw new ArgumentOutOfRangeException();

                case System.Data.IsolationLevel.Chaos:
                    throw new ArgumentOutOfRangeException();

                case System.Data.IsolationLevel.ReadUncommitted:
                    return "SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED";

                case System.Data.IsolationLevel.ReadCommitted:
                    return "SET TRANSACTION ISOLATION LEVEL READ COMMITTED";

                case System.Data.IsolationLevel.RepeatableRead:
                    return "SET TRANSACTION ISOLATION LEVEL REPEATABLE READ";

                case System.Data.IsolationLevel.Serializable:
                    return "SET TRANSACTION ISOLATION LEVEL SERIALIZABLE";

                case System.Data.IsolationLevel.Snapshot:
                    return "SET TRANSACTION ISOLATION LEVEL SNAPSHOT";

                default:
                    throw new ArgumentOutOfRangeException();
            }
        }
        public System.Data.IsolationLevel GetCurrentTransactionScopeDataIsolationLevel()
        {
            return DataUtil.GetCurrentTransactionDataIsolationLevel() ?? _DefaultIsolationLevel;
        }
        private void OnStateChange(object sender, StateChangeEventArgs args)
        {
            if (args.CurrentState == ConnectionState.Open && args.OriginalState != ConnectionState.Open)
            {
                using (var command = this.Database.Connection.CreateCommand())
                {
                    var isolationLevel = this.GetCurrentTransactionScopeDataIsolationLevel();
                    string commandText = this.CommandTextSetTransactionIsolationLevel(isolationLevel);

                    command.CommandText = commandText;
                    command.ExecuteNonQuery();
                }
            }
        }
    }
}
