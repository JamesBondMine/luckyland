//
//  NoaTabBarController.h
//  NoaIMChatService
//
//  Created by LuckyLand on 2026/7/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// TabBar 红点 index（当前 Tab：0=消息，1=我的）
typedef NS_ENUM(NSInteger, LuckyLandTabBadgeIndex) {
    LuckyLandTabBadgeIndexSession = 0,
    LuckyLandTabBadgeIndexMine = 1,
};

@interface LuckyLandTabBarController : UITabBarController
- (void)setBadgeValue:(NSInteger)index number:(NSInteger)number;
@end

NS_ASSUME_NONNULL_END
