//
//  NoaNetworkDetectionVC.h
//  NoaChatKit
//
//  Created by phl on 2025/10/15.
//

#import "CandyBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoaNetworkDetectionVC : CandyBaseViewController

/// 当前幸运数字(未登录时可为空)
@property (nonatomic, copy, nullable) NSString *currentSsoNumber;

@end

NS_ASSUME_NONNULL_END
