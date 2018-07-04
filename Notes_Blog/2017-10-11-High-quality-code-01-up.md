---
title: 《编写高质量代码》读书笔记
subtitle: 第01章 Java开发中通用的方法和准则（上）
author: Angus Liu
cdn: header-off
date: 2017-10-11 21:54:57
header-img: https://i.loli.net/2017/10/11/59de2474b4392.jpg
tags:
      - 《编写高质量代码》
      - 读书笔记
      - Java
---
> What matters in life is not what happens to you but what you remember and how you remember it.
> 生命中真正重要的不是你遭遇了什么，而是你记住了哪些事，又是如何铭记的。
> <p align="right"> —— 马尔克斯《百年孤独》 </p>

## 建议1：不要在常量和变量中出现易混淆的字母
1.最基本的Java编码规范
(1) 包名全小写（例如：com.guangsir.test）。
(2) 类名首字母全大写（例如：Apple\People）。
(3) 常量全部大写并用下划线分割（例如：POP_MUSIC_COUNT）。
(4) 变量采用驼峰命名法（Camel Case）。

2.防范在变量中出现易混淆的字母
(1) 字母“l”尽量不要和数字混用，若必须混合，则将“l”大写为“L”。
(2) 大写字母“O”也尽量避免与数字混用，若必须混合，为字母“O”添加注释。

## 建议2：莫让常量蜕变成变量
```Java
public class Client {
	public static void main(String[] args) {
		System.out.println("RAND_CONST的值会变！" + Const.RAND_CONST);
	}
}

/*接口常量*/
interface Const {
	// RAND_CONST的值会变，RAND_CONST已不再是纯粹的常量了
	public static final int RAND_CONST = new Random().nextInt();
}
```
![建议02_1](https://i.loli.net/2017/10/11/59de268e0b5db.png)
![建议02_2](https://i.loli.net/2017/10/11/59de269d8b45b.png)
问题及解决：
(1) 上面常量定义的方式是不可取的，常量应该在编译时期就必须确定其值，而不应该在运行期更改，否者程序的可读性会变得非常差。
(2) 除非是项目的唯一方案，否者不要使用常量会变得功能来实现序列号算法、随机种子的生成。

注意：务必让常量在运行期间保持不变。

## 建议3：三元操作符的类型务必一致
```Java
public class Client {
	public static void main(String[] args) {
		int i = 80;
		String s = String.valueOf(i < 100 ? 90 : 100); // s = "90";
		String s1 = String.valueOf(i < 100 ? 90 : 100.0); // s = "90.0";
		System.out.println("两者是否相等：" + s.equals(s1));
	}
}
```
![建议03](https://i.loli.net/2017/10/11/59de272823c74.png)
三元操作符类型转换规则：
(1) 若两个操作数不可转换，则不做转换，返回值为Object类型。
(2) 若两个操作数是明确类型的表达式（比如变量），则按照正常的二进制数字来转换，int类型转换为long类型，long类型转换为float类型等。
(3) 若两个操作数中有一个是数字S，另外一个是表达式，且其类型为T，那么，若数字S在T的范围内，则转换为T类型；若S超出了T类型的范围，则T转换为S类型（详情参考建议22）。
(4) 若两个操作数都是直接量数字（Literal/或译为字面量），则返回值类型为范围较大者。

注意：保证三元操作符中两个操作数类型一致，即可减少可能的错误发生。

## 建议4：避免带有可变长参数的方法重载
1.可变长参数遵循的一些基本规则
(1) 变长参数必须是方法中最后一个参数
(2) 一个方法不能定义多个变长参数
```Java
public class Client {
	// 简单折扣计算
	public void calPrice(int price, int discount) {
		float knockdownPrice = price * discount / 100.0F;
		System.out.println("简单折扣后的价格是：" + formateCurrency(knockdownPrice));
	}

	// 复杂多折扣计算(变长参数的范围覆盖了非变长参数的范围)
	public void calPrice(int price, int... discounts) {
		float knockdownPrice = price;
		for (int discount : discounts) {
			knockdownPrice = knockdownPrice * discount / 100;
		}
		System.out.println("复杂折扣后的价格是：" + formateCurrency(knockdownPrice));
	}

	// 格式化成本地货币形式
	private String formateCurrency(float price) {
		// 使用NumberFormat的getCurrencyInstance()方法来获取指定语言环境的货币格式。
		return NumberFormat.getCurrencyInstance().format(price / 100);
	}

	public static void main(String[] args) {
		Client client = new Client();
		// 499元货物，打75折
		client.calPrice(49900, 75);
        // 499元货物，打75折,会员日，再打9折
		client.calPrice(49900, 75, 90);
	}
}
```
![建议04](https://i.loli.net/2017/10/11/59de2779b9363.png)
为什么第一次使用的是“简单折扣方法”，编译器为什么会首先根据2个int类型的实参而不是1个int类型、1个int数组类型的实参来查找方法呢？
很简单，因为int是一个原生数据类型，而数组本身是一个对象，编译器想要“偷懒”，于是它会从最简单的开始“猜想”，只要符合编译条件的即可通过，于是出现这个问题。

注意：为了让我们的程序能被人看懂，需要慎重考虑变长参数的方法的重载，防止陷入小陷阱。

## 建议5：别让null值和空值威胁到变长方法
```Java
public class Client {
	public void method(String str, Integer... is) {

	}

	public void method(String str, String... strs) {

	}

	public static void main(String[] args) {
		Client client = new Client();
		client.method("China", 0);
		client.method("China", "people");
		client.method("China"); // The method method(String, Integer[]) is ambiguous for the type Client
		client.method("China", null); // The method method(String, Integer[]) is ambiguous for the type Client
	}
}
```
![建议05](https://i.loli.net/2017/10/11/59de27c002e64.png)
问题及解决：
(1) 两次编译不过代码提示的信息相同：方法模糊不清，编译器不知道该调用哪一个方法。
(2) 对于client.method("China")语句，根据实参“China”（String类型），两个方法都符合形参格式，编译器不知道调用哪一个方法，于是报错。这个错在于Client类的设计者违反了KISS原则（Keep It Simple，Stupid，即懒人原则）。
(3) 对于client.method("China", null)语句，直接量null是没有类型的，虽然两个method方法都符合请求，但不知道调用哪一个，于是报错。除了不符合懒人原则外，这里还有一个非常不好的编码习惯，即调用者隐藏了实参类型，这是非常危险的，不仅调用者需要猜测该调用哪一个方法，而且被调用者也可能产生内部逻辑混乱的问题。

对于本例，应做如下修改。也就是让编译器知道这个null值是String类型的，编译就可顺利通过，减少了错误的发生。
```Java
public static void main(String[] args) {
		Client client = new Client();		
		String[] strs = null;
		client.method("China", strs);
}
```

## 建议6：覆写变长方法也循规蹈矩
覆写必须满足的条件：
(1) 重写方法不能缩小访问权限
(2) **参数列表必须与被重写方法相同**
(3) 返回类型必须与被重写方法相同或是其子类
(4) 重写方法不能抛出新的异常，或是超出父类异常范围的异常，但是可以抛出更少、更有限的异常，或者不抛出异常。

为什么“参数列表必须与被重写方法相同”？
```Java
public class Client {
	public static void main(String[] args) {
		// 向上转型
		Base base = new Sub();
		base.fun(100, 50);

		// 不转型
		Sub sub = new Sub();
		sub.fun(100, 50);
	}

}

// 基类
class Base {
	void fun(int price, int... discounts) {
		System.out.println("Base... fun");
	}
}

// 子类 覆写父类方法
class Sub extends Base {
	@Override
	void fun(int price, int[] discounts) { // 参数列表写法与父类不同，但编译后一样（一个int类型的形参加一个int数组类型的形参）
		System.out.println("Sub... fun");
	}
}
```
![建议06](https://i.loli.net/2017/10/11/59de289b6211b.png)
编译不通过，问题在于什么地方?
(1) 首先说明，问题不在于@override注解，因为覆写是正确的，父类的fun()方法编译后形成的形参就是一个int类型的形参与一个int数组类型的形参，子类的参数列表也是如此，所以@override注解没有问题，只是Eclipse会提示这是不好的编码风格。
(2) 问题在于“sub.fun(100, 50)”这条语句，提示找不到 fun(int, int)方法。奇怪的地方在于，既然@override没有报错，那就覆写成功了。但是同样的参数、方法名，通过父类调用没有任何问题，通过子类调用却编译不过。事实上，base对象是把子类对象做了向上转型，其调用的是父类的可变长参数的fun()方法。而sub则调用的是子类的fun()方法，因为数组本身也是一个对象，编译器不能在两个没有继承关系的类之间做转换（int类型和int数组类型），加上java是严格要求类型匹配的，所以编译出错。

注意：这是个特例，覆写的方法参数竟然可以与父类不相同，这就违背了覆写的定义，从而会引发一系列莫名其妙的错误，所以覆写变长方法是也要严格遵循规范。覆写的方法参数与父类相同，不仅仅是类型、数量，还包括显示形式。

## 建议7：警惕自增的陷阱
```Java
public class Client {
	public static void main(String[] args) {
		int count1 = 0;
		int count2 = 0;
		int count3 = 10;
		for(int i = 0; i < 10; i++) {
			count1 = count1++;
			count2 = ++count2;
			count3 = count3--;
		}
		System.out.println("count1=" + count1);
		System.out.println("count2=" + count2);
		System.out.println("count3=" + count3);
	}
}
```
![建议07](https://i.loli.net/2017/10/11/59de28cf0bcc3.png)
为什么count1结果为0，而不是10？
(1) count++是一个表达式，有返回值，它的返回值就是count自加前的值。
(2) Java对于自增是这样处理的：首先把count的值（不是引用）拷贝到一个临时变量区，然后对count变量加1，最后返回临时变量区的值。
(3) 程序第一次循环的详细处理步骤如下：
&emsp;① 步骤1 JVM把count值（0） 拷贝到临时变量区。
&emsp;② 步骤2 count值加1，这时候count的值是1。
&emsp;③ 步骤3 返回临时变量区的值，该值为0。
&emsp;④ 步骤4 返回值赋值给count，此时count的值被重置为0。
```Java
// “count = count++”这条语句可以按照如下代码来理解
public static int mokeAdd(int count) {
    int count = 0;
    // 先保存初始值
    int temp = count;
    // 做自增操作
    count = count + 1;
    // 返回原始值
    return temp;
}
```
(4) 解决方法就是把count = count++改成count++即可。
(5) 该问题在不同的语言环境有不同的实现：C++中“count = count++”与“count++”等效，而PHP与Java保持相同。

## 建议8：不要让旧语法困扰你
以下是一段包含旧语法的“神奇代码”：
```Java
public class Client {
	public static void main(String[] args) {
		// 数据定义及初始化
		int fee = 200;
		// 其他业务处理
		saveDefault:save(fee);
	}

	static void saveDefault() {
		System.out.println("saveDefault run");
	}

	static void save(int fee) {
		System.out.println("save run");
	}
}
```
![建议08_1](https://i.loli.net/2017/10/11/59de2962c1b1b.png)
![建议08_2](https://i.loli.net/2017/10/11/59de296db6f5b.png)
如何解释“saveDefault:save(fee)”这一段代码？
(1) 这是goto语句中标号的写法。
(2) goto语句有着“double face”作用的关键字，它可以让程序从多层循环中跳出，不用一层一层退出。
(3) goto语句这点虽然很好，但同时带来了代码结构混乱的问题，不利于理解与调试。这样做还有很多隐患，比如标号前后对象构造或变量初始化，一旦跳过这个标号，程序将不可想象。
(4) 所以java中抛弃了goto语法，但还是保留了该关键字，只是不进行语义处理，与此类似的还有const关键字。
(5) Java中扩展了break'和continue关键字，他们的后面都可以加上标号做跳转，完全实现了goto的功能（同时也把缺点实现了）。
(6) 但优秀的代码中不应该有break和continue后跟标号的情况，甚至需要减少break和continue的使用，这样是提高代码可读性。
(7) 让旧语法随风而去~

## 建议9：少用静态导入
从Java 5开始引入了静态导入方法（import static），其目的是为了减少字符输入量，提高代码的可读性，以便更好的理解程序。
先来看一个不使用静态导入，即一般导入的例子：
```Java
package suggest.nine;

public class MathUtils {
	// 计算圆面积
	public static double calCircleArea(double r) {
		return Math.PI * r *r ;
	}

	// 计算球面积
	public static double calBallArea(double r) {
		return 4 * Math.PI * r * r;
	}
}
```
在该代码中，两个计算方法都引入了java.lang.Math类（默认导入的）中的PI常量，但这样写有点不好，特别是如果MathUtils的方法较多时，每次都写Math就有点繁琐。
使用静态导入可以解决上面的问题：
```Java
package suggest.nine;

import static java.lang.Math.PI;

public class MathUtils {
	// 计算圆面积
	public static double calCircleArea(double r) {
		return PI * r *r ;
	}

	// 计算球面积
	public static double calBallArea(double r) {
		return 4 * PI * r * r;
	}
}
```
静态导入的作用就是把Math类中的PI常量引入到本类中，这会使程序更简单，跟容易阅读，只要看到PI就知道这是圆周率，不用每次都把类名写全。
但是滥用静态导入绝对会是一个噩梦，缺少了类名的修饰，静态属性和静态方法的表象意义会被无限放大，会让阅读者很难弄清楚器属性或方法代表何意，下面就是一段反例：
```Java
package suggest.nine;

import java.text.NumberFormat;
import static java.lang.Double.*;
import static java.lang.Math.*;
import static java.text.NumberFormat.*;
import static java.lang.Integer.*;

public class Client {
	// 输入半径和精度要求，计算面积
	public static void main(String[] args) {
		double s = PI * parseDouble(args[0]);
		NumberFormat nf = getInstance();
		nf.setMaximumFractionDigits(parseInt(args[1]));
		formatMessage(nf.format(s));
	}

	// 格式化消息输出
	private static void formatMessage(String s) {
		System.out.println("圆面积是：" + s);
	}
}
```
从这段程序中可以看出滥用静态导入的问题：
(1) parseDouble()方法能比较容易的知道是Double类的一个转换方法，PI也能看出来，但这都带有一点猜测性，不能直接看出。
(2) 紧接着的getInstance()方法则比较难看出，分不清是本地方法还是是NumberFormat类的方法。这样的代码阅读性非常差。
(3) 所以静态导入一定要遵循两个原则：
    ① 不使用*（星号）通配符，除非是导入静态常量类（只包含常量的类或接口）。
    ② 方法名是具有明确、清晰表象意义的工具类。下面是例子。
从程序中很容易判断出assertEquals方法是用来断言两个值是否相等，assertFalse方法则是断言表达式为假，如此确实减少了代码量，可读性也提高了。
```Java
package suggest.nine;

import org.junit.Test;
import static org.junit.Assert.*;

public class DaoTest {
	@Test
	public void testInsert() {
		// 断言
		assertEquals("foo", "foo");
		assertFalse(Boolean.FALSE);
	}
}
```

## 建议10：不要在本类中覆盖静态导入的变量和方法
如果一个类中的方法及属性与静态导入的方法与属性重名会出现什么问题呢？
先来看一下正常情况下的静态导入：
```Java
import static java.lang.Math.PI;
import static java.lang.Math.abs;

public class Client {
	public static void main(String[] args) {
		System.out.println("PI=" + PI);
		System.out.println("abs(-100)=" + abs(-100));
	}
}
```
![建议10_1](https://i.loli.net/2017/10/11/59de2a568117a.png)
输出没有问题，打印的是静态变量PI的值以及通过abs方法计算出-100的绝对值。
如果在Client类中也定义了PI常量和abs方法，会出现什么问题？
```Java
import static java.lang.Math.PI;
import static java.lang.Math.abs;

public class Client {
	// 常量名与静态导入的PI相同
	public final static String PI = "我不是真正的PI";

	// 方法名与静态导入的相同
	public static int abs(int abs) {
		return 0;
	}

	public static void main(String[] args) {
		System.out.println("PI=" + PI);
		System.out.println("abs(-100)=" + abs(-100));
	}
}
```
![建议10_2](https://i.loli.net/2017/10/11/59de2a7dd14e6.png)
问题及解决：
(1) 很明显本地的属性和方法被引用了，不是Math类中的属性和方法。
(2) 编译器有一个最短路径原则：如果能够在本类中找到的变量、常量、方法，就不会到其他包或父类、接口中查找，以确保本类中的属性、方法优先。
(3) 因此，如果要变更一个被静态导入的方法，最好是在原始类中重构，而不是在本类中覆盖。

## 建议11：养成良好习惯，显示声明UID
当我们编写一个实现了Serializable接口的类，Eclipse马上就会给一个警告：需要增加一个Serial Version ID。那么，为什么要增加呢？它是怎么计算出来的？又有什么用呢？
![建议11_1](https://i.loli.net/2017/10/11/59de2aa3f386f.png)
类实现Serializable接口的目的是为了持久化，比如网络传输或本地传输，为系统的分布和异构部署提供先决支持条件。若没有序列化，远程调用、对象数据库等都不可能存在。
下面是一个简单的序列化类：
```Java
import java.io.Serializable;

public class Person implements Serializable{

	private String name;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
}
```
Person类是一个实现了Serializable接口的简单JavaBean，可以在网络上传输，也可以本地存储然后读取。这里以Java消息服务（Java Message Service）方式传递该对象（即通过网络传递对象），定义在消息队列中的数据类型为ObjectMessage，首先定义一个消息的生产者（Producer），代码如下：
```Java
public class Producer {
	public static void main(String[] args) {
		Person person = new Person();
		person.setName("我是路人甲");
		// 序列化，保存到磁盘上
		SerializationUtils.writeObject(person);
	}
}
```
这里引入了一个工具类SerializationUtils，其作用是对一个类进行序列化和反序列化，并存储到硬盘上（模拟网络传输），其代码如下：
```Java
public class SerializationUtils {
	private static String FILE_NAME = "D:/obj.bin";
	// 序列化
	public static void writeObject(Serializable s) {
		try {
			ObjectOutputStream oos = new ObjectOutputStream(
					new FileOutputStream(FILE_NAME));
			oos.writeObject(s);
			oos.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 反序列化
	public static Object readObject() {
		Object obj = null;
		try {
			ObjectInput input = new ObjectInputStream(
					new FileInputStream(FILE_NAME));
			obj = input.readObject();
			input.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return obj;
	}
}
```
通过对象序列化过程，把一个对象从内存转化为可传输的数据流，然后通过网络发送到消息消费者（Consumer）那里，并进行反序列化，生成实例对象，代码如下：
```Java
public class Consumer {
	public static void main(String[] args) {
		// 反序列化
		Person person = (Person) SerializationUtils.readObject();
		System.out.println("name=" + person.getName());
	}
}
```
这是一个反序列化过程，也就是将对象数据流转化为一个对象的过程，其运行后的结果为：name=我是路人甲。
![建议11_2](https://i.loli.net/2017/10/11/59de2b08b5d27.png)
问题及解决：
(1) 如果消息的生产者和消息的消费者所参考的消息类（Person）有差异，比如消息生产者中的Person类增加了一个年龄属性，而消费者没有增加该属性。
(2) 没有增加的原因譬如分布式部署的应用，你甚至不知道应用部署在何处，特别是通过广播（broadcast）方式发送消息的情况，漏掉一两个订阅者很正常。
(3) 在这种序列化和反序列化不一致的情形下，反序列化会报一个InvalidClassException（无效类）异常，原因是序列化和反序列化对应的类版本发生了变化，JVM不能把数据流转化为实例对象。
![建议11_3](https://ooo.0o0.ooo/2017/10/11/59de2b2b9774a.png)
(4) 从这里我们知道JVM是根据SerialVersionUID，也叫做流标识符（Stream Unique Identifier）来判断一个类版本的。JVM在反序列化时，会比较数据流中的serialVersionUID和类的SerialVersionUID是否相同，如果相同，则认为类没有改变，可以把数据流load为实例对象；如果不同，抛出InvalidClassException。这样做可以很好的校验，保证一个对象即使在网络或磁盘中“滚过”一次依然“出淤泥而不染”，保证类的一致性。
(5) SerialVersionUID可以显式声明，也可以隐式声明：
&emsp;① 显式声明格式为： private static final long serialVersionUID = XXXXXL;
&emsp;② 而隐式声明为编译器在编译的时候根据包名、类名、继承关系、非私有方法及属性，以及参数、返回值等诸多因子计算得出的，极度复杂，基本上值唯一。
(6)  通过显示声明serialVersionUID，即使生产者和消费者对应的类版本不同，反序列化也可以运行，所带来的问题就是消费端不能读取到新增的业务属性（age）而已。
```Java
public class Person implements Serializable {
	// 显示声明serialVersionUID
	private static final long serialVersionUID = 1234L;
	// private int age; // Consumer中的Person类对象没有该属性
	private String name;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
}
```
(7) 通过此例，我们的反序列化实现了版本兼容的功能，提高了代码的健壮性。故而在编写序列化类时，注意添加上serialVersionUID字段。

注意：显示声明serialVersionUID可以避免对象不一致，但尽量不要以这种方式向JVM“撒谎”。

## 建议12：避免用序列化类在构造函数中为不变量赋值
我们知道带有final标识的属性时不变量，也就是说只能赋值一次，不能重复赋值，但是在序列化类中就有点复杂，比如下面这个类：
```Java
public class Person implements Serializable{

	private static final long serialVersionUID = 123454531L;
	// 不变量
//	public final String name = "混世魔王";
	public final String name = "齐天大圣"; // 序列化后再更改
}
```
![建议12_1](https://i.loli.net/2017/10/11/59de2bc021771.png)
这个Person（此时版本为1.0）类被序列化，然后存储到磁盘上，在反序列化时name属性会重新计算其值（这与static变量不同，static变量不会保存到数据流中），比如name属性修改为“齐天大圣”（版本2.0），那么反序列化对象的name值就是“齐天大圣”。保持新旧对象的final变量相同，有利于代码业务逻辑统一，这是反序列化的基本规则之一。也就是说，如果final属性是一个直接量，在反序列化时会重新计算。
下面是final变量的另一种赋值方式，通过构造函数赋值：
```Java
public class Person implements Serializable{

	private static final long serialVersionUID = 123454531L;
	// 不变量初始不赋值
	public final String name;
	// 构造函数为不变量赋值
	public Person() {
		name = "混世魔王";
	}
}
```
这是常用的一种赋值方式，可以把这个Person定义为版本1.0，然后进行序列化：
```Java
public class Serialize {
	public static void main(String[] args) {
		// 序列化以持久保存
		SerializationUtils.writeObject(new Person());
	}
}
```
Person的实例对象保存到了磁盘上，它是一个贫血对象（承载业务属性，但不包含其行为定义），之后做一个简单的模拟，修改name的值，注意保持serialVersionUID不变：
```Java
public class Person implements Serializable{

	private static final long serialVersionUID = 123454531L;
	// 不变量初始不赋值
	public final String name;
	// 构造函数为不变量赋值
	public Person() {
		name = "齐天大圣"; // 修改name的值
	}
}
```
此时Person类的版本是2.0，因为serialVersionUID没变，依然可以反序列化：
```Java
public class Deserialize {
	public static void main(String[] args) {
		// 反序列化
		Person person = (Person) SerializationUtils.readObject();
		System.out.println(person.name);
	}
}
```
![建议12_2](https://i.loli.net/2017/10/11/59de2c4232fcf.png)
final类型变量不是会重新计算吗，那为什么答案依然是“混世魔王”？
(1) 这里触及到反序列化的另一个规则：反序列化时构造函数不会执行。
(2) 反序列化执行的过程是这样的：
    ① JVM从数据流中获取一个Object对象
    ② 然后根据数据流中的类描述信息（序列化时，保存到磁盘的对象文件中包含乐描述信息，注意不是类）查看，发现是final变量，需要重新计算。
    ③ 于是引用Person类中的name值。
    ④ 而此时JVM又发现name竟然没有赋值，不能引用，于是JVM就不再进行初始化，保持原值状态，结果就依然是“混世魔王”了。

注意：在序列化类中，不使用构造函数为final变量赋值。

## 建议13：避免为final变量复杂赋值
为final变量赋值还有一种方式，通过方法赋值，即直接在声明时通过方法返回赋值：
```Java
public class Person implements Serializable{

	private static final long serialVersionUID = 123454531L;
	// 通过方法返回值为final变量赋值
	public final String name = initName();
	// 初始化方法名
	public String initName() {
		return "混世魔王";
	}
}
```
name属性是通过initName方法的返回值赋值的，在复杂类中经常用到，比使用构造函数更简洁、易修改。那么如此用法在序列化时会不会出现什么问题呢？Person类写好了（此时为版本1.0），先把它序列化，存储到本地文件中。
现在Person类的代码需要修改，initName的返回值也改变了：
```Java
public class Person implements Serializable{

	private static final long serialVersionUID = 123454531L;
	// 通过方法返回值为final变量赋值
	public final String name = initName();
	// 初始化方法名
	public String initName() {
		return "齐天大圣";
	}
}
```
上段代码仅仅修改了initName的返回值（Person的类版本为2.0），也就是通过new生成的Person对象的final变量值应该为“齐天大圣”。那么把之前存储到硬盘上的实例加载上来，name会是什么呢？
![建议13_1](https://ooo.0o0.ooo/2017/10/11/59de2cfe88238.png)
结果是“混世魔王”。上一建议说过final变量会被重新赋值，但是这个例子有没有重新赋值，为什么？
(1) 上个建议所说final会被重新赋值，其中的值指的是简单对象。
(2) 简单对象包括：8个基本数据类型（boolean、char、byte、short、int、long、float、double），以及数组、字符串（字符串情况很复杂，不通过new关键字生成String对象的情况下，final变量的赋值与基本类型相同），但是不能方法赋值。
(3) 其中的原理是这样的，保存到磁盘上（或网络传输）的对象文件包括两部分：
&emsp;① 类描述信息
&emsp;包括路径信息、继承关系、访问权限、变量描述、变量访问权限、方法签名、返回值，以及变量的关联类信息。需要注意的是它并不是class文件的翻版，它不记录方法、构造函数、static变量等的具体实现。之所以类描述会被保存，是为了保证反序列化的健壮运行。
&emsp;② 非瞬态（非transient关键字修饰）和非静态（非static关键字修饰）的实例变量值
&emsp;注意，这里的值如果是一个基本类型，直接是一个简单值保存下来；如果是复杂对象，则需要将该对象与关联类的信息一起保存下来，并且持续递归下去（关联类也必须实现Serializable接口，否者会出现序列化异常），也就是递归到最后还是基本数据类型的保存。正因为这样，一个持久化后的对象文件会比一个class类文件大很多。
(4) 总结下来，反序列化时final变量在一下情况不会被重新赋值：
&emsp;① 通过构造函数为final变量赋值。
&emsp;② 通过方法返回值为final变量赋值。
&emsp;③ final修饰的属性不是基本类型。
