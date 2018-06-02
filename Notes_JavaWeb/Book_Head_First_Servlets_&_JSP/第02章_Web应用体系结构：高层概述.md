### # 什么是容器？

Servlet没有main()方法。它们受控于另一个Java应用，这个Java应用称为容器。如果Web服务器应用（如Apache）得到一个指向某servlet的请求，此时服务器会将该请求交给该servlet的容器（如Tomcat）。容器向servlet提供HTTP请求和响应，而且要由容器调用servlet的方法，如doPost()或doGet()。

### # 容器能提供什么？

+ 通信支持：利用容器提供的方法，你能轻松地让servle与Web服务器对话； 
+ 生命周期管理：容器控制着servlet的生与死。它会负责加载类、实例和初始化servlet、调用servlet方法，并使servlet实例能够被垃圾回收。 
+ 多线程支持：容器会自动地为它接收的每个servlet请求创建一个新的java线程。针对客户机的请求，如果servlet已经运行完相应的HTTP服务方法，这个线程就会结束（也就是会死掉）。 
+ 声明方式实现安全：利用容器，可以使用XML部署描述文件配置（和修改）安全性，而不必将其硬编码写到servlet（或其他）类代码中。 
+ JSP支持：负责把JSP代码翻译成真正的java。 

