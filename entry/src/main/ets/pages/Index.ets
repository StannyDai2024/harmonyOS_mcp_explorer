import { router } from '@kit.ArkUI';
import { queryConfigData, QueryOptionConfig, QueryField } from '../utils/config'
import { QueryType, QueryParams, WeatherParams, POIParams, NearbyParams, CyclingParams, DistanceParams  } from '../types/ApiTypes';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State selectedType: string = QueryType.WEATHER;
  availableOptions = queryConfigData.queryOptions;
  @State selectedOption: QueryOptionConfig = this.availableOptions.filter((item) => item.type ===this.selectedType)[0] as QueryOptionConfig;
  // 动态表单字段
  @State formData: Record<string, string> = {};

  private resetFormData() {
    this.formData = {};
    if (this.selectedOption) {
      this.selectedOption.fields.forEach(field => {
        this.formData[field.key] = '';
      });
    }
  }

  handleQuery() {
    // 验证必填字段
    const missingFields: string[] = [];
    this.selectedOption.fields.forEach(field => {
      if (field.required && (!this.formData[field.key] || this.formData[field.key].trim() === '')) {
        missingFields.push(field.label);
      }
    });

    if (missingFields.length > 0) {
      console.error('缺少必填字段:', missingFields.join(', '));
      // 这里可以显示提示信息
      return;
    }

    // 构建查询参数
    const queryParams = this.buildQueryParams();
    const queryText = this.buildQueryText();

    console.log('查询参数:', JSON.stringify(queryParams, null, 2));
    console.log('查询文本:', queryText);

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

  buildQueryParams(): QueryParams {
    switch (this.selectedType) {
      case QueryType.WEATHER:
        return {
          type: QueryType.WEATHER,
          location: this.formData['location'] || ''
        } as WeatherParams;

      case QueryType.POI:
        return {
          type: QueryType.POI,
          address: this.formData['address'] || ''
        } as POIParams;

      case QueryType.NEARBY:
        return {
          type: QueryType.NEARBY,
          location: this.formData['location'] || '',
          keyword: this.formData['keyword'] || ''
        } as NearbyParams;

      case QueryType.DISTANCE:
        return {
          type: QueryType.DISTANCE,
          startLocation: this.formData['startLocation'] || '',
          endLocation: this.formData['endLocation'] || ''
        } as DistanceParams;

      case QueryType.CYCLING:
        return {
          type: QueryType.CYCLING,
          startLocation: this.formData['startLocation'] || '',
          endLocation: this.formData['endLocation'] || ''
        } as CyclingParams;

      default:
        return {
          type: QueryType.WEATHER,
          location: ''
        } as WeatherParams;
    }
  }

  buildQueryText(): string {
    if (!this.selectedOption) return '';

    const fieldValues = this.selectedOption.fields.map(field => {
      const value = this.formData[field.key] || '';
      return `${field.label}: ${value}`;
    }).join(', ');

    return `${this.selectedOption.label} - ${fieldValues}`;
  }

  build() {
    Scroll() {
      Column({ space: 10 }) {
        Text('高德MCP查询助手')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          // .fontColor($r('app.color.text_primary'))
          // .layoutWeight(1)
        Divider().strokeWidth(1)

        Column({ space:12 }) {
          Text('选择查询功能')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .alignSelf(ItemAlign.Start)

          ForEach(this.availableOptions, (option: QueryOptionConfig) => {
            this.buildOptionCard(option)
          })
        }
        .width('100%')
        .padding({ left: 16, right: 16 })

        Divider().strokeWidth(1)
        this.buildDynamicForm()

        // 查询按钮
        Button('开始查询')
          .width('80%')
          .height(50)
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .backgroundColor($r('app.color.brand_primary'))
          .margin({ top: 20, bottom: 30 })
          .onClick(() => {
            this.handleQuery()
          })

      }
      .width('100%')
      // .height('100%')
      .padding({ left: 16, right: 16 })
      .backgroundColor($r('app.color.background'))
    }
    .height('100%')
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


  @Builder
  buildDynamicForm() {
    Column({ space: 16 }) {
      Text('输入查询条件')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .alignSelf(ItemAlign.Start)
        .margin({ left: 16 })


      Column({ space: 12 }) {
        if (this.selectedOption) {
          ForEach(this.selectedOption.fields, (field: QueryField) => {
            this.buildConfigurableInputField(field)
          })
        }
      }
      .width('100%')
      .padding({ left: 16, right: 16 })
    }
    .width('100%')
  }

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
}