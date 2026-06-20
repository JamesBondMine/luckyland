//
//  NoaPasswordViewController.h
//  NoaKit
//
//  Created by Candy on 2026/9/19.
//

#import "LuckyLandBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoaPasswordViewController : LuckyLandBaseViewController

@property (nonatomic, strong)NSString *areaCode;
@property (nonatomic, strong)NSString *loginInfo;

//这里改成枚举
@property (nonatomic, assign)int loginType;
@property (nonatomic, assign)BOOL pwdExit;

@end

NS_ASSUME_NONNULL_END
