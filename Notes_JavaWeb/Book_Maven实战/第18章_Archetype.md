### 18.1 Archetype使用再叙

#### 18.1.1 Maven Archetype Plugin

Archetype并不是Maven的核心特性，它也是通过插件来实现的，这一插件就是maven-archetype-plugin。

#### 18.1.2 使用Archetype的一般步骤

```bash
mvn archetype:generate
```

输入上述命令后，Archetype插件会输出一个Archetype列表供用户选择：

```bash
Choose archetype：
1：internal-＞appfuse-basic-jsf（AppFuse archetype for creating a web applica-
tion with Hibernate,Spring and JSF）
2：internal-＞appfuse-basic-spring（AppFuse archetype for creating a web ap-
plication with Hibernate,Spring and Spring MVC）
3：internal-＞appfuse-basic-struts（AppFuse archetype for creating a web ap-
plication with Hibernate,Spring and Struts 2）
4：internal-＞appfuse-basic-tapestry（AppFuse archetype for creating a web ap-
plication with Hibernate,Spring and Tapestry 4）
5：internal-＞appfuse-core（AppFuse archetype for creating a jar application
with Hibernate and Spring and XFire）
6：internal-＞appfuse-modular-jsf（AppFuse archetype for creating a modular
application with Hibernate,Spring and JSF）
7：internal-＞appfuse-modular-spring（AppFuse archetype for creating a modu-
lar application with Hibernate,Spring and Spring MVC）
8：internal-＞appfuse-modular-struts（AppFuse archetype for creating a modu-
lar application with Hibernate,Spring and Struts 2）
9：internal-＞appfuse-modular-tapestry（AppFuse archetype for creating a modu-
lar application with Hibernate,Spring and Tapestry 4）
10：internal-＞makumba-archetype（Archetype for a simple Makumba application）
11：internal-＞maven-archetype-j2ee-simple（A simple J2EE Java application）
12：internal-＞maven-archetype-marmalade-mojo（A Maven plugin development
project using marmalade）
13：internal-＞maven-archetype-mojo（A Maven Java plugin development project）
14：internal-＞maven-archetype-portlet（A simple portlet application）
15：internal-＞maven-archetype-profiles（）
16：internal-＞maven-archetype-quickstart（）
...
```

在选择了一个Archetype之后，下一步就需要提供一些基本的参数。主要有：

+ groupId：想要创建项目的groupId。
+ artifactId：想要创建项目的artifactId。
+ version：想要创建项目的version。
+ package：想要创建项目的默认Java包名。

#### 18.1.3 批处理方式使用Archetype

可以使用mvn命令的-B选项，要求maven-archetype-plugin以批处理的方式运行（取消交互）。不过，这时还必须显式地声明要使用的Archetype坐标信息，以及要创建项目的groupId、artifactId、version、pack-age等信息。例如：

```bash
- D archetypeGroupId ＝ org.apache.maven.archetypes ＼
- D archetypeArtifactId ＝ maven - archetype - quickstart ＼
- D archetypeVersion ＝1.0 ＼
- D groupId ＝ com.juvenxu.mvnbook ＼
- D artifactId ＝ archetype - test ＼
- D version ＝1.0 - SNAPSHOT ＼
- D package ＝ com.juvenxu.mvnbook
[INFO] Scanning for projects...
[INFO]
[INFO] －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
[INFO] Building Maven Stub Project (No POM) 1
[INFO] －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
[INFO]
[INFO] ＞ ＞ ＞ maven － archetype － plugin:2.0 － alpha － 5:generate (default － cli) @
standalone － pom ＞ ＞ ＞
[INFO]
[INFO] ＜ ＜ ＜ maven － archetype － plugin:2.0 － alpha － 5:generate (default － cli) @
standalone － pom ＜ ＜ ＜
[INFO]
[INFO] －－－maven － archetype － plugin:2.0 － alpha －5:generate (default － cli) @ standalone
－ pom －－－
[INFO] Generating project in Batch mode
[INFO] Archetype repository missing. Using the one from [org.apache.maven. archetypes:
maven － archetype － quickstart:1.0] found in catalog remote
[INFO] －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
[INFO] Using following parameters for creating OldArchetype: maven － archetype －
quickstart:1.0
[INFO] －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
[INFO] Parameter: groupId, Value: com.juvenxu.mvnbook
[INFO] Parameter: packageName, Value: com.juvenxu.mvnbook
[INFO] Parameter: package, Value: com.juvenxu.mvnbook
[INFO] Parameter: artifactId, Value: archetype － test
[INFO] Parameter: basedir, Value: D:＼tmp＼archetype
[INFO] Parameter: version, Value: 1.0 － SNAPSHOT
[INFO] ********************* End of debug info from resources from
generated POM ***********************
[INFO] OldArchetype created in dir: D:＼tmp＼archetype＼archetype － test
[INFO] －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
[INFO] BUILD SUCCESS
[INFO] －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
[INFO] Total time: 2.624s
[INFO] Finished at: Wed Apr 28 14:34:32 CST 2010
[INFO] Final Memory: 6M／11M
[INFO] －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
```

#### 18.1.4 常用Archetype介绍

几个比较常用的Archetype：

1.maven-archetype-quickstart

maven-archetype-quickstart可能是最常用的Archetype，当maven-archetype-plugin提示用户选择Archetype的时候，它就是默认值。使用maven-archetype-quickstart生成的项目十分简单，基本内容如下：

+ 一个包含JUnit依赖声明的pom.xml。
+ src/main/java主代码目录及该目录下一个名为App的输出“Hello World！”的类。
+ src/test/java测试代码目录及该目录下一个名为AppTest的JUnit测试用例。

当需要创建一个全新的Maven项目时，就可以使用该Archetype生成项目后进行修改，省去了手工创建POM及目录结构的麻烦。

2.maven-archetype-webapp

这是一个最简单的Maven war项目模板，当需要快速创建一个Web应用的时候就可以使用它。使用maven-archetype-webapp生成的项目内容如下：

+ 一个packaging为war且带有JUnit依赖声明的pom.xml。
+ src/main/webapp/目录。
+ src/main/webapp/index.jsp文件，一个简单的Hello World页面。
+ src/main/webapp/WEB-INF/web.xml文件，一个基本为空的Web应用配置文件。

3.AppFuse Archetype

AppFuse是一个集成了很多开源工具的项目，它由Matt Raible开发，旨在帮助Java编程人员快速高效地创建项目。AppFuse本身使用Maven构建，它的核心其实就是一个项目的骨架，是包含了持久层、业务层及展现层的一个基本结构。在AppFuse 2.x中，已经集成了大量流行的开源工具，如Spring、Struts 2、JPA、JSF、Tapestry等。

AppFuse为用户提供了大量Archetype，以方便用户快速创建各种类型的项目，它们都使用同样的groupId org.appfuse。针对各种展现层框架分别为：

+ appfuse-*-jsf：基于JSF展现层框架的Archetype。
+ appfuse-*-spring：基于Spring MVC展现层框架的Archetype。
+ appfuse-*-struts：基于Struts 2展现层框架的Archetype。
+ appfuse-*-tapestry：基于Tapestry展现层框架的Archetype。

每一种展现层框架都有3个Archetype，分别为light、basic和modular。其中，light类型的Archetype只包含最简单的骨架；basic类型的Archetype则包含了一些用户管理及安全方面的特性；modular类型的Archetype会生成多模块的项目，其中的core模块包含了持久层及业务层的代码，而Web模块则是展现层的代码。

官方的快速入门手册：<http://appfuse.org/display/apf/appfuse+quickstart>。

### 18.2 编写Archetype

### 18.3 Archetype Catalog

### 18.4 小结

本章详细阐述了最为有用的Maven插件之一：Maven Archetype Plugin。可以选择以交互式或者批处理的方式使用该插件生成项目骨架。另外，还介绍了一些常用的Archetype。

本章的重点是创建自己的Archetype，这主要包括理解Archetype项目的结构、如何通过属性过滤为Archetype提供灵活性，以及Archetype Package参数的作用。Archetype Plugin通过读取Archetype-catalog.xml文件内容来提供可用的Archetype列表信息，这样的Catalog可以从各个地方获得，如插件内置、本机机器、中央仓库以及自定义的file://或http://路径。本章最后介绍了如何使用archetype:crawl和nexus-archetype-plugin生成仓库的archetype-catalog.xml内容。