// API相关的类型定义

// 查询类型枚举
export enum QueryType {
  WEATHER = 'weather',
  POI = 'poi',
  NEARBY = 'nearby',
  DISTANCE = 'distance',
  CYCLING = 'cycling'
}

// 动态表单字段定义
export interface QueryField {
  key: string;
  label: string;
  type: string;
  placeholder: string;
  required: boolean;
}

// 查询选项配置
export interface QueryOptionConfig {
  type: string;
  label: string;
  description: string;
  icon: string;
  enabled: boolean;
  fields: Array<QueryField>;
}

// 配置文件结构
export interface QueryConfig {
  queryOptions: Array<QueryOptionConfig>;
}

// API请求体
export interface ApiRequest {
  query: string;
}

// 工具调用结果接口
export interface ToolResult {
  id?: string;
  name?: string;
  status?: string;
  request?: Record<string, string | number>;
  response?: Array<ResponseItem>;
}

export interface ResponseItem {
  type?: string;
  text?: string;
  annotations?: Record<string, string | number> | null;
  meta?: Record<string, string | number> | null;
}

// 通用API结果数据结构
export interface ApiResultData {
  // 基础信息
  message?: string;
  status?: string;

  // SSE流式响应相关
  toolResults?: Array<ToolResult>;
}

// API响应体
export interface ApiResponse {
  success: boolean;
  data?: ApiResultData;
  message?: string;
  error?: string;
}

// 路由参数
export interface RouteParams {
  queryType: string;
  queryText: string;
}


export interface SSEDataItem {
  request_id?: string;
  agent_id?: string;
  user_id?: string;
  conversation_id?: string;
  type: string;
  data: SSEData;
  usage: object | null;
  model_name: string | null;
  time: string;
}

interface SSEData {
  id?: string;
  name?: string;
  tool_type?: string;
  message?: string;
  status?: string;
  request?: object;
  response?: Array<SSEResponseItem>;
  content?: string;
  reasoning_content?: string;
  url: string | null;
  raw?: object;
}

interface SSEResponseItem {
  type: string;
  text: string;
  annotations: object | null;
  meta: object | null;
}
