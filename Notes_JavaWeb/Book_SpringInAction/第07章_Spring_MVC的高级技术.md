### 7.1 Spring MVC配置的替代方案

#### 7.1.1 自定义DispatcherServlet配置

在AbstractAnnotationConfigDispatcherServletInitializer将DispatcherServlet注册到Servlet容器中之后，就会调用customizeRegistration()，并将Servlet注册后得到的ServletRegistration.Dynamic传递进来。通过重载customizeRegistration()方法，可以对DispatcherServlet进行额外的配置。

例如，如果计划使用Servlet 3.0对multipart配置的支持，那么需要使用DispatcherServlet的registration来启用multipart请求。可以重载customizeRegistration()方法来设置MultipartConfigElement，如下所示：

```java
public class SpittrWebAppInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {
	...
    @Override
    protected void customizeRegistration(ServletRegistration.Dynamic registration) {
        // 设置了对multipart的支持，将上传文件的临时存储目录设置在“/tmp/spittr/uploads”
        registration.setMultipartConfig(new MultipartConfigElement("/tmp/spittr/uploads"));
    }
}
```

借助customizeRegistration()方法中的ServletRegistration.Dynamic，能够完成多项任务，包括通过调用setLoadOnStartup()设置load-on-startup优先级，通过setInitParameter()设置初始化参数，通过调用setMultipartConfig()配置Servlet 3.0对multipart的支持。

#### 7.1.2 添加其他的Servlet和Filter

基于Java的初始化器（initializer）的一个好处就在于可以定义任意数量的初始化器类。因此，如果想往Web容器中注册其他组件的话，只需创建一个新的初始化器就可以了。最简单的方式就是实现Spring的WebApplicationInitializer接口。

通过实现WebApplicationInitializer来注册Servlet：

```java
public class MyServletInitializer implements WebApplicationInitializer {
    @Override
    public void onStartup(ServletContext servletContext) throws ServletException {
        // 注册Servlet
        ServletRegistration.Dynamic myServlet = servletContext.addServlet("myServlet", MyServlet.class);
        // 映射Servlet
        myServlet.addMapping("/custome/*")；
    }
}
```

注册Filter的WebApplicationInitializer：

```java
@Override
public void onStartup(ServletContext servletContext) throws ServletException {
    FilterRegistration.Dynamic filter = servletContext.addFilter("myFilter", MyFilter.class);
    filter.addMappingForUrlPatterns(null, false, "/custom/*");
}
```

如果只是注册Filter，并且该Filter只会映射到DispatcherServlet上的话，那么在AbstractAnnotationConfigDispatcherServletInitializer中还有一种快捷方式。

为了注册Filter并将其映射到DispatcherServlet，所需要做的仅仅是重载AbstractAnnotationConfigDispatcherServletInitializer的getServletFilters()方法：

```java
public class MyWebApplicationInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {
    ...
    @Override
    protected Filter[] getServletFilters() {
        // 在这里没有必要声明它的映射路径，
        // getServletFilters()方法返回的所有Filter都会映射到DispatcherServlet上
        return new Filter[]{new MyFilter()};
    }
}
```

#### 7.1.3 在web.xml中声明DispatcherServlet

在典型的Spring MVC应用中，会需要DispatcherServlet和ContextLoader Listener。AbstractAnnotationConfigDispatcherServletInitializer会自动注册它们，但是如果需要在web.xml中注册的话，那就需要手动来完成这项任务。

在web.xml中搭建Spring MVC：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0">
    
    <!-- 设置根上下文配置文件位置 -->
    <context-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>/WEB-INF/spring/root-context.xml</param-value>
    </context-param>

    <!-- 注册ContextLoaderListener -->
    <listener>
        <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
    </listener>

    <!-- 注册DispatcherServlet -->
    <servlet>
        <servlet-name>appServlet</servlet-name>
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
        <load-on-startup>1</load-on-startup>
    </servlet>

    <!-- 将DispatcherServlet映射到"/" -->
    <servlet-mapping>
        <servlet-name>appServlet</servlet-name>
        <url-pattern>/</url-pattern>
    </servlet-mapping>

</web-app>
```

ContextLoaderListener和DispatcherServlet各自都会加载一个Spring应用上下文。上下文参数contextConfigLocation指定了一个XML文件的地址，这个文件定义了根应用上下文，它会被ContextLoaderListener加载。

DispatcherServlet会根据Servlet的名字找到一个文件，并基于该文件加载应用上下文。在上述程序中，Servlet的名字是appServlet，因此DispatcherServlet会从“/WEB-INF/appServlet-context.xml”文件中加载其应用上下文。如果希望指定DispatcherServlet配置文件的位置的话，那么可以在Servlet上指定一个contextConfigLocation初始化参数：

```xml
<servlet>
    <servlet-name>appServlet</servlet-name>
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
    <init-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>/WEB-INF/spring/appServlet/servlet-context.xml</param-value>
    </init-param>
    <load-on-startup>1</load-on-startup>
</servlet>
```













