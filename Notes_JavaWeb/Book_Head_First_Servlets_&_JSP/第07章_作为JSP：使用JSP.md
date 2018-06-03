### # JSP隐式对象

| API                 | 隐式对象    |
| ------------------- | ----------- |
| JspWriter           | out         |
| HttpServletRequest  | request     |
| HttpServletResponse | response    |
| HttpSession         | session     |
| ServletContext      | application |
| ServletConfig       | config      |
| Throwable           | exception   |
| PageContext         | pageContext |
| Object              | page        |

### # JSP中的属性

|      | servlet中                                       | JSP中（使用隐式对象）                  |
| ---- | ----------------------------------------------- | -------------------------------------- |
| 应用 | getServletContext().setAttribute("key", value)  | application.setAttribute("key", value) |
| 请求 | request.setAttribute("key", value)              | request.setAttribute("key", value)     |
| 会话 | request.getSession().setAttribute("key", value) | session.setAttribute("key", value)     |
| 页面 | 不适用                                          | pageContext.setAttribute("key", value) |

### # 3个指令

① page指令

```jsp
<%@ page import="foo.*" session="false" %>
```

定义页面特定的属性，如字符编码、页面响应的内容类型，以及这个页面是否要有隐式的会话对象。page指令可以使用至多13个不同属性（如import属性）。

② taglib指令

```jsp
<%@ taglib tagdir="/WEB-INF/tags/lib" prefix="cool" %>
```

定义JSP可以使用的标签库。

③ include指令

```jsp
<%@ include file="header.html" %>
```

定义在转换时增加到当前页面的文本和代理，从而允许建立可重用的块（如标准页面标题或导航栏），这些可重用的块能增加到各个页面上，而不必在每个JSP中重复写这些代码。

