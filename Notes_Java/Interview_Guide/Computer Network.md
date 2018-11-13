# 计算机网络机知识点

### TCP 与 UDP 各自特点

> 《计算机网络》- 第 5 章 运输层

**UDP（User Datagram Protocol，用户数据报协议）：**

+ UDP 是无连接的。
+ UDP 使用尽最大努力交付。
+ UDP 是面向报文的。
+ UDP 没有拥塞控制。
+ UDP 支持一对一、一对多、多对一和多对多的交互通信。
+ UDP 首部开销小，只有 8 个字节，比 TCP 的 20 个字节的首部要短。

**TCP（Transmission Control Protocol，传输控制协议）：**

+ TCP 是面向连接的运输层协议。
+ 每一条 TCP 连接只能有两个端点（endpoint），每一条TCP连接只能是点对点的（一对一）。
+ TCP 提供可靠的交付的服务。
+ TCP 提供全双工通信。
+ 面向字节流。TCP 中的“流”（Stream）指的是流入到进程或从进程流出的字节序列。

