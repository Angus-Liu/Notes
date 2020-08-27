### @Metadata

`@Metadata` 是 Kotlin 里比较特殊的一个注解。它记录了 Kotlin 代码元素的一些信息，比如 class 的可见性，function 的返回值，参数类型，property 的 lateinit，nullable 的属性等等。这些 Metadata 的信息由 kotlinc 生成，最终会以注解的形式存于 `.class` 文件。

之所以要把这些信息存放到 metadata 里，是因为 Kotlin 最终要编译为 java 的 bytecode，而 java bytecode 的定义里是没有 Kotlin 独有的语法信息（internal/lateinit/nullable等）的，所以要把这些信息已某种形式存放起来，也就是 `@Metadata`。

`@Metadata` 的信息会一直保留到运行时(`AnnotationRetention.RUNTIME`)，也就是说我们可以在运行时通过反射的方式获取 `@Metadata` 的信息，比如要判断某个 class 是否为 kotlin class，只需要判断它是否有 `@Metadata` 注解即可。Kotlin 的反射 API 就是基于 `@Metadata` 来实现的。

以下是 Metadata 的源码机翻：

```kotlin
/**
 * 该注解存在于Kotlin编译器生成的任何类文件中，编译器和反射将对它进行读取。
 * 参数具有非常短的JVM名称：这些名称出现在所有生成的类文件中，我们希望减小它们的大小。
 */
@Retention(AnnotationRetention.RUNTIME)
@Target(AnnotationTarget.CLASS)
@SinceKotlin("1.3")
public annotation class Metadata(
    /**
     * 该注解编码的一种元数据。Kotlin编译器可以识别以下类型(参见KotlinClassHeader.Kind):
     *
     * 1 Class 
     * 2 File 
     * 3 Synthetic class 
     * 4 Multi-file class facade 
     * 5 Multi-file class part
     *
     * 这里没有列出的类文件被视为非kotlin文件。
     */
    @get:JvmName("k")
    val kind: Int = 1,
    /**
     * 此注解的参数中提供的元数据的版本。
     */
    @get:JvmName("mv")
    val metadataVersion: IntArray = [],
    /**
     * 用该注解注释的类文件的字节码接口的版本(命名约定、签名)。
     */
    @get:JvmName("bv")
    val bytecodeVersion: IntArray = [],
    /**
     * 自定义格式的元数据。对于不同的类型，格式可能不同(甚至不存在)。
     */
    @get:JvmName("d1")
    val data1: Array<String> = [],
    /**
     * d1的补充：元数据中出现的字符串数组，以纯文本格式编写，以便重用常量池中已存在的字符串。这些字符串可以在元数据中由这个数组中的整数索引建立索引。
     */
    @get:JvmName("d2")
    val data2: Array<String> = [],
    /**
     * 额外的字符串。对于多文件部件类，外观类的内部名称。
     */
    @get:JvmName("xs")
    val extraString: String = "",
    /**
     * 从Kotlin的角度来看，该类所在的包的完全限定名，如果这个名称与JVM的包FQ名称没有区别，则为空字符串。
     * 如果使用JvmPackageName注解，这些名称可能不同。
     * 请注意，此信息也存储在相应模块的.kotlin_module文件中。
     */
    @SinceKotlin("1.2")
    @get:JvmName("pn")
    val packageName: String = "",
    /**
     * 额外的int。这个数字的位代表以下标志：
     *
     * 0 - 这是一个多文件类的外观或部分，使用-Xmultifile-parts-inherit编译。
     * 1 - 这个类文件由Kotlin的预发行版本编译，发行版本不可见。
     * 2 - 这个类文件是一个编译好的Kotlin脚本源文件(.kts)。
     * 3 - 此类文件的元数据不应由编译器读取，编译器的major.minor版本小于此元数据的主要版本（mv）。
     */
    @SinceKotlin("1.1")
    @get:JvmName("xi")
    val extraInt: Int = 0
)
```

