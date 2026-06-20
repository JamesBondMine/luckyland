//
//  NoaContactHeaderView.m
//  NoaKit
//
//  Created by LuckyLand on 2026/9/23.
//

#import "NoaContactHeaderView.h"
#import "UIImage+YYImageHelper.h"

static const CGFloat kItemSpacing = 20.0;
static const CGFloat kItemCornerRadius = 12.0;
static const CGFloat kItemBorderWidth = 1.0;
static const CGFloat kItemHeight = 90.0;
static const CGFloat kItemVerticalInset = 10.0;

@interface NoaContactHeaderView ()

@property (nonatomic, strong) UILabel *lblRedNum;
@property (nonatomic, strong) UIButton *btnNew;
@property (nonatomic, strong) UIButton *btnFile;
@property (nonatomic, strong) UIButton *btnGroupHelper;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *ivNew;

@end

@implementation NoaContactHeaderView

+ (CGFloat)preferredHeight {
    return DWScale(kItemVerticalInset * 2 + kItemHeight);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tkThemebackgroundColors = @[COLOR_F8F9FB, COLOR_F8F9FB_DARK];
        [self setupUI];
    }
    return self;
}

#pragma mark - 界面布局
- (void)setupUI {
    self.backView.backgroundColor = UIColor.clearColor;
    [self addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(DWScale(10));
        make.trailing.mas_equalTo(-DWScale(10));
        make.top.bottom.mas_equalTo(self);
    }];
    
    _btnNew = [self createItemButtonWithIcon:@"acon_friend"
                                       title:@"新朋友"
                                      action:@selector(btnNewClick)];
    [self.backView addSubview:_btnNew];
    
    _ivNew = [_btnNew viewWithTag:1001];
    
    _lblRedNum = [UILabel new];
    _lblRedNum.textColor = COLORWHITE;
    _lblRedNum.font = FONTR(12);
    _lblRedNum.text = @" 0 ";
    _lblRedNum.backgroundColor = COLOR_F93A2F;
    _lblRedNum.layer.cornerRadius = DWScale(9);
    _lblRedNum.layer.masksToBounds = YES;
    _lblRedNum.hidden = YES;
    _lblRedNum.textAlignment = NSTextAlignmentCenter;
    [_btnNew addSubview:_lblRedNum];
    [_lblRedNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_ivNew).offset(-DWScale(4));
        make.leading.equalTo(_ivNew.mas_trailing).offset(-DWScale(6));
        make.height.mas_equalTo(18);
        make.width.mas_greaterThanOrEqualTo(18);
    }];
    
    _btnFile = [self createItemButtonWithIcon:@"acon_file"
                                        title:@"文件助手"
                                       action:@selector(btnFileClick)];
    [self.backView addSubview:_btnFile];
    
    _btnGroupHelper = [self createItemButtonWithIcon:@"acon_msg"
                                               title:@"群助手"
                                              action:@selector(btnHelperClick)];
    [self.backView addSubview:_btnGroupHelper];
    
    [self updateItemButtonsLayout];
}

- (UIButton *)createItemButtonWithIcon:(NSString *)iconName title:(NSString *)title action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = DWScale(kItemCornerRadius);
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = DWScale(kItemBorderWidth);
    button.layer.tkThemeborderColors = @[COLOR_E8E8E8, COLOR_E8E8E8_DARK];
    button.tkThemebackgroundColors = @[COLORWHITE, COLOR_11];
    [button setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLORWHITE], [UIImage ImageForColor:COLORWHITE_DARK]]
                             forState:UIControlStateHighlighted];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *iconView = [[UIImageView alloc] initWithImage:ImgNamed(iconName)];
    iconView.tag = 1001;
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    [button addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(button).offset(DWScale(12));
        make.top.equalTo(button).offset(DWScale(12));
        make.size.mas_equalTo(CGSizeMake(DWScale(25), DWScale(25)));
    }];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.tkThemetextColors = @[HEXCOLOR(@"333333"), HEXCOLOR(@"333333")];
    titleLabel.font = FONTR(12);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = LanguageToolMatch(title);
    [button addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(iconView);
        make.top.equalTo(iconView.mas_bottom).offset(DWScale(8));
        make.trailing.lessThanOrEqualTo(button).offset(-DWScale(4));
    }];
    
    return button;
}

- (void)updateItemButtonsLayout {
    BOOL showFile = [UserManager.userRoleAuthInfo.isShowFileAssistant.configValue isEqualToString:@"true"];
    _btnFile.hidden = !showFile;
    CGFloat spacing = DWScale(kItemSpacing);
    
    [_btnNew mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset(DWScale(kItemVerticalInset));
        make.bottom.equalTo(self.backView).offset(-DWScale(kItemVerticalInset));
        make.leading.equalTo(self.backView);
        make.height.mas_equalTo(DWScale(kItemHeight));
    }];
    
    if (showFile) {
        [_btnFile mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.width.equalTo(_btnNew);
            make.leading.equalTo(_btnNew.mas_trailing).offset(spacing);
        }];
        [_btnGroupHelper mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.width.equalTo(_btnNew);
            make.leading.equalTo(_btnFile.mas_trailing).offset(spacing);
            make.trailing.equalTo(self.backView);
        }];
    } else {
        [_btnFile mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(0);
            make.leading.equalTo(_btnNew.mas_trailing);
        }];
        [_btnGroupHelper mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.width.equalTo(_btnNew);
            make.leading.equalTo(_btnNew.mas_trailing).offset(spacing);
            make.trailing.equalTo(self.backView);
        }];
    }
}

- (void)updateUI {
    [self updateItemButtonsLayout];
}

#pragma mark - 数据赋值
- (void)setNewFriendApplyNum:(NSInteger)newFriendApplyNum {
    _newFriendApplyNum = newFriendApplyNum;
    if (newFriendApplyNum > 0) {
        _lblRedNum.hidden = NO;
        if (newFriendApplyNum > 99) {
            _lblRedNum.text = @" 99+ ";
        } else {
            _lblRedNum.text = [NSString stringWithFormat:@"%ld", newFriendApplyNum];
        }
    } else {
        _lblRedNum.hidden = YES;
    }
}

#pragma mark - 交互事件
- (void)btnNewClick {
    if (_delegate && [_delegate respondsToSelector:@selector(contactHeaderAction:)]) {
        [_delegate contactHeaderAction:0];
    }
}

- (void)btnFileClick {
    if (_delegate && [_delegate respondsToSelector:@selector(contactHeaderAction:)]) {
        [_delegate contactHeaderAction:1];
    }
}

- (void)btnHelperClick {
    if (_delegate && [_delegate respondsToSelector:@selector(contactHeaderAction:)]) {
        [_delegate contactHeaderAction:2];
    }
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
    }
    return _backView;
}

@end
