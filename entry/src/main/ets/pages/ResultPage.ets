import { router } from '@kit.ArkUI'
import { QueryParams, RouteParams, ApiRequest, ApiResponse, ApiResultData, POIParams, NearbyParams, CyclingParams, DistanceParams } from '../types/ApiTypes';
import { HttpClient } from '../utils/HttpClient';

@Entry
@Component
struct ResultPage {
  @State queryParams?: QueryParams = undefined;
  @State queryText: string = '';
  @State loading: boolean = false;
  @State result?: ApiResultData = undefined;
  @State error: string = '';

  aboutToAppear() {
    this.loadRouteParams();
  }

  onPageShow() {
    this.performQuery();
  }

  build() {
    Column({ space: 16 }) {
      // 标题栏
      this.buildTitleBar()
      // 查询信息展示
      this.buildQueryInfo()
      // 查询结果展示
      this.buildQueryResult();
    }
    .height('100%')
    .backgroundColor($r('app.color.background'))
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

  loadRouteParams() {
    try {
      const params = router.getParams() as RouteParams;
      console.log('params', JSON.stringify(params, null, 2))
      if (params) {
        this.queryParams = params.queryParams;
        this.queryText = params.queryText || '';
      }
    } catch (error) {
      console.error('获取路由参数失败：', error);
      this.error = '页面参数获取失败';
    }
  }

  @Builder
  buildTitleBar() {
    Row() {
      Button() {
        Text('←')
          .fontSize(24)
          .fontColor($r('app.color.text_primary'))
      }
      .width(40)
      .height(40)
      .backgroundColor(Color.Transparent)
      .onClick(() => {
        router.back();
      })

      Text('查询结果')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary'))
        .layoutWeight(1)
        .textAlign(TextAlign.Center)

      // 占位按钮，保持标题居中
      Button() {
        // 空白占位
      }
      .width(40)
      .height(40)
      .backgroundColor(Color.Transparent)
    }
    .width('100%')
    .height(56)
    .padding({ left: 16, right: 16 })
    .backgroundColor($r('app.color.surface'))
  }


  @Builder
  buildQueryInfo() {
    Column({ space: 12 }) {
      Text('查询信息')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.text_primary'))
        .alignSelf(ItemAlign.Start)

      Column({ space: 8 }) {
        Row() {
          Text('查询类型：')
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
          Text(this.getQueryTypeLabel())
            .fontSize(14)
            .fontColor($r('app.color.text_primary'))
            .fontWeight(FontWeight.Medium)
        }
        .alignItems(VerticalAlign.Center)
        .alignSelf(ItemAlign.Start)

        Row() {
          Text('查询内容：')
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
          Text(this.queryText)
            .fontSize(14)
            .fontColor($r('app.color.text_primary'))
            .layoutWeight(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(2)
        }
        .alignItems(VerticalAlign.Top)
        .alignSelf(ItemAlign.Start)
        .width('100%')
      }
      .width('100%')
    }
    .width('100%')
    .padding(16)
    .backgroundColor($r('app.color.surface'))
    .borderRadius(8)
  }

  @Builder
  buildQueryResult() {
    // 加载状态或结果展示
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
    .width('100%')
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
        .fontColor($r('app.color.text_primary'))

      Text(this.error)
        .fontSize(14)
        .fontColor($r('app.color.text_secondary'))
        .textAlign(TextAlign.Center)
        .maxLines(3)

      Button('重新查询')
        .width(120)
        .height(40)
        .fontSize(16)
        .backgroundColor($r('app.color.brand_primary'))
        .onClick(() => {
          this.error = '';
          this.performQuery();
        })
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height(300)
  }

  @Builder
  buildResultView() {
    Scroll() {
      Column({ space: 16 }) {
        Text('查询结果')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_primary'))
          .alignSelf(ItemAlign.Start)

        Column({ space: 12 }) {
          Text(JSON.stringify(this.result, null, 2))
            .fontSize(14)
            .fontColor($r('app.color.text_primary'))
            .backgroundColor($r('app.color.surface'))
            .padding(16)
            .borderRadius(8)
            .width('100%')
            .copyOption(CopyOptions.InApp)
        }
        .width('100%')

        // 操作按钮
        Row({ space: 8 }) {
          Button('返回')
            .width(0)
            .height(44)
            .fontSize(16)
            .backgroundColor($r('app.color.surface'))
            .fontColor($r('app.color.text_primary'))
            .layoutWeight(1)
            .onClick(() => {
              router.back();
            })
        }
        .width('100%')
        .margin({ top: 20 })
      }
      .width('100%')
      .padding(16)
    }
  }

  getQueryTypeLabel(): string {
    if (!this.queryParams) return '';

    switch (this.queryParams.type) {
      case 'weather': return '天气查询';
      case 'poi': return 'POI查询';
      case 'nearby': return '周边搜索';
      case 'distance': return '距离测量';
      case 'cycling': return '骑行规划';
      default: return '未知类型';
    }
  }
}