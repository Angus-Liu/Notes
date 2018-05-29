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

Spring应用程序经常部署在Java EE应用服务器中，如WebSphere、JBoss或甚至像Tomcat这样的Web容器中。这些服务器允许配置通过JNDI获取数据源。这种配置的好处在于数据源完全可以在应用程序之外进行管理，这样应用程序只需在访问数据库的时候查找数据源就可以了。另外，在应用服务器中管理的数据源通常以池的方式组织，从而具备更好的性能，并且还支持系统管理员对其进行热切换。

利用Spring，可以像使用Spring bean那样配置JNDI中数据源的引用并将其装配到需要的类中。位于jee命名空间下的\<jee:jndi-lookup>元素可以用于检索JNDI中的任何对象（包括数据源）并将其作为Spring的bean。例如，如果应用程序的数据源配置在JNDI中，可以使用\<jee:jndi-lookup>元素将其装配到Spring中，如下所示：

```xml
<!-- jndi-name属性用于指定JNDI中资源的名称，
     如果只设置了jndi-name属性，那么就会根据指定的名称查找数据源 -->
<!-- 如果应用程序运行在Java应用服务器中，需要将resource-ref属性设置为true，
     这样给定的jndi-name将会自动添加"java:comp/env/"前缀 -->
<jee:jndi-lookup id="dataSource" jndi-name="/jdbc/SpittrDS" resource-ref="true" />
```

使用Java配置的话，可以借助JndiObjectFactoryBean从JNDI中查找DataSource：

```java
@Bean
public JndiObjectFactoryBean dataSource() {
    JndiObjectFactoryBean jndiObjectFB = new JndiObjectFactoryBean();
    jndiObjectFB.setJndiName("jdbc/SpittrDS");
    jndiObjectFB.serResourceRef(true);
    jndiObjectFB.setProxyInterface(javax.sql.DataSource.class);
    return jndiObjectFB;
}
```

#### 10.2.2 使用数据源连接池

如果不能从JNDI中查找数据源，那么下一个选择就是直接在Spring中配置数据源连接池。尽管Spring并没有提供数据源连接池实现，但是有多项可用的方案，包括如下开源的实现：

+ Apache Commons DBCP (http://jakarta.apache.org/commons/dbcp)
+ c3p0 (http://sourceforge.net/projects/c3p0/) 
+ BoneCP (http://jolbox.com/) 

这些连接池中的大多数都能配置为Spring的数据源，在一定程度上与Spring自带的DriverManagerDataSource或SingleConnectionDataSource很类似。如下就是配置DBCP BasicDataSource的方式：

```xml
<!-- 前四个属性是配置BasicDataSource所必需的 -->
<!-- 属性driverClassName指定了JDBC驱动类的全限定类名，在这里我们配置的是H2数据库的数据源；
     属性url用于设置数据库的JDBC URL；
     最后，username和password用于在连接数据库时进行认证 -->
<bean id="dataSource" class="org.apache.commons.dbcp.BasicDataSource"
      p:diverClassName="org.h2.Driver"
      p:url="jdbc:h2:tcp://localhost/-/spittr"
      p:username="root"
      p:password="123456"
      p:initialSize="5"
      p:maxActive="10"/>
```

若是Java配置的话，连接池形式的DataSourcebean可以声明如下：

```java
@Bean
public BasicDataSource dataSource() {
    BasicDataSource ds= new BasicDataSource();
    ds.setDiverClassName("org.h2.Driver");
    ds.setUrl("jdbc:h2:tcp://localhost/-/spittr");
    ds.setUserName("root");
    ds.setPassword("123456");
    // 连接池启动时会创建5个连接
    // 需要的时候，允许BasicDataSource创建新的连接，但是最大连接为10
    ds.setInitialSize(5);
    ds.setMaxActive(10);
    return ds;
}
```

DBCP BasicDataSource最有用的一些池配置属性：

| 池配置属性                 | 所指定的内容                                                 |
| -------------------------- | ------------------------------------------------------------ |
| initialSize                | 池启动时创建的连接数量                                       |
| maxActive                  | 同一时间可从池中分配的最多连接数。如果设置为0，表示无限制    |
| maxIdle                    | 池里不会被释放的最多空闲连接数。如果设置为0，表示无限制      |
| maxOpenPreparedStatements  | 在同一时间能够从语句池中分配的预处理语句（prepared statement）的最大数量。如果设置为0，表示无限制 |
| maxWait                    | 在抛出异常之前，池等待连接回收的最大时间（当没有可用连接时）。如果设置为-1，表示无限等待 |
| minEvictableIdleTimeMillis | 连接在池中保持空闲而不被回收的最大时间                       |
| minIdle                    | 在不创建新连接的情况下，池中保持空闲的最小连接数             |
| poolPreparedStatements     | 是否对预处理语句（prepared statement）进行池管理（布尔值）   |

#### 10.2.3 基于JDBC驱动的数据源

在Spring中，通过JDBC驱动定义数据源是最简单的配置方式。Spring提供了三个这样的数据源类（均位于org.springframework.jdbc.datasource包中）供选择：

+ DriverManagerDataSource：在每个连接请求时都会返回一个新建的连接。与DBCP的BasicDataSource不同，由DriverManagerDataSource提供的连接并没有进行池化管理；
+ SimpleDriverDataSource：与DriverManagerDataSource的工作方式类似，但是它直接使用JDBC驱动，来解决在特定环境下的类加载问题，这样的环境包括OSGi容器；
+ SimpleDriverDataSource：与DriverManagerDataSource的工作方式类似，但是它直接使用JDBC驱动，来解决在特定环境下的类加载问题，这样的环境包括OSGi容器；

以上这些数据源的配置与DBCPBasicDataSource的配置类似。如下就是配置DriverManagerDataSource的方法：

```java
@Bean
public DataSource datasource() {
    DriverManagerDataSource ds = new DriverManagerDataSource();
    ds.setDiverClassName("org.h2.Driver");
    ds.setUrl("jdbc:h2:tcp://localhost/-/spittr");
    ds.setUserName("root");
    ds.setPassword("123456");
    return ds;
}
```

使用XML的话，DriverManagerDataSource可以按照如下的方式配置：

```xml
<bean id="dataSource" class="org.springframework.jdbc.datasource.DriverManagerDataSource"
      p:diverClassName="org.h2.Driver"
      p:url="jdbc:h2:tcp://localhost/-/spittr"
      p:username="root"
      p:password="123456"/>
```

#### 10.2.4 使用嵌入式的数据源

嵌入式数据库（embedded database）作为应用的一部分运行，而不是应用连接的独立数据库服务器。对于开发和测试来讲，嵌入式数据库都是很好的可选方案。这是因为每次重启应用或运行测试的时候，都能够重新填充测试数据。

Spring的jdbc命名空间能够简化嵌入式数据库的配置。如下的程序清单展现了如何使用jdbc命名空间来配置嵌入式的H2数据库，它会预先加载一组测试数据：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:jdbc="http://www.springframework.org/schema/jdbc"
       xsi:schemaLocation="http://www.springframework.org/schema/beans 
                           http://www.springframework.org/schema/beans/spring-beans.xsd 
                           http://www.springframework.org/schema/jdbc 
                           http://www.springframework.org/schema/jdbc/spring-jdbc.xsd">

    <!-- <jdbc:embedded-database>的type属性设置为H2，
         表明嵌入式数据库是H2数据库（要确保H2位于应用的类路径下） -->
    <jdbc:embedded-database id="dataSource" type="H2">
        <!-- 可以配置多个<jdbc:script>元素来搭建数据库 -->
        <!-- 第一个引用了schema.sql，它包含了在数据库中创建表的SQL -->
        <jdbc:script location="classpath:jdbc/schema.sql"/>
        <!-- 第二个引用了test-data.sql，用来将测试数据填充到数据库中 -->
        <jdbc:script location="classpath:jdbc/test-data.sql"/>

    </jdbc:embedded-database>

</beans>
```

如果使用Java来配置嵌入式数据库时，不会像jdbc命名空间那么简便，可以使用EmbeddedDatabaseBuilder来构建DataSource：

```java
@Bean
public DataSource dataSource() {
    return new EmbeddedDatabaseBuilder()
        .setTyepe(EmbeddedDatabaseType.H2)
        .addScript("classpath:schemal.sql")
        .addScript("classpath:test-data.sql")
        .build();
}
```

#### 10.2.5 使用profile选择数据源

























​                                                                                    









