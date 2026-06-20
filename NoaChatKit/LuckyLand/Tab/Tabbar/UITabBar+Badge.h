//
//  UITabBar+Badge.h
//  NoaIMChatService
//
//  Created by LuckyLand on 2026/7/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBar (Badge)
/// tabbar 红点显示（使用系统 UITabBarItem.badgeValue，兼容 iOS 26 Liquid Glass）
/// @param index 下标
/// @param textStr 显示的内容(如果只想显示红点@"")
/// @param badgeSize 保留参数，系统 badge 不使用
/// @param tapBlock 保留参数，系统 badge 不支持点击回调
- (void)showBadgeAtItemIndex:(NSInteger)index textStr:(NSString *)textStr size:(CGSize)badgeSize tapBlock:(void(^)(void))tapBlock;


/// tabbar红点隐藏
/// @param index 下标
- (void)hideBadgeAtItemIndex:(NSInteger)index;


@end

NS_ASSUME_NONNULL_END
