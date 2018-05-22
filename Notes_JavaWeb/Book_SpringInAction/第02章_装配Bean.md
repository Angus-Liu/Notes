### 2.1 Spring配置的可选方案

当描述bean如何进行装配时，Spring具有非常大的灵活性，它提供了三种主要的装配机制：

+ 在XML中进行显式配置。
+ 在Java中进行显式配置。（比XML配置更好）
+ 隐式的bean发现机制和自动装配。（尽量采用）

### 2.2 自动化装配bean 

Spring从两个角度来实现自动化装配：

+ 组件扫描（component scanning）：Spring会自动发现应用上下文中所创建的bean。
+ 自动装配（autowiring）：Spring自动满足bean之间的依赖。

#### 2.2.1 创建可被发现的bean

CompactDisc接口在Java中定义了CD的概念：

```java
package com.angus.stereo.autoconfig;

public interface CompactDisc {
    void play();
}
```

带有@Component注解的CompactDisc实现类SgtPeppers：

```java
package com.angus.stereo.autoconfig;
import org.springframework.stereotype.Component;

@Component // @Component注解表明该类会作为组件类，并告知Spring要为这个类创建bean。
public class SgtPeppers implements CompactDisc {

    private String title = "Sgt. Pepper's Lonely Hearts Club Band";
    private String artist = "The Beatles";

    @Override
    public void play() {
        System.out.println("Playing " + title + " by " + artist);
    }
}
```

组件扫描默认是不启用的。我们还需要显式配置一下Spring，从而命令它去寻找带有@Component注解的类，并为其创建bean：

```java
package com.angus.stereo.autoconfig;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

// @Configuration注解表明这是一个配置类，该类应该包含在Spring应用上下文中如何创建bean的细节；
@Configuration 
// @ComponentScan注解能够在Spring中启用组件扫描。如果没有其他配置的话，默认会扫描与配置类所在的包及子包。 
@ComponentScan 
public class CDPlayerConfig {
}
```

也可以是使用XML来启用组件扫描：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd">

    <context:component-scan base-package="com.angus.stereo.autoconfig"/>
    
</beans>
```

为了测试组件扫描的功能，我们创建一个简单的JUnit测试，它会创建Spring上下文，并判断CompactDisc是不是真的创建出来了：

```java
package com.angus.stereo.autoconfig;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import static org.junit.Assert.assertNotNull;

// 使用了SpringJUnit4ClassRunner，以便在测试时自动创建Spring的应用上下文
@RunWith(SpringJUnit4ClassRunner.class)
// 注解@ContextConfiguration会告诉它需要在CDPlayerConfig中加载配置
@ContextConfiguration(classes = CDPlayerConfig.class) 
public class CDplayerTest {

    @Autowired // 添加@Autowired注解，以便将CompactDisc注入到测试代码中
    private CompactDisc cd;  // Spring能够发现CompactDisc类，自动在Spring上下文中将其创建为bean并将其注入到测试代码之中。

    @Test
    public void cdShoudleNotNull() {
        assertNotNull(cd);
    }

}
```

#### 2.2.2 为组件扫描的bean命名

Spring应用上下文中所有的bean都会给定一个ID。在前面的例子中，这个bean所给定的ID为sgtPeppers，也就是将类名的第一个字母变为小写。

如果想为这个bean设置不同的ID，比如说lonelyHeartsClub，那么需要将SgtPeppers类的@Component注解配置为如下所示：

```java
@Component("lonelyHeartsClub") // 可以用@Named注解替代，但是不推荐
public class SgtPeppers implements CompactDisc {
    ...
}
```

#### 2.2.3 设置组件扫描的基础包

想要将配置类放在单独的包中，使其与其他的应用代码区分开来。此时需要做的就是在@ComponentScan的value属性中指明待扫描的包名称：

```java
@Configuration
@ComponentScan("com.angus.stereo.autoconfig")
public class CDPlayerConfig {
    ...
}
```

若想更加清晰地表明所设置的是基础包，可以通过basePackages属性进行配置： 

```java
@Configuration
@ComponentScan(basePackages = "com.angus.stereo.autoconfig")
public class CDPlayerConfig {
    ...
}

// 还可以指定多个基础包
@Configuration
@ComponentScan(basePackages = {"com.angus.stereo.autoconfig.soundsystem", "com.angus.stereo.autoconfig.musicsystem"})
public class CDPlayerConfig {
    ...
}
```

除了将包设置为简单的String类型之外，@ComponentScan还提供了另外一种更为安全的方法，那就是将其指定为待扫描包中所包含的类或接口： 

```java
@Configuration
@ComponentScan(basePackageClasses = {CompactDisc.class,...})
public class CDPlayerConfig {
    ...
}
```

#### 2.2.4 通过为bean添加注解实现自动装配

简单来说，自动装配就是让Spring自动满足bean依赖的一种方法，在满足依赖的过程中，会在Spring应用上下文中寻找匹配某个bean需求的其他bean。为了声明要进行自动装配，我们可以借助Spring的@Autowired注解。

```java
package com.angus.stereo.autoconfig;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class CDPlayer implements MediaPlayer {

    private CompactDisc cd;

    // @Autowired注解表明当Spring创建CDPlayerbean的时候，
    // 会通过这个构造器来进行实例化并且会传入一个CompactDisc类型的bean
    @Autowired
    public CDPlayer(CompactDisc cd){
        this.cd = cd;
    }

    public void play() {
        cd.play();
    }
}

```

@Autowired注解不仅能够用在构造器上，还能用在属性的Setter或其他方法上：

```java
@Autowired
public void setCd(CompactDisc cd) {
    this.cd = cd;
}

@Autowired
public void insertDisc(CompactDisc cd) {
    this.cd = cd;
}
```

如果没有匹配的bean，在应用上下文创建的时候，Spring会抛出一个异常。为了避免异常的出现，可以将@Autowired的required属性设置为false：

```java
// 将required属性设置为false时，如果没有匹配的bean的话，Spring将会让这个bean处于未装配的状态 
@Autowired(required = false) 
```

#### 2.2.5 验证自动装配

```java
package com.angus.stereo.autoconfig;
import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.contrib.java.lang.system.StandardOutputStreamLog;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes=CDPlayerConfig.class)
public class CDPlayerTest {

    // 该样例中使用了StandardOutputStreamLog，
    // 这是来源于System Rules库的一个JUnit规则，该规则能够基于控制台的输出编写断言
    @Rule
    public final StandardOutputStreamLog log = new StandardOutputStreamLog();

    @Autowired
    private MediaPlayer player;

    @Autowired
    private CompactDisc cd;

    @Test
    public void cdShouldNotBeNull() {
        assertNotNull(cd);
    }

    @Test
    public void play() {
        player.play();
        assertEquals(
                "Playing Sgt. Pepper's Lonely Hearts Club Band by The Beatles\r\n",
                log.getLog());
    }
}
```

### 2.3 通过Java代码装配bean

在此前的基础上，在CDPlayerConfig类中去掉了ComponentScan注解，关掉注解扫描，使用显式配置。在进行显式配置时，JavaConfig是更好的方案，因为它更为强大、类型安全并且对重构友好。

在概念上，JavaConfig与应用程序中的业务逻辑和领域代码是不同的，它不应该包含任何业务逻辑，也不应该侵入到业务逻辑代码之中。尽管不是必须的，但通常会将JavaConfig放到单独的包中。

#### 2.3.1 创建配置类

```java
package com.angus.stereo.autoconfig;
import org.springframework.context.annotation.Configuration;

// @Configuration注解表明这是一个配置类，其包含在Spring应用上下文中如何创建bean的细节
@Configuration 
public class CDPlayerConfig {
    
}
```

#### 2.3.2 声明简单的bean

要在JavaConfig中声明bean，需要编写一个方法，这个方法会创建所需类型的实例，然后给这个方法添加@Bean注解：

```java
package com.angus.stereo.autoconfig;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class CDPlayerConfig {

    // @Bean注解会告诉Spring这个方法将会返回一个对象，该对象要注册为Spring应用上下文中的bean
    @Bean
    public CompactDisc sgtPeppers(){
        return new SgtPeppers(); // 方法体中包含了最终产生bean实例的逻辑
    }
}
```

#### 2.3.3  借助JavaConfig实现注入

在JavaConfig中装配bean的最简单方式就是引用创建bean的方法：

```java
@Bean
public CDPlayer cdPlayer(){
    // 因为sgtPeppers()方法上添加了@Bean注解，Spring将会拦截所有对它的调用，
    // 并确保直接返回Spring所创建的bean，而不是每次都对其进行实际的调用
    return new CDPlayer(sgtPeppers());
}
```

还有一种理解起来更为简单的方式：

```java
@Bean
public CDPlayer cdPlayer(CompactDisc compactDisc){
    return new CDPlayer(compactDisc);
}
```

### 2.4 通过XML装配bean

在装配bean的时候，还有一种可选方案，尽管这种方案可能不太合乎大家的心意，但是它在Spring中已经有很长的历史了。在Spring刚刚出现的时候，XML是描述配置的主要方式。鉴于已经存在那么多基于XML的Spring配置，所以理解如何在Spring中使用XML还是很重要的。

#### 2.4.1 创建XML配置规范

在使用XML为Spring装配bean之前，需要创建一个新的配置规范。这意味着要创建一个XML文件，并且要以\<beans>元素为根。最为简单的Spring XML配置如下所示：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!-- <beans>是该模式中的一个元素，它是所有Spring配置文件的根元素 -->
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans 
                           http://www.springframework.org/schema/beans/spring-beans.xsd http://www.springframework.org/schema/context 
                           http://www.springframework.org/schema/context/spring-context.xsd">
    ...
</beans>
```

#### 2.4.2 声明一个简单的\<bean>

要在基于XML的Spring配置中声明一个bean，要使用spring-beans模式中的另外一个元素：\<bean>

```xml
<!-- <bean>元素类似于JavaConfig中的@Bean注解 -->
<!-- 因为没有明确给定ID，所以这个bean将会根据全限定类名来进行命名，
     在本例中，bean的ID将会是“soundsystem.SgtPeppers#0” -->
<bean class="com.angus.stereo.xmlconfig.SgtPeppers"/>

<!-- 更好的办法是借助id属性，为每个bean设置一个名字 -->
<bean id="compactDisc" class="com.angus.stereo.xmlconfig.SgtPeppers"/>
```

#### 2.4.3 借助构造器注入初始化bean

在Spring XML配置中，只有一种声明bean的方式：使用\<bean>元素并指定class属性。Spring会从这里获取必要的信息来创建bean。

在XML中声明DI时，会有多种可选的配置方案和风格。具体到构造器注入，有两种基本的配置方案可供选择：

+ \<constructor-arg>元素
+ 使用Spring 3.0所引入的c-命名空间

两者的区别在很大程度就是是否冗长烦琐。可以看到，\<constructor-arg>元素比使用c-命名空间会更加冗长，从而导致XML更加难以读懂。另外，有些事情\<constructor-arg>可以做到，但是使用c-命名空间却无法实现。

**构造器注入bean引用**

使用\<constructor-arg>元素实现构造器注入引用：

```java
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="compactDisc" class="com.angus.stereo.xmlconfig.SgtPeppers"/>

    <bean id="cdPlayer" class="com.angus.stereo.xmlconfig.CDPlayer" > 
        <constructor-arg ref="compactDisc"/>
    </bean>
    
</beans>
```

使用c-命名空间：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!-- 添加了c命名空间 -->
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:c="http://www.springframework.org/schema/c"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="compactDisc" class="com.angus.stereo.xmlconfig.SgtPeppers"/>
    
    <bean id="cdPlayer" class="com.angus.stereo.xmlconfig.CDPlayer" c:cd-ref="compactDisc"/>

</beans>
```

在这里，我们使用了c-命名空间来声明构造器参数，它作为\<bean>元素的一个属性，不过这个属性的名字有点诡异。 

![1526602664332](assets/1526602664332.png)

 **将字面量注入到构造器中** 