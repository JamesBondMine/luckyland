//
//  LuckyLandMyCollectionViewController.h
//  NoaKit
//
//  Created by LuckyLand on 2023/4/19.
//

#import "LuckyLandBaseViewController.h"
#import "NoaMyCollectionItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LuckyLandMyCollectionViewController : LuckyLandBaseViewController

@property (nonatomic, assign)BOOL isFromChat;
@property (nonatomic, copy) NSString *chatSession;
@property (nonatomic, assign)CIMChatType chatType;
//发送收藏的消息(转发)
@property (nonatomic, copy) void(^sendCollectionMsgBlock)(NoaMyCollectionItemModel *collectionMsg);

@end

NS_ASSUME_NONNULL_END
