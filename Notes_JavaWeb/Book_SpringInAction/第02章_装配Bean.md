### 2.1 Spring配置的可选方案

当描述bean如何进行装配时，Spring具有非常大的灵活性，它提供了三种主要的装配机制：

(1) 在XML中进行显式配置。

(2) 在Java中进行显式配置。

(3) 隐式的bean发现机制和自动装配。

### 2.2 自动化装配bean 

Spring从两个角度来实现自动化装配：

(1) 组件扫描（component scanning）：Spring会自动发现应用上下文中所创建的bean。

(2) 自动装配（autowiring）：Spring自动满足bean之间的依赖。

#### 2.2.1 创建可被发现的bean

(1) @Component注解表明该类会作为组件类，并告知Spring要为这个类创建bean。

```java
@Component
public class SgtPeppers implements CompactDisc {}
```

(2) @Configuration注解表明这个类是一个配置类，该类应该包含在Spring应用上下文中如何创建bean的细节；@ComponentScan注解能够在Spring中启用组件扫描。如果没有其他配置的话，@ComponentScan默认会扫描与配置类相同的包。 

```java
@Configuration
@ComponentScan
public class CDPlayerConfig {}
```

 (3) CDPlayerTest使用了Spring的SpringJUnit4ClassRunner，以便在测试开始的时候自动创建Spring的应用上下文。注解@ContextConfiguration会告诉它需要在CDPlayerConfig中加载配置。 

```java
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = CDPlayerConfig.class)
public class CDPlayerTest {

    @Autowired
    private CompactDisc cd;

    @Test
    public void cdShouldNotNull() {
        Assert.assertNotNull(cd); // Spring能够发现CompactDisc类，自动在Spring上下文中
    }                             // 将其创建为bean并将其注入到测试代码之中。
}
```

#### 2.2.2 为组件扫描的bean命名

Spring应用上下文中所有的bean都会给定一个ID。在前面的例子中，尽管我们没有明确地为SgtPeppersbean设置ID，但Spring会根据类名为其指定一个ID。具体来讲，这个bean所给定的ID为sgtPeppers，也就是将类名的第一个字母变为小写。

如果想为这个bean设置不同的ID，你所要做的就是将期望的ID作为值传递给@Component注解。比如说，如果想将这个bean标识为lonelyHeartsClub，那么你需要将SgtPeppers类的@Component注解配置为如下所示：

```java
@Component("lonelyHeartsClub")
public class SgtPeppers implements CompactDisc {}
```

#### 2.2.3 设置组件扫描的基础包

想要将配置类放在单独的包中，使其与其他的应用代码区分开来。此时需要做的就是在@ComponentScan的value属性中指明包的名称：

```java
@Configuration
@ComponentScan("autoconfig.soundsystem")
public class CDPlayerConfig {
}
```

若想更加清晰地表明所设置的是基础包可以通过basePackages属性进行配置： 

```java
@Configuration
@ComponentScan(basePackages = "autoconfig.soundsystem")
public class CDPlayerConfig {
}

// 还可以指定多个基础包
@Configuration
@ComponentScan(basePackages = {"autoconfig.soundsystem", "autoconfig.musicsystem"})
public class CDPlayerConfig {
}
```

除了将包设置为简单的String类型之外，@ComponentScan还提供了另外一种方法，那就是将其指定为包中所包含的类或接口： 

```java
@Configuration
@ComponentScan(basePackageClasses = {CompactDisc.class,...})
public class CDPlayerConfig {
}
```

#### 2.2.4 通过为bean添加注解实现自动装配

简单来说，自动装配就是让Spring自动满足bean依赖的一种方法，在满足依赖的过程中，会在Spring应用上下文中寻找匹配某个bean需求的其他bean。为了声明要进行自动装配，我们可以借助Spring的@Autowired注解。

```java
@Component
public class CDPlayer implements MediaPlayer {

    private CompactDisc cd;

    @Autowired
    public CDPlayer(CompactDisc cd){
        this.cd = cd;
    }

    @Override
    public void play() {
        cd.play();
    }
}
```

在Spring初始化bean之后，它会尽可能得去满足bean的依赖，在本例中，依赖是通过带有@Autowired注解的方法进行声明的。不管是构造器、Setter方法还是其他的方法，Spring都会尝试满足方法参数上所声明的依赖。假如有且只有一个bean匹配依赖需求的话，那么这个bean将会被装配进来。

如果没有匹配的bean，那么在应用上下文创建的时候，Spring会抛出一个异常。为了避免异常的出现，可以将@Autowired的required属性设置为false：

```java
 @Autowired(required = false)
```

将required属性设置为false时，Spring会尝试执行自动装配，但是如果没有匹配的bean的话，Spring将会让这个bean处于未装配的状态。如果代码中没有进行null检查的话，这个处于未装配状态的属性有可能会出现NullPointerException。 如果有多个bean都能满足依赖关系的话，Spring将会抛出一个异常，表明没有明确指定要选择哪个bean进行自动装配。

#### 2.2.5 验证自动装配

```java
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = CDPlayerConfig.class)
public class CDPlayerTest {

    @Autowired
    private MediaPlayer player;

    @Autowired
    private CompactDisc cd;

    @Test
    public void cdShouldNotNull() {
        assertNotNull(cd);
    }

    @Test
    public void play() {
        player.play();
    }
}
```

### 2.3 通过Java代码装配bean

#### 2.3.1 创建配置类

在此前的基础上，在CDPlayerConfig类中去掉了ComponentScan注解，关掉了注解扫描，使用显式配置。

#### 2.3.2 声明简单的bean

```java
@Bean
public CompactDisc sgtPeppers(){
    return new SgtPeppers();
}
```

@Bean注解会告诉Spring这个方法将会返回一个对象，该对象要注册为Spring应用上下文中的bean。方法体中包含了最终产生bean实例的逻辑。默认情况下，bean的ID与带有@Bean注解的方法名是一样的，可以自定义。 

#### 2.3.3  借助JavaConfig实现注入

```java
@Configuration
public class CDPlayerConfig {
    @Bean
    public CompactDisc compactDisc() {
        return new SgtPeppers();
    }

    @Bean
    public CDPlayer cdPlayer(CompactDisc compactDisc) {
        return new CDPlayer(compactDisc);
    }
}
```

### 2.4 通过XML装配bean

#### 2.4.1 创建XML配置规范

#### 2.4.2 声明一个简单的\<bean\>

```xml
 <bean id="compactDisc" class="xmlconfig.soundsystem.SgtPeppers" />
```

# 2.4.3 借助构造器注入初始化bean

在Spring XML配置中，只有一种声明bean的方式：使用`<bean>`元素并指定class属性。Spring会从这里获取必要的信息来创建bean。

在XML中声明DI时，会有多种可选的配置方案和风格。具体到构造器注入，有两种基本的配置方案可供选择：

(1) `<constructor-arg>`元素

(2) 使用Spring 3.0所引入的c-命名空间

两者的区别在很大程度就是是否冗长烦琐。可以看到，`<constructor-arg>`元素比使用c-命名空间会更加冗长，从而导致XML更加难以读懂。另外，有些事情`<constructor-arg>`可以做到，但是使用c-命名空间却无法实现。

**构造器注入bean引用**

```xml
<bean id="cdPlayer" class="xmlconfig.soundsystem.CDPlayer">
    <constructor-arg ref="compactDisc"/>
</bean>

<!-- 使用c命名空间 -->
<beans ...
       xmlns:c="http://www.springframework.org/schema/c"
       ... >

<bean id="cdPlayer" class="xmlconfig.soundsystem.CDPlayer" c:cd-ref="compactDisc"/>
```

在这里，我们使用了c-命名空间来声明构造器参数，它作为`<bean>`元素的一个属性，不过这个属性的名字有点诡异。 

![1526602664332](assets/1526602664332.png)

 **将字面量注入到构造器中** 