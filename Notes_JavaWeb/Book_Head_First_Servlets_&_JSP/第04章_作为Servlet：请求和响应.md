### # Servlet受容器的控制

1. 用户点击一个链接，链接的URL指向一个servlet。
2. 容器“看出”这个请求是一个servlet，所以容器创建两个对象：HTTPServletResponse、HTTPServletRequest。
3. 容器根据请求中的URL查找正确的servlet，为这个请求创建或分配一个线程，并调用servlet的service()方法（传递请求和响应对象作为参数）。
4. service()方法根据客户发出的HTTP方法（GET、POST等），确定调用哪个servlet方法。
5. 客户发出了一个HTTP GET请求，所以service()方法会调用servlet的doGET()方法，并传送请求和响应对象作为参数。
6. servlet使用响应对象将响应写至客户。响应通过容器传回。
7. service()方法结束，所以线程要么撤销，要么返回到容器管理的一个线程池。请求和响应对象引用已经出了作用域，所以这些对象已经没有意义（可以垃圾回收）。
8. 客户得到响应。

### # 每个请求都在一个单独的线程中运行！

任何servlet类都不会有多个实例，而是容器运行多个线程来处理对同一个servlet的多个请求。

### # ServletConfig和ServletContext

ServletConfig对象：

+ 每个servlet都有一个ServletConfig对象。
+ 用于向servlet传递部署信息（例如数据库或企业bean的查找名），而你不想把这个信息硬编码到servlet中（servlet初始化参数）。
+ 用于访问ServletContext。
+ 参数在部署描述文件中配置。

ServletContext

+ 每个web应用有一个ServletContext。
+ 用于访问Web应用参数（也在部署描述文件中配置）。
+ 相当于一种应用公告栏，可以在这里放置消息（称为属性），应用的其他部分可以访问这些消息。
+ 用于得到服务器信息，包括容器名和容器版本，以及所支持的API的版本等。

### # HTTP方法

+ GET 要求得到请求URL上的一个资源文件。
+ POST 要求服务器接收附加到请求体的消息，并提供所请求URL上的一个东西。这像一个扩展的GET。
+ HEAD 只要求得到GET返回结果的首部部分。所以这有点像GET，但是响应中没有响应体。它能提供所请求的URL的有关信息，但是不会真正返回实际的资源文件。
+ TRACE 要求请求消息回送，这样客户能看到另一端上接收了什么，以便测试或排错。
+ PUT 指出要把所包含的信息（体）放在请求的URL上。
+ DELETE 指出删除所请求URL上的一个资源文件。
+ OPTIONS 要求得到一个HTTP方法列表，所请求URL上的资源文件可以对这些HTTP方法做出响应。
+ CONNECT 要求连接以便建立隧道。

### # HttpServletResponse

+ 使用响应向客户发回数据。
+ 对响应对象（HttpServletResponse）调用的最常用的方法是setContentType()和getWriter()。
+ 得到书写器的方法是getWriter，利用getWriter()方法可以完成字符I/O，向流写入HTML（或其他内容）。
+ 还可以使用响应来设置首部、发送错误、以及增加cookie。
+ 实际中，可能会使用一个响应流发送二进制文件。要得到二进制流，需要在响应上调用getOutputStream()方法。
+ setContentType()方法告诉浏览器如何处理随响应到来的数据。常见的内容类型为“text/html”、“application/pdf”和“image/jpeg”.
+ 可以使用addHeader()或setHeader()设置响应首部。二者的区别是这个首部是否已经是响应的一部分。如果是，setHeader()会替换原来的值，而addHeader()会追加一个值。如果响应中没有这个首部，两者都是新增这个首部。
+ 要重定向一个请求，需要在响应上调用sendRedirect()方法（不能在已经提交，即已在流中写入数据后再重定向）。
+ 重定向和请求分派是不同的。请求分派在服务端发生，是把请求传递给服务器上的另一个组件。重定向在客户端进行，是告诉浏览器去访问另一个URL。









