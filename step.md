# 开发向导

本文指导如何一步步开发出当前的应用。

## 考点
1. arkUI 组件使用（基础组件、布局组件）
2. 自定义组件
3. 状态管理
4. 生命周期
5. 配置新页面路由跳转
6. 路由参数解析
7. HTTP 请求、结果解析
8. 条件渲染、循环渲染

## 步骤拆分

大致部分拆分如下：
1. 实现 UI
    - 导入配置，本地加载
    - 实现标题，
    - 实现 ForEach 列表
    - 实现 dynamicForm 自定义组件
    - 新建并配置结果页
2. 实现路由跳转
    - 实现跳转逻辑，结果页顶部返回按钮逻辑实现
    - 路由参数解析，并在结果页展示出来查询信息
3. 实现数据请求，封装 mcp 服务接口
    - sse 结果解析
4. 实现结果页数据结果展示
    - 展示工具调用
    - 展示最终message 结果
5. 实现请求失败兜底展示
6. 实现重新查询按钮逻辑

### 核心配置文件

查询功能模块配置文件如下，配置文件中定义了：
1. 查询的功能列表信息
2. 选中功能后需要填写哪些表单输入信息

基于这份配置文件实现 index 页面 UI：
1. 功能选择模块
2. dynamicForm 动态表单

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
  ],
  version: '1.0.0',
  updateTime: '2025-09-08',
  description: '高德MCP查询功能配置'
};

```
