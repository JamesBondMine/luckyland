//
//  NoaGroupNoticeDetailVC.h
//  NoaKit
//
//  Created by LuckyLand on 2025/8/11.
//

#import <Foundation/Foundation.h>
#import "LuckyLandBaseViewController.h"
#import "LingIMGroup.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoaGroupNoticeDetailVC : LuckyLandBaseViewController

@property (nonatomic,strong) LingIMGroup * groupInfoModel;

@property (nonatomic, strong) NoaGroupNoteModel *groupNoticeModel;

@property (nonatomic, copy) void(^deleteNoticyCallback)(void);

@end

NS_ASSUME_NONNULL_END
