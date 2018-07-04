---
title: 《设计模式的艺术》读书笔记
subtitle: 第01章 从招式与内功谈起——设计模式概述
author: Angus Liu
cdn: header-off
date: 2017-11-03 20:56:56
header-img: https://i.loli.net/2017/11/03/59fc68430fc47.jpg
tags:
      - 《设计模式的艺术》
      - 读书笔记
      - Java
      - 设计模式
---
> I will no longer, as has ever been my habit, continue to ruminate on every petty vexation which fortune may dispense; I will enjoy the present, and the past shall be for me the past.
> 我绝不会再像以前一样，把命运加给我们的一点儿不幸拿来反复咀嚼(念念不忘)；我要享受现时，过去的事就让它过去吧。
> <p align="right"> —— 歌德《少年维特之烦恼》 </p>

## 1.1 设计模式是从何而来
设计模式起源于建筑领域，最早由Christopher Alexander博士及其研究团队发现人们对舒适住宅和城市环境存在一些共同的认同规律，他们把这些认同规律归纳为253个模式，对每一个模式(Pattern)都从Context（前提条件）、Theme或Problem（目标问题）、 Solution（解决方案）三个方面进行了描述，并给出了从用户需求分析到建筑环境结构设计直至经典实例的过程模型。

Christopher Alexander在他的著作《建筑的永恒之道》中，将模式定义为： 每个模式都描述了一个在我们的环境中不断出现的问题，然后描述了该问题的解决方案的核心，通过这种方式，我们可以无数次地重用那些已有的成功的解决方案，无须再重复相同的工作。

这个定义可以简单的理解为：模式是在特定环境下人们解决某类重复出现问题的一套成功或有效的解决方案。(A pattern is a successful or efficient solution to a recurring  problem within a context.）

最早将模式的思想引入软件工程方法学的是1991-1992年以“四人组(Gang of Four，简称GoF，分别是Erich Gamma, Richard Helm, Ralph Johnson和John Vlissides)”自称的四位著名软件工程学者，他们在1994年归纳发表了23种在软件开发中使用频率较高式来统一沟通面向对象的设计模式，旨在用模方法在分析、设计和实现间的鸿沟。GoF将模式的概念引入软件工程领域，这标志着软件模式的诞生。

## 1.2 设计模式是什么
设计模式的一般定义为：设计模式（Disign Pattern）是一套被反复使用，多数人知晓的、经过分类编目的、代码设计经验的总结，使用设计模式是为了可重用代码、让代码更容易被他人理解并且保证代码可靠性。

设计模式一般包含名称、问题、目的、解决方案、效果等组成要素，其中关键要素是模式名称（描述模式的问题、解决方案和效果）、问题（描述何时使用该设计模式，以及设计中存在的问题和原因）、解决方案（描述设计模式组成成分及其相互关系，各自的职责和协作方式，通常用UML图表示）和效果（描述模式的优缺点及使用时应权衡的问题）。

根据设计模式的用途，可将其分为三大类：
(1) 创建型模式（5+1种）：主要用于如何创建对象。
(2) 结构型模型（7种）：主要用于描述如何实现类或对象的组合。
(3) 行为型模式（11种）：主要用于描述类或对象怎样交互以及怎样分配职责。

<table style="text-align:center"><caption style="text-align:center">常用设计模式一览表</caption><tr><th style="text-align:center">类型</th><th style="text-align:center">模式名称</th><th style="text-align:center">学习难度</th><th style="text-align:center">使用频率</th></tr><tr><td rowspan="6">创建型模式<br/>Creational Pattern</td><td>单例模式<br />Singleton Pattern</td><td>★☆☆☆☆</td><td>★★★★☆</td></tr><tr><td>简单工厂模式<br />Simple Factory Pattern</td><td>★★☆☆☆</td><td>★★★☆☆</td></tr><tr><td>工厂方法模式<br />Factory Method Pattern</td><td>★★☆☆☆</td><td>★★★★★</td></tr><tr><td>抽象工厂模式<br />Abstract Factory Pattern</td><td>★★★★☆</td><td>★★★★★</td></tr><tr><td>原型模式<br/>Prototype Pattern</td><td>★★★☆☆</td><td>★★★☆☆</td></tr><tr><td>建造者模式<br />Builder Pattern</td><td>★★★★☆</td><td>★★☆☆☆</td></tr><tr><td rowspan="7">结构型模式<br />Structural Pattern</td><td>适配器模式<br />Adapter Pattern</td><td>★★☆☆☆</td><td>★★★★☆</td></tr><tr><td>桥接模式<br />Bridge Pattern</td><td>★★★☆☆</td><td>★★★☆☆</td></tr><tr><td>组合模式<br />Composite Pattern</td><td>★★★☆☆</td><td>★★★★☆</td></tr><tr><td>装饰模式<br />Decorator Pattern</td><td>★★★☆☆</td><td>★★★☆☆</td></tr><tr><td>外观模式<br />Facade Pattern</td><td>★☆☆☆☆</td><td>★★★★★</td></tr><tr><td>享元模式<br />Flyweight Pattern</td><td>★★★★☆</td><td>★☆☆☆☆</td></tr><tr><td>代理模式<br />Proxy Pattern</td><td>★★★☆☆</td><td>★★★★☆</td></tr><tr><td rowspan="11">行为型模式<br />Behavioral Pattern</td><td>职责链模式<br />Chain of Responsibility Pattern</td><td>★★★☆☆</td><td>★★☆☆☆</td></tr><tr><td>命令模式<br />Command Pattern</td><td>★★★☆☆</td><td>★★★★☆</td></tr><tr><td>解释器模式<br />Interpreter Pattern</td><td>★★★★★</td><td>★☆☆☆☆</td></tr><tr><td>迭代器模式<br />Iterator Pattern</td><td>★★★☆☆</td><td>★★★★★</td></tr><tr><td>中介者模式<br />Mediator Pattern</td><td>★★★☆☆</td><td>★★☆☆☆</td></tr><tr><td>备忘录模式<br />Memento Pattern</td><td>★★☆☆☆</td><td>★★☆☆☆</td></tr><tr><td>观察者模式<br />Observer Pattern</td><td>★★★☆☆</td><td>★★★★★</td></tr><tr><td>状态模式<br />State Pattern</td><td>★★★☆☆</td><td>★★★☆☆</td></tr><tr><td>策略模式<br />Strategy Pattern</td><td>★☆☆☆☆</td><td>★★★★☆</td></td><tr><td>模板方法模式<br />Template Method Pattern</td><td>★★☆☆☆</td><td>★★★☆☆</td></td><tr><td>访问者模式<br />Visitor Pattern</td><td>★★★★☆</td><td>★☆☆☆☆</td></td></table><br />

## 1.3 设计模式有什么用
简单来说，设计模式至少有以下几个用途：
(1) 设计模式来源于众多专家的经验和智慧，是从许多优秀的软件系统中总结的成功的、能够实现可维护性复用的设计方案，使用这些方案可以避免我们做一些重复性的工作。
(2) 设计模式提供了一套通用的形式来方便开发人员之间的沟通交流，使得设计方案更叫通俗易懂。
(3) 大部分设计模式兼顾了系统的可重用性和可扩展性，使得我们可以更好地重用一些已有的设计方案、功能模块甚至一个完整的软件系统，避免做一些重复的设计、编写一些重复的代码。设计模式还有助于提高系统的灵活性和可扩展性，让我们在不修改或少修改现有系统的基础上增加、删除或替换功能模块。
(4) 合理使用设计模式并对设计模式的使用情况进行文档化，将有助于别人更块地理解系统。
(5) 最后一点对初学者很重要，学习设计模式将有助于初学者更加深入地理解面向对象思想，早日脱离“菜鸟期”。

## 1.4 个人观点（作者）
以下是本书作者关于学习设计模式的几点看法：
(1) 掌握设计模式的关键在于多思考，多实践，用心学习，饱含信心。
(2)在学习每一个设计模式时应该掌握如下几点：
&emsp;① 明确这个设计模式的意图，它解决的是什么问题，以及何时使用它。
&emsp;② 掌握其结构图，记住关键代码，明白它是如何解决问题的。
&emsp;③ 联想到至少两个它的应用案例，一个生活中的，一个软件中的。
&emsp;④ 了解这个设计模式的优缺点，以及使用它的注意事项。
(3) “如果想体验一下运用模式的感觉，那么最好的方法就是运用它们”。学习设计模式的目的在于运用，严格一点说，不会再开发中灵活运用一个模式基本等于没学。
(4) 千万不要滥用设计模式，不要试图在一个系统中用上所有模式。每个模式都有自己的适用场景，不能为了使用模式而过度设计。
(5) 每一个设计模式都是一种计策，它为解决某一类问题而诞生，不管其难度与使用频率，都应该好好学习，反复研读。
(6) 设计模式的“上乘”境界：“手中无模式，心中有模式”。
(7) John Vlissides的著作《设计模式沉思录》(Pattern Hatching Design Patterns Applied)：模式从不保证任何东西，它不能保证你一定能够做出可复用的软件，提高你的生产率，更不能保证世界和平。模式并不能替代人来完成软件系统的创造，它们只不过会给那些缺乏经验但却具备才能和创造力的人带来希望。

本篇学习笔记参考自[Lovelion的CSDN博客](http://blog.csdn.net/lovelion/article/details/17517213)及他的书籍[《设计模式的艺术》](https://book.douban.com/subject/20493657/)。
