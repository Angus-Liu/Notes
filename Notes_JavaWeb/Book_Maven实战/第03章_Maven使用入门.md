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

项目主代码和测试代码不同，项目的主代码会被打包到最终的**构件**中（如jar），而测试代码只在运行测试时用到，不会被打包。默认情况下，Maven假设项目主代码位于**`src/main/java`**目录中，Maven会自动搜寻该目录找到项目主代码。

```java
// 该Java类的包名是com.juvenxu.mvnbook.helloworld，
// 这与之前在POM中定义的groupId和artifactId相吻合
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

