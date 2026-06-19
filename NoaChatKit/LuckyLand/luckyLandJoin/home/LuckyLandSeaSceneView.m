//
//  LuckyLandSeaSceneView.m
//  LuckyLand
//
//  Created by 牛路伽 on 2026/6/17.
//

#import "LuckyLandSeaSceneView.h"
#import "LuckyLandBoatView.h"
#import <NoaChatCore/LingIMGroupMemberModel.h>

static CGFloat const kLuckyLandSeaTopRatio = 0.34;
static CGFloat const kLuckyLandBoatWidthRatio = 0.28;
static CGFloat const kLuckyLandBoatMinScale = 0.55;
static CGFloat const kLuckyLandBoatMaxScale = 1.0;

@interface LuckyLandSeaSceneView ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) NSMutableArray<LuckyLandBoatView *> *boatViews;
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
  self.boatConfigs = @[];

  _backgroundImageView = [[UIImageView alloc] initWithImage:ImgNamed(@"home_bg")];
  _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
  _backgroundImageView.userInteractionEnabled = NO;
  [self addSubview:_backgroundImageView];
}

#pragma mark - Public

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
  [self layoutBoats];
  if (self.isAnimating) {
    [self startBoatAnimations];
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
    boatView.frame = CGRectMake(0, 0, size.width, size.height);
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

#pragma mark - Helpers

- (NSString *)randomBoatImageName {
  NSInteger index = arc4random_uniform(5);
  return [NSString stringWithFormat:@"boat%ld", (long)index];
}

- (NSDictionary *)sailingConfigAtIndex:(NSUInteger)index {
  NSArray *templates = @[
    @{@"direction": @(LuckyLandBoatDirectionLeftToRight), @"y": @(0.22), @"duration": @(4), @"delay": @(0)},
    @{@"direction": @(LuckyLandBoatDirectionRightToLeft), @"y": @(0.34), @"duration": @(4), @"delay": @(2)},
    @{@"direction": @(LuckyLandBoatDirectionRightToLeft), @"y": @(0.04), @"duration": @(28), @"delay": @(1)},
    @{@"direction": @(LuckyLandBoatDirectionLeftToRight), @"y": @(0.42), @"duration": @(16), @"delay": @(4)},
    @{@"direction": @(LuckyLandBoatDirectionRightToLeft), @"y": @(0.52), @"duration": @(19), @"delay": @(10)},
    @{@"direction": @(LuckyLandBoatDirectionLeftToRight), @"y": @(0.62), @"duration": @(10), @"delay": @(6)},
    @{@"direction": @(LuckyLandBoatDirectionRightToLeft), @"y": @(0.74), @"duration": @(24), @"delay": @(8)},
    @{@"direction": @(LuckyLandBoatDirectionLeftToRight), @"y": @(0.12), @"duration": @(25), @"delay": @(12)},
    @{@"direction": @(LuckyLandBoatDirectionRightToLeft), @"y": @(0.19), @"duration": @(3), @"delay": @(14)},
  ];
  NSMutableDictionary *config = [[templates[index % templates.count] mutableCopy] ?: @{} mutableCopy];
  config[@"delay"] = @([config[@"delay"] doubleValue] + (index / templates.count) * 1.5);
  return [config copy];
}

@end
