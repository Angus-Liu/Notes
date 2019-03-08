# 第11章 用CSS进行布局

**构建页面**
恰当地使用 article、 aside、 nav、section、 header、 footer 和 div 等元素将页面划分成不同的逻辑区块。根据需要，对它们应用 ARIA 地标角色。 

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Angus Liu</title>
</head>
<body>
<div class="page">
    <!-- ==== 开始报头 ==== -->
    <header class="masthead" role="banner">

    </header>
    <!-- 结束报头 -->

    <!-- ==== 开始容器 ==== -->
    <div class="container">
        <!-- ==== 开始主体内容 ==== -->
        <main role="main">

        </main>
        <!-- 结束主体内容 -->

        <!-- ==== 开始附注栏 ==== -->
        <div class="sidebar">

        </div>
        <!-- 结束附注栏 -->
    </div>
    <!-- 结束容器 -->

    <!-- ==== 开始页脚 ==== -->
    <footer class="footer" role="contentinfo">

    </footer>
    <!-- 结束页脚 -->
</div>
<!-- 结束页面 -->
</body>
</html>
```

