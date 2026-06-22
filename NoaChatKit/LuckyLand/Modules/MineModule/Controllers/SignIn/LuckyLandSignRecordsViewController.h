//
//  LuckyLandSignRecordsViewController.h
//  NoaKit
//
//  Created by Apple on 2023/8/9.
//

#import "LuckyLandBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LuckyLandSignRecordsViewController : LuckyLandBaseViewController
@property(nonatomic,strong) NSArray * signInRecords;
@property(nonatomic,copy) NSString * totalLoyalty;
@end

NS_ASSUME_NONNULL_END
