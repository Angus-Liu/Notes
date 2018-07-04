---
title: 《编写高质量代码》读书笔记
subtitle: 第02章 基本类型
author: Angus Liu
cdn: header-off
date: 2017-10-13 22:11:33
header-img: https://i.loli.net/2017/10/13/59e0cd4f60a96.jpg
tags:
      - 《编写高质量代码》
      - 读书笔记
      - Java
---
> I guess it comes down to a simple choice:get busy living or get busy dying.
> 生命可以归结为一种简单的选择：要么忙于生存，要么赶着去死
> <p align="right"> —— 斯蒂芬·金《肖申克的救赎》 </p>

## 建议21：用偶判断，不用奇判断
关于判断奇偶数，我们来看一个例子：
```Java
public class Client {
	public static void main(String[] args) {
		// 接收键盘输入参数
		Scanner input = new Scanner(System.in);
		System.out.println("请输入多个数字判断奇偶：");
		while (input.hasNextInt()) {
			int i = input.nextInt();
			String str = i + "->" + (i % 2 == 1 ? "奇数" : "偶数");
			System.out.println(str);
		}
	}
}
```
![建议21_1](https://i.loli.net/2017/10/13/59e0cf1ec95de.png)
查看打印的结果，前三个正常，但是-1却被判断为偶数，这是怎么回事？我们先来了解一下Java中取余（% 标识符）算法，模拟代码如下：
```Java
public class Client {
	public static void main(String[] args) {
		// 接收键盘输入参数
		Scanner input = new Scanner(System.in);
		System.out.println("请输入多个数字判断奇偶：");
		while (input.hasNextInt()) {
			int i = input.nextInt();
			String str = i + "->" + (i % 2 == 1 ? "奇数" : "偶数");
			System.out.print(str);
			String str1 = i + "-->" + (remainder(i, 2) == 1 ? "奇数" : "偶数");
			System.out.println("\t" + str1);
		}
	}

	// 模拟取余运算，dividend被除数，divisor除数
	public static int remainder(int dividend, int divisor){
		// 就是被除数除以除数取整再乘以除数，看看是否与原来相等
		return dividend - dividend / divisor * divisor;
	}
}
```
![建议21_2](https://i.loli.net/2017/10/13/59e0cf517fecb.png)
看完上面的模拟代码，应该明白Java的取余是怎么计算的了，所以输入-1，运算结果为-1，当然不等于1了，所以就被误判为偶数，也就是我们的判断失误了。问题明白了，修正就很容易了，改为判断是否为偶数即可：
```Java
i % 2 == 0 ? "偶数":"奇数";
```
**注意：对于基础知识，我们“应该知其然，并知其所以然”。**

## 建议22：用整数类型处理货币
在日常生活中，最容易接触到的小数就是货币，我们来看下面关于货币找零的程序：
```Java
public class Client {
	public static void main(String[] args) {
		System.out.println(10.00 - 9.60);
	}
}
```
![建议22_1](https://i.loli.net/2017/10/13/59e0d08582f2f.png)
我们期望的找零结果是0.4，打印出来的数字却是0.40000000000000036，这是为什么呢？
(1) 这是因为计算机中的浮点数有可能（注意是可能）是不正确的，它只能无限接近准确值，而不能完全精确。
(2) 为什么会如此呢？这是由浮点数的存储机制决定的。
(3) 我们先来看看0.4这个十进制小数如何转换成二进制小数：
&emsp;① 使用“乘2取整，顺序排列”法。
&emsp;② 我们发现0.4不能使用二进制准确的表示，在二进制数世界里它是一个无限循环的小数，也就是说“展示”都不能“展示”，更别说内存中的存储了。
&emsp;③ 浮点数的存储包括三部分：符号位、指数位、尾数。
&emsp;④ 可以这样理解，在十进制的世界里没有办法准确表示1/3，那么在二进制的世界里也无法准确表示1/5（如果二进制也有分数倒是可以表示），在二进制的世界里1/5是一个无限循环小数。

那如果直接像下面这样直接取整可以吗：
```Java
public class Client {
	public static void main(String[] args) {
		NumberFormat f = new DecimalFormat("#.##");
		System.out.println(f.format(10.00 - 9.60));
	}
}
```
![建议22_2](https://i.loli.net/2017/10/13/59e0d0bd8102e.png)
问题看似是解决了，但是却隐藏了一个更深的问题。我们思考一下金融行业的计算方法，会计系统一般记录小数点后的4位小数，但是在汇总、展现、报表中，则记录小数点后的2位小数，如果使用浮点数来计算货币，在大批量的加减乘除后结果会出现非常大的误差（其中还要涉及到四舍五入问题）！会计系统要的就是准确，但是却因为计算机的缘故不准确了。
要解决此问题的方法有两种：
(1) 使用BigDecimal
&emsp;BigDecimal是专门为弥补浮点数无法精确计算的缺憾为设计的类，并且它本身也提供了加减乘除的常用数学算法。特别是与数据库Decimal类型的字段映射时，BigDecimal是最优的方案。
(2) 使用整型
&emsp;把参与运算的值扩大100倍，并转变为整型，然后在展现时再缩小100倍，这样处理的好处是计算简单、准确，一般在非金融行业（如零售行业）应用较多。此方法还会用于零售的pos机，它们的输入输出都是整数，那运算就更简单。

## 建议23：不要让类型默默转换
下面是一个小学生做的题目，根据光速计算月亮与地球、太阳与地球之间的距离：
```Java
public class Client {
	// 光速是30万公里/秒，定义为常量
	public static final int LIGHT_SPEED = 300_000_000;
	public static void main(String[] args) {
		System.out.println("题目1：月光照射到地球上需要1秒，计算月亮和地球的距离。");
		long dis1 = LIGHT_SPEED * 1;
		System.out.println("月亮与地球的距离为：" + dis1 + "米");
		System.out.println("--------------------------");
		System.out.println("题目2：太阳光照射到地球上需要8分钟，计算太阳到地球的距离。");
		// 可能要超出整数范围，使用long类型
		long dis2 = LIGHT_SPEED * 8 * 60;
		System.out.println("太阳到地球的距离为：" + dis2 + "米");
	}
}
```
![建议23_1](https://i.loli.net/2017/10/13/59e0d10ba10da.png)
dis2已经考虑到int类型可能越界的问题，并且使用了long类型，但是为什么太阳和地球的距离还是负的，怎么解决？
(1) 那是因为Java是先运算然后再进行类型转换的，具体地说就是因为dis2的三个运算都是int类型，三者相乘的结果虽然也是int结果，但是已经超出了int类型最大值，所以其值就是负值了（越过边界就会从头开始），再转换成long类型，结果还是负值。
(2) 问题知道了，解决起来很简单，只要加个"L"即可解决：
```Java
long dis2 = LIGHT_SPEED * 8L * 60;
```
60L是一个长整型，乘出来的结果也是一个长整型（这是Java的基本转换规则，像数据范围的方向转换，也就是加宽类型），在还没有超过int类型的范围时就已经转换为long类型了，彻底解决了越界问题。
(3) 实际开发中，更通用的做法是主动声明类型转化（注意不是强制类型转换），代码如下：
```Java
long dis2 = 1L * LIGHT_SPEED * 8 * 60;
```
既然期望的结果是long类型，那就让第一个参与运算的参数是long类型（1L）吧。
![建议23_2](https://i.loli.net/2017/10/13/59e0d1542f4ba.png)
**注意：基本类型转换时，使用主动声明方式减少不必要的Bug。**

## 建议24：边界，边界，还是边界
某商家生产的电子产品非常畅销，需要提前30天预订才能抢到手，同时它还规定了一个会员可拥有的最多产品数量，目的是防止囤积压货肆意加价。会员的预订过程是这样的：先登录官方网站，选择产品型号，然后设置需要预订的数量，提交，符合规则则提示下单成功，不符合规则则提示下单失败。后台的处理逻辑模拟如下：
```Java
public class Client {
	// 一个会员拥有产品的最多数量
	public final static int LIMIT = 2000;

	public static void main(String[] args) {
		// 会员当前拥有的产品量
		int cur = 1000;
		Scanner input = new Scanner(System.in);
		System.out.print("请输入需要预订的数量：");
		while (input.hasNextInt()) {
			int order = input.nextInt();
			// 当前拥有的与准备订购的产品数量之和
			if (order > 0 && order + cur <= LIMIT) {
				System.out.println("你已经成功预订" + order + "个产品！");
			} else {
				System.out.println("超过限额，预订失败！");
			}
		}
	}
}
```
这是一个简单的订单处理程序，如果当前预订量与拥有数量之和超过了最大数量，则预订失败，否则下单成功。业务逻辑很简单，同时在Web页面对订单数量做了严格的校验，比如不能是负值，不能超过最大数量等，但是人算不如天算，刚运行就出现了错误：某会员拥有的产品的数量与预定的数量之和远远大于限额：
![建议24_1](https://i.loli.net/2017/10/13/59e0d191abddf.png)
程序逻辑上没有问题，但是这个数字远远超出了限额，为什么会预定成功？
(1) 看着2147483647这个数字很眼熟，对，它就是int类型的最大值。
(2) 我们来看程序，order的值是2147483647，那再加上1000就超出了int类型的范围，其结果是-2147482649，那当然是小于正数2000了！
(3) 一句话归结原因：数字越界是校验失败。
(4) 在单元测试中，有一项测试叫做边界测试（也叫做临界测试），如果一个方法接收的是int类型的参数，拿以下三个字是必测的：0、正最大、负最小，其中正最大和负最小是边界值，如果这三个值都没有问题，方法才是比较安全可靠的。上述例子就是缺少边界测试，只是系统出现了严重错误。
(5) 也许你要疑惑了，Web页面既然已经做了严格的校验了，为什么还能输入2147483647这么大的数字呢？是否校验不严格？非也，Web校验都是在页面上通过JavaScript实现的，只能限制普通用户（不懂HTML、不懂HTTP、不懂Java的简单使用者），而对于高手，这些校验基本都是摆设，HTTP是明文传输的，将其拦截几次，分析一下数据结构，然后再写一个模拟器。一切前端校验都是浮云，随手就可以往后台提交数据！

## 建议25：不要让四舍五入亏了一方
下面还是来重温一个数学题：四舍五入。四舍五入是一种近似精确的计算方法，在Java 5之前，我们一般是通过Math.round来获得指定精度的整数或小数的，这种方法使用非常广泛：
```Java
public class Client {
	public static void main(String[] args) {
		System.out.println("10.5的近似值：" + Math.round(10.5));
		System.out.println("-10.5的近似值：" + Math.round(-10.5));
	}
}
```
![建议25_1](https://i.loli.net/2017/10/13/59e0d1c62f727.png)
这是四舍五入的经典问题，绝对值相同的两个数字，近似值的绝对值为什么就不同了呢？
(1) 这是由Math.round采用的舍入规则决定的（采用的是正无穷方向舍入规则）。
(2) 四舍五入是有误差的：其误差值是舍入位的一半。

下面我们以舍入运用最频繁的银行利息计算为例来阐述上述问题。银行的盈利渠道主要是利息差，从储户中获取资金然后放贷。所以对银行来说，对付给储户的利息的计算非常频繁。那我们回过头来看看四舍五入，小于5的数字被舍去、大于等于5的数字进位后舍去，由于所有位上的数字都是自然算出来的，概率相等，下面以10笔存款利息作为模型，来思考这个算法：
(1) 四舍。舍弃的数值：0.000、0.001、0.002、0.003、0.004，因为是舍弃的，对银行来说，每舍弃一个数字就会赚取相应的金额：0.000、0.001、0.002、0.003、0.004。
(2) 五入。进位的数值：0.005、0.006、0.007、0.008、0.009，因为是进位的，对银行来说，每进位一个数字就会亏顺相应的金额：0.001、0.002、0.003、0.004.、0.005。
(3) 因为舍弃和进位的数字在0-9是均匀分布的，所以对银行来说，每10笔利息计算会损失0.005元。
(4) 对一家有5千万储户的银行来说，每年仅仅因为四舍五入的误差而损失的金额就会有100000元。
```Java
public class Client {
	public static void main(String[] args) {
		// 银行账户数量：50_000_000
		int accountNum = 50_000_000;
		// 按照人民银行的规定，每个季度的末月的20日为银行结息日
		double cost = 0.005 * accountNum * 4;
		System.out.println("银行每年损失的金额：" + cost);
	}
}
```
![建议25_2](https://i.loli.net/2017/10/13/59e0d1ee78dbc.png)
这个算法的误差是由美国银行家发现的，并且对此提出了一个修正算法，叫做银行家舍入（Banker's Round）的近似算法，其规则如下：
&emsp;① 舍去的数值小于5时，直接舍去。
&emsp;② 舍去位的数值大于等于6时，进位后舍去。
&emsp;③ 当舍去位的数值等于5时，分两种情况：5后面还有数字（非0），则进位后舍去；若5后面是0，则根据5前一位的奇偶性来判断是否需要进位，奇数进位，偶数舍去。
&emsp;④ 以上规则汇总成一句话（四舍六入五留双）：四舍六入五考虑，五后非零就进一，五后为零看奇偶，五前为偶应舍去，五前为奇要进一。举例说明，取两位精度：
&emsp;&emsp;round(10.5551) = 10.56
&emsp;&emsp;round(10.555)   = 10.56
&emsp;&emsp;round(10.545)   = 10.54
(5) 要在Java 5以上版本使用银行家舍入算法非常简单，直接使用RoundingMode类提供的Round模式即可：
```Java
public class Client {
	public static void main(String[] args) {
		// 存款
		BigDecimal d = new BigDecimal(888888);
		// 月利率，乘以3计 算季利率
		BigDecimal r = new BigDecimal(0.001875 * 3);
		// 计算利息
		BigDecimal i = d.multiply(r).setScale(2, RoundingMode.HALF_EVEN);
		System.out.println("季利息是：" + i);
	}
}
```
![建议25_3](https://i.loli.net/2017/10/13/59e0d2439d3f6.png)
在上面的例子中，我们使用了BigDecimal类，并且采用setScale方法设置了精度，同时传递了一个RoundingMode.HALF_EVEN参数表示使用银行家舍入法则进行舍入运算，BIgDecimal和RoundingMode是绝配，想要采用什么舍入模式使用RoundingMode设置即可。
(6) 目前Java支持以下七种舍入模式：
&emsp;① ROUND_UP：远离零方向舍入
&emsp;向远离0的方向舍入，也就是向绝对值最大的方向舍入，只要舍弃为非0即进位。
&emsp;② ROUND_DOWN：趋向零方向舍入
&emsp;向0方向靠拢，就是位上所有数值都舍弃，不存在进位情况。
&emsp;③ ROUND_CEILING：向正无穷方向舍入
&emsp;向正无穷方向靠拢，如果是正数，舍入行为类似ROUND_UP；如果是负数，舍入行为类似ROUND_DOWN。注意：Math.round方法使用的就是该模式。
&emsp;④ ROUND_FLOOR：向负无穷方向舍入
&emsp;向负无穷方向靠拢，如果是正数，舍入行为类似ROUND_DOWN；如果是负数，舍入行为类似ROUND_UP。
&emsp;⑤ HALF_UP：最近数字舍入（5进）
&emsp;这就是经典的四舍五入模式。
&emsp;⑥ HALF_EVEN：银行家舍入算法
&emsp;在普通项目中舍入模式不会有太多影响，可以直接使用Math.round方法，但在大量与货币数字交互的项目中，一定要选择好近似的计算模式，尽量减少因算法不同而造成的损失。
**注意：根据不同的场景，慎重选择不同的舍入模式，以提高项目的精准度，减少算法损失。**

## 建议26：提防包装类型的null值
Java引入包装类型（wrapper Types）是为了解决基本类型的实例化问题，以便让一个基本数据类型也能参与到面向对象的编程的世界中去。在Java 5中的泛型更是对基本数据类型说了“不”，如果想要把一个整型数据放到List中，就必须使用Integer包装类型：
```Java
public class Client {
	public static void main(String[] args) {
		List<Integer> list = new ArrayList<>();
		list.add(1);
		list.add(2);
		list.add(null);
		System.out.println(f(list));
	}

	// 计算list中所有元素之和
	public static int f(List<Integer> list) {
		int count = 0;
		for (int i : list) {
			count += i;
		}
		return count;
	}
}
```
![建议26_1](https://i.loli.net/2017/10/13/59e0d2d0686b9.png)
代码很简单，f方法接收的参数是一个List参数，然后计算List中所有元素之和。把1、2和空值都放到List中，然后调用方法计算，基本类型和包装类型通过自动装箱（Autoboxing）和自动拆箱（AutoUnboxing）自由转换的，可是null为什么没有转换为0？
(1) 在程序的for循环过程中，隐含了一个拆箱过程，在此过程中包装类型转换为了基本类型。
(2) 拆箱过程是通过调用包装对象的intValue方法实现的，由于包装对象是null，访问其intValue方法就会报NullPointerException。
(3) 问题想清楚了，修改也很简单，加入null值检查即可：
```Java
public class Client {
	public static void main(String[] args) {
		List<Integer> list = new ArrayList<>();
		list.add(1);
		list.add(2);
		list.add(null);
		System.out.println(f(list));
	}

	// 计算list中所有元素之和
	public static int f(List<Integer> list) {
		int count = 0;
		for (Integer i : list) {
			count += (i != null) ? i : 0;
		}
		return count;
	}
}
```
(4) 上面以Integer和int为例说明了拆箱问题，其他7个包装对象的拆箱过程也存在着同样的问题。对于此类问题，切记要在包装类型参与运算时，要做null值校验。

## 建议27：谨慎包装类型的大小比较
基本类型是可以比较大小的，其所对应的包装类都实现了Comparable接口也说明了此问题，下面来比较一下两个包装类对象的大小：
```Java
public class Client {
	public static void main(String[] args) {
		Integer i = new Integer(100);
		Integer j = new Integer(100);
		compare(i, j);
	}

	// 比较两个包装对象的大小
	public static void compare(Integer i, Integer j) {
		System.out.println(i == j);
		System.out.println(i > j);
		System.out.println(i < j);
        System.out.println(i == 100);
	}
}
```
代码很简单，产生了两个Integer对象，然后比较两者的大小关系，既然基本类型和包装类型可以自由转换，那是不是两个Integer对象就是相等呢？
![建议27_1](https://i.loli.net/2017/10/13/59e0d3158e441.png)
打印结果前面都是false，只有最后一个i == 100正确，为什么？下面来一一解释：
(1) i == j
在Java中“==”是用来判断两个操作数是否有相等关系的，如果是基本数据类型则判断值是否相等，如果是对象则判断是否是一个对象的两个引用，也就是地址是否相等，这里很明显是两个对象，不可能相等。
(2) i > j 和 i < j
在Java中，“>”和“<”用来判断两个数字类型的大小关系，注意只能使数字型的判断，对于Integer包装类型来说，是根据其intValue()方法的返回值（也就是其相应的基本类型）进行比较的（其他包装类型是根据相应的value值比较的，如doubleValue、floatValue等），那很显然，两者不可能有大小关系。
(3) 问题清楚了，修改就比较容易了，直接使用Integer实例的compareTo方法即可。这类问题的产生是习惯问题，只要是两个对象之间的比较就应该采用相应的方法，而不是通过Java的默认机制来处理。

## 建议28：优先使用整型池
上一建议解释了包装对象的比较问题，本建议将继续深入探讨相关问题，首先看如下代码：
```Java
public class Client {
	 public static void main(String[] args) {
		Scanner input = new Scanner(System.in);
		while(input.hasNextInt()) {
			int ii = input.nextInt();
			System.out.println("\n====" + ii + "的相等判断====");
			// 两个通过new产生的Integer对象
			Integer i = new Integer(ii);
			Integer j = new Integer(ii);
			System.out.println("new产生的对象：" + (i == j));

			// 基本类型转换为包装类型比较
			i = ii;
			j = ii;
			System.out.println("基本类型转换的对象：" + (i == j));

			// 通过静态方法生成一个实例
			i = Integer.valueOf(i);
			j = Integer.valueOf(i);
			System.out.println("valueOf产生的对象：" + (i == j));
		}
	}
}
```
输入三个数字127、128、555，结果如下：
![建议28_1](https://i.loli.net/2017/10/13/59e0d34c6171d.png)
很不可思议，数字127的比较结果表明它的装箱动作所产生的对象竟然是同一个对象，valueOf产生的也是同一个对象，但是大于127的数字128和555在比较过程中产生的却不是同一个对象，这是为什么？
(1) new产生的Integer对象
new声明的就是要生成一个新的对象，没二话，这是两个对象，地址肯定不等，比较结果为false。
(2) 装箱生成的对象
首先要说明的是装箱动作是通过valueOf方法实现的，也就是后两个方法是相通的，那结果也肯定是一样的，现在的问题是：valueOf如何产生对象呢？来看一下Integer.valueOf的实现代码：
```Java
public static Integer valueOf(int i) {
    if (i >= IntegerCache.low && i <= IntegerCache.high) // low = -128,high = 127
        return IntegerCache.cache[i + (-IntegerCache.low)];
    return new Integer(i);
}
```
这段代码的意思很明了，如果是-128到127之间的int类型转换为Integer对象，则直接从cache数组中获得，那cache数组里又是什么呢？它的代码如下：
```Java
static final Integer cache[];

cache = new Integer[(high - low) + 1];
int j = low;
for(int k = 0; k < cache.length; k++)
    cache[k] = new Integer(j++);
```
cache是IntergerCache内部类的一个静态数组，容纳的是-128到127之间的对象。通过valueOf产生包装对象时，如果int参数在-128到127之间，则直接从整型池中获得对象，不在该范围的int类型则通过new生成包装对象。
(3) 明白了这一点，要理解上面的输出结果就迎刃而解，127的包装对象是直接从整型池中获得对象，不管输入多少个127，获得的对象都是同一个，那地址当然是相等的。而128、555超出了整型池范围，是通过new产生一个新的对象，地址不同，当然也就不相等了。
(4) 整型池的存在不仅仅提高了系统性能，同时也节约了内存空间，这也是我们使用整型池的原因，也就是在声明包装对象的时候使用valueOf生成，而不是通过构造函数来生成的原因。
(5) 在判断对象是否相等的时候，最好是使用equals方法，避免用“==”产生非预期结果。
**注意：通过包装类的valueOf方法生成的包装类实例可以显著提高空间和时间性能。**

## 建议29：优先选择基本类型
包装类型是一个类，它提供了诸如构造方法、类型转换、比较等非常使用的功能，而且在Java 5之后实现与基本类型的自动转换，这是包装类型如虎添翼，应用更加广泛，但无论是从安全性、性能方面还是稳定性来说，基本类型都是首选方案。下面是一段代码：
```Java
public class Client {
	public static void main(String[] args) {
		int intNum = 40;
		long longNum = 40L;
		// 分别传递int类型和Integer类型
		f(intNum);
		f(Integer.valueOf(intNum));
		System.out.println("-----------------");
		f(longNum);
		f(Long.valueOf(longNum));
	}

	public static void f(long a) {
		System.out.println("基本数据类型的方法被调用！");
	}

	public static void f(Long a) {
		System.out.println("包装类型的方法被调用！");
	}
}
```
在上面的程序中首先声明了一个int变量i，然后加宽转变成long型，再调用f()方法，分别传递int和long的基本类型和包装类型，该程序是否能编译通过呢？结果又是什么？
(1) 改程序能编译通过，但说不能通过可能是猜测这些地方不能编译：
&emsp;① f()方法重载有问题。定义两个的两个f()方法实现了重载，一个形参是基本类型，一个形参是包装类型，这类重载很正常。虽然基本类型和包装类型有自动装箱、自动拆箱的功能，但并不影响它们的重载，自动拆箱/装箱只有在赋值时才会发生，和重载没有关系。
&emsp;② f(intNum)报错。intNum是int类型，传递到f(long a)没有任何问题的，编译器会自动把intNum的类型加宽，并将其转变为long类型，这是基本类型的转换规则，没有任何问题。
&emsp;③ f(Integer.valueOf(intNum))报错。代码中没有f(Integer a)方法，不可能接收一个Integer类型的参数，而且Integer和Long两个包装类型是兄弟关系，不是继承关系，那说它编译失败？不，编译是成功的。
(2) 先来看一下输出：
![建议29_1](https://i.loli.net/2017/10/13/59e0d3d471a61.png)
f(intNum)输出是正确的，但是f(Integer.valueOf(intNum))的输出就让人困惑了，为什么会调用f(long a)方法呢？这是因为自动装箱有一个重要的原则：基本类型可以先加宽，再转变成宽类型的包装类型，但不能直接转变为宽类型的包装类型。简单的说就是int可以加宽转变成long，然后再转变为Long对象，但是不能直接有int转变为Long。注意这里指的都是自动转换，不是通过构造函数生成。依据这一原则，来看一个例子：
```Java
public class Client {
	public static void main(String[] args) {
		int intNum = 40;
		f(intNum);

	}

	public static void f(Long a) {
		System.out.println("包装类型的方法被调用！");
	}
}
```
![建议29_2](https://ooo.0o0.ooo/2017/10/13/59e0d3f94282f.png)
这段程序编译是通不过的，因为intNum是一个int类型，不能自动转换为Long类型，但是修改一下就可以：
```Java
public class Client {
	public static void main(String[] args) {
		int intNum = 40;
		f((long)intNum);

	}

	public static void f(Long a) {
		System.out.println("包装类型的方法被调用！");
	}
}
```
这就是int先加宽转变成long类型，然后自动转换成Long类型。
(3) 规则明白了，继续来看f(Integer.valueOf(intNum))是如何调用的，Integer.valueOf(intNum)返回的是一个Integer对象，这没错，但是Integer和int是可以互相转换的。没有f(Integer a)方法，编译器会尝试转换成int类型的实参调用，这下就与f(long a)匹配上，于是乎被加宽成long型，结果也就明显了。
(4) 整个f(Integer.valueOf(intNum))的执行过程是这样的：
&emsp;① intNum通过valueOf方法包装成一个Integer对象。
&emsp;② 由于没有f(Integer a)方法，编译器会尝试把Integer对象转换为int基本类型。
&emsp;③ int自动拓宽成long，编译结束。
(5) 使用包装类型的确有方便的地方，但是也会引起一些不必要的困惑，比如上诉例子，如果f()的两个重载方法使用的都是基本类型，而且实参也是基本类型，就不会产生以上问题，程序的可读性也会变强。自动装箱/拆箱虽然很方便，但是引起的问题有时也非常严重。
**注意：重申，基本类型有限考虑。**

## 建议30：不要随便设置随机种子
随机数在太多的地方都用到了，比如加密、混淆数据等，我们使用随机数是期望获得一个唯一的、不可仿造的数字，以避免产生相同的业务数据造成混乱。在Java项目中通常是通过Math.random方法和Random类来获得随机数的：
```Java
public class Client {
	public static void main(String[] args) {
		Random r = new Random();
		for(int i = 0; i <3; i++) {
			System.out.println("第" + i + "次：" + r.nextInt());
		}
	}
}
```
代码很简单，运行程序可知，三次打印的结果都不同，即使多次运行也是不同，这正是我们想要的随机数。再来看下面的例子：
```Java
public class Client {
	public static void main(String[] args) {
		Random r = new Random(1000); // 显示设置随机种子
		for(int i = 0; i <3; i++) {
			System.out.println("第" + i + "次：" + r.nextInt());
		}
	}
}
```
上面使用了Random的有参构造，运行结果如下：
![建议30_1](https://i.loli.net/2017/10/13/59e0d468618fe.png)
计算机不同，上述数据也不同，但是同一台机器，不管运行多少次，上述结果都是不变的，似乎随机数不随机了，问题何在？
(1) 那是因为产生随机数的种子被固定了，在Java中，随机数的产生取决于种子，随机数和种子之间的关系遵从两个规则：
&emsp;① 种子不同，产生不同的随机数。
&emsp;② 种子相同，即使实例不同也产生相同的随机数。
(2) 知道规则后，再看例子会发现问题就出在有参构造上，Random的默认种子（无参构造）实现如下，注意这个值与距离某一个固定时间点的纳秒数有关，不同的操作系统和硬件有不同的固定时间点，也就是说不同的操作系统该值是不同的，同一个操作系统也会不同，随机数自然也不同。
```Java
public Random() {
    this(seedUniquifier() ^ System.nanoTime());
}
```
(3) 顺便提一下，System.nanoTime()方法不能用于计算日期，那时因为“固定”的时间点是不确定的，纳秒值甚至可能是负值，这点与System.currentTimeMills不同。
(4) new Random(1000)显式地设置了随机种子为1000，运行多次，虽然实例不同，但都会获得相同的三个随机数。所以，除非必要，否则不要设置随机种子。
(5) 再次顺便提一下，在Java中有两种方法可以获得不同的随机数：通过java.util.Random类获得随机数的原理和Math.random方法相同，Math.random()方法也是通过生成一个Random类的实例，然后委托nextDouble()方法的，两者殊途同归。
**注意：若非必要，不要设置随机种子。**
