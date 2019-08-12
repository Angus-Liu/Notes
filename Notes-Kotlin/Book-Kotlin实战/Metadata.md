### @Metadata

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
     * 1 类
     * 2 文件
     * 3 Synthetic class
     * 4 Multi-file class facade
     * 5 Multi-file class part
     *
     * The class file with a kind not listed here is treated as a non-Kotlin file.
     */
    @get:JvmName("k")
    val kind: Int = 1,
    /**
     * 此注解的参数中提供的元数据版本。
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
     * d1的补充：元数据中出现的字符串数组，以纯文本格式编写，以便重用常量池中已存在的字符串。
     * 然后，可以通过该数组中的整数索引在元数据中索引这些字符串。
     */
    @get:JvmName("d2")
    val data2: Array<String> = [],
    /**
     * An extra string. For a multi-file part class, internal name of the facade class.
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
     * 0 - 这是一个多文件类外观或部分，使用-Xmultifile-parts-inherit编译。
     * 1 - 这个类文件由Kotlin的预发行版本编译，发行版本不可见。
     * 2 - 这个类文件是一个编译好的Kotlin脚本源文件(.kts)。
     * 3 - 此类文件的元数据不应由编译器读取，编译器的major.minor版本小于此元数据的主要版本（mv）。
     */
    @SinceKotlin("1.1")
    @get:JvmName("xi")
    val extraInt: Int = 0
)
```

