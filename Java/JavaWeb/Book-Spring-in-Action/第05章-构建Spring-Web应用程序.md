### 5.1 Spring MVC起步

Spring MVC基于模型-视图-控制器（Model-View-Controller，MVC）模式实现，它能够构建像Spring框架那样灵活和松耦合的Web应用程序。

#### 5.1.1 跟踪Spring MVC的请求

每当用户在Web浏览器中点击链接或提交表单的时候，请求就开始工作了。请求是一个十分繁忙的家伙。从离开浏览器开始到获取响应返回，它会经历好多站，在每站都会留下一些信息同时也会带上其他信息。如图是请求使用Spring MVC所经历的所有站点：

![1527167008244](assets/1527167008244.png)

+ 在请求离开浏览器时，会带有用户所请求内容的信息，至少会包含请求的URL。但是还可能带有其他的信息，例如用户提交的表单信息。
+ 请求旅程的第一站是Spring的DispatcherServlet，在这里一个单实例的Servlet将请求委托给应用程序的其他组件来执行实际的处理。
+ 控制器是一个用于处理请求的Spring组件。DispatcherServlet需要知道应该将请求发送给哪个控制器，所以DispatcherServlet会查询处理器映射（handler mapping）来确定请求的下一站。处理器映射会根据请求所携带的URL信息来进行决策。
+ 一旦选择了合适的控制器，DispatcherServlet会将请求发送给选中的控制器。到了控制器，请求会卸下其负载（用户提交的信息）并耐心等待控制器处理这些信息。
+ 控制器在完成逻辑处理后，通常会产生一些信息，这些信息需要返回给用户并在浏览器上显示。这些信息被称为模型（model）。
+ 控制器所做的最后一件事就是将模型数据打包，并且标示出用于渲染输出的视图名。它接下来会将请求连同模型和视图名发送回DispatcherServlet。
+ 这样，控制器就不会与特定的视图相耦合，传递给DispatcherServlet的视图名并不直接表示某个特定的JSP。实际上，它甚至并不能确定视图就是JSP。它仅仅传递了一个逻辑名称，这个名字将会用来查找产生结果的真正视图。DispatcherServlet将会使用视图解析器（view resolver）来将逻辑视图名匹配为一个特定的视图实现，它可能是也可能不是JSP。
+ 请求的最后一站是视图的实现（可能是JSP），在这里它交付模型数据。请求的任务就完成了。

#### 5.1.2 搭建Spring MVC

**配置DispatcherServlet**

DispatcherServlet是Spring MVC的核心。在这里请求会第一次接触到框架，它要负责将请求路由到其他的组件之中。借助于Servlet 3规范和Spring 3.1的功能增强，这里会使用Java将DispatcherServlet配置在Servlet容器中，而不会再使用web.xml文件：

```java
// 扩展AbstractAnnotationConfigDispatcherServletInitializer的类会自动地配置DispatherServlet和Spring应用上下文
public class SpittrWebAppInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {
    
    // getRootConfigClasses()方法返回的带有@Configuration注解的类
    // 将会用来配置ContextLoaderListener创建的应用上下文中的bean
    @Override
    protected Class<?>[] getRootConfigClasses() {
        return new Class[]{ RootConfig.class }; // 根配置定义在RootConfig中
    }

    
    // getServletConfigClasses()方法返回的带有@Configuration注解的类
    // 将会用来定义DispatcherServlet应用上下文中的bean
    @Override
    protected Class<?>[] getServletConfigClasses() {
        return new Class[]{ WebConfig.class }; // DispatcherServlet的配置声明在WebConfig中
    }

    // getServletMappings()方法会将一个或多个路径映射到DispatherServlet上
    @Override
    protected String[] getServletMappings() { 
        return new String[]{"/"}; // 将DispatcherServlet映射到"/"
    }
}

```

**AbstractAnnotationConfigDispatcherServletInitializer剖析**

在Servlet 3.0环境中，容器会在类路径中查找实现javax.servlet.ServletContainerInitializer接口的类，如果能发现的话，就会用它来配置Servlet容器。

Spring提供了这个接口的实现，名为SpringServletContainerInitializer，这个类反过来又会查找实现WebApplicationInitializer的类并将配置的任务交给它们来完成。Spring 3.2引入了一个便利的WebApplicationInitializer基础实现，也就是AbstractAnnotationConfigDispatcherServletInitializer。

因为上面的SpittrWebAppInitializer扩展了AbstractAnnotationConfigDispatcherServletInitializer（同时也就实现了WebApplicationInitializer），因此当部署到Servlet 3.0容器中的时候，容器会自动发现它，并用它来配置Servlet上下文。

**两个应用上下文之间的故事**

当DispatcherServlet启动的时候，它会创建Spring应用上下文，并加载配置文件或配置类中所声明的bean。

但是在Spring Web应用中，通常还会有另外一个由ContextLoaderListener创建的应用上下文。

DispatcherServlet加载包含Web组件的bean，如控制器、视图解析器以及处理器映射，而ContextLoaderListener要加载应用中的其他bean。这些bean通常是驱动应用后端的中间层和数据层组件。

getServletConfigClasses()方法返回的带有@Configuration注解的类将会用来定义DispatcherServlet应用上下文中的bean。getRootConfigClasses()方法返回的带有@Configuration注解的类将会用来配置ContextLoaderListener创建的应用上下文中的bean。

**启用Spring MVC**

启用Spring MVC组件的方法不仅一种，所能创建的最简单的Spring MVC配置就是一个带有@EnableWebMvc注解的类：

```java
package spittr.config;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;

@Configuration
@EnableWebMvc
public class WebConfig {
}

```

这可以运行起来，它的确能够启用Spring MVC，但还有不少问题要解决：

+ 没有配置视图解析器。如果这样的话，Spring默认会使用BeanNameView-Resolver，这个视图解析器会查找ID与视图名称匹配的bean，并且查找的bean要实现View接口，它以这样的方式来解析视图。
+ 没有启用组件扫描。这样的结果就是，Spring只能找到显式声明在配置类中的控制器。
+ 这样配置的话，DispatcherServlet会映射为应用的默认Servlet，所以它会处理所有的请求，包括对静态资源的请求，如图片和样式表（在大多数情况下，这可能并不是想要的效果）。

因此，需要在WebConfig这个最小的Spring MVC配置上再加一些内容：

```java
package spittr.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.ViewResolver;
import org.springframework.web.servlet.config.annotation.DefaultServletHandlerConfigurer;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
import org.springframework.web.servlet.view.InternalResourceViewResolver;

@Configuration
@EnableWebMvc // 启用Spring MVC
@ComponentScan("spittr.web") // 启用组件扫描，将会扫描spittr.web包来查找组件
public class WebConfig extends WebMvcConfigurerAdapter {

    @Bean // 添加了一个ViewResolver bean
    public ViewResolver viewResolver() { // 配置JSP视图解析器
        // InternalResourceViewResolver会查找JSP文件，在查找的时候，它会在视图名称上加一个特定的前缀和后缀
        // 例如，名为home的视图将会解析为/WEB-INF/views/home.jsp
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();
        resolver.setPrefix("/WEB-INF/views/");
        resolver.setSuffix(".jsp");
        resolver.setExposeContextBeansAsAttributes(true);
        return resolver;
    }

    // 新的WebConfig类还扩展了WebMvcConfigurerAdapter并重写了其configureDefaultServletHandling()方法
    @Override
    public void configureDefaultServletHandling(DefaultServletHandlerConfigurer configurer) {
        // 通过调用DefaultServletHandlerConfigurer的enable()方法，
        // 要求DispatcherServlet将对静态资源的请求转发到Servlet容器中默认的Servlet上，
        // 而不是使用DispatcherServlet本身来处理此类请求
        configurer.enable(); 
    }
}
```

因为这里聚焦于Web开发，而Web相关的配置通过DispatcherServlet创建的应用上下文都已经配置好了，因此现在的RootConfig相对很简单：

```java
package spittr.config;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.ComponentScan.Filter;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.FilterType;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;

@Configuration
// RootConfig使用了@ComponentScan注解。这样的话，就有很多机会用非Web的组件来充实完善RootConfig。
@ComponentScan(basePackages = {"spittr"}, excludeFilters = {
        @Filter(type = FilterType.ANNOTATION, value = EnableWebMvc.class)})
public class RootConfig {
}
```

#### 5.1.3 Spittr应用简介

为了实现在线社交的功能，这里将要构建一个简单的微博（microblogging）应用。类似Twitter，会添加一些小的变化。当然，要使用Spring技术来构建这个应用。

Spittr应用有两个基本的领域概念：Spitter（应用的用户）和Spittle（用户发布的简短状态更新）。这里，会构建应用的Web层，创建展现Spittle的控制器以及处理用户注册成为Spitter的表单。

### 5.2 编写基本的控制器

在Spring MVC中，控制器只是方法上添加了@RequestMapping注解的类，这个注解声明了它们所要处理的请求。

开始的时候，尽可能简单，假设控制器类要处理对“/”的请求，并渲染应用的首页：

```java
package spittr.web;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import static org.springframework.web.bind.annotation.RequestMethod.GET;

@Controller  // 声明为一个控制器，将其声明为Spring应用上下文中的一个bean
public class HomeController {

    // @RequestMapping注解的value属性指定了这个方法要处理的请求路径，method属性细化了它所处理的HTTP方法
    @RequestMapping(value = "/", method = GET)  // 处理对"/"的GET请求
    public String home() {
        // 返回"home"，该String将会被Spring MVC解读为要渲染的视图名称
        // DispatcherServlet会要求视图解析器将这个逻辑名称解析为实际的视图
        return "home";  // 这里"home"会被解析为"/WEB-INF/views/home.jsp"路径的JSP
    }
}

```

Spittr应用的首页，定义为一个简单的JSP：

```jsp
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
    <title>Spitter</title>
    <link rel="stylesheet"
          type="text/css"
          href="<c:url value="/resources/style.css" />" >
</head>
<body>
<h1>Welcome to Spitter</h1>

<%-- 提供两个链接，一个用于查看Spittle列表，另一个用于注册 --%>
<a href="<c:url value="/spittles" />">Spittles</a> |
<a href="<c:url value="/spitter/register" />">Register</a>
</body>
</html>

```

#### 5.2.1 测试控制器

从Spring 3.2开始，可以按照控制器的方式来测试Spring MVC中的控制器了，而不仅仅是作为POJO进行测试。Spring现在包含了一种mock Spring MVC并针对控制器执行HTTP请求的机制。这样的话，在测试控制器的时候，就没有必要再启动Web服务器和Web浏览器了：

```java
package spittr.web;
import org.junit.Test;
import org.springframework.test.web.servlet.MockMvc;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.view;
import static org.springframework.test.web.servlet.setup.MockMvcBuilders.standaloneSetup;

public class HomeControllerTest {

    @Test
    public void testHomePage() throws Exception {
        HomeController controller = new HomeController();
        // 搭建MockMvc
        MockMvc mockMvc = standaloneSetup(controller).build();
        // 对"/"执行GET请求
        mockMvc.perform(get("/"))
            .andExpect(view().name("home")); // 预期得到home视图
    }
}
```

#### 5.2.2 定义类级别的请求处理

对HomeController进行重构，拆分@RequestMapping，并将其路径映射部分放到类级别上：

```java
package spittr.web;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import static org.springframework.web.bind.annotation.RequestMethod.GET;

@Controller
@RequestMapping(value = "/") // 将控制器映射到"/"
public class HomeController {
    
    @RequestMapping(method = GET) // 处理GET请求
    public String home() {
        return "home"; // 视图名为home
    }
}

```

在修改@RequestMapping时，还可以对HomeController做另外一个变更。@RequestMapping的value属性能够接受一个String类型的数组：

```java
@Controller
// 现在，HomeController能映射到对“/”和“/homepage”的GET请求
@RequestMapping(value = {"/", "/homepage"}) 
public class HomeController {
    ...
}
```

#### 5.2.3 传递模型数据到视图中

在Spittr应用中，有一个页面展现最近提交的Spittle列表。因此，需要一个新的方法来处理这个页面。

首先，定义一个数据访问的Repository。为了实现解耦以及避免陷入数据库访问的细节之中，将其Repository定义为一个接口：

```java
package spittr.data;

import spittr.Spittle;
import java.util.List;

public interface SpittleRepository {
    // max参数表示返回的Spittle中ID最大值，count表示要返回的Spittle数目
    List<Spittle> findSpittles(long max, int count);
}
```

创建SpittleController，在模型中放入最新的spittle列表：

```java
package spittr.web;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import spittr.data.SpittleRepository;

@Controller
@RequestMapping("/spittles")
public class SpittleController {
    private SpittleRepository spittleRepository;

    @Autowired // 注入SpittleRepository
    public void SpittleController(SpittleRepository spittleRepository) {
        this.spittleRepository = spittleRepository;
    }

    @RequestMapping(method = RequestMethod.GET)
    public String spittles(Model model) {
        // 将spittles添加到Model中
        // Model实际上是一个Map，它会传递给视图，这样数据就能渲染到客户端了
        // 当调用addAttribute()方法并且不指定key时，key会自动根据对象类型进行推断
        // 本例中，因为是一个List<Spittle>，因此，键会推断为spittleList
        model.addAttribute(spittleRepository.findSpittles(Long.MAX_VALUE, 20));
        return "spittles"; // 返回视图名
    }
}

```

测试SpittleController处理针对"/spittles"的GET请求：

```java
package spittr.web;
import org.junit.Test;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.web.servlet.view.InternalResourceView;
import spittr.Spittle;
import spittr.data.SpittleRepository;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import static org.hamcrest.Matchers.hasItems;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.model;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.view;
import static org.springframework.test.web.servlet.setup.MockMvcBuilders.standaloneSetup;

public class SpittleControllerTest {
    // 这个测试对“/spittles”发起GET请求，
    // 然后断言视图的名称为spittles并且模型中包含名为spittleList的属性，
    // 在spittleList中包含预期的内容
    @Test
    public void shouldShowRecentSpittles() throws Exception {
        List<Spittle> expectedSpittles = createSpittleList(20);
        // 创建SpittleRepository接口的mock实现
        SpittleRepository mockRepository = mock(SpittleRepository.class);
        // 该实现会从findSpittles()返回20个Spittle对象
        when(mockRepository.findSpittles(Long.MAX_VALUE, 20)).thenReturn(expectedSpittles);
        // 将这个mockRepository注入到新的SpittleController中
        SpittleController controller = new SpittleController(mockRepository);

        // 创建MockMvc并使用这个控制器
        MockMvc mockMvc = standaloneSetup(controller)
                // MockMvc构造器上调用了setSingleView()，这样，mock框架就不用解析控制器的视图名了
                // 这里这么做的原因是因为视图名与请求路径非常相似，按照默认的视图解析规则时
                // MockMvc就会发生失败，因为无法区分视图路径和控制器的路径
                .setSingleView(new InternalResourceView("/WEB-INF/views/spittles.jsp"))
                .build();

        mockMvc.perform(get("/spittles"))
                .andExpect(view().name("spittles"))
                .andExpect(model().attributeExists("spittleList"))
                .andExpect(model().attribute("spittleList",
                        hasItems(expectedSpittles.toArray())));
    }

    private List<Spittle> createSpittleList(int count) {
        List<Spittle> spittles = new ArrayList<Spittle>();
        for (int i = 0; i < count; i++) {
            spittles.add(new Spittle("Spittle " + i, new Date()));
        }
        return spittles;
    }
}

```

### 5.3 接收请求的输入

Spring MVC允许以多种方式将客户端中的数据传送到控制器的处理器方法中，包括：

+ 查询参数（Query Parameter）
+ 表单参数（Form Parameter）
+ 路径变量（Path Variable）

#### 5.3.1 处理查询参数

在Spittr应用中，可能需要处理的一件事就是展现分页的Spittle列表。为了实现这个分页的功能，所编写的处理器方法要接受如下的参数：

+ before参数（表明结果中所有的Spittle的ID均应该在这个值之前）
+ count参数（表明在结果中要包含的Spittle数量）

为了实现该功能，对SpittleController中的spittles()方法进行修改：

```java
@Controller
@RequestMapping("/spittles")
public class SpittleController {

    private static final String MAX_LONG_AS_STRING = "9223372036854775807";

    private SpittleRepository spittleRepository;

    @Autowired
    public SpittleController(SpittleRepository spittleRepository) {
        this.spittleRepository = spittleRepository;
    }

    // 修改spittles()方法，使其能够同时处理有参数和无参数的场景
    @RequestMapping(method = RequestMethod.GET)
    public List<Spittle> spittles(
            @RequestParam(value = "max", defaultValue = MAX_LONG_AS_STRING) long max,
            @RequestParam(value = "count", defaultValue = "20") int count) {
        // 该方法较之前比较特别，没有返回视图名称，也没有显式的指定Model，方法返回的是Spittle列表
        // 当处理器方法像这样返回对象或集合时，这个值会放到模型中，模型的key会根据其类型推断得出（即为spittleList）
        // 逻辑视图的名称将会根据请求路径推断得出，因为这个方法处理针对“/spittles”的GET请求，因此视图的名称将会是spittles
        return spittleRepository.findSpittles(max, count);
    }
}
```

添加一个测试，这个测试反映了新spittles()方法的功能：

```java
@Test
public void shouldShowPagedSpittles() throws Exception {
    List<Spittle> expectedSpittles = createSpittleList(50);
    SpittleRepository mockRepository = mock(SpittleRepository.class);
    // findSpittles()方法中包含预期的max和count参数
    when(mockRepository.findSpittles(238900, 50)).thenReturn(expectedSpittles);

    SpittleController controller = new SpittleController(mockRepository);

    MockMvc mockMvc = standaloneSetup(controller)
        .setSingleView(new InternalResourceView("/WEB-INF/views/spittles.jsp"))
        .build();

    // 传入max和count参数
    mockMvc.perform(get("/spittles?max=238900&count=50"))
        .andExpect(view().name("spittles"))
        .andExpect(model().attributeExists("spittleList"))
        .andExpect(model().attribute("spittleList",
                                     hasItems(expectedSpittles.toArray())));
}
```

#### 5.3.2 通过路径参数接收输入 

假设应用程序需要根据给定的ID来展现某一个Spittle记录。在理想情况下，要识别的资源（Spittle）应该通过URL路径进行标示，而不是通过查询参数。对“/spittles/12345”发起GET请求要优于对“/spittles/show?spittle_id=12345”发起请求。

为此，需要在SpittleController中为其添加新的方法：

```java
// 为了实现这种路径变量，Spring MVC允许在@RequestMapping路径中添加占位符（占位符名称要用"{}"括起来）
// 因为方法的参数名碰巧与占位符的名称相同，故而可以省略@PathVariable中的value属性（这里给出了）
@RequestMapping(value = "/{spittleId}", method = RequestMethod.GET)
public String spittle(@PathVariable(value = "spittleId") long spittleId, Model model) {
    // spittle()方法会将参数传递到SpittleRepository的findOne()方法中，
    // 用来获取某个Spittle对象，然后将Spittle对象添加到模型中
    model.addAttribute(spittleRepository.findOne(spittleId));
    return "spittle";
}
```

测试对某个Spittle的请求，其中ID要在路径变量中指定：

```java
@Test
public void testSpittle() throws Exception {
    Spittle expectedSpittle = new Spittle("Hello", new Date());
    
    SpittleRepository mockRepository = mock(SpittleRepository.class);
    when(mockRepository.findOne(12345)).thenReturn(expectedSpittle);
    SpittleController controller = new SpittleController(mockRepository);
    MockMvc mockMvc = standaloneSetup(controller).build();
    
    mockMvc.perform(get("/spittles/12345")) // 通过路径请求资源
        .andExpect(view().name("spittle"))
        .andExpect(model().attributeExists("spittle"))
        .andExpect(model().attribute("spittle", expectedSpittle));
}
```

### 5.4 处理表单

像提供内容一样，Spring MVC的控制器也为表单处理提供了良好的支持。

使用表单分为两个方面：展现表单以及处理用户通过表单提交的数据。在Spittr应用中，需要有个表单让新用户进行注册。SpitterController是一个新的控制器，目前只有一个请求处理的方法来展现注册表单：

```java
package spittr.web;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/spitter")
public class SpitterController {
    // 处理对"/spitter/register"的GET请求
    @RequestMapping(value = "/register", method = RequestMethod.GET)
    public String showRegistrationForm(){
        return "registerForm";
    }
}
```

测试展现表单的控制器方法：

```java
package spittr.web;
import org.junit.Test;
import org.springframework.test.web.servlet.MockMvc;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.view;
import static org.springframework.test.web.servlet.setup.MockMvcBuilders.standaloneSetup;

public class SpitterControllerTest {

    @Test
    public void shouldShowRegisteration() throws Exception {
        SpitterController controller = new SpitterController();
        // 构建MockMvc
        MockMvc mockMvc = standaloneSetup(controller).build();
        mockMvc.perform(get("/spitter/register"))
                .andExpect(view().name("registerForm")); // 断言registerForm视图
    }
}

```

#### 5.4.1 编写处理表单的控制器

当处理注册表单的POST请求时，控制器需要接受表单数据并将表单数据保存为Spitter对象。最后，为了防止重复提交，应该将浏览器重定向到新创建用户的基本信息页面：

```java
@Controller
@RequestMapping("/spitter")
public class SpitterController {

    private SpitterRepository spitterRepository;

    @Autowired // 注入SpitterRepository
    public SpitterController(SpitterRepository spitterRepository) {
        this.spitterRepository = spitterRepository;
    }

    @RequestMapping(value = "/register", method = RequestMethod.GET)
    public String showRegistrationForm() {
        return "registerForm";
    }

    // 创建processRegistration()方法，它接受一个Spitter对象作为参数
    // Spitter对象中的属性将会使用请求中同名的参数进行填充
    @RequestMapping(value = "/register", method = RequestMethod.POST)
    public String processRegistration(Spitter spitter) {
        spitterRepository.save(spitter);  // 调用SpitterRepository的save()方法保存Spitter
        // 当InternalResourceViewResolver看到视图格式中的"redirect:"前缀时，
        // 它会要将其解析为重定向的规则，而不是视图的名称;
        // InternalResourceViewResolver还能识别"forward:"前缀，
        // 当它发现视图格式中以“forward:”作为前缀时，
        // 请求将会前往（forward）指定的URL路径，而不再是重定向
        return "redirect:/spitter/" + spitter.getUsername(); // 重定向到用户的基本信息页
    }
}

```

测试SpitterController中处理表单的方法：

```java
    @Test
    public void shouldProcessRegistration() throws Exception {
        SpitterRepository mockRepository = mock(SpitterRepository.class);
        Spitter unsaved = new Spitter("angus", "123456", "Angus", "Liu", "angus.liu96@gmail.com");
        Spitter saved = new Spitter("angus", "123456", "Angus", "Liu", "angus.liu96@gmail.com");

        when(mockRepository.save(unsaved)).thenReturn(saved);

        SpitterController controller = new SpitterController(mockRepository);

        MockMvc mockMvc = standaloneSetup(controller).build();

        mockMvc.perform(post("/spitter/register")
                .param("username", "angus")
                .param("password", "123456")
                .param("firstName", "Angus")
                .param("lastName", "Liu")
                .param("email", "angus.liu96@gmail.com"))
                .andExpect(redirectedUrl("/spitter/angus"));
        verify(mockRepository, atLeastOnce()).save(unsaved);
    }
```

往SpitterController中添加一个处理器方法，用来处理对基本信息页面的请求：

```java
@RequestMapping(value = "/{username}", method = RequestMethod.GET)
public String showSpitterProfile(@PathVariable String username, Model model){
    Spitter spitter = spitterRepository.findByUsername(username);
    model.addAttribute(spitter);
    return "profile";
}
```

#### 5.4.2 校验表单

从Spring 3.0开始，在Spring MVC中提供了对Java校验API（Java Validation API，又称JSR-303）的支持。在Spring MVC中要使用Java校验API的话，并不需要什么额外的配置。只要保证在类路径下包含这个Java API的实现即可，比如Hibernate Validator。

Java校验API定义了多个注解，这些注解可以放到属性上，从而限制这些属性的值。所有的注解都位于javax.validation.constraints包中：

| 注解         | 描述                                                         |
| ------------ | ------------------------------------------------------------ |
| @AssertFalse | 所注解的元素必须是Boolean类型，并且值为false                 |
| @AssertTrue  | 所注解的元素必须是Boolean类型，并且值为true                  |
| @DecimalMax  | 所注解的元素必须是数字，并且它的值要小于或等于给定的BigDecimalString值 |
| @DecimalMin  | 所注解的元素必须是数字，并且它的值要大于或等于给定的BigDecimalString值 |
| @Digits      | 所注解的元素必须是数字，并且它的值必须有指定的位数           |
| @Future      | 所注解的元素的值必须是一个将来的日期                         |
| @Max         | 所注解的元素必须是数字，并且它的值要小于或等于给定的值       |
| @Min         | 所注解的元素必须是数字，并且它的值要大于或等于给定的值       |
| @NotNull     | 所注解元素的值必须不能为null                                 |
| @Null        | 所注解元素的值必须为null                                     |
| @Past        | 所注解的元素的值必须是一个已过去的日期                       |
| @Pattern     | 所注解的元素的值必须匹配给定的正则表达式                     |
| @Size        | 所注解的元素的值必须是String、集合或数组，并且它的长度要符合给定的范围 |

如下的程序清单展现了Spitter类，它的属性已经添加了校验注解：

```java
package spittr;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import org.apache.commons.lang3.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.HashCodeBuilder;
import org.hibernate.validator.constraints.Email;

public class Spitter {

    private Long id;

    // Spitter的所有属性都添加了@NotNull注解，以确保它们的值不为null
    // 属性上也添加了@Size注解以限制它们的长度在最大值和最小值之间
    @NotNull // 非空
    @Size(min=5, max=16) // 5-16个字符
    private String username;

    @NotNull
    @Size(min=5, max=25)
    private String password;

    @NotNull
    @Size(min=2, max=30)
    private String firstName;

    @NotNull
    @Size(min=2, max=30)
    private String lastName;

    @NotNull
    @Email
    private String email;
    ...
}
```

接下来需要修改processRegistration()方法来应用校验功能：

```java
// 校验Spitter输入
@RequestMapping(value = "/register", method = RequestMethod.POST)
// Spitter参数添加了@Valid注解，这会告知Spring，需要确保这个对象满足校验限制
// 如果有校验出现错误的话，那么这些错误可以通过Errors对象进行访问（Errors参数要紧跟在带有@Valid注解的参数后面）
public String processRegistration(@Valid Spitter spitter, Errors errors) {
    // 如果校验出现错误，则重新返回表单
    if (errors.hasErrors()) {
        return "registerForm";
    }
    spitterRepository.save(spitter);
    return "redirect:/spitter/" + spitter.getUsername();
}
```

### 5.5 小结

借助于注解，Spring MVC提供了近似于POJO的开发模式，这使得开发处理请求的控制器变得非常简单，同时也易于测试。

当编写控制器的处理器方法时，Spring MVC极其灵活。概括来讲，如果处理器方法需要内容的话，只需将对应的对象作为参数，而它不需要的内容，则没有必要出现在参数列表中。这样，就为请求处理带来了无限的可能性，同时还能保持一种简单的编程模型。









