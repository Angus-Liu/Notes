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
     * Fully qualified name of the package this class is located in, from Kotlin's point of view, or empty string if this name
     * does not differ from the JVM's package FQ name. These names can be different in case the [JvmPackageName] annotation is used.
     * Note that this information is also stored in the corresponding module's `.kotlin_module` file.
     */
    @SinceKotlin("1.2")
    @get:JvmName("pn")
    val packageName: String = "",
    /**
     * An extra int. Bits of this number represent the following flags:
     *
     * * 0 - this is a multi-file class facade or part, compiled with `-Xmultifile-parts-inherit`.
     * * 1 - this class file is compiled by a pre-release version of Kotlin and is not visible to release versions.
     * * 2 - this class file is a compiled Kotlin script source file (.kts).
     * * 3 - the metadata of this class file is not supposed to be read by the compiler, whose major.minor version is less than
     *   the major.minor version of this metadata ([mv]).
     */
    @SinceKotlin("1.1")
    @get:JvmName("xi")
    val extraInt: Int = 0
)
```

