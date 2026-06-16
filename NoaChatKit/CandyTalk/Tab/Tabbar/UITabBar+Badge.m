//
//  UITabBar+Badge.m
//  NoaIMChatService
//
//  Created by Candy on 2026/7/8.
//

#import "UITabBar+Badge.h"

@implementation UITabBar (Badge)

- (UITabBarItem *)noa_tabBarItemAtIndex:(NSInteger)index {
    if (index < 0 || index >= (NSInteger)self.items.count) {
        return nil;
    }
    return self.items[index];
}

#pragma mark - 显示红点
- (void)showBadgeAtItemIndex:(NSInteger)index textStr:(NSString *)textStr size:(CGSize)badgeSize tapBlock:(nonnull void (^)(void))tapBlock {
    UITabBarItem *item = [self noa_tabBarItemAtIndex:index];
    if (!item) {
        return;
    }
    (void)badgeSize;
    (void)tapBlock;

    if (!textStr || [textStr isEqualToString:@"0"]) {
        item.badgeValue = nil;
        return;
    }
    item.badgeValue = textStr;
}

#pragma mark - 隐藏红点
- (void)hideBadgeAtItemIndex:(NSInteger)index {
    UITabBarItem *item = [self noa_tabBarItemAtIndex:index];
    if (!item) {
        return;
    }
    item.badgeValue = nil;
}

@end
