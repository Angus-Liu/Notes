## 默认激活的 profile
```yml
spring:
  profiles:
    active: dev
```

## Hibernate JPA

```yml
spring:
  jpa:
    hibernate:
      ddl-auto: validate
    show-sql: true
```

## Thymeleaf

```yml
spring:
  thymeleaf:
    # 模板格式
    mode: HTML
    encoding: UTF-8
    cache: false
    # 支持 EL 表达式
    enable-spring-el-compiler: true
    servlet:
      content-type: text/html
```

## ElasticSearch

```yml
spring:
  data:
    elasticsearch:
      cluster-name: angus
      cluster-nodes: 127.0.0.1:9300
```

## 静态资源匹配

```yml
spring:
  mvc:
    # 静态资源匹配，默认值为（/**）
    static-path-pattern: /static/**
  resources:
    # 静态资源路径，默认值为 classpath:/META-INF/resources/,classpath:/resources/,classpath:/static/,classpath:/public/
    static-locations: classpath:/static/
```

## Log 配置

```yml
# log 配置
logging:
  level:
    org.hibernate.SQL: debug
    com.angus.xunwu.base: debug
```

## 关闭默认的错误页面

```yml
server:
  # 关闭默认的 error page
  error:
    whitelabel:
      enabled: false
```

## MySQL 配置

```yml
spring:
  # datasource 配置
  datasource:
    url: jdbc:mysql://localhost:3306/demo?useSSL=false&serverTimezone=Asia/Shanghai
    username: root
    password: root
    driver-class-name: com.mysql.cj.jdbc.Driver
```

## H2 配置

```yml
spring:
  # datasource 配置
  datasource:
    # 内存模式
    url: jdbc:h2:mem:test
    driver-class-name: org.h2.Driver
    schema: classpath:db/schema.sql
    data: classpath:db/data.sql
```

