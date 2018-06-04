### # \<c:import> JSTL标记

```jsp
<c:import url="http://www.example.html" />
```

动态：在请求时将URL属性值执行的内容增加到当前页面。它与\<jsp:include>非常相似，但是更强大，也更灵活。

### # \<c:url>可以满足所有超链接需求

如果容器未能从客户得到一个cookie，它会自动完成URL重写。为此需要对URL编码，将会jessionid追加到特定URL的最后，使用\<c:url>标记可以自动完成这项工作。

```jsp
<a href="<c:url value='/example.jsp'" /> Click here! </a>
```

