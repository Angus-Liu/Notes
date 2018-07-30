## 第 9 条：try-with-resources 优于 try-finally

The Java libraries include many resources that must be closed manually by invoking a close method. Examples include InputStream, OutputStream, and java.sql.Connection. Closing resources is often overlooked by clients, with predictably dire performance consequences. While many of these resources use finalizers as a safety net, finalizers don’t work very well (Item 8).    

Java库包含许多必须通过调用`close`方法手动关闭的资源。实例包括`InputStream`，`OutputStream`，和`java.sql.Connection`。关闭资源经常被客户忽视，可预见的可怕性能后果。虽然其中许多资源使用终结器作为安全网，但终结器不能很好地工作（[第8项](https://www.safaribooksonline.com/library/view/effective-java-3rd/9780134686097/ch2.xhtml#lev8)）。

Historically, a try-finally statement was the best way to guarantee that a resource would be closed properly, even in the face of an exception or return:    

从历史上看，一`try`- `finally`声明是保证资源会被正常关闭，即使在异常或回报的脸的最佳方式：

```java
// try-finally - No longer the best way to close resources!
static String firstLineOfFile(String path) throws IOException {
    BufferedReader br = new BufferedReader(new FileReader(path));
    try {
        return br.readLine();
    } finally {
        br.close();
    }
}
```

This may not look bad, but it gets worse when you add a second resource:    

这可能看起来不错，但是当你添加第二个资源时它会变得更糟： 

```java
// try-finally is ugly when used with more than one resource!
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

It may be hard to believe, but even good programmers got this wrong most of the time. For starters, I got it wrong on page 88 of *Java Puzzlers* [[Bloch05](https://www.safaribooksonline.com/library/view/effective-java-3rd/9780134686097/ref.xhtml#rBloch05)], and no one noticed for years. In fact, two-thirds of the uses of the `close` method in the Java libraries were wrong in 2007.

可能很难相信，但即使是优秀的程序员也会在大多数时候弄错。对于初学者来说，我在*Java Puzzlers* [ [Bloch05](https://www.safaribooksonline.com/library/view/effective-java-3rd/9780134686097/ref.xhtml#rBloch05) ]的第88页上[弄错了](https://www.safaribooksonline.com/library/view/effective-java-3rd/9780134686097/ref.xhtml#rBloch05)，多年来没有人注意到。实际上，`close`2007年Java方法中该方法的三分之二使用是错误的。

Even the correct code for closing resources with `try`-`finally` statements, as illustrated in the previous two code examples, has a subtle deficiency. The code in both the `try` block and the `finally` block is capable of throwing exceptions. For example, in the `firstLineOfFile` method, the call to `readLine` could throw an exception due to a failure in the underlying physical device, and the call to `close` could then fail for the same reason. Under these circumstances, the second exception completely obliterates the first one. There is no record of the first exception in the exception stack trace, which can greatly complicate debugging in real systems—usually it’s the first exception that you want to see in order to diagnose the problem. While it is possible to write code to suppress the second exception in favor of the first, virtually no one did because it’s just too verbose.

即使是使用`try`- `finally`语句关闭资源的正确代码，如前两个代码示例所示，也有一个微妙的缺陷。`try`块和`finally`块中的代码都能够抛出异常。例如，在该`firstLineOfFile`方法中，`readLine`由于底层物理设备发生故障以及调用，调用可能会引发异常`close`然后可能因同样的原因而失败。在这种情况下，第二个例外完全抹杀了第一个例外。异常堆栈跟踪中没有第一个异常的记录，这可能会使实际系统中的调试变得非常复杂 - 通常这是您要查看以诊断问题的第一个异常。虽然有可能编写代码来抑制第二个异常而支持第一个异常，但几乎没有人这样做，因为它太冗长了。

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