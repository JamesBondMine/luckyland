//
//  LuckyLandSafeCodeAuthViewController.h
//  NoaKit
//
//  Created by LuckyLand on 2024/12/30.
//

#import "LuckyLandBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LuckyLandSafeCodeAuthViewController : LuckyLandBaseViewController

@property (nonatomic, copy)NSString *loginInfo;
@property (nonatomic, assign)int loginType;
@property (nonatomic, copy)NSString *scKey;

@end

NS_ASSUME_NONNULL_END
