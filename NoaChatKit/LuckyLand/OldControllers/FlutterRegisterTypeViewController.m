//
//  FlutterRegisterTypeViewController.m
//  CandyTalk
//

#import "FlutterRegisterTypeViewController.h"

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
        if ([call.method isEqualToString:@"back"]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            result(@(YES));
            return;
        }
        
        if ([call.method isEqualToString:@"registerDetail0"]) {
            result(@(YES));
            return;
        }
        if ([call.method isEqualToString:@"registerDetail1"]) {
            result(@(YES));
            return;
        }
        if ([call.method isEqualToString:@"registerDetail2"]) {
            result(@(YES));
            return;
        }
        
        
        result(FlutterMethodNotImplemented);
    }];
}

@end
