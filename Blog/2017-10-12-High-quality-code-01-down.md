---
title: 《编写高质量代码》读书笔记
subtitle: 第01章 Java开发中通用的方法和准则（下）
author: Angus Liu
cdn: header-off
date: 2017-10-12 09:52:38
header-img: https://i.loli.net/2017/10/12/59decc7139201.jpg
tags:
      - 《编写高质量代码》
      - 读书笔记
      - Java
---
> 我认为，每个人都有一个觉醒期，但觉醒的早晚决定个人的命运。
> <p align="right"> —— 路遥《平凡的世界》 </p>

## 建议14：使用序列化类的私有方法巧妙解决部分属性持久化问题
把不需要持久化的属性加上瞬态关键字（transient）即可实现部分属性持久化，但这方案有时候行不通。例如一个计税系统和人力资源系统（HR系统）通过RMI（Remote Method Invocation，远程方法调用）对接，计税系统需要从HR系统获得人员的姓名和基本工资，以作为纳税的依据，而HR系统的工资分为两部分：基本工资和绩效工资。很明显这是两个互相关联的类，先来看看薪水类Salary类：
```Java
public class Salary implements Serializable {
	private static final long serialVersionUID = 134324L;
	// 基本工资
	private int basePay;
	// 绩效工资
	private int bonus;

	public Salary(int _basePay, int _bonus) {
		basePay = _basePay;
		bonus = _bonus;
	}

	public int getBasePay() {
		return basePay;
	}
	public void setBasePay(int basePay) {
		this.basePay = basePay;
	}
	public int getBonus() {
		return bonus;
	}
	public void setBonus(int bonus) {
		this.bonus = bonus;
	}
}
```
Person类和Salary类是关联关系：
```Java
public class Person implements Serializable {
	private static final long serialVersionUID = 5344212L;
	// 姓名
	private String name;
	// 薪水
	private Salary salary;

	public Person(String _name, Salary _salary) {
		name = _name;
		salary = _salary;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Salary getSalary() {
		return salary;
	}

	public void setSalary(Salary salary) {
		this.salary = salary;
	}
}
```
这是两个实现了Serializable接口的简单JavaBean，都具备序列化条件。首先计税系统请求HR系统对某一个对象进行序列化，把人员工资信息传递到计税系统中：
```Java
public class Serialize {
	public static void main(String[] args) {
		// 基本工资1000元，绩效工资2500
		Salary salary = new Salary(1000, 2500);
		// 记录人员信息
		Person person = new Person("张三", salary);
		// HR系统持久化，并传递到计税系统
		SerializationUtils.writeObject(person);
	}
}
```
通过网络传送到计税系统后，进行反序列化：
```Java
public class Desevialize {
	public static void main(String[] args) {
		// 技术系统反序列化，并打印信息
		Person person = (Person) SerializationUtils.readObject();
		StringBuffer sb = new StringBuffer();
		sb.append("姓名：" + person.getName());
		sb.append("\t基本工资：" + person.getSalary().getBasePay());
		sb.append("\t绩效工资：" + person.getSalary().getBonus());
		System.out.println(sb);
	}
}
```
![建议14_1](https://i.loli.net/2017/10/11/59de2dad9e954.png)
打印出的结果很简单，但是这不符合要求，因为计税系统只能从HR系统中获取人员名字和基本工资，而绩效工资是不能获得的，这是个保密数据，不允许发生泄漏。

怎么解决这个问题呢？下面有一些方案：
(1) 在bonus前加transient关键字
&emsp;这是一个方法，但不是一个好方法，加上transient关键字就意味着Salary类失去了分布式部署的功能，它可是HR系统最核心的类，一旦遭遇性能瓶颈，想再实现分布式部署就不可能了。
(2) 新增业务对象
&emsp;增加一个Person4Tax类，完全为计税系统服务，它只有两个属性：姓名和基本工资。符合开闭原则，而且对原系统没有侵入性，只是增加了工作量。这是个方法，但不是最佳方法。
(3) 请求端过滤
&emsp;在计税系统中获得Person对象后，过滤掉Salary的bonus属性，方案可行但是不合规矩，因为HR系统的Salary类的安全新竟然让外系统（计税系统）来承担，设计严重失职。
(4) 变更传输契约
&emsp;例如使用XML传输，或者重建一个Web Service服务，可以做，但是成本太高。

那么优秀的方案是什么呢？下面是改进后的Person类，其中，实现了Serializable接口的类可以实现两个私有方法：writeObject和readObject，以影响和控制序列化和反序列化的过程。
```Java
public class Person implements Serializable {
	private static final long serialVersionUID = 5344212L;
	// 姓名
	private String name;
	// 薪水
	private Salary salary;

	public Person(String _name, Salary _salary) {
		name = _name;
		salary = _salary;
	}

	// 序列化委托方法
	private void writeObject(ObjectOutputStream out) throws IOException {
		out.defaultWriteObject();
		out.writeInt(salary.getBasePay());
	}

	// 反序列化时委托的方法
	private void readObject(ObjectInputStream in) throws IOException, ClassNotFoundException{
		in.defaultReadObject();
		salary = new Salary(in.readInt(), 0);
	}
    ...
}
```
![建议14_2](https://i.loli.net/2017/10/11/59de2df09ca35.png)
我们在Person类中增加了writeObject和readObject两个方法，并且访问对象都是私有级别的，为什么会改变程序的运行结果呢？
(1) 这里运用了序列化独有的机制：序列化回调。
(2) Java调用ObjectOutputStream类把一个对象转换成数据流时，会通过反射（Reflection）来检查被序列化类是否有writeObject方法，并且检查其是否符合私有、无返回值的特性。
(3) 若有，则会委托该方法进行对象序列化。
(4) 若没有，则由ObjectOutputStream按照默认规则继续序列化。
(5) 同样，在从数据流恢复成实例对象时，也会检查是否有一个readObject方法。
(6) 如果有，则会通过该方法读取属性值。
(7) 此处有几个关键点要说明：
&emsp;① out.defaultWriteObject()
&emsp;告知JVM按照默认的规则写入对象，惯例的写法是写在第一句话里。
&emsp;② in.defaultReadObject()
&emsp;告知JVM按照默认规则写入对象，惯例的写法也是写在第一句话里。
&emsp;③ out.writeXxx()和in.readXxx()
&emsp;分别是写入和读出相应的值，类似一个队列，先进先出，如果此处有复杂的数据逻辑，建议按封装Collection对象处理。
(8) 如此一来，Person类失去了分布式部署的能力，但是HR的重点在于薪水计算，所依赖的公式很复杂。相比起来Person类计算可能性不大，所以即使为了性能考虑，Person类为分布式部署的意义也不大。

## 建议15：break万万不可忘
记住在case语句后面随手写上break，养成良好的习惯，防止在单元测试时，由于分支条件覆盖不到的时候，在生产中可能会出现一些严重事故。对于此类问题，还有一个最简单的解决方法：修改IDE的警告级别，例如在Eclipse中，可以依次点击Window → Preferences → Java → Compiler → Errors/Warnings → Potential Programming problems，然后修改‘switch’ case fall-through为Errors级别,这样如果不在case语句中加入break，Eclipse会直接报错。
![建议15_1](https://i.loli.net/2017/10/11/59de2e36354c7.png)

## 建议16：易变业务使用脚本语言编写
Java一直遭受异种语言的入侵，比如PHP、Ruby、Groovy、JavaScript等，这些入侵者都是脚本语言，它们都是在运行期间解释执行的。
为什么Java这种强编译型语言会需要这些脚本语言呢？那是因为脚本语言的三大特征：
(1) 灵活。脚本语言一般都是动态类型，可以不用声明变量类型而直接使用，也可以在运行期改变类型。
(2) 便捷。脚本语言是一种解释型语言，不需要编译成二进制代码，也不需要像Java一样生成字节码。它的执行是依靠解释器解释的，因此在运行期间变更代码很容易，而且不用停止应用。
(3) 简单。只能说部分脚本语言简单，比如Grovxy，Java程序员两小时即可上手。
脚本语言的这些特性是Java所缺少的，引入脚本语言可以使Java更强大。为此，JCP(Java Community Process)提出了JSR223规范，只要符合该规范的语言都可以在Java平台运行（对JavaScript是默认支持的）。

下面是一个案例，展现一下脚本语言是如何实现“拥抱变化”的。
```JavaScript
function formula(var1, var2) {
	return var1 + var2 *factor;
}
```
这是一个简单的JS脚本语言函数，factor因子是从上下文来的，类似于一个运行的环境变量。该JavaScript保存在D:\model.js中。下一步Java需要调用JavaScript中的函数：
```Java
public class Client {
	public static void main(String[] args) throws Exception{
		// 获得一个JavaScript的执行引擎
		ScriptEngine engine = new ScriptEngineManager().getEngineByName("javascript");
		// 建立上下文变量
		Bindings bind = engine.createBindings();
		bind.put("factor", 1);
		// 绑定上下文，作用于是当前引擎范围
		engine.setBindings(bind, ScriptContext.ENGINE_SCOPE);
		Scanner input = new Scanner(System.in);
		while(input.hasNextInt()) {
			int first = input.nextInt();
			int sec = input.nextInt();
			System.out.println("输入参数是：" + first + "," + sec);
			// 执行js代码
			engine.eval(new FileReader("d:/model.js"));
			// 是否可调用方法
			if(engine instanceof Invocable) {
				Invocable in = (Invocable)engine;
				// 执行js中的函数
				Double result = (Double)in.invokeFunction("formula", first, sec);
				System.out.println("运算结果：" + result.intValue());
			}
		}
	}
}
```
上段代码使用Scanner类接收键盘输入的两个数字，然后调用JavaScript脚本的formula函数计算结果，注意，除非输入一个非int数字，否者JVM会一直运行，这是模拟生产线在线变更状况。运行结果如下：
![建议16_1](https://i.loli.net/2017/10/11/59de2e9884e8d.png)
此时，保持JVM运行状态，修改一下formula函数：
```JavaScript
function formula(var1, var2) {
	return var1 + var2 - factor; // 将乘号变成减号
}
```
回到JVM继续输入，运行结果为：
![建议16_2](https://i.loli.net/2017/10/11/59de2ebecbabc.png)
修改JS代码，JVM没有重启，输入参数也没有任何的改变，仅仅改变脚本函数即可产生不同的结果。
这就是脚本语言对系统设计最有利的地方：
(1) 可以随时发布不用重新部署。
(2) 即使进行变更，也能提供不间断的业务服务。

## 建议17：慎用动态编译
从Java6开始，Java开始支持动态编译，可以在运行期间直接编译.java文件，执行.class，并且能够获得相关的输入输出，甚至还能监听相关的事件。不过，我们最期望的还是给定一段代码，直接编译运行，也就是空中编译执行（on-the-fly），来看如下代码：
```Java
public class Client {
	public static void main(String[] args) throws Exception{
		// Javay源代码
		String sourceStr = "public class Hello {" +
				      "public String sayHello (String name) {" +
					  "return \"Hello,\" + name + \"!\"; "
				   + "}"
				 + "}";
		// 类名及文件名
		String className = "Hello";
		// 方法名
		String methodName = "sayHello";
		// 改变JAVA_HOME环境变量，以防不能获取当前编译器（Eclipse默认指向jre问题）
		// 具体问题参考下方的网址（注意将jdk中的tools.jar复制到jdk中的jre）
        // 还有方法是配置Eclipse，指向jdk，懒得配置，这里临时更改JAVA_HOME吧
		System.setProperty("java.home", "C:\\Program Files\\Java\\jdk1.8.0_131\\jre");
		// 当前编译器
		JavaCompiler cmp = ToolProvider.getSystemJavaCompiler();
		// Java标准文件管理器
		StandardJavaFileManager fm = cmp.getStandardFileManager(null, null, null);
		// Java文件对象
		JavaFileObject jfo = new StringJavaObject(className, sourceStr);
		// 编译参数。类似于javac <options> 中的options
		List<String> optionList = new ArrayList<>();
		// 编译文件的存放地方，注意：此处是为Eclipse工具特设的
		optionList.addAll(Arrays.asList("-d", "./bin"));
		// 要编译的单元
		List<JavaFileObject> jfos = Arrays.asList(jfo);
		// 设置编译环境
		JavaCompiler.CompilationTask task = cmp.getTask(null, fm, null, optionList, null, jfos);
		// 编译成功
		if (task.call()) {
			// 生成对象
			Object obj = Class.forName(className).newInstance();
			Class<? extends Object> cls = obj.getClass();
			// 调用sayHello方法
			Method m = cls.getMethod(methodName, String.class);
			String str = (String) m.invoke(obj, "Dynamic Compliation");
			System.out.println(str);
		}
	}
}

/**
 * 文本中的Java对象
 */
class StringJavaObject extends SimpleJavaFileObject {
	// 源代码
	private String content = "";

	// 遵循Java规范的类名及文件
	protected StringJavaObject(String _javaFileName, String _content) {
		super(_createStringJavaObjectUri(_javaFileName), Kind.SOURCE);
		content = _content;
	}

	// 产生一个URL资源路径
	private static URI _createStringJavaObjectUri(String name) {
		// 注意此处没有设置包名
		return URI.create("String:///seventeen///" + name + Kind.SOURCE.extension);
	}

	// 文本文件代码
	@Override
	public CharSequence getCharContent(boolean ignoreEncodingErrors) throws IOException {
		// TODO Auto-generated method stub
		return content;
	}
}
```
上诉代码如果没有正确配置，会报空指针异常，参考
[java - Nullpointerexception error when using JavaCompiler - Stack Overflow](https://stackoverflow.com/questions/18127806/nullpointerexception-error-when-using-javacompiler)
![建议17_1](https://i.loli.net/2017/10/11/59de2f46cbe96.png)
上面的代码较多，这是一个动态编译的模板程序，可以拷贝到项目中使用。从上可以看出只要是本地静态编译能够实现的任务，比如编译参数、输入输出、错误监控等，动态编译都能实现。
Java的动态编译对源提供了多个渠道，比如：
(1) 可以是字符串（如例子）
(2) 可以是文本文件
(3) 也可以是编译过的字节码文件（.class文件）
(4) 甚至可以是存放在数据库中的明文代码或是字节码
汇总成一句话，只要是符合Java规范的就可以在运行期动态加载，其实现方式就是实现JavaFileObject接口，重写getCharContent、openInputStream、openOutputStream，或者实现JDK已经提供的两个SimpleJavaFileObject、ForwardingJavaFileObject。
动态编译虽然是很好的工具，让我们可以更加自如的控制编译过程，但是实际项目中很少用到，因为静态编译已经能处理大部分甚至全部的工作，即使需要动态编译，也有很好的替代方案，比如JRuby、Grovxy等无缝的脚本语言。

另外，我们在使用动态编译时，需要注意以下几点：
(1) 在框架汇中谨慎使用
&emsp;比如要在Struts中使用动态编译，动态实现一个类，她若继承ActionSupport就希望它成为一个Action。能做到，但是debug很困难；再比如在Spring中，写一个动态类，要让它动态注入到Spring容器中，需要花费很大的功夫。
(2) 不要在要求高性能的项目中使用
&emsp;动态编译毕竟需要一个编译过程，与静态编译相比多了一个执行环节，因此在高性能项目中不要使用动态编译。不过，如果实在工具类项目中它则可以很好的发挥器优越性，比如在Eclipse中写一个插件，就可以很好的使用动态编译，不用重启即可实现运行、调试功能，非常方便。
(3) 动态编译要考虑安全性问题
&emsp;如果在Web页面中提供了一个功能，允许上传一个Java文件然后运行，那就等于说：“我的机器没有密码，大家都来看我的隐私吧”，这是非常典型的注入漏洞，只要上传一个恶意Java程序就可以让所有的安全工作毁于一旦。
(4) 记录动态编译过程
&emsp;建议记录源文件、目标文件、编译过程、执行过程等日志，不仅仅是为了诊断，还是为了安全和审计，对Java项目来说，空中编译和运行是很不让人放心的，留下这些依据可以更好地优化程序。

## 建议18：避免instanceof非预期结果
instanceof是一个简单的二元操作符，它是一个用来判断一个对象是否是一个类的实例的，其操作类似于>=、==，非常简单，下面是一段程序：
```Java
public class Client {
	public static void main(String[] args) {
		// String对象是否是Object的实例
		boolean b1 = "String" instanceof Object;
		// String对象是否是String的实例
		boolean b2 = new String() instanceof String;
		// Object对象是否是String的实例
		boolean b3 = new Object() instanceof String;
		// 拆箱类型是否是装箱类型的实例
//		boolean b4 = 'A' instanceof Character;
		// 空对象是否是String的实例
		boolean b5 = null instanceof String;
		// 类型装换后的空对象是否是String的实例
		boolean b6 = (String)null instanceof String;
		// Date对象是否是String的实例
//		boolean b7 = new Date() instanceof String;
		// 在泛类型中判断String对象是否是Date的实例
		boolean b8 = new GenericClass<String>().isDateInstance("");

		System.out.println("b1=" + b1);
		System.out.println("b2=" + b2);
		System.out.println("b3=" + b3);
		System.out.println("b5=" + b5);
		System.out.println("b6=" + b6);
		System.out.println("b8=" + b8);
	}
}

class GenericClass<T> {
	// 判断是否是Date类型
	public boolean isDateInstance(T t) {
		return t instanceof Date;
	}
}
```
![建议18_1](https://i.loli.net/2017/10/11/59de2fc81787a.png)
![建议18_2](https://i.loli.net/2017/10/11/59de2fd0d2d4f.png)
这一段程序，instanceof所有的应用场景都出现了，同时问题也出现了：
(1) "String" instanceof Object
&emsp;返回值是true，这很正常，“String”是一个字符串，字符串又继承了Object，那当然是返回true了。
(2) new String() instanceof String
&emsp;返回值是true，没有任何问题，一个类的对象当然是它的实例了。
(3) new Object() instanceof String
&emsp;返回值是false，Object是父类，其对象当然不是String的实例了。需要注意的是，这句话其实完全可以编译通过，只要instanceof关键字左右两个操作数有继承关系或者实现关系，就可以编译通过。
(4) 'A' instanceof Character
&emsp;这句代码有一定的蒙蔽性，事实上它编译不过，为什么呢？因为‘A’是一个char类型，也就是基本类型，不是一个对象，instanceof只能用于对象的判断，不能用于基本类型的判断。
(5) null instanceof String
&emsp;返回值是false，这是instanceof特有的规则：若左操作数是null，结果就直接返回false，不再运算右操作数是什么类。这对我们的程序非常有利，在使用instanceof操作符时，不用关心被判断的类对象（左操作数）是否为null，这与我们常用的equals、toString方法不同。
(6) (String)null instanceof String
&emsp;返回值为false，不要看这里有个强制类型转换就认为结果是true，不是的，null是一个万用类型，也可以说它没有类型，即使做类型转换还是个null。
(7) new Date() instanceof String
&emsp;编译不能通过，因为Date类和String类没有继承或者实现关系，所以在编译时会直接报错，instanceof操作符的左右操作数必须有继承关系或者实现关系，否者编译会失败。
(8) new GenericClass<String>.isDataInstance("")
&emsp;能编译通过，返回值为false。T是个String类型，与Date之间没有继承或实现关系，为什么“t instanceof Date”会编译通过呢？那时因为Java的泛型是为编码服务的，在编译成字节码的时候，T已经是Object类型了，传递的实参是String类型，也就是说T的表面是Object，实际是String类型，那“t instanceof Date”这句话就等价于“Object instanceof Date”，所以会返回false。

## 建议19：断言绝对不是鸡肋
1.在防御式编程中经常会使用断言（Assertion）对参数和环境做出判断，避免程序因不当输入或错误的环境而产生逻辑异常。在Java中断言使用的是assert关键字，其基本用法如下：
```Java
assert <布尔表达式>
assert <布尔表达式> : <错误信息>
```
在布尔表达式为假时，抛出AssertionError错误，并附带了错误信息。assert的语法交简单，有以下两个特性：
(1) assert默认是不启用的
&emsp;我们知道断言是为调试程序服务的，目的是为了能够快速、方便地检查到程序异常，但Java在默认条件下时不启用的，要启用需要在编译、运行时加上相关的关键字（请参考Java规范或参考[在Eclipse中如何开启断言](http://blog.csdn.net/limm33/article/details/55511413)）
(2) assert抛出的异常AssertionError继承自Error
&emsp;断言失败后，JVM会抛出一个AssertionError错误，它继承自Error。注意，这是一个错误，是不可恢复的，也就表示这是一个严重问题，开发者必须予以关注并解决。

2.assert虽然是做断言的，但不能将其等价为if...else...这样的条件判断，它在以下两种情况不可使用：
(1) 对外公开的方法中
&emsp;我们知道防御式编程最核心的一点就是：所有的外部因素（输入参数、环境变量、上下文）都是“邪恶的”，都存在企图摧毁程序的罪恶本源，为了抵制它们，我们要在程序中处处校验，满地设卡，不满足条件就不再执行后续程序，以保护主程序的正确性，处处设卡没问题，但就是不能用断言做输入校验，特别是公开方法，下面就是一个例子：
```Java
public class Client {
	public static void main(String[] args) {
		StringUtils.encode(null);
	}

}

// 字符串处理工具类
class StringUtils {
	public static String encode(String str) {
		assert str != null : "加密的字符串为null";
		/* 加密处理 */
		return str; // 当成已经加密了
	}
}
```
![建议19_1](https://i.loli.net/2017/10/11/59de30b9238dd.png)
encode方法对输入参数做了不为空的假设，如果为空，则抛出AssertionError，但是encode是一个public方法，这标志它是对外公开的，任何一个类只要能够传递一个String类型的参数（遵守契约）就可以调用，但是Client类按照规范和契约调用encod方法，去获得了一个AssertionError错误信息，是谁破坏了契约约定？是encode方法自己！
(2) 在执行逻辑代码的情况下
&emsp;assert的支持是可选的，在开发时可以让它自己运行，但在生产系统中则不需要其运行了（以便提高性能），因此在assert的布尔表达式中不能执行逻辑代码，否则会因为环境不同而产生不同的逻辑，例如：
```Java
public void doSomething(List list, Object element) {
    assert list.remove(element):"删除元素" + element + "失败";
    /*业务处理*/
}
```
这段代码在assert启用的情况下，没有任何问题，但是一旦投入到生产环境中，就不会启用断言了，而这个方法就彻底完蛋了，list的删除动作永远都不会执行，所以也就永远不会报错或异常。

3.以上两种情况不能使用assert，那在什么情况下能够使用asset呢？一句话：按照正常执行逻辑不可能到达的代码区域可以放置assert。具体分三种情况：
(1) 在私有方法中放置assert作为输入参数的校验
&emsp;在私有方法中可以放置assert校验输入参数，因为私有方法的使用者是作者自己，私有方法的调用者与被调用者之间是一种弱契约或无契约关系，其间的约束是依靠作者自己控制的，因此加上assert可以更好的预防自己犯错，或者无意的程序犯错。
(2) 流程控制中不可能达到的区域
&emsp;这类似于JUnit的fail方法，其标志意义是：程序执行到这里就是错误的，例如：
```Java
public void doSomething() {
    int i = 7;
    while(i > 7) {
        /*业务处理*/
    }
    assert false:"到达这里就表示错误";
}
```
(3) 建立程序探针
&emsp;我们可能会在一段程序中定义两个变量，分别表示两个不同的业务含义，但是两者有固定的关系，例如var1 = var2 * 2，那我们就可以在程序中到处设“桩”，断言这两者的关系，如果不满足即表明程序已经出现了异常，业务也就没有必要运行下去了。

## 建议20：不要只替换一个类
我们在系统中定义一个常量接口（或常量类），以囊括系统中所涉及的常量，从而简化代码，方便开发，在很多开源项目中已采用了类似的方法，比如Struts2中，org.apache.struts2.StrutsConstants就是一个常量类，它定义了Struts框架中与配置有关的常量接口，而org.apache.struts2.StrutsStatic则是一个常量接口，其中定义了OGNL访问的关键字。
关于常量接口（类）我们来看一个例子，首先定义一个常量类：
```Java
public class Constant {
	// 定义人类寿命极限
	public final static int MAX_AGE = 150;
}
```
这是一个非常简单的常量类，定义了人类的最大年龄，我们在代码中引用这个常量：
```Java
public class Client {
	public static void main(String[] args) {
		System.out.println("人类寿命的极限是：" + Constant.MAX_AGE);
	}
}
```
运行结果非常简单。 目前的代码编写都是在“智能型”IDE工具中完成的，下面我们暂时回到原始时代（记事本编写时代），然后看看会发生什么奇妙事情。
修改Constant类中的常量，人类的寿命增加了，最大能活到180岁，代码如下：
```Java
public class Constant {
	// 定义人类寿命极限
	public final static int MAX_AGE = 180;
}
```
然后重新编译：javac Constant.java，编译完成后执行：java Client。
![建议20_1](https://i.loli.net/2017/10/11/59de314f96f5f.png)
太奇怪了，为什么输出的结果没有改变为180？原因是：
(1) 对于final修饰的基本类型和String类型，编译器会认为它是稳定态（Immutable Status），所以在编译时就直接把值编译到字节码中了，避免了在运行期引用（Runtime Reference），以提高代码的执行效率。
(2) 针对上个例子来说，Client类在编译时，字节码中就写上了“150”这个常量，而不是一个地址引用，因此无论后续怎么修改常量类，只要不重新编译Client类，输出还是照旧。
(3) 而对于final修饰的类（即非基本类型），编译器认为它是不稳定态（Mutable Status），在编译时建立的则是引用关系（该类型也叫Soft Final），如果Client类引入的常量是一个类或实例，即使不重新编译也会输出最新值。
(4) 千万不要小看这点知识点，细坑也能绊倒大象，比如在一个Web项目中，开发人员修改了一个final类型的值（基本类型），考虑到重新发布风险比较大，或是时间比较长，或者是审批流程过于繁琐，反正为了偷懒，于是直接采用替换class类文件的方式发布。替换完后应用服务器自动重启，然后简单测试一下（比如在本类中引用final类型的常量），一切OK。可运行几天后发现业务数据对不上，有的类（引用关系的类）使用了旧值，有的类（继承关系的类）使用的是新值，而且毫无头绪，让人一筹莫展，其实问题的根源就在于此。
(5) 为什么我们的例子不在IDE工具（例如Eclipse）中运行呢？那时因为IDE中不能重现该问题，若修改了Constant类，IDE工具会自动编译所有的应用类，“智能化”屏蔽了该问题，但潜在的风险依然存在。

注意：发布应用系统时禁止使用类文件替换方式，整体WAR包发布才是完全之策。
