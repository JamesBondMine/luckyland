//
//  LuckyLandLanguageSetViewController.h
//  NoaKit
//
//  Created by LuckyLand on 2026/12/28.
//

#import "LuckyLandBaseViewController.h"

//设置语言后，修改UI类型
typedef NS_ENUM(NSUInteger, LanguageChangeUIType) {
    LanguageChangeUITypeLogin = 1,         //更新登录页
    LanguageChangeUITypeTabbar = 2,        //更新Tabbar页
};

NS_ASSUME_NONNULL_BEGIN

@interface LuckyLandLanguageSetViewController : LuckyLandBaseViewController
@property (nonatomic, assign) LanguageChangeUIType changeType;
@end

NS_ASSUME_NONNULL_END
