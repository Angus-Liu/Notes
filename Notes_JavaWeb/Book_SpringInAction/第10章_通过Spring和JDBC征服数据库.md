### 10.1 Spring的数据访问哲学

为了避免持久化的逻辑分散到应用的各个组件中，最好将数据访问的功能放到一个或多个专注于此项任务的组件中。这样的组件通常称为数据访问对象（data access object，DAO）或Repository。

为了避免应用与特定的数据访问策略耦合在一起，编写良好的Repository应该以接口的方式暴露功能。

![1527496093455](assets/1527496093455.png)

服务对象通过接口来访问Repository。这样做会有几个好处：

+ 它使得服务对象易于测试，因为它们不再与特定的数据访问实现绑定在一起。实际上，可以为这些数据访问接口创建mock实现，这样无需连接数据库就能测试服务对象，而且会显著提升单元测试的效率并排除因数据不一致所造成的测试失败。
+ 此外，数据访问层是以持久化技术无关的方式来进行访问的。持久化方式的选择独立于Repository，同时只有数据访问相关的方法才通过接口进行暴露。这可以实现灵活的设计，并且切换持久化框架对应用程序其他部分所带来的影响最小。

#### 10.1.1 了解Spring的数据访问异常体系

在使用JDBC的过程中，如果不强制捕获SQLException的话，几乎无法使用JDBC做任何事情。SQLException表示在尝试访问数据库的时出现了问题，但是这个异常却没有告哪里出错了以及如何进行处理。可能导致抛出SQLException的常见问题包括：

+ 应用程序无法连接数据库；
+ 要执行的查询存在语法错误；
+ 查询中所使用的表和/或列不存在；
+ 试图插入或更新的数据违反了数据库约束。

**Spring所提供的平台无关的持久化异常**

不同于JDBC，Spring提供了多个数据访问异常，分别描述了它们抛出时所对应的问题，且与特定的持久化框架无关（不用关心所选择的持久化方案）：

| JDBC异常                                                     | Spring的数据访问异常                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| BatchUpdateException<br/>DataTruncation<br/>SQLException<br/>SQLWarning | BadSqlGrammarException<br/>CannotAcquireLockException<br/>CannotSerializeTransactionException<br/>CannotGetJdbcConnectionException<br/>CleanupFailureDataAccessException<br/>ConcurrencyFailureException<br/>DataAccessException<br/>DataAccessResourceFailureException<br/>DataIntegrityViolationException<br/>DataRetrievalFailureException<br/>DataSourceLookupApiUsageException<br/>DeadlockLoserDataAccessException<br/>DuplicateKeyException<br/>EmptyResultDataAccessException<br/>IncorrectResultSizeDataAccessException<br/>IncorrectUpdateSemanticsDataAccessException<br/>InvalidDataAccessApiUsageException<br/>InvalidDataAccessResourceUsageException<br/>InvalidResultSetAccessException<br/>JdbcUpdateAffectedIncorrectNumberOfRowsException<br/>LbRetrievalFailureException |
| BatchUpdateException<br/>DataTruncation<br/>SQLException<br/>SQLWarning | NonTransientDataAccessResourceException<br/>OptimisticLockingFailureException<br/>PermissionDeniedDataAccessException<br/>PessimisticLockingFailureException<br/>QueryTimeoutException<br/>RecoverableDataAccessException<br/>SQLWarningException<br/>SqlXmlFeatureNotImplementedException<br/>TransientDataAccessException<br/>TransientDataAccessResourceException<br/>TypeMismatchDataAccessException<br/>UncategorizedDataAccessException<br/>UncategorizedSQLException |

**看！不用写catch代码块**

这些异常都继承自DataAccessException。DataAccessException的特殊之处在于它是一个非检查型异常。换句话说，没有必要捕获Spring所抛出的数据访问异常。DataAccessException只是Sping处理检查型异常和非检查型异常哲学的一个范例。Spring认为触发异常的很多问题是不能在catch代码块中修复的。

#### 10.1.2 数据访问模块

Spring在数据访问中采用模板方法模式。故而不管使用什么样的技术，都需要一些特定的数据访问步骤。

Spring将数据访问过程中固定的和可变的部分明确划分为两个不同的类：模板（template）和回调（callback）。模板管理过程中固定的部分，而回调处理自定义的数据访问代码。

![1527500118325](assets/1527500118325.png)

如图，Spring的模板类处理数据访问的固定部分——事务控制、管理资源以及处理异常。同时，应用程序相关的数据访问——语句、绑定参数以及整理结果集——在回调的实现中处理。事实证明，这是一个优雅的架构，用户只需关心自己的数据访问逻辑即可。

针对不同的持久化平台，Spring提供了多个可选的模板：

| 模板类（org.springframework.*）                 | 用途                                               |
| ----------------------------------------------- | -------------------------------------------------- |
| jca.cci.core.CciTemplate                        | JCA CCI连接                                        |
| jdbc.core.JdbcTemplate                          | JDBC连接                                           |
| jdbc.core.namedparam.NamedParameterJdbcTemplate | 支持命名参数的JDBC连接                             |
| jdbc.core.simple.SimpleJdbcTemplate             | 通过Java 5简化后的JDBC连接（Spring 3.1中已经废弃） |
| orm.hibernate3.HibernateTemplate                | Hibernate 3.x以上的Session                         |
| orm.ibatis.SqlMapClientTemplate                 | iBATIS SqlMap客户端                                |
| orm.jdo.JdoTemplate                             | Java数据对象（Java Data Object）实现               |
| orm.jpa.JpaTemplate                             | Java持久化API的实体管理器                          |

### 10.2 配置数据源

无论选择Spring的哪种数据访问方式，都需要配置一个数据源的引用。Spring提供了在Spring上下文中配置数据源bean的多种方式，包括：

+ 通过JDBC驱动程序定义的数据源；
+ 通过JNDI查找的数据源；
+ 连接池的数据源。

#### 10.2.1 使用JNDI数据源













