## 静态资源访问

```java
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    /**
     * 静态资源访问配置，等同于在 application.yml 中做如下配置，区别是代码配置不会覆盖默认配置，且可以设置多个 pattern
     *
     * spring:
     *   mvc:
     *     # 静态资源匹配，默认值为（/**）
     *     static-path-pattern: /static/**
     *   resources:
     *     # 静态资源路径，默认值为 classpath:/META-INF/resources/,classpath:/resources/,classpath:/static/,classpath:/public/
     *     static-locations: classpath:/static/
     *
     * @param registry
     */
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/static/**")
                .addResourceLocations("classpath:/static/");
    }
}

```

## WebSocket 注入 Service

```java
/**
 * WebSocket 配置
 *
 * @author Angus Liu
 * @data 2018/9/13
 */
@Configuration
public class WebSocketConfig {

    /**
     * ServerEndpointExporter 用于扫描和注册所有携带 ServerEndPoint 注解的实例，
     * 若部署到外部容器 则无需提供此类。
     *
     * @return
     */
    @Bean
    public ServerEndpointExporter serverEndpointExporter() {
        return new ServerEndpointExporter();
    }


    /**
     * 因 SpringBoot WebSocket 对每个客户端连接都会创建一个 WebSocketServer（@ServerEndpoint 注解对应的） 对象，Bean 注入操作会被直接略过，因而手动注入一个全局变量
     *
     * @param messageService
     */
    @Autowired
    public void setMessageService(MessageService messageService) {
        WebSocketServer.messageService = messageService;
    }
}

/**
 * WebSocket 聊天服务端
 *
 * @author Angus Liu
 * @date 2018/09/13
 */
@Component
@ServerEndpoint(value = "/web-socket-server/{account}")
public class WebSocketServer {
    // 待注入对象声明为全局变量
    public static MessageService messageService;
    ...
}
```

