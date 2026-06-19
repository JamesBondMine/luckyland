//
//  LuckyLandSeaSceneView.h
//  LuckyLand
//
//  Created by 牛路伽 on 2026/6/17.
//

#import <UIKit/UIKit.h>

@class LuckyLandBoatView;
@class LingIMGroupMemberModel;

NS_ASSUME_NONNULL_BEGIN

/// 幸运岛首页海面场景：背景 + 群成员小船
@interface LuckyLandSeaSceneView : UIView

/// 点击小船回调，memberUid 为群成员 userUid
@property (nonatomic, copy, nullable) void (^boatTapAction)(LuckyLandBoatView *boatView, NSString *memberUid);

/// 按群成员列表刷新小船（一对一）
- (void)reloadWithGroupMembers:(NSArray<LingIMGroupMemberModel *> *)members;

/// 开始小船航行动画
- (void)startBoatAnimations;

/// 停止小船航行动画
- (void)stopBoatAnimations;

@end

NS_ASSUME_NONNULL_END
