//
//  LuckyLandNativeMineViewController.m
//  LuckyLand
//

#import "LuckyLandNativeMineViewController.h"
#import "LuckyLandNativeMineCell.h"

#import "NoaTeamListVC.h"
#import "LuckyLandMyCollectionViewController.h"
#import "LuckyLandBlackListViewController.h"
#import "LuckyLandLanguageSetViewController.h"
#import "LuckyLandSafeSettingViewController.h"
#import "LuckyLandPrivacySettingViewController.h"
#import "NoaNetworkDetectionVC.h"
#import "NoaComplainVC.h"
#import "LuckyLandAboutUsViewController.h"
#import "LuckyLandUserInfoViewController.h"
#import "LuckyLandSystemSettingViewController.h"
#import "LuckyLandAccountRemoveViewController.h"
#import "NoaMessageAlertView.h"
#import "LuckyLandSignInViewController.h"
#import "LuckyLandMyQRCodeViewController.h"
#import "NoaQRCodeModel.h"
#import "LuckyLandDrawerPresentationController.h"

#import <SDWebImage/SDWebImage.h>

@interface LuckyLandNativeMineViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *idLabel;
@property (nonatomic, strong) UIView *listContainerView;
@property (nonatomic, strong) UIStackView *listStackView;

@end

@implementation LuckyLandNativeMineViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(@"FFFFFF");
    [self setupUI];
    [self setupNotification];
    [self refreshUserInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self refreshUserInfo];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI

- (void)setupUI {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];

    [self.contentView addSubview:self.headerView];
    [self.contentView addSubview:self.listContainerView];

    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    CGFloat safeTop = DStatusBarH;
    CGFloat tabBarInset = DTabBarH + 39;

    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.contentView);
        make.height.mas_equalTo(400 + safeTop);
    }];
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(150 + safeTop);
        make.leading.equalTo(self.contentView);
        make.trailing.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-tabBarInset);
    }];

    [self setupHeaderContentWithSafeTop:safeTop];
    [self setupListContent];
}

- (void)setupHeaderContentWithSafeTop:(CGFloat)safeTop {
    UIView *safeContent = [[UIView alloc] init];
    [self.headerView addSubview:safeContent];
    [safeContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.headerView);
        make.top.equalTo(self.headerView).offset(safeTop);
    }];

    UIButton *signInButton = [self iconButtonWithImage:ImgNamed(@"qiandao-2") action:@selector(handleSignInTap)];
    UIButton *qrButton = [self systemIconButton:@"qrcode.viewfinder" action:@selector(handleQRTap)];
    UIButton *settingsButton = [self systemIconButton:@"gearshape" action:@selector(handleSettingsTap)];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = LanguageToolMatch(@"我的");
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    titleLabel.textAlignment = NSTextAlignmentCenter;

    [safeContent addSubview:signInButton];
    [safeContent addSubview:titleLabel];
    [safeContent addSubview:qrButton];
    [safeContent addSubview:settingsButton];

    [signInButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(safeContent);
        make.width.height.mas_equalTo(44);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(signInButton);
        make.centerX.equalTo(safeContent);
        make.leading.greaterThanOrEqualTo(signInButton.mas_trailing).offset(8);
        make.trailing.lessThanOrEqualTo(qrButton.mas_leading).offset(-8);
    }];
    [qrButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(signInButton);
        make.trailing.equalTo(settingsButton.mas_leading);
        make.width.height.mas_equalTo(44);
    }];
    [settingsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(signInButton);
        make.trailing.equalTo(safeContent);
        make.width.height.mas_equalTo(44);
    }];

    UIView *avatarContainer = [[UIView alloc] init];
    avatarContainer.backgroundColor = UIColor.whiteColor;
    avatarContainer.layer.cornerRadius = 27;
    avatarContainer.layer.borderWidth = 2;
    avatarContainer.layer.borderColor = UIColor.whiteColor.CGColor;
    avatarContainer.clipsToBounds = YES;
    avatarContainer.userInteractionEnabled = YES;
    [avatarContainer addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAvatarTap)]];

    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.image = DefaultAvatar;
    [avatarContainer addSubview:self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(avatarContainer);
    }];

    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = UIColor.whiteColor;
    self.nameLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];

    UIImageView *copyIcon = [[UIImageView alloc] init];
    if (@available(iOS 13.0, *)) {
        copyIcon.image = [[UIImage systemImageNamed:@"doc.on.doc"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    copyIcon.tintColor = UIColor.whiteColor;
    copyIcon.contentMode = UIViewContentModeScaleAspectFit;

    self.idLabel = [[UILabel alloc] init];
    self.idLabel.textColor = UIColor.whiteColor;
    self.idLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];

    UIStackView *idStack = [[UIStackView alloc] initWithArrangedSubviews:@[self.idLabel, copyIcon]];
    idStack.axis = UILayoutConstraintAxisHorizontal;
    idStack.spacing = 4;
    idStack.alignment = UIStackViewAlignmentCenter;
    idStack.userInteractionEnabled = YES;
    [idStack addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCopyIdTap)]];
    [copyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(16);
    }];

    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    editButton.layer.cornerRadius = 20;
    editButton.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMinXMaxYCorner;
    editButton.clipsToBounds = YES;
    [editButton setTitle:LanguageToolMatch(@"编辑资料") forState:UIControlStateNormal];
    [editButton setTitleColor:COLOR_1B2E60 forState:UIControlStateNormal];
    editButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    [editButton addTarget:self action:@selector(handleEditProfileTap) forControlEvents:UIControlEventTouchUpInside];

    [safeContent addSubview:avatarContainer];
    [safeContent addSubview:self.nameLabel];
    [safeContent addSubview:idStack];
    [safeContent addSubview:editButton];

    [avatarContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(safeContent).offset(16);
        make.top.equalTo(signInButton.mas_bottom).offset(8);
        make.width.height.mas_equalTo(54);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(avatarContainer.mas_trailing).offset(8);
        make.top.equalTo(avatarContainer).offset(8);
        make.trailing.lessThanOrEqualTo(editButton.mas_leading).offset(-8);
    }];
    [idStack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(8);
        make.trailing.lessThanOrEqualTo(editButton.mas_leading).offset(-8);
    }];
    [editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(safeContent);
        make.centerY.equalTo(avatarContainer);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(40);
    }];
}

- (void)setupListContent {
    [self.listContainerView addSubview:self.listStackView];
    [self.listStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.listContainerView).insets(UIEdgeInsetsMake(16, 0, 26, 0));
    }];

    NSArray<NSArray<NSDictionary *> *> *sections = @[
        @[@{@"tag": @"mineTouchIndex0", @"title": LanguageToolMatch(@"我的团队"), @"icon": @"tuandui"}],
        @[
            @{@"tag": @"mineTouchIndex1", @"title": LanguageToolMatch(@"我的收藏"), @"icon": @"shoucang"},
            @{@"tag": @"mineTouchIndex2", @"title": LanguageToolMatch(@"黑名单"), @"icon": @"heimingdan"},
        ],
        @[
            @{@"tag": @"mineTouchIndex3", @"title": LanguageToolMatch(@"应用语言"), @"icon": @"yuyan"},
            @{@"tag": @"mineTouchIndex4", @"title": LanguageToolMatch(@"安全设置"), @"icon": @"anquanbaozhang"},
            @{@"tag": @"mineTouchIndex5", @"title": LanguageToolMatch(@"隐私设置"), @"icon": @"yinsi"},
            @{@"tag": @"mineTouchIndex6", @"title": LanguageToolMatch(@"网络检测"), @"icon": @"wangluo"},
            @{@"tag": @"mineTouchIndex7", @"title": LanguageToolMatch(@"投诉与支持"), @"icon": @"tousujianyi"},
        ],
        @[@{@"tag": @"mineTouchIndex8", @"title": LanguageToolMatch(@"关于"), @"icon": @"guanyu"}],
        @[@{@"tag": @"mineTouchIndex9", @"title": LanguageToolMatch(@"删除账号"), @"destructive": @YES}],
    ];

    for (NSInteger i = 0; i < sections.count; i++) {
        if (i > 0) {
            [self.listStackView addArrangedSubview:[self dividerView]];
        }
        for (NSDictionary *item in sections[i]) {
            LuckyLandNativeMineCell *cell = [[LuckyLandNativeMineCell alloc] initWithFrame:CGRectZero];
            if ([item[@"destructive"] boolValue]) {
                [cell configureDestructiveWithTitle:item[@"title"]];
            } else {
                [cell configureWithTitle:item[@"title"] iconName:item[@"icon"]];
            }
            cell.actionTag = item[@"tag"];
            [cell addTarget:self action:@selector(handleMineCellTap:) forControlEvents:UIControlEventTouchUpInside];
            [cell mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(44);
            }];
            [self.listStackView addArrangedSubview:cell];
        }
    }
}

- (UIView *)dividerView {
    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = HEXCOLOR(@"F2F3F3");
    [divider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(10);
    }];
    return divider;
}

- (UIButton *)iconButtonWithImage:(UIImage *)image action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    button.contentEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIButton *)systemIconButton:(NSString *)symbol action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (@available(iOS 13.0, *)) {
        UIImage *image = [[UIImage systemImageNamed:symbol] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [button setImage:image forState:UIControlStateNormal];
        button.tintColor = UIColor.whiteColor;
    }
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - User Info

- (void)setupNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserInfo) name:@"MineUserInfoUpdate" object:nil];
}

- (void)refreshUserInfo {
    NSString *nickname = UserManager.userInfo.nickname;
    NSString *userId = UserManager.userInfo.userName;
    self.nameLabel.text = nickname.length > 0 ? nickname : @"--";
    self.idLabel.text = userId.length > 0 ? userId : @"--";

    NSString *avatar = UserManager.userInfo.avatar;
    if (avatar.length == 0) {
        self.avatarImageView.image = DefaultAvatar;
        return;
    }
    [self.avatarImageView sd_setImageWithURL:[avatar getImageFullUrl]
                            placeholderImage:DefaultAvatar
                                     options:SDWebImageAllowInvalidSSLCertificates];
}

#pragma mark - Actions

- (void)handleMineCellTap:(LuckyLandNativeMineCell *)sender {
    [self handleMineAction:sender.actionTag];
}

- (void)handleSignInTap {
    [self handleMineAction:@"mineTouchIndex103"];
}

- (void)handleQRTap {
    [self handleMineAction:@"mineTouchIndex102"];
}

- (void)handleSettingsTap {
    [self handleMineAction:@"mineTouchIndex101"];
}

- (void)handleAvatarTap {
    [self handleMineAction:@"mineTouchIndex104"];
}

- (void)handleEditProfileTap {
    [self handleMineAction:@"mineTouchIndex100"];
}

- (void)handleCopyIdTap {
    NSString *userId = UserManager.userInfo.userName;
    if (userId.length > 0) {
        [UIPasteboard generalPasteboard].string = userId;
    }
    [self handleMineAction:@"mineTouchIndex105"];
}

- (void)handleMineAction:(NSString *)action {
    if (action.length == 0) {
        return;
    }

    if ([action isEqualToString:@"mineTouchIndex0"]) {
        [self openFullScreen:[NoaTeamListVC new]];
    } else if ([action isEqualToString:@"mineTouchIndex1"]) {
        LuckyLandMyCollectionViewController *vc = [[LuckyLandMyCollectionViewController alloc] init];
        vc.isFromChat = NO;
        [self openFullScreen:vc];
    } else if ([action isEqualToString:@"mineTouchIndex2"]) {
        [self openFullScreen:[[LuckyLandBlackListViewController alloc] init]];
    } else if ([action isEqualToString:@"mineTouchIndex3"]) {
        LuckyLandLanguageSetViewController *vc = [[LuckyLandLanguageSetViewController alloc] init];
        vc.changeType = LanguageChangeUITypeTabbar;
        [self openFullScreen:vc];
    } else if ([action isEqualToString:@"mineTouchIndex4"]) {
        [self openFullScreen:[[LuckyLandSafeSettingViewController alloc] init]];
    } else if ([action isEqualToString:@"mineTouchIndex5"]) {
        [self openFullScreen:[[LuckyLandPrivacySettingViewController alloc] init]];
    } else if ([action isEqualToString:@"mineTouchIndex6"]) {
        NoaNetworkDetectionVC *vc = [NoaNetworkDetectionVC new];
        NoaSsoInfoModel *ssoModel = [NoaSsoInfoModel getSSOInfo];
        vc.currentSsoNumber = ssoModel.liceseId;
        [self openFullScreen:vc];
    } else if ([action isEqualToString:@"mineTouchIndex7"]) {
        [self openFullScreen:[NoaComplainVC new]];
    } else if ([action isEqualToString:@"mineTouchIndex8"]) {
        [self openFullScreen:[[LuckyLandAboutUsViewController alloc] init]];
    } else if ([action isEqualToString:@"mineTouchIndex9"]) {
        [self showDeleteAccountFlow];
    } else if ([action isEqualToString:@"mineTouchIndex100"] || [action isEqualToString:@"mineTouchIndex104"]) {
        [self openFullScreen:[[LuckyLandUserInfoViewController alloc] init]];
    } else if ([action isEqualToString:@"mineTouchIndex101"]) {
        [self openFullScreen:[[LuckyLandSystemSettingViewController alloc] init]];
    } else if ([action isEqualToString:@"mineTouchIndex102"]) {
        [self getQtcondeContent];
    } else if ([action isEqualToString:@"mineTouchIndex103"]) {
        [self openFullScreen:[[LuckyLandSignInViewController alloc] init]];
    } else if ([action isEqualToString:@"mineTouchIndex105"]) {
        [HUD showMessage:LanguageToolMatch(@"复制成功") inView:self.view];
    }
}

#pragma mark - Delete Account

- (void)showDeleteAccountFlow {
    NoaMessageAlertView *msgAlertView = [[NoaMessageAlertView alloc] initWithMsgAlertType:ZMessageAlertTypeTitle supView:self.view];
    msgAlertView.lblTitle.text = LanguageToolMatch(@"删除账号");
    msgAlertView.lblContent.text = LanguageToolMatch(@"删除账号详细说明");
    msgAlertView.lblContent.numberOfLines = 0;
    [msgAlertView.btnSure setTitle:LanguageToolMatch(@"确认") forState:UIControlStateNormal];
    [msgAlertView.btnCancel setTitle:LanguageToolMatch(@"取消") forState:UIControlStateNormal];
    [msgAlertView alertShow];
    WeakSelf
    msgAlertView.sureBtnBlock = ^(BOOL isCheckBox) {
        [weakSelf openFullScreen:[[LuckyLandAccountRemoveViewController alloc] init]];
    };
}

#pragma mark - QR Code

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
        LuckyLandMyQRCodeViewController *myQrcodeVC = [[LuckyLandMyQRCodeViewController alloc] init];
        myQrcodeVC.qrcodeContent = ![NSString isNil:content] ? content : @"";
        [weakSelf openFullScreen:myQrcodeVC];
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [HUD hideHUD];
        [HUD showMessageWithCode:code errorMsg:msg];
    }];
}

#pragma mark - Navigation

- (void)openFullScreen:(UIViewController *)vc {
    if (!vc) {
        return;
    }
    vc.hidesBottomBarWhenPushed = YES;

    UINavigationController *currentNav = self.navigationController;
    UIPresentationController *pc = currentNav.presentationController;
    if ([pc isKindOfClass:[LuckyLandDrawerPresentationController class]]) {
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
                [targetNav pushViewController:vc animated:YES];
            }
        }];
        return;
    }

    UINavigationController *mineNav = [self mineTabNavigationController];
    UINavigationController *rootNav = [self rootNavigationController];
    UITabBarController *tab = self.tabBarController;

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

- (UINavigationController *)mineTabNavigationController {
    UITabBarController *tab = self.tabBarController;
    if (![tab isKindOfClass:[UITabBarController class]]) {
        return nil;
    }
    for (UIViewController *vcItem in tab.viewControllers) {
        if ([vcItem isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navItem = (UINavigationController *)vcItem;
            UIViewController *root = navItem.viewControllers.firstObject;
            if ([root isKindOfClass:[LuckyLandNativeMineViewController class]]) {
                return navItem;
            }
        }
    }
    return nil;
}

- (UINavigationController *)rootNavigationController {
    UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)rootVC;
    }
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UIViewController *selected = ((UITabBarController *)rootVC).selectedViewController;
        if ([selected isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)selected;
        }
    }
    return nil;
}

#pragma mark - Lazy

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (UIView *)headerView {
    if (!_headerView) {
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:ImgNamed(@"shanhai_minebg")];
        bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        bgImageView.clipsToBounds = YES;
        bgImageView.userInteractionEnabled = YES;
        _headerView = bgImageView;
    }
    return _headerView;
}

- (UIView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[UIView alloc] init];
        _listContainerView.backgroundColor = UIColor.whiteColor;
        _listContainerView.layer.cornerRadius = 12;
        _listContainerView.clipsToBounds = YES;
    }
    return _listContainerView;
}

- (UIStackView *)listStackView {
    if (!_listStackView) {
        _listStackView = [[UIStackView alloc] init];
        _listStackView.axis = UILayoutConstraintAxisVertical;
        _listStackView.spacing = 0;
    }
    return _listStackView;
}

@end
