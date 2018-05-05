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