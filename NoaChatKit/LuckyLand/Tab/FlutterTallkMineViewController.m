//
//  FlutterTallkMineViewController.m
//  CandyTalk
//

#import "FlutterTallkMineViewController.h"
#import "LuckLandTeamViewController.h"//团队
#import "NoaTeamListVC.h"
#import "NoaDrawerPresentationController.h"
#import "NoaMyCollectionViewController.h"//我的收藏
#import "NoaComplainVC.h"//投诉与支持
#import "NoaLanguageSetViewController.h"//多语言
#import "NoaBlackListViewController.h"//黑名单
#import "NoaSafeSettingViewController.h"//安全设置

#import "NoaPrivacySettingViewController.h"
#import "NoaUserInfoViewController.h"//个人资料
#import "LuckyLandSystemSettingViewController.h"//系统设置

// 网络检测页面
#import "NoaNetworkDetectionVC.h"
#import "NoaDrawerPresentationController.h"
#import "NoaDrawerTransitioningDelegate.h"
#import <objc/runtime.h>

#import "LuckyLandAboutUsViewController.h"//关于我们

#import "LuckyLandSignInViewController.h" //签到页面
#import "NoaMyQRCodeViewController.h"//我的二维码
#import "NoaQRCodeModel.h"
#import <SDWebImage/SDWebImage.h>

#import "LuckLandContactVC.h"


static NSString * const kFlutterBridgeChannelName = @"com.noa.flutter/bridge";
static NSString * const kFlutterMineAvatarCachePrefix = @"flutter_mine_avatar";

@interface FlutterTallkMineViewController ()
@property (nonatomic, strong) FlutterMethodChannel *bridgeChannel;
@end

@implementation FlutterTallkMineViewController

- (instancetype)init {
    self = [super initWithProject:nil initialRoute:@"/mine" nibName:nil bundle:nil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMethodChannel];
    [self sendUserInfoToFlutter];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self sendUserInfoToFlutter];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (NSString *)flutterMineAvatarCachePathForUserId:(NSString *)userId avatar:(NSString *)avatar {
    NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *safeUserId = userId.length > 0 ? userId : @"default";
    NSString *avatarKey = avatar.length > 0 ? avatar : @"default";
    NSCharacterSet *invalidSet = [NSCharacterSet characterSetWithCharactersInString:@"/:"];
    safeUserId = [[safeUserId componentsSeparatedByCharactersInSet:invalidSet] componentsJoinedByString:@"_"];
    avatarKey = [[avatarKey componentsSeparatedByCharactersInSet:invalidSet] componentsJoinedByString:@"_"];
    if (avatarKey.length > 64) {
        avatarKey = [avatarKey substringFromIndex:avatarKey.length - 64];
    }
    return [cacheDir stringByAppendingPathComponent:
            [NSString stringWithFormat:@"%@_%@_%@.jpg", kFlutterMineAvatarCachePrefix, safeUserId, avatarKey]];
}

- (NSString *)jsonStringWithUserName:(NSString *)userName
                              userId:(NSString *)userId
                          avatarPath:(NSString *)avatarPath {
    NSDictionary *userInfo = @{
        @"userName": userName ?: @"",
        @"id": userId ?: @"",
        @"userAvatar": avatarPath ?: @""
    };
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo options:0 error:nil];
    if (!jsonData) {
        return @"{}";
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] ?: @"{}";
}

- (void)sendUserInfoToFlutter {
    if (!self.bridgeChannel) {
        return;
    }

    NSString *userName = UserManager.userInfo.nickname ?: @"";
    NSString *userId = UserManager.userInfo.userName ?: @"";
    NSString *userAvatar = UserManager.userInfo.avatar ?: @"";

    [self.bridgeChannel invokeMethod:@"initMineUserInfo"
                           arguments:[self jsonStringWithUserName:userName
                                                           userId:userId
                                                       avatarPath:@""]];

    if (userAvatar.length == 0) {
        return;
    }

    NSURL *imageURL = [userAvatar getImageFullUrl];
    if (!imageURL) {
        return;
    }

    NSString *localPath = [self flutterMineAvatarCachePathForUserId:userId avatar:userAvatar];
    if ([[NSFileManager defaultManager] fileExistsAtPath:localPath]) {
        [self.bridgeChannel invokeMethod:@"initMineUserInfo"
                               arguments:[self jsonStringWithUserName:userName
                                                               userId:userId
                                                           avatarPath:localPath]];
        return;
    }

    @weakify(self)
    [[SDWebImageManager sharedManager] loadImageWithURL:imageURL
                                                options:SDWebImageAllowInvalidSSLCertificates
                                               progress:nil
                                              completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        @strongify(self)
        if (!self || !finished) {
            return;
        }

        NSString *avatarPath = @"";
        if (image) {
            NSData *imageData = data.length > 0 ? data : UIImageJPEGRepresentation(image, 0.9);
            if (imageData.length > 0 && [imageData writeToFile:localPath atomically:YES]) {
                avatarPath = localPath;
            }
        }

        [self.bridgeChannel invokeMethod:@"initMineUserInfo"
                               arguments:[self jsonStringWithUserName:userName
                                                               userId:userId
                                                           avatarPath:avatarPath]];
    }];
}

- (void)setupMethodChannel {
    self.bridgeChannel = [FlutterMethodChannel methodChannelWithName:kFlutterBridgeChannelName
                                                     binaryMessenger:self.binaryMessenger];
    @weakify(self)
    [self.bridgeChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        @strongify(self)
        if ([call.method isEqualToString:@"mineReady"]) {
            [self sendUserInfoToFlutter];
            result(@(YES));
            return;
        }

        if (![call.method isEqualToString:@"mineSelectTap"]) {
            result(FlutterMethodNotImplemented);
            return;
        }

        NSString *action = [call.arguments isKindOfClass:[NSString class]] ? (NSString *)call.arguments : nil;
        if (action.length == 0) {
            result(FlutterMethodNotImplemented);
            return;
        }

        if ([action isEqualToString:@"back"]) {
            [self.navigationController popViewControllerAnimated:YES];
            result(@(YES));
            return;
        }

        ZLoginAndRegisterTypeMenu registerWay = NSNotFound;
        if ([action isEqualToString:@"mineTouchIndex200"]) {
            LuckLandContactVC *teamVC = [LuckLandContactVC new];
            [self openFullScreen:teamVC];
        } else if ([action isEqualToString:@"mineTouchIndex0"]) {
            NoaTeamListVC *teamVC = [NoaTeamListVC new];
            [self openFullScreen:teamVC];
        } else if ([action isEqualToString:@"mineTouchIndex1"]) {
            NoaMyCollectionViewController *myCollectionVC = [[NoaMyCollectionViewController alloc] init];
            myCollectionVC.isFromChat = NO;
            [self openFullScreen:myCollectionVC];
        } else if ([action isEqualToString:@"mineTouchIndex2"]) {
            //黑名单
            NoaBlackListViewController *blackListVC = [[NoaBlackListViewController alloc] init];
            [self openFullScreen:blackListVC];
        } else if ([action isEqualToString:@"mineTouchIndex3"]) {
            //多语言
            NoaLanguageSetViewController *languageSetVC = [[NoaLanguageSetViewController alloc] init];
            languageSetVC.changeType = LanguageChangeUITypeTabbar;
            [self openFullScreen:languageSetVC];
 
        } else if ([action isEqualToString:@"mineTouchIndex4"]) {
            //安全设置
            NoaSafeSettingViewController *safeSettingVC = [[NoaSafeSettingViewController alloc] init];
            [self openFullScreen:safeSettingVC];
        } else if ([action isEqualToString:@"mineTouchIndex5"]) {
            //隐私设置
            NoaPrivacySettingViewController *privacySettingVC = [[NoaPrivacySettingViewController alloc] init];
            [self openFullScreen:privacySettingVC];
        } else if ([action isEqualToString:@"mineTouchIndex6"]) {
            //网络检测
            NoaNetworkDetectionVC *vc = [NoaNetworkDetectionVC new];
            NoaSsoInfoModel *ssoModel = [NoaSsoInfoModel getSSOInfo];
            vc.currentSsoNumber = ssoModel.liceseId;
            [self openFullScreen:vc];
        } else if ([action isEqualToString:@"mineTouchIndex7"]) {
            //投诉与支持
            NoaComplainVC *vc = [NoaComplainVC new];
            [self openFullScreen:vc];
        } else if ([action isEqualToString:@"mineTouchIndex8"]) {
            //关于我们
            LuckyLandAboutUsViewController *aboutUsVC = [[LuckyLandAboutUsViewController alloc] init];
            [self openFullScreen:aboutUsVC];
        } else if ([action isEqualToString:@"mineTouchIndex100"]) {
            //个人信息
            NoaUserInfoViewController *userInfoVC = [[NoaUserInfoViewController alloc] init];
            [self openFullScreen:userInfoVC];
        } else if ([action isEqualToString:@"mineTouchIndex101"]) {
            //系统设置
            LuckyLandSystemSettingViewController *sysSettingVC = [[LuckyLandSystemSettingViewController alloc] init];
            [self openFullScreen:sysSettingVC];
        } else if ([action isEqualToString:@"mineTouchIndex102"]) {
            //我的二维码
            [self getQtcondeContent];
        } else if ([action isEqualToString:@"mineTouchIndex103"]) {
            LuckyLandSignInViewController * signInVC = [[LuckyLandSignInViewController alloc] init];
            [self openFullScreen:signInVC];
        } else if ([action isEqualToString:@"mineTouchIndex104"]) {
            //个人信息
            NoaUserInfoViewController *userInfoVC = [[NoaUserInfoViewController alloc] init];
            [self openFullScreen:userInfoVC];
        } else if ([action isEqualToString:@"mineTouchIndex105"]) {
            [HUD showMessage:LanguageToolMatch(@"复制成功") inView:self.view];
        }

        
        
        if (registerWay != NSNotFound) {
            result(@(YES));
            return;
        }

        result(FlutterMethodNotImplemented);
    }];
}



#pragma mark - 先获取生成二维码的content，再本地生成二维码
- (void)getQtcondeContent {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObjectSafe:@"" forKey:@"content"];
    [dict setObjectSafe:@1 forKey:@"type"];
    [dict setObjectSafe:UserManager.userInfo.userUID forKey:@"userUid"];
    
    WeakSelf
    [HUD showActivityMessage:@""];
    [IMSDKManager UserGetCreatQrcodeContentWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        [HUD hideHUD];
        NoaQRCodeModel *model = [NoaQRCodeModel mj_objectWithKeyValues:data];
        NSString *content = model.content;
        //跳转到我的二维码
        NoaMyQRCodeViewController *myQrcodeVC = [[NoaMyQRCodeViewController alloc] init];
        myQrcodeVC.qrcodeContent = ![NSString isNil:content] ? content : @"" ;
        [weakSelf openFullScreen:myQrcodeVC];
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [HUD hideHUD];
        [HUD showMessageWithCode:code errorMsg:msg];
    }];
}



#pragma mark - Navigation Helper
- (void)openFullScreen:(UIViewController *)vc {
    if (!vc) { return; }
    vc.hidesBottomBarWhenPushed = YES;

    // 优先使用当前可见的导航
    UINavigationController *currentNav = self.navigationController;

    // 若当前在抽屉容器中，改为先隐藏（dismiss）抽屉效果，再在根部导航上 push 全屏页面
    UIPresentationController *pc = currentNav.presentationController;
    if ([pc isKindOfClass:[NoaDrawerPresentationController class]]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
            UINavigationController *targetNav = nil;
            if ([rootVC isKindOfClass:[UITabBarController class]]) {
                UIViewController *selected = ((UITabBarController *)rootVC).selectedViewController;
                if ([selected isKindOfClass:[UINavigationController class]]) {
                    targetNav = (UINavigationController *)selected;
                }
            } else if ([rootVC isKindOfClass:[UINavigationController class]]) {
                targetNav = (UINavigationController *)rootVC;
            }
            if (targetNav) {
                vc.hidesBottomBarWhenPushed = YES;
                // 移除重新 present 抽屉的逻辑，点击后隐藏 mineVC，返回后不再出现
                [targetNav pushViewController:vc animated:YES];
            }
        }];
        return;
    }

    // 精确获取“我的”Tab对应的导航控制器，确保返回时仍回到 ZMineVC
    UINavigationController *mineNav = nil;
    UITabBarController *tab = self.tabBarController;
    if ([tab isKindOfClass:[UITabBarController class]]) {
        for (UIViewController *vcItem in tab.viewControllers) {
            if ([vcItem isKindOfClass:[UINavigationController class]]) {
                UINavigationController *navItem = (UINavigationController *)vcItem;
                UIViewController *root = navItem.viewControllers.firstObject;
                if ([root isKindOfClass:[FlutterTallkMineViewController class]]) {
                    mineNav = navItem;
                    break;
                }
            }
        }
    }

    // 获取根部导航（Tab 内的选中导航 or 根导航）
    UINavigationController *rootNav = nil;
    UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        rootNav = (UINavigationController *)rootVC;
    } else if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UIViewController *selected = ((UITabBarController *)rootVC).selectedViewController;
        if ([selected isKindOfClass:[UINavigationController class]]) {
            rootNav = (UINavigationController *)selected;
        }
    }

    // 如果当前页面（或其导航）是以半屏方式呈现（非抽屉的其他场景），可作为兜底：无动画关闭后在根导航 push
    BOOL presentedAsSheet = NO;
    if (currentNav) {
        presentedAsSheet = (currentNav.presentingViewController != nil && currentNav.modalPresentationStyle != UIModalPresentationFullScreen);
    } else {
        presentedAsSheet = (self.presentingViewController != nil && self.modalPresentationStyle != UIModalPresentationFullScreen);
    }

    if (presentedAsSheet && (mineNav || rootNav)) {
        [self dismissViewControllerAnimated:NO completion:^{
            if (tab && mineNav) {
                tab.selectedViewController = mineNav;
                [mineNav pushViewController:vc animated:YES];
            } else {
                [rootNav pushViewController:vc animated:YES];
            }
        }];
        return;
    }

    // 正常 push
    if (currentNav) {
        [currentNav pushViewController:vc animated:YES];
        return;
    }
    if (mineNav) {
        [mineNav pushViewController:vc animated:YES];
        return;
    }
    if (rootNav) {
        [rootNav pushViewController:vc animated:YES];
    }
}


@end
