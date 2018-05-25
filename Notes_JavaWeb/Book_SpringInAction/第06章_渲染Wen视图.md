### 6.1 理解视图解析

将控制器中请求处理的逻辑和视图中的渲染实现解耦是Spring MVC的一个重要特性。通过Spring视图解析器，控制器只需要通过逻辑视图名来了解视图，从而使Spring确定使用哪一个视图实现来渲染模型。

Spring MVC定义了一个名为ViewResolver的接口，它大致如下所示：

```java
public interface ViewResolver {
    View resolveViewName(String viewName, Locale locale) throws Exception;
}
```

当给resolveViewName()方法传入一个视图名和Locale对象时，它会返回一个View实例。View是另外一个接口，其任务是接受模型以及Servlet的request和response对象，并将输出结果渲染到response中。



