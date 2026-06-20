//
//  ZGroupTopMessageListViewController.h
//  NoaChatKit
//
//  Created by Auto on 2025/1/15.
//

#import "LuckyLandBaseViewController.h"
#import "LingIMGroup.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZGroupTopMessageListViewController : LuckyLandBaseViewController

/// 群组ID（群聊时使用）
@property (nonatomic, strong) NSString *groupId;
/// 群信息（群聊时使用）
@property (nonatomic, strong) LingIMGroup *groupInfo;
/// 会话类型（0单聊 1群聊）
@property (nonatomic, assign) CIMChatType chatType;
/// 好友ID（单聊时使用）
@property (nonatomic, strong) NSString *friendUid;

@end

NS_ASSUME_NONNULL_END

