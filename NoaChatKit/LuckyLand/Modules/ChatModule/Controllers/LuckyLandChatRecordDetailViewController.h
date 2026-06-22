//
//  LuckyLandChatRecordDetailViewController.h
//  NoaKit
//
//  Created by LuckyLand on 2023/4/25.
//

#import "LuckyLandBaseViewController.h"
#import "NoaMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LuckyLandChatRecordDetailViewController : LuckyLandBaseViewController

@property (nonatomic, assign) NSInteger levelNum;
@property (nonatomic, strong) NoaMessageModel *model;

@end

NS_ASSUME_NONNULL_END
