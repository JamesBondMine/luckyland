//
//  NoaMsgAtListViewController.h
//  NoaKit
//
//  Created by LuckyLand on 2026/12/5.
//

#import "LuckyLandBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoaMsgAtListViewController : LuckyLandBaseViewController

@property (nonatomic, assign)CIMChatType chatType;
@property (nonatomic, copy)NSString *sessionId;
@property (nonatomic, copy)void(^AtUserSelectClick)(id _Nullable atModel);

@end

NS_ASSUME_NONNULL_END
