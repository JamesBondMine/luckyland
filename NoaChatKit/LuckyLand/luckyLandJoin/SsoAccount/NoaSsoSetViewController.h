//
//  NoaSsoSetViewController.h
//  NoaKit
//
//  Created by Candy on 2026/9/1.
//

#import "LuckyLandLoginBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoaSsoSetViewController : LuckyLandLoginBaseViewController

/// 是否是rootController
@property (nonatomic, assign) BOOL isRoot;

/// 是否是修改幸运数字
@property (nonatomic, assign) BOOL isReset;

//设置了SSO信息
@property (nonatomic, copy) void(^configSsoInfoFinish)(void);

/// 设置UI布局
- (void)setupSsoSetUI;

/// 是否是悬浮窗模式
@property (nonatomic, assign) BOOL isPopWindows;

@end

NS_ASSUME_NONNULL_END
