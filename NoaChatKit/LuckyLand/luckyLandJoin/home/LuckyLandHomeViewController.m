//
//  LuckyLandHomeViewController.m
//  LuckyLand
//
//  Created by 牛路伽 on 2026/6/17.
//

#import "LuckyLandHomeViewController.h"
#import "LuckyLandSeaSceneView.h"
#import "LuckyLandBoatView.h"
#import "LingIMGroup.h"
#import "NoaMessageTools.h"
#import "LuckyLandUserHomePageVC.h"
#import "LuckLandContactVC.h"
#import "NoaUserModel.h"

static NSInteger const kLuckyLandGroupInfoMaxRetryCount = 2;
static NSArray<NSString *> * const kLuckyLandFallbackSkyUsernames = @[@"james8099", @"james8100", @"james8101"];

@interface LuckyLandHomeViewController ()

@property (nonatomic, strong) LuckyLandSeaSceneView *seaSceneView;
@property (nonatomic, strong) UIButton *emptyHintButton;
@property (nonatomic, strong) LingIMGroup *groupInfoModel;
@property (nonatomic, copy) NSString *groupID;
@property (nonatomic, assign) NSTimeInterval lastForegroundRefreshTimestamp;
@property (nonatomic, assign) BOOL isRequestingGroupInfo;

@end

@implementation LuckyLandHomeViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.groupID = @"1001";
  [self setupSeaScene];
  [self setupEmptyHint];
  [self setupAppLifecycleObservers];
  [self loadFallbackSkyUsers];
  [self requestGroupInfo];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:animated];
  [self refreshSeaSceneIfNeededOnAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [self.seaSceneView stopBoatAnimations];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI

- (void)setupSeaScene {
  self.seaSceneView = [[LuckyLandSeaSceneView alloc] initWithFrame:CGRectZero];
  [self.view addSubview:self.seaSceneView];
  [self.seaSceneView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.view);
  }];

  __weak typeof(self) weakSelf = self;
  self.seaSceneView.boatTapAction = ^(LuckyLandBoatView *boatView, NSString *memberUid) {
    __strong typeof(weakSelf) strongSelf = weakSelf;
    if (!strongSelf || memberUid.length == 0) {
      return;
    }
    [strongSelf pushSuggestUserInfoWithUid:memberUid];
  };
  self.seaSceneView.skyAvatarTapAction = ^(NSString *memberUid) {
    __strong typeof(weakSelf) strongSelf = weakSelf;
    if (!strongSelf || memberUid.length == 0) {
      return;
    }
    [strongSelf pushSuggestUserInfoWithUid:memberUid];
  };
}

- (void)setupEmptyHint {
  self.emptyHintButton = [UIButton buttonWithType:UIButtonTypeCustom];
  self.emptyHintButton.hidden = YES;
  self.emptyHintButton.titleLabel.numberOfLines = 0;
  self.emptyHintButton.titleLabel.textAlignment = NSTextAlignmentCenter;
  self.emptyHintButton.contentEdgeInsets = UIEdgeInsetsMake(16, 24, 16, 24);
  self.emptyHintButton.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.45];
  self.emptyHintButton.layer.cornerRadius = 12;
  self.emptyHintButton.layer.masksToBounds = YES;
  [self.emptyHintButton setTitle:LanguageToolMatch(@"新用户你好，请前往通讯录添加好友和群聊吧")
                        forState:UIControlStateNormal];
  [self.emptyHintButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
  self.emptyHintButton.titleLabel.font = FONTN(16);
  [self.emptyHintButton addTarget:self
                           action:@selector(emptyHintTapped)
                 forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.emptyHintButton];
  [self.emptyHintButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.equalTo(self.view);
    make.leading.greaterThanOrEqualTo(self.view).offset(32);
    make.trailing.lessThanOrEqualTo(self.view).offset(-32);
  }];
}

#pragma mark - App Lifecycle

- (void)setupAppLifecycleObservers {
  NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
  [center addObserver:self
             selector:@selector(appWillEnterForeground)
                 name:UIApplicationWillEnterForegroundNotification
               object:nil];
  [center addObserver:self
             selector:@selector(appDidBecomeActive)
                 name:UIApplicationDidBecomeActiveNotification
               object:nil];
}

- (void)appWillEnterForeground {
  [self refreshAfterReturningToForeground];
}

- (void)appDidBecomeActive {
  if (!self.view.window) {
    return;
  }
  [self refreshAfterReturningToForeground];
}

- (void)refreshAfterReturningToForeground {
  NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
  if (now - self.lastForegroundRefreshTimestamp < 0.8) {
    return;
  }
  self.lastForegroundRefreshTimestamp = now;

  [self restoreSeaSceneFromLocalCache];
  self.isRequestingGroupInfo = NO;
  [self requestGroupInfo];
}

- (void)refreshSeaSceneIfNeededOnAppear {
  if (!self.emptyHintButton.hidden) {
    [self restoreSeaSceneFromLocalCache];
    self.isRequestingGroupInfo = NO;
    [self requestGroupInfo];
    return;
  }

  if (self.seaSceneView.displayedBoatCount == 0) {
    [self restoreSeaSceneFromLocalCache];
    if (self.seaSceneView.displayedBoatCount == 0) {
      self.isRequestingGroupInfo = NO;
      [self requestGroupInfo];
      return;
    }
  }
  [self.seaSceneView startBoatAnimations];
}

- (void)restoreSeaSceneFromLocalCache {
  NSArray *localMembers = [IMSDKManager imSdkGetAllGroupMemberWith:self.groupID];
  NSArray<LingIMGroupMemberModel *> *validMembers = [self validMembersFromList:localMembers];
  if (validMembers.count == 0) {
    return;
  }
  [self hideEmptyHint];
  [self.seaSceneView reloadWithGroupMembers:validMembers];
  [self.seaSceneView startBoatAnimations];
}

#pragma mark - Fallback Sky Users

- (void)loadFallbackSkyUsers {
  NSMutableArray<NoaUserModel *> *orderedUsers = [NSMutableArray arrayWithCapacity:kLuckyLandFallbackSkyUsernames.count];
  for (NSUInteger idx = 0; idx < kLuckyLandFallbackSkyUsernames.count; idx++) {
    [orderedUsers addObject:[NoaUserModel new]];
  }

  dispatch_group_t group = dispatch_group_create();
  __weak typeof(self) weakSelf = self;

  [kLuckyLandFallbackSkyUsernames enumerateObjectsUsingBlock:^(NSString *username, NSUInteger idx, BOOL *stop) {
    dispatch_group_enter(group);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObjectSafe:username forKey:@"userName"];
    [IMSDKManager userSearchWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
      if ([data isKindOfClass:[NSArray class]]) {
        NSArray *resultList = (NSArray *)data;
        if (resultList.count > 0) {
          NoaUserModel *user = [NoaUserModel mj_objectWithKeyValues:[resultList firstObject]];
          if (user.userUID.length > 0) {
            @synchronized(orderedUsers) {
              orderedUsers[idx] = user;
            }
          }
        }
      }
      dispatch_group_leave(group);
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
      dispatch_group_leave(group);
    }];
  }];

  dispatch_group_notify(group, dispatch_get_main_queue(), ^{
    __strong typeof(weakSelf) strongSelf = weakSelf;
    if (!strongSelf) {
      return;
    }
    [strongSelf.seaSceneView reloadSkyAvatarsWithUsers:[orderedUsers copy]];
  });
}

#pragma mark - Empty State

- (NSArray<LingIMGroupMemberModel *> *)validMembersFromList:(NSArray<LingIMGroupMemberModel *> *)members {
  if (members.count == 0) {
    return @[];
  }
  NSMutableArray<LingIMGroupMemberModel *> *validMembers = [NSMutableArray array];
  for (LingIMGroupMemberModel *member in members) {
    if (member.isDel || member.userUid.length == 0) {
      continue;
    }
    [validMembers addObject:member];
  }
  return [validMembers copy];
}

- (void)showEmptyHint {
  self.emptyHintButton.hidden = NO;
  [self.view bringSubviewToFront:self.emptyHintButton];
  [self.seaSceneView stopBoatAnimations];
}

- (void)hideEmptyHint {
  self.emptyHintButton.hidden = YES;
}

- (void)emptyHintTapped {
  LuckLandContactVC *vc = [LuckLandContactVC new];
  vc.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)reloadSeaSceneWithMembers:(NSArray<LingIMGroupMemberModel *> *)members {
  NSArray<LingIMGroupMemberModel *> *validMembers = [self validMembersFromList:members];
  if (validMembers.count == 0) {
    [self.seaSceneView reloadWithGroupMembers:@[]];
    [self showEmptyHint];
    return;
  }
  [self hideEmptyHint];
  [self.seaSceneView reloadWithGroupMembers:validMembers];
  [self.seaSceneView startBoatAnimations];
}

#pragma mark - Navigation

- (void)pushSuggestUserInfoWithUid:(NSString *)uidStr {
  LuckyLandUserHomePageVC *vc = [LuckyLandUserHomePageVC new];
  vc.isFromQRCode = YES;
  vc.userUID = uidStr;
  vc.groupID = self.groupID ?: @"";
  [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 查询群组详情 数据请求

- (void)requestGroupInfo {
  [self requestGroupInfoWithRemainingRetries:kLuckyLandGroupInfoMaxRetryCount];
}

- (void)requestGroupInfoWithRemainingRetries:(NSInteger)remainingRetries {
  if (self.isRequestingGroupInfo) {
    return;
  }
  self.isRequestingGroupInfo = YES;

  WeakSelf
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  [params setValue:self.groupID forKey:@"groupId"];
  if (![NSString isNil:UserManager.userInfo.userUID]) {
    [params setValue:UserManager.userInfo.userUID forKey:@"userUid"];
  }
  [[NoaIMSDKManager sharedTool] getGroupInfoWith:params onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
    [ZTOOL doInMain:^{
      weakSelf.isRequestingGroupInfo = NO;
      if (![data isKindOfClass:[NSDictionary class]]) {
        [weakSelf handleGroupInfoRequestFailedWithCode:-1
                                                   msg:LanguageToolMatch(@"数据异常")
                                       remainingRetries:remainingRetries];
        return;
      }

      NSDictionary *dict = (NSDictionary *)data;
      weakSelf.groupInfoModel = [LingIMGroup mj_objectWithKeyValues:dict];

      LingIMGroupModel *imGroupModel = [NoaMessageTools netWorkGroupModelToDBGroupModel:weakSelf.groupInfoModel];
      if (imGroupModel) {
        LingIMGroupModel *localGroupModel = [IMSDKManager toolCheckMyGroupWith:weakSelf.groupInfoModel.groupId];
        imGroupModel.lastSyncMemberTime = localGroupModel.lastSyncMemberTime;
        imGroupModel.lastSyncActiviteScoreime = localGroupModel.lastSyncActiviteScoreime;
        [IMSDKManager toolInsertOrUpdateGroupModelWith:imGroupModel];
      }

      [weakSelf reloadSeaSceneWithMembers:weakSelf.groupInfoModel.groupMemberList];
    }];
  } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
    [ZTOOL doInMain:^{
      weakSelf.isRequestingGroupInfo = NO;
      [weakSelf handleGroupInfoRequestFailedWithCode:code
                                                 msg:msg
                                     remainingRetries:remainingRetries];
    }];
  }];
}

- (void)handleGroupInfoRequestFailedWithCode:(NSInteger)code
                                         msg:(NSString *)msg
                             remainingRetries:(NSInteger)remainingRetries {
  if (remainingRetries > 0) {
    [self requestGroupInfoWithRemainingRetries:remainingRetries - 1];
    return;
  }

  LingIMGroupModel *groupModel = [IMSDKManager toolCheckMyGroupWith:self.groupID];
  self.groupInfoModel = [[LingIMGroup alloc] init];
  if (groupModel) {
    self.groupInfoModel.groupAvatar = groupModel.groupAvatar;
    self.groupInfoModel.groupName = groupModel.groupName;
    self.groupInfoModel.msgTop = groupModel.msgTop;
    self.groupInfoModel.msgNoPromt = groupModel.msgNoPromt;
    self.groupInfoModel.groupId = groupModel.groupId;
  } else {
    self.groupInfoModel.groupId = self.groupID;
  }

  NSArray *localMembers = [IMSDKManager imSdkGetAllGroupMemberWith:self.groupID];
  NSArray<LingIMGroupMemberModel *> *validMembers = [self validMembersFromList:localMembers];
  if (validMembers.count == 0) {
    [self reloadSeaSceneWithMembers:@[]];
    return;
  }

  [self reloadSeaSceneWithMembers:localMembers];
  if (msg.length > 0) {
    [HUD showMessageWithCode:code errorMsg:msg];
  }
}

@end
