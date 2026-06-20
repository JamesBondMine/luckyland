//
//  NILaunchViewController.m
//  NoaKit
//
//  Created by 郑开1 on 2024/3/7.
//

#import "LuckyLandLaunchViewController.h"

@interface LuckyLandLaunchViewController ()

@end

@implementation LuckyLandLaunchViewController

- (instancetype)init{
    id  controller;
    controller = [UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil].instantiateInitialViewController;
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
}

@end
