# HarmonyOS MCP Explorer 代码重构方案

## 现状分析

当前Index.ets和ResultPage.ets代码量较大，职责不够清晰，存在以下问题：
- Index.ets约300+行，包含配置加载、表单管理、查询构建等多种职责
- ResultPage.ets约390+行，包含API调用、结果展示、状态管理等逻辑
- 组件复用性不强，维护困难
- 类型定义分散，已部分整合到ApiTypes.ets

## 综合架构设计方案

### 1. 共享状态管理层
```
store/
  AppStore.ets          # 全局应用状态管理
  QueryStore.ets        # 查询相关状态管理
    - availableOptions: QueryOptionConfig[]
    - selectedOption: QueryOptionConfig | null
    - selectedType: string
    - formData: Record<string, string>
    - 状态更新方法
  ConfigStore.ets       # 配置数据状态管理
    - 配置加载状态
    - 配置缓存
```

### 2. 服务层
```
services/
  ConfigService.ets     # 配置加载服务（Index使用）
    - loadConfigFromJSON(): Promise<QueryConfig>
    - 处理UTF-8文件解码
    - 错误处理和重试机制

  QueryService.ets      # 查询构建服务（Index使用）
    - buildQueryParams(formData, selectedType): QueryParams
    - buildQueryText(selectedOption, formData): string
    - validateForm(formData, fields): ValidationResult

  ApiService.ets        # API请求服务（ResultPage使用）
    - performQuery(queryText): Promise<ApiResultData>
    - 封装HttpClient调用
    - 错误处理和重试

  RouteService.ets      # 路由参数管理服务
    - parseRouteParams(): RouteParams | null
    - navigateToResult(params): void
    - 参数验证和错误处理
```

### 3. 共享组件库
```
components/
  common/
    TitleBar.ets        # 通用标题栏组件
      - 支持标题文本配置
      - 支持返回按钮显示/隐藏
      - 支持右侧操作按钮

    LoadingView.ets     # 加载状态组件
      - 统一的加载动画
      - 可配置提示文本

    ErrorView.ets       # 错误状态组件
      - 错误图标和文本展示
      - 重试按钮（可选）
      - 错误类型分类展示

  query/
    QueryOptionCard.ets  # 查询选项卡片组件
      - 接收QueryOptionConfig参数
      - 选中状态管理
      - 点击事件回调

    DynamicForm.ets     # 动态表单组件
      - 根据字段配置渲染表单
      - 表单验证
      - 数据绑定

    FormField.ets       # 单个表单字段组件
      - 支持不同输入类型
      - 必填标识
      - 验证状态展示

  result/
    QueryInfo.ets       # 查询信息展示组件
      - 查询类型和内容展示
      - 支持折叠/展开

    ToolResults.ets     # 工具调用结果组件
      - 工具列表渲染
      - 展开/折叠详情

    ToolItem.ets        # 单个工具项组件
      - 工具信息展示
      - 状态图标
      - 详情展开

    MessageContent.ets  # 消息内容展示组件
      - 消息格式化展示
      - 复制功能
      - 链接识别
```

### 4. 工具函数层
```
utils/
  FileUtils.ets         # 文件操作工具
    - readRawFileAsText(filename): Promise<string>
    - UTF-8解码处理
    - 预览器环境兼容

  HttpClient.ets        # HTTP客户端（已存在，可优化）
    - 增加请求拦截器
    - 统一错误处理
    - 超时重试机制

  TextUtils.ets         # 文本处理工具
    - 文本截断和省略
    - 格式化显示
    - 特殊字符处理

  RouterUtils.ets       # 路由参数工具
    - 参数序列化/反序列化
    - 类型安全的参数传递
    - 导航历史管理

  ValidationUtils.ets   # 验证工具
    - 表单字段验证规则
    - 错误消息生成
    - 通用验证函数
```

### 5. 页面简化后结构
```
pages/
  Index.ets            # 主页面（目标：<150行）
    - 页面布局和状态管理
    - 组件组合和事件处理
    - 页面级别的生命周期

  ResultPage.ets       # 结果页面（目标：<100行）
    - 页面布局和导航
    - 组件组合
    - 页面级别的状态管理
```

## 数据流设计

### Index页面数据流
```
ConfigService.loadConfig()
  ↓
ConfigStore.setConfig()
  ↓
QueryStore.setAvailableOptions()
  ↓
用户选择/输入
  ↓
QueryService.buildParams()
  ↓
RouteService.navigateToResult()
```

### ResultPage页面数据流
```
RouteService.parseParams()
  ↓
QueryStore.setCurrentQuery()
  ↓
ApiService.performQuery()
  ↓
ResultPage渲染结果
```

## 实施计划

### 第一阶段：服务层拆分（优先级：高）
1. 创建ConfigService，迁移配置加载逻辑
2. 创建QueryService，迁移查询构建逻辑
3. 创建ApiService，迁移API调用逻辑
4. 创建RouteService，统一路由参数处理

**预期收益**：
- 业务逻辑与UI分离
- 便于单元测试
- 提高代码复用性

### 第二阶段：状态管理重构（优先级：中）
1. 创建QueryStore，使用@ObservedV2/@Trace
2. 迁移状态管理逻辑
3. 建立响应式数据流

**预期收益**：
- 状态管理统一化
- 跨页面数据共享
- 更好的数据一致性

### 第三阶段：组件拆分（优先级：中）
1. 拆分Index页面组件（QueryOptionCard, DynamicForm）
2. 拆分ResultPage组件（ToolResults, MessageContent）
3. 创建通用组件（TitleBar, LoadingView, ErrorView）

**预期收益**：
- 组件复用性提升
- 代码可维护性增强
- UI一致性保证

### 第四阶段：工具函数整理和页面精简（优先级：低）
1. 整理和优化工具函数
2. 页面代码精简
3. 性能优化和代码清理

**预期收益**：
- 代码质量提升
- 性能优化
- 开发体验改善

## 技术要点

### 状态管理
- 使用HarmonyOS的@ObservedV2和@Trace实现响应式状态
- 避免过度设计，保持简单实用
- 明确状态的生命周期和作用域

### 组件设计
- 遵循单一职责原则
- 通过props传递配置，通过callbacks处理事件
- 支持主题和样式定制

### 服务层设计
- 异步操作使用Promise/async-await
- 统一的错误处理机制
- 支持取消和重试

### 类型安全
- 充分利用TypeScript类型系统
- 所有类型定义集中在ApiTypes.ets
- 避免any类型的使用

## 风险评估

### 重构风险
- **影响范围大**：涉及核心页面重构
- **测试工作量**：需要全面回归测试
- **时间投入**：预计需要1-2周完成

### 降低风险措施
- 分阶段实施，每阶段都保证功能完整性
- 保留原有文件作为备份
- 充分测试每个阶段的改动
- 优先实施低风险、高收益的改动

## 预期收益

### 短期收益
- 代码结构更清晰
- 组件复用性提升
- 维护成本降低

### 长期收益
- 新功能开发效率提升
- 代码质量和稳定性改善
- 团队协作效率提高
- 更好的可测试性

---

*备注：此方案基于当前代码结构分析制定，可根据实际开发过程中的情况进行调整优化。*