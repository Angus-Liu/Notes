## 创建安全客户端Socket

```java
// 连接一个安全的HTTP服务器
import java.io.*;
import javax.net.ssl.*;

public class HTTPSClient {

    public static void main(String[] args) throws IOException {

        args = new String[]{"www.baidu.com"};

        if (args.length == 0) {
            System.out.println("Usage: java HTTPSClient2 host");
            return;
        }

        int port = 443; // 默认https端口
        String host = args[0];

        SSLSocketFactory factory
                = (SSLSocketFactory) SSLSocketFactory.getDefault();
        SSLSocket socket = null;
        try {
            socket = (SSLSocket) factory.createSocket(host, port);

            // 启用所有密码组
            String[] supported = socket.getSupportedCipherSuites();
            socket.setEnabledCipherSuites(supported);

            Writer out = new OutputStreamWriter(socket.getOutputStream(), "UTF-8");
            // https在GET行中需要完全URL
            out.write("GET http://" + host + "/ HTTP/1.1\r\n");
            out.write("Host: " + host + "\r\n");
            out.write("\r\n");
            out.flush();

            // 读取响应
            BufferedReader in = new BufferedReader(
                    new InputStreamReader(socket.getInputStream()));

            // 读取首部
            String s;
            while (!(s = in.readLine()).equals("")) {
                System.out.println(s);
            }
            System.out.println();

            // 读取长度
            String contentLength = in.readLine();
            int length = Integer.MAX_VALUE;
            try {
                length = Integer.parseInt(contentLength.trim(), 16);
            } catch (NumberFormatException ex) {
                // 这个异常表明服务器在响应体的第一行没有发送content-length
            }
            System.out.println(contentLength);

            int c;
            int i = 0;
            while ((c = in.read()) != -1 && i++ < length) {
                System.out.write(c);
            }

            System.out.println();
        } finally {
            try {
                if (socket != null) socket.close();
            } catch (IOException ignored) {
            }
        }
    }
}
```

