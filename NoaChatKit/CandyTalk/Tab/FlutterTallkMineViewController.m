//
//  FlutterTallkMineViewController.m
//  CandyTalk
//

#import "FlutterTallkMineViewController.h"

@implementation FlutterTallkMineViewController

- (instancetype)init {
    self = [super initWithProject:nil initialRoute:@"/mine" nibName:nil bundle:nil];
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

@end
