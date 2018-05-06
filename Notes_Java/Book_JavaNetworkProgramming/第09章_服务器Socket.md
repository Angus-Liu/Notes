## 使用ServerSocket

ServerSocket类包含了使用Java编写服务器所需的全部内容。其中包括创建ServerSocket对象的构造函数、在指定端口监听连接的方法、配置各个服务器的Socket选项的方法，以及其他一些常见的方法。

在Java中，服务器程序的基本生命周期如下：

1. A new ServerSocket is created on a particular port using a ServerSocket() constructor.

   使用一个ServerSocket()构造函数在一个特定端口个创建一个新的ServerSocket。

2. The ServerSocket listens for incoming connection attempts on that port using its accept() method. accept() blocks until a client attempts to make a connection, at which point accept() returns a Socket object connecting the client and the server.

   ServerSocket使用其accept()方法监听这个端口的入站连接。accept()会一直阻塞，直到一个客户端尝试连接，此时accept()将返回一个连接客户端和服务器的Socket对象。

3. Depending on the type of server, either the Socket’s getInputStream() method, getOutputStream() method, or both are called to get input and output streams that communicate with the client.

   根据服务器的类型，会调用Socket的getInputStream()方法或getOutputStream()方法，或是这两个方法都调用，以获得与客户端通信的输入和输出流。

4. The server and the client interact according to an agreed-upon protocol until it is time to close the connection.

   服务器和客户端根据已协商的协议交互，直到要关闭连接。

5. The server, the client, or both close the connection.

   服务端，客户端或二者关闭连接

6. The server returns to step 2 and waits for the next connection.    

   服务器返回步骤2，等待下一次连接。

```java
// 模拟的Daytime服务器
import java.net.*;
import java.io.*;
import java.util.Date;

public class DaytimeServer {

    public final static int PORT = 13;

    public static void main(String[] args) {
        try (ServerSocket server = new ServerSocket(PORT)) {
            while (true) {
                try (Socket connection = server.accept()) {
                    Writer out = new OutputStreamWriter(connection.getOutputStream());
                    Date now = new Date();
                    out.write(now.toString() + "\r\n");
                    out.flush();
                    connection.close();
                } catch (IOException ex) {
                }
            }
        } catch (IOException ex) {
            System.err.println(ex);
        }
    }
} 

// 请求获取daytime的客户端
import java.net.*;
import java.io.*;

public class DaytimeClient {

    public static void main(String[] args) {

        String hostname = args.length > 0 ? args[0] : "localhost";
        Socket socket = null;
        try {
            socket = new Socket(hostname, 13);
            socket.setSoTimeout(15000);
            InputStream in = socket.getInputStream();
            StringBuilder time = new StringBuilder();
            InputStreamReader reader = new InputStreamReader(in, "ASCII");
            for (int c = reader.read(); c != -1; c = reader.read()) {
                time.append((char) c);
            }
            System.out.println(time);
        } catch (IOException ex) {
            System.err.println(ex);
        } finally {
            if (socket != null) {
                try {
                    socket.close();
                } catch (IOException ex) {
                    // ignore
                }
            }
        }
    }
}
```

### 多线程服务器

```java
// 多线程daytime服务器
import java.net.*;
import java.io.*;
import java.util.Date;

public class MultithreadedDaytimeServer {

    public final static int PORT = 13;

    public static void main(String[] args) {
        try (ServerSocket server = new ServerSocket(PORT)) {
            while (true) {
                try {
                    Socket connection = server.accept();
                    Thread task = new DaytimeThread(connection);
                    task.start();
                } catch (IOException ex) {
                }
            }
        } catch (IOException ex) {
            System.err.println("Couldn't start server");
        }
    }

    private static class DaytimeThread extends Thread {

        private Socket connection;

        DaytimeThread(Socket connection) {
            this.connection = connection;
        }

        @Override
        public void run() {
            try {
                Writer out = new OutputStreamWriter(connection.getOutputStream());
                Date now = new Date();
                out.write(now.toString() + "\r\n");
                out.flush();
            } catch (IOException ex) {
                System.err.println(ex);
            } finally {
                try {
                    connection.close();
                } catch (IOException e) {
                    // ignore;
                }
            }
        }
    }
}

// 使用线程池的daytime服务器
import java.io.*;
import java.net.*;
import java.util.*;
import java.util.concurrent.*;

public class PooledDaytimeServer {

    public final static int PORT = 13;

    public static void main(String[] args) {

        ExecutorService pool = Executors.newFixedThreadPool(50);

        try (ServerSocket server = new ServerSocket(PORT)) {
            while (true) {
                try {
                    Socket connection = server.accept();
                    Callable<Void> task = new DaytimeTask(connection);
                    pool.submit(task);
                } catch (IOException ex) {
                }
            }
        } catch (IOException ex) {
            System.err.println("Couldn't start server");
        }
    }

    private static class DaytimeTask implements Callable<Void> {

        private Socket connection;

        DaytimeTask(Socket connection) {
            this.connection = connection;
        }

        @Override
        public Void call() {
            try {
                Writer out = new OutputStreamWriter(connection.getOutputStream());
                Date now = new Date();
                out.write(now.toString() + "\r\n");
                out.flush();
            } catch (IOException ex) {
                System.err.println(ex);
            } finally {
                try {
                    connection.close();
                } catch (IOException e) {
                    // ignore;
                }
            }
            return null;
        }
    }
}
```

### 用Socket写入服务器

```java
// echo服务器
import java.nio.*;
import java.nio.channels.*;
import java.net.*;
import java.util.*;
import java.io.IOException;

public class EchoServer {

    public static int DEFAULT_PORT = 7;

    public static void main(String[] args) {

        int port;
        try {
            port = Integer.parseInt(args[0]);
        } catch (RuntimeException ex) {
            port = DEFAULT_PORT;
        }
        System.out.println("Listening for connections on port " + port);

        ServerSocketChannel serverChannel;
        Selector selector;
        try {
            serverChannel = ServerSocketChannel.open();
            ServerSocket ss = serverChannel.socket();
            InetSocketAddress address = new InetSocketAddress(port);
            ss.bind(address);
            serverChannel.configureBlocking(false);
            selector = Selector.open();
            serverChannel.register(selector, SelectionKey.OP_ACCEPT);
        } catch (IOException ex) {
            ex.printStackTrace();
            return;
        }

        while (true) {
            try {
                selector.select();
            } catch (IOException ex) {
                ex.printStackTrace();
                break;
            }

            Set<SelectionKey> readyKeys = selector.selectedKeys();
            Iterator<SelectionKey> iterator = readyKeys.iterator();
            while (iterator.hasNext()) {
                SelectionKey key = iterator.next();
                iterator.remove();
                try {
                    if (key.isAcceptable()) {
                        ServerSocketChannel server = (ServerSocketChannel) key.channel();
                        SocketChannel client = server.accept();
                        System.out.println("Accepted connection from " + client);
                        client.configureBlocking(false);
                        SelectionKey clientKey = client.register(
                                selector, SelectionKey.OP_WRITE | SelectionKey.OP_READ);
                        ByteBuffer buffer = ByteBuffer.allocate(100);
                        clientKey.attach(buffer);
                    }
                    if (key.isReadable()) {
                        SocketChannel client = (SocketChannel) key.channel();
                        ByteBuffer output = (ByteBuffer) key.attachment();
                        client.read(output);
                    }
                    if (key.isWritable()) {
                        SocketChannel client = (SocketChannel) key.channel();
                        ByteBuffer output = (ByteBuffer) key.attachment();
                        output.flip();
                        client.write(output);
                        output.compact();
                    }
                } catch (IOException ex) {
                    key.cancel();
                    try {
                        key.channel().close();
                    } catch (IOException cex) {
                    }
                }
            }
        }
    }
}
```

