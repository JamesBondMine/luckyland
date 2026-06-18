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

@interface LuckyLandHomeViewController ()

@property (nonatomic, strong) LuckyLandSeaSceneView *seaSceneView;

@property (nonatomic, strong) LingIMGroup *groupInfoModel;
@property (nonatomic, strong) NSMutableArray * groupMemberIdArr;
@property (nonatomic, strong) NSString * groupID;

@end

@implementation LuckyLandHomeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
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
  self.seaSceneView.boatTapAction = ^(LuckyLandBoatView *boatView, NSInteger boatIndex) {
    __strong typeof(weakSelf) strongSelf = weakSelf;
    if (!strongSelf) {
      return;
    }
    // TODO: 处理小船点击，例如进入对应房间/组织
    DLog(@"点击小船 index: %ld", (long)boatIndex);
  };
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
            }
        }];
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [ZTOOL doInMain:^{
            //如果请求失败，则从数据库中去群组信息赋值刷新
            LingIMGroupModel * groupModel = [IMSDKManager toolCheckMyGroupWith:self.groupID];
            weakSelf.groupInfoModel = [[LingIMGroup alloc] init];
            weakSelf.groupInfoModel.groupAvatar = groupModel.groupAvatar;
            weakSelf.groupInfoModel.groupName = groupModel.groupName;
            weakSelf.groupInfoModel.msgTop = groupModel.msgTop;
            weakSelf.groupInfoModel.msgNoPromt = groupModel.msgNoPromt;
            weakSelf.groupInfoModel.groupId = groupModel.groupId;
            [HUD showMessageWithCode:code errorMsg:msg];
        }];
        
    }];
}

@end
