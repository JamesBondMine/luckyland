//
//  LuckyLandNativeMineCell.m
//  LuckyLand
//

#import "LuckyLandNativeMineCell.h"

@interface LuckyLandNativeMineCell ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@end

@implementation LuckyLandNativeMineCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = UIColor.whiteColor;

    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_iconImageView];

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    _titleLabel.textColor = HEXCOLOR(@"333333");
    [self addSubview:_titleLabel];

    UIImage *arrow = nil;
    if (@available(iOS 13.0, *)) {
        arrow = [UIImage systemImageNamed:@"chevron.right"];
    }
    _arrowImageView = [[UIImageView alloc] initWithImage:arrow];
    _arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    _arrowImageView.tintColor = HEXCOLOR(@"999999");
    [self addSubview:_arrowImageView];

    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(20);
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(20);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImageView.mas_trailing).offset(8);
        make.centerY.equalTo(self);
        make.trailing.lessThanOrEqualTo(self.arrowImageView.mas_leading).offset(-8);
    }];
    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-20);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(14);
    }];
}

- (void)configureWithTitle:(NSString *)title iconName:(NSString *)iconName {
    self.titleLabel.text = title ?: @"";
    self.iconImageView.image = ImgNamed(iconName);
}

@end
