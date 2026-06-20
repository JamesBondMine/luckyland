//
//  LuckyLandHomeViewController.h
//  NoaKit
//
//  Created by Apple on 2026/9/2.
//

#import "LuckyLandBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LuckyLandConversationViewController : LuckyLandBaseViewController

- (void)sessionListAllRead:(NSString *)lastServerMsgId;

@end

NS_ASSUME_NONNULL_END
