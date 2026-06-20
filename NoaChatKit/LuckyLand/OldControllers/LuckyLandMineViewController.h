//
//  NoaMineVC.h
//  NoaKit
//
//  Created by Apple on 2026/9/2.
//

#import "CandyBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LuckyLandMineViewController : CandyBaseViewController

/// 以抽屉样式从当前顶部导航 present 出 ZMineVC（带去重）
+ (void)presentMineDrawerFromTop;

@end

NS_ASSUME_NONNULL_END
