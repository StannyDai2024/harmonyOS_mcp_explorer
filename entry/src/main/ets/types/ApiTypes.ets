// API相关的类型定义

// 查询类型枚举
export enum QueryType {
  WEATHER = 'weather',
  POI = 'poi',
  NEARBY = 'nearby',
  DISTANCE = 'distance',
  CYCLING = 'cycling'
}

// 查询类型选项
export interface QueryOption {
  type: QueryType;
  label: string;
  description: string;
}

// 基础查询参数接口
export interface BaseQueryParams {
  type: QueryType;
}

// 天气查询参数
export interface WeatherParams extends BaseQueryParams {
  location: string;
}

// POI查询参数
export interface POIParams extends BaseQueryParams {
  address: string;
}

// 周边搜索参数
export interface NearbyParams extends BaseQueryParams {
  location: string;
  keyword: string;
}

// 距离测量参数
export interface DistanceParams extends BaseQueryParams {
  startLocation: string;
  endLocation: string;
}

// 骑行路径规划参数
export interface CyclingParams extends BaseQueryParams {
  startLocation: string;
  endLocation: string;
}

// 联合查询参数类型
export type QueryParams = WeatherParams | POIParams | NearbyParams | DistanceParams | CyclingParams;

// API请求体中的消息项
export interface ApiRequestMessage {
  role: 'user' | 'assistant' | 'tool';
  content: string;
}

// API请求体
export interface ApiRequest {
  query: string;
  memory?: Array<ApiRequestMessage>;
}

// 路径规划步骤
export interface RouteStep {
  instruction?: string;
  distance?: string;
  duration?: string;
}

// 周边搜索结果项
export interface NearbyResult {
  name?: string;
  address?: string;
  phone?: string;
  latitude?: number;
  longitude?: number;
  distance?: string;
}

// 通用API结果数据结构
export interface ApiResultData {
  // 基础信息
  message?: string;
  status?: string;

  // SSE流式响应相关
  toolResults?: Array<object>;
  totalMessages?: number;
  totalTools?: number;
  locationData?: Array<object>;

  // 位置相关信息
  latitude?: number;
  longitude?: number;
  lat?: number;
  lng?: number;
  location?: string;
  address?: string;

  // POI相关信息
  name?: string;
  type?: string;
  distance?: string;

  // 联系方式
  phone?: string;
  tel?: string;

  // 天气信息
  weather?: string;
  temperature?: string;
  humidity?: string;
  wind?: string;

  // 路径规划
  steps?: Array<RouteStep>;

  // 周边搜索结果
  results?: Array<NearbyResult>;

  // 常见的其他字段
  id?: string;
  code?: string;
  success?: boolean;
  error?: string;
  data?: object;
  count?: number;
  total?: number;
  page?: number;
  size?: number;
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
  queryParams: QueryParams;
  queryText: string;
  cachedResult?: ApiResultData;
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
