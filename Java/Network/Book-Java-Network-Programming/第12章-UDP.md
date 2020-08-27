## UDP客户端

```java
// 一个daytime协议客户端
import java.io.*;
import java.net.*;

public class DaytimeUDPClient {

    private final static int PORT = 13;
    private static final String HOSTNAME = "time.nist.gov";

    public static void main(String[] args) {
        // 随机选择一个端口监听
        try (DatagramSocket socket = new DatagramSocket(0)) {
            socket.setSoTimeout(10000);
            InetAddress host = InetAddress.getByName(HOSTNAME);
            // 构建一个UDP request包，用于发送到指定到目标主机
            DatagramPacket request = new DatagramPacket(new byte[1], 1, host, PORT);
            // 构建一个UDP response包，用于接收响应
            DatagramPacket response = new DatagramPacket(new byte[1024], 1024);
            // 发送请求
            socket.send(request);
            // 接收响应
            socket.receive(response);
            String result = new String(response.getData(), 0, response.getLength(),
                    "US-ASCII");
            System.out.println(result);
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }
}
```

## UDP服务器

```java
// daytime协议服务器
import java.net.*;
import java.util.Date;
import java.util.logging.*;
import java.io.*;

public class DaytimeUDPServer {

    private final static int PORT = 13;
    private final static Logger audit = Logger.getLogger("requests");
    private final static Logger errors = Logger.getLogger("errors");

    public static void main(String[] args) {
        try (DatagramSocket socket = new DatagramSocket(PORT)) {
            while (true) {
                try {
                    // 构建一个UDP request包，用于接收客户端的请求
                    DatagramPacket request = new DatagramPacket(new byte[1024], 1024);
                    socket.receive(request);

                    String daytime = new Date().toString();
                    byte[] data = daytime.getBytes("US-ASCII");
                    // 构建一个UDP response包，响应客户端的请求
                    DatagramPacket response = new DatagramPacket(data, data.length,
                            request.getAddress(), request.getPort());
                    socket.send(response);
                    audit.info(daytime + " " + request.getAddress());
                } catch (IOException | RuntimeException ex) {
                    errors.log(Level.SEVERE, ex.getMessage(), ex);
                }
            }
        } catch (IOException ex) {
            errors.log(Level.SEVERE, ex.getMessage(), ex);
        }
    }
}
```

