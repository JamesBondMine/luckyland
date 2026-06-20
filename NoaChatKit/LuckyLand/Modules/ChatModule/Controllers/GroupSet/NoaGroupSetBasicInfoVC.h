//
//  NoaGropuSetBasicInfoVC.h
//  NoaKit
//
//  Created by LuckyLand on 2026/11/7.
//

#import "LuckyLandBaseViewController.h"
#import "LingIMGroup.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoaGroupSetBasicInfoVC : LuckyLandBaseViewController

@property (nonatomic,strong)LingIMGroup * groupInfoModel;

- (void)reloadCurData;

@end

NS_ASSUME_NONNULL_END
