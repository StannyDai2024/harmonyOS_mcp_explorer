# 开发向导

本文指导如何一步步开发出当前的应用。

## 考点
1. arkUI 组件使用（基础组件、布局组件）
2. 自定义组件封装
3. 状态管理
4. 生命周期
5. 配置新页面路由跳转
6. 路由参数解析
7. HTTP 请求、结果解析
8. 条件渲染、循环渲染
9. 应用通知下发

### 核心配置文件

查询功能模块配置文件如下，配置文件中定义了：
1. 查询的功能列表信息
2. 选中功能后需要填写哪些表单输入信息

基于这份配置文件实现 index 页面 UI：
1. 功能选择列表
2. 动态表单

```ts
// 直接在代码中定义配置数据
const queryConfigData: QueryConfig = {
  queryOptions: [
    {
      type: 'weather',
      label: '查天气',
      description: '查询指定城市的天气信息',
      icon: '🌤️',
      enabled: true,
      fields: [
        {
          key: 'location',
          label: '城市名称',
          type: 'text',
          placeholder: '请输入城市名称（如：杭州）',
          required: true
        }
      ]
    },
    {
      type: 'poi',
      label: '查询POI',
      description: '根据地址获取经纬度坐标',
      icon: '📍',
      enabled: true,
      fields: [
        {
          key: 'address',
          label: '地址信息',
          type: 'text',
          placeholder: '请输入详细地址',
          required: true
        }
      ]
    },
    {
      type: 'nearby',
      label: '周边搜索',
      description: '搜索指定位置周边的兴趣点',
      icon: '🔍',
      enabled: true,
      fields: [
        {
          key: 'location',
          label: '位置',
          type: 'text',
          placeholder: '请输入位置（如：西湖）',
          required: true
        },
        {
          key: 'keyword',
          label: '搜索关键词',
          type: 'text',
          placeholder: '请输入搜索关键词（如：餐厅）',
          required: true
        }
      ]
    },
    {
      type: 'distance',
      label: '距离测量',
      description: '计算两个地点之间的距离',
      icon: '📏',
      enabled: true,
      fields: [
        {
          key: 'startLocation',
          label: '起点',
          type: 'text',
          placeholder: '请输入起点位置',
          required: true
        },
        {
          key: 'endLocation',
          label: '终点',
          type: 'text',
          placeholder: '请输入终点位置',
          required: true
        }
      ]
    },
    {
      type: 'cycling',
      label: '骑行规划',
      description: '规划两地之间的骑行路线',
      icon: '🚴',
      enabled: true,
      fields: [
        {
          key: 'startLocation',
          label: '出发地',
          type: 'text',
          placeholder: '请输入出发地位置',
          required: true
        },
        {
          key: 'endLocation',
          label: '目的地',
          type: 'text',
          placeholder: '请输入目的地位置',
          required: true
        }
      ]
    }
  ]
};

```


## 工程初始化

将 query-option.json 放置在 rawfile 目录下

## 应用功能开发（总计65分）

### 1. 本地文件读取逻辑实现（6分）
在 page/Index 页面中实现读取 rawfile 目录下的 query-config.json 文件逻辑，并解析为实体对象，从对象中读取 queryOptions 用于后续查询功能列表的渲染；实现页面标题（高德MCP查询助手）的渲染。

答题卡提交：
（1）请将读取 json 文件的代码截图粘贴到答题卡中
（2）请将模拟器中标题的渲染页面截图粘贴到答题卡中

### 2. 实现列表卡片组件（5分）
封装可复用的卡片组件，列表中每一项的卡片应该包含 "icon"、"label"、"description" 内容的显示；每一项是 radio 单选按钮。

答题卡提交：
（1）请将代码实现截图粘贴到答题卡中
（2）请将组件渲染效果截图粘贴到答题卡中

### 3. 实现查询列表渲染（5分）
在 Index 页面中引用卡片组件，并用第一步获取的 queryOptions 数据来渲染查询功能选择列表界面。

答题卡提交：
（1）请将代码实现截图粘贴到答题卡中
（2）查询列表渲染效果截图粘贴到答题卡中

### 4. 实现表单项组件（5分）
观察 queryOptions 里面的 fields 字段，该字段描述了查询选项选中后需要输入的信息。其中 required 为是否必填；type 是表单类型，本项目中仅涉及文本输入框。这一步实现表单项组件，接收单个 field 信息，并渲染出表单内容，包含 label、placeholder 的显示。
请将代码实现截图、表单项组件渲染效果截图粘贴到答题卡中。

### 5. 实现联动逻辑（7分）
选择不同的查询功能项后，动态展示对应的表单输入框，实现选项与表单内容的联动效果。
实现要点提示：
（1）监听查询选项变化，当选择改变时触发表单更新
（2）根据选中项的 fields 配置动态渲染对应表单
（3）实现表单数据的状态管理和双向绑定
（4）切换选项时清空之前输入的数据，避免数据污染

答题卡提交：
（1）请将上述每个要点的实现代码截图分步粘贴到答题卡中
（2）请将选中查询天气的页面渲染效果截图粘贴到答题卡中
（3）请将选中骑行规划的页面渲染效果截图粘贴到答题卡中

### 6. 实现路由跳转（3分）
新建结果页面并配置路由，实现查询按钮点击跳转到结果页。

实现要点提示：
（1）创建 ResultPage.ets 页面文件，实现标题以及左上角返回逻辑
（2）在 main_pages.json 中添加路由配置
（3）实现查询按钮点击事件处理

答题卡提交：
（1）请将 ResultPage.ets 页面创建代码截图粘贴到答题卡中
（2）请将 main_pages.json 路由配置截图粘贴到答题卡中
（3）请将查询按钮点击事件和路由跳转代码截图粘贴到答题卡中

### 7 实现跳转时同时添加参数（2分）
跳转结果页时，将当前的查询类型、用户输入信息以及要查询的内容文本作为参数传递到结果页。

各种查询类型的参数示例：
- **查询天气**：queryType: 'weather', queryText: "查天气 - 城市名称: 杭州"
- **查询POI**：queryType: 'poi', queryText: "查询POI - 地址信息: 西湖区文三路"
- **周边搜索**：queryType: 'nearby', queryText: "周边搜索 - 位置: 西湖, 搜索关键词: 餐厅"
- **距离测量**：queryType: 'distance', queryText: "距离测量 - 起点: 杭州, 终点: 上海"
- **骑行规划**：queryType: 'cycling', queryText: "骑行规划 - 出发地: 西湖, 目的地: 雷峰塔"

实现要点提示：
（1）点击查询按钮前实现表单验证逻辑，检查必填项是否已填写
（2）根据当前表单内容构建出 queryText （查询内容）

答题卡提交：
（1）请将表单验证逻辑代码截图粘贴到答题卡中
（2）请将构建 queryText 的方法实现代码截图粘贴到答题卡中

### 7. 实现结果页参数解析及查询信息展示（5分）
在结果页面中获取路由参数，在页面顶部中展示出【查询类型】【查询内容】两个信息。

实现要点提示：
（1）获取路由参数，解析查询类型和查询内容数据
（2）设计合理的信息展示UI界面

答题卡提交：
（1）请将路由参数获取和解析代码截图粘贴到答题卡中
（2）请将结果页面展示查询信息的效果截图粘贴到答题卡中

### 8. 实现请求逻辑（5分）
在结果页面显示后调用 API 查询结果（华为云部署的MCP API），实现 HTTP 网络请求逻辑。

实现要点提示：
（1）你可以利用 curl 命令尝试发起一个真实的 post 请求，观察返回结果，exampleReturn.md 记录了一个真实请求结果供你参考
（2）根据 API 的要求设置你的 http 请求头
（3）实现 SSE 流式响应的处理逻辑
（4）正确处理异步请求操作

答题卡提交：
（1）请将 HttpClient 请求调用代码截图粘贴到答题卡中
（2）请将请求参数构建逻辑代码截图粘贴到答题卡中
（3）请将异步请求处理代码截图粘贴到答题卡中


### 9. 解析请求响应数据，展示最终message返回结果（5分）
解析MCP API返回的SSE数据流，提取并展示最终的message内容。

实现要点提示：
（1）解析HttpClient返回的ApiResultData中的message字段
（2）实现文本内容的格式化显示
（3）处理可能的数据解析异常
（4）支持长文本的友好展示

答题卡提交：
（1）请将message数据解析代码截图粘贴到答题卡中
（2）请将message展示UI代码截图粘贴到答题卡中
（3）请将message内容展示效果截图粘贴到答题卡中

### 10. 实现不同状态展示（5分）
根据请求状态展示不同的UI界面：请求执行中展示 loading 态；请求失败展示失败状态和重新查询按钮；请求成功展示请求结果。

实现要点提示：
（1）定义请求状态管理（loading、success、error）
（2）使用条件渲染展示不同状态下的UI
（3）Loading 状态显示加载指示器和提示文字
（4）错误状态显示错误信息和重试按钮
（5）成功状态显示结果内容

答题卡提交：
（1）请将状态管理定义代码截图粘贴到答题卡中
（2）请将 Loading 状态UI实现代码截图粘贴到答题卡中
（3）请将错误状态UI和重试逻辑代码截图粘贴到答题卡中
（4）请将 Loading 状态页面效果截图粘贴到答题卡中
（5）请将错误状态页面效果截图粘贴到答题卡中

### 11. 解析请求响应数据，展示工具调用情况（5分）
解析并展示API响应中的工具调用信息，包括调用的工具名称、参数、执行状态等详细信息。

实现要点提示：
（1）解析响应中的toolResults数组数据
（2）提取工具名称、执行状态、请求参数、响应内容等信息
（3）设计工具调用信息的展示UI界面
（4）实现结构化数据的友好展示

答题卡提交：
（1）请将toolResults数据解析代码截图粘贴到答题卡中
（2）请将工具调用信息UI设计代码截图粘贴到答题卡中
（3）请将工具调用展示效果截图粘贴到答题卡中

### 12. 公共事件与通知功能实现（4分）
实现应用启动时自动推送一条通知消息。

实现要点提示：
（1）在 EntryAbility 的 onCreate 生命周期中实现
（2）使用 notificationManager 发送系统通知
（3）配置通知的标题、内容和样式
（4）处理通知权限和发送异常

答题卡提交：
（1）请将 EntryAbility 中通知实现代码截图粘贴到答题卡中
（2）请将通知配置代码截图粘贴到答题卡中
（3）请将系统通知显示效果截图粘贴到答题卡中

---

## 参考答案

### 1. 本地文件读取逻辑实现（6分）

**步骤说明**：在 Index.ets 中实现读取 rawfile 中的 query-config.json 文件

**参考答案**：

```typescript
import { util } from '@kit.ArkTS';
import { QueryConfig, QueryOptionConfig } from '../types/ApiTypes';

@Entry
@Component
struct Index {
  @State availableOptions: QueryOptionConfig[] = [];
  uiContext = this.getUIContext();

  aboutToAppear(): void {
    this.loadConfigFromJSON();
  }

  private loadConfigFromJSON(): void {
    const hostCxt = this.uiContext.getHostContext();
    hostCxt?.resourceManager.getRawFileContent('query-config.json').then((value) => {
      if (value.buffer.byteLength === 0) {
        console.log('预览器环境，无法读取配置文件');
        return;
      }

      const uint8Array = new Uint8Array(value.buffer);
      const decoder = util.TextDecoder.create('utf-8');
      const text: string = decoder.decodeWithStream(uint8Array, { stream: false });
      console.log('配置文件内容:', text);

      try {
        const configData = JSON.parse(text) as QueryConfig;
        this.availableOptions = configData.queryOptions;
        console.log('配置数据加载成功:', configData);
      } catch (error) {
        console.error('配置文件解析失败:', error);
      }
    })
      .catch((err: Error) => {
        console.error('配置文件读取失败:', JSON.stringify(err));
      });
  }

  build() {
    Column() {
      Text('高德MCP查询助手')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
    }
  }
}
```

**评分要点**：
- 正确使用 `resourceManager.getRawFileContent()` 读取文件 (3分)
- 正确使用 `util.TextDecoder` 解析buffer数据 (2分)
- 页面标题渲染 (1分)

### 2. 实现列表卡片组件（5分）

**步骤说明**：创建可复用的卡片组件

**参考答案（方式一：@Builder）**：

```typescript
@Builder
buildOptionCard(option: QueryOptionConfig) {
  Row({ space: 12 }) {
    Radio({ value: option.type, group: 'queryType' })
      .checked(this.selectedType === option.type)
      .onChange((isChecked: boolean) => {
        if (isChecked) {
          this.selectedType = option.type;
          this.selectedOption = option;
          this.resetFormData();
        }
      })

    Column({ space: 4 }) {
      Row({ space: 8 }) {
        Text(option.icon)
          .fontSize(18)

        Text(option.label)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_primary'))
      }
      .alignItems(VerticalAlign.Center)

      Text(option.description)
        .fontSize(14)
        .fontColor($r('app.color.text_secondary'))
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .alignItems(HorizontalAlign.Start)
    .layoutWeight(1)
  }
  .width('100%')
  .padding(16)
  .backgroundColor($r('app.color.surface'))
  .borderRadius(12)
  .alignItems(VerticalAlign.Top)
}
```

**参考答案（方式二：@Component）**：

```typescript
@Component
export struct QueryOptionCard {
  @Prop option: QueryOptionConfig;
  @Prop isSelected: boolean;
  private onSelectionChange: (option: QueryOptionConfig) => void = () => {};

  build() {
    Row({ space: 12 }) {
      Radio({ value: this.option.type, group: 'queryType' })
        .checked(this.isSelected)
        .onChange((isChecked: boolean) => {
          if (isChecked) {
            this.onSelectionChange(this.option);
          }
        })

      Column({ space: 4 }) {
        Row({ space: 8 }) {
          Text(this.option.icon)
            .fontSize(18)

          Text(this.option.label)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.text_primary'))
        }
        .alignItems(VerticalAlign.Center)

        Text(this.option.description)
          .fontSize(14)
          .fontColor($r('app.color.text_secondary'))
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
    }
    .width('100%')
    .padding(16)
    .backgroundColor($r('app.color.surface'))
    .borderRadius(12)
    .alignItems(VerticalAlign.Top)
  }
}
```

**评分要点**：
- 组件创建和参数传递 (2分)
- Radio组件实现单选 (1分)
- 正确显示icon、label、description (2分)

### 3. 实现查询列表渲染（5分）

**参考答案**：

```typescript
struct Index {
  @State selectedType: string = QueryType.WEATHER;
  @State availableOptions: QueryOptionConfig[] = [];
  @State selectedOption: QueryOptionConfig | null = null;

  build() {
    Column({ space: 12 }) {
      Text('选择查询功能')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .alignSelf(ItemAlign.Start)

      ForEach(this.availableOptions, (option: QueryOptionConfig) => {
        this.buildOptionCard(option)
      })
    }
  }

  @Builder
  buildOptionCard(option: QueryOptionConfig) {
    Row({ space: 12 }) {
      Radio({ value: option.type, group: 'queryType' })
        .checked(this.selectedType === option.type)
        .onChange((isChecked: boolean) => {
          if (isChecked) {
            this.selectedType = option.type;
            this.selectedOption = option;
            this.resetFormData();
          }
        })
      // ... 其余UI代码
    }
  }
}
```

**评分要点**：
- 使用ForEach循环渲染 (2分)
- 正确引入和参数传递 (2分)
- @State状态管理 (1分)

### 4. 实现表单项组件（5分）

**步骤说明**：创建表单输入项组件

**参考答案（方式一：@Builder）**：

```typescript
@Builder
buildConfigurableInputField(field: QueryField) {
  Column({ space: 8 }) {
    Row({ space: 4 }) {
      Text(field.label)
        .fontSize(16)
        .fontColor($r('app.color.text_primary'))

      if (field.required) {
        Text('*')
          .fontSize(16)
          .fontColor($r('app.color.error'))
      }
    }
    .alignSelf(ItemAlign.Start)

    TextInput({
      placeholder: field.placeholder,
      text: this.formData[field.key] || ''
    })
      .width('100%')
      .height(48)
      .fontSize(16)
      .placeholderColor($r('app.color.text_secondary'))
      .backgroundColor($r('app.color.surface'))
      .borderRadius(8)
      .onChange((value: string) => {
        this.formData[field.key] = value;
      })
  }
  .alignItems(HorizontalAlign.Start)
  .width('100%')
}
```

**参考答案（方式二：@Component）**：

```typescript
@Component
export struct FormField {
  @Prop field: QueryField;
  @Link fieldValue: string;

  build() {
    Column({ space: 8 }) {
      Row({ space: 4 }) {
        Text(this.field.label)
          .fontSize(16)
          .fontColor($r('app.color.text_primary'))

        if (this.field.required) {
          Text('*')
            .fontSize(16)
            .fontColor($r('app.color.error'))
        }
      }
      .alignSelf(ItemAlign.Start)

      TextInput({
        placeholder: this.field.placeholder,
        text: this.fieldValue
      })
        .width('100%')
        .height(48)
        .fontSize(16)
        .placeholderColor($r('app.color.text_secondary'))
        .backgroundColor($r('app.color.surface'))
        .borderRadius(8)
        .onChange((value: string) => {
          this.fieldValue = value;
        })
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
  }
}
```

**评分要点**：
- 组件创建和参数传递 (2分)
- TextInput双向绑定 (2分)
- label和必填标识显示 (1分)

### 5. 实现联动逻辑（7分）

**参考答案**：

```typescript
struct Index {
  @State selectedOption: QueryOptionConfig | null = null;
  @State formData: Record<string, string> = {};

  private resetFormData() {
    this.formData = {};
    if (this.selectedOption) {
      this.selectedOption.fields.forEach(field => {
        this.formData[field.key] = '';
      });
    }
  }

  @Builder
  buildDynamicForm() {
    Column({ space: 16 }) {
      Text('输入查询条件')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)

      Column({ space: 12 }) {
        if (this.selectedOption) {
          ForEach(this.selectedOption.fields, (field: QueryField) => {
            this.buildConfigurableInputField(field)
          })
        }
      }
    }
  }
}
```

**评分要点**：
- 选项变化监听和联动显示 (3分)
- 动态表单渲染逻辑 (2分)
- 表单数据状态管理 (1分)
- 切换时数据清空 (1分)

### 6. 实现路由跳转（3分）

**参考答案**：

```typescript
import { router } from '@kit.ArkUI';

handleQuery() {
  // 验证必填字段
  const missingFields: string[] = [];
  this.selectedOption?.fields.forEach(field => {
    if (field.required && (!this.formData[field.key] || this.formData[field.key].trim() === '')) {
      missingFields.push(field.label);
    }
  });

  if (missingFields.length > 0) {
    console.error('缺少必填字段:', missingFields.join(', '));
    return;
  }

  const queryParams = this.buildQueryParams();
  const queryText = this.buildQueryText();

  // 跳转到结果页面
  router.pushUrl({
    url: 'pages/ResultPage',
    params: {
      queryParams: queryParams,
      queryText: queryText
    }
  }).catch((error: Error) => {
    console.error('跳转结果页失败：', error);
  });
}
```

需要在 `main_pages.json` 中配置路由：
```json
{
  "src": [
    "pages/Index",
    "pages/ResultPage"
  ]
}
```

**评分要点**：
- 页面创建和路由配置 (1分)
- router.pushUrl跳转和参数传递 (1分)
- 表单验证逻辑 (1分)

### 7. 实现结果查询信息展示（5分）

**参考答案**：

```typescript
import { router } from '@kit.ArkUI';
import { QueryParams, RouteParams } from '../types/ApiTypes';

@Entry
@Component
struct ResultPage {
  @State queryParams?: QueryParams = undefined;
  @State queryText: string = '';

  aboutToAppear() {
    this.loadRouteParams();
  }

  loadRouteParams() {
    try {
      const params = router.getParams() as RouteParams;
      if (params) {
        this.queryParams = params.queryParams;
        this.queryText = params.queryText || '';
      }
    } catch (error) {
      console.error('获取路由参数失败：', error);
    }
  }

  @Builder
  buildQueryInfo() {
    Column({ space: 12 }) {
      Text('查询信息')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)

      Column({ space: 8 }) {
        Row() {
          Text('查询类型：')
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
          Text(this.getQueryTypeLabel())
            .fontSize(14)
            .fontColor($r('app.color.text_primary'))
        }

        Row() {
          Text('查询内容：')
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
          Text(this.queryText)
            .fontSize(14)
            .fontColor($r('app.color.text_primary'))
            .layoutWeight(1)
        }
      }
    }
    .padding(16)
    .backgroundColor($r('app.color.surface'))
    .borderRadius(8)
  }

  getQueryTypeLabel(): string {
    switch (this.queryParams?.type) {
      case 'weather': return '天气查询';
      case 'poi': return 'POI查询';
      case 'nearby': return '周边搜索';
      case 'distance': return '距离测量';
      case 'cycling': return '骑行规划';
      default: return '未知类型';
    }
  }
}
```

**评分要点**：
- 路由参数获取和解析 (2分)
- 查询信息UI设计 (2分)
- 数据正确显示 (1分)

### 8. 实现请求逻辑（5分）

**参考答案**：

```typescript
import { HttpClient } from '../utils/HttpClient';
import { ApiResultData } from '../types/ApiTypes';

@Entry
@Component
struct ResultPage {
  @State loading: boolean = false;
  @State result?: ApiResultData = undefined;
  @State error: string = '';

  onPageShow() {
    this.performQuery();
  }

  async performQuery() {
    this.loading = true;
    this.error = '';
    try {
      const response = await HttpClient.request({ query: this.queryText });
      if (response.success) {
        this.result = response.data;
      } else {
        this.error = response.error || '查询失败';
      }
    } catch (err) {
      this.error = '网络请求异常';
    } finally {
      this.loading = false;
    }
  }
}
```

**评分要点**：
- HTTP请求调用 (2分)
- 请求参数构建 (1分)
- SSE流式响应处理 (2分)

### 9. 实现不同状态展示（5分）

**参考答案**：

```typescript
@Builder
buildQueryResult() {
  if (this.loading) {
    this.buildLoadingView()
  } else if (this.error) {
    this.buildErrorView()
  } else if (this.result) {
    this.buildResultView()
  }
}

@Builder
buildLoadingView() {
  Column({ space: 16 }) {
    LoadingProgress()
      .width(48)
      .height(48)
      .color($r('app.color.brand_primary'))

    Text('正在查询中...')
      .fontSize(16)
      .fontColor($r('app.color.text_secondary'))
  }
  .justifyContent(FlexAlign.Center)
  .height(200)
}

@Builder
buildErrorView() {
  Column({ space: 16 }) {
    Text('❌')
      .fontSize(64)

    Text('查询失败')
      .fontSize(18)
      .fontWeight(FontWeight.Medium)

    Text(this.error)
      .fontSize(14)
      .fontColor($r('app.color.text_secondary'))
      .textAlign(TextAlign.Center)

    Button('重新查询')
      .onClick(() => {
        this.error = '';
        this.performQuery();
      })
  }
  .justifyContent(FlexAlign.Center)
  .height(300)
}
```

**评分要点**：
- 状态管理定义 (1分)
- Loading状态UI (1分)
- 错误状态UI和重试逻辑 (2分)
- 条件渲染实现 (1分)

### 10. 解析请求响应数据，展示最终message返回结果（5分）

**参考答案**：

```typescript
@Builder
buildMessageContent() {
  if (this.result?.message) {
    Column({ space: 8 }) {
      Text('💬 响应消息')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.text_primary'))

      Text(this.result.message)
        .fontSize(14)
        .fontColor($r('app.color.text_primary'))
        .backgroundColor($r('app.color.surface'))
        .padding(16)
        .borderRadius(8)
        .width('100%')
        .copyOption(CopyOptions.InApp)
    }
  }
}
```

**评分要点**：
- SSE数据解析 (2分)
- Message内容提取 (2分)
- 内容格式化显示 (1分)

### 11. 解析请求响应数据，展示工具调用情况（5分）

**参考答案**：

```typescript
@Builder
buildToolResults() {
  Column({ space: 12 }) {
    Text('🔧 工具调用详情')
      .fontSize(16)
      .fontWeight(FontWeight.Medium)

    ForEach(this.result?.toolResults || [], (tool: ToolResult, index: number) => {
      this.buildToolItem(tool, index)
    })
  }
}

@Builder
buildToolItem(tool: ToolResult, index: number) {
  Column({ space: 8 }) {
    Row({ space: 8 }) {
      Text(`#${index + 1}`)
        .fontSize(12)
        .fontColor($r('app.color.text_secondary'))

      Text(this.getToolName(tool))
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .layoutWeight(1)

      Text('🔧')
        .fontSize(16)
    }

    Text(this.getToolDescription(tool))
      .fontSize(13)
      .fontColor($r('app.color.text_secondary'))
      .maxLines(3)
  }
  .padding(12)
  .backgroundColor($r('app.color.surface'))
  .borderRadius(6)
}

getToolName(tool: ToolResult): string {
  return tool?.name || '未知工具';
}

getToolDescription(tool: ToolResult): string {
  if (tool?.status) {
    const statusText = tool.status === 'SUCCESS' ? '✅ 执行成功' : '❌ 执行失败';
    let description = statusText;

    if (tool.request) {
      const requestKeys = Object.keys(tool.request);
      if (requestKeys.length > 0) {
        const params = requestKeys.map(key => `${key}: ${tool.request![key]}`).join(', ');
        description += `\n参数: ${params}`;
      }
    }

    return description;
  }
  return '工具调用详情';
}
```

**评分要点**：
- 工具调用数据解析 (2分)
- 工具信息提取 (2分)
- 工具调用UI展示 (1分)

### 12. 公共事件与通知功能实现（4分）

**参考答案**：

```typescript
import { notificationManager } from '@kit.NotificationKit';
import { BusinessError } from '@kit.BasicServicesKit';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
    this.sendNotification();
  }

  private sendNotification(): void {
    let notifyId = 1001;
    let notificationRequest: notificationManager.NotificationRequest = {
      id: notifyId,
      content: {
        notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
        normal: {
          title: '高德MCP查询助手',
          text: '欢迎使用高德MCP查询助手，开始您的位置服务查询吧！',
          additionalText: '应用已启动'
        }
      },
      label: 'MCP_NOTIFICATION',
      badgeIconStyle: notificationManager.BadgeStyle.NUMBER,
      showDeliveryTime: true
    };

    notificationManager.publish(notificationRequest).then(() => {
      console.info('通知发送成功');
    }).catch((err: BusinessError) => {
      console.error('通知发送失败:', err);
    });
  }
}
```

**评分要点**：
- 生命周期使用正确 (1分)
- 通知API调用 (2分)
- 通知内容配置 (1分)


## 预估时间：4-6小时
  分解：
  - 步骤1-5（UI部分）：2-2.5小时
    - 文件读取和配置解析：30分钟
    - 组件封装和列表渲染：1小时
    - 表单组件和联动逻辑：30-60分钟
  - 步骤6-7（路由跳转）：30分钟
  - 步骤8-11（网络和数据处理）：1.5-2小时
    - HTTP请求集成：30分钟
    - SSE数据解析：1-1.5小时（相对复杂）
  - 步骤12（通知功能）：15-30分钟
  - 调试和完善：30分钟-1小时

### 评分分布
- UI组件开发：22分（步骤1-5）
- 路由和页面跳转：8分（步骤6-7）
- 网络请求和数据处理：20分（步骤8-11）
- 系统功能集成：4分（步骤12）
- 代码质量和规范：5分（整体评估）
- 功能完整性：6分（整体功能测试）

### 考核重点
1. **ArkUI组件熟练度**：自定义组件创建、组件参数传递、状态管理
2. **数据绑定和渲染**：ForEach循环、条件渲染、双向数据绑定
3. **路由导航**：页面跳转、参数传递、路由配置
4. **网络编程**：HTTP请求、SSE流式数据处理、异步编程
5. **状态管理**：应用状态、页面状态、组件状态的合理管理
6. **用户体验**：Loading状态、错误处理、表单验证

### 扣分项
- 代码不规范（变量命名、缩进、注释）：扣1-2分
- 功能异常或崩溃：扣3-5分
- UI布局混乱或体验差：扣2-3分
- 未处理边界情况（网络异常、数据异常等）：扣2-4分

### 技术要点提醒
1. **状态管理装饰器**：正确使用@State、@Prop、@Link等装饰器
2. **生命周期**：合理使用aboutToAppear等生命周期方法
3. **异步处理**：使用async/await处理网络请求
4. **类型定义**：使用现有的ApiTypes中的类型定义
5. **资源管理**：使用$rawfile()读取rawfile中的配置文件
6. **错误处理**：使用try-catch处理可能的异常情况
