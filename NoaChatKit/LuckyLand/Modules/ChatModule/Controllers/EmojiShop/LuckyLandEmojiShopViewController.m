//
//  LuckyLandEmojiShopViewController.m
//  NoaKit
//
//  Created by LuckyLand on 2023/10/25.
//

#import "LuckyLandEmojiShopViewController.h"
#import <JXCategoryView/JXCategoryView.h>
#import "NoaScrollView.h"
#import "LuckyLandEmojiShopPackageViewController.h"//表情包
#import "LuckyLandEmojiShopFeaturedViewController.h"//精选表情

@interface LuckyLandEmojiShopViewController () <JXCategoryViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) JXCategoryTitleView *viewCategory;
@property (nonatomic, strong) NoaScrollView *scrollView;
@property (nonatomic, strong) LuckyLandEmojiShopPackageViewController *emojiPackageVC;
@property (nonatomic, strong) LuckyLandEmojiShopFeaturedViewController *emojiFeaturedVC;

@end

@implementation LuckyLandEmojiShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitleStr = LanguageToolMatch(@"表情商城");
    self.view.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_11];
    [self setupUI];
}

#pragma mark - 界面布局
- (void)setupUI {
    _viewCategory = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, DNavStatusBarH + DWScale(10), DScreenWidth, DWScale(40))];
    _viewCategory.delegate = self;
    _viewCategory.titles = @[LanguageToolMatch(@"表情包"),LanguageToolMatch(@"精选表情")];
    _viewCategory.titleColorGradientEnabled = YES;
    _viewCategory.titleLabelZoomScale = YES;
    _viewCategory.titleFont = FONTB(16);
    _viewCategory.titleLabelZoomScale = 1.0;
    WeakSelf
    self.view.tkThemeChangeBlock = ^(id  _Nullable itself, NSUInteger themeIndex) {
        switch (themeIndex) {
            case 1:
            {
                //暗黑
                weakSelf.viewCategory.backgroundColor = COLOR_11;
                weakSelf.viewCategory.titleColor = COLOR_66_DARK;
                weakSelf.viewCategory.titleSelectedColor = COLOR_11_DARK;
            }
                break;
                
            default:
            {
                weakSelf.viewCategory.backgroundColor = COLORWHITE;
                weakSelf.viewCategory.titleColor = COLOR_66;
                weakSelf.viewCategory.titleSelectedColor = COLOR_11;
            }
                break;
        }
    };
    //指示器
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = COLOR_EB5C5C;
    lineView.componentPosition = JXCategoryComponentPosition_Bottom;
    lineView.verticalMargin = 5;
    _viewCategory.indicators = @[lineView];
    
    _scrollView = [[NoaScrollView alloc] initWithFrame:CGRectMake(0, DNavStatusBarH + DWScale(10) + DWScale(40), DScreenWidth, DScreenHeight - DNavStatusBarH - DWScale(10) - DWScale(40) - DHomeBarH)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delaysContentTouches = NO;
    _scrollView.contentSize = CGSizeMake(DScreenWidth * 2, 0);
    _scrollView.bounces = NO;
    
    [self.view addSubview:self.viewCategory];
    [self.view addSubview:self.scrollView];
    self.viewCategory.contentScrollView = self.scrollView;
    
    _emojiPackageVC = [LuckyLandEmojiShopPackageViewController new];
    _emojiPackageVC.view.frame = CGRectMake(0, 0, DScreenWidth, _scrollView.height);
    [self addChildViewController:_emojiPackageVC];
    [self.scrollView addSubview:_emojiPackageVC.view];
    
    _emojiFeaturedVC = [LuckyLandEmojiShopFeaturedViewController new];
    _emojiFeaturedVC.view.frame = CGRectMake(DScreenWidth, 0, DScreenWidth, _scrollView.height);
    [self addChildViewController:_emojiFeaturedVC];
    [self.scrollView addSubview:_emojiFeaturedVC.view];
}


@end
