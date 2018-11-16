# Java EE

### JSP 隐式对象（9个）

> [JSP内置对象](http://blog.csdn.net/qq_34337272/article/details/64310849)

+ out (JspWriter) : 输出服务器响应的输出流对象；
+ request (HttpServletRequest) : 封装客户端的请求，其中包含来自GET或POST请求的参数；
+ response (HttpServletResponse) : 封装服务器对客户端的响应；
+ session (HttpSession) : 封装用户会话的对象；
+ application (ServletContext) : 封装服务器运行环境的对象；
+ config (ServletConfig) : Web应用的配置对象；
+ exception (Throwable) : 封装页面抛出异常的对象；
+ pageContext (PageContext) : 通过该对象可以获得其他隐式对象；
+ page (Object) : JSP 页面本身（相当于Java程序中的this）。

