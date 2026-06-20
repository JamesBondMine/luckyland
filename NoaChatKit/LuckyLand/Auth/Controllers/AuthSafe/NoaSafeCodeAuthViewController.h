//
//  NoaSafeCodeAuthViewController.h
//  NoaKit
//
//  Created by Candy on 2024/12/30.
//

#import "LuckyLandBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoaSafeCodeAuthViewController : LuckyLandBaseViewController

@property (nonatomic, copy)NSString *loginInfo;
@property (nonatomic, assign)int loginType;
@property (nonatomic, copy)NSString *scKey;

@end

NS_ASSUME_NONNULL_END
