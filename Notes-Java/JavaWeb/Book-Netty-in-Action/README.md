# Netty In Action

> 记录学习**Netty**的历程，方便以后查阅，参考自书籍[《Netty In Action》](https://book.douban.com/subject/27038538/)。
>
> 下载链接：<http://readfree.me/book/27038538/> 

![img](assets/s28361212.jpg) 

## 目录

- [x] 第01章 Netty——异步和事件驱动
- [x] 第02章 你的第一款Netty应用程序
- [x] 第03章 Netty的组件和设计
- [x] 第04章 传输
- [x] 第05章 ByteBuf
- [x] 第06章 ChannelHandler和ChannelPipeLine
- [x] 第07章 EventLoop和线程模型
- [x] 第08章 引导
- [x] 第09章 单元测试
- [x] 第10章 编解码器框架
- [x] 第11章 预置的ChannelHandler和编解码器
- [x] 第12章 WebSocket
- [x] 第13章 使用UDP广播事件
- [x] 第14章 案例研究，第一部分
  - [x] 14.1 Dropplr——构建移动服务
  - [x] 14.2 Firebase——实时数据同步服务
  - [x] 14.3 Urban Airship——构建移动服务
  - [x] 14.4 总结
- [x] 第15章 案例研究，第二部分
  - [x] 15.1 Netty在Facebook的使用：Nifty和Swift
  - [x] 15.2 Netty在Twitter的使用：Finagle
  - [x] 15.3 小结
- [x] 附录 Maven介绍

## 读后感

很棒的一本书，读完后对于 Netty 有了大致的了解。书主要介绍了 Netty 的架构与设计思路，但没有解释原理和实现方法，也没有太多实战内容。可能本就是面向入门人员吧，所以对读者要求也不高，不过还是需要补充并发和网络方面的知识。读第一遍还只是浅浅了解，目的主要是为了实现毕设中基于 WebSocket 的即时通讯功能（随书附带的 WebSocket 例子有些小 bug），对于案例研究部分目前还没有很深的体会。Netty 框架整体上给人以一种简洁优雅，又不失扩展和功能性的印象，值得深入研究。