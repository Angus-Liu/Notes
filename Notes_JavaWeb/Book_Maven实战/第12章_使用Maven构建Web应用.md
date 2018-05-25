### 12.1 Web项目的目录结构

基于Java的Web应用，其标准的打包方式是WAR。WAR与JAR类似，只不过它可以包含更多的内容，如JSP文件、Servlet、Java类、web.xml配置文件、依赖JAR包、静态web资源（如HTML、CSS、JavaScript文件）等。一个典型的WAR文件会有如下目录结构：

```bash
-war/
  +META-INF/   # META-INF中包含一些打包数据信息（不用关心）
  +WEB-INF/    # WEB-INF是WAR包的核心
  | +classes/  # classes包含所有该项目的类
  | | +ServletA.class
  | | +config.properties
  | | +……
  | |
  | +lib/      # lib包含所有该项目依赖的JAR包
  | | +dom4j-1.4.1.jar
  | | +mail-1.4.1.jar
  | | +……
  | |
  | +web.xml   # web.xml不可或缺
  |
  +img/        # img、css、js等中包含项目用到的Web资源
  |
  +css/
  |
  +js/
  |
  +index.html
  +sample.jsp
```

同任何其他Maven项目一样，Maven对Web项目的布局结构也有一个通用的约定，不过必须为Web项目显式指定打包方式为war。

Maven Web项目比较特殊的地方在于它还有一个Web资源目录，其默认位置是src/main/we-bapp/。一个典型的Web项目的Maven目录结构如下：

```bash
+project
|
+pom.xml
|
+src/
  +main/
  | +java/
  | | +ServletA.java
  | | +……
  | |
  | +resources/
  | | +config.properties
  | | +……
  | |
  | +webapp/    # 在src/main/webapp/目录下，必须包含一个子目录WEB-INF
  |   +WEB-INF/ # 该子目录还必须要包含web.xml文件
  |   | +web.xml 
  |   |
  |   +img/
  |   |
  |   +css/
  |   |
  |   +js/
  |   +
  |   +index.html
  |   +sample.jsp
  |
  +test/
    +java/
    +resources/
```

### 12.2 account-service

#### 12.2.1 account-service的POM

account-service用来封装account-email、account-persist和account-captcha三个模块的细节，因此它肯定需要依赖这三个模块。account-service的POM内容：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <!-- 与其他模块一样，account-service继承自account-parent -->
    <parent>
        <groupId>com.angus.mvnbook.account</groupId>
        <artifactId>account-parent</artifactId>
        <version>1.0.0-SNAPSHOT</version>
    </parent>

    <artifactId>account-service</artifactId>
    <name>Account Service</name>

    <properties>
        <greenmail.version>1.5.7</greenmail.version>
    </properties>

    <dependencies>
        <!-- account-service依赖于account-email、account-persist和account-captcha -->
        <dependency>
            <!-- 由于是同一项目中的其他模块，groupId和version都完全一致，
                 因此可以用Maven属性${project.groupId}和${project.version}进行替换 -->
            <groupId>${project.groupId}</groupId>
            <artifactId>account-email</artifactId>
            <version>${project.version}</version>
        </dependency>
        <dependency>
            <groupId>${project.groupId}</groupId>
            <artifactId>account-persist</artifactId>
            <version>${project.version}</version>
        </dependency>
        <dependency>
            <groupId>${project.groupId}</groupId>
            <artifactId>account-captcha</artifactId>
            <version>${project.version}</version>
        </dependency>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
        </dependency>
        <dependency>
            <groupId>com.icegreen</groupId>
            <artifactId>greenmail</artifactId>
            <version>${greenmail.version}</version>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <testResources>
            <testResource>
                <directory>src/test/resources</directory>
                <filtering>true</filtering>
            </testResource>
        </testResources>
    </build>

</project>
```

#### 12.2.2 account-service的主代码

### 12.3 account-web

由于account-service已经封装了所有下层细节，account-web只需要在此基础上提供一些Web页面，并使用简单Servlet与后台实现交互控制。

#### 12.3.1 account-web的POM

```xml
<?xml version="1.0" encoding="UTF-8"?>

<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <parent>
        <groupId>com.angus.mvnbook.account</groupId>
        <artifactId>account-parent</artifactId>
        <version>1.0.0-SNAPSHOT</version>
    </parent>

    <artifactId>account-web</artifactId>
    <!-- 除了使用打包方式为war之外，Web项目与一般项目没有多大的区别 -->
    <packaging>war</packaging>
    <name>Account Web</name>

    <dependencies>
        <!-- account-web模块依赖account-service模块 -->
        <dependency>
            <groupId>${project.groupId}</groupId>
            <artifactId>account-service</artifactId>
            <version>${project.version}</version>
        </dependency>
        <!-- 几乎所有的web项目都依赖servlet-api和jsp-api，它们为servlet和jsp的编写提供支持 -->
        <dependency>
            <groupId>javax.servlet</groupId>
            <artifactId>servlet-api</artifactId>
            <version>2.5</version>
            <!-- 依赖范围为provided，表示最终不会被打包至war文件中，因为几乎所有的Web容器都提供了这两个类库 -->
            <scope>provided</scope>
        </dependency>
        <dependency>
            <groupId>javax.servlet.jsp</groupId>
            <artifactId>jsp-api</artifactId>
            <version>2.2</version>
            <scope>provided</scope>
        </dependency>
        <!-- spring-web为Web应用提供Spring的集成支持 -->
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-web</artifactId>
        </dependency>
    </dependencies>

    <build>
        <resources>
            <resource>
                <directory>src/main/resources</directory>
                <filtering>true</filtering>
            </resource>
        </resources>
        <pluginManagement>
            <plugins>
                <plugin>
                    <groupId>org.mortbay.jetty</groupId>
                    <artifactId>jetty-maven-plugin</artifactId>
                    <version>7.1.0.RC1</version>
                    <configuration>
                        <scanIntervalSeconds>10</scanIntervalSeconds>
                        <webAppConfig>
                            <contextPath>/account</contextPath>
                        </webAppConfig>
                    </configuration>
                </plugin>
            </plugins>
        </pluginManagement>
    </build>
</project>

```

在一些Web项目中，可能会看到finalName元素的配置。该元素用来标识项目生成的主构件的名称，该元素的默认值已在超级POM中设定，值为${project.artifactId}-${project.version}。因此上述代码清单对应的主构件名称为account-web-1.0.0-SNAPSHOT.war，这样的名称显然不利于部署。这时可以如下所示配置finalName元素：

```xml
<!-- 经此配置后，项目生成的war包名称就会成为account.war，更方便部署 -->
<finalName>account</finalName>
```

#### 12.3.2 account-web的主代码

### 12.4 使用jetty-maven-plugin进行测试

传统的Web测试方法要求我们编译、测试、打包及部署，这往往会消耗数10秒至数分钟的时间，jetty-maven-plugin能够帮助我们节省时间，它能够周期性地检查项目内容，发现变更后自动更新到内置的Jetty Web容器中，这时就可以直接测试Web页面了。

使用jetty-maven-plugin十分简单。指定该插件的坐标，并且稍加配置即可：

```xml
<plugin>
    <groupId>org.mortbay.jetty</groupId>
    <artifactId>jetty-maven-plugin</artifactId>
    <version>7.1.0.RC1</version>
    <configuration>
        <!-- scanIntervalSeconds表示该插件扫描项目时间间隔 -->
        <scanIntervalSeconds>10</scanIntervalSeconds>
        <!-- webappConfig元素下的contextPath表示项目部署后的context path -->
        <!-- 这里的值为/test，即可以通过http://hostname:port/account/访问该应用 -->
        <webAppConfig>
            <contextPath>/account</contextPath>
        </webAppConfig>
    </configuration>
</plugin>
```

为了能在命令行直接运行mvn jetty:run，需要配置settings.xml如下：

```xml
<pluginGroups>
    <!-- pluginGroup
     | Specifies a further group identifier to use for plugin lookup.
    <pluginGroup>com.your.plugins</pluginGroup>
    -->
    <pluginGroup>org.mortbay.jetty</pluginGroup>
</pluginGroups>
```

### 12.5 使用Cargo实现自动化部署

### 12.6 小结

本章介绍的是用Maven管理Web项目，因此首先讨论了Web项目的基本结构，然后分析最后两个模块：account-service和account-web，其中后者是一个典型的Web模块。开发Web项目的时候，大家往往会使用热部署来实现快速的开发和测试，jetty-maven-plugin可以帮助实现这一目标。最后讨论的是自动化部署，这一技术的主角是Cargo，有了它，可以让Maven自动部署应用至本地和远程Web容器中。





















