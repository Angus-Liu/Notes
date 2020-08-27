## 第 9 条：try-with-resources 优于 try-finally

Java库中包含了许多必须通过调用 `close` 方法手动关闭的资源。包括 `InputStream`，`OutputStream`，和 `java.sql.Connection` 等。但关闭资源常常被客户端所忽视，导致了预料内极其严重的性能影响 。虽然这其中有许多资源使用了 finalizer 作为安全网，但 finalizer 并不能很好地工作（[第 8 条][item8]）。

从以往看，try-finally 语句是保证资源被正确关闭的最佳方式 ，即使在遇到异常或返回时：

```java
// try-finally —— 不再是关闭资源的最佳方式!
static String firstLineOfFile(String path) throws IOException {
    BufferedReader br = new BufferedReader(new FileReader(path));
    try {
        return br.readLine();
    } finally {
        br.close();
    }
}
```

这看起来可能还不错，但当你添加第二个资源时，情况就变得糟糕起来： 

```java
// 当使用多个资源时，try-finally 变得令人厌恶!
static void copy(String src, String dst) throws IOException {
    InputStream in = new FileInputStream(src);
    try {
        OutputStream out = new FileOutputStream(dst);
        try {
            byte[] buf = new byte[BUFFER_SIZE];
            int n;
            while ((n = in.read(buf)) >= 0)
                out.write(buf, 0, n);
        } finally {
            out.close();
        }
    }
    finally {
        in.close();
    }
}
```

可能难以置信，即使是优秀的程序员，大多数时候也会在这上面犯错。起初，我在《Java解惑》（ Java Puzzlers [[Bloch05](#Bloch05)]）的第88页上就将它弄错了，但多年来都没有人注意到。事实上，2007 年 Java 库中关于 `close` 方法的使用有三分之二是错的。


即使在使用 try-finally 语句关闭资源的正确代码中，如前两个代码块所示，也有一个不易察觉的缺陷。try 语句块和 finally 语句块中的代码都能够抛出异常。例如，在 `firstLineOfFile` 方法中，对 `readLine` 方法的调用可能会因为底层物理设备的故障而抛出异常，对 `close` 方法的调用可能会因为同样的原因而失败。 在这种情况下，第二个异常将第一个异常完全掩盖了。异常堆栈跟踪中没有第一个异常的记录，这可能会使实际系统中的调试变得非常复杂——通常，为了诊断问题，你希望看到第一个异常。 虽然可以编写代码抑制第二个异常来支持第一个异常，但实际上没有人这样做，因为太繁琐了。

当 Java 7 引入 try-with-resources 语句后 [JLS，14.20.3]，所有的这些问题一并得到了解决。要使用此构造，资源必须实现 `AutoCloseable` 接口，该接口由一个没有返回值（void-returning）的 `close` 方法组成。现在，Java 库和第三方库中的许多类和接口都实现或者继承了 `AutoCloseable` 接口。如果你编写的类代表必须关闭的资源，那么你的类也应该实现 `AutoCloseable` 接口。

下面是我们第一个使用 try-with-resources 语句块的示例：

```java
// try-with-resources —— 关闭资源的最佳方式!
static String firstLineOfFile(String path) throws IOException {
    try (BufferedReader br = new BufferedReader(
        new FileReader(path))) {
        return br.readLine();
    }
}
```

下面是我们第二个使用 try-with-resources 语句块的示例：

```java
// try-with-resources 处理多个资源时，简短且酷毙了！
static void copy(String src, String dst) throws IOException {
    try (InputStream   in = new FileInputStream(src);
        OutputStream out = new FileOutputStream(dst)) {
        byte[] buf = new byte[BUFFER_SIZE];
        int n;
        while ((n = in.read(buf)) >= 0)
            out.write(buf, 0, n);
    }
}
```

try-with-resources 版本不仅比原始版本更短、更易读，而且提供了更好的诊断功能。考虑 `firstLineOfFile` 方法。如果对 `readLine` 方法的调用和对 `close` 方法的调用（不可见）都抛出了异常，则为了利于前者，后一个异常会被抑制。实际上，为了保留你真正想要看到的异常，可能会抑制多个异常。这些被抑制的异常并不仅仅被丢弃；它们会被打印在堆栈跟踪中，并带有一个表示它们被抑制的符号。你还可以借助 Java 7 中添加到 `Throwable` 类的 `getSuppressed `方法，以编程的方式访问它们。

你可以把 catch 子句放在 try-with-resources 语句块中，就像在普通的 try-finally 语句中那样。这允许你对异常进行处理，而不必使用另一层嵌套对代码造成影响。作为一个稍显人为的例子，这是我们的 `firstLineOfFile` 方法的一个版本，它不会抛出异常，但如果无法打开文件或从中读取，它将返回一个默认值：

```java
// try-with-resources 带一个 catch 子句
static String firstLineOfFile(String path, String defaultVal) {
    try (BufferedReader br = new BufferedReader(
        new FileReader(path))) {
        return br.readLine();
    } catch (IOException e) {
        return defaultVal;
    }

}
```

结论很明确：在使用必须关闭的资源时，始终优先使用 try-with-resources 而不是 try-finally。它生成的代码更短更清晰，产生的异常信息也更有用。使用 try-with-resources 语句使得正确编写那些必须被关闭的资源的代码变得容易，而这在使用 try-finally 语句时几乎是不可能的。

<p id="Bloch05">[Bloch05] Bloch, Joshua, and Neal Gafter. 2005. Java Puzzlers: Traps, Pitfalls, and Corner Cases. 
Boston: Addison-Wesley.
ISBN: 032133678X.

[item8]: url	"在未来填入第 8 条的 url，否则无法进行跳转"



>翻译：Angus、
>
>校对：