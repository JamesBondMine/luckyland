//
//  LuckyLandIslandSceneView.m
//  LuckyLand
//
//  Created by 牛路伽 on 2026/6/17.
//

#import "LuckyLandIslandSceneView.h"

/// 海岛可点击区域（相对 land 图归一化坐标：x/y 为中心点，w/h 为宽高占比）
static NSString * const kLuckyLandIslandTapRegionKey = @"region";
static NSString * const kLuckyLandIslandIndexKey = @"index";

@interface LuckyLandIslandInteractionOverlayView : UIView
@end

@implementation LuckyLandIslandInteractionOverlayView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.userInteractionEnabled || self.hidden || self.alpha < 0.01) {
        return nil;
    }
    if (![self pointInside:point withEvent:event]) {
        return nil;
    }

    for (UIView *subview in [self.subviews reverseObjectEnumerator]) {
        if (subview.hidden || subview.alpha < 0.01 || !subview.userInteractionEnabled) {
            continue;
        }
        CGPoint localPoint = [subview convertPoint:point fromView:self];
        if ([subview pointInside:localPoint withEvent:event]) {
            UIView *hitView = [subview hitTest:localPoint withEvent:event];
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
          kLuckyLandIslandTapRegionKey: [NSValue valueWithCGRect:CGRectMake(0.20, 0.46, 0.22, 0.18)]},
        @{kLuckyLandIslandIndexKey: @(LuckyLandIslandIndexRocky),
          kLuckyLandIslandTapRegionKey: [NSValue valueWithCGRect:CGRectMake(0.50, 0.34, 0.28, 0.22)]},
        @{kLuckyLandIslandIndexKey: @(LuckyLandIslandIndexGrassy),
          kLuckyLandIslandTapRegionKey: [NSValue valueWithCGRect:CGRectMake(0.78, 0.60, 0.30, 0.24)]},
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
}

#pragma mark - Layout

- (void)relayoutIslandInteraction {
    [self layoutIslandButtons];
    [self updateHelicopterSizeIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.landImageView.frame = self.bounds;
    self.interactionOverlayView.frame = self.bounds;
    [self layoutIslandButtons];
    [self updateHelicopterSizeIfNeeded];
}

- (void)layoutIslandButtons {
    CGRect sceneBounds = self.interactionOverlayView.bounds;
    if (CGRectIsEmpty(sceneBounds)) {
        return;
    }

    [self.islandTapConfigs enumerateObjectsUsingBlock:^(NSDictionary *config, NSUInteger idx, BOOL *stop) {
        if (idx >= self.islandButtons.count) {
            return;
        }

        CGRect normalized = [config[kLuckyLandIslandTapRegionKey] CGRectValue];
        UIButton *button = self.islandButtons[idx];

        CGFloat width = normalized.size.width * sceneBounds.size.width;
        CGFloat height = normalized.size.height * sceneBounds.size.height;
        CGFloat centerX = normalized.origin.x * sceneBounds.size.width;
        CGFloat centerY = normalized.origin.y * sceneBounds.size.height;

        button.frame = CGRectMake(centerX - width * 0.5,
                                  centerY - height * 0.5,
                                  width,
                                  height);
    }];
}

- (void)updateHelicopterSizeIfNeeded {
    if (CGRectIsEmpty(self.interactionOverlayView.bounds)) {
        return;
    }

    CGFloat heliWidth = CGRectGetWidth(self.interactionOverlayView.bounds) * 0.26;
    UIImage *planeImage = self.helicopterImageView.image;
    if (!planeImage || planeImage.size.width <= 0) {
        return;
    }

    CGFloat aspect = planeImage.size.height / planeImage.size.width;
    self.helicopterImageView.bounds = CGRectMake(0, 0, heliWidth, heliWidth * aspect);
}

#pragma mark - Actions

- (void)islandButtonTapped:(UIButton *)sender {
    LuckyLandIslandIndex islandIndex = (LuckyLandIslandIndex)sender.tag;
    [self flyHelicopterToIsland:islandIndex];
}

#pragma mark - Helicopter animation

- (CGPoint)helicopterStartPoint {
    CGFloat marginX = CGRectGetWidth(self.interactionOverlayView.bounds) * 0.06;
    CGFloat marginY = CGRectGetHeight(self.interactionOverlayView.bounds) * 0.04;
    return CGPointMake(marginX, CGRectGetHeight(self.interactionOverlayView.bounds) - marginY);
}

- (CGPoint)centerForIsland:(LuckyLandIslandIndex)islandIndex {
    for (NSDictionary *config in self.islandTapConfigs) {
        if ([config[kLuckyLandIslandIndexKey] integerValue] != islandIndex) {
            continue;
        }
        CGRect normalized = [config[kLuckyLandIslandTapRegionKey] CGRectValue];
        return CGPointMake(normalized.origin.x * CGRectGetWidth(self.interactionOverlayView.bounds),
                           normalized.origin.y * CGRectGetHeight(self.interactionOverlayView.bounds));
    }
    return CGPointMake(CGRectGetMidX(self.interactionOverlayView.bounds),
                       CGRectGetMidY(self.interactionOverlayView.bounds));
}

- (void)flyHelicopterToIsland:(LuckyLandIslandIndex)islandIndex {
    if (CGRectIsEmpty(self.interactionOverlayView.bounds)) {
        return;
    }

    if (self.islandTapAction) {
        self.islandTapAction(islandIndex);
    }

    [self.helicopterImageView.layer removeAllAnimations];

    CGPoint startPoint = [self helicopterStartPoint];
    CGPoint endPoint = [self centerForIsland:islandIndex];

    self.helicopterImageView.hidden = NO;
    self.helicopterImageView.center = startPoint;

    CGFloat angle = atan2(endPoint.y - startPoint.y, endPoint.x - startPoint.x);
    self.helicopterImageView.transform = CGAffineTransformMakeRotation(angle);

    UIBezierPath *flightPath = [UIBezierPath bezierPath];
    [flightPath moveToPoint:startPoint];
    CGPoint controlPoint = CGPointMake((startPoint.x + endPoint.x) * 0.5,
                                       MIN(startPoint.y, endPoint.y) - CGRectGetHeight(self.interactionOverlayView.bounds) * 0.12);
    [flightPath addQuadCurveToPoint:endPoint controlPoint:controlPoint];

    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.path = flightPath.CGPath;
    positionAnimation.duration = 1.6;
    positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    positionAnimation.fillMode = kCAFillModeForwards;
    positionAnimation.removedOnCompletion = NO;

    [self.helicopterImageView.layer addAnimation:positionAnimation forKey:@"luckyLandHelicopterFly"];

    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(positionAnimation.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        strongSelf.helicopterImageView.center = endPoint;
        [strongSelf.helicopterImageView.layer removeAnimationForKey:@"luckyLandHelicopterFly"];
    });
}

@end
