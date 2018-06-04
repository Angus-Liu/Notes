### # JSP表达式语言（EL）剖析

EL表达式总是放在大括号里，而且前面有一个美元前缀符：${person.name}

| EL隐式对象       | 属性                                                         |
| ---------------- | ------------------------------------------------------------ |
| pageScope        | 页面作用域中的属性                                           |
| requestScope     | 请求作用域中的属性                                           |
| sessionScope     | 会话作用域中的属性                                           |
| applicationScope | 应用作用域中的属性                                           |
| param            |                                                              |
| paramValues      |                                                              |
| header           |                                                              |
| headerValues     |                                                              |
| cookie           |                                                              |
| initparam        |                                                              |
| pageContext      | 在所用隐式对象中，只有pageContext不是映射（map），这是pageContext对象的实际引用 |

### # JSP表达式语言（EL）复习

+ EL表达式总是放在大括号里，而且前面有一个美元前缀符：${expression}。
+ 表达式的第一个命名变量要么是一个隐式对象，要么是某个作用域中的一个属性。
+ 点号操作符允许你使用一个map或一个bean性质名来访问值，其只能放合法的Java标识符。
+ 利用\[ ] 操作符可以访问数组和list，可以把包含命名变量的表达式放在括号里，而且可以任意嵌套。
+ EL表达式不关心列表索引加不加引号。
+ 如果中括号里的内容没有用引号引起来，容器就会进行计算。如果确实放在引号里，而且不是一个数组或是List的索引，容器就会把它看作是性质或键的直接量名。
+ 除了一个EL隐式对象PageContext之外，其他EL隐式对象都是Map。
+ 不要把隐式EL作用域对象（属性的Map）与属性所所绑定的对象混为一谈。例如，requestScope ≠ request。
+ EL函数允许你调用一个普通Java类中的公共静态方法。函数名不一定与具体的方法名匹配。
+ 使用一个TLD（标记库描述文件）将函数名映射到一个具体的静态方法。
+ 要在JSP中使用函数，必须使用taglib指令声明一个命名空间。在taglib指令中放一个prefix属性，高数容器你要调用的函数在哪个TLD里能找到。

### # include指令在转换时发生，\<jsp:include>标准动作在运行时发生

如果使用include指令，容器会在转换时，将复用模板拷贝到每个JSP中，再编译为生成的servlet。也就是会把完整的JSP模板插入到当前引用处。

\<jsp:include>则完全不同，容器会根据页面（page）属性创建一个RequestDisaptcher，并应用include()方法。所分配的JSP针对请求和响应对象执行，而且在同一个线程中运行，之后会把模板JSP文件的响应插入到当前引用的JSP。（好处是可以及时响应更改，坏处是影响性能）

一句话概括：include指令在装换时插入模板JSP的源代码，而\<jsp:include>标准动作在运行时插入模板JSP的响应。

### # Bean相关标准动作复习

+ \<jsp:useBean>标准动作会定义一个变量，它可能是一个现有bean属性的引用，如果不存在这样一个bean，则会创建一个新的bean，这个变量就是新的bean的引用。
+ 如果有一个“type”属性，但是没有“class”属性，bean必须已经存在，因为你没有执行为这个新bean实例化哪个类类型。
+ \<jsp:useBean>标记中可以有一个体，体中的内容会有条件地运行，主要作用是使用\<jsp:setProperty>设置新bean的性质。
+ \<jsp:setProperty>必须有一个name属性（与\<jsp:useBean>的“id”匹配），还要有一个“property”属性。“property”属性必须是一个具体的性质名，或者是通配符“*”。
+ 如果没有包含“value”属性，只有当一个请求参数的名与性质名匹配时，容器才会设置性质值。如果“property”属性使用通配符（*），容器会为所有与某个请求参数名匹配的性质设置值。
+ 如果请求参数名与性质名不同，但是你想把性质的值设置为请求参数值，可以在\<jsp:setProperty>标记中使用“param”属性。
+ \<jsp:setProperty>动作使用自省将“性质”匹配到一个JavaBean设置方法。如果性质是“*”，JSP将迭代处理所有请求参数来设置JavaBean性质。
+ 性质值可以是String或基本类型。

