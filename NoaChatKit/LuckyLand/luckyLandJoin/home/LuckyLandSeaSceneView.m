//
//  LuckyLandSeaSceneView.m
//  LuckyLand
//
//  Created by 牛路伽 on 2026/6/17.
//

#import "LuckyLandSeaSceneView.h"
#import "LuckyLandBoatView.h"
#import "NoaUserModel.h"
#import <NoaChatCore/LingIMGroupMemberModel.h>
// 海面起始位置（比例越小，天空越少、海面越高）
static CGFloat const kLuckyLandSeaTopRatio = 0.18;
static CGFloat const kLuckyLandBoatWidthRatio = 0.19;
static CGFloat const kLuckyLandBoatMinScale = 0.48;
static CGFloat const kLuckyLandBoatMaxScale = 0.82;
static CGFloat const kLuckyLandSkyAvatarScreenRatio = 0.12;

@interface LuckyLandSkyAvatarControl : UIControl

@property (nonatomic, copy) NSString *userUid;
@property (nonatomic, assign) CGFloat skyXRatio;
@property (nonatomic, strong) UIImageView *avatarView;

@end

@implementation LuckyLandSkyAvatarControl

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    _avatarView = [[UIImageView alloc] initWithFrame:self.bounds];
    _avatarView.contentMode = UIViewContentModeScaleAspectFill;
    _avatarView.clipsToBounds = YES;
    _avatarView.userInteractionEnabled = NO;
    _avatarView.image = DefaultAvatar;
    _avatarView.layer.borderWidth = 2.f;
    _avatarView.layer.borderColor = UIColor.whiteColor.CGColor;
    [self addSubview:_avatarView];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  self.avatarView.frame = self.bounds;
  self.avatarView.layer.cornerRadius = CGRectGetWidth(self.bounds) * 0.5;
}

@end

@interface LuckyLandSeaSceneView ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIView *skyAvatarContainerView;
@property (nonatomic, strong) NSMutableArray<LuckyLandBoatView *> *boatViews;
@property (nonatomic, strong) NSMutableArray<LuckyLandSkyAvatarControl *> *skyAvatarViews;
@property (nonatomic, copy) NSArray<NSDictionary *> *boatConfigs;
@property (nonatomic, assign) BOOL isAnimating;

@end

@implementation LuckyLandSeaSceneView

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
  self.clipsToBounds = YES;
  self.userInteractionEnabled = YES;
  self.boatViews = [NSMutableArray array];
  self.skyAvatarViews = [NSMutableArray array];
  self.boatConfigs = @[];

  _backgroundImageView = [[UIImageView alloc] initWithImage:ImgNamed(@"home_bg")];
  _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
  _backgroundImageView.userInteractionEnabled = NO;
  [self addSubview:_backgroundImageView];

  _skyAvatarContainerView = [[UIView alloc] initWithFrame:CGRectZero];
  _skyAvatarContainerView.backgroundColor = UIColor.clearColor;
  _skyAvatarContainerView.userInteractionEnabled = YES;
  [self addSubview:_skyAvatarContainerView];
}

#pragma mark - Public

- (NSInteger)displayedBoatCount {
  return self.boatViews.count;
}

- (void)reloadSkyAvatarsWithUsers:(NSArray<NoaUserModel *> *)users {
  for (LuckyLandSkyAvatarControl *avatarControl in self.skyAvatarViews) {
    [avatarControl removeFromSuperview];
  }
  [self.skyAvatarViews removeAllObjects];

  NSArray<NSNumber *> *xRatios = @[@0.20, @0.50, @0.80];
  NSInteger slotCount = MIN((NSInteger)xRatios.count, (NSInteger)users.count);
  for (NSInteger idx = 0; idx < slotCount; idx++) {
    NoaUserModel *user = users[idx];
    if (user.userUID.length == 0) {
      continue;
    }

    LuckyLandSkyAvatarControl *avatarControl = [[LuckyLandSkyAvatarControl alloc] initWithFrame:CGRectZero];
    avatarControl.userUid = user.userUID;
    avatarControl.accessibilityLabel = user.userName;
    avatarControl.tag = idx;
    avatarControl.skyXRatio = [xRatios[idx] doubleValue];
    if (user.avatar.length > 0) {
      [avatarControl.avatarView sd_setImageWithURL:[user.avatar getImageFullUrl]
                                  placeholderImage:DefaultAvatar
                                           options:SDWebImageAllowInvalidSSLCertificates];
    } else {
      avatarControl.avatarView.image = DefaultAvatar;
    }
    [avatarControl addTarget:self
                      action:@selector(handleSkyAvatarTap:)
            forControlEvents:UIControlEventTouchUpInside];
    [self.skyAvatarContainerView addSubview:avatarControl];
    [self.skyAvatarViews addObject:avatarControl];
  }

  [self setNeedsLayout];
  [self layoutIfNeeded];
}

- (void)reloadWithGroupMembers:(NSArray<LingIMGroupMemberModel *> *)members {
  [self stopBoatAnimations];

  for (LuckyLandBoatView *boatView in self.boatViews) {
    [boatView removeFromSuperview];
  }
  [self.boatViews removeAllObjects];

  NSMutableArray *validMembers = [NSMutableArray array];
  for (LingIMGroupMemberModel *member in members) {
    if (member.isDel || member.userUid.length == 0) {
      continue;
    }
    [validMembers addObject:member];
  }

  NSMutableArray *configs = [NSMutableArray array];
  [validMembers enumerateObjectsUsingBlock:^(LingIMGroupMemberModel *member, NSUInteger idx, BOOL *stop) {
    LuckyLandBoatView *boatView = [[LuckyLandBoatView alloc] initWithFrame:CGRectZero];
    NSDictionary *config = [self sailingConfigAtIndex:idx];
    boatView.direction = [config[@"direction"] integerValue];
    boatView.tag = idx;
    boatView.memberUid = member.userUid;
    [boatView setBoatImageName:[self randomBoatImageName]];
    [boatView setBowAvatarURL:member.userAvatar];
    [self addSubview:boatView];
    [self.boatViews addObject:boatView];
    [configs addObject:config];

    __weak typeof(self) weakSelf = self;
    boatView.tapAction = ^(LuckyLandBoatView *boat) {
      __strong typeof(weakSelf) strongSelf = weakSelf;
      if (strongSelf.boatTapAction && boat.memberUid.length > 0) {
        strongSelf.boatTapAction(boat, boat.memberUid);
      }
    };
  }];
  self.boatConfigs = [configs copy];

  [self setNeedsLayout];
  [self layoutIfNeeded];
  if (self.isAnimating) {
    [self startBoatAnimations];
  }
}

#pragma mark - Layout

- (void)layoutSubviews {
  [super layoutSubviews];
  self.backgroundImageView.frame = self.bounds;
  [self layoutSkyAvatars];
  [self layoutBoats];
  if (self.isAnimating) {
    [self startBoatAnimations];
  }
}

- (CGFloat)skyAvatarDiameter {
  return CGRectGetWidth(self.bounds) * kLuckyLandSkyAvatarScreenRatio;
}

- (CGFloat)skyAvatarCenterY {
  CGFloat seaTop = CGRectGetHeight(self.bounds) * kLuckyLandSeaTopRatio;
  CGFloat topInset = 0.f;
  if (@available(iOS 11.0, *)) {
    topInset = self.safeAreaInsets.top;
  }
  CGFloat preferredY = topInset + [self skyAvatarDiameter] * 0.75;
  CGFloat maxY = seaTop * 0.55;
  return MIN(preferredY, maxY);
}

- (void)layoutSkyAvatars {
  self.skyAvatarContainerView.frame = self.bounds;
  if (self.skyAvatarViews.count == 0) {
    return;
  }

  CGFloat diameter = [self skyAvatarDiameter];
  CGFloat centerY = [self skyAvatarCenterY];
  for (LuckyLandSkyAvatarControl *avatarControl in self.skyAvatarViews) {
    CGFloat xRatio = avatarControl.skyXRatio;
    avatarControl.frame = CGRectMake(0, 0, diameter, diameter);
    avatarControl.center = CGPointMake(CGRectGetWidth(self.bounds) * xRatio, centerY);
  }
}

- (CGFloat)seaYForNormalized:(CGFloat)normalizedY {
  CGFloat seaTop = CGRectGetHeight(self.bounds) * kLuckyLandSeaTopRatio;
  CGFloat seaHeight = CGRectGetHeight(self.bounds) - seaTop;
  return seaTop + seaHeight * normalizedY;
}

- (CGFloat)boatWidthForNormalizedY:(CGFloat)normalizedY {
  CGFloat baseWidth = CGRectGetWidth(self.bounds) * kLuckyLandBoatWidthRatio;
  normalizedY = MAX(0.f, MIN(1.f, normalizedY));
  CGFloat scale = kLuckyLandBoatMinScale + (kLuckyLandBoatMaxScale - kLuckyLandBoatMinScale) * normalizedY;
  return baseWidth * scale;
}

- (void)layoutBoats {
  if (CGRectIsEmpty(self.bounds)) {
    return;
  }

  for (NSUInteger idx = 0; idx < self.boatViews.count; idx++) {
    LuckyLandBoatView *boatView = self.boatViews[idx];
    NSDictionary *config = self.boatConfigs[idx];
    CGFloat normalizedY = [config[@"y"] floatValue];
    CGFloat width = [self boatWidthForNormalizedY:normalizedY];
    CGSize size = [boatView boatImageSizeForWidth:width];
    CGFloat centerY = [self seaYForNormalized:normalizedY];
    boatView.frame = CGRectMake(0, 0, size.width * 1.3, size.height * 1.3);
    boatView.center = CGPointMake(-size.width, centerY);
  }
}

#pragma mark - Animation

- (void)startBoatAnimations {
  self.isAnimating = YES;
  if (CGRectIsEmpty(self.bounds) || self.boatViews.count == 0) {
    return;
  }

  for (NSUInteger idx = 0; idx < self.boatViews.count; idx++) {
    LuckyLandBoatView *boatView = self.boatViews[idx];
    NSDictionary *config = self.boatConfigs[idx];
    CGFloat normalizedY = [config[@"y"] floatValue];
    CGFloat width = [self boatWidthForNormalizedY:normalizedY];
    CGSize size = [boatView boatImageSizeForWidth:width];
    CGFloat offscreenX = CGRectGetWidth(self.bounds) + size.width;
    CGFloat centerY = [self seaYForNormalized:normalizedY];
    NSTimeInterval duration = [config[@"duration"] doubleValue];
    NSTimeInterval delay = [config[@"delay"] doubleValue];
    LuckyLandBoatDirection direction = [config[@"direction"] integerValue];

    CGFloat startX = (direction == LuckyLandBoatDirectionLeftToRight) ? -size.width : offscreenX;
    CGFloat endX = (direction == LuckyLandBoatDirectionLeftToRight) ? offscreenX : -size.width;

    [boatView stopSailing];
    [boatView startSailingFromX:startX toX:endX centerY:centerY duration:duration delay:delay];
  }
}

- (void)stopBoatAnimations {
  self.isAnimating = NO;
  for (LuckyLandBoatView *boatView in self.boatViews) {
    [boatView stopSailing];
  }
}

#pragma mark - Actions

- (void)handleSkyAvatarTap:(LuckyLandSkyAvatarControl *)sender {
  if (self.skyAvatarTapAction && sender.userUid.length > 0) {
    self.skyAvatarTapAction(sender.userUid);
  }
}

#pragma mark - Helpers

- (NSString *)randomBoatImageName {
  NSInteger index = arc4random_uniform(5);
  return [NSString stringWithFormat:@"boat%ld", (long)index];
}

- (NSDictionary *)sailingConfigAtIndex:(NSUInteger)index {
  NSArray *templates = @[
    @{@"direction": @(LuckyLandBoatDirectionLeftToRight), @"y": @(0.06), @"duration": @(4), @"delay": @(0)},
    @{@"direction": @(LuckyLandBoatDirectionRightToLeft), @"y": @(0.18), @"duration": @(4), @"delay": @(2)},
    @{@"direction": @(LuckyLandBoatDirectionRightToLeft), @"y": @(0.30), @"duration": @(28), @"delay": @(1)},
    @{@"direction": @(LuckyLandBoatDirectionLeftToRight), @"y": @(0.42), @"duration": @(16), @"delay": @(4)},
    @{@"direction": @(LuckyLandBoatDirectionRightToLeft), @"y": @(0.54), @"duration": @(19), @"delay": @(10)},
    @{@"direction": @(LuckyLandBoatDirectionLeftToRight), @"y": @(0.66), @"duration": @(10), @"delay": @(6)},
    @{@"direction": @(LuckyLandBoatDirectionRightToLeft), @"y": @(0.68), @"duration": @(24), @"delay": @(8)},
    @{@"direction": @(LuckyLandBoatDirectionLeftToRight), @"y": @(0.12), @"duration": @(25), @"delay": @(12)},
    @{@"direction": @(LuckyLandBoatDirectionRightToLeft), @"y": @(0.24), @"duration": @(3), @"delay": @(14)},
  ];
  NSMutableDictionary *config = [[templates[index % templates.count] mutableCopy] ?: @{} mutableCopy];
  NSUInteger cycle = index / templates.count;
  if (cycle > 0) {
    CGFloat yBase = [config[@"y"] floatValue];
    CGFloat laneOffset = (cycle % 3) * 0.10;
    config[@"y"] = @(MIN(yBase + laneOffset, 0.88));
    config[@"delay"] = @([config[@"delay"] doubleValue] + cycle * 1.5);
  }
  return [config copy];
}

@end
