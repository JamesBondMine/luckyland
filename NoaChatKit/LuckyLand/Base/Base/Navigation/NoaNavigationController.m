//
//  NoaNavigationController.m
//  NoaIMChatService
//
//  Created by LuckyLand on 2026/7/8.
//

#import "NoaNavigationController.h"

@interface NoaNavigationController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation NoaNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
    //解决滑动返回手势失效问题
    self.interactivePopGestureRecognizer.delegate = (id)self;
}


#pragma mark - iPadOS 26 TabBar 修复

/// iPadOS 26 上 hidesBottomBarWhenPushed 会破坏 TabBar 状态，导致 push 第三级或 pop 后界面卡死。
/// 参考: https://developer.apple.com/forums/thread/789148
- (BOOL)noa_shouldAvoidHidesBottomBarWhenPushed {
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPad) {
        return NO;
    }
    NSString *systemVersion = UIDevice.currentDevice.systemVersion;
    return [systemVersion compare:@"26.0" options:NSNumericSearch] != NSOrderedAscending;
}

- (void)noa_syncTabBarHiddenAnimated:(BOOL)animated {
    if (![self noa_shouldAvoidHidesBottomBarWhenPushed]) {
        return;
    }

    UITabBarController *tabBarController = self.tabBarController;
    if (!tabBarController) {
        return;
    }

    BOOL shouldHide = self.viewControllers.count > 1;
    if (@available(iOS 18.0, *)) {
//        [tabBarController setTabBarHidden:shouldHide animated:animated];
    } else {
        tabBarController.tabBar.hidden = shouldHide;
    }
}

#pragma mark - UINavigationControllerDelegate
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //全局隐藏导航栏
    [navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //全局隐藏导航栏
    [navigationController setNavigationBarHidden:YES animated:animated];
    [self noa_syncTabBarHiddenAnimated:animated];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    //左滑如果上一级是根视图，有时会界面卡死的处理
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        if (self.viewControllers.count < 2) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - 跳转处理
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = [self noa_shouldAvoidHidesBottomBarWhenPushed] ? NO : YES;
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark - 状态栏处理
// 状态栏模式交给topViewController控制
- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

// 状态栏显示、隐藏交给topViewController控制
- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
