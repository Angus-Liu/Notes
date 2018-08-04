## 第 9 条：try-with-resources 优于 try-finally

Java库中包含了许多必须通过调用 `close` 方法手动关闭的资源。包括 `InputStream`，`OutputStream`，和 `java.sql.Connection` 等。但关闭资源常常被客户端所忽视，导致了预料内的糟糕性能影响 。虽然这其中有许多资源使用了 finalizer 作为安全网，但 finalizer 并不能很好地工作（[第 8 条][item8]）。

从以往看，try-finally 语句是保证资源被正确关闭的最佳方式 ，即使在遇到异常或返回时：

```java
// try-finally - 不再是关闭资源的最佳方式!
static String firstLineOfFile(String path) throws IOException {
    BufferedReader br = new BufferedReader(new FileReader(path));
    try {
        return br.readLine();
    } finally {
        br.close();
    }
}
```

这看起来可能还不错，但当你添加第二个资源时，情况就慢慢变得糟糕起来： 

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

可能很难相信，即使是优秀的程序员，大多数时候也会在这上面犯错。起初，我在《Java解惑》（ Java Puzzlers [[Bloch05](#Bloch05)]）的第88页上就将它弄错了，但多年来都没有人注意到。事实上，2007 年 Java 库中关于 `close` 方法的使用有三分之二是错的。
[备注]: (//) 感觉这里应该是 2017 年。


即使在使用 try-finally 语句关闭资源的正确代码中，如前两个代码块所示，也有一个不易察觉的缺陷。try 语句块和 finally 语句块中的代码都能够抛出异常。例如，在 `firstLineOfFile` 方法中，对 `readLine` 方法的调用可能会因为底层物理设备的故障而抛出异常，对 `close` 方法的调用可能会因为同样的原因而失败。 在这种情况下，第二个例外完全抹杀了第一个例外。异常堆栈跟踪中没有第一个异常的记录，这可能会使实际系统中的调试变得非常复杂 - 通常这是您要查看以诊断问题的第一个异常。虽然有可能编写代码来抑制第二个异常而支持第一个异常，但几乎没有人这样做，因为它太冗长了。

All of these problems were solved in one fell swoop when Java 7 introduced the `try`-with-resources statement [JLS, 14.20.3]. To be usable with this construct, a resource must implement the `AutoCloseable` interface, which consists of a single `void`-returning `close`method. Many classes and interfaces in the Java libraries and in third-party libraries now implement or extend `AutoCloseable`. If you write a class that represents a resource that must be closed, your class should implement `AutoCloseable` too.

当Java 7引入`try`-with-resources语句[JLS，14.20.3] 时，所有这些问题都得到了一举解决。要使用此构造，资源必须实现`AutoCloseable`接口，该接口由单个`void`返回`close`方法组成。现在，Java库和第三方库中的许多类和接口都实现或扩展`AutoCloseable`。如果您编写的代表必须关闭的资源的类，您的类也应该实现`AutoCloseable`。

Here’s how our first example looks using `try`-with-resources: 

以下是我们的第一个示例使用`try`-with-resources的方式：

```java
// try-with-resources - the the best way to close resources!

static String firstLineOfFile(String path) throws IOException {

    try (BufferedReader br = new BufferedReader(
        new FileReader(path))) {
        return br.readLine();
    }

}
```

And here’s how our second example looks using `try`-with-resources: 

以下是我们的第二个示例如何使用`try`-with-resources： 

```java
// try-with-resources on multiple resources - short and sweet

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

Not only are the `try`-with-resources versions shorter and more readable than the originals, but they provide far better diagnostics. Consider the `firstLineOfFile` method. If exceptions are thrown by both the `readLine` call and the (invisible) `close`, the latter exception is *suppressed* in favor of the former. In fact, multiple exceptions may be suppressed in order to preserve the exception that you actually want to see. These suppressed exceptions are not merely discarded; they are printed in the stack trace with a notation saying that they were suppressed. You can also access them programmatically with the `getSuppressed` method, which was added to `Throwable` in Java 7.

`try`-with-resources版本不仅比原始版本更短，更易读，而且它们提供了更好的诊断功能。考虑一下`firstLineOfFile` 方法。如果`readLine`调用和（不可见）都抛出异常`close`，则后一个异常被*抑制*为有利于前者。实际上，可以抑制多个异常以保留您实际想要查看的异常。这些被抑制的异常不仅被丢弃; 它们被打印在堆栈跟踪中，并带有一个表示它们被压缩的符号。您还可以使用Java 7中`getSuppressed`添加的方法以编程方式访问它们`Throwable`。

You can put catch clauses on `try`-with-resources statements, just as you can on regular `try`-`finally` statements. This allows you to handle exceptions without sullying your code with another layer of nesting. As a slightly contrived example, here’s a version our `firstLineOfFile` method that does not throw exceptions, but takes a default value to return if it can’t open the file or read from it:

你可以把catch子句`try`-with资源报表，就像你可以在普通`try`- `finally`语句。这允许您处理异常，而不会使用另一层嵌套来破坏您的代码。作为一个有点人为的例子，这里是我们的`firstLineOfFile`方法的一个版本，它不会抛出异常，但如果无法打开文件或从中读取，则返回默认值：

```java
// try-with-resources with a catch clause
static String firstLineOfFile(String path, String defaultVal) {

    try (BufferedReader br = new BufferedReader(
        new FileReader(path))) {
        return br.readLine();
    } catch (IOException e) {
        return defaultVal;
    }

}
```

The lesson is clear: Always use `try`-with-resources in preference to `try-finally` when working with resources that must be closed. The resulting code is shorter and clearer, and the exceptions that it generates are more useful. The `try-`with-resources statement makes it easy to write correct code using resources that must be closed, which was practically impossible using `try`-`finally`. 

经验教训很明确：在使用必须关闭的资源时，始终`try`优先使用-with-resources `try-finally`。生成的代码更短更清晰，它生成的异常更有用。在`try-`与资源语句可以很容易地编写使用，必须关闭资源，这是几乎不可能使用正确的代码`try`- `finally`。 



<p id="Bloch05">[Bloch05] Bloch, Joshua, and Neal Gafter. 2005. Java Puzzlers: Traps, Pitfalls, and Corner Cases. 
Boston: Addison-Wesley.
ISBN: 032133678X.

[item8]: url	"在未来填入第 8 条的 url，否则无法进行跳转"