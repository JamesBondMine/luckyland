//
//  LuckyLandSeaSceneView.m
//  LuckyLand
//
//  Created by 牛路伽 on 2026/6/17.
//

#import "LuckyLandSeaSceneView.h"
#import "LuckyLandBoatView.h"

static CGFloat const kLuckyLandSeaTopRatio = 0.34;
static CGFloat const kLuckyLandBoatWidthRatio = 0.28;

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
  self.boatViews = [NSMutableArray array];

  _backgroundImageView = [[UIImageView alloc] initWithImage:ImgNamed(@"home_bg")];
  _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
  _backgroundImageView.userInteractionEnabled = NO;
  [self addSubview:_backgroundImageView];

  self.boatConfigs = @[
    @{@"direction": @(LuckyLandBoatDirectionLeftToRight), @"y": @(0.52), @"duration": @(22), @"delay": @(0)},
    @{@"direction": @(LuckyLandBoatDirectionRightToLeft), @"y": @(0.62), @"duration": @(26), @"delay": @(3)},
    @{@"direction": @(LuckyLandBoatDirectionLeftToRight), @"y": @(0.72), @"duration": @(30), @"delay": @(6)},
    @{@"direction": @(LuckyLandBoatDirectionRightToLeft), @"y": @(0.34), @"duration": @(24), @"delay": @(2)},
    @{@"direction": @(LuckyLandBoatDirectionLeftToRight), @"y": @(0.22), @"duration": @(20), @"delay": @(0)},
    @{@"direction": @(LuckyLandBoatDirectionRightToLeft), @"y": @(0.44), @"duration": @(24), @"delay": @(2)},
  ];

  [self.boatConfigs enumerateObjectsUsingBlock:^(NSDictionary *config, NSUInteger idx, BOOL *stop) {
    LuckyLandBoatView *boatView = [[LuckyLandBoatView alloc] initWithFrame:CGRectZero];
    boatView.direction = [config[@"direction"] integerValue];
    boatView.tag = idx;
    [self addSubview:boatView];
    [self.boatViews addObject:boatView];

    __weak typeof(self) weakSelf = self;
    boatView.tapAction = ^(LuckyLandBoatView *boat) {
      __strong typeof(weakSelf) strongSelf = weakSelf;
      if (strongSelf.boatTapAction) {
        strongSelf.boatTapAction(boat, boat.tag);
      }
    };

    if (idx % 2 == 0) {
      [boatView setBowAvatarImage:DefaultAvatar];
    } else {
      [boatView setBowAvatarImage:DefaultAvatar];
      [boatView setSternAvatarImage:DefaultAvatar];
    }
  }];
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

- (CGSize)boatSize {
  CGFloat boatWidth = CGRectGetWidth(self.bounds) * kLuckyLandBoatWidthRatio;
  UIImage *boatImage = ImgNamed(@"boat0");
  CGFloat aspect = (boatImage.size.width > 0) ? (boatImage.size.height / boatImage.size.width) : 1.0;
  return CGSizeMake(boatWidth, boatWidth * aspect);
}

- (void)layoutBoats {
  if (CGRectIsEmpty(self.bounds)) {
    return;
  }

  CGSize size = [self boatSize];
  for (NSUInteger idx = 0; idx < self.boatViews.count; idx++) {
    LuckyLandBoatView *boatView = self.boatViews[idx];
    NSDictionary *config = self.boatConfigs[idx];
    CGFloat centerY = [self seaYForNormalized:[config[@"y"] floatValue]];
    boatView.frame = CGRectMake(0, 0, size.width, size.height);
    boatView.center = CGPointMake(-size.width, centerY);
  }
}

#pragma mark - Animation

- (void)startBoatAnimations {
  self.isAnimating = YES;
  if (CGRectIsEmpty(self.bounds)) {
    return;
  }

  CGSize size = [self boatSize];
  CGFloat offscreenX = CGRectGetWidth(self.bounds) + size.width;

  for (NSUInteger idx = 0; idx < self.boatViews.count; idx++) {
    LuckyLandBoatView *boatView = self.boatViews[idx];
    NSDictionary *config = self.boatConfigs[idx];
    CGFloat centerY = [self seaYForNormalized:[config[@"y"] floatValue]];
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

@end
