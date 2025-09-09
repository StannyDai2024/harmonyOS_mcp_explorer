import { http } from '@kit.NetworkKit';
import { ApiRequest, ApiResponse, ApiResultData, SSEDataItem } from '../types/ApiTypes';

export class HttpClient {
  private static readonly BASE_URL = 'https://aiae.appstage.myhuaweicloud.com/v1/routes/open/50c8ca0fb08e4c80878538af967d324f/execute';
  private static readonly AUTH_TOKEN = 'Bearer sk-055a0a667b860d15deb72ae0344d180e74c964a7f66e514734fbd3240f97c832';

  static async request(requestData: ApiRequest): Promise<ApiResponse>  {
    console.log('=== HTTP Request Started ===');
    console.log('请求URL:', HttpClient.BASE_URL);
    console.log('请求数据:', JSON.stringify(requestData, null, 2));
    const httpRequest = http.createHttp();
    try {
      const response = await httpRequest.request(HttpClient.BASE_URL, {
        method: http.RequestMethod.POST,
        header: {
          'Authorization': HttpClient.AUTH_TOKEN,
          'Content-Type': 'application/json'
        },
        extraData: JSON.stringify(requestData),
        // 超时可能比较严重，这里设置为 2min
        connectTimeout: 120000,
        readTimeout: 120000,
      });

      console.log('=== HTTP Response Received ===');
      console.log('响应状态码:', response.responseCode);
      console.log('响应头:', JSON.stringify(response.header, null, 2));
      console.log('响应数据长度:', (response.result as string).length);
      console.log('响应数据前100字符:', (response.result as string).substring(0, 100));

      return HttpClient.parseSSE(response)
    } catch (error) {
      console.error('=== HTTP Request Error ===');
      console.error('错误类型:', typeof error);
      console.error('错误信息:', (error as Error).message || error.toString());
      console.error('错误详情:', error);
      return {
        success: false,
        error: '网络请求异常',
        message: (error as Error).message || '未知错误'
      };

    } finally {
      console.log('销毁HTTP请求实例...');
      httpRequest.destroy();
    }
  }

  static parseSSE(response: http.HttpResponse): ApiResponse {
    if (response.responseCode !== 200) {
      console.error('HTTP请求失败 - 状态码:', response.responseCode);
      console.error('失败响应内容:', response.result);
      return {
        success: false,
        error: `请求失败，状态码：${response.responseCode}`,
        message: response.result as string
      };
    }

    console.log('响应成功，解析SSE流式数据...');
    const responseText = response.result as string;

    // 解析SSE流式响应
    const sseLines = responseText.split('\n');
    console.log('SSE行数:', sseLines.length);

    let combinedContent = '';
    let toolResults: Array<object> = [];
    let messages: Array<string> = [];
    for (let line of sseLines) {
      line = line.trim();

      // 跳过空行和结束标记
      if (!line || line === 'data: [DONE]') {
        continue;
      }

      // 处理data:行
      if (line.startsWith('data: ')) {
        // 获取 data: 之后的 json 串
        const jsonStr = line.substring(6);
        try {
          const sseData: SSEDataItem = JSON.parse(jsonStr);
          console.log('解析SSE数据项:', JSON.stringify(sseData, null, 2));

          // 根据type处理不同类型的数据
          if (sseData.type === 'tool' && sseData.data) {
            console.log('发现工具调用结果');
            toolResults.push(sseData.data);
          } else if (sseData.type === 'message' && sseData.data && sseData.data.content) {
            console.log('发现消息内容:', sseData.data.content);
            messages.push(sseData.data.content);
          }
        } catch (parseError) {
          console.warn('解析SSE数据项失败:', parseError, '原始数据:', jsonStr.substring(0, 100));
        }
      }
    }
    // 拼接所有消息内容
    combinedContent = messages.join('');
    console.log('合并后的消息内容:', combinedContent);

    // 构建最终结果
    const finalData: ApiResultData = {
      message: combinedContent,
      toolResults: toolResults,
    };
    console.log('最终构建的数据:', JSON.stringify(finalData, null, 2));
    return {
      success: true,
      data: finalData,
      message: '请求成功'
    };
  }
}