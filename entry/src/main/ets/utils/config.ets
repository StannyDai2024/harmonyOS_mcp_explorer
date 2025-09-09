
export interface QueryField {
  key: string;
  label: string;
  type: string;
  placeholder: string;
  required: boolean;
}

export interface QueryOptionConfig {
  type: string;
  label: string;
  description: string;
  icon: string;
  enabled: boolean;
  fields: Array<QueryField>;
}

export interface QueryConfig {
  queryOptions: Array<QueryOptionConfig>;
  version: string;
  updateTime: string;
  description: string;
}

export const queryConfigData: QueryConfig = {
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