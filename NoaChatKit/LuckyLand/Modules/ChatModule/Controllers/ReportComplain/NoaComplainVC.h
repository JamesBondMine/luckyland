//
//  NoaComplainVC.h
//  NoaKit
//
//  Created by LuckyLand on 2023/6/19.
//

#import "LuckyLandBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoaComplainVC : LuckyLandBaseViewController
@property (nonatomic, copy) NSString *complainID;//投诉ID
@property (nonatomic, assign) CIMChatType complainType;//投诉类型 群聊 好友
/// 举报消息时预填的投诉说明
@property (nonatomic, copy, nullable) NSString *prefillComment;
@end

NS_ASSUME_NONNULL_END
