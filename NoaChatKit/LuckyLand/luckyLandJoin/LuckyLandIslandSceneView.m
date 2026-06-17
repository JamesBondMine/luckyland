//
//  LuckyLandIslandSceneView.m
//  LuckyLand
//
//  Created by 牛路伽 on 2026/6/17.
//

#import "LuckyLandIslandSceneView.h"

/// 海岛可点击区域（相对 land 原图归一化坐标：x/y 为中心点，w/h 为宽高占比）
static NSString * const kLuckyLandIslandTapRegionKey = @"region";
static NSString * const kLuckyLandIslandIndexKey = @"index";

@interface LuckyLandIslandInteractionOverlayView : UIView

@property (nonatomic, copy) NSArray<UIButton *> *islandButtons;

@end

@implementation LuckyLandIslandInteractionOverlayView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.userInteractionEnabled || self.hidden || self.alpha < 0.01) {
        return nil;
    }
    if (![self pointInside:point withEvent:event]) {
        return nil;
    }

    for (UIButton *button in [self.islandButtons reverseObjectEnumerator]) {
        if (button.hidden || button.alpha < 0.01 || !button.userInteractionEnabled) {
            continue;
        }
        CGPoint localPoint = [button convertPoint:point fromView:self];
        if ([button pointInside:localPoint withEvent:event]) {
            UIView *hitView = [button hitTest:localPoint withEvent:event];
            if (hitView) {
                return hitView;
            }
        }
    }

    return nil;
}

@end

@interface LuckyLandIslandSceneView ()

@property (nonatomic, strong, readwrite) UIView *interactionOverlayView;
@property (nonatomic, strong) UIImageView *landImageView;
@property (nonatomic, strong) UIImageView *helicopterImageView;
@property (nonatomic, strong) NSArray<NSDictionary *> *islandTapConfigs;
@property (nonatomic, strong) NSMutableArray<UIButton *> *islandButtons;
@property (nonatomic, assign) BOOL isFlying;

@end

@implementation LuckyLandIslandSceneView

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
    self.clipsToBounds = YES;
    self.userInteractionEnabled = NO;
    self.islandButtons = [NSMutableArray array];

    self.islandTapConfigs = @[
        @{kLuckyLandIslandIndexKey: @(LuckyLandIslandIndexForest),
          kLuckyLandIslandTapRegionKey: [NSValue valueWithCGRect:CGRectMake(0.18, 0.52, 0.44, 0.20)]},
        @{kLuckyLandIslandIndexKey: @(LuckyLandIslandIndexRocky),
          kLuckyLandIslandTapRegionKey: [NSValue valueWithCGRect:CGRectMake(0.6, 0.42, 0.39, 0.20)]},
        @{kLuckyLandIslandIndexKey: @(LuckyLandIslandIndexGrassy),
          kLuckyLandIslandTapRegionKey: [NSValue valueWithCGRect:CGRectMake(0.7, 0.65, 0.55, 0.22)]},
    ];

    _landImageView = [[UIImageView alloc] initWithImage:ImgNamed(@"land")];
    _landImageView.contentMode = UIViewContentModeScaleAspectFill;
    _landImageView.userInteractionEnabled = NO;
    [self addSubview:_landImageView];

    _interactionOverlayView = [[LuckyLandIslandInteractionOverlayView alloc] initWithFrame:CGRectZero];
    _interactionOverlayView.backgroundColor = UIColor.clearColor;

    _helicopterImageView = [[UIImageView alloc] initWithImage:ImgNamed(@"plane")];
    _helicopterImageView.contentMode = UIViewContentModeScaleAspectFit;
    _helicopterImageView.userInteractionEnabled = NO;
    _helicopterImageView.hidden = YES;
    [_interactionOverlayView addSubview:_helicopterImageView];

    for (NSDictionary *config in self.islandTapConfigs) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor colorWithWhite:1 alpha:0.001];
        button.tag = [config[kLuckyLandIslandIndexKey] integerValue];
        [button addTarget:self action:@selector(islandButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_interactionOverlayView addSubview:button];
        [self.islandButtons addObject:button];
    }

    ((LuckyLandIslandInteractionOverlayView *)_interactionOverlayView).islandButtons = [self.islandButtons copy];
}

#pragma mark - Layout

- (CGRect)displayedLandImageRectInBounds:(CGRect)bounds {
    UIImage *image = self.landImageView.image;
    if (!image || image.size.width <= 0 || image.size.height <= 0 || CGRectIsEmpty(bounds)) {
        return bounds;
    }

    CGFloat imageAspect = image.size.width / image.size.height;
    CGFloat viewAspect = bounds.size.width / bounds.size.height;

    if (viewAspect < imageAspect) {
        CGFloat displayHeight = bounds.size.height;
        CGFloat displayWidth = displayHeight * imageAspect;
        CGFloat originX = (bounds.size.width - displayWidth) * 0.5;
        return CGRectMake(originX, 0, displayWidth, displayHeight);
    }

    CGFloat displayWidth = bounds.size.width;
    CGFloat displayHeight = displayWidth / imageAspect;
    CGFloat originY = (bounds.size.height - displayHeight) * 0.5;
    return CGRectMake(0, originY, displayWidth, displayHeight);
}

- (CGRect)frameForNormalizedIslandRegion:(CGRect)normalized inBounds:(CGRect)bounds {
    CGRect imageRect = [self displayedLandImageRectInBounds:bounds];
    CGFloat width = normalized.size.width * imageRect.size.width;
    CGFloat height = normalized.size.height * imageRect.size.height;
    CGFloat centerX = imageRect.origin.x + normalized.origin.x * imageRect.size.width;
    CGFloat centerY = imageRect.origin.y + normalized.origin.y * imageRect.size.height;
    return CGRectMake(centerX - width * 0.5,
                      centerY - height * 0.5,
                      width,
                      height);
}

- (void)relayoutIslandInteraction {
    [self layoutIslandButtons];
    [self updateHelicopterSizeIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.landImageView.frame = self.bounds;
    [self layoutIslandButtons];
    [self updateHelicopterSizeIfNeeded];
}

- (void)layoutIslandButtons {
    CGRect sceneBounds = self.interactionOverlayView.bounds;
    if (CGRectIsEmpty(sceneBounds)) {
        sceneBounds = self.bounds;
    }
    if (CGRectIsEmpty(sceneBounds)) {
        return;
    }

    [self.islandTapConfigs enumerateObjectsUsingBlock:^(NSDictionary *config, NSUInteger idx, BOOL *stop) {
        if (idx >= self.islandButtons.count) {
            return;
        }

        CGRect normalized = [config[kLuckyLandIslandTapRegionKey] CGRectValue];
        UIButton *button = self.islandButtons[idx];
        button.frame = [self frameForNormalizedIslandRegion:normalized inBounds:sceneBounds];
    }];
}

- (void)updateHelicopterSizeIfNeeded {
    CGRect sceneBounds = self.interactionOverlayView.bounds;
    if (CGRectIsEmpty(sceneBounds)) {
        sceneBounds = self.bounds;
    }
    if (CGRectIsEmpty(sceneBounds)) {
        return;
    }

    CGFloat heliWidth = CGRectGetWidth(sceneBounds) * 0.26;
    UIImage *planeImage = self.helicopterImageView.image;
    if (!planeImage || planeImage.size.width <= 0) {
        return;
    }

    CGFloat aspect = planeImage.size.height / planeImage.size.width;
    self.helicopterImageView.bounds = CGRectMake(0, 0, heliWidth, heliWidth * aspect);
}

#pragma mark - Actions

- (void)setIslandButtonsEnabled:(BOOL)enabled {
    for (UIButton *button in self.islandButtons) {
        button.userInteractionEnabled = enabled;
    }
}

- (void)islandButtonTapped:(UIButton *)sender {
    if (self.isFlying) {
        return;
    }

    LuckyLandIslandIndex islandIndex = (LuckyLandIslandIndex)sender.tag;
    [self flyHelicopterToIsland:islandIndex];
}

#pragma mark - Helicopter animation

- (CGPoint)helicopterStartPointInBounds:(CGRect)bounds {
    CGFloat marginY = bounds.size.height * 0.03;
    return CGPointMake(CGRectGetMidX(bounds), CGRectGetMaxY(bounds) - marginY);
}

- (CGPoint)centerForIsland:(LuckyLandIslandIndex)islandIndex inBounds:(CGRect)bounds {
    for (NSDictionary *config in self.islandTapConfigs) {
        if ([config[kLuckyLandIslandIndexKey] integerValue] != islandIndex) {
            continue;
        }
        CGRect normalized = [config[kLuckyLandIslandTapRegionKey] CGRectValue];
        CGRect imageRect = [self displayedLandImageRectInBounds:bounds];
        return CGPointMake(imageRect.origin.x + normalized.origin.x * imageRect.size.width,
                           imageRect.origin.y + normalized.origin.y * imageRect.size.height);
    }
    return CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
}

- (void)flyHelicopterToIsland:(LuckyLandIslandIndex)islandIndex {
    CGRect sceneBounds = self.interactionOverlayView.bounds;
    if (CGRectIsEmpty(sceneBounds)) {
        sceneBounds = self.bounds;
    }
    if (CGRectIsEmpty(sceneBounds)) {
        return;
    }

    self.isFlying = YES;
    [self setIslandButtonsEnabled:NO];

    [self.helicopterImageView.layer removeAllAnimations];

    CGPoint startPoint = [self helicopterStartPointInBounds:sceneBounds];
    CGPoint endPoint = [self centerForIsland:islandIndex inBounds:sceneBounds];

    self.helicopterImageView.hidden = NO;
    self.helicopterImageView.center = startPoint;

    CGFloat angle = atan2(endPoint.y - startPoint.y, endPoint.x - startPoint.x);
//    self.helicopterImageView.transform = CGAffineTransformMakeRotation(angle);

    UIBezierPath *flightPath = [UIBezierPath bezierPath];
    [flightPath moveToPoint:startPoint];
    CGPoint controlPoint = CGPointMake((startPoint.x + endPoint.x) * 0.5,
                                       MIN(startPoint.y, endPoint.y) - sceneBounds.size.height * 0.10);
    [flightPath addQuadCurveToPoint:endPoint controlPoint:controlPoint];

    NSTimeInterval duration = 3.0;
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.path = flightPath.CGPath;
    positionAnimation.duration = duration;
    positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    positionAnimation.fillMode = kCAFillModeForwards;
    positionAnimation.removedOnCompletion = NO;

    [self.helicopterImageView.layer addAnimation:positionAnimation forKey:@"luckyLandHelicopterFly"];

    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }

        strongSelf.helicopterImageView.center = endPoint;
        [strongSelf.helicopterImageView.layer removeAnimationForKey:@"luckyLandHelicopterFly"];

        if (strongSelf.islandTapAction) {
            strongSelf.islandTapAction(islandIndex);
        }

        strongSelf.isFlying = NO;
        [strongSelf setIslandButtonsEnabled:YES];
    });
}

@end
