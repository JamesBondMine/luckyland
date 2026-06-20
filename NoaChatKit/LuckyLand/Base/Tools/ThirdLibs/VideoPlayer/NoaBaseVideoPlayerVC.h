//
//  NoaBaseVideoPlayerVC.h
//  NoaKit
//
//  Created by LuckyLand on 2026/9/24.
//

#import "LuckyLandBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoaBaseVideoPlayerVC : LuckyLandBaseViewController
//视频封面地址
@property (nonatomic, copy) NSString *videoCoverUrl;
//视频地址
@property (nonatomic, copy) NSString *videoUrl;
@end

NS_ASSUME_NONNULL_END
