### 16.1 了解REST

近几年来，以信息为中心的表述性状态转移（Representational State Transfer，REST）已成为替换传统SOAP Web服务（Simple Object Access Protocol，简单对象访问协议）的流行方案。SOAP一般会关注行为和处理，而REST关注的是要处理的数据。:point_right:[ "SOAP vs REST"](http://www.soapui.org/learn/api/soap-vs-rest-api.html)

#### 16.1.1 REST的基础知识

REST与RPC（remote procedure call，远程过程调用）几乎没有任何关系。RPC是面向服务的，并关注于行为和动作；而REST是面向资源的，强调描述应用程序的事物和名词。

根据REST的名词，可得其有下列特性：

+ 表述性（Representational）：REST资源实际上可以用各种形式来进行表述，包括XML、JSON（JavaScript Object Notation）甚至HTML——最适合资源使用者的任意形式；
+ 状态（State）：当使用REST的时候，更关注资源的状态而不是对资源采取的行动；
+ 转移（Transfer）：REST涉及到转移资源数据，它以某种表述性形式从一个应用转移到另一个应用。

更简洁地讲，REST就是将资源的状态以最适合客户端或服务端的形式从服务器端转移到客户端（或者反过来）。在REST中，资源通过URL进行识别和定位。至于RESTful URL的结构并没有严格的规则，但是URL应该能够识别资源，而不是简单的发一条命令到服务器上。

REST中会有行为，它们是通过HTTP方法来定义的。具体来讲，也就是GET、POST、PUT、DELETE、PATCH以及其他的HTTP方法构成了REST中的动作。这些HTTP方法通常会匹配为如下的CRUD动作：

+ Create：POST
+ Read：GET
+ Update：PUT或PATCH
+ Delete：DELETE

一些参考链接：

+ [RESTful 手册 cookbook](https://sofish.github.io/restcookbook/)

+ [理解HTTP幂等性](https://www.cnblogs.com/weidagang2046/archive/2011/06/04/idempotence.html)

#### 16.1.2  Spring是如何支持REST的

Spring支持以下方式来创建REST资源：

+ 控制器可以处理所有的HTTP方法，包含四个主要的REST方法：GET、PUT、DELETE以及POST。Spring 3.2及以上版本还支持PATCH方法；
+ 借助@PathVariable注解，控制器能够处理参数化的URL（将变量输入作为URL的一部分）；
+ 借助Spring的视图和视图解析器，资源能够以多种方式进行表述，包括将模型数据渲染为XML、JSON、Atom以及RSS的View实现；
+ 可以使用ContentNegotiatingViewResolver来选择最适合客户端的表述；
+ 借助@ResponseBody注解和各种HttpMethodConverter实现，能够替换基于视图的渲染方式；
+ 类似地，@RequestBody注解以及HttpMethodConverter实现可以将传入的HTTP数据转化为传入控制器处理方法的Java对象；
+ 借助RestTemplate，Spring应用能够方便地使用REST资源。

### 16.2 创建第一个REST端点

实现RESTful功能的Spring MVC控制器：

```java
package spittr.web;
import java.util.Date;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import spittr.Spittle;
import spittr.data.SpittleRepository;

@Controller
@RequestMapping("/spittles")
public class SpittleController {

    private static final String MAX_LONG_AS_STRING = "9223372036854775807";

    private SpittleRepository spittleRepository;

    @Autowired
    public SpittleController(SpittleRepository spittleRepository) {
        this.spittleRepository = spittleRepository;
    }

    // 当发起对"/spittles"的GET请求时，将会调用spittles()方法
    @RequestMapping(method=RequestMethod.GET)
    public List<Spittle> spittles(
        @RequestParam(value="max", defaultValue=MAX_LONG_AS_STRING) long max,
        @RequestParam(value="count", defaultValue="20") int count) {
        return spittleRepository.findSpittles(max, count);
    }
}
```

Spring提供了两种方法将资源的Java表述形式转换为发送给客户端的表述形式：

+ 内容协商（Content negotiation）：选择一个视图，它能够将模型渲染为呈现给客户端的表述形式；
+ 消息转换器（Message conversion）：通过一个消息转换器将控制器所返回的对象转换为呈现给客户端的表述形式。

#### 16.2.1 协商资源表述 

当控制器的处理方法完成时，通常会返回一个逻辑视图名。如果方法不直接返回逻辑视图名（例如方法返回void），那么逻辑视图名会根据请求的URL判断得出。DispatcherServlet接下来会将视图的名字传递给一个视图解析器，要求它来帮助确定应该用哪个视图来渲染请求结果。

在面向人类访问的Web应用程序中，选择的视图通常来讲都会渲染为HTML。视图解析方案是个简单的一维活动。如果根据视图名匹配上了视图，那这就是需要的视图了。

当要将视图名解析为能够产生资源表述的视图时，就有另外一个维度需要考虑了。视图不仅要匹配视图名，而且所选择的视图要适合客户端。如果客户端想要JSON，那么渲染HTML的视图就不行了——尽管视图名可能匹配。

Spring的ContentNegotiatingViewResolver是一个特殊的视图解析器，它考虑到了客户端所需要的内容类型。按照其最简单的形式，ContentNegotiatingViewResolver可以按照下述形式进行配置：

```java
@Bean
public ViewResolver cnViewer() {
    return new ContentNegotiatingViewResolver();
}
```

在这个简单的bean声明背后会涉及到很多事情。要理解ContentNegotiatingViewResolver是如何工作的，这涉及内容协商的两个步骤：

1. 确定请求的媒体类型；
2. 找到适合请求媒体类型的最佳视图。

**确定请求的媒体类型**

ContentNegotiatingViewResolver将会考虑到Accept头部信息并使用它所请求的媒体类型，但是它会首先查看URL的文件扩展名。如果URL在结尾处有文件扩展名的话，ContentNegotiatingViewResolver将会基于该扩展名确定所需的类型。如果扩展名是“.json”的话，那么所需的内容类型必须是“application/json”。如果扩展名是“.xml”，那么客户端请求的就是“application/xml”。当然，“.html”扩展名表明客户端所需的资源表述为HTML（text/html）。

如果根据文件扩展名不能得到任何媒体类型的话，那就会考虑请求中的Accept头部信息。在这种情况下，Accept头部信息中的值就表明了客户端想要的MIME类型，没有必要再去查找了。

最后，如果没有Accept头部信息，并且扩展名也无法提供帮助的话，ContentNegotiatingViewResolver将会使用“/”作为默认的内容类型，这就意味着客户端必须要接收服务器发送的任何形式的表述。

一旦内容类型确定之后，ContentNegotiatingViewResolver就该将逻辑视图名解析为渲染模型的View。与Spring的其他视图解析器不同，ContentNegotiatingViewResolver本身不会解析视图。而是委托给其他的视图解析器，让它们来解析视图。

ContentNegotiatingViewResolver要求其他的视图解析器将逻辑视图名解析为视图。解析得到的每个视图都会放到一个列表中。这个列表装配完成后，ContentNegotiatingViewResolver会循环客户端请求的所有媒体类型，在候选的视图中查找能够产生对应内容类型的视图。第一个匹配的视图会用来渲染模型。

**影响媒体类型的选择**

在上述的选择过程中，阐述了确定所请求媒体类型的默认策略。通过为其设置一个ContentNegotiationManager，能够改变它的行为。借助ContentNegotiationManager所能做到的事情如下所示：

+ 指定默认的内容类型，如果根据请求无法得到内容类型的话，将会使用默认值；
+ 通过请求参数指定内容类型；
+ 忽视请求的Accept头部信息；
+ 将请求的扩展名映射为特定的媒体类型；
+ 将JAF（Java Activation Framework）作为根据扩展名查找媒体类型的备用方案。

有三种配置ContentNegotiationManager的方法：

+ 直接声明一个ContentNegotiationManager类型的bean；
+ 通过ContentNegotiationManagerFactoryBean间接创建bean；
+ 重载WebMvcConfigurerAdapter的configureContentNegotiation()方法。

一般而言，如果使用XML配置ContentNegotiationManager的话，那最有用的将会是ContentNegotiationManagerFactoryBean。例如，可能希望在XML中配置ContentNegotiationManager使用“application/json”作为默认的内容类型：

```xml
<!-- 因为ContentNegotiationManagerFactoryBean是FactoryBean的实现，
     所以它会创建一个ContentNegotiationManager bean。
     这个ContentNegotiationManager能够注入到
     ContentNegotiatingViewResolver的contentNegotiationManager属性中。 -->
<bean id="contentNegotiationManager"
      class="org.springframework.http.ContentNegotiationManagerFactoryBean"
      p:defaultContentType="application/json">
```

如果使用Java配置的话，获得ContentNegotiationManager的最简便方法就是扩展WebMvcConfigurerAdapter并重载configureContentNegotiation()方法。在创建Spring MVC应用的时候，很可能已经扩展了WebMvcConfigurerAdapter。例如，在Spittr应用中，已经有了WebMvcConfigurerAdapter的扩展类，名为WebConfig，所以需要做的就是重载configureContentNegotiation()方法。如下就是configureContentNegotiation()的一个实现，它设置了默认的内容类型：

```java
// configureContentNegotiation()方法给定了一个Content-NegotiationConfigurer对象。
// ContentNegotiationConfigurer中的一些方法对应于ContentNegotiationManager的Setter方法，
// 这样就能在ContentNegotiation-Manager创建时，设置任意内容协商相关的属性
@Override
public void configureContentNegotiation(ContentNegotiationConfigurer configurer) {
    // 调用defaultContentType()方法将默认的内容类型设置为"application/json"
    configurer.defaultContentType(MediaType.APPLICATION_JSON);
}
```

现在，已经有了ContentNegotiationManagerbean，接下来就需要将它注入到ContentNegotiatingViewResolver的contentNegotiationManager属性中。这需要稍微修改一下之前声明ContentNegotiatingViewResolver的@Bean方法：

```java
@Bean
public ViewResolver cnViewResolver(ContentNegotiationManager cnm) {
    // 这个@Bean方法注入了ContentNegotiationManager，
    // 并使用它调用了setContentNegotiationManager()。
    // 这样的结果就是ContentNegotiatingViewResolver
    // 将会使用ContentNegotiationManager所定义的行为
    ContentNegotiatingViewResolver cnvr = new ContentNegotiatingViewResolver();
    cnvr.setContentNegotiationManager(cnm);
    return cnvr;
}
```

ContentNegotiationManager简单配置样例：

```java
// ContentNegotiatingViewResolver一旦能够确定客户端想要什么样的媒体类型，
// 接下来就是查找渲染这种内容的视图
@Bean
public ViewResolver cnViewResolver(ContentNegotiationManager cnm) {
    ContentNegotiatingViewResolver cnvr = new ContentNegotiatingViewResolver();
    cnvr.setContentNegotiationManager(cnm);
    return cnvr;
}

@Override
public void configureContentNegotiation(ContentNegotiationConfigurer configurer) {
    // 默认为HTML
    configurer.defaultContentType(MediaType.TEXT_HTML);
}

// 以bean的形式查找视图
// 如果逻辑视图的名称为“spittles”，
// 那么所配置的BeanNameViewResolver将会解析spittles()方法中所声明的View。
// 这是因为bean名称匹配逻辑视图的名称。
// 如果没有匹配的View的话，ContentNegotiatingViewResolver将会采用默认的行为，
// 将其输出为HTML。
@Bean
public ViewResolver beanNameViewResolver() {
    return new BeanNameViewResolver();
}

@Bean
public View spittles() {
    // 将"spittles"定义为JSON视图
    return new MappingJackson2JsonView();
}
```

**ContentNegotiatingViewResolver的优势与限制**

ContentNegotiatingViewResolver最大的优势在于，它在Spring MVC之上构建了REST资源表述层，控制器代码无需修改。相同的一套控制器方法能够为面向人类的用户产生HTML内容，也能针对不是人类的客户端产生JSON或XML。

如果面向人类用户的接口与面向非人类客户端的接口之间有很多重叠的话，那么内容协商是一种很便利的方案。在实践中，面向人类用户的视图与REST API在细节上很少能够处于相同的级别。如果面向人类用户的接口与面向非人类客户端的接口之间没有太多重叠的话，那么ContentNegotiatingViewResolver的优势就体现不出来了。

ContentNegotiatingViewResolver还有一个严重的限制。作为ViewResolver的实现，它只能决定资源该如何渲染到客户端，并没有涉及到客户端要发送什么样的表述给控制器使用。如果客户端发送JSON或XML的话，那么ContentNegotiatingViewResolver就无法提供帮助了。

ContentNegotiatingViewResolver还有一个相关的小问题，所选中的View会渲染模型给客户端，而不是资源。这里有个细微但很重要的区别。当客户端请求JSON格式的Spittle对象列表时，客户端希望得到的响应可能如下所示：

```json
[
    {
        "id": 42,
        "latitude": 28.419489,
        "longitude": -81.581184,
        "message": "Hello World!",
        "time": 1400389200000
    },
    {
        "id": 43,
        "latitude": 28.419136,
        "longitude": -81.577225,
        "message": "Blast off!",
        "time": 1400475600000
    }
]
```

而模型是key-value组成的Map，那么响应可能会如下所示：

```json
{
    "spittleList": [
        {
            "id": 42,
            "latitude": 28.419489,
            "longitude": -81.581184,
            "message": "Hello World!",
            "time": 1400389200000
        },
        {
            "id": 43,
            "latitude": 28.419136,
            "longitude": -81.577225,
            "message": "Blast off!",
            "time": 1400475600000
        }
    ]
}
```

尽管这不是很严重的问题，但确实可能不是客户端所预期的结果。

因为有这些限制，通常建议不要使用ContentNegotiatingViewResolver。更加倾向于使用Spring的消息转换功能来生成资源表述。

#### 16.2.2 使用HTTP信息转换器

消息转换（message conversion）提供了一种更为直接的方式，它能够将控制器产生的数据转换为服务于客户端的表述形式。当使用消息转换功能时，DispatcherServlet不再需要那么麻烦地将模型数据传送到视图中。实际上，这里根本就没有模型，也没有视图，只有控制器产生的数据，以及消息转换器（message converter）转换数据之后所产生的资源表述。

例如，假设客户端通过请求的Accept头信息表明它能接受“application/json”，并且Jackson JSON在类路径下，那么处理方法返回的对象将交给MappingJacksonHttpMessageConverter，并由它转换为返回客户端的JSON表述形式。另一方面，如果请求的头信息表明客户端想要“text/xml”格式，那么Jaxb2RootElementHttpMessageConverter将会为客户端产生XML响应。

Spring提供了多个HTTP信息转换器，用于实现资源表述与各种Java类型之间的互相转换：

| 信息转换器                           | 描述                                                         |
| ------------------------------------ | ------------------------------------------------------------ |
| AtomFeedHttpMessageConverter         | Rome Feed对象和Atom feed（媒体类型application/atom+xml）之间的互相转换。<br>如果 Rome 包在类路径下将会进行注册 |
| BufferedImageHttpMessageConverter    | BufferedImages与图片二进制数据之间互相转换                   |
| ByteArrayHttpMessageConverter        | 读取/写入字节数组。从所有媒体类型（*/*）中读取，并以application/octet-stream格式写入 |
| FormHttpMessageConverter             | 将application/x-www-form-urlencoded内容读入到MultiValueMap<String,String>中，也会将MultiValueMap<String,String>写入到application/x-www-form- urlencoded中或将MultiValueMap<String, Object>写入到multipart/form-data中 |
| Jaxb2RootElementHttpMessageConverter | 在XML（text/xml或application/xml）和使用JAXB2注解的对象间互相读取和写入。<br>如果 JAXB v2 库在类路径下，将进行注册 |
| MappingJacksonHttpMessageConverter   | 在JSON和类型化的对象或非类型化的HashMap间互相读取和写入。<br>如果 Jackson JSON 库在类路径下，将进行注册 |
| MappingJackson2HttpMessageConverter  | 在JSON和类型化的对象或非类型化的HashMap间互相读取和写入。<br>如果 Jackson 2 JSON 库在类路径下，将进行注册 |
| MarshallingHttpMessageConverter      | 使用注入的编排器和解排器（marshaller和unmarshaller）来读入和写入XML。支持的编排器和解排器包括Castor、JAXB2、JIBX、XMLBeans以及Xstream |
| ResourceHttpMessageConverter         | 读取或写入Resource                                           |
| RssChannelHttpMessageConverter       | 在RSS feed和Rome Channel对象间互相读取或写入。<br>如果 Rome 库在类路径下，将进行注册 |
| SourceHttpMessageConverter           | 在XML和javax.xml.transform.Source对象间互相读取和写入。<br>默认注册 |
| StringHttpMessageConverter           | 将所有媒体类型（*/*）读取为String。将String写入为text/plain  |
| XmlAwareFormHttpMessageConverter     | FormHttpMessageConverter的扩展，使用SourceHttp MessageConverter来支持基于XML的部分 |

**在响应体中返回资源状态**

正常情况下，当处理方法返回Java对象（除String外或View的实现以外）时，这个对象会放在模型中并在视图中渲染使用。但是，如果使用了消息转换功能的话，需要告诉Spring跳过正常的模型/视图流程，并使用消息转换器。有不少方式都能做到这一点，但是最简单的方法是为控制器方法添加@ResponseBody注解。

```java
// 注意getSpitter()的@RequestMapping注解。在这里，使用了produces属性表明这个方法只处理预期输出为JSON的请求。
// 也就是说，这个方法只会处理Accept头部信息包含“application/json”的请求。
// 其他任何类型的请求，即使它的URL匹配指定的路径并且是GET请求也不会被这个方法处理。
// 这样的请求会被其他的方法来进行处理（如果存在适当方法的话），或者返回客户端HTTP 406（Not Acceptable）响应
@RequestMapping(method=RequestMethod.GET, produces="application/json")
// @ResponseBody注解会告知Spring，要将返回的对象作为资源发送给客户端，并将其转换为客户端可接受的表述形式。
// 更具体地讲，DispatcherServlet将会考虑到请求中Accept头部信息，并查找能够为客户端提供所需表述形式的消息转换器。
public @ResponseBody List<Spittle> spittles(
    @RequestParam(value="max", defaultValue=MAX_LONG_AS_STRING) long max,
    @RequestParam(value="count", defaultValue="20") int count) {
    return spittleRepository.findSpittles(max, count);
}
```

假设客户端的Accept头部信息表明它接受“application/json”，并且Jackson JSON库位于应用的类路径下，那么将会选择MappingJacksonHttpMessageConverter或MappingJackson2HttpMessageConverter（这取决于类路径下是哪个版本的Jackson）。消息转换器会将控制器返回的Spittle列表转换为JSON文档，并将其写入到响应体中。响应大致会如下所示：

```json
[
    {
        "id": 42,
        "latitude": 28.419489,
        "longitude": -81.581184,
        "message": "Hello World!",
        "time": 1400389200000
    },
    {
        "id": 43,
        "latitude": 28.419136,
        "longitude": -81.577225,
        "message": "Blast off!",
        "time": 1400475600000
    }
]
```

**在请求体中接收资源状态**

@ResponseBody能够告诉Spring在把数据发送给客户端的时候，要使用某一个消息器，与之类似，@RequestBody也能告诉Spring查找一个消息转换器，将来自客户端的资源表述转换为对象。例如，假设需要一种方式将客户端提交的新Spittle保存起来。可以按照如下的方式编写控制器方法来处理这种请求：

```java
// @RequestMapping有一个consumes属性，这里将其设置为“application/ json”。
// consumes属性的工作方式类似于produces，不过它会关注请求的Content-Type头部信息。
// 它会告诉Spring这个方法只会处理对“/spittles”的POST请求，
// 并且要求请求的Content-Type头部信息为“application/json”。
// 如果无法满足这些条件的话，会由其他方法（如果存在合适的方法的话）来处理请求。
@RequestMapping(method=RequestMethod.POST, consumes="application/json")
// saveSpittle()是一个非常简单的方法。它接受一个Spittle对象作为参数，
// 并使用SpittleRepository进行保存，最终返回spittleRepository.save()方法所得到的Spittle对象。
public @ResponseBody Spittle saveSpittle(@RequestBody Spittle spittle) {
    return spittleRepository.save(spittle);
}
```

例如，如果客户端发送的Spittle数据是JSON表述形式，那么Content-Type头部信息可能就会是“application/json”。在这种情况下，DispatcherServlet会查找能够将JSON转换为Java对象的消息转换器。如果Jackson 2库在类路径中，那么MappingJackson2HttpMessageConverter将会担此重任，将JSON表述转换为Spittle，然后传递到saveSpittle()方法中。这个方法还使用了@ResponseBody注解，因此方法返回的Spittle对象将会转换为某种资源表述，发送给客户端。

**为控制器默认设置消息转换**

当处理请求时，@ResponseBody和@RequestBody是启用消息转换的一种简洁和强大方式。但是，如果所编写的控制器有多个方法，并且每个方法都需要信息转换功能的话，那么这些注解就会带来一定程度的重复性。

Spring 4.0引入了@RestController注解，能够在这个方面提供帮助。如果在控制器类上使用@RestController来代替@Controller的话，Spring将会为该控制器的所有处理方法应用消息转换功能。这样就不必为每个方法都添加@ResponseBody了。所定义的SpittleController可能就会如下所示：

```java
package spittr.api;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import spittr.Spittle;
import spittr.data.SpittleRepository;
// 控制器使用了@RestController，
// 所以它的方法所返回的对象将会通过消息转换机制，产生客户端所需的资源表述
@RestController
@RequestMapping("/spittles")
public class SpittleController {
    private static final String MAX_LONG_AS_STRING="9223372036854775807";
    private SpittleRepository spittleRepository;
    @Autowired
    public SpittleController(SpittleRepository spittleRepository) {
        this.spittleRepository = spittleRepository;
    }
    @RequestMapping(method=RequestMethod.GET)
    public List<Spittle> spittles(
        @RequestParam(value="max", defaultValue=MAX_LONG_AS_STRING) long max,
        @RequestParam(value="count", defaultValue="20") int count) {
        return spittleRepository.findSpittles(max, count);
    }
    @RequestMapping(method=RequestMethod.POST, consumes="application/json")
    public Spittle saveSpittle(@RequestBody Spittle spittle) {
        return spittleRepository.save(spittle);
    }
}
```

### 16.3　提供资源之外的其他内容

一个好的REST API不仅能够在客户端和服务器之间传递资源，它还能够给客户端提供额外的元数据，帮助客户端理解资源或者在请求中出现了什么情况。

#### 16.3.1 发送错误信息到客户端

Spring提供了多种方式来处理发生错误时的场景，例如客户端要求Spittle对象，但是它什么都没有得到：

+ 使用@ResponseStatus注解可以指定状态码；
+ 控制器方法可以返回ResponseEntity对象，该对象能够包含更多响应相关的元数据；
+ 异常处理器能够应对错误场景，这样处理器方法就能关注于正常的状况。

**使用ResponseEntity**

作为@ResponseBody的替代方案，控制器方法可以返回一个ResponseEntity对象。ResponseEntity中可以包含响应相关的元数据（如头部信息和状态码）以及要转换成资源表述的对象。因为ResponseEntity允许指定响应的状态码，所以当无法找到Spittle的时候，可以返回HTTP 404错误：

```java
@RequestMapping(value="/{id}", method=RequestMethod.GET)
// ResponseEntity还包含了@ResponseBody的语义，因此负载部分将会渲染到响应体中，
// 就像之前在方法上使用@ResponseBody注解一样。如果返回ResponseEntity的话，
// 那就没有必要在方法上使用@ResponseBody注解了
public ResponseEntity<Spittle> spittleById(@PathVariable long id) {
    Spittle spittle = spittleRepository.findOne(id);
    HttpStatus status = spittle != null ? HttpStatus.OK : HttpStatus.NOT_FOUND;
    return new ResponseEntity<Spittle>(spittle, status);
}
```

可能还会希望在响应体中包含一些错误信息，这是可以定义一个包含错误信息的Error对象：

```java
public class Error {
    private int code;
    private String message;
    public Error(int code, String message) {
        this.code = code;
        this.message = message;
    }
    public int getCode() {
        return code;
    }
    public String getMessage() {
        return message;
    }
}
```

修改spittleById()，让它可以返回Error：

```java
@RequestMapping(value="/{id}", method=RequestMethod.GET)
public ResponseEntity<?> spittleById(@PathVariable long id) {
    // 如果找到Spittle的话，就会把返回的对象以及200（OK）的状态码封装到ResponseEntity中。
    // 另一方面，如果findOne()返回null的话，将会创建一个Error对象，
    // 并将其与404（Not Found）状态码一起封装到ResponseEntity中，然后返回。
    Spittle spittle = spittleRepository.findOne(id);
    if (spittle == null) {
        Error error = new Error(4, "Spittle [" + id + "] not found");
        return new ResponseEntity<Error>(error, HttpStatus.NOT_FOUND);
    }
    return new ResponseEntity<Spittle>(spittle, HttpStatus.OK);
}
```

**处理错误**

spittleById()方法中的if代码块是处理错误的，但这是控制器中错误处理器（error handler）所擅长的领域。错误处理器能够处理导致问题的场景，这样常规的处理器方法就能只关心正常的逻辑处理路径了。

重构一下代码来使用错误处理器。首先，定义能够对应SpittleNotFoundException的错误处理器：

```java
// @ExceptionHandler注解能够用到控制器方法中，用来处理特定的异常。
// 这里，它表明如果在控制器的任意处理方法中抛出SpittleNotFoundException异常，
// 就会调用spittleNotFound()方法来处理异常。
@ExceptionHandler(SpittleNotFoundException.class)
public ResponseEntity<Error> spittleNotFound(SpittleNotFoundException e) {
    long spittleId = e.getSpittleId();
    Error error = new Error(4, "Spittle [" + spittleId + "] not found");
    return new ResponseEntity<Error>(error, HttpStatus.NOT_FOUND);
}
```

至于SpittleNotFoundException，它是一个很简单异常类：

```java
public class SpittleNotFoundException extends RuntimeException {
    private long spittleId;
    public SpittleNotFoundException(long spittleId) {
        this.spittleId = spittleId;
    }
    public long getSpittleId() {
        return spittleId;
    }
}
```

现在，可以移除掉spittleById()方法中大多数的错误处理代码，并且已经知道spittleById()将会返回Spittle并且HTTP状态码始终会是200（OK），那么就可以不再使用ResponseEntity，而是将其替换为@ResponseBody：

```java
// 当然，如果控制器类上使用了@RestController，甚至不再需要@ResponseBody
@RequestMapping(value="/{id}", method=RequestMethod.GET)
public @ResponseBody Spittle spittleById(@PathVariable long id) {
    Spittle spittle = spittleRepository.findOne(id);
    if (spittle == null) { 
        throw new SpittleNotFoundException(id); 
    }
    return spittle;
}
```

鉴于错误处理器的方法会始终返回Error，并且HTTP状态码为404（Not Found），那么现在可以对spittleNotFound()方法进行类似的清理：

```java
// 因为spittleNotFound()方法始终会返回Error，
// 所以使用ResponseEntity的唯一原因就是能够设置状态码。
// 但是通过为spittleNotFound()方法添加@ResponseStatus(HttpStatus.NOT_FOUND)注解，
// 可以达到相同的效果，而且可以不再使用ResponseEntity了。
// 同样，如果控制器类上使用了@RestController，
// 那么就可以移除掉@ResponseBody，让代码更加干净
同样，如果控制器类上使用了@RestController，那么就可以移除掉@ResponseBody，让代码更加干净
@ExceptionHandler(SpittleNotFoundException.class)
@ResponseStatus(HttpStatus.NOT_FOUND)
public @ResponseBody Error spittleNotFound(SpittleNotFoundException e) {
    long spittleId = e.getSpittleId();
    return new Error(4, "Spittle [" + spittleId + "] not found");
}
```

#### 16.3.2 在响应中设置头部信息

如下的程序清单展现了一个新版本的saveSpittle()，它会返回ResponseEntity用来告诉客户端新创建的资源（返回201 CREATED状态码以及新资源的路径）：

```java
@RequestMapping(method=RequestMethod.POST, consumes="application/json")
public ResponseEntity<Spittle> saveSpittle(@RequestBody Spittle spittle) {
    // 获取保存后的的Spittle
    Spittle spittle = spittleRepository.save(spittle);
    // 设置Location头部信息
    // 创建了一个HttpHeaders实例，用来存放希望在响应中包含的头部信息值。
    // HttpHeaders是MultiValueMap<String, String>的特殊实现，
    // 它有一些便利的Setter方法（如setLocation()），用来设置常见的HTTP头部信息
    HttpHeaders headers = new HttpHeaders();
    URI locationUri = URI.create("http://localhost:8080/spittr/spittles/" + spittle.getId());
    headers.setLocation(locationUri);
    // 创建ResponseEntity
    ResponseEntity<Spittle> responseEntity = 
        new ResponseEntity<Spittle>(spittle, headers, HttpStatus.CREATED);
    return responseEntity;
}
```

其实没有必要手动构建URL，Spring提供了UriComponentsBuilder，可以提供一些帮助。它是一个构建类，通过逐步指定URL中的各种组成部分（如host、端口、路径以及查询），能够使用它来构建UriComponents实例（避免硬编码）。借助UriComponentsBuilder所构建的UriComponents对象，就能获得适合设置给Location头部信息的URI：

```java
@RequestMapping(method=RequestMethod.POST, consumes="application/json")
public ResponseEntity<Spittle> saveSpittle(@RequestBody Spittle spittle, 
                                           UriComponentsBuilder ucb) {
    Spittle spittle = spittleRepository.save(spittle);
    HttpHeaders headers = new HttpHeaders();
    // 计算Location URI
    // 在处理器方法所得到的UriComponentsBuilder中，
    // 会预先配置已知的信息如host、端口以及Servlet内容。
    // 它会从处理器方法所对应的请求中获取这些基础信息。
    // 基于这些信息，代码会通过设置路径的方式构建UriComponents其余的部分
    URI locationUri = ucb.path("/spittles/")
        .path(String.valueOf(spittle.getId()))
        .build()
        .toUri();
    headers.setLocation(locationUri);
    ResponseEntity<Spittle> responseEntity =
        new ResponseEntity<Spittle>(
        spittle, headers, HttpStatus.CREATED)
        return responseEntity;
}
```

### 16.4 编写REST客户端

作为客户端，编写与REST资源交互的代码可能会比较乏味，并且所编写的代码都是样板式的。例如，假设需要借助Facebook的Graph API，编写方法来获取某人的Facebook基本信息。不过，获取基本信息的代码会有点复杂，如下面的程序清单所示.

使用Apache HTTP Client获取Facebook中的个人基本信息：

```java
public Profile fetchFacebookProfile(String id) {
    try {
        // 创建客户端
        HttpClient client = HttpClients.createDefault();
        // 创建请求
        HttpGet request = new HttpGet("http://graph.facebook.com/" + id);
        request.setHeader("Accept", "application/json");
        // 执行请求
        HttpResponse response = client.execute(request);
        HttpEntity entity = response.getEntity();
        // 将请求映射为对象
        ObjectMapper mapper = new ObjectMapper();
        return mapper.readValue(entity.getContent(), Profile.class);
    } catch (IOException e) {
        throw new RuntimeException(e);
    }
}
```

鉴于在资源使用上有如此之多的样板代码，可能会觉得最好的方式是封装通用代码并参数化可变的部分。这正是Spring的RestTemplate所做的事情。就像JdbcTemplate处理了JDBC数据访问时的丑陋部分，RestTemplate让我们在使用RESTful资源时免于编写那些乏味的代码。

#### 16.4.1 了解RestTemplate的操作

RestTemplate定义了36个与REST资源交互的方法，其中的大多数都对应于HTTP的方法。实际上，这里面只有11个独立的方法，其中有十个有三种重载形式，而第十一个则重载了六次。

除了TRACE以外，RestTemplate涵盖了所有的HTTP动作。除此之外，execute()和exchange()提供了较低层次的通用方法来使用任意的HTTP方法。

大多数操作都以三种方法的形式进行了重载：

+ 一个使用java.net.URI作为URL格式，不支持参数化URL；
+ 一个使用String作为URL格式，并使用Map指明URL参数；
+ 一个使用String作为URL格式，并使用可变参数列表指明URL参数。

RestTemplate定义了11个独立的操作，而每一个都有重载，这样一共是36个方法：

| 方法              | 描述                                                         |
| ----------------- | ------------------------------------------------------------ |
| delete()          | 在特定的URL上对资源执行HTTP DELETE操作                       |
| exchange()        | 在URL上执行特定的HTTP方法，返回包含对象的ResponseEntity，这个对象是从响应体中映射得到的 |
| execute()         | 在URL上执行特定的HTTP方法，返回一个从响应体映射得到的对象    |
| getForEntity()    | 发送一个HTTP GET请求，返回的ResponseEntity包含了响应体所映射成的对象 |
| getForObject()    | 发送一个HTTP GET请求，返回的请求体将映射为一个对象           |
| headForHeaders()  | 发送HTTP HEAD请求，返回包含特定资源URL的HTTP头               |
| optionsForAllow() | 发送HTTP OPTIONS请求，返回对特定URL的Allow头信息             |
| postForEntity()   | POST数据到一个URL，返回包含一个对象的ResponseEntity，这个对象是从响应体中映射得到的 |
| postForLocation() | POST数据到一个URL，返回新创建资源的URL                       |
| postForObject()   | POST数据到一个URL，返回根据响应体匹配形成的对象              |
| put()             | PUT资源到特定的URL                                           |

#### 16.4.2 GET资源

三个getForObject()方法的签名如下：

```java
<T> T getForObject(URI url, Class<T> responseType) throws RestClientException;
<T> T getForObject(String url, Class<T> responseType, Object... uriVariables) throws RestClientException;
<T> T getForObject(String url, Class<T> responseType, Map<String, ?> uriVariables) throws RestClientException;
```

类似地，getForEntity()方法的签名如下：

```java
<T> ResponseEntity<T> getForEntity(URI url, Class<T> responseType) throws RestClientException;
<T> ResponseEntity<T> getForEntity(String url, Class<T> responseType, Object... uriVariables) throws RestClientException;
<T> ResponseEntity<T> getForEntity(String url, Class<T> responseType, Map<String, ?> uriVariables) throws RestClientException;
```

除了返回类型，getForEntity()方法就是getForObject()方法的镜像。实际上，它们的工作方式大同小异。它们都执行根据URL检索资源的GET请求。它们都将资源根据responseType参数匹配为一定的类型。唯一的区别在于getForObject()只返回所请求类型的对象，而getForEntity()方法会返回请求的对象以及响应相关的额外信息。

#### 16.4.3 检索资源

getForObject()方法是检索资源的合适选择，请求一个资源并按照所选择的Java类型接收该资源。作为getForObject()能够做什么的一个简单示例，以下fetchFacebookProfile()的另一个实现：

```java
public Profile fetchFacebookProfile(String id) {
    // fetchFacebookProfile()首先构建了一个RestTemplate的实例（另一种可行的方式是注入实例）
    RestTemplate rest = new RestTemplate();
    // 调用了getForObject()来得到Facebook个人信息，要求结果是Profile对象。
    // 在接收到Profile对象后，该方法将其返回给调用者
    // RestTemplate可以接受参数化URL，URL中的{id}占位符最终将会用方法的id参数来填充
    return rest.getForObject("http://graph.facebook.com/{id}",Profile.class, id);
}

// 另外一种替代方案是将id参数放到Map中，并以id作为key，
// 然后将这个Map作为最后一个参数传递给getForObject()
public Spittle[] fetchFacebookProfile(String id) {
    Map<String, String> urlVariables = new HashMap<String, String();
    urlVariables.put("id", id);
    RestTemplate rest = new RestTemplate();
    return rest.getForObject("http://graph.facebook.com/{id}",Profile.class, urlVariables);
}
```

#### 16.4.4 抽取响应的元数据

作为getForObject()的一个替代方案，RestTemplate还提供了getForEntity()。getForEntity()方法与getForObject()方法的工作很相似。getForObject()只返回资源（通过HTTP信息转换器将其转换为Java对象），getForEntity()会在ResponseEntity中返回相同的对象，而且ResponseEntity还带有关于响应的额外信息，如HTTP状态码和响应头。

例如可能想使用ResponseEntity所做的事就是获取响应头的一个值。例如，假设除了获取资源，还想要知道资源的最后修改时间。假设服务端在LastModified头部信息中提供了这个信息，可以像这样使用getHeaders()方法：

```java
// getHeaders()方法返回一个HttpHeaders对象，该对象提供了多个便利的方法来查询响应头
Date lastModified = new Date(response.getHeaders().getLastModified());
```

如果对响应的HTTP状态码感兴趣，那么可以调用getStatusCode()方法：

```java
public Spittle fetchSpittle(long id) {
    RestTemplate rest = new RestTemplate();
    ResponseEntity<Spittle> response = 
        rest.getForEntity("http://localhost:8080/spittr-api/spittles/{id}",
                          Spittle.class, id);
    // 在这里，如果服务器响应304状态，这意味着服务器端的内容自从上一次请求之后再也没有修改。
    // 在这种情况下，将会抛出自定义的NotModifiedException异常来表明客户端应该检查它的缓存来获取Spittle
    if(response.getStatusCode() == HttpStatus.NOT_MODIFIED) {
        throw new NotModifiedException();
    }
    return response.getBody();
}
```

#### 16.4.5 PUT资源

为了对数据进行PUT操作，RestTemplate提供了三个简单的put()方法。就像其他的RestTemplate方法一样，put()方法有三种形式：

```java
void put(URI url, Object request) throws RestClientException;
void put(String url, Object request, Object... uriVariables) throws RestClientException;
void put(String url, Object request, Map<String, ?> uriVariables) throws RestClientException;
```

按照它最简单的形式，put()接受一个java.net.URI，用来标识（及定位）要将资源发送到服务器上，另外还接受一个对象，这代表了资源的Java表述。

例如，以下展现了如何使用基于URI版本的put()方法来更新服务器上的Spittle资源：

```java
public void updateSpittle(Spittle spittle) throws SpitterException {
    RestTemplate rest = new RestTemplate();
    String url = "http://localhost:8080/spittr-api/spittles/" + spittle.getId();
    rest.put(URI.create(url), spittle);
}

// 可以将URI指定为模板并对可变部分插入值，
// 以下是使用基于String的put()方法重写的updateSpittle()
public void updateSpittle(Spittle spittle) throws SpitterException {
    RestTemplate rest = new RestTemplate();
    rest.put("http://localhost:8080/spittr-api/spittles/{id}",
             spittle, spittle.getId());
}

// 还可以将模板参数作为Map传递进来
public void updateSpittle(Spittle spittle) throws SpitterException {
    RestTemplate rest = new RestTemplate();
    Map<String, String> params = new HashMap<String, String>();
    params.put("id", spittle.getId());
    rest.put("http://localhost:8080/spittr-api/spittles/{id}",
             spittle, params);
}
```

在所有版本的put()中，第二个参数都是表示资源的Java对象，它将按照指定的URI发送到服务器端。在本示例中，它是一个Spittle对象。RestTemplate将使用某个HTTP消息转换器将Spittle对象转换为一种表述形式，并在请求体中将其发送到服务器端。

对象将被转换成什么样的内容类型很大程度上取决于传递给put()方法的类型。如果给定一个String值，那么将会使用StringHttpMessageConverter：这个值直接被写到请求体中，内容类型设置为“text/plain”。如果给定一个MultiValueMap<String,String>，那么这个Map中的值将会被FormHttpMessageConverter以“application/x-www-form-urlencoded”的格式写到请求体中。

因为传递进来的是Spittle对象，所以需要一个能够处理任意对象的信息转换器。如果在类路径下包含Jackson 2库，那么MappingJacksonHttpMessageConverter将以application/json格式将Spittle写到请求中。

#### 16.4.6 DELETE资源

不需要在服务端保留某个资源时，那么可能需要调用RestTemplate的delete()方法。就像PUT方法那样，delete()方法有三个版本，它们的签名如下：

```java
void delete(String url, Object... uriVariables) throws RestClientException;
void delete(String url, Map<String, ?> uriVariables) throws RestClientException;
void delete(URI url) throws RestClientException;
```

delete()方法是所有RestTemplate方法中最简单的。唯一要提供的就是要删除资源的URI。例如，为了删除指定ID的Spittle，可以这样调用delete()：

```java
public void deleteSpittle(long id) {
    RestTemplate rest = new RestTemplate();
    rest.delete(URI.create("http://localhost:8080/spittr-api/spittles/" + id));
}

// 为了避免使用字符串连接来创建URI对象，可以进行修改
public void deleteSpittle(long id) {
    RestTemplate rest = new RestTemplate();
    rest.delete("http://localhost:8080/spittr-api/spittles/{id}", id));
}
```

#### 16.4.7 POST资源数据

RestTemplate有三个不同类型共九个方法来发送POST请求。postForObject()和postForEntity()对POST请求的处理方式与发送GET请求的getForObject()和getForEntity()方法是类似的。另一个方法是postForLocation()，它是POST请求所特有的。

#### 16.4.8 在POST请求中获取响应对象

POST资源到服务端的一种方式是使用RestTemplate的postForObject()方法。postForObject()方法的三个变种签名如下：

```java
<T> T postForObject(URI url, Object request, Class<T> responseType) throws RestClientException;
<T> T postForObject(String url, Object request, Class<T> responseType, Object... uriVariables) throws RestClientException;
<T> T postForObject(String url, Object request, Class<T> responseType, Map<String, ?> uriVariables) throws RestClientException;
```

在所有情况下，第一个参数都是资源要POST到的URL，第二个参数是要发送的对象，而第三个参数是预期返回的Java类型。在将URL作为String类型的两个版本中，第四个参数指定了URL变量（要么是可变参数列表，要么是一个Map）。

当POST新的Spitter资源到Spitter REST API时，它们应该发送到http://localhost:8080/spittr-api/spitters，这里会有一个应对POST请求的处理方法来保存对象。因为这个URL不需要URL参数，所以可以使用任何版本的postForObject()。但为了保持尽可能简单，可以这样调用：

```java
// postSpitterForObject()方法给定了一个新创建的Spitter对象，
// 并使用postForObject()将其发送到服务器端。
// 在响应中，它接收到一个Spitter对象并将其返回给调用者
public Spitter postSpitterForObject(Spitter spitter) {
    RestTemplate rest = new RestTemplate();
    return rest.postForObject("http://localhost:8080/spittr-api/spitters", spitter, Spitter.class);
}
```

postForEntity()方法能得到请求带回来的一些元数据，其有着与postForObject()几乎相同的一组签名：

```java
<T> ResponseEntity<T> postForEntity(URI url, Object request, Class<T> responseType) throws RestClientException;
<T> ResponseEntity<T> postForEntity(String url, Object request, Class<T> responseType, Object... uriVariables) throws RestClientException;
<T> ResponseEntity<T> postForEntity(String url, Object request, Class<T> responseType, Map<String, ?> uriVariables) throws RestClientException;
```

假设除了要获取返回的Spitter资源，还要查看响应中Location头信息的值。在这种情况下，可以这样调用postForEntity()：

```java
RestTemplate rest = new RestTemplate();
// postForEntity()返回一个ResponseEntity<T>对象，
// 可以调用这个对象的getBody()方法以获取资源对象（在本示例中是Spitter）
// getHeaders()会返回一个HttpHeaders，通过它可以访问响应中返回的各种HTTP头信息
ResponseEntity<Spitter> response = rest.postForEntity(
    "http://localhost:8080/spittr-api/spitters", spitter, Spitter.class);
Spitter spitter = response.getBody();
URI url = response.getHeaders().getLocation();
```

#### 16.4.9 在POST请求后获取资源位置

类似于其他的POST方法，postForLocation()会在POST请求的请求体中发送一个资源到服务器端。但是，响应不再是相同的资源对象（有时候没有必要返回原对象），postForLocation()的响应是新创建资源的位置。它有如下三个方法签名：

```java
URI postForLocation(String url, Object request, Object... uriVariables) throws RestClientException;
URI postForLocation(String url, Object request, Map<String, ?> uriVariables) throws RestClientException;
URI postForLocation(URI url, Object request) throws RestClientException;
```

例，希望在返回中包含资源的URL：

```java
public String postSpitter(Spitter spitter) {
    RestTemplate rest = new RestTemplate();
    // postForLocation()会以String的格式新资源的URL
    return rest
        .postForLocation("http://localhost:8080/spittr-api/spitters",spitter)
        .toString();
}
```

#### 16.4.10 交换资源

RestTemplate的exchange()方法可以在发送给服务端的请求中设置头信息，像RestTemplate的其他方法一样，exchange()也重载为三个签名格式。一个使用java.net.URI来标识目标URL，而其他两个以String的形式传入URL并带有URL变量：

```java
<T> ResponseEntity<T> exchange(URI url, HttpMethod method, HttpEntity<?> requestEntity, Class<T> responseType) throws RestClientException;
<T> ResponseEntity<T> exchange(String url, HttpMethod method, HttpEntity<?> requestEntity, Class<T> responseType, Object... uriVariables) throws RestClientException;
<T> ResponseEntity<T> exchange(String url, HttpMethod method, HttpEntity<?> requestEntity, Class<T> responseType, Map<String, ?> uriVariables) throws RestClientException;
```

exchange()方法使用HttpMethod参数来表明要使用的HTTP动作。根据这个参数的值，exchange()能够执行与其他RestTemplate方法一样的工作。例如：

```java
// 借助exchange()方法从服务器端获取Spitter资源
// 通过传入HttpMethod.GET作为HTTP动作，要求exchange()发送一个GET请求。
// 第三个参数是用于在请求中发送资源的，但因为这是一个GET请求，它可以是null。
// 下一个参数表明我们希望将响应转换为Spitter对象。
// 最后一个参数用于替换URL模板中{spitter}占位符的值。
ResponseEntity<Spitter> response = rest.exchange(
    "http://localhost:8080/spittr-api/spitters/{spitter}",
    HttpMethod.GET, null, Spitter.class, spitterId);
Spitter spitter = response.getBody();
```

如果不指明头信息，exchange()对Spitter的GET请求会带有如下的头信息：

```properties
GET /Spitter/spitters/angus HTTP/1.1
# Accept头信息表明它能够接受多种不同的XML内容类型以及application/json
Accept: application/xml, text/xml, application/*+xml, application/json
Content-Length: 0
User-Agent: Java/1.6.0_20
Host: localhost:8080
Connection: keep-alive
```

假设希望服务端以JSON格式发送资源。在这种情况下，需要将“application/json”设置为Accept头信息的唯一值。设置请求头信息是很简单的，只需构造发送给exchange()方法的HttpEntity对象即可，HttpEntity中包含承载头信息的MultiValueMap：

```java
// 新建一个LinkedMultiValueMap并添加值为“application/json”的Accept头信息。
MultiValueMap<String, String> headers = new LinkedMultiValueMap<String, String>();
headers.add("Accept", "application/json");
// 构建一个HttpEntity（使用Object泛型类型），将MultiValueMap作为构造参数传入。
// 如果这是一个PUT或POST请求，还需要为HttpEntity设置在请求体中发送的对象
HttpEntity<Object> requestEntity = new HttpEntity<Object>(headers);
```

传入HttpEntity来调用exchange()：

```java
ResponseEntity<Spitter> response = rest.exchange(
"http://localhost:8080/spittr-api/spitters/{spitter}",
HttpMethod.GET, requestEntity, Spitter.class, spitterId);
Spitter spitter = response.getBody();
```

请求将会带有如下的头信息发送：

```properties
GET /Spitter/spitters/habuma HTTP/1.1
# 指定Accept之后，假设服务器端能够将Spitter序列化为JSON，响应体将会以JSON格式来进行表述。
Accept: application/json
Content-Length: 0
User-Agent: Java/1.6.0_20
Host: localhost:8080
Connection: keep-alive
```

### 16.5 小结

RESTful架构使用Web标准来集成应用程序，使得交互变得简单自然。系统中的资源采用URL进行标识，使用HTTP方法进行管理并且会以一种或多种适合客户端的方式来进行表述。

借助参数化的URL模式并将控制器处理方法与特定的HTTP方法关联，控制器能够响应对资源的GET、POST、PUT以及DELETE请求。

为了响应这些请求，Spring能够将资源背后的数据以最适合客户端的形式展现。对于基于视图的响应，ContentNegotiatingViewResolver能够在多个视图解析器产生的视图中选择出最适合客户端期望内容类型的那一个。或者，控制器的处理方法可以借助@ResponseBody注解完全绕过视图解析，并使用信息转换器将返回值转换为客户端的响应。

REST API为客户端暴露了应用的功能，Spring应用也可以借助RestTemplate来使用这些API。rrrrr























