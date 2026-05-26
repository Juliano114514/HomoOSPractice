import { Log } from 'core';
import { RouterManager } from 'core';
import { FeedScreen } from 'feature_feed';
import { VideoScreen } from 'feature_video';
import { ProfileScreen } from 'feature_profile';
import { MusicScreen, MusicPlayerScreen } from 'feature_music';
import { MemoScreen } from 'feature_memo';
import { ChapterScreen } from 'chapters'

@Entry
@Component
struct Index {
  @Provide('pageInfos') pageInfos: NavPathStack = RouterManager.getInstance().getStack()
  @State currentIndex: number = 0

  // 自定义 TabBar
  @Builder
  tabBuilder(title: string, targetIndex: number, iconStr: string) {
    Column() {
      Text(iconStr)
        .fontSize(24)
        .fontColor(this.currentIndex === targetIndex ? '#007DFF' : '#999999')
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? '#007DFF' : '#999999')
        .fontSize(12)
        .margin({ top: 4 })
    }
    .onClick(()=>{
      this.currentIndex = targetIndex
      Log.debug('IndexPage', `Switched to Tab: ${title}`);
    })
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }

  build(){
    Navigation(this.pageInfos){
      Tabs({barPosition: BarPosition.End, index: this.currentIndex}){
        TabContent() { FeedScreen() }.tabBar(this.tabBuilder('首页', 0, '🏠'))
        TabContent() { VideoScreen() }.tabBar(this.tabBuilder('视频', 1, '🎬'))
        TabContent() { MusicScreen() }.tabBar(this.tabBuilder('音乐', 2, '🎵'))
        TabContent() { ProfileScreen() }.tabBar(this.tabBuilder('我的', 3, '👤'))
        TabContent() { ChapterScreen() }.tabBar(this.tabBuilder('课程', 4, '📚'))
        TabContent() { MemoScreen() }.tabBar(this.tabBuilder('待办', 5, '📝'))
      }
      .onChange((index: number) => {
        this.currentIndex = index;
      })
    }
    .mode(NavigationMode.Stack) // 强制使用堆叠模式，适用于手机端
    .hideTitleBar(true)         // 隐藏系统默认标题栏，方便全面自定义UI
    .navDestination(this.pageMap) // 绑定全局路由映射表
  }


  // 统一路由分发图：在此处通过名称匹配并渲染对应的目标页面
  @Builder pageMap(name: string, param: Object) {
    if (name === 'VideoDetail') {
      // 等待后续开发：VideoDetailScreen({ videoId: param as string })
    } else if (name === 'LessonConcurrency') {
      // 等待后续开发：LessonConcurrencyScreen()
    } else if (name === 'MusicPlayer') {     // ====== 新增音乐播放页路由分发 ======
      MusicPlayerScreen()
    }
  }
}