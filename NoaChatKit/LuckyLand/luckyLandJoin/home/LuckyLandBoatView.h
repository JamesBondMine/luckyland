//
//  LuckyLandBoatView.h
//  LuckyLand
//
//  Created by 牛路伽 on 2026/6/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LuckyLandBoatDirection) {
  /// 小船朝右，自左向右航行
  LuckyLandBoatDirectionLeftToRight = 0,
  /// 小船朝左，自右向左航行
  LuckyLandBoatDirectionRightToLeft = 1,
};

/// 幸运岛小船：可点击，船头/船尾可放置头像
@interface LuckyLandBoatView : UIView

@property (nonatomic, assign) LuckyLandBoatDirection direction;

/// 对应群成员 userUid
@property (nonatomic, copy, nullable) NSString *memberUid;

/// 点击小船回调
@property (nonatomic, copy, nullable) void (^tapAction)(LuckyLandBoatView *boatView);

/// 设置小船图片（boat0 ~ boat4）
- (void)setBoatImageName:(NSString *)imageName;

/// 按给定宽度计算小船展示尺寸
- (CGSize)boatImageSizeForWidth:(CGFloat)width;

/// 设置船头头像
- (void)setBowAvatarImage:(nullable UIImage *)image;
- (void)setBowAvatarURL:(nullable NSString *)url;

/// 设置船尾头像
- (void)setSternAvatarImage:(nullable UIImage *)image;
- (void)setSternAvatarURL:(nullable NSString *)url;

/// 开始在海面区域航行（水平往复循环）
- (void)startSailingFromX:(CGFloat)startX
                      toX:(CGFloat)endX
                  centerY:(CGFloat)centerY
                 duration:(NSTimeInterval)duration
                    delay:(NSTimeInterval)delay;

/// 停止航行与起伏动画
- (void)stopSailing;

@end

NS_ASSUME_NONNULL_END
