//
//  NoaGroupQRCodeVC.h
//  NoaKit
//
//  Created by LuckyLand on 2026/11/7.
//

#import "LuckyLandBaseViewController.h"
#import "LingIMGroup.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoaGroupQRCodeVC : LuckyLandBaseViewController

@property (nonatomic, strong)LingIMGroup * groupInfoModel;
@property (nonatomic, copy)NSString *qrcoceContent;
@property (nonatomic, assign) NSInteger expireTime; //过期时间
@end

NS_ASSUME_NONNULL_END
