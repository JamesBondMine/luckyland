//
//  LuckyLandBoatView.m
//  LuckyLand
//
//  Created by 牛路伽 on 2026/6/17.
//

#import "LuckyLandBoatView.h"

static CGFloat const kLuckyLandBoatAvatarRatio = 0.44;
static CGFloat const kLuckyLandBoatBowXWhenFacingLeft = 0.12;
static CGFloat const kLuckyLandBoatSternXWhenFacingLeft = 0.80;
static CGFloat const kLuckyLandBoatAvatarCenterY = 0.60;

@interface LuckyLandBoatView ()

@property (nonatomic, strong) UIImageView *boatImageView;
@property (nonatomic, strong) UIImageView *bowAvatarView;
@property (nonatomic, strong) UIImageView *sternAvatarView;
@property (nonatomic, assign) BOOL isSailing;
@property (nonatomic, assign) CGFloat sailingStartX;
@property (nonatomic, assign) CGFloat sailingEndX;
@property (nonatomic, assign) CGFloat sailingCenterY;
@property (nonatomic, assign) NSTimeInterval sailingDuration;

@end

@implementation LuckyLandBoatView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self commonInit];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if (self) {
    [self commonInit];
  }
  return self;
}

- (void)commonInit {
  self.backgroundColor = UIColor.clearColor;
  self.clipsToBounds = NO;
  _direction = LuckyLandBoatDirectionRightToLeft;

  _boatImageView = [[UIImageView alloc] initWithImage:ImgNamed(@"boat0")];
  _boatImageView.contentMode = UIViewContentModeScaleAspectFit;
  _boatImageView.userInteractionEnabled = NO;
  [self addSubview:_boatImageView];

  _bowAvatarView = [self createAvatarView];
  _sternAvatarView = [self createAvatarView];
  [self addSubview:_bowAvatarView];
  [self addSubview:_sternAvatarView];

  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
  [self addGestureRecognizer:tap];
}

- (UIImageView *)createAvatarView {
  UIImageView *avatarView = [[UIImageView alloc] init];
  avatarView.contentMode = UIViewContentModeScaleAspectFill;
  avatarView.clipsToBounds = YES;
  avatarView.image = DefaultAvatar;
  avatarView.hidden = YES;
  avatarView.userInteractionEnabled = NO;
  avatarView.layer.borderWidth = 1.5;
  avatarView.layer.borderColor = UIColor.whiteColor.CGColor;
  return avatarView;
}

#pragma mark - Layout

- (void)layoutSubviews {
  [super layoutSubviews];

  self.boatImageView.frame = self.bounds;

  BOOL facingRight = (self.direction == LuckyLandBoatDirectionLeftToRight);
  self.boatImageView.transform = facingRight ? CGAffineTransformMakeScale(-1, 1) : CGAffineTransformIdentity;

  CGFloat avatarSize = CGRectGetWidth(self.bounds) * kLuckyLandBoatAvatarRatio;
  CGFloat bowX = facingRight ? kLuckyLandBoatSternXWhenFacingLeft : kLuckyLandBoatBowXWhenFacingLeft;
  CGFloat sternX = facingRight ? kLuckyLandBoatBowXWhenFacingLeft : kLuckyLandBoatSternXWhenFacingLeft;
  CGFloat avatarY = CGRectGetHeight(self.bounds) * kLuckyLandBoatAvatarCenterY;

  self.bowAvatarView.bounds = CGRectMake(0, 0, avatarSize, avatarSize);
  self.bowAvatarView.center = CGPointMake(CGRectGetWidth(self.bounds) * bowX, avatarY);
  [self.bowAvatarView rounded:avatarSize * 0.5];

  self.sternAvatarView.bounds = CGRectMake(0, 0, avatarSize, avatarSize);
  self.sternAvatarView.center = CGPointMake(CGRectGetWidth(self.bounds) * sternX, avatarY);
  [self.sternAvatarView rounded:avatarSize * 0.5];
}

#pragma mark - Public

- (void)setDirection:(LuckyLandBoatDirection)direction {
  if (_direction == direction) {
    return;
  }
  _direction = direction;
  [self setNeedsLayout];
}

- (void)setBowAvatarImage:(UIImage *)image {
  if (image) {
    self.bowAvatarView.image = image;
    self.bowAvatarView.hidden = NO;
  } else {
    self.bowAvatarView.image = DefaultAvatar;
    self.bowAvatarView.hidden = YES;
  }
}

- (void)setSternAvatarImage:(UIImage *)image {
  if (image) {
    self.sternAvatarView.image = image;
    self.sternAvatarView.hidden = NO;
  } else {
    self.sternAvatarView.image = DefaultAvatar;
    self.sternAvatarView.hidden = YES;
  }
}

- (void)setBowAvatarURL:(NSString *)url {
  if (url.length == 0) {
    [self setBowAvatarImage:nil];
    return;
  }
  self.bowAvatarView.hidden = NO;
  [self.bowAvatarView sd_setImageWithURL:[url getImageFullUrl]
                        placeholderImage:DefaultAvatar
                                 options:SDWebImageAllowInvalidSSLCertificates];
}

- (void)setSternAvatarURL:(NSString *)url {
  if (url.length == 0) {
    [self setSternAvatarImage:nil];
    return;
  }
  self.sternAvatarView.hidden = NO;
  [self.sternAvatarView sd_setImageWithURL:[url getImageFullUrl]
                          placeholderImage:DefaultAvatar
                                   options:SDWebImageAllowInvalidSSLCertificates];
}

- (void)startSailingFromX:(CGFloat)startX
                      toX:(CGFloat)endX
                  centerY:(CGFloat)centerY
                 duration:(NSTimeInterval)duration
                    delay:(NSTimeInterval)delay {
  self.isSailing = YES;
  self.sailingStartX = startX;
  self.sailingEndX = endX;
  self.sailingCenterY = centerY;
  self.sailingDuration = MAX(duration, 0.1);

  [self.layer removeAllAnimations];
  self.center = CGPointMake(startX, centerY);
  [self startBobbingAnimation];

  __weak typeof(self) weakSelf = self;
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    __strong typeof(weakSelf) strongSelf = weakSelf;
    if (!strongSelf || !strongSelf.isSailing) {
      return;
    }
    [strongSelf runSailingStep];
  });
}

- (void)stopSailing {
  self.isSailing = NO;
  [self.layer removeAllAnimations];
}

#pragma mark - Animation

- (void)startBobbingAnimation {
  CABasicAnimation *bobbing = [CABasicAnimation animationWithKeyPath:@"position.y"];
  bobbing.fromValue = @(self.sailingCenterY - 4);
  bobbing.toValue = @(self.sailingCenterY + 4);
  bobbing.duration = 1.8;
  bobbing.autoreverses = YES;
  bobbing.repeatCount = HUGE_VALF;
  bobbing.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  [self.layer addAnimation:bobbing forKey:@"luckyLandBoatBobbing"];
}

- (void)runSailingStep {
  if (!self.isSailing || !self.superview) {
    return;
  }

  self.center = CGPointMake(self.sailingStartX, self.sailingCenterY);

  __weak typeof(self) weakSelf = self;
  [UIView animateWithDuration:self.sailingDuration
                        delay:0
                      options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                   animations:^{
    weakSelf.center = CGPointMake(weakSelf.sailingEndX, weakSelf.sailingCenterY);
  } completion:^(BOOL finished) {
    __strong typeof(weakSelf) strongSelf = weakSelf;
    if (!strongSelf || !finished || !strongSelf.isSailing) {
      return;
    }
    [strongSelf runSailingStep];
  }];
}

#pragma mark - Actions

- (void)handleTap {
  if (self.tapAction) {
    self.tapAction(self);
  }
}

@end
