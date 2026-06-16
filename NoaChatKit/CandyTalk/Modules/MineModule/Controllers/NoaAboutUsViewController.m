//
//  NoaAboutUsViewController.m
//  NoaKit
//
//  Created by Candy on 2026/11/13.
//

#import "NoaAboutUsViewController.h"
#import "NoaToolManager.h"
#import "NoaAppUpdateTools.h"
#import "AppDelegate.h"
#import <Flutter/Flutter.h>
#import "NoaBaseWebViewController.h"

#define SERVE_BTN_TAG           101
#define PRIVACY_BTN_TAG         102
#define SCORE_BTN_TAG           103
#define VERSION_BTN_TAG         104
#define LOGAN_BTN_TAG           105

@interface NoaAboutUsViewController ()

@property (nonatomic, strong) UIView *flutterContainerView;
@property (nonatomic, strong) FlutterViewController *flutterViewController;
@property (nonatomic, strong) FlutterMethodChannel *flutterBridgeChannel;

@end

@implementation NoaAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitleStr = LanguageToolMatch(@"关于我们");
    self.view.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_11];
    
    [self setupUI];
    [self setupFlutterView];
}

- (void)setupUI {
    UIImageView *logoImgView = [[UIImageView alloc] init];
    logoImgView.image = ImgNamed(@"img_login_logo");
    [self.view addSubview:logoImgView];
    [logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(DNavStatusBarH + 20);
        make.centerX.equalTo(self.view);
        make.width.height.mas_equalTo(DWScale(82));
    }];
    
    UILabel *versionLbl = [[UILabel alloc] init];
    versionLbl.text = [NSString stringWithFormat:LanguageToolMatch(@"当前版本v%@ %@"), [ZTOOL getCurretnVersion], [ZTOOL getBuildVersion]];
    versionLbl.tkThemetextColors = @[COLOR_66, COLOR_66_DARK];
    versionLbl.font = FONTN(16);
    versionLbl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:versionLbl];
    [versionLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoImgView.mas_bottom).offset(16);
        make.leading.equalTo(self.view).offset(10);
        make.trailing.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(DWScale(22));
    }];
    

    UIView *flutterContainerView = [[UIView alloc] init];
    flutterContainerView.backgroundColor = UIColor.clearColor;
    [self.view addSubview:flutterContainerView];
    self.flutterContainerView = flutterContainerView;
    [flutterContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(centerBackView.mas_bottom).offset(16);
        make.top.equalTo(versionLbl.mas_bottom).offset(16);
        make.leading.equalTo(self.view).offset(16);
        make.trailing.equalTo(self.view).offset(-16);
        make.height.equalTo(@100);
//        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-16);
    }];
}

- (void)setupFlutterView {
    AppDelegate *appDelegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
    FlutterEngine *engine = appDelegate.flutterEngine;
    if (!engine) {
        engine = [[FlutterEngine alloc] initWithName:@"noa_flutter_engine_fallback"];
        [engine run];
        appDelegate.flutterEngine = engine;
    }
    
    FlutterViewController *flutterVC = [[FlutterViewController alloc] initWithEngine:engine nibName:nil bundle:nil];
    self.flutterViewController = flutterVC;

    __weak typeof(self) weakSelf = self;
    FlutterMethodChannel *bridgeChannel = [FlutterMethodChannel methodChannelWithName:@"com.noa.flutter/bridge" binaryMessenger:engine.binaryMessenger];
    self.flutterBridgeChannel = bridgeChannel;
    [bridgeChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        if ([call.method isEqualToString:@"openPolicyDetail"]) {
            NSDictionary *args = [call.arguments isKindOfClass:[NSDictionary class]] ? (NSDictionary *)call.arguments : @{};
            NSString *title = [args objectForKey:@"title"] ?: @"";
            NSString *url = privacyPolicyUrl;
            if ([title isEqual:@"服务协议"]){
                url = servicePolicyUrl;
            }
            [weakSelf openFlutterPolicyDetailWithTitle:title url:url];
            result(@(YES));
            return;
        }
        result(FlutterMethodNotImplemented);
    }];
    
    [self addChildViewController:flutterVC];
    flutterVC.view.frame = self.flutterContainerView.bounds;
    flutterVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.flutterContainerView addSubview:flutterVC.view];
    [flutterVC didMoveToParentViewController:self];
}

- (void)openFlutterPolicyDetailWithTitle:(NSString *)title url:(NSString *)url {
    NoaBaseWebViewController *webVC = [[NoaBaseWebViewController alloc] init];
    webVC.webViewTitle = title;
    webVC.webViewUrl = url;
    [self.navigationController pushViewController:webVC animated:YES];
    
//    NSString *safeTitle = title ?: @"";
//    NSString *safeURL = url ?: @"";
//    NSString *encodedTitle = [safeTitle stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] ?: @"";
//    NSString *encodedURL = [safeURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] ?: @"";
//    NSString *route = [NSString stringWithFormat:@"/aboutDetail?title=%@&url=%@", encodedTitle, encodedURL];
//    FlutterViewController *detailVC = [[FlutterViewController alloc] initWithProject:nil initialRoute:route nibName:nil bundle:nil];
//    detailVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - Action
- (void)contentAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    if (btn.tag == SERVE_BTN_TAG) {
        //服务协议
        [ZTOOL setupServeAgreement];
    }
    
    if (btn.tag == PRIVACY_BTN_TAG) {
        //隐私政策
        [ZTOOL setupPrivePolicy];
    }
    
    if (btn.tag == SCORE_BTN_TAG) {
        //去评分，跳商店
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_IN_APPLE_STORE_URL] options:@{} completionHandler:nil];
    }
    if (btn.tag == VERSION_BTN_TAG) {
        //检查更新
        [NoaAppUpdateTools getAppUpdateInfoWithShowDefaultTips:YES completion:nil];
    }
    
    if (btn.tag == LOGAN_BTN_TAG) {
        //日志上报
        [HUD showActivityMessage:LanguageToolMatch(@"日志上报")];


        //上传前一天的日志
        NSDate *todayDate = [NSDate date];
        NSDate *lastDayDate = [NSDate dateWithTimeInterval:-24 * 60 * 60 sinceDate:todayDate];
        NSString *lastDayDateStr = [lastDayDate dateForStringWith:@"yyyy-MM-dd"];
        [IMSDKManager imSdkUploadLoganWith:lastDayDateStr complete:^(NSError * _Nullable error) {
        }];

    }
}

@end
