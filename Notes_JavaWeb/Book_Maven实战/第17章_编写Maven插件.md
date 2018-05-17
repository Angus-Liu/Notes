### 17.1 编写Maven插件的一般步骤

编写Maven插件的主要步骤：

1. 创建一个maven-plugin项目：插件本身也是Maven项目，特殊的地方在于它的packaging必须是maven-plugin，可以使用maven-archetype-plugin快速创建一个Maven插件项目。
2. 为插件编写目标：每个插件都必须包含一个或者多个目标，Maven称之为Mojo（与POJO对应，后者指Plain Old Java Object，这里指Maven Old Java Object）。编写插件的时候必须提供一个或者多个继承自AbstractMojo的类。
3. 为目标提供配置点：大部分Maven插件及其目标都是可配置的，因此在编写Mojo的时候需要注意提供可配置的参数。
4. 编写代码实现目标行为：根据实际的需要实现Mojo。
5. 错误处理及日志：当Mojo发生异常时，根据情况控制Maven的运行状态。在代码中编写必要的日志以便为用户提供足够的信息。
6. 测试插件：编写自动化的测试代码测试行为，然后再实际运行插件以验证其行为。

