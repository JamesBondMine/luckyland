//
//  LuckyLandIslandSceneView.h
//  LuckyLand
//
//  Created by 牛路伽 on 2026/6/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LuckyLandIslandIndex) {
    LuckyLandIslandIndexForest = 0,
    LuckyLandIslandIndexRocky = 1,
    LuckyLandIslandIndexGrassy = 2,
};

/// 幸运岛海面场景：展示海岛背景，点击海岛时直升机从左下角飞入
@interface LuckyLandIslandSceneView : UIView

/// 仅负责海岛点击与直升机动画，背景透明，可叠在表单上方
@property (nonatomic, strong, readonly) UIView *interactionOverlayView;

/// 直升机开始飞向海岛时触发（用于发起幸运数字加入）
@property (nonatomic, copy, nullable) void (^islandTapAction)(LuckyLandIslandIndex islandIndex);

/// 在布局变化后刷新海岛点击区域（交互层可能被加到 VC 根视图上）
- (void)relayoutIslandInteraction;

@end

NS_ASSUME_NONNULL_END
