//
//  LuckyLandSeaSceneView.h
//  LuckyLand
//
//  Created by 牛路伽 on 2026/6/17.
//

#import <UIKit/UIKit.h>

@class LuckyLandBoatView;

NS_ASSUME_NONNULL_BEGIN

/// 幸运岛首页海面场景：背景 + 多艘漂浮小船
@interface LuckyLandSeaSceneView : UIView

/// 点击小船回调
@property (nonatomic, copy, nullable) void (^boatTapAction)(LuckyLandBoatView *boatView, NSInteger boatIndex);

/// 开始小船航行动画
- (void)startBoatAnimations;

/// 停止小船航行动画
- (void)stopBoatAnimations;

@end

NS_ASSUME_NONNULL_END
