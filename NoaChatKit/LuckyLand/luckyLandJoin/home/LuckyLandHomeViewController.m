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
#import "NoaUserHomePageVC.h"

@interface LuckyLandHomeViewController ()

@property (nonatomic, strong) LuckyLandSeaSceneView *seaSceneView;
@property (nonatomic, strong) LingIMGroup *groupInfoModel;
@property (nonatomic, copy) NSString *groupID;

@end

@implementation LuckyLandHomeViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.groupID = @"1001";
  [self setupSeaScene];
  [self requestGroupInfo];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:animated];
  [self.seaSceneView startBoatAnimations];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [self.seaSceneView stopBoatAnimations];
}

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
}

- (void)reloadSeaSceneWithMembers:(NSArray<LingIMGroupMemberModel *> *)members {
  [self.seaSceneView reloadWithGroupMembers:members ?: @[]];
  [self.seaSceneView startBoatAnimations];
}

// 跳转到推荐用户详情
- (void)pushSuggestUserInfoWithUid:(NSString *)uidStr {
  NoaUserHomePageVC *vc = [NoaUserHomePageVC new];
  vc.isFromQRCode = YES;
  vc.userUID = uidStr;
  vc.groupID = self.groupID ?: @"";
  [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 查询群组详情 数据请求
- (void)requestGroupInfo {
  WeakSelf
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  [params setValue:self.groupID forKey:@"groupId"];
  if (![NSString isNil:UserManager.userInfo.userUID]) {
    [params setValue:UserManager.userInfo.userUID forKey:@"userUid"];
  }
  [[NoaIMSDKManager sharedTool] getGroupInfoWith:params onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
    [ZTOOL doInMain:^{
      if ([data isKindOfClass:[NSDictionary class]]) {
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
      }
    }];
  } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
    [ZTOOL doInMain:^{
      LingIMGroupModel *groupModel = [IMSDKManager toolCheckMyGroupWith:weakSelf.groupID];
      weakSelf.groupInfoModel = [[LingIMGroup alloc] init];
      weakSelf.groupInfoModel.groupAvatar = groupModel.groupAvatar;
      weakSelf.groupInfoModel.groupName = groupModel.groupName;
      weakSelf.groupInfoModel.msgTop = groupModel.msgTop;
      weakSelf.groupInfoModel.msgNoPromt = groupModel.msgNoPromt;
      weakSelf.groupInfoModel.groupId = groupModel.groupId;

      NSArray *localMembers = [IMSDKManager imSdkGetAllGroupMemberWith:weakSelf.groupID];
      [weakSelf reloadSeaSceneWithMembers:localMembers];
      [HUD showMessageWithCode:code errorMsg:msg];
    }];
  }];
}

@end
