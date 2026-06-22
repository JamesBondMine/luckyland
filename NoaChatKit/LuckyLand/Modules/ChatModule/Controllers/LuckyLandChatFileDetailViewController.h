//
//  LuckyLandChatFileDetailViewController.h
//  NoaKit
//
//  Created by LuckyLand on 2023/4/11.
//

#import "LuckyLandBaseViewController.h"
#import "NoaMessageModel.h"
#import "NoaMyCollectionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LuckyLandChatFileDetailViewController : LuckyLandBaseViewController

@property (nonatomic, strong)NoaMessageModel *fileMsgModel;
@property (nonatomic, copy)NSString *localFilePath;
@property (nonatomic, copy)NSString *fromSessionId;
@property (nonatomic, assign)BOOL isShowRightBtn;

@property (nonatomic, assign)BOOL isFromCollcet;//是否从收藏列表进入的
@property (nonatomic, strong)NoaMyCollectionModel *collectionMsgModel;//收藏消息的model

@end

NS_ASSUME_NONNULL_END
