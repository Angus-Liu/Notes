# 第 12 条：始终重写 toString 方法

 It consists of the class name followed by an “at” sign (`@`) and the unsigned hexadecimal representation of the hash code, for example, `PhoneNumber@163b91`. The general contract for `toString` says that the returned string should be “a concise but informative representation that is easy for a person to read.” While it could be argued that `PhoneNumber@163b91` is concise and easy to read, it isn’t very informative when compared to `707-867-5309`. The `toString` contract goes on to say, “It is recommended that all subclasses override this method.” Good advice, indeed!

虽然 `Object` 提供了 `toString` 方法的一个实现，但它返回的字符串通常并不是类的用户期望看到的。它由类名后跟@符号和散列码的无符号十六进制表示组成，例如 `PhoneNumber@ 163b91`。 toString的一般合同说，返回的字符串应该是“一个简洁但信息丰富的表示，一个人很容易阅读。”虽然可以说PhoneNumber @ 163b91简洁易读，但信息量不大与707-867-5309相比。 toString合同继续说，“建议所有子类都覆盖这个方法。”确实是好建议！

While it isn’t as critical as obeying the `equals` and `hashCode` contracts ([Items 10](https://www.safaribooksonline.com/library/view/effective-java-3rd/9780134686097/ch3.xhtml#lev10) and [11](https://www.safaribooksonline.com/library/view/effective-java-3rd/9780134686097/ch3.xhtml#lev11)), **providing a good** `**toString**` **implementation makes your class much more pleasant to use and makes systems using the class easier to debug**. The `toString`method is automatically invoked when an object is passed to `println`, `printf`, the string concatenation operator, or `assert`, or is printed by a debugger. Even if you never call `toString` on an object, others may. For example, a component that has a reference to your object may include the string representation of the object in a logged error message. If you fail to override `toString`, the message may be all but useless.

虽然它不像遵守equals和hashCode契约那样重要（第10和第11项），但是提供一个好的toString实现会使你的类使用起来更加愉快，并使使用该类的系统更容易调试。当对象传递给println，printf，字符串连接运算符或断言，或由调试器打印时，会自动调用toString方法。即使您从未在对象上调用toString，其他人也可能。例如，具有对象引用的组件可能在记录的错误消息中包含该对象的字符串表示形式。如果您未能覆盖toString，则该消息可能几乎无用。

If you’ve provided a good `toString` method for `PhoneNumber`, generating a useful diagnostic message is as easy as this:

如果您为PhoneNumber提供了一个好的toString方法，那么生成有用的诊断消息就像这样简单：

```java
System.out.println("Failed to connect to " + phoneNumber);
```

Programmers will generate diagnostic messages in this fashion whether or not you override `toString`, but the messages won’t be useful unless you do. The benefits of providing a good `toString` method extend beyond instances of the class to objects containing references to these instances, especially collections. Which would you rather see when printing a map, `{Jenny=PhoneNumber@163b91}` or `{Jenny=707-867-5309}`?

程序员将以这种方式生成诊断消息，无论您是否覆盖toString，但除非您这样做，否则消息将无用。提供良好的toString方法的好处是将类的实例扩展到包含对这些实例的引用的对象，尤其是集合。你打算在打印地图时看到哪一个，{Jenny = PhoneNumber @ 163b91}或{Jenny = 707-867-5309}？

**When practical, the** `**toString**` **method should return** **\*all*** **of the interesting information contained in the object**, as shown in the phone number example. It is impractical if the object is large or if it contains state that is not conducive to string representation. Under these circumstances, `toString` should return a summary such as `Manhattan residential phone directory (1487536 listings)` or `Thread[main,5,main]`. Ideally, the string should be self-explanatory. (The `Thread`example flunks this test.) A particularly annoying penalty for failing to include all of an object’s interesting information in its string representation is test failure reports that look like this:

在可行的情况下，toString方法应该返回对象中包含的所有有趣信息，如电话号码示例所示。如果对象很大或者它包含不利于字符串表示的状态，那是不切实际的。在这种情况下，toString应该返回一个摘要，例如曼哈顿住宅电话簿（1487536列表）或Thread [main，5，main]。理想情况下，字符串应该是不言自明的。 （线程示例使这个测试失败。）如果未能在其字符串表示中包含所有对象的有趣信息，那么特别恼人的惩罚是测试失败报告如下所示：

```java
Assertion failure: expected {abc, 123}, but was {abc, 123}.
```

One important decision you’ll have to make when implementing a `toString` method is whether to specify the format of the return value in the documentation. It is recommended that you do this for *value classes*, such as phone number or matrix. The advantage of specifying the format is that it serves as a standard, unambiguous, human-readable representation of the object. This representation can be used for input and output and in persistent human-readable data objects, such as CSV files. If you specify the format, it’s usually a good idea to provide a matching static factory or constructor so programmers can easily translate back and forth between the object and its string representation. This approach is taken by many value classes in the Java platform libraries, including `BigInteger`, `BigDecimal`, and most of the boxed primitive classes.

在实现toString方法时，您必须做出的一个重要决定是，是否在文档中指定返回值的格式。建议您对值类（例如电话号码或矩阵）执行此操作。指定格式的优点是它可以作为对象的标准，明确，人类可读的表示。该表示可用于输入和输出以及持久的人类可读数据对象，例如CSV文件。如果指定格式，通常最好提供匹配的静态工厂或构造函数，以便程序员可以轻松地在对象及其字符串表示之间来回转换。 Java平台库中的许多值类都采用了这种方法，包括BigInteger，BigDecimal和大多数盒装基元类。

The disadvantage of specifying the format of the `toString` return value is that once you’ve specified it, you’re stuck with it for life, assuming your class is widely used. Programmers will write code to parse the representation, to generate it, and to embed it into persistent data. If you change the representation in a future release, you’ll break their code and data, and they will yowl. By choosing not to specify a format, you preserve the flexibility to add information or improve the format in a subsequent release.

指定toString返回值的格式的缺点是，一旦你指定了它，你就会终身坚持它，假设你的类被广泛使用。程序员将编写代码来解析表示，生成表示并将其嵌入到持久数据中。如果您在将来的版本中更改了表示形式，那么您将破坏其代码和数据，并且它们会y。y。通过选择不指定格式，可以保留在后续版本中添加信息或改进格式的灵活性。

**Whether or not you decide to specify the format, you should clearly document your intentions.** If you specify the format, you should do so precisely. For example, here’s a `toString` method to go with the `PhoneNumber` class in [Item 11](https://www.safaribooksonline.com/library/view/effective-java-3rd/9780134686097/ch3.xhtml#lev11):

无论您是否决定指定格式，都应清楚地记录您的意图。如果指定格式，则应该精确地指定格式。例如，这是一个与第11项中的PhoneNumber类一起使用的toString方法：

```java
/**

  * Returns the string representation of this phone number.

  * The string consists of twelve characters whose format is

  * "XXX-YYY-ZZZZ", where XXX is the area code, YYY is the

  * prefix, and ZZZZ is the line number. Each of the capital

  * letters represents a single decimal digit.

  *

  * If any of the three parts of this phone number is too small

  * to fill up its field, the field is padded with leading zeros.

  * For example, if the value of the line number is 123, the last

  * four characters of the string representation will be "0123".

  */

 @Override public String toString() {

     return String.format("%03d-%03d-%04d",

             areaCode, prefix, lineNum);

 }

```

If you decide not to specify a format, the documentation comment should read something like this:

如果您决定不指定格式，则文档注释应如下所示：

```java
/**

  * Returns a brief description of this potion. The exact details

  * of the representation are unspecified and subject to change,

  * but the following may be regarded as typical:

  *

  * "[Potion #9: type=love, smell=turpentine, look=india ink]"

  */

 @Override public String toString() { ... }

```

After reading this comment, programmers who produce code or persistent data that depends on the details of the format will have no one but themselves to blame when the format is changed.

在阅读此评论之后，编写依赖于格式细节的代码或持久数据的程序员在格式更改时将没有任何人可归咎于自己。

Whether or not you specify the format, **provide programmatic access to the information contained in the value returned by** `**toString**`**.** For example, the `PhoneNumber` class should contain accessors for the area code, prefix, and line number. If you fail to do this, you *force* programmers who need this information to parse the string. Besides reducing performance and making unnecessary work for programmers, this process is error-prone and results in fragile systems that break if you change the format. By failing to provide accessors, you turn the string format into a de facto API, even if you’ve specified that it’s subject to change.

无论是否指定格式，都可以以编程方式访问toString返回的值中包含的信息。例如，PhoneNumber类应包含区号，前缀和行号的访问器。如果您不这样做，则强制需要此信息的程序员解析字符串。除了降低性能并为程序员做出不必要的工作之外，这个过程容易出错，如果你改变格式，会导致脆弱的系统崩溃。由于未能提供访问器，您将字符串格式转换为事实上的API，即使您已指定它可能会发生更改。

It makes no sense to write a `toString` method in a static utility class ([Item 4](https://www.safaribooksonline.com/library/view/effective-java-3rd/9780134686097/ch2.xhtml#lev4)). Nor should you write a `toString` method in most enum types ([Item 34](https://www.safaribooksonline.com/library/view/effective-java-3rd/9780134686097/ch6.xhtml#lev34)) because Java provides a perfectly good one for you. You should, however, write a `toString` method in any abstract class whose subclasses share a common string representation. For example, the `toString`methods on most collection implementations are inherited from the abstract collection classes.

在静态实用程序类中编写toString方法是没有意义的（第4项）。你也不应该在大多数枚举类型（第34项）中编写toString方法，因为Java为你提供了一个非常好的方法。但是，您应该在任何抽象类中编写toString方法，其子类共享一个公共字符串表示形式。例如，大多数集合实现上的toString方法都是从抽象集合类继承的。

Google’s open source AutoValue facility, discussed in [Item 10](https://www.safaribooksonline.com/library/view/effective-java-3rd/9780134686097/ch3.xhtml#lev10), will generate a `toString`method for you, as will most IDEs. These methods are great for telling you the contents of each field but aren’t specialized to the *meaning* of the class. So, for example, it would be inappropriate to use an automatically generated `toString` method for our `PhoneNumber`class (as phone numbers have a standard string representation), but it would be perfectly acceptable for our `Potion` class. That said, an automatically generated `toString` method is far preferable to the one inherited from `Object`, which tells you *nothing* about an object’s value.

第10项中讨论的Google的开源AutoValue工具将为您生成toString方法，大多数IDE也是如此。这些方法非常适合告诉您每个字段的内容，但不是专门针对类的含义。因此，例如，对我们的PhoneNumber类使用自动生成的toString方法是不合适的（因为电话号码具有标准字符串表示），但它对于我们的Potion类是完全可以接受的。也就是说，自动生成的toString方法远比从Object继承的方法更好，它不会告诉您对象的值。

To recap, override `Object`’s `toString` implementation in every instantiable class you write, unless a superclass has already done so. It makes classes much more pleasant to use and aids in debugging. The `toString` method should return a concise, useful description of the object, in an aesthetically pleasing format.

回顾一下，在你编写的每个可实例化的类中重写Object的toString实现，除非超类已经这样做了。它使类的使用更加愉快，并有助于调试。 toString方法应该以美学上令人愉悦的格式返回对象的简明有用的描述。