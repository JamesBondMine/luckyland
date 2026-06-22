//
//  LuckyLandFriendManageVC.h
//  NoaKit
//
//  Created by LuckyLand on 2026/10/22.
//

// 好友管理VC

#import "LuckyLandBaseViewController.h"
#import "NoaUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LuckyLandFriendManageVC : LuckyLandBaseViewController
@property (nonatomic, strong) NoaUserModel *userModel;
@property (nonatomic, copy) NSString *friendUID;
@end

NS_ASSUME_NONNULL_END
