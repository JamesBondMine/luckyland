//
//  NoaTeamCreateDataHandle.h
//  NoaKit
//
//  Created by ppppphl on 2025/7/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoaTeamCreateDataHandle : NSObject

/// 创建团队
@property (nonatomic, strong) RACCommand *createTeamCommand;

/// 请求随机幸运数字
@property (nonatomic, strong) RACCommand *requestRandomCodeCommand;

/// 当前的随机验证码
@property (nonatomic, copy, readonly) NSString *randomCode;

/// 返回上一级页面
@property (nonatomic, strong) RACSubject *backSubject;

/// 展示code验证码异常文案
@property (nonatomic, strong) RACSubject *showCodeErrorSubject;

/// 判断幸运数字是否符合格式(4位长度，纯数字)
/// - Parameter code: 幸运数字
- (BOOL)validateInviteCode:(NSString *)code;

@end

NS_ASSUME_NONNULL_END
