# 数据结构相关知识点

### Bloom Filter

> [海量数据处理算法—Bloom Filter](https://www.cnblogs.com/zhxshseu/p/5289871.html)

Bloom-Filter，即布隆过滤器，1970年由Bloom中提出。它可以用于检索一个元素是否在一个集合中。

Bloom Filter（BF）是一种空间效率很高的**随机数据结构**，它利用位数组很简洁地表示一个集合，并能判断一个元素是否属于这个集合。它是一个判断元素是否存在集合的快速的概率算法。Bloom Filter有**可能会出现错误判断**，但不会漏掉判断。也就是Bloom Filter判断元素不再集合，那肯定不在。如果判断元素存在集合中，有一定的概率判断错误。因此，Bloom Filter”不适合那些“**零错误**的应用场合。而在能容忍低错误率的应用场合下，Bloom Filter比其他常见的算法（如hash，折半查找）极大**节省了空间。** 

它的优点是空间效率和查询时间都远远超过一般的算法，缺点是有一定的误识别率和删除困难。

Bloom Filter的详细介绍：[Bloom Filter](http://en.wikipedia.org/wiki/Bloom_filter)