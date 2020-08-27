### # 属性作用域

|                                             | 可访问性（谁能看到）                                         | 作用域（能存活多久）                                         | 适用于...                                                    |
| ------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Context（上下文）<br>（不是线程安全的！）   | Web应用中所有部分，包括servlet、JSP、ServletContextListener、ServletContextAttributeListener | ServletContext的生命期、这意味着所部署应用的生命期。如果服务器或应用关闭，上下文则撤销（其属性也相应撤销）。 | 希望整个应用共享的资源，包括数据库连接、JNDI查找名、email地址等。 |
| HttpSession（会话）<br>（不是线程安全的！） | 访问这个特定会话的所有servlet或JSP。要记住，会话可能从单个客户请求扩展到跨同一个客户的多个请求，这些请求可能指向不同的servlet。 | 会话的声明周期。会话可以通过编程撤销，也可能只是因为超时而撤销。 | 与客户有关的资源和数据，而不只是与单个请求相关的资源。它要求与客户完成一个持续的会话。购物车就是一个典型的例子。 |
| Request（请求）<br>（线程安全）             | 应用中能直接访问请求对象的所有部分。简单来说，这主要是指使用RequestDispatcher将请求转发到JSP和Servlet，另外还有与请求相关的监听者。 | 请求的生命周期，这说明会持续到Servlet的service()方法结束，换句话说，就是线程（栈）处理这个请求的整个生命周期。 | 将模型信息从控制器传送到视图……或者特定于单个客户请求的任何其他数据。 |

### # 常见的监听者

| 场景                                                         | 监听器接口                                                   | 事件类型                     |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ---------------------------- |
| 你想知道一个Web应用上下文中是否增加、删除或替换了一个属性。  | javax.servlet.ServletContextAttributeListener<br>attributeAdded<br>attributeRemoved<br>attributeReplaced | ServletContextAttributeEvent |
| 你想知道有多少个并发用户。也就是说，你想跟踪活动的会话。     | javax.servlet.http.HttpSessionListener<br>sessionCreated<br>sessionDestroyed | HttpSessionEvent             |
| 每次请求到来时你都想知道以便建立日志记录。                   | javax.servlet.ServletRequestListener<br>requestInitialized<br>requestDestroyed | ServletRequestEvent          |
| 增加、删除或替换一个请求属性时你希望能够知道。               | javax.servlet.ServletRequestAttributeListener<br>attributeAdded<br>attributeRemoved<br>attributeReplaced | ServletRequestAttributeEvent |
| 你有一个属性类（这个类表示的对象将放在一个属性中），而且你希望得到这个类型的对象在绑定到一个会话或从会话删除时得到通知。 | javax.servlet.http.HttpSessionBindingListener<br>valueBound<br>valueUnbound | HttpSessionBindingEvent      |
| 增加、删除或替换一个会话属性时你希望能够知道。               | javax.servlet.http.HttpSessionAttributeListener<br>attributeAdded<br>attributeRemoved<br>attributeReplaced | HttpSessionBindingEvent      |
| 你想知道是否创建或撤销了一个上下文。                         | javax.servlet.ServletContextListener<br>contextInitialized<br>contextDestroyed | ServletContextEvent          |
| 你有一个属性类，而且希望这个类型的对象在其绑定的会话迁移到另一个JVM时得到通知。 | javax.servlet.http.HttpSessionActivationListener<br>sessionDidActivate<br>sessionWillPassivate | HttpSessionEvent             |

