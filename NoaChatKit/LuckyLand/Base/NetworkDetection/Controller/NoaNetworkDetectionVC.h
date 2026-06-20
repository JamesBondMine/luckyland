//
//  NoaNetworkDetectionVC.h
//  NoaChatKit
//
//  Created by ppppphl on 2025/10/15.
//

#import "LuckyLandBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoaNetworkDetectionVC : LuckyLandBaseViewController

/// 当前幸运数字(未登录时可为空)
@property (nonatomic, copy, nullable) NSString *currentSsoNumber;

@end

NS_ASSUME_NONNULL_END
