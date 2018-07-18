## 第 3 条：用私有构造器或者枚举类型强化 Singleton 属性

A singleton is simply a class that is instantiated exactly once [Gamma95]. Singletons typically represent either a stateless object such as a function (Item 24) or a system component that is intrinsically unique. Making a class a singleton can make it difficult to test its clients because it’s impossible to substitute a mock implementation for a singleton unless it implements an interface that serves as its type.    

甲*单*仅仅是被实例化恰好一次[类[Gamma95](https://www.safaribooksonline.com/library/view/effective-java-3rd/9780134686097/ref.xhtml#rGamma95) ]。单身人士通常代表无状态对象，例如函数（[第24项](https://www.safaribooksonline.com/library/view/effective-java-3rd/9780134686097/ch4.xhtml#lev24)）或本质上唯一的系统组件。**使类成为单例可能会使测试其客户端变得困难，**因为除非它实现了作为其类型的接口，否则不可能将模拟实现替换为单例。

实现单例的方法有两种。两者都基于保持构造函数私有并导出公共静态成员以提供对唯一实例的访问。在一种方法中，该成员是最终字段：

私有构造函数只调用一次，以初始化public static final字段`Elvis.INSTANCE`。缺少公共或受保护的构造函数可以*保证* “单一的”宇宙：`Elvis`一旦`Elvis`初始化类，就会存在一个实例- 不多也不少。客户端所做的任何事情都无法改变这一点，但有一点需要注意：特权客户端可以借助该方法反射性地调用私有构造函数（[第65项](https://www.safaribooksonline.com/library/view/effective-java-3rd/9780134686097/ch9.xhtml#lev65)）`AccessibleObject.setAccessible`。如果您需要防御此攻击，请修改构造函数以使其在要求创建第二个实例时抛出异常。

在实现单例的第二种方法中，公共成员是一种静态工厂方法：

所有调用都`Elvis.getInstance`返回相同的对象引用，并且不会`Elvis`创建任何其他实例（前面提到过相同的警告）。

公共字段方法的主要优点是API清楚地表明该类是单例：公共静态字段是final，因此它将始终包含相同的对象引用。第二个优点是它更简单。

静态工厂方法的一个优点是，它使您可以灵活地改变主意，关于类是否是单例而不更改其API。工厂方法返回唯一的实例，但可以修改它，例如，为每个调用它的线程返回一个单独的实例。第二个优点是，如果您的应用需要，您可以编写*通用的单件工厂*（[第30项](https://www.safaribooksonline.com/library/view/effective-java-3rd/9780134686097/ch5.xhtml#lev30)）。使用静态工厂的最后一个优点是*方法参考*可以用作供应商，例如`Elvis::instance`a `Supplier<Elvis>`。除非其中一个优点相关，否则公共领域方法更可取。

为了使单一类使用这些方法中的任何一种可*序列化*（[第12章](https://www.safaribooksonline.com/library/view/effective-java-3rd/9780134686097/ch12.xhtml#ch12)），仅仅添加`implements Serializable`到其声明是不够的。要维护单例保证，请声明所有实例字段`transient`并提供`readResolve`方法（[第89项](https://www.safaribooksonline.com/library/view/effective-java-3rd/9780134686097/ch12.xhtml#lev89)）。否则，每次反序列化序列化实例时，都会创建一个新实例，在我们的示例中，将导致虚假`Elvis`目击。要防止这种情况发生，请将此`readResolve`方法添加到`Elvis`类中：

实现单例的第三种方法是声明单元素枚举： 

这种方法类似于公共领域方法，但它更简洁，免费提供序列化机制，并提供了对多个实例化的铁定保证，即使面对复杂的序列化或反射攻击。这种方法可能会有点不自然，但**单元素枚举类型通常是实现单例的最佳方法**。请注意，如果您的单例必须扩展超类`Enum`（除非您*可以*声明枚举来实现接口），否则不能使用此方法。 