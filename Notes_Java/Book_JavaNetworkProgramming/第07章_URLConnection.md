## 打开URLConnection

直接使用URLConnection类的程序遵循以下基本步骤（但不绝对）：

1. 构造一个URL对象。
2. 调用这个URL对象的openConnection()获取一个对应该URL的URLConnection对象。
3. 配置这个URLConnection.
4. 读取首部字段。
5. 获得输入流并读取数据。
6. 获得输出流并写入数据。
7. 关闭连接。

## 读取服务器的数据

1. 构造一个URL对象。
2. 调用这个URL对象的openConnection()方法，获取对应URL的URLConnection对象。
3. 调用这个URLConnection的getInputStream()方法。
4. 使用通常的流API读取输入流。

```java
// 用URLConnection下载一个Web页面
import java.io.*;
import java.net.*;

public class SourceViewer {

    public static void main(String[] args) {
        if (args.length > 0) {
            try {
                // 打开URLConnection进行读取
                URL u = new URL(args[0]);
                URLConnection uc = u.openConnection();
                try (InputStream raw = uc.getInputStream()) { 
                    InputStream buffer = new BufferedInputStream(raw);
                    // 将InputStream链到一个Reader
                    Reader reader = new InputStreamReader(buffer);
                    int c;
                    while ((c = reader.read()) != -1) {
                        System.out.print((char) c);
                    }
                }
            } catch (MalformedURLException ex) {
                System.err.println(args[0] + " is not a parseable URL");
            } catch (IOException ex) {
                System.err.println(ex);
            }
        }
    }
}
```

URL类与URLConnection类之间最大的不同在于：

+ URLConnection提供了对HTTP首部的访问。
+ URLConnection可以配置发送给服务器的请求参数。
+ URLConnection除了读取服务器数据外，还可以向服务器写入数据。

## 读取首部

### 获得特定的首部字段

```java
// 用正确的字符集下载一个Web页面
import java.io.*;
import java.net.*;

public class EncodingAwareSourceViewer {

    public static void main(String[] args) {

        for (int i = 0; i < args.length; i++) {
            try {
                // 设置默认编码方式
                String encoding = "ISO-8859-1";
                URL u = new URL(args[i]);
                URLConnection uc = u.openConnection();
                String contentType = uc.getContentType();
                int encodingStart = contentType.indexOf("charset=");
                if (encodingStart != -1) {
                    encoding = contentType.substring(encodingStart + 8);
                }
                InputStream in = new BufferedInputStream(uc.getInputStream());
                Reader r = new InputStreamReader(in, encoding);
                int c;
                while ((c = r.read()) != -1) {
                    System.out.print((char) c);
                }
                r.close();
            } catch (MalformedURLException ex) {
                System.err.println(args[0] + " is not a parseable URL");
            } catch (UnsupportedEncodingException ex) {
                System.err.println(
                        "Server sent an encoding Java does not support: " + ex.getMessage());
            } catch (IOException ex) {
                System.err.println(ex);
            }
        }
    }
} 
```

```java
// 从Web网站下载二进制文件并保存到磁盘
import java.io.*;
import java.net.*;

public class BinarySaver {

    public static void main(String[] args) {
        args = new String[]{"https://www.baidu.com/img/bd_logo.png"};
        for (int i = 0; i < args.length; i++) {
            try {
                URL root = new URL(args[i]);
                saveBinaryFile(root);
            } catch (MalformedURLException ex) {
                System.err.println(args[i] + " is not URL I understand.");
            } catch (IOException ex) {
                System.err.println(ex);
            }
        }
    }

    public static void saveBinaryFile(URL u) throws IOException {
        URLConnection uc = u.openConnection();
        String contentType = uc.getContentType();
        int contentLength = uc.getContentLength();
        if (contentType.startsWith("text/") || contentLength == -1) {
            throw new IOException("This is not a binary file.");
        }

        try (InputStream raw = uc.getInputStream()) {
            InputStream in = new BufferedInputStream(raw);
            byte[] data = new byte[contentLength];
            int offset = 0;
            while (offset < contentLength) {
                int bytesRead = in.read(data, offset, data.length - offset);
                if (bytesRead == -1) break;
                offset += bytesRead;
            }

            if (offset != contentLength) {
                throw new IOException("Only read " + offset
                        + " bytes; Expected " + contentLength + " bytes");
            }
            String name = u.getFile();
            name = name.substring(name.lastIndexOf('/') + 1);
            String filename = "D:\\Temp\\" +name;
            try (FileOutputStream fout = new FileOutputStream(filename)) {
                fout.write(data);
                fout.flush();
            }
        }
    }
}
```

```java
// 返回首部
import java.io.*;
import java.net.*;
import java.util.*;

public class HeaderViewer {

    public static void main(String[] args) {

        args = new String[]{"http://www.baidu.com", "https://github.com" , "https://www.zhihu.com"};

        for (int i = 0; i < args.length; i++) {
            try {
                URL u = new URL(args[i]);
                URLConnection uc = u.openConnection();
                System.out.println("Content-type: " + uc.getContentType());
                if (uc.getContentEncoding() != null) {
                    System.out.println("Content-encoding: "
                            + uc.getContentEncoding());
                }
                if (uc.getDate() != 0) {
                    System.out.println("Date: " + new Date(uc.getDate()));
                }
                if (uc.getLastModified() != 0) {
                    System.out.println("Last modified: "
                            + new Date(uc.getLastModified()));
                }
                if (uc.getExpiration() != 0) {
                    System.out.println("Expiration date: "
                            + new Date(uc.getExpiration()));
                }
                if (uc.getContentLength() != -1) {
                    System.out.println("Content-length: " + uc.getContentLength());
                }
            } catch (MalformedURLException ex) {
                System.err.println(args[i] + " is not a URL I understand");
            } catch (IOException ex) {
                System.err.println(ex);
            }
            System.out.println();
        }
    }
}
```

### 获得任意的首部字段

```java
// 显示整个HTTP首部
import java.io.*;
import java.net.*;

public class AllHeaders {

    public static void main(String[] args) {
        args = new String[]{"http://www.baidu.com", "https://github.com", "https://www.zhihu.com"};
        for (int i = 0; i < args.length; i++) {
            try {
                URL u = new URL(args[i]);
                URLConnection uc = u.openConnection();
                for (int j = 1; ; j++) {
                    String header = uc.getHeaderField(j);
                    if (header == null) break;
                    System.out.println(uc.getHeaderFieldKey(j) + ": " + header);
                }
            } catch (MalformedURLException ex) {
                System.err.println(args[i] + " is not a URL I understand.");
            } catch (IOException ex) {
                System.err.println(ex);
            }
            System.out.println();
        }
    }
}
```

## 缓存

默认情况下，一般认为使用GET通过HTTP访问的页面可以缓存，也应当缓存。使用HTTPS或POST访问的页面通常不应缓存。不过HTTP首部可以对此做出调整：

+ Expires首部（主要针对HTTP 1.0）指示可以缓存这个资源表示，直到指定的时间为止。
+ Cache-control首部（HTTP 1.1）提供了细粒度的缓存策略（Cache-control会覆盖Expires）：
  + max-age=[seconds]：从现在知道缓存项过期前的秒数。
  + s-maxage=[seconds]：从现在起，直到缓存项在共享缓存中过期之前的秒数。私有缓存可以将缓存保存更长时间。
  + public：可以缓存一个经过认证的响应。未认证的响应不能缓存。
  + private：仅单个用户可以保存响应，而共享缓存不应保存。
  + no-cache：缓存项仍然可以缓存，不过客户端每次访问时要用一个Etag或Last-modified首部重新验证响应的状态。
  + no-store：不管怎样都不缓存。
+ Last-modified首部指示资源最后一次修改的日期。客户端可以使用一个HEAD请求来检查这个日期，只有当本地缓存的副本早于Last-modified日期时，它才会真正执行GET来获取资源。
+ Etag首部（HTTP 1.1）是资源改变时这个资源的唯一标识符。客户端可以使用一个HEAD请求来检查这个标识符，只有当本地缓存的副本有一个不同的Etag时，它才会真正请求GET来获取资源。

```java
// 如何检查Cache-control首部
import java.util.Date;
import java.util.Locale;


public class CacheControl {

    private Date maxAge = null;
    private Date sMaxAge = null;
    private boolean mustRevalidate = false;
    private boolean noCache = false;
    private boolean noStore = false;
    private boolean proxyRevalidate = false;
    private boolean publicCache = false;
    private boolean privateCache = false;

    public CacheControl(String s) {
        if (s == null || !s.contains(":")) {
            return; // default policy
        }

        String value = s.split(":")[1].trim();
        String[] components = value.split(",");

        Date now = new Date();
        for (String component : components) {
            try {
                component = component.trim().toLowerCase(Locale.US);
                if (component.startsWith("max-age=")) {
                    int secondsInTheFuture = Integer.parseInt(component.substring(8));
                    maxAge = new Date(now.getTime() + 1000 * secondsInTheFuture);
                } else if (component.startsWith("s-maxage=")) {
                    int secondsInTheFuture = Integer.parseInt(component.substring(8));
                    sMaxAge = new Date(now.getTime() + 1000 * secondsInTheFuture);
                } else if (component.equals("must-revalidate")) {
                    mustRevalidate = true;
                } else if (component.equals("proxy-revalidate")) {
                    proxyRevalidate = true;
                } else if (component.equals("no-cache")) {
                    noCache = true;
                } else if (component.equals("public")) {
                    publicCache = true;
                } else if (component.equals("private")) {
                    privateCache = true;
                }
            } catch (RuntimeException ex) {
                continue;
            }
        }
    }

    public Date getMaxAge() {
        return maxAge;
    }

    public Date getSharedMaxAge() {
        return sMaxAge;
    }

    public boolean mustRevalidate() {
        return mustRevalidate;
    }

    public boolean proxyRevalidate() {
        return proxyRevalidate;
    }

    public boolean noStore() {
        return noStore;
    }

    public boolean noCache() {
        return noCache;
    }

    public boolean publicCache() {
        return publicCache;
    }

    public boolean privateCache() {
        return privateCache;
    }
}
```

## HttpURLConnection

### 处理服务器响应

```java
// 包括响应码和消息的SourceViewer
import java.io.*;
import java.net.*;

public class SourceViewer {

    public static void main(String[] args) {
        args = new String[]{"https://github.com"};
        for (int i = 0; i < args.length; i++) {
            try {
                // 打开URLConnection进行读取
                URL u = new URL(args[i]);
                HttpURLConnection uc = (HttpURLConnection) u.openConnection();
                int code = uc.getResponseCode();
                String response = uc.getResponseMessage();
                System.out.println("HTTP/1.x " + code + " " + response);
                for (int j = 1; ; j++) {
                    String header = uc.getHeaderField(j);
                    String key = uc.getHeaderFieldKey(j);
                    if (header == null || key == null) break;
                    System.out.println(uc.getHeaderFieldKey(j) + ": " + header);
                }
                System.out.println();

                try (InputStream in = new BufferedInputStream(uc.getInputStream())) {
                    // 将InputStream串链到一个Reader
                    Reader r = new InputStreamReader(in);
                    int c;
                    while ((c = r.read()) != -1) {
                        System.out.print((char) c);
                    }
                }
            } catch (MalformedURLException ex) {
                System.err.println(args[0] + " is not a parseable URL");
            } catch (IOException ex) {
                System.err.println(ex);
            }
        }
    }
}
```

```java
// 访问页面遇到错误时
import java.io.*;
import java.net.*;

public class SourceViewer {

    public static void main(String[] args) {
        try {
            URL u = new URL(args[0]);
            HttpURLConnection uc = (HttpURLConnection) u.openConnection();
            try (InputStream raw = uc.getInputStream()) {
                printFromStream(raw);
            } catch (IOException ex) {
                // 获取错误页面的输入流
                printFromStream(uc.getErrorStream());
            }
        } catch (MalformedURLException ex) {
            System.err.println(args[0] + " is not a parseable URL");
        } catch (IOException ex) {
            System.err.println(ex);
        }
    }

    private static void printFromStream(InputStream raw) throws IOException {
        try (InputStream buffer = new BufferedInputStream(raw)) {
            Reader reader = new InputStreamReader(buffer);
            int c;
            while ((c = reader.read()) != -1) {
                System.out.print((char) c);
            }
        }
    }
}
```

