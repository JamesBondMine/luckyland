//
//  FlutterRegisterTypeViewController.m
//  CandyTalk
//

#import "FlutterRegisterTypeViewController.h"
#import "NoaRegisterViewController.h"
#import "NoaEnumHeader.h"

static NSString * const kFlutterBridgeChannelName = @"com.noa.flutter/bridge";

@implementation FlutterRegisterTypeViewController

- (instancetype)init {
    self = [super initWithProject:nil initialRoute:@"/registerSelect" nibName:nil bundle:nil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMethodChannel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)setupMethodChannel {
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:kFlutterBridgeChannelName
                                                               binaryMessenger:self.binaryMessenger];
    @weakify(self)
    [channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        @strongify(self)
        if (![call.method isEqualToString:@"registerSelectTap"]) {
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
        if ([action isEqualToString:@"registerDetail0"]) {
            registerWay = ZLoginTypeMenuEmail;
        } else if ([action isEqualToString:@"registerDetail1"]) {
            registerWay = ZLoginTypeMenuPhoneNumber;
        } else if ([action isEqualToString:@"registerDetail2"]) {
            registerWay = ZLoginTypeMenuAccountPassword;
        }

        if (registerWay != NSNotFound) {
            NoaRegisterViewController *registerVC = [[NoaRegisterViewController alloc] init];
            registerVC.currentRegisterWay = registerWay;
            [self.navigationController pushViewController:registerVC animated:YES];
            result(@(YES));
            return;
        }

        result(FlutterMethodNotImplemented);
    }];
}

@end
