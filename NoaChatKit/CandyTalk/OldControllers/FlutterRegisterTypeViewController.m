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
    [channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        if ([call.method isEqualToString:@"registerSelectTap"]) {
            NSString *itemId = @"";
            if ([call.arguments isKindOfClass:[NSString class]]) {
                itemId = (NSString *)call.arguments;
            } else if ([call.arguments isKindOfClass:[NSDictionary class]]) {
                itemId = [(NSDictionary *)call.arguments objectForKey:@"id"] ?: @"";
            }
            NSLog(@"[FlutterRegisterType] register select tapped: %@", itemId);
            result(@(YES));
            return;
        }
        result(FlutterMethodNotImplemented);
    }];
}

@end
