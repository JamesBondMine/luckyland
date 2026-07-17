//
//  LuckyLandSeaSceneView.h
//  LuckyLand
//
//  Created by 牛路伽 on 2026/6/17.
//

#import <UIKit/UIKit.h>

@class LuckyLandBoatView;
@class LingIMGroupMemberModel;
@class NoaUserModel;

NS_ASSUME_NONNULL_BEGIN

/// 企业号首页海面场景：背景 + 群成员小船
@interface LuckyLandSeaSceneView : UIView

/// 点击小船回调，memberUid 为群成员 userUid
@property (nonatomic, copy, nullable) void (^boatTapAction)(LuckyLandBoatView *boatView, NSString *memberUid);

/// 点击天空固定头像回调
@property (nonatomic, copy, nullable) void (^skyAvatarTapAction)(NSString *memberUid);

/// 按群成员列表刷新小船（一对一）
- (void)reloadWithGroupMembers:(NSArray<LingIMGroupMemberModel *> *)members;

/// 天空固定展示的用户头像（最多 3 个，位置固定）
- (void)reloadSkyAvatarsWithUsers:(NSArray<NoaUserModel *> *)users;

/// 当前展示的小船数量
- (NSInteger)displayedBoatCount;

/// 开始小船航行动画
- (void)startBoatAnimations;

/// 停止小船航行动画
- (void)stopBoatAnimations;

@end

NS_ASSUME_NONNULL_END
