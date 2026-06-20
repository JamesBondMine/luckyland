//
//  FlutterTallkMineViewController.h
//  CandyTalk
//

#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlutterTallkMineViewController : FlutterViewController


/// 以抽屉样式从当前顶部导航 present 出 ZMineVC（带去重）
+ (void)presentMineDrawerFromTop;


@end

NS_ASSUME_NONNULL_END
