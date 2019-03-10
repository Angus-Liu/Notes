### 17.1 编写Maven插件的一般步骤

编写Maven插件的主要步骤：

1. 创建一个maven-plugin项目：插件本身也是Maven项目，特殊的地方在于它的packaging必须是maven-plugin，可以使用maven-archetype-plugin快速创建一个Maven插件项目。
2. 为插件编写目标：每个插件都必须包含一个或者多个目标，Maven称之为Mojo（与POJO对应，后者指Plain Old Java Object，这里指Maven Old Java Object）。编写插件的时候必须提供一个或者多个继承自AbstractMojo的类。
3. 为目标提供配置点：大部分Maven插件及其目标都是可配置的，因此在编写Mojo的时候需要注意提供可配置的参数。
4. 编写代码实现目标行为：根据实际的需要实现Mojo。
5. 错误处理及日志：当Mojo发生异常时，根据情况控制Maven的运行状态。在代码中编写必要的日志以便为用户提供足够的信息。
6. 测试插件：编写自动化的测试代码测试行为，然后再实际运行插件以验证其行为。

### 17.2 案例：编写一个用于代码统计的Maven插件

要创建一个Maven插件项目，首先使用maven-archetype-plugin命令：

```bash
$mvn archetype:generate
# 然后选择
maven-archetype-plugin（An archetype which contains a sample Maven plugin.）
```

输入Maven坐标等信息之后，一个Maven插件项目就创建好了。

```xml
<?xml version="1.0" encoding="UTF-8"?>


<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>

  <groupId>com.angus.mvnbook</groupId>
  <artifactId>maven-ioc-plugin</artifactId>
  <version>0.0.1-SNAPSHOT</version>
  <packaging>maven-plugin</packaging>

  <name>maven-ioc-plugin Maven Plugin</name>
  
  <!-- FIXME change it to the project's website -->
  <url>http://www.example.com</url>

  <prerequisites>
    <maven>${maven.version}</maven>
  </prerequisites>

  <properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <maven.compiler.source>1.7</maven.compiler.source>
    <maven.compiler.target>1.7</maven.compiler.target>
    <maven.version>3.3.9</maven.version>
  </properties>

  <dependencies>
    <dependency>
      <groupId>org.apache.maven</groupId>
      <artifactId>maven-plugin-api</artifactId>
      <version>${maven.version}</version>
      <scope>provided</scope>
    </dependency>
    <dependency>
      <groupId>org.apache.maven</groupId>
      <artifactId>maven-core</artifactId>
      <version>${maven.version}</version>
      <scope>provided</scope>
    </dependency>
    <dependency>
      <groupId>org.apache.maven</groupId>
      <artifactId>maven-artifact</artifactId>
      <version>${maven.version}</version>
      <scope>provided</scope>
    </dependency>
    <dependency>
      <groupId>org.apache.maven</groupId>
      <artifactId>maven-compat</artifactId>
      <version>${maven.version}</version>
      <scope>test</scope>
    </dependency> 
    <dependency>
      <groupId>org.apache.maven.plugin-tools</groupId>
      <artifactId>maven-plugin-annotations</artifactId>
      <version>3.5.1</version>
      <scope>provided</scope>
    </dependency>
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>4.12</version>
      <scope>test</scope>
    </dependency>
    <dependency>
      <groupId>org.apache.maven.plugin-testing</groupId>
      <artifactId>maven-plugin-testing-harness</artifactId>
      <version>3.3.0</version>
      <scope>test</scope>
    </dependency>
  </dependencies>

  <build>
    <pluginManagement><!-- lock down plugins versions to avoid using Maven defaults (may be moved to parent pom) -->
      <plugins>
        <plugin>
          <artifactId>maven-clean-plugin</artifactId>
          <version>3.0.0</version>
        </plugin>
        <!-- see http://maven.apache.org/ref/current/maven-core/default-bindings.html#Plugin_bindings_for_maven-plugin_packaging -->
        <plugin>
          <artifactId>maven-resources-plugin</artifactId>
          <version>3.0.2</version>
        </plugin>
        <plugin>
          <artifactId>maven-compiler-plugin</artifactId>
          <version>3.7.0</version>
        </plugin>
        <plugin>
          <artifactId>maven-plugin-plugin</artifactId>
          <version>3.5.1</version>
        </plugin>
        <plugin>
          <artifactId>maven-surefire-plugin</artifactId>
          <version>2.20.1</version>
        </plugin>
        <plugin>
          <artifactId>maven-jar-plugin</artifactId>
          <version>3.0.2</version>
        </plugin>
        <plugin>
          <artifactId>maven-install-plugin</artifactId>
          <version>2.5.2</version>
        </plugin>
        <plugin>
          <artifactId>maven-deploy-plugin</artifactId>
          <version>2.8.2</version>
        </plugin>
        <plugin>
          <artifactId>maven-invoker-plugin</artifactId>
          <version>3.0.1</version>
        </plugin>
      </plugins>
    </pluginManagement>
    <plugins>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-plugin-plugin</artifactId>
        <version>3.5.1</version>
        <configuration>
          <!-- <goalPrefix>maven-archetype-plugin</goalPrefix> -->
          <skipErrorNoDescriptorsFound>true</skipErrorNoDescriptorsFound>
        </configuration>
        <executions>
          <execution>
            <id>mojo-descriptor</id>
            <goals>
              <goal>descriptor</goal>
            </goals>
          </execution>
          <execution>
            <id>help-goal</id>
            <goals>
              <goal>helpmojo</goal>
            </goals>
          </execution>
        </executions>
      </plugin>
    </plugins>
  </build>

  <profiles>
    <profile>
      <id>run-its</id>
      <build>

        <plugins>
          <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-invoker-plugin</artifactId>
            <version>3.0.1</version>
            <configuration>
              <debug>true</debug>
              <cloneProjectsTo>${project.build.directory}/it</cloneProjectsTo>
              <pomIncludes>
                <pomInclude>*/pom.xml</pomInclude>
              </pomIncludes>
              <postBuildHookScript>verify</postBuildHookScript>
              <localRepositoryPath>${project.build.directory}/local-repo</localRepositoryPath>
              <settingsFile>src/it/settings.xml</settingsFile>
              <goals>
                <goal>clean</goal>
                <goal>test-compile</goal>
              </goals>
            </configuration>
            <executions>
              <execution>
                <id>integration-test</id>
                <goals>
                  <goal>install</goal>
                  <goal>integration-test</goal>
                  <goal>verify</goal>
                </goals>
              </execution>
            </executions>
          </plugin>
        </plugins>
      </build>
    </profile>
  </profiles>
</project>

```

Maven插件项目的POM有两个特殊的地方：

1. 它的packaging必须为maven-plugin，这种特殊的打包类型能控制Maven为其在生命周期阶段绑定插件处理相关的目标，例如在compile阶段，Maven需要为插件项目构建一个特殊插件描述符文件。
2. 从上述代码中可以看到一个artifactId为maven-plugin-api的依赖，该依赖中包含了插件开发所必需的类，例如稍后会看到的AbstractMojo。

### 17.3 Mojo标注

### 17.4 Mojo参数

### 17.5 错误处理和日志

### 17.6 测试Maven插件

### 17.7 小结

编写Maven插件的一般步骤包括创建一个插件项目、编写Mojo、为Mojo提供配置点、实现Mojo行为、处理错误、记录日志和测试插件等。本章实现了一个简单的代码行统计插件，并逐步展示了上述步骤。在编写自己插件的时候，还可以参考本章描述的各种Mojo标注、Mojo参数、异常类型和日志接口。本章最后介绍了如何使用maven-invoker-plugin实现插件的自动化集成测试。

