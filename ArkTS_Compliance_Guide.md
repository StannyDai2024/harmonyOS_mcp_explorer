# ArkTS 合规性指南

本文档记录了在HarmonyOS开发过程中遇到的ArkTS合规性问题及解决方案，防止重复踩坑。

## 1. 类型安全问题

### 1.1 禁止使用 any/unknown 类型
**错误示例：**
```typescript
const sseData = JSON.parse(jsonStr); // 隐式 any 类型
const data: any = response.result;
```

**正确做法：**
```typescript
// 定义明确的接口类型
interface SSEDataItem {
  type: string;
  data: SSEData;
  // ...其他字段
}

const sseData: SSEDataItem = JSON.parse(jsonStr);
```

### 1.2 对象字面量必须有明确类型
**错误示例：**
```typescript
const requestConfig = {
  method: http.RequestMethod.POST,
  header: { 'Content-Type': 'application/json' }
};
```

**正确做法：**
```typescript
interface HttpRequestConfig {
  method: http.RequestMethod;
  header: Record<string, string>;
  // ...其他字段
}

const requestConfig: HttpRequestConfig = {
  method: http.RequestMethod.POST,
  header: { 'Content-Type': 'application/json' }
};
```

## 2. 语法限制问题

### 2.1 不支持解构赋值声明
**错误示例：**
```typescript
const [lng, lat] = location.split(',');
const { name, address } = result;
```

**正确做法：**
```typescript
const locationParts = location.split(',');
const lng = locationParts[0];
const lat = locationParts[1];

const name = result.name;
const address = result.address;
```

### 2.2 不支持对象扩展操作符
**错误示例：**
```typescript
const newRecord = { ...record, id: generateId() };
```

**正确做法：**
```typescript
const newRecord = {
  id: generateId(),
  queryText: record.queryText,
  queryParams: record.queryParams,
  result: record.result,
  timestamp: record.timestamp
};
```

### 2.3 不支持索引签名
**错误示例：**
```typescript
interface ApiData {
  [key: string]: string | number;
}
```

**正确做法：**
```typescript
interface ApiData {
  name?: string;
  value?: number;
  // 明确列出所有可能的属性
}
```

## 3. 静态方法中的 this 使用

### 3.1 静态方法中不能使用 this
**错误示例：**
```typescript
class HttpClient {
  private static readonly BASE_URL = 'https://api.example.com';
  
  static request() {
    return fetch(this.BASE_URL); // 错误：静态方法中使用 this
  }
}
```

**正确做法：**
```typescript
class HttpClient {
  private static readonly BASE_URL = 'https://api.example.com';
  
  static request() {
    return fetch(HttpClient.BASE_URL); // 使用类名而不是 this
  }
}
```

## 4. 工具类型限制

### 4.1 不支持 TypeScript 工具类型
**错误示例：**
```typescript
type SaveParams = Omit<QueryRecord, 'id' | 'timestamp'>;
type PartialRecord = Partial<QueryRecord>;
```

**正确做法：**
```typescript
// 定义明确的接口，而不是使用工具类型
interface SaveQueryRecordParams {
  queryText: string;
  queryParams: QueryParams;
  result: ApiResultData;
}
```

### 4.2 不支持对象字面量作为类型声明
**错误示例：**
```typescript
steps?: Array<{
  instruction: string;
  distance: string;
}>;
```

**正确做法：**
```typescript
// 定义单独的接口
interface RouteStep {
  instruction?: string;
  distance?: string;
}

steps?: Array<RouteStep>;
```

## 5. 资源引用问题

### 5.1 资源引用必须完整
**错误示例：**
```typescript
.fontColor($r('app.color.')) // 不完整的资源引用
```

**正确做法：**
```typescript
.fontColor($r('app.color.text_primary')) // 完整的资源引用
```

## 6. 开发建议

1. **提前定义接口**：在编写代码前先定义好所有需要的接口类型
2. **避免隐式类型**：所有变量和函数参数都应该有明确的类型声明
3. **使用类型断言**：需要类型转换时使用 `as` 关键字
4. **拆分复杂对象**：将复杂的嵌套对象拆分为多个简单接口
5. **静态分析工具**：使用ArkTS检查工具及时发现合规性问题

## 7. 常见错误信息对照表

| 错误信息 | 问题原因 | 解决方案 |
|---------|---------|---------|
| `arkts-no-any-unknown` | 使用了any或unknown类型 | 定义明确的接口类型 |
| `arkts-no-untyped-obj-literals` | 对象字面量没有类型声明 | 添加接口类型声明 |
| `arkts-no-destruct-decls` | 使用了解构赋值 | 改为显式的属性访问 |
| `arkts-no-spread` | 使用了扩展操作符 | 改为显式的属性复制 |
| `arkts-no-standalone-this` | 静态方法中使用this | 改为使用类名 |
| `arkts-no-utility-types` | 使用了TypeScript工具类型 | 定义明确的接口类型 |
| `arkts-no-indexed-signatures` | 使用了索引签名 | 明确列出所有属性 |
| `arkts-no-obj-literals-as-types` | 对象字面量作为类型 | 定义单独的接口 |

## 8. 检查清单

在提交代码前，请检查：

- [ ] 所有变量都有明确的类型声明
- [ ] 没有使用any/unknown类型
- [ ] 对象字面量都有对应的接口定义
- [ ] 没有使用解构赋值或扩展操作符
- [ ] 静态方法中没有使用this
- [ ] 资源引用完整且正确
- [ ] 运行ArkTS检查工具无错误