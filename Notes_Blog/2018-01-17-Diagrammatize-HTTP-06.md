---
title: 《图解HTTP》读书笔记
subtitle: 第06章 HTTP首部
author: Angus Liu
cdn: header-off
header-img: https://i.loli.net/2018/01/17/5a5eb14914240.jpg
date: 2018-01-17 10:08:48
tags:
      - 《图解HTTP》
      - 读书笔记
      - HTTP
---
> To take a step you can't take back.
> 迈出这永无法回头的一步。
> <p align="right"> —— Keira Knightley 《A Step You Can’t Take Back》 </p>

## 6.1 HTTP报文首部
![0e78a81b-bd38-4b33-8637-37100e4987db](https://i.loli.net/2018/01/17/5a5eb5484f1ef.jpg)
(1) HTTP协议的请求和响应报文中必定包含HTTP首部。首部内容为客户端和服务器分别处理请求和响应所提供需要的信息。
(2) HTTP请求报文
 ① 在请求中，HTTP报文由方法、URI、HTTP版本、HTTP首部字段等部分构成。
![411761eb-2fc2-4995-9a7b-b6d6a66e0e36](https://i.loli.net/2018/01/17/5a5eb5b6c7f05.jpg)
 ② 下面是访问http://hackr.jp 时， 请求报文的首部信息。
> GET / HTTP/1.1
Host: hackr.jp
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20100101 Firefox/13.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*; q=0.8
Accept-Language: ja,en-us;q=0.7,en;q=0.3
Accept-Encoding: gzip, deflate
DNT: 1
Connection: keep-alive
If-Modified-Since: Fri, 31 Aug 2007 02:02:20 GMT
If-None-Match: "45bae1-16a-46d776ac"
Cache-Control: max-age=0

(3) HTTP响应报文
 ① 在响应中，HTTP报文由HTTP版本、状态码（数字和原因短语）、HTTP首部字段3部分构成。
![c689241c-6da6-4a82-94bb-4d9960fdae07](https://i.loli.net/2018/01/17/5a5eb629cc05c.jpg)
 ② 下面是之前请求访问 http://hackr.jp/ 时， 返回的响应报文的首部信息。
> HTTP/1.1 304 Not Modified
Date: Thu, 07 Jun 2012 07:21:36 GMT
Server: Apache
Connection: close
Etag: "45bae1-16a-46d776ac"

(4) 在报文众多的字段当中，HTTP首部字段包含的信息最为丰富。首部字段同时存在于请求和响应报文内，并涵盖HTTP报文相关的内容信息。

## 6.2 HTTP首部字段
### 6.2.1 HTTP首部字段传递重要信息
(1) HTTP首部字段是构成HTTP报文的要素之一。在客户端与服务器之间以HTTP协议进行通信的过程中，无论是请求还是响应都会使用首部字段，它能起到传递额外重要信息的作用。
(2) 使用首部字段是为了给浏览器和服务器提供报文主体大小、所使用的语言、认证信息等内容。

### 6.2.2 HTTP首部字段结构
(1) HTTP首部字段是由首部字段名和字段值构成的，中间用冒号“:”分隔。
> 首部字段名: 字段值

(2) 字段值对应单个HTTP首部字段可以有多个值。
>Keep-Alive: timeout=15, max=100

### 6.2.3 4种HTTP首部字段类型
HTTP首部字段根据实际用途被分为以下4种类型。
(1) 通用首部字段（General Header Fields）：请求报文和新响应报文都会使用的首部。
(2) 请求首部字段（Request Header Fields）：从客户端向服务器发送请求报文时使用的首部。补充了请求的附加内容、客户端信息、响应内容相关优先级等信息。
(3) 响应首部字段（Response Header Fields）：从服务器向客户端返回响应报文时使用的首部。补充了响应的附加内容，也会要求客户端附加额外的内容信息。
(4) 实体首部字段（Entity Header Fields）：针对请求报文的和响应报文的实体部分使用的首部。补充了资源内容更新时间等与实体有关的信息。

## 6.2.4 HTTP/1.1首部字段一览
HTTP/1.1规范定义了如下47种首部字段
(1) 通用首部字段

| 首部字段名        | 说明                       |
|:------------------|:---------------------------|
| Connection        | 逐跳首部、连接的管理       |
| Date              | 创建报文的日期时间         |
| Pragma            | 报文指令                   |
| Trailer           | 报文末端的首部一览         |
| Transfer-Encoding | 指定报文主体的传输编码格式 |
| Upgrade           | 升级为其他协议             |
| Via               | 代理服务器的相关信息       |
| Warning           | 错误通知                   |

(2) 请求首部字段

| 首部字段名          | 说明                                          |
|:--------------------|:----------------------------------------------|
| Accept              | 用户代理可处理的媒体类型                      |
| Accept-Charset      | 优先的字符集                                  |
| Accept-Encoding     | 优先的内容编码                                |
| Accept-Language     | 优先的语言（自然语言）                        |
| Authorization       | Web认证信息                                   |
| Expect              | 期待服务器的特定行为                          |
| From                | 用户的电子邮箱地址                            |
| Host                | 请求资源所在服务器                            |
| If-Match            | 比较实体标记（ETag）                          |
| If-Modified-Since   | 比较资源的更新时间                            |
| If-None-Match       | 比较实体标记（与ETag相反）                    |
| If-Unmodified-Since | 比较资源的更新时间（与If-Modified-Since相反） |
| Max-Forwards        | 最大传输逐跳数                                |
| Proxy-Authorization | 代理服务器要求客户端的认证信息                |
| Range               | 实体的字节范围请求                            |
| Referer             | 对请求中URI的原始获取方                       |
| TE                  | 传输编码的优先级                              |
| User-Agent          | HTTP客户端程序的信息                          |

(3) 响应首部字段

| 首部字段名         | 说明                         |
|:-------------------|:-----------------------------|
| Accept-Ranges      | 是否接受字节范围请求         |
| Age                | 推算资源创建经过时间         |
| ETag               | 资源的匹配信息               |
| Location           | 令客户端重定向至指定URI      |
| Proxy-Authenticate | 代理服务器对客服端的认证信息 |
| Retry-After        | 对再次发起请求的实际要求     |
| Server             | HTTP服务器的安装信息         |
| Vary               | 代理服务器缓存的管理信息     |
| WWW-Authenticate   | 服务器对客户端的认证信息     |

(4) 实体首部字段

| 首部字段名       | 说明                   |
|:-----------------|:-----------------------|
| Allow            | 资源可支持的HTTP方法   |
| Content-Encoding | 实体主体适用的编码方式 |
| Content-Language | 实体主体的自然语言     |
| Content-Length   | 实体主体的大小（字节） |
| Content-Location | 替代对应资源的URI      |
| Content-MD5      | 实体主体的报文摘要     |
| Content-Range    | 实体主体的位置范围     |
| Content-Type     | 实体主体的媒体类型     |
| Expires          | 实体主体过期的日期时间 |
| Last-Modified    | 资源的最后修改日期时间 |

### 6.2.5 非HTTP/1.1首部字段
在HTTP协议通信交互中，还有Cookie、Set-Cookie和Content-Disposition等不限于RFC2616中定义的，使用频率很高的首部字段。

### 6.2.6 End-to-end首部和Hop-by-hop首部
HTTP首部字段将定义成缓存代理和非缓存代理的行为，分成2种类型。
(1) 端到端首部（End-to-end Header）
该类别首部会转发给请求/响应的最终接收目标，且必须保存在由缓存生成的响应中，必须转发。
(2) 逐跳首部（Hop-to-hop）
该类别首部只对单次转发有效，会因通过缓存或代理而不再转发。HTTP/1.1和之后的版本汇总，如果使用hop-by-hop首部，需提供Connection首部字段。属于逐跳首部的只有8个：Connection、Keep-Alive、Proxy-Authenticate、Proxy-Authorization、Trailer、TE、Transfer-Encoding、Upgrade。

## 6.3 HTTP/1.1通用首部字段
### 6.3.1 Cache-Control
通过指定首部字段Cache-Control的指令，就能操作缓存的工作机制。
> Cache-Control: private, max-age=0, no-cache

Cache-Control指令一览
(1) 缓存请求指令

| 指令               | 参数   | 说明                         |
|:-------------------|:-------|:-----------------------------|
| no-cache           | 无     | 强制向源服务器再次验证       |
| no-store           | 无     | 不缓存请求或响应的任何内容   |
| max-age=[秒]       | 必需   | 响应的最大Age值              |
| max-stale（=[秒]） | 可省略 | 接收已过期的响应             |
| min-fresh=（秒）   | 必需   | 期望在指定时间内的响应仍有效 |
| no-transform       | 无     | 代理不可更改媒体类型         |
| only-if-cached     | 无     | 从缓存获取资源               |
| cached-extension   | -      | 新指令标记（token）          |

(2) 缓存响应指令

| 指令             | 参数   | 说明                                           |
|:-----------------|:-------|:-----------------------------------------------|
| public           | 无     | 可向任意方向提供响应的缓存                     |
| private          | 可省略 | 仅向特定用户返回响应                           |
| no-cache         | 可省略 | 缓存前必需先确认其有效性                       |
| no-store         | 无     | 不缓存请求或响应的任何内容                     |
| no-transform     | 无     | 代理不可更改类型                               |
| must-revalidate  | 无     | 可缓存但必须向源服务器进行确认                 |
| proxy-revalidate | 无     | 要求中间缓存服务器对缓存的响应有效性再进行确认 |
| max-age=[秒]     | 必需   | 响应的最大Age值                                |
| s-maxage=[秒]    | 必需   | 公共服务器响应的最大Age值                      |
| cache-extension  | -      | 新指令标记（token）                            |


### 6.3.2 Connection
Connection首部字段具备如下两个作用。
(1) 控制不再转发给代理的首部字段
> Connection: 不再转发的首部字段名

在客户端发送请求和服务器返回响应内，使用 Connection 首部字段，可控制不再转发给代理的首部字段（ 即 Hop-by-hop 首部）。
(2) 管理首部连接
> Connection: close

HTTP/1.1 版本的默认连接都是持久连接。 为此，客户端会在持久连接上连续发送请求。当服务器端想明确断开连接时， 则指定Connection 首部字段的值为 Close。
> Connection: Keep-Alive

HTTP/1.1 之前的 HTTP 版本的默认连接都是非持久连接。为此，如果想在旧版本的 HTTP 协议上维持持续连接，则需要指定Connection首部字段的值为 Keep-Alive。

### 6.3.3 Date
> Date: Tue, 03 Jul 2012 04:40:59 GMT

首部字段Date表明创建HTTP报文的日期和时间。

### 6.3.4 Pragma
Pragma 是 HTTP/1.1 之前版本的历史遗留字段，仅作为与 HTTP/1.0的向后兼容而定义。规范定义的形式唯一，如下所示。
> Pragma: no-cache

该首部字段属于通用首部字段，但只用在客户端发送的请求中。客户端会要求所有的中间服务器不返回缓存的资源。但一般会同时含有下面两个首部字段，以适配不同的HTTP版本。
> Cache-Control: no-cache
Pragma: no-cache

### 6.3.5 Trailer
首部字段Trailer（预告，报文末端首部一览）会事先说明在报文主体后记录了哪些首部字段。该首部字段可应用在HTTP/1.1版本的分块传输编码时。
> HTTP/1.1 200 OK
Date: Tue, 03 Jul 2012 04:40:56 GMT
Content-Type: text/html
...
Transfer-Encoding: chunked
Trailer: Expires
...(报文主体)...
0
Expires: Tue, 28 Sep 2004 23:59:59 GMT

以上用例中，指定首部字段 Trailer 的值为 Expires，在报文主体之后（分块长度 0 之后）出现了首部字段 Expires。

### 6.3.6 Transfer-Encoding
首部字段Transfer-Encoding规定了传输报文主体时采用的编码方式。HTTP/1.1的传输编码仅对分块传输编码有效。
> HTTP/1.1 200 OK
Date: Tue, 03 Jul 2012 04:40:56 GMT
Cache-Control: public, max-age=604800
Content-Type: text/javascript; charset=utf-8
Expires: Tue, 10 Jul 2012 04:40:56 GMT
X-Frame-Options: DENY
X-XSS-Protection: 1; mode=block
Content-Encoding: gzip
Transfer-Encoding: chunked
Connection: keep-alive
cf0    ←16进制(10进制为3312)
...3312字节分块数据...
392    ←16进制(10进制为914)
...914字节分块数据...
0

以上用例中，正如在首部字段 Transfer-Encoding 中指定的那样，有效使用分块传输编码，且分别被分成3312字节和914字节大小的分块数据。

### 6.3.7 Upgrade
首部字段Upgrade用于检测HTTP协议及其他协议是否使用更高的版本进行通信，其参数值可以用来指定一个完全不同的通信协议。
![18dbee76-c3a3-4e01-9ed3-45d38da6889d](https://i.loli.net/2018/01/17/5a5ebd98f2905.jpg)
上图用例中，首部字段 Upgrade 指定的值为 TLS/1.0。请注意此处两个字段首部字段的对应关系，Connection 的值被指定为 Upgrade。Upgrade 首部字段产生作用的 Upgrade 对象仅限于客户端和邻接服务器之间。 因此， 使用首部字段 Upgrade 时， 还需要额外指定Connection:Upgrade。对于附有首部字段 Upgrade 的请求， 服务器可用 101 Switching Protocols 状态码作为响应返回。

### 6.3.8 Via
使用首部字段Via是为了追踪客户端与服务器之间的请求和响应报文的传输路径。报文经过代理或网关时，会先在首部字段Via中附加该服务器的信息，然后再进行转发。首部字段Via不仅用于追踪报文的转发，还可避免请求回环的发生，故必须添加。
![5009a9a2-382b-420b-9caa-f38fdfa8d5dc](https://i.loli.net/2018/01/17/5a5ebded8a28e.jpg)

### 6.3.9 Warning
(1) HTTP/1.1 的 Warning 首部是从 HTTP/1.0 的响应首部（ Retry-After） 演变过来的。 该首部通常会告知用户一些与缓存相关的问题的警告。
(2) Warning 首部的格式如下。 最后的日期时间部分可省略。 
> Warning: [警告码][警告的主机:端口号]“[警告内容]”([日期时间])
Warning: 113 gw.hackr.jp:8080 "Heuristic expiration" Tue, 03 Jul 2012 05:09:44 GMT

(3) HTTP/1.1 中定义了 7 种警告。 警告码对应的警告内容仅推荐参考。另外， 警告码具备扩展性， 今后有可能追加新的警告码。 

| 警告码 | 警告内容                                           | 说明                                                             |
|:------:|:---------------------------------------------------|:-----------------------------------------------------------------|
|  110   | Response is stale（响应已过期）                    | 代理返回已过期的资源                                             |
|  111   | Revalidation failed（再验证失败）                  | 代理再验证资源有效性时失败（服务器无法达到的原因）               |
|  112   | Disconnection operation（断开连接操作）            | 代理与互联网的连接被故意切断                                     |
|  113   | Heuristic expiration（试探性过期）                 | 响应的使用周期超过24小时（有效缓存的设定时间大于24小时的情况下） |
|  199   | Miscellaneous warning（杂项警告）                  | 任意的警告内容                                                   |
|  214   | Transformation applied（使用了转换）               | 代理对内容编码或媒体类型等执行了某些处理时                       |
|  299   | Miscellaneous persistent warning（持久正杂项警告） | 任意的警告内容                                                   |

## 6.4 请求首部字段
### 6.4.1 Accept
> Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8

(1) Accept首部字段可通知服务器，用户代理能够处理的媒体类型及媒体类型的相对优先级。可使用type/subtype这种形式。可一次性指定多种媒体类型。
(2) 若想要给显示的媒体类型（下同）增加优先级， 则使用 q= 来额外表示权重值， 用分号（ ;） 进行分隔。 权重值 q 的范围是 0~1（ 可精确到小数点后 3 位） ， 且 1 为最大值。 不指定权重 q 值时， 默认权重为 q=1.0。

### 6.4.2 Accept-Charset
> Accept-Charset: iso-8859-5, unicode-1-1;q=0.8

Accept-Charset首部字段可用来通知服务器，用户代理支持的字符集及字符集的相对优先级顺序。可一次性指定多种字符集。

### 6.4.3 Accept-Encoding
> Accept-Encoding: gzip, deflate

(1) Accepet-Encoding首部字段用来告知服务器，用户代理支持的内容编码集内容编码的优先级顺序。可一次指定多种编码。
(2) 下面试举出几个内容编码的例子。
 ① gzip
 由文件压缩程序 gzip（GNU zip）生成的编码格式（RFC1952），采用 Lempel-Ziv 算法（LZ77）及 32 位循环冗余校验（Cyclic Redundancy Check，通称 CRC）。
 ② compress
 由 UNIX 文件压缩程序 compress 生成的编码格式，采用 Lempel-Ziv-Welch 算法（LZW）。
 ③ deflate
 组合使用 zlib 格式（RFC1950）及由 deflate 压缩算法（RFC1951）生成的编码格式。
 ④ identity
 不执行压缩或不会变化的默认编码格式

### 6.4.4 Accept-Language
> Accept-Language: zh-cn,zh;q=0.7,en-us,en;q=0.3

首部字段Accept-Language用来告知服务器用户代理能够处理的自然语言集（中英文等），以及自然语言集的相对优先级。可一次指定多种自然语言集。

### 6.4.5 Authorization
> Authorization: Basic dWVub3NlbjpwYXNzd29yZA==

首部字段Authorization是用来告知服务器，用户代理的认证信息（证书值）。通常，想要通过服务器认证的用户代理会在接收到返回的401状态码（401 Unauthorized）响应后，把首部字段Authorization加入。

### 6.4.6 Expect
> Expect: 100-continue

(1) 客户端使用首部字段Expect来告知服务器，期望出现的某种特定行为。若服务器无法理解，会返回417 Exception Failed。
(2) 客户端可以利用该字段，写明所期望的扩展。但HTTP/1.1规范只定义了100-continue。

### 6.4.7 Form
首部字段Form用来告知服务器使用用户代理的用户的电子邮件地址。通常，其使用目的是为了显示搜索引擎等用户代理的负责人的电子邮件联系方式。

### 6.4.8 Host
![52090206-0cf5-4c18-96fe-30b1b2e9c89c](https://i.loli.net/2018/01/17/5a5ebe8b10851.jpg)
图： 虚拟主机运行在同一个 IP 上， 因此使用首部字段 Host 加以区分
> Host: www.hackr.jp

首部字段Host会告知服务器，请求的资源所在的互联网主机名和端口号。Host 首部字段在 HTTP/1.1 规范内是唯一一个必须被包含在请求内的首部字段。

### 6.4.9 If-Match
(1) 形如 If-xxx 这种样式的请求首部字段， 都可称为条件请求。 服务器接收到附带条件的请求后， 只有判断指定条件为真时， 才会执行请求。
> If-Match: "123456"

(2) 首部字段 If-Match， 属附带条件之一， 它会告知服务器匹配资源所用的实体标记（ ETag） 值。 这时的服务器无法使用弱 ETag 值。服务器会比对 If-Match 的字段值和资源的 ETag 值， 仅当两者一致时， 才会执行请求。 反之， 则返回状态码 412 Precondition Failed 的响应。还可以使用星号（ *） 指定 If-Match 的字段值。 针对这种情况， 服务器将会忽略 ETag 的值， 只要资源存在就处理请求。

### 6.4.10 If-Modified-Since
> If-Modified-Since: Thu, 15 Apr 2004 00:00:00 GMT

(1) 首部字段 If-Modified-Since， 属附带条件之一， 它会告知服务器若 If-Modified-Since 字段值早于资源的更新时间， 则希望能处理该请求。而在指定 If-Modified-Since 字段值的日期时间之后， 如果请求的资源都没有过更新， 则返回状态码 304 Not Modified 的响应。
(2) If-Modified-Since 用于确认代理或客户端拥有的本地资源的有效性。获取资源的更新日期时间， 可通过确认首部字段 Last-Modified 来确定。

### 6.4.11 If-None-Match
(1) 首部字段 If-None-Match 属于附带条件之一。 它和首部字段 If-Match作用相反。 用于指定 If-None-Match 字段值的实体标记（ ETag） 值与请求资源的 ETag 不一致时， 它就告知服务器处理该请求。
(2) 在 GET 或 HEAD 方法中使用首部字段 If-None-Match 可获取最新的资源。 因此， 这与使用首部字段 If-Modified-Since 时有些类似。

### 6.4.12 If-Range
首部字段 If-Range 属于附带条件之一。 它告知服务器若指定的 If-Range 字段值（ ETag 值或者时间） 和请求资源的 ETag 值或时间相一致时， 则作为范围请求处理。 反之， 则返回全体资源。
### 6.4.13 If-Unmodified-Since
> If-Unmodified-Since: Thu, 03 Jul 2012 00:00:00 GMT

首部字段 If-Unmodified-Since 和首部字段 If-Modified-Since 的作用相反。 它的作用的是告知服务器， 指定的请求资源只有在字段值内指定的日期时间之后， 未发生更新的情况下， 才能处理请求。 如果在指定日期时间后发生了更新， 则以状态码 412 Precondition Failed 作为响应返回。

### 6.4.14 Max-Forwards
![Uploading be274cc7-f05f-47a2-a975-b5e1a293fb1d](https://i.loli.net/2018/01/17/5a5ec27649322.jpg)
(1) 通过 TRACE 方法或 OPTIONS 方法， 发送包含首部字段 MaxForwards 的请求时， 该字段以十进制整数形式指定可经过的服务器最大数目。 服务器在往下一个服务器转发请求之前， Max-Forwards 的值减 1 后重新赋值。 当服务器接收到 Max-Forwards 值为 0 的请求时， 则不再进行转发， 而是直接返回响应。
![f4e7576d-4b45-48f1-80af-8bb9e22dd3e0](https://i.loli.net/2018/01/17/5a5ebf2b8398b.jpg)
(2) 使用 HTTP 协议通信时， 请求可能会经过代理等多台服务器。 途中，如果代理服务器由于某些原因导致请求转发失败， 客户端也就等不到服务器返回的响应了。 对此， 我们无从可知。可以灵活使用首部字段 Max-Forwards， 针对以上问题产生的原因展开调查。 由于当 Max-Forwards 字段值为 0 时， 服务器就会立即返回响应， 由此我们至少可以对以那台服务器为终点的传输路径的通信状况有所把握。

### 6.4.15 Proxy-Authorization
> Proxy-Authorization: Basic dGlwOjkpNLAGfFY5

接收到从代理服务器发来的认证质询时，客户端会发送包含首部字段Proxy-Authorization的请求，以告知服务器认证所需要的信息。

### 6.4.16 Range
> Range: bytes=5001-10000

(1) 对于只需获取部分资源的范围请求， 包含首部字段 Range 即可告知服务器资源的指定范围。 上面的示例表示请求获取从第 5001 字节至第10000 字节的资源。
(2) 接收到附带 Range 首部字段请求的服务器， 会在处理请求之后返回状态码为 206 Partial Content 的响应。 无法处理该范围请求时， 则会返回状态码 200 OK 的响应及全部资源。

6.4.17 Referer
> Referer: http://www.hackr.jp/index.htm

首部字段Referer会告知服务器请求的原始资源的URI。客户端一般都会发送 Referer 首部字段给服务器。 但当直接在浏览器的地址栏输入 URI， 或出于安全性的考虑时， 也可以不发送该首部字段。因为原始资源的 URI 中的查询字符串可能含有 ID 和密码等保密信息， 要是写进 Referer 转发给其他服务器， 则有可能导致保密信息的泄露。

### 6.4.18 TE
> TE: gzip, deflate;q=0.5

(1) 首部字段 TE 会告知服务器客户端能够处理响应的传输编码方式及相对优先级。 它和首部字段 Accept-Encoding 的功能很相像， 但是用于传输编码。
(2) 首部字段 TE 除指定传输编码之外， 还可以指定伴随 trailer 字段的分块传输编码的方式。 应用后者时， 只需把 trailers 赋值给该字段值。

### 6.4.19 User-Agent
> User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20100101 Firefox/13.0.1

(1) 首部字段 User-Agent 会将创建请求的浏览器和用户代理名称等信息传达给服务器。
(2) 由网络爬虫发起请求时， 有可能会在字段内添加爬虫作者的电子邮件地址。 此外， 如果请求经过代理， 那么中间也很可能被添加上代理服务器的名称 

## 6.5 响应字段
### 6.5.1 Accept-Ranges
> Accept-Ranges: bytes

首部字段 Accept-Ranges 是用来告知客户端服务器是否能处理范围请求， 以指定获取服务器端某个部分的资源。可指定的字段值有两种， 可处理范围请求时指定其为 bytes， 反之则指定其为 none。

### 6.5.2 Age
> Age: 600

首部字段 Age 能告知客户端， 源服务器在多久前创建了响应。 字段值的单位为秒。若创建该响应的服务器是缓存服务器， Age 值是指缓存后的响应再次发起认证到认证完成的时间值。 代理创建响应时必须加上首部字段Age。

### 6.5.3 ETag
> ETag: "82e22293907ce725faf67773957acd12"

(1) 首部字段 ETag 能告知客户端实体标识。 它是一种可将资源以字符串形式做唯一性标识的方式。 服务器会为每份资源分配对应的 ETag值。另外， 当资源更新时， ETag 值也需要更新。 生成 ETag 值时， 并没有统一的算法规则， 而仅仅是由服务器来分配。
(2) 强 ETag 值和弱 Tag 值
 ① 强 ETag 值：强 ETag 值， 不论实体发生多么细微的变化都会改变其值。
> ETag: "usagi-1234"

 ② 弱 ETag 值：弱 ETag 值只用于提示资源是否相同。 只有资源发生了根本改变， 产生差异时才会改变 ETag 值。 这时， 会在字段值最开始处附加 W/。
> ETag: W/"usagi-1234"

### 6.5.4 Location
> Location: http://www.usagidesign.jp/sample.html

使用首部字段 Location 可以将响应接收方引导至某个与请求 URI 位置不同的资源。基本上， 该字段会配合 3xx ： Redirection 的响应， 提供重定向的URI。几乎所有的浏览器在接收到包含首部字段 Location 的响应后， 都会强制性地尝试对已提示的重定向资源的访问。

### 6.5.5 Proxy-Authenticate
> Proxy-Authenticate: Basic realm="Usagidesign Auth"

首部字段 Proxy-Authenticate 会把由代理服务器所要求的认证信息发送给客户端。

### 6.5.6 Retry-After
> Retry-After: 120

首部字段 Retry-After 告知客户端应该在多久之后再次发送请求。 主要配合状态码 503 Service Unavailable 响应， 或 3xx Redirect 响应一起使用。

### 6.5.7 Server
> Server: Apache/2.2.17 (Unix)

首部字段 Server 告知客户端当前服务器上安装的 HTTP 服务器应用程序的信息。 不单单会标出服务器上的软件应用名称， 还有可能包括版本号和安装时启用的可选项。

### 6.5.8 Vary
![cab15b4d-af48-4d0e-8dcc-02e77bd526db](https://i.loli.net/2018/01/17/5a5ec01c8b492.jpg)
(1) 首部字段 Vary 可对缓存进行控制。 源服务器会向代理服务器传达关于本地缓存使用方法的命令。
(2) 从代理服务器接收到源服务器返回包含 Vary 指定项的响应之后， 若再要进行缓存， 仅对请求中含有相同 Vary 指定首部字段的请求返回缓存。 即使对相同资源发起请求， 但由于 Vary 指定的首部字段不相同， 因此必须要从源服务器重新获取资源。

### 6.5.9 WWW-Authenticate
> WWW-Authenticate: Basic realm="Usagidesign Auth"

首部字段 WWW-Authenticate 用于 HTTP 访问认证。 它会告知客户端适用于访问请求 URI 所指定资源的认证方案（ Basic 或是 Digest） 和带参数提示的质询（ challenge） 。 状态码 401 Unauthorized 响应中，肯定带有首部字段 WWW-Authenticate。

## 6.6 实体首部字段
实体首部字段是包含在请求报文和响应报文中的实体部分所使用的首部，用于补充内容的更新时间等与实体相关的信息。
### 6.6.1 Allow
> Allow: GET, HEAD

首部字段 Allow 用于通知客户端能够支持 Request-URI 指定资源的所有 HTTP 方法。 当服务器接收到不支持的 HTTP 方法时， 会以状态码405 Method Not Allowed 作为响应返回。 与此同时， 还会把所有能支持的 HTTP 方法写入首部字段 Allow 后返回。

### 6.6.2 Content-Encoding
> Content-Encoding: gzip

首部字段 Content-Encoding 会告知客户端服务器对实体的主体部分选用的内容编码方式。 内容编码是指在不丢失实体信息的前提下所进行的压缩。主要采用以下 4 种内容编码的方式：gzip、compress、deflate、identity。

### 6.6.3 Content-Language
> Content-Language: zh-CN

首部字段 Content-Language 会告知客户端， 实体主体使用的自然语言（ 指中文或英文等语言） 。

### 6.6.4 Content-Length
> Content-Length: 15000

首部字段 Content-Length 表明了实体主体部分的大小（ 单位是字节） 。 对实体主体进行内容编码传输时， 不能再使用 Content-Length首部字段。 

### 6.6.5 Content-Location
> Content-Location: http://www.hackr.jp/index-ja.html

首部字段 Content-Location 给出与报文主体部分相对应的 URI。 和首部字段 Location 不同， Content-Location 表示的是报文主体返回资源对应的 URI。

### 6.6.6 Content-MD5
> Content-MD5: OGFkZDUwNGVhNGY3N2MxMDIwZmQ4NTBmY2IyTY==

首部字段 Content-MD5 是一串由 MD5 算法生成的值， 其目的在于检查报文主体在传输过程中是否保持完整， 以及确认传输到达。

### 6.6.7 Content-Range
> Content-Range: bytes 5001-10000/10000

针对范围请求， 返回响应时使用的首部字段 Content-Range， 能告知客户端作为响应返回的实体的哪个部分符合范围请求。 字段值以字节为单位， 表示当前发送部分及整个实体大小。

### 6.6.8 Content-Type
> Content-Type: text/html; charset=UTF-8

首部字段 Content-Type 说明了实体主体内对象的媒体类型。 和首部字段 Accept 一样， 字段值用 type/subtype 形式赋值。参数 charset 使用 iso-8859-1 或 euc-jp 等字符集进行赋值。

### 6.6.9 Expires
> Expires: Wed, 04 Jul 2012 08:26:05 GMT

(1) 首部字段 Expires 会将资源失效的日期告知客户端。 缓存服务器在接收到含有首部字段 Expires 的响应后， 会以缓存来应答请求， 在Expires 字段值指定的时间之前， 响应的副本会一直被保存。 当超过指定的时间后， 缓存服务器在请求发送过来时， 会转向源服务器请求资源。
(2) 源服务器不希望缓存服务器对资源缓存时， 最好在 Expires 字段内写入与首部字段 Date 相同的时间值。
(3) 但是， 当首部字段 Cache-Control 有指定 max-age 指令时， 比起首部字段 Expires， 会优先处理 max-age 指令。

### 6.6.10 Last-Modified
> Last-Modified: Wed, 23 May 2012 09:59:55 GMT

首部字段 Last-Modified 指明资源最终修改的时间。 一般来说， 这个值就是 Request-URI 指定资源被修改的时间。 但类似使用 CGI 脚本进行动态数据处理时， 该值有可能会变成数据最终修改时的时间。

## 6.7 为Cookie服务的首部字段
(1) Cookie的工作机制是用户识别及状态管理。Web网站为了管理用户的状态会通过Web浏览器，把一些数据临时写入用户的计算机内。接着当用户访问该网站时，可通过通信方式取回之前发放的Cookie。
(2) 调用Cookie时，由于可检验Cookie的有效期，以及发送方的域、路径、协议等消息，所以正规发布的Cookie内的数据不会因来自其他Web站点和攻击者的攻击而泄露。
(3) 为 Cookie 服务的首部字段

| 首部字段名 | 说明                           | 首部类型     |
|:-----------|:-------------------------------|:-------------|
| Set-Cookie | 开始状态管理所使用的Cookie信息 | 响应首部字段 |
| Cookie     | 服务器接收到的Cookie信息       | 请求首部字段 |

### 6.7.1 Set-Cookie
> Set-Cookie: status=enable; expires=Tue, 05 Jul 2011 07:26:31 GMT; path=/; domain=.hackr.jp;

当服务器准备开始管理客户端的状态时， 会事先告知各种信息。下面的表格列举了 Set-Cookie 的字段值。

| 属性         | 说明                                                           |
|:-------------|:---------------------------------------------------------------|
| Name=VALUE   | 赋予Cookie的名称和值（必需）                                   |
| expires=DATE | Cookie的有效期（默认为浏览器关闭前）                           |
| path=PATH    | 将服务器上的文件目录作为Cookie的适用对象（默认为文档所在目录） |
| domain=域名  | 作为Cookie适用对象的域名（默认为创建Cookie的服务器的域名）     |
| Secure       | 仅在HTTPS安全通信时才会发送Cookie                              |
| HttpOnly     | 加以限制，使Cookie不能被JavaScript脚本访问                     |

### 6.7.2 Cookie
> Cookie: status=enable

首部字段Cookie会告知服务器，当客户端想获取HTTP状态管理支持时，就会在请求中包含从服务器收到的Cookie。接收到多个Cookie时，同样可以以多个Cookie形式发送。

## 6.8 其他首部字段
### 6.8.1 X-Frame-Options
> X-Frame-Options: DENY

(1) 首部字段 X-Frame-Options 属于 HTTP 响应首部，用于控制网站内容在其他 Web 网站的 Frame 标签内的显示问题。其主要目的是为了防止点击劫持（clickjacking）攻击。
(2) 首部字段 X-Frame-Options 有以下两个可指定的字段值。
 ① DENY ：拒绝
 ② SAMEORIGIN ：仅同源域名下的页面（Top-level-browsing-context）匹配时许可。（比如，当指定 http://hackr.jp/sample.html 页面为 SAMEORIGIN 时，那么 hackr.jp 上所有页面的 frame 都被允许可加载该页面，而 example.com 等其他域名的页面就不行了）

### 6.8.2 X-XSS-Protection
> X-XSS-Protection: 1

(1) 首部字段 X-XSS-Protection 属于 HTTP 响应首部，它是针对跨站脚本攻击（XSS）的一种对策，用于控制浏览器 XSS 防护机制的开关。
(2) 首部字段 X-XSS-Protection 可指定的字段值如下。
 ① 0 ：将 XSS 过滤设置成无效状态
 ② 1 ：将 XSS 过滤设置成有效状态

### 6.8.3 DNT
> DNT: 1

(1) 首部字段 DNT 属于 HTTP 请求首部，其中 DNT 是 Do Not Track 的简称，意为拒绝个人信息被收集，是表示拒绝被精准广告追踪的一种方法。
(2) 首部字段 DNT 可指定的字段值如下。
 ① 0 ：同意被追踪
 ② 1 ：拒绝被追踪
(3) 由于首部字段 DNT 的功能具备有效性，所以 Web 服务器需要对 DNT 做对应的支持。

### 6.8.4 P3P
> P3P: CP="CAO DSP LAW CURa ADMa DEVa TAIa PSAa PSDa IVAa IVDa OUR BUS IND UNI COM NAV INT"

(1) 首部字段 P3P 属于 HTTP 相应首部，通过利用 P3P（The Platform for Privacy Preferences，在线隐私偏好平台）技术，可以让 Web 网站上的个人隐私变成一种仅供程序可理解的形式，以达到保护用户隐私的目的。
(2) 要进行 P3P 的设定，需按以下操作步骤进行。
步骤 1：创建 P3P 隐私
步骤 2：创建 P3P 隐私对照文件后，保存命名在 /w3c/p3p.xml
步骤 3：从 P3P 隐私中新建 Compact policies 后，输出到 HTTP 响应中
