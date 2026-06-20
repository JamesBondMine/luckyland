//
//  NoaTeamInviteCreateVC.h
//  NoaKit
//
//  Created by ppppphl on 2025/7/22.
//

#import "LuckyLandBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^CreateGroupSuccessHandle)(void);
@interface NoaTeamInviteCreateVC : LuckyLandBaseViewController

/// 创建团队成功，返回刷新页面
@property (nonatomic, copy) CreateGroupSuccessHandle createGroupSuccessHandle;

@end

NS_ASSUME_NONNULL_END
