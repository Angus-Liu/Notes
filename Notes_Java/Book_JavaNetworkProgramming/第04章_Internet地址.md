## InetAddress类

java.net.InetAddress类是Java对IP地址（包括IPv4和IPv6）的高层表示。大多数其他网络类都要用到这个类，包括Socket、ServerSocket、URL、DatagramSocket、DatagramPacket等。一般地讲，它包括一个主机名和一个IP地址。

### 创建新的InetAddress对象

```java
// 显示www.oreilly.com地址的程序
public class OReillyByName {

    public static void main(String[] args) {
        try {
            InetAddress address = InetAddress.getByName("www.oreilly.com");
            System.out.println(address);
        } catch (UnknownHostException ex) {
            System.out.println("Could not find www.oreilly.com");
        }
    }
}

// 查找本地机器的地址
public class MyAddress {

    public static void main(String[] args) {
        try {
            InetAddress address = InetAddress.getLocalHost();
            System.out.println(address);
        } catch (UnknownHostException ex) {
            System.out.println("Could not find this computer's address.");
        }
    }
}
```

### 获取方法

InetAddress包含4个获取方法，可以将主机名作为字符串返回，将IP地址作为字符串或字节数组返回：

```java
public String getHostName()
public String getCanonicalHostName() // 与getHostName()方法类似，但其知道主机名也会联系DNS，会覆盖缓存
public byte[] getAddress() // 返回IP地址字节数组，注意因为java没有无符号字节类型，所以小于0的值需要加上256
public String getHostAddress()
```

### 地址类型

有些地址和地址模式有特殊的含义。Java提供了10个方法来测试InteAddress对象那个是否符合其中某个标准：

```java
public boolean isAnyLocalAddress() // 是否为通配地址，IPv4为0.0.0.0，IPv6为0:0:0:0:0:0:0:0（又写作::）
public boolean isLoopbackAddress() // 是否为本地环回地址，IPv4为127.0.0.1，IPv6为0:0:0:0:0:0:0:1（又写作::1）
public boolean isLinkLocalAddress() // 是否是IPv6本地链接地址
public boolean isSiteLocalAddress() // 是否是IPv6本地网站地址
public boolean isMulticastAddress() // 是否是组播地址
public boolean isMCGlobal() // 是否是全球组播地址
public boolean isMCNodeLocal() // 是否是本地接口组播地址
public boolean isMCLinkLocal() // 是否是子网范围组播地址
public boolean isMCSiteLocal() // 是否是网站范围组播地址
public boolean isMCOrgLocal() // 是否是组织范围组播地址
```











