//
//  LuckyLandLoginBaseViewController.m
//  NoaChatKit
//
//  Created by ppppphl on 2025/11/4.
//

#import "LuckyLandLoginBaseViewController.h"
#import "LuckyLandNetSetViewController.h"
#import "LuckyLandLanguageSetViewController.h"

@interface LuckyLandLoginBaseViewController ()


/// 网络设置
@property (nonatomic, strong) UIButton *networkSetBtn;

/// 系统语言
@property (nonatomic, strong) UIButton *systemLanguageBtn;

/// 设置幸运数字
@property (nonatomic, strong) UIButton *setSsoAccountBtn;

/// 语言设置右侧箭头
@property (nonatomic, strong) UIImageView *languageArrow;

/// 上方标题
@property (nonatomic, strong, readwrite) UILabel *topTitleLabel;

/// 上方小标题
@property (nonatomic, strong, readwrite) UILabel *topSubTitleLabel;

/// 高斯模糊view
@property (nonatomic, strong, readwrite) NoaLoginBaseBlurView *blurView;

@end

@implementation LuckyLandLoginBaseViewController

- (UIButton *)networkSetBtn {
    if (!_networkSetBtn) {
        _networkSetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_networkSetBtn setTitle:LanguageToolMatch(@"网络设置") forState:UIControlStateNormal];
        [_networkSetBtn setTkThemeTitleColor:@[COLOR_11, COLOR_11_DARK] forState:UIControlStateNormal];
        [_networkSetBtn setImage:ImgNamed(@"icon_sso_net") forState:UIControlStateNormal];
        _networkSetBtn.titleLabel.font = FONTM(14);
        [_networkSetBtn setBtnImageAlignmentType:ButtonImageAlignmentTypeLeft imageSpace:6];
        _networkSetBtn.tag = 10001;
        [_networkSetBtn addTarget:self action:@selector(btnSetClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _networkSetBtn;
}

- (UIButton *)systemLanguageBtn {
    if (!_systemLanguageBtn) {
        _systemLanguageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_systemLanguageBtn setTitle:LanguageToolMatch(@"系统语言") forState:UIControlStateNormal];
        [_systemLanguageBtn setTkThemeTitleColor:@[COLOR_11, COLOR_11_DARK] forState:UIControlStateNormal];
        [_systemLanguageBtn setImage:ImgNamed(@"icon_sso_language") forState:UIControlStateNormal];
        _systemLanguageBtn.titleLabel.font = FONTM(13);
        [_systemLanguageBtn setBtnImageAlignmentType:ButtonImageAlignmentTypeLeft imageSpace:6];
        _systemLanguageBtn.tag = 10002;
        [_systemLanguageBtn addTarget:self action:@selector(btnSetClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _systemLanguageBtn;
}

- (UIButton *)setSsoAccountBtn {
    if (!_setSsoAccountBtn) {
        _setSsoAccountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_setSsoAccountBtn setTitle:LanguageToolMatch(@"设置幸运数字") forState:UIControlStateNormal];
        _setSsoAccountBtn.tkThemebackgroundColors = @[COLOR_EB5C5C, COLOR_EB5C5C_DARK];
        [_setSsoAccountBtn setTkThemeTitleColor:@[COLORWHITE, COLORWHITE] forState:UIControlStateNormal];
        _setSsoAccountBtn.titleLabel.font = FONTM(14);
        _setSsoAccountBtn.tag = 10003;
        [_setSsoAccountBtn addTarget:self action:@selector(btnSetClick:) forControlEvents:UIControlEventTouchUpInside];
        _setSsoAccountBtn.layer.cornerRadius = 12.0;
        _setSsoAccountBtn.layer.masksToBounds = YES;
        _setSsoAccountBtn.titleEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    }
    return _setSsoAccountBtn;
}

- (UIImageView *)languageArrow {
    if (!_languageArrow) {
        _languageArrow = [UIImageView new];
        _languageArrow.image = ImgNamed(@"sso_language_arrow");
    }
    return _languageArrow;
}

- (UILabel *)topTitleLabel {
    if (!_topTitleLabel) {
        _topTitleLabel = [UILabel new];
        _topTitleLabel.tkThemetextColors = @[COLOR_00, COLOR_00_DARK];
        _topTitleLabel.font = FONTM(26);
    }
    return _topTitleLabel;
}

- (UILabel *)topSubTitleLabel {
    if (!_topSubTitleLabel) {
        _topSubTitleLabel = [UILabel new];
        _topSubTitleLabel.tkThemetextColors = @[COLOR_66, COLOR_66_DARK];
        _topSubTitleLabel.font = FONTR(12);
    }
    return _topSubTitleLabel;
}

- (NoaLoginBaseBlurView *)blurView {
    if (!_blurView) {
        _blurView = [[NoaLoginBaseBlurView alloc] initWithFrame:CGRectZero IsPopWindows:NO];
    }
    return _blurView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // UI布局
    [self setupBaseNavBar];
    [self setupBaseUI];
}

- (void)setupBaseNavBar {
    self.navBtnBack.hidden = YES;
    self.navBtnRight.hidden = YES;
    self.navTitleLabel.hidden = YES;
    self.navLineView.hidden = YES;
    self.navView.tkThemebackgroundColors = @[UIColor.clearColor, UIColor.clearColor];
}

- (void)setupBaseUI {

    [self.navView addSubview:self.networkSetBtn];
    [self.networkSetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(DStatusBarH + 19));
        make.leading.equalTo(@16);
        make.height.equalTo(@14);
        make.width.greaterThanOrEqualTo(@74);
    }];
    
    [self.navView addSubview:self.systemLanguageBtn];
    [self.systemLanguageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.networkSetBtn.mas_trailing).offset(16);
        make.centerY.equalTo(self.networkSetBtn);
        make.height.equalTo(@14);
        make.width.greaterThanOrEqualTo(@74);
    }];
    
    CGFloat ssoAccountTextWith = [self calculateButtonWidthForText:self.setSsoAccountBtn.titleLabel.text font:self.setSsoAccountBtn.titleLabel.font];
    CGFloat ssoAccountBtnWith = MAX(94, ssoAccountTextWith);
    [self.navView addSubview:self.setSsoAccountBtn];
    [self.setSsoAccountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.navView).offset(-16);
        make.centerY.equalTo(self.networkSetBtn);
        make.height.equalTo(@24);
        make.width.equalTo(@(ssoAccountBtnWith));
    }];
    
    [self.navView addSubview:self.languageArrow];
    [self.languageArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.systemLanguageBtn.mas_trailing).offset(4);
        make.centerY.equalTo(self.networkSetBtn);
        make.height.equalTo(@9);
        make.width.equalTo(@9);
    }];
    
    [self.view addSubview:self.blurView];
    [self.blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navView.mas_bottom).offset(146);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (void)btnSetClick:(UIButton *)sender {
    if (sender.tag == 10001) {
        // 网络设置
        [self clickNetworkSetAction];
    }else if (sender.tag == 10002) {
        // 系统语言
        [self clickSystemLanguage];
    }else if (sender.tag == 10003) {
        // 设置幸运数字
        [self clickSetSsoAccount];
    }else {
        // 暂不处理
    }
}

/// 设置网络按钮点击事件（子类重写实现）
- (void)clickNetworkSetAction {
    // 子类重写实现具体逻辑
    LuckyLandNetSetViewController *netSetVC = [[LuckyLandNetSetViewController alloc] init];
    [self.navigationController pushViewController:netSetVC animated:YES];
}

/// 设置系统语言点击事件（子类重写实现）
- (void)clickSystemLanguage {
    // 子类重写实现具体逻辑
    LuckyLandLanguageSetViewController *languageSetVC = [[LuckyLandLanguageSetViewController alloc] init];
    languageSetVC.changeType = LanguageChangeUITypeLogin;
    [self.navigationController pushViewController:languageSetVC animated:YES];
}

/// 设置幸运数字点击事件（子类重写实现）
- (void)clickSetSsoAccount {
    // 子类重写实现具体逻辑
}

- (void)showNetworkDetectionAndSystemLanguageButton:(BOOL)isShow {
    self.networkSetBtn.hidden = !isShow;
    self.systemLanguageBtn.hidden = !isShow;
    self.languageArrow.hidden = !isShow;
}

- (void)showSsoAccountSetButton:(BOOL)isShow {
    self.setSsoAccountBtn.hidden = !isShow;
}

/// MARK: 根据文本计算长度
- (CGFloat)calculateButtonWidthForText:(NSString *)text font:(UIFont *)font {
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGSize size = [text sizeWithAttributes:attributes];
    CGFloat textWidth = size.width + 24; // 左右各12的内边距,多余出来一点
    return textWidth;
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
