## URL类

java.net.URL类是对统一资源定位符的抽象。它扩展了java.lang.Object，是一个final类，使用了策略设计模式。协议处理器就是策略，URL类构成上下文，通过它来选择不同的策略。

### 创建新的URL

```java
import java.net.*;

public class ProtocolTester {

    public static void main(String[] args) {

        // hypertext transfer protocol
        testProtocol("http://www.adc.org");

        // secure http
        testProtocol("https://www.amazon.com/exec/obidos/order2/");

        // file transfer protocol
        testProtocol("ftp://ibiblio.org/pub/languages/java/javafaq/");

        // Simple Mail Transfer Protocol
        testProtocol("mailto:elharo@ibiblio.org");

        // telnet
        testProtocol("telnet://dibner.poly.edu/");

        // local file access
        testProtocol("file:///etc/passwd");

        // gopher
        testProtocol("gopher://gopher.anc.org.za/");

        // Lightweight Directory Access Protocol
        testProtocol(
                "ldap://ldap.itd.umich.edu/o=University%20of%20Michigan,c=US?postalAddress");

        // JAR
        testProtocol(
                "jar:http://cafeaulait.org/books/javaio/ioexamples/javaio.jar!"
                        + "/com/macfaq/io/StreamCopier.class");

        // NFS, Network File System
        testProtocol("nfs://utopia.poly.edu/usr/tmp/");

        // a custom protocol for JDBC
        testProtocol("jdbc:mysql://luna.ibiblio.org:3306/NEWS");

        // rmi, a custom protocol for remote method invocation
        testProtocol("rmi://ibiblio.org/RenderEngine");

        // custom protocols for HotJava
        testProtocol("doc:/UsersGuide/release.html");
        testProtocol("netdoc:/UsersGuide/release.html");
        testProtocol("systemresource://www.adc.org/+/index.html");
        testProtocol("verbatim:http://www.adc.org/");
    }

    private static void testProtocol(String url) {
        try {
            // 最简单的URL构造函数只接受一个字符串形式的绝对URL作为唯一的参数
            URL u = new URL(url);
            System.out.println(u.getProtocol() + " is supported");
        } catch (MalformedURLException ex) {
            String protocol = url.substring(0, url.indexOf(':'));
            System.out.println(protocol + " is not supported");
        }
    }
}
```

### 从URL中获取数据

```java
// 下载一个Web页面
import java.io.*;
import java.net.*;

public class SourceViewer {

    public static void main(String[] args) {

        args = new String[]{"http://www.baidu.com"};
        if (args.length > 0) {
            InputStream in = null;
            try {
                // 打开URL进行读取
                URL u = new URL(args[0]);
                in = u.openStream();
                // 缓冲输入以提高性能
                in = new BufferedInputStream(in);
                // 将InputStream串链到一个Reader
                Reader r = new InputStreamReader(in);
                int c;
                while ((c = r.read()) != -1) {
                    System.out.print((char) c);
                }
            } catch (MalformedURLException ex) {
                System.err.println(args[0] + " is not a parseable URL");
            } catch (IOException ex) {
                System.err.println(ex);
            } finally {
                if (in != null) {
                    try {
                        in.close();
                    } catch (IOException e) {
                        // 忽略
                    }
                }
            }
        }
    }
} 
```

```java
// 下载一个对象
import java.io.*;
import java.net.*;

public class ContentGetter {

    public static void main(String[] args) {
        if (args.length > 0) {
            // 打开URL进行读取
            try {
                URL u = new URL(args[0]);
                Object o = u.getContent();
                System.out.println("I got a " + o.getClass().getName());
            } catch (MalformedURLException ex) {
                System.err.println(args[0] + " is not a parseable URL");
            } catch (IOException ex) {
                System.err.println(ex);
            }
        }
    }
}
```

### 分解URL

URL由以下5部分组成：

+ The scheme, also known as the protocol（模式，也称为协议）
+ The authority（授权机构）
+ The path（路径）
+ The fragment identifier, also known as the section or ref（片段标识符，也称为段或ref）
+ The query string（查询字符串）

> For example, in the URL http://www.ibiblio.org/javafaq/books/jnp/index.html? isbn=1565922069#toc, the scheme is http, the authority is www.ibiblio.org, the path is / javafaq/books/jnp/index.html, the fragment identifier is toc, and the query string is isbn=1565922069. However, not all URLs have all these pieces. For instance, the URL http://www.faqs.org/rfcs/rfc3986.html has a scheme, an authority, and a path, but no fragment identifier or query string.    

```java
// URL的组成部分
import java.net.*;

public class URLSplitter {

    public static void main(String args[]) {
        args = new String[]{"https://guangxs.github.io/2018/01/17/Diagrammatize-HTTP-06/#6-3-3-Date"};
        for (int i = 0; i < args.length; i++) {
            try {
                URL u = new URL(args[i]);
                System.out.println("The URL is " + u);
                System.out.println("The scheme is " + u.getProtocol());
                System.out.println("The user info is " + u.getUserInfo());

                String host = u.getHost();
                if (host != null) {
                    int atSign = host.indexOf('@');
                    if (atSign != -1) host = host.substring(atSign + 1);
                    System.out.println("The host is " + host);
                } else {
                    System.out.println("The host is null.");
                }

                System.out.println("The port is " + u.getPort());
                System.out.println("The path is " + u.getPath());
                System.out.println("The ref is " + u.getRef());
                System.out.println("The query string is " + u.getQuery());
            } catch (MalformedURLException ex) {
                System.err.println(args[i] + " is not a URL I understand.");
            }
            System.out.println();
        }
    }
}
```

## URI类

URI是对URL的抽象，不仅包括统一资源定位符URL，还包括统一资源定位名URN。URI类与URL类的区别表现在3个重要的方面：

+ URI类完全有关于资源的标识和URI的解析。它没有提供方法类获取URI所标识资源的表示。
+ 相比URL类，URI类与相关的规范更一致。
+ URI对象可以表示相对URI。URL类在存储URI之前会将其绝对化。

简而言之，URL对象是对应网络获取应用层协议的一个表示，而URI对象纯粹用于解析和处理字符串。URI没有网络获取功能。

### URI的各部分

```java
// URI的各部分
import java.net.*;

public class URISplitter {

    public static void main(String args[]) {
        for (int i = 0; i < args.length; i++) {
            try {
                URI u = new URI(args[i]);
                System.out.println("The URI is " + u);
                if (u.isOpaque()) {
                    System.out.println("This is an opaque URI.");
                    System.out.println("The scheme is " + u.getScheme());
                    System.out.println("The scheme specific part is "
                            + u.getSchemeSpecificPart());
                    System.out.println("The fragment ID is " + u.getFragment());
                } else {
                    System.out.println("This is a hierarchical URI.");
                    System.out.println("The scheme is " + u.getScheme());
                    try {
                        u = u.parseServerAuthority();
                        System.out.println("The host is " + u.getHost());
                        System.out.println("The user info is " + u.getUserInfo());
                        System.out.println("The port is " + u.getPort());
                    } catch (URISyntaxException ex) {
                        // Must be a registry based authority
                        System.out.println("The authority is " + u.getAuthority());
                    }
                    System.out.println("The path is " + u.getPath());
                    System.out.println("The query string is " + u.getQuery());
                    System.out.println("The fragment ID is " + u.getFragment());
                }
            } catch (URISyntaxException ex) {
                System.err.println(args[i] + " does not seem to be a URI.");
            }
            System.out.println();
        }
    }
}
```

## x-www-urlencoded

URL中使用的字符必须来自ASCII的一个固定子集，包括：

+ The capital letters A–Z（大写字母）
+ The lowercase letters a–z（小写字母）
+ The digits 0–9（数字）
+ The punctuation characters - _ . ! ~ * ' (and ,) （部分标点符号）

字符: / & ? @ # ; $ + = 和 % 也可以使用，但只用于特定的用途。如果这些字符以及其他字符字符出现在路径或查询字符串中，都应当进行编码。

### URLEncoder

```java
import java.io.*;
import java.net.*;

public class EncoderTest {

    public static void main(String[] args) {

        try {
            System.out.println(URLEncoder.encode("This string has spaces", "UTF-8")); // 空格除了编码为%20，还可以编码为加号（+）
            System.out.println(URLEncoder.encode("This*string*has*asterisks", "UTF-8"));
            System.out.println(URLEncoder.encode("This%string%has%percent%signs", "UTF-8"));
            System.out.println(URLEncoder.encode("This+string+has+pluses", "UTF-8"));
            System.out.println(URLEncoder.encode("This/string/has/slashes", "UTF-8"));
            System.out.println(URLEncoder.encode("This\"string\"has\"quote\"marks", "UTF-8"));
            System.out.println(URLEncoder.encode("This:string:has:colons", "UTF-8"));
            System.out.println(URLEncoder.encode("This~string~has~tildes", "UTF-8"));
            System.out.println(URLEncoder.encode("This(string)has(parentheses)", "UTF-8"));
            System.out.println(URLEncoder.encode("This.string.has.periods", "UTF-8"));
            System.out.println(URLEncoder.encode("This=string=has=equals=signs", "UTF-8"));
            System.out.println(URLEncoder.encode("This&string&has&ampersands", "UTF-8"));
            System.out.println(URLEncoder.encode("Thiséstringéhasé non-ASCII characters", "UTF-8"));
        } catch (UnsupportedEncodingException ex) {
            throw new RuntimeException("Broken VM does not support UTF-8");
        }
    }
}
```

```
"C:\Program Files\Java\jdk1.8.0_131\bin\java" "-javaagent:D:\IntelliJ IDEA\lib\idea_rt.jar=12821:D:\IntelliJ IDEA\bin" -Dfile.encoding=UTF-8 -classpath "C:\Program Files\Java\jdk1.8.0_131\jre\lib\charsets.jar;C:\Program Files\Java\jdk1.8.0_131\jre\lib\deploy.jar;C:\Program Files\Java\jdk1.8.0_131\jre\lib\ext\access-bridge-64.jar;C:\Program Files\Java\jdk1.8.0_131\jre\lib\ext\cldrdata.jar;C:\Program Files\Java\jdk1.8.0_131\jre\lib\ext\dnsns.jar;C:\Program Files\Java\jdk1.8.0_131\jre\lib\ext\jaccess.jar;C:\Program Files\Java\jdk1.8.0_131\jre\lib\ext\jfxrt.jar;C:\Program Files\Java\jdk1.8.0_131\jre\lib\ext\localedata.jar;C:\Program Files\Java\jdk1.8.0_131\jre\lib\ext\nashorn.jar;C:\Program Files\Java\jdk1.8.0_131\jre\lib\ext\sunec.jar;C:\Program Files\Java\jdk1.8.0_131\jre\lib\ext\sunjce_provider.jar;C:\Program Files\Java\jdk1.8.0_131\jre\lib\ext\sunmscapi.jar;C:\Program Files\Java\jdk1.8.0_131\jre\lib\ext\sunpkcs11.jar;C:\Program Files\Java\jdk1.8.0_131\jre\lib\ext\zipfs.jar;C:\Program Files\Java\jdk1.8.0_131\jre\lib\javaws.jar;C:\Program Files\Java\jdk1.8.0_131\jre\lib\jce.jar;C:\Program Files\Java\jdk1.8.0_131\jre\lib\jfr.jar;C:\Program Files\Java\jdk1.8.0_131\jre\lib\jfxswt.jar;C:\Program Files\Java\jdk1.8.0_131\jre\lib\jsse.jar;C:\Program Files\Java\jdk1.8.0_131\jre\lib\management-agent.jar;C:\Program Files\Java\jdk1.8.0_131\jre\lib\plugin.jar;C:\Program Files\Java\jdk1.8.0_131\jre\lib\resources.jar;C:\Program Files\Java\jdk1.8.0_131\jre\lib\rt.jar;D:\IntelliJ IDEA\Projects\Java_Network_Programming\out\production\chapter_05" EncoderTest
This+string+has+spaces
This*string*has*asterisks
This%25string%25has%25percent%25signs
This%2Bstring%2Bhas%2Bpluses
This%2Fstring%2Fhas%2Fslashes
This%22string%22has%22quote%22marks
This%3Astring%3Ahas%3Acolons
This%7Estring%7Ehas%7Etildes
This%28string%29has%28parentheses%29
This.string.has.periods
This%3Dstring%3Dhas%3Dequals%3Dsigns
This%26string%26has%26ampersands
This%C3%A9string%C3%A9has%C3%A9+non-ASCII+characters

Process finished with exit code 0
```















