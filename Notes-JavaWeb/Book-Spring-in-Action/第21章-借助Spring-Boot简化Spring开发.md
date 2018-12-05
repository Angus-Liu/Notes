### 21.1 Spring Boot简介

Spring Boot提供了四个主要的特性，能够改变开发Spring应用程序的方式：

+ Spring Boot Starter：它将常用的依赖分组进行了整合，将其合并到一个依赖中，这样就可以一次性添加到项目的Maven或Gradle构建中；
+ 自动配置：Spring Boot的自动配置特性利用了Spring 4对条件化配置的支持，合理地推测应用所需的bean并自动化配置它们；
+ 命令行接口（Command-line interface，CLI）：Spring Boot的CLI发挥了Groovy编程语言的优势，并结合自动配置进一步简化Spring应用的开发；
+ Actuator：它为Spring Boot应用添加了一定的管理特性。

#### 21.1.1 添加Starter依赖

Spring Boot Starter依赖将所需的常见依赖按组聚集在一起，形成单条依赖：

| Starter                               | 所提供的依赖                                                 |
| ------------------------------------- | ------------------------------------------------------------ |
| spring-boot-starter-actuator          | spring-boot-starter 、spring-boot-actuator 、<br>spring-core |
| spring-boot-starter-amqp              | spring-boot-starter 、spring-boot-rabbit 、<br>spring-core 、 spring-tx |
| spring-boot-starter-aop               | spring-boot-starter 、spring-aop 、AspectJ Runtime 、<br>AspectJ Weaver 、spring-core |
| spring-boot-starter-batch             | spring-boot-starter 、HSQLDB 、spring-jdbc 、<br>spring-batch-core 、spring-core |
| spring-boot-starter-elasticsearch     | spring-boot-starter、 spring-data-elasticsearch、<br> spring-core、 spring-tx |
| spring-boot-starter-gemfire           | spring-boot-starter、 Gemfire、 spring-core、<br> spring-tx、 spring-context、 spring-context-support、<br> spring-data-gemfire |
| spring-boot-starter-data-jpa          | spring-boot-starter、 spring-boot-starter-jdbc、<br>spring-boot-starter-aop、 spring-core、 <br>Hibernate EntityManager、 spring-orm、 <br>spring-data-jpa、 spring-aspects |
| spring-boot-starter-data-mongodb      | spring-boot-starter、 MongoDB Java 驱动 、<br> spring-core、 spring-tx、 spring-data-mongodb |
| spring-boot-starter-data-rest         | spring-boot-starter、 spring-boot-starter-web、 <br>Jackson 注解 、 Jackson 数据绑定 、 spring-core、<br> spring-tx、 spring-data-rest-webmvc |
| spring-boot-starter-data-solr         | spring-boot-starter、 Solrj、 spring-core、<br> spring-tx、 spring-data-solr、 Apache HTTP Mime |
| spring-boot-starter-freemarker        | spring-boot-starter、 spring-boot-starter-web、 <br>Freemarker、 spring-core、 spring-context-support |
| spring-boot-starter-groovy-templ-ates | spring-boot-starter、 spring-boot-starter-web、 <br>Groovy、 Groovy 模板、spring-core |
| spring-boot-starter-hornetq           | spring-boot-starter、 spring-core、<br> spring-jms、 Hornet JMS Client |
| spring-boot-starter-integration       | spring-boot-starter、 spring-aop、 spring-tx、<br> spring-web、 spring-webmvc、 spring-integration-core、<br> spring-integration-file、 spring-integration-http、 <br>spring-integration-ip、 spring-integration-stream |
| spring-boot-starter-jdbc              | spring-boot-starter、 spring-jdbc 、tomcat-jdbc、 spring-tx  |
| spring-boot-starter-jetty             | jetty-webapp、 jetty-jsp                                     |
| spring-boot-starter-log4j             | jcl-over-slf4j、 jul-to-slf4j 、slf4j-log4j12、log4j         |
| spring-boot-starter -logging          | jcl-over-slf4j、 jul-to-slf4j 、log4j-over-slf4j、 logback-classic |
| spring-boot-starter-mobile            | spring-boot-starter、 spring-boot-starter-web、 spring-mobile-device |
| spring-boot-starter-redis             | spring-boot-starter、 spring-data-redis、 lettuce            |
| spring-boot-starter-remote-shell      | spring-boot-starter-actuator、 spring-context、 org.crashub.** |
| spring-boot-starter-security          | spring-boot-starter、 spring-security-config、 <br>spring-security-web、 spring-aop、 spring-beans、<br> spring-context、 spring-core、 spring-expression、 spring-web |
| spring-boot-starter-social-facebook   | spring-boot-starter、 spring-boot-starter-web、<br> spring-core、 spring-social-config、 spring-social-core、 <br>spring-social-web、 spring-social-facebook |
| spring-boot-starter-social-twitter    | spring-boot-starter、 spring-boot-starter-web、 <br>spring-core、 spring-social-config、 spring-social-core、 <br>spring-social-web、 spring-social-twitter |
| spring-boot-starter-social-linkedin   | spring-boot-starter、 spring-boot-starter-web、 <br>spring-core、 spring-social-config、 spring-social-core、<br> spring-social-web、 spring-social-linkedin |
| spring-boot-starter                   | spring-boot、 spring-boot-autoconfigure、 <br>spring-boot-starter-logging |
| spring-boot-starter-test              | spring-boot-starter-logging、 spring-boot、 junit、<br>mockito-core、 hamcrest-library、 spring-test |
| spring-boot-starter-thymeleaf         | spring-boot-starter、 spring-boot-starter-web、<br> spring-core、 thymeleaf-spring4、 thymeleaf-layout-dialect |
| spring-boot-starter-tomcat            | tomcat-embed-core、 tomcat-embed-logging-juli                |
| spring-boot-starter-web               | spring-boot-starter、 spring-boot-starter-tomcat、<br> jackson-databind、 spring-web、 spring-webmvc |
| spring-boot-starter-websocket         | spring-boot-starter-web、 spring-websocket、 <br>tomcat-embed-core、 tomcat-embed-logging-juli |
| spring-boot-starter-ws                | spring-boot-starter、 spring-boot-starter-web、 <br>spring-core、 spring-jms、 spring-oxm、 spring-ws-core、<br>spring-ws-support |

#### 21.1.2 自动配置

Spring Boot的Starter减少了构建中依赖列表的长度，而Spring Boot的自动配置功能则削减了Spring配置的数量。它在实现时，会考虑应用中的其他因素并推断所需要的Spring配置。

作为样例，第6章中要将Thymeleaf模板作为Spring MVC的视图，至少需要三个bean：ThymeleafViewResolver、SpringTemplateEngine和TemplateResolver。但是，使用Spring Boot自动配置的话，需要做的仅仅是将Thymeleaf添加到项目的类路径中。如果Spring Boot探测到Thymeleaf位于类路径中，它就会推断需要使用Thymeleaf实现Spring MVC的视图功能，并自动配置这些bean。

Spring Boot Starter也会触发自动配置。例如，在Spring Boot应用中，如果想要使用Spring MVC的话，所需要做的仅仅是将Web Starter作为依赖放到构建之中。将Web Starter作为依赖放到构建中以后，它会自动添加Spring MVC依赖。如果Spring Boot的Web自动配置探测到Spring MVC位于类路径下，它将会自动配置支持Spring MVC的多个bean，包括视图解析器、资源处理器以及消息转换器（等等）。接下来需要做的就是编写处理请求的控制器。

#### 21.1.3 Spring Boot CLI

Spring Boot CLI充分利用了Spring Boot Starter和自动配置的魔力，并添加了一些Groovy的功能。它简化了Spring的开发流程，通过CLI，能够运行一个或多个Groovy脚本，并查看它是如何运行的。在应用的运行过程中，CLI能够自动导入Spring类型并解析依赖。

用来阐述Spring Boot CLI的最有趣的例子就是如下的Groovy脚本：

```groovy
@RestController
class Hi {
    @RequestMapping("/")
    String hi() {
        "Hi!"
    }
}
```

如果已经安装过Spring Boot CLI，可以使用如下的命令行来运行它：

```bash
$ spring run Hi.groovy
```

#### 21.1.4 Actuator

Spring Boot Actuator为Spring Boot项目带来了很多有用的特性，包括：

+ 管理端点；
+ 合理的异常处理以及默认的“/error”映射端点；
+ 获取应用信息的“/info”端点；
+ 当启用Spring Security时，会有一个审计事件框架。

### 21.2 使用Spring Boot构建应用 

#### 21.2.1 处理请求

#### 21.2.2 创建视图

#### 21.2.3 添加静态内容

#### 21.2.4 持久化数据

#### 21.2.5 尝试运行

### 21.3 组合使用Groovy与Spring Boot CLI

#### 21.3.1 编写Groovy控制器

#### 21.3.2 使用Groovy Repository实现数据持久化

#### 21.3.3 运行Spring Boot CLI

### 21.4 通过Actuator获取了解应用内部状况

Spring Boot Actuator所完成的主要功能就是为基于Spring Boot的应用添加多个有用的管理端点。这些端点包括以下几个内容。

+ GET /autoconfig：描述了Spring Boot在使用自动配置的时候，所做出的决策；
+ GET /beans：列出运行应用所配置的bean；
+ GET /configprops：列出应用中能够用来配置bean的所有属性及其当前的值；
+ GET /dump：列出应用的线程，包括每个线程的栈跟踪信息；
+ GET /env：列出应用上下文中所有可用的环境和系统属性变量；
+ GET /env/{name}：展现某个特定环境变量和属性变量的值；
+ GET /health：展现当前应用的健康状况；
+ GET /info：展现应用特定的信息；
+ GET /metrics：列出应用相关的指标，包括请求特定端点的运行次数；
+ GET /metrics/{name}：展现应用特定指标项的指标状况；
+ POST /shutdown：强制关闭应用；
+ GET /trace：列出应用最近请求相关的元数据，包括请求和响应头。

为了启用Actuator，只需将Actuator Starter依赖添加到项目中即可。如果使用Gradle构建Java应用的话，那么在build.gradle的dependencies代码块中需要添加如下的依赖：

```groovy
compile("org.springframework.boot:spring-boot-starter-actuator")
```

或者，在项目的Maven pom.xml文件中，可以添加如下的\<dependency>：

```xml
<dependency>
    <groupId> org.springframework.boot</groupId>
    <artifactId>spring-boot-actuator</artifactId>
</dependency>
```

添加完Spring Boot Actuator之后，可以重新构建并启动应用，然后打开浏览器访问以上所述的端点来获取更多信息。例如，如果想要查看Spring应用上下文中所有的bean，那么可以访问http://localhost:8080/beans。如果使用curl命令行工具的话，所得到的结果将会如下所示：

```json
$ curl http://localhost:8080/beans
[
    {
        "beans": [
            {
                // 可以看到有一个ID为contactController的bean，
                // 它依赖于名为contactRepository的bean，
                // 而contactRepository又依赖于jdbcTemplatebean
                "bean": "contactController",
                "dependencies": [
                    "contactRepository"
                ],
                "resource": "null",
                "scope": "singleton",
                "type": "ContactController"
            },
            {
                "bean": "contactRepository",
                "dependencies": [
                    "jdbcTemplate"
                ],
                "resource": "null",
                "scope": "singleton",
                "type": "ContactRepository"
            },
            ...
            {
                "bean": "jdbcTemplate",
                "dependencies": [],
                "resource": "class path resource [...]",
                "scope": "singleton",
                "type": "org.springframework.jdbc.core.JdbcTemplate"
            },
            ...
        ]
            }
        ]
```

另外一个端点也能帮助了解Spring Boot自动配置的内部情况，这就是“/autoconfig”。这个端点所返回的JSON描述了Spring Boot在自动配置bean的时候所做出的决策。例如，当针对Contacts应用调用“/autoconfig”端点时，如下展现了删减后的JSON结果：

```json
$ curl http://localhost:8080/autoconfig
{
    // 报告包含了两部分：一部分是没有匹配上的（negative matches）
    "negativeMatches": {
        "AopAutoConfiguration": [
            {
                "condition": "OnClassCondition",
                "message": "required @ConditionalOnClass classes not found:
                org.aspectj.lang.annotation.Aspect,
                org.aspectj.lang.reflect.Advice"
            }
        ],
        "BatchAutoConfiguration": [
            {
                "condition": "OnClassCondition",
                "message": "required @ConditionalOnClass classes not found:
                org.springframework.batch.core.launch.JobLauncher"
            }
        ],
        ...
    },
        // 一部分是匹配上的（positive matches）
        "positiveMatches": {
            // 因为在类路径下找到了SpringTemplateEngine，Thymeleaf自动配置将会发挥作用
            // 除非明确声明了默认的模板解析器、视图解析器以及模板bean否则的话，这些bean会进行自动配置
            // 只有在类路径中能够找到Servlet类，才会自动配置默认的视图解析器
            "ThymeleafAutoConfiguration": [
                {
                    "condition": "OnClassCondition",
                    "message": "@ConditionalOnClass classes found:
                    org.thymeleaf.spring4.SpringTemplateEngine"
                }
            ],
            "ThymeleafAutoConfiguration.DefaultTemplateResolverConfiguration":[
                {
                    "condition": "OnBeanCondition",
                    "message": "@ConditionalOnMissingBean
                    (names: defaultTemplateResolver; SearchStrategy: all)
                    found no beans"
                }
            ],
            "ThymeleafAutoConfiguration.ThymeleafDefaultConfiguration": [
                {
                    "condition": "OnBeanCondition",
                    "message": "@ConditionalOnMissingBean (types:
                    org.thymeleaf.spring4.SpringTemplateEngine;
                    SearchStrategy: all) found no beans"
                }
            ],
            "ThymeleafAutoConfiguration.ThymeleafViewResolverConfiguration": [
                {
                    "condition": "OnClassCondition",
                    "message": "@ConditionalOnClass classes found:
                    javax.servlet.Servlet"
                }
            ],
            "ThymeleafAutoConfiguration.ThymeleafViewResolverConfiguration
            #thymeleafViewResolver": [
            {
            "condition": "OnBeanCondition",
            "message": "@ConditionalOnMissingBean (names:
            thymeleafViewResolver; SearchStrategy: all)
            found no beans"
        }
        ],
        ...
    } }
```

### 21.5 小结

Spring Boot用了两个技巧来消除Spring项目中的样板式配置：Spring Boot Starter和自动配置。

一个简单的Spring Boot Starter依赖能够替换掉Maven或Gradle构建中多个通用的依赖。例如，在项目中添加Spring Boot Web依赖后，将会引入Spring Web和Spring MVC模块，以及Jackson 2数据绑定模块。

自动配置充分利用了Spring 4.0的条件化配置特性，能够自动配置特定的Spring bean，用来启用某项特性。例如，Spring Boot能够在应用的类路径中探测到Thymeleaf，然后自动将Thymeleaf模板配置为Spring MVC视图的bean。

Spring Boot的命令行接口（command-line interface，CLI）使用Groovy进一步简化了Spring项目。通过在Groovy代码中简单地引用Spring组件，CLI就能自动添加所需的Starter依赖（而这又会触发自动配置）。除此之外，通过Spring Boot CLI运行时，很多的Spring类型都不需要在Groovy代码中显式使用import语句导入。

最后，Spring Boot Actuator为基于Spring Boot开发的Web应用提供了一些通用的管理特性，包括查看线程dump、Web请求历史以及Spring应用上下文中的bean。
