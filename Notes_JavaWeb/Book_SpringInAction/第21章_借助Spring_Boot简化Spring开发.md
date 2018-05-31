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

#### 21.1.2 单条配置



