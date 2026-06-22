//
//  LuckyLandCharacterRegisterViewController.h
//  NoaKit
//
//  Created by LuckyLand on 2023/9/15.
//

#import "LuckyLandBaseViewController.h"

@class LuckyLandCharacterManagerViewController;

NS_ASSUME_NONNULL_BEGIN

@interface LuckyLandCharacterRegisterViewController : LuckyLandBaseViewController

@property (nonatomic, assign) BOOL isFromBind;
@property (nonatomic, assign) BOOL isBinded;
//注册登录绑定结果
@property (nonatomic, copy) void(^chartManageBindResult)(BOOL result);

@end

NS_ASSUME_NONNULL_END
