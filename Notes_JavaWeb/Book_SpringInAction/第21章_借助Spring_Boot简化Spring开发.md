### 21.1 Spring Boot简介

Spring Boot提供了四个主要的特性，能够改变开发Spring应用程序的方式：

+ Spring Boot Starter：它将常用的依赖分组进行了整合，将其合并到一个依赖中，这样就可以一次性添加到项目的Maven或Gradle构建中；
+ 自动配置：Spring Boot的自动配置特性利用了Spring 4对条件化配置的支持，合理地推测应用所需的bean并自动化配置它们；
+ 命令行接口（Command-line interface，CLI）：Spring Boot的CLI发挥了Groovy编程语言的优势，并结合自动配置进一步简化Spring应用的开发；
+ Actuator：它为Spring Boot应用添加了一定的管理特性。

#### 21.1.1 添加Starter依赖



