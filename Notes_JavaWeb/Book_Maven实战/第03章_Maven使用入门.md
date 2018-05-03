### 3.1 编写POM

Maven项目的核心是pom.xml。POM（Project Object Model，项目对象模型）定义了项目的基本信息，用于描述项目如何构建，声明项目依赖，等等。

首先创建一个名为hello-world的文件夹，打开该文件夹，新建一个名为pom.xml的文件，输入其内容：

```xml
<?xml version="1.0" encoding="UTF-8"?> <!-- XML头：指定该文档的版本和编码方式 -->
<!-- project是所有pom.xml的根元素 -->
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <!-- modelVersion元素指定当前POM模型的版本，只能是4.0.0 -->
    <modelVersion>4.0.0</modelVersion>

    <!-- groupId、artifactId和version三行是pom.xml中最重要的 -->
    
    <!-- groupId定义了项目属于哪个组（组织或公司），
         譬如在googlecode上建立了一个名为myapp的项目，
         那么groupId就应该是com.googlecode.myapp -->
    <groupId>com.angus.mvnbook</groupId>
    
    <!-- artifactId定义了当前Maven项目在组中的唯一ID，
         在前面的groupId为com.googlecode.myapp的例子中，
         可能会为不同的子项目（模块）分配artifactId，如my-app-util、myapp-domain、myapp-web等 -->
    <artifactId>hello-world</artifactId>
    
    <!-- version指定了项目当前的版本 —— 1.0-SNAPSHOT，
         SNAPSHOT意为快照，说明该项目还处于开发中，是不稳定的版本。-->
    <version>1.0-SNAPSHOT</version>
    
    <!-- name元素声明了一个对于用户更友好的名称，非必须，但建议设置 -->
    <name>Maven Hello World Project</name>

</project>
```

### 3.2 编写主代码

项目主代码和测试代码不同，项目的主代码会被打包到最终的**构件**中（如jar），而测试代码只在运行测试时用到，不会被打包。默认情况下，Maven假设项目主代码位于`src/main/java`目录中，Maven会自动搜寻该目录找到项目主代码。

```java
// 该Java类的包名是com.juvenxu.mvnbook.helloworld，这与之前在POM中定义的groupId和artifactId相吻合
// 项目中Java类的包都应该基于项目的groupId和artifactId，这样更加清晰，更加符合逻辑，也方便搜索构件或者Java类
package com.angus.mvnbook.helloworld;

public class HelloWorld {
    public String sayHello() {
        return "Hello Maven!";
    }

    public static void main(String[] args) {
        System.out.println(new HelloWorld().sayHello());
    }
}
```

代码编写完毕后，使用Maven进行编译，在项目根目录下运行命令mvn clean compile：

```bash
# clean告诉Maven清理输出目录target/，compile告诉Maven编译项目主代码
$ mvn clean compile
[INFO] Scanning for projects...
[INFO]
[INFO] -------------------< com.angus.mvnbook:hello-world >--------------------
[INFO] Building Maven Hello World Project 1.0-SNAPSHOT
[INFO] --------------------------------[ jar ]---------------------------------
[INFO]
# Maven首先执行了clean:clean任务，删除target/目录
[INFO] --- maven-clean-plugin:2.5:clean (default-clean) @ hello-world ---
[INFO] Deleting E:\Temp\helloworld\target
[INFO]
# 接着执行resources:resources任务（未定义项目资源，暂且略过）
[INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ hello-world ---
[WARNING] Using platform encoding (GBK actually) to copy filtered resources, i.e. build is platform dependent!
[INFO] skip non existing resourceDirectory E:\Temp\helloworld\src\main\resources
[INFO]
# 最后执行compiler:compile任务，将项目主代码编译至target/classes目录
[INFO] --- maven-compiler-plugin:3.1:compile (default-compile) @ hello-world ---
[INFO] Changes detected - recompiling the module!
[WARNING] File encoding has not been set, using platform encoding GBK, i.e. build is platform dependent!
[INFO] Compiling 1 source file to E:\Temp\helloworld\target\classes
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 2.199 s
[INFO] Finished at: 2018-05-02T10:38:11+08:00
[INFO] ------------------------------------------------------------------------

```

### 3.3 编写测试代码

Maven项目中默认的测试代码目录是src/test/java。

在Java世界中，由Kent Beck和Erich Gamma建立的JUnit是事实上的单元测试标准。要使用JUnit，首先需要为Hello World项目添加一个JUnit依赖：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.angus.mvnbook</groupId>
    <artifactId>hello-world</artifactId>
    <version>1.0-SNAPSHOT</version>
    <name>Maven Hello World Project</name>

    <!-- dependencies元素下可以包含多个dependency元素以声明项目的依赖 -->
    <dependencies>
        <!-- https://mvnrepository.com/artifact/junit/junit -->
        <dependency>
            <!-- 有了groupId和artifactId以及version，Maven就能够自动下载junit-4.12jar。 -->
            <!-- Maven会自动访问中央仓库（http://repo1.maven.org/maven2/），下载需要的文件 -->
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.12</version>
            <!-- scope为依赖范围，若依赖范围为test则表示该依赖只对测试有效 -->
            <!-- 测试代码中的import JUnit代码是没有问题的，但是如果在主代码中用import JUnit代码，
                 就会造成编译错误。如果不声明依赖范围，那么默认值就是compile，表示该依赖对主代码和测试代码都有效 -->
            <scope>test</scope>
        </dependency>
    </dependencies>

</project>
```

在src/test/java目录下创建创建测试类：

```java
package com.angus.mvnbook.helloworld;

import static org.junit.Assert.assertEquals;
import org.junit.Test;

public class HelloWorldTest {
    @Test
    public void testSayHello() {
        HelloWorld helloWorld = new HelloWorld();
        String result = helloWorld.sayHello();
        assertEquals("Hello Maven!", result);
    }
}
```

一个典型的**单元测试**包含三个步骤：① 准备测试类及数据；② 执行要测试的行为；③ 检查结果。

调用Maven执行测试，运行mvn clean test：

```bash
$ mvn clean test
...
# maven-compiler-plugin:3.1:testCompile任务执行完成，测试代码通过编译之后在target/test-classes下生成了二进制文件
[INFO] --- maven-compiler-plugin:3.1:testCompile (default-testCompile) @ hello-world ---
[INFO] Changes detected - recompiling the module!
[WARNING] File encoding has not been set, using platform encoding GBK, i.e. build is platform dependent!
[INFO] Compiling 1 source file to E:\Temp\helloworld\target\test-classes
[INFO]
# maven-surefire-plugin:2.12.4:test任务运行测试，surefire是Maven中负责执行测试的插件，
# 这里它运行测试用例HelloWorldTest，并且输出测试报告，显示一共运行了多少测试，失败了多少，出错了多少，跳过了多少
[INFO] --- maven-surefire-plugin:2.12.4:test (default-test) @ hello-world ---
[INFO] Surefire report directory: E:\Temp\helloworld\target\surefire-reports

-------------------------------------------------------
 T E S T S
-------------------------------------------------------
Running com.angus.mvnbook.helloworld.HelloWorldTest
Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.131 sec

Results :

Tests run: 1, Failures: 0, Errors: 0, Skipped: 0

[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 6.251 s
[INFO] Finished at: 2018-05-03T08:53:54+08:00
[INFO] ------------------------------------------------------------------------


```

### 3.4 打包和运行

将项目进行编译、测试之后，下一个重要步骤就是打包（package）。Hello World的POM中没有指定打包类型，使用默认打包类型jar。简单地执行命令mvn clean package进行打包：

```shell
$ mvn clean package
...
[INFO]
# maven-jar-plugin:2.4:jar 任务负责打包
# jar插件将项目主代码打包成一个名为hello-world-1.0-SNAPSHOT.jar的文件
# 该文件是根据artifactId-version.jar命名的（可以使用fileName来自定义文件名称）
[INFO] --- maven-jar-plugin:2.4:jar (default-jar) @ hello-world ---
[INFO] Building jar: E:\Temp\helloworld\target\hello-world-1.0-SNAPSHOT.jar
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 6.497 s
[INFO] Finished at: 2018-05-03T08:55:24+08:00
[INFO] ------------------------------------------------------------------------
```

执行mvn clean install命令，将构件安装到本地仓库，使得其他Maven项目可以直接使用该构件：

```shell
$ mvn clean install
...
[INFO] --- maven-jar-plugin:2.4:jar (default-jar) @ hello-world ---
[INFO] Building jar: E:\Temp\helloworld\target\hello-world-1.0-SNAPSHOT.jar
[INFO]
# 执行maven-install-plugin:2.4:install任务，将项目输出的jar安装到本地仓库
[INFO] --- maven-install-plugin:2.4:install (default-install) @ hello-world ---
[INFO] Installing E:\Temp\helloworld\target\hello-world-1.0-SNAPSHOT.jar to C:\Users\GuangSIR\.m2\repository\com\angus\mvnbook\hello-world\1.0-SNAPSHOT\hello-world-1.0-SNAPSHOT.jar
[INFO] Installing E:\Temp\helloworld\pom.xml to C:\Users\GuangSIR\.m2\repository\com\angus\mvnbook\hello-world\1.0-SNAPSHOT\hello-world-1.0-SNAPSHOT.pom
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 7.076 s
[INFO] Finished at: 2018-05-03T09:00:58+08:00
[INFO] ------------------------------------------------------------------------


```

借助插件maven-shade-plugin可构建带有Main-Class信息的可运行jar：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.angus.mvnbook</groupId>
    <artifactId>hello-world</artifactId>
    <version>1.0-SNAPSHOT</version>
    <name>Maven Hello World Project</name>

    <dependencies>
        <!-- https://mvnrepository.com/artifact/junit/junit -->
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.12</version>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-shade-plugin</artifactId>
                <version>3.1.1</version>
                <executions>
                    <execution>
                        <phase>package</phase>
                        <goals>
                            <goal>shade</goal>
                        </goals>
                        <configuration>
                            <transformers>
                                <transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                                    <mainClass>com.angus.mvnbook.helloworld.HelloWorld</mainClass>
                                </transformer>
                            </transformers>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>

</project>
```

执行java -jar命令执行该jar文件：

```shell
$ java -jar hello-world-1.0-SNAPSHOT.jar
Hello Maven!
```

### 3.5 使用Archetype生成项目骨架

若是Maven 3，简单地运行下列命令可帮助生成项目骨架：

```shell
mvn archetype:generate
```













