//
//  KungfuClassDetailViewController.m
//  Shaolin
//
//  Created by ws on 2020/5/13.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuClassDetailViewController.h"
#import "AppDelegate+AppService.h"

#import "KungfuClassMoreCell.h"
#import "KungfuClassInfoCell.h"
#import "KfClassContainerCell.h"
#import "KungfuClassHeaderView.h"
#import "KungfuClassVideoChooseView.h"

#import "KungfuAllScoreViewController.h"
#import "OrderFillCourseViewController.h"
#import "ShoppingCartViewController.h"

#import "AppDelegate.h"

#import "KungfuManager.h"
#import "ClassDetailModel.h"
#import "ClassGoodsModel.h"
#import "ClassListModel.h"
#import "ClassVideoModel.h"

#import "DataManager.h"
#import "ShoppingCartGoodsModel.h"

#import "NSDate+LGFDate.h"

#import "SMAlert.h"

#import "KungfuClassInfoView.h"
#import "SLPlayerView.h"
#import "AVCSelectSharpnessView.h"
#import <sys/utsname.h>
#import "SLRouteManager.h"
#import "ThumbFollowShareManager.h"

static NSString *const classCellId = @"KungfuClassInfoCell";
static NSString *const classConCellId = @"KfClassContainerCell";
static NSString *const moreCellId = @"KungfuClassMoreCell";

#define NAVBAR_COLORCHANGE_POINT 70
#define VIEWSAFEAREAINSETS(view) ({UIEdgeInsets i; if(@available(iOS 11.0, *)) {i = view.safeAreaInsets;} else {i = UIEdgeInsetsZero;} i;})

@interface KungfuClassDetailViewController () <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,AliyunVodPlayerViewDelegate>

@property (nonatomic, strong) UITableView   * classTable;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) KungfuClassHeaderView  * headerView;

@property (nonatomic, strong) ClassGoodsModel *currentClassData;
@property (nonatomic, strong) KungfuClassVideoChooseView *videoEndView;

//控制锁屏
@property (nonatomic, assign) BOOL isLock;
//播放器
@property (nonatomic, strong, nullable) SLPlayerView *playerView;
@property (nonatomic, assign) BOOL isStatusHidden;

@property (nonatomic, strong) KungfuClassInfoView * infoView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UIView * loadBgView; // 加载时遮盖的view
@property (nonatomic, strong) UIView * tableFooterView;
@property (nonatomic, strong) UIButton * tableFooterViewBuyBtn;

@property (nonatomic, strong) ClassDetailModel *model;
@property (nonatomic, strong) NSArray <ClassListModel *> *recommendedClassList;

@property (nonatomic, assign) NSInteger currentClassIndex;

///tableview底部View，用来增加滑动范围
@property(nonatomic, strong) UIView * occupationView;
@end

@implementation KungfuClassDetailViewController

#pragma mark - life cycle
- (void)dealloc {
    AppDelegate * slAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    slAppDelegate.allowOrentitaionRotation = YES;
    
    // 添加教程观看记录
    if (self.currentClassData) {
        [self setCourseReadHistory:self.currentClassData time:self.playerView.saveCurrentTime];
    }
    [self destroyPlayVideo];
    
    NSLog(@"教程详情界面释放了");
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.playerView pause];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ) {
        self.playerView.frame = self.headerView.classImgv.bounds;
        self.videoEndView.frame = self.headerView.classImgv.bounds;
        [self refreshUIWhenScreenChanged:false];
    }else{
        self.playerView.frame = CGRectMake(0,0, ScreenWidth, ScreenHeight);
        self.videoEndView.frame = CGRectMake(0,0, ScreenWidth, ScreenHeight);
        [self refreshUIWhenScreenChanged:true];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self initParamers];
    [self requestDetailData];
}

- (void) initUI {
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self.view addSubview:self.classTable];
    [self.view addSubview:self.tableFooterView];
    [self.view addSubview:self.loadBgView];
    
    [self.view addSubview:self.playerView];
    
    [self.rightBtn setImage:[UIImage imageNamed:@"focus_normal"] forState:(UIControlStateNormal)];
    [self.rightBtn setImage:[UIImage imageNamed:@"focus_select_yellow"] forState:(UIControlStateSelected)];
    [self.rightBtn addTarget:self action:@selector(foucsAction:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)initParamers {
    self.currentClassIndex = 999;
    
    AppDelegate * slAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    slAppDelegate.allowOrentitaionRotation = YES;

}

- (void)destroyPlayVideo{
    if (_playerView != nil) {
        [_playerView stop];
        [_playerView releasePlayer];
        _playerView.delegate = nil;
        [_playerView removeFromSuperview];
        _playerView = nil;
    }
}

- (void)refreshUIWhenScreenChanged:(BOOL)isFullScreen{
    [self.navigationController setNavigationBarHidden:isFullScreen animated:NO];
    if (isFullScreen) {
        self.videoEndView.backBtn.hidden = NO;
    } else {
        self.videoEndView.backBtn.hidden = YES;
    }
}

#pragma mark - notification
- (void) subClassSelect:(NSNotification *)noti {
    
    NSDictionary *dict = noti.object;
    NSInteger index = [dict[@"index"] integerValue];
    
    [self readyWithData:self.model.goodsNext[index] selectIndex:index];
}

#pragma mark - event
- (void)setCourseReadHistory:(ClassGoodsModel *)data time:(float)time {
    // 添加播放历史
    if (!self.classId) {
        return;
    }

    NSString *goodsId = self.classId;
    NSString *attrId = data.classGoodsId;
    
    if (time == 0.0) {
        time = 1.0;
    }
    NSString *timeStr = [NSString stringWithFormat:@"%d",(int)(time*1000)];
    
    NSDictionary *params = @{
        @"goodsId":goodsId,
        @"attrId":attrId,
        @"lookTime":timeStr
    };
    
    self.model.history.attrId = data.classGoodsId;
    self.model.history.lookTime = timeStr;
    
    [[KungfuManager sharedInstance] setCourseReadHistory:params callback:^(NSDictionary *result) {
        NSLog(@"%@", result);
    }];
}

- (void)readyWithData:(ClassGoodsModel *)goodsModel selectIndex:(NSInteger)selectIndex
{
    if (![self.model.buy boolValue]){
        /** 未购买的视频，判断课节里的try_watch，0  不能试看  1 可以试看*/
        if ([goodsModel.tryLook intValue] == 0) {
            // 不能试看，return
            NSString * buttonTitle = self.tableFooterViewBuyBtn.titleLabel.text;
            
            if ([buttonTitle containsString:SLLocalizedString(@"最低位阶")]) {
                [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"您当前位阶与该教程不符") view:self.view afterDelay:TipSeconds];
                return;
            }
            
            [self showBuyAlertWithInfo];
            return;
        } else {
            // 可以试看，不return，把endView的类型设为试看类型
            self.videoEndView.endViewType = VideoPlayEndTry;
        }
    }
    
    // 滚动到顶
    [self.classTable setContentOffset:CGPointMake(0,0) animated:NO];
    
    [self requestVideoAuthWithClassModel:goodsModel Block:^(ClassVideoModel *videoModel) {
        [self playWithVideoModel:videoModel classGoodsModel:goodsModel selectIndex:selectIndex];
    }];
}

/// 播放视频
- (void) playWithVideoModel:(ClassVideoModel *)videoModel
            classGoodsModel:(ClassGoodsModel *)goodsModel
                selectIndex:(NSInteger)selectIndex
{
    if (self.currentClassData
        && self.currentClassData != goodsModel)
    {
        // 添加上一节课的播放记录
        [self setCourseReadHistory:self.currentClassData time:self.playerView.saveCurrentTime];
    }
    
    if (self.currentClassData == goodsModel) {
        if (self.playerView.currentPlayStatus == AVPStatusPrepared
            || self.playerView.currentPlayStatus == AVPStatusStarted) {
            return;
        }
        [self.playerView resume];
    }
    
    
    self.currentClassData = goodsModel;
    self.currentClassIndex = selectIndex;
        
    if ([self.model.buy boolValue]) {
        if (self.currentClassIndex == self.model.goodsNext.count - 1) {
            // 最后一节，把endView的状态设为最后一节
            self.videoEndView.endViewType = VideoPlayEndLast;
        } else {
            self.videoEndView.endViewType = VideoPlayEndCenter;
        }
    }
    
    [self.videoEndView setNeedsLayout];
    
    NSString * indexName = NotNilAndNull(self.currentClassData.classGoodsName)?self.currentClassData.classGoodsName:@"";
    NSString * className = NotNilAndNull(self.currentClassData.value)?self.currentClassData.value:@"";
    NSString * playerTitle = [NSString stringWithFormat:@"%@ %@",indexName,className];
    
    [self.playerView setTitle:playerTitle];
    [self.playerView stop];
    self.playerView.hidden = NO;
    self.videoEndView.hidden = YES;
    [self.playerView playViewPrepareWithVid:videoModel.videoMeta.videoId playAuth:videoModel.playAuth];
    
    
    // 隐藏教程图
    [self.headerView hideSdcScrollView];
    self.headerView.playBtn.hidden = YES;
}


- (void)foucsAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        //收藏
        [self collectClass:btn];
    }else
    {  //取消收藏
        [self collectCancle:btn];
    }
}


- (void) showBuyAlertWithInfo
{
    [SMAlert setConfirmBtBackgroundColor:kMainYellow];
    [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
    [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
    [SMAlert setCancleBtTitleColor:KTextGray_333];
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
    UILabel *title = [[UILabel alloc]initWithFrame:customView.bounds];
    [title setFont:[UIFont systemFontOfSize:15]];
    [title setTextColor:[UIColor darkGrayColor]];
    title.text = SLLocalizedString(@"是否加入我的教程？");
    [title setTextAlignment:NSTextAlignmentCenter];
    [customView addSubview:title];
    
    [SMAlert showCustomView:customView stroke:YES confirmButton:[SMButton initWithTitle:SLLocalizedString(@"确定") clickAction:^{
        [self classPay];
    }] cancleButton:[SMButton initWithTitle:SLLocalizedString(@"取消") clickAction:nil]];
}

#pragma mark - request
- (void) requestDetailData {
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:@""];
    
    [[KungfuManager sharedInstance] getClassDetailWithDic:@{@"id":self.classId} success:^(NSDictionary * _Nullable resultDic) {
        resultDic = [ThumbFollowShareManager reloadDictByLocalCache:resultDic modelItemType:ClassItemType modelItemKind:ImageText];
        ClassDetailModel *model = [ClassDetailModel mj_objectWithKeyValues:resultDic];
        if ([model.oldPrice floatValue] == 0.00 && ![model isVIPClass]) {
            // 如果是0元非会员课程，算作是已经购买了 此需求 2020-11-27 增加
            model.buy = @"1";
        }
        self.model = model;
        
        if (NotNilAndNull(self.model.history)) {
            [self.model.goodsNext enumerateObjectsUsingBlock:^(ClassGoodsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.classGoodsId isEqualToString:self.model.history.attrId]) {
                    self.currentClassIndex = idx;
                    *stop = YES;
                }
            }];
        } else {
            self.currentClassIndex = 999;
        }
        [self.classTable reloadData];
        // 更多推荐课程
        [self requestMoreClassList];
        
    } failure:^(NSString * _Nullable errorReason) {
        
        [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
        [self.navigationController popViewControllerAnimated:YES];
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        [hud hideAnimated:YES];
    }];
}

- (void) requestMoreClassList {
    
    [[KungfuManager sharedInstance] getClassRecommendWithDic:@{@"id":self.model.classDetailId,@"subjectId":self.model.subjectId,@"level":self.model.level,@"page":@"1"} success:^(NSDictionary * _Nullable resultDic) {
        
        NSArray *arr = resultDic[DATAS];
        NSArray *dataList = [ClassListModel mj_objectArrayWithKeyValuesArray:arr];
        self.recommendedClassList = dataList;
        
        [self.classTable reloadData];
    } failure:^(NSString * _Nullable errorReason) {
        [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {}];
}

- (void) requestVideoAuthWithClassModel:(ClassGoodsModel *)goodsModel Block:(void(^)(ClassVideoModel * videoModel))videoBlock {
    
    if (IsNilOrNull(goodsModel.attrId)) {
        [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"视频获取失败，请稍后重试")];
        return;
    }
    
    // 从阿里获取播放凭证
    [[KungfuManager sharedInstance] getVideoAuthWithVideoId:goodsModel.attrId callback:^(NSDictionary *result) {
        
        if (!result) {
            [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"视频获取失败，请稍后重试")];
            return;
        }
        ClassVideoModel *model = [ClassVideoModel mj_objectWithKeyValues:result];
        if (model){
            if (videoBlock) {
                videoBlock(model);
            }
        } else {
            [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"视频获取失败，请稍后重试")];
        }
    }];
}

// 收藏教程
- (void)collectClass:(UIButton *)btn
{
    WEAKSELF
    NSDictionary * dic = @{@"goodsId":self.model.classDetailId,@"type":@"2"};
//    [[KungfuManager sharedInstance] getClassCollectWithDic:dic callback:^(Message *message) {
//
//        if (message.isSuccess) {
//            [btn setSelected:YES];
//            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"收藏成功") view:weakSelf.view afterDelay:TipSeconds];
//        } else {
//            [ShaolinProgressHUD singleTextHud:message.reason view:weakSelf.view afterDelay:TipSeconds];
//        }
//    }];
    
    
    // 收藏教程
        [[DataManager shareInstance]addCollect:dic Callback:^(Message *message) {
            
            if (message.isSuccess) {
                [btn setSelected:YES];
                [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"收藏成功") view:weakSelf.view afterDelay:TipSeconds];
            } else {
                [ShaolinProgressHUD singleTextHud:message.reason view:weakSelf.view afterDelay:TipSeconds];
            }
        }];
    
    
    
    
    
    
    
}

// 取消收藏
- (void)collectCancle:(UIButton *)btn
{
    WEAKSELF
    NSDictionary * dic = @{@"goodsId":self.model.classDetailId,@"type":@"2"};
//    [[KungfuManager sharedInstance] getClassCollectWithDic:dic callback:^(Message *message) {
//
//        if (message.isSuccess) {
//            [btn setSelected:NO];
//            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"取消收藏") view:weakSelf.view afterDelay:TipSeconds];
//        } else {
//            [ShaolinProgressHUD singleTextHud:message.reason view:weakSelf.view afterDelay:TipSeconds];
//        }
//    }];
    
    // 取消收藏
        [[DataManager shareInstance]cancelCollect:dic Callback:^(Message *message) {
            if (message.isSuccess) {
                [btn setSelected:NO];
                [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"取消收藏") view:weakSelf.view afterDelay:TipSeconds];
            } else {
                [ShaolinProgressHUD singleTextHud:message.reason view:weakSelf.view afterDelay:TipSeconds];
            }
        }];
  
    
    
}

- (void) playClass {
    
    NSString * buttonTitle = self.tableFooterViewBuyBtn.titleLabel.text;
    
    if ([buttonTitle containsString:SLLocalizedString(@"最低位阶")]) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"您当前位阶与该教程不符") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    if ([buttonTitle isEqualToString:SLLocalizedString(@"观看教程")]) {
        if (IsNilOrNull(self.model.goodsNext) || !self.model.goodsNext.count) {
            return;
        }
        
        if (self.currentClassData) {
            return;
        }
        
        
        [self.classTable setContentOffset:CGPointMake(0,0) animated:NO];
        
        if (self.currentClassIndex == 999) {
            self.currentClassIndex = 0;
        }
        
        [self readyWithData:self.model.goodsNext[self.currentClassIndex] selectIndex:self.currentClassIndex];
    }
    
    if ([buttonTitle isEqualToString:SLLocalizedString(@"免费观看")]) {
        [self classPay];
    }
    
    if ([buttonTitle isEqualToString:SLLocalizedString(@"学习教程")]) {
        [self classPay];
    }
}

///支付流程
- (void)classPay {
    
    [SLRouteManager pushRealNameAuthenticationState:self.navigationController showAlert:YES isReloadData:YES finish:^(SLRouteRealNameAuthenticationState state) {
        if (state == RealNameAuthenticationStateSuccess) {
            NSMutableArray *modelMutabelArray = [NSMutableArray array];
            NSMutableDictionary *tam = [NSMutableDictionary dictionary];
            
            ShoppingCartGoodsModel *cartGoodModel = [[ShoppingCartGoodsModel alloc] init];
            
            cartGoodModel.goodsName = self.model.classDetailName;
            cartGoodModel.desc = self.model.desc;
            cartGoodModel.imgDataList = @[self.model.cover];
            cartGoodModel.price = self.model.oldPrice;
            cartGoodModel.oldPrice = self.model.oldPrice;
            cartGoodModel.stock = @"1";
            cartGoodModel.storeType = @"1";
            cartGoodModel.num = @"1";
            cartGoodModel.desc = self.model.desc;
            cartGoodModel.goodsId = self.model.classDetailId;
            cartGoodModel.appStoreId = self.model.appStoreId;
            
            [tam setValue:@[cartGoodModel] forKey:@"goods"];
            
            [modelMutabelArray addObject:tam];
            
            OrderFillCourseViewController *orderFillVC = [[OrderFillCourseViewController alloc] init];
            orderFillVC.dataArray = modelMutabelArray;
            [self.navigationController pushViewController:orderFillVC animated:YES];
        }
    }];
}

- (void)reloadTableFooterView{
    SLAppInfoModel *userModel = [SLAppInfoModel sharedInstance];
    
    [self.tableFooterViewBuyBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
    }];
    if ([self.model.buy boolValue]) {
        [self.tableFooterViewBuyBtn setTitle:SLLocalizedString(@"观看教程") forState:UIControlStateNormal];
    } else {
        if ([self.model isFreeClass]) {
            // 免费教程
            [self.tableFooterViewBuyBtn setTitle:SLLocalizedString(@"免费观看") forState:UIControlStateNormal];
        }
        
        if ([self.model isVIPClass]) {
            // 会员教程  判断等级
            if ([userModel.levelId intValue] < [self.model.lookLevel intValue]) {
                NSString *title = [NSString stringWithFormat:SLLocalizedString(@"最低位阶%@可观看教程"), self.model.lookLevelName];
                [self.tableFooterViewBuyBtn setTitle:title forState:UIControlStateNormal];
            } else {
                [self.tableFooterViewBuyBtn setTitle:SLLocalizedString(@"学习教程") forState:UIControlStateNormal];
            }
        }
        
        if ([self.model isPayClass]) {
            // 付费教程
            
            //            [self.tableFooterViewBuyBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            //                make.left.mas_equalTo((kWidth - 32 - 13)/2 + 13);
            //            }];
            [self.tableFooterViewBuyBtn setTitle:SLLocalizedString(@"学习教程") forState:UIControlStateNormal];
        }
    }
}

#pragma mark - AliPlayerDelegate
- (void)onBackViewClickWithAliyunVodPlayerView:(AliyunVodPlayerView *)playerView{
    //    [self returnAction];
}

- (void)aliyunVodPlayerView:(AliyunVodPlayerView *)playerView happen:(AVPEventType)event{
    
    if (event == AVPEventPrepareDone) {
        if ([self.currentClassData.classGoodsId isEqualToString:self.model.history.attrId]) {

            // 如果剩余未观看时间小于1秒则重头播放
            int time = playerView.aliPlayer.getMediaInfo.duration;
            int look_time = [self.model.history.lookTime intValue];
            if (time - look_time <= 1000) {
                look_time = 0;
            }
            
            [self.playerView seekToTime:look_time];
        }
    }
}

- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView onPause:(NSTimeInterval)currentPlayTime{
    NSLog(@"onPause");
}

- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView onResume:(NSTimeInterval)currentPlayTime{
    NSLog(@"onResume");
}

- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView onStop:(NSTimeInterval)currentPlayTime{
    NSLog(@"onStop");
}

- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView onSeekDone:(NSTimeInterval)seekDoneTime{
    NSLog(@"onSeekDone");
}

- (void)onFinishWithAliyunVodPlayerView:(AliyunVodPlayerView *)playerView{
    NSLog(@"onFinish");
    self.videoEndView.hidden = NO;
    
    //    if (!self.playerView.controlView.isHiddenView) {
    [self.playerView.controlView hiddenView];
    //    }
    //    if (self.config.isLocal && self.doneVideoArray.count > 0) {
    //        [self.playerView setUIStatusToReplay];
    //        return;
    //    }
    //vid列表播放
    //    [self.listView playNextMediaVideo];
}

- (void)aliyunVodPlayerView:(AliyunVodPlayerView *)playerView lockScreen:(BOOL)isLockScreen{
    self.isLock = isLockScreen;
}

- (void)aliyunVodPlayerView:(AliyunVodPlayerView *)playerView fullScreen:(BOOL)isFullScreen{
    
    self.isStatusHidden = isFullScreen  ;
    [self refreshUIWhenScreenChanged:isFullScreen];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)aliyunVodPlayerView:(AliyunVodPlayerView *)playerView onVideoDefinitionChanged:(NSString *)videoDefinition {
}

- (void)onCircleStartWithVodPlayerView:(AliyunVodPlayerView *)playerView {
    
    // 移动播放位置
    
}

- (void)onClickedAirPlayButtonWithVodPlayerView:(AliyunVodPlayerView *)playerView {
}

- (void)onClickedBarrageBtnWithVodPlayerView:(AliyunVodPlayerView *)playerView {
}

- (void)onDownloadButtonClickWithAliyunVodPlayerView:(AliyunVodPlayerView *)playerView {
}

- (void)onSecurityTokenExpiredWithAliyunVodPlayerView:(AliyunVodPlayerView *)playerView {
}

- (void)selectSharpnessView:(AVCSelectSharpnessView *)view cancelButtonTouched:(UIButton *)button{
    //    [view dismiss];
}

- (void)selectSharpnessView:(AVCSelectSharpnessView *)view lookVideoButtonTouched:(UIButton *)button{
    //横屏状态下才有这个按钮 1.隐藏选择视图， 2.展示视频列表视图
    if (ScreenWidth > ScreenHeight) {
    }
}


#pragma mark - delegate && dataSources
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF
    if (indexPath.section == 0) {
        KungfuClassInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:classCellId forIndexPath:indexPath];
        cell.model = self.model;
        cell.moreHandle = ^{
            
            weakSelf.infoView = [[KungfuClassInfoView alloc]initWithFrame:weakSelf.view.bounds];
            [weakSelf.infoView setAlpha:0];
            
            weakSelf.infoView.classNameStr = weakSelf.model.classDetailName;
            weakSelf.infoView.classContentStr = NotNilAndNull(weakSelf.model.intro)?weakSelf.model.intro:@"";
            
            UIWindow *window = [ShaolinProgressHUD frontWindow];
            [window addSubview:weakSelf.infoView];
            
            [UIView animateWithDuration:0.3 animations:^{
                [weakSelf.infoView setAlpha:1];
            } completion:^(BOOL finished) {}];
            
            [weakSelf.infoView setShutDownBlock:^{
                [UIView animateWithDuration:0.3 animations:^{
                    [weakSelf.infoView setAlpha:0];
                } completion:^(BOOL finished) {
                    // 把popView从Window中移除
                    [weakSelf.infoView removeFromSuperview];
                }];
            }];
        };
        return cell;
    }
    
    if (indexPath.section == 1) {
        
        KfClassContainerCell * cell = [tableView dequeueReusableCellWithIdentifier:classConCellId forIndexPath:indexPath];
        cell.model = self.model;
        cell.currentClassIndex = self.currentClassIndex;
        
        cell.cellSelectBlock = ^(NSInteger indexRow) {
            [weakSelf readyWithData:weakSelf.model.goodsNext[indexRow] selectIndex:indexRow];
        };
        return cell;
    }
    
    KungfuClassMoreCell  * cell = [tableView dequeueReusableCellWithIdentifier:moreCellId forIndexPath:indexPath];
    cell.classListArray = self.recommendedClassList;
    cell.cellSelectBlock = ^(ClassListModel * _Nonnull model) {
        KungfuClassDetailViewController * vc = [KungfuClassDetailViewController new];
        vc.classId = model.classId;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 114 + 36;
    }
    
    if (indexPath.section == 1) {
        if (self.model){
            if (self.model.goodsNext.count > 3){
                return 3.5 * 64;
            }
            return self.model.goodsNext.count*64 ;
        }
        return 0;
    }
    
    if (indexPath.section == 2) {
        if (self.recommendedClassList.count){
            return 170;
        }
        return 0;
    }
    return .001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1)
        return 10;
    return .001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return .001;
    }
    
    if (section == 2) {
        return 40;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{

    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 10)];
    v.backgroundColor = KTextGray_FA;
    return v;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 10)];
    v.backgroundColor = KTextGray_FA;
    
    if (section == 2) {
        if (self.recommendedClassList.count){
            v.frame = CGRectMake(0, 0, kWidth, 40);
            
            UILabel * sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 5, kWidth - 32, 30)];
            sectionLabel.text = SLLocalizedString(@"相关推荐");
            sectionLabel.textColor = KTextGray_666;
            sectionLabel.font = [UIFont boldSystemFontOfSize:16];
            v.backgroundColor = UIColor.whiteColor;
            [v addSubview:sectionLabel];
        } else {
            v.frame = CGRectZero;
        }
    }
    
    return v;
}

//#pragma mark - scrollerViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat offsetY = scrollView.contentOffset.y;
//    if (offsetY > NAVBAR_COLORCHANGE_POINT)
//    {
//        CGFloat alpha = (offsetY - NAVBAR_COLORCHANGE_POINT) / NavBar_Height;
//        self.navigationView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:alpha];
//    }
//    else
//    {
//        self.navigationView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
//    }
//
//    if (offsetY > 190)
//    {
//        //        [self.player.currentPlayerManager pause];
//    }
//
//    self.playerView.top = - offsetY ;
//}

#pragma mark - setter

- (void)setCurrentClassIndex:(NSInteger)currentClassIndex {
    _currentClassIndex = currentClassIndex;
    
    if (currentClassIndex != 999) {
        
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
        [self.classTable reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)setModel:(ClassDetailModel *)model{
    _model = model;
    
    if (IsNilOrNull(model)) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"教程获取失败，请稍后重试") view:self.view afterDelay:TipSeconds];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    NSString *collect = model.collect;

    self.rightBtn.selected = [collect intValue];
    self.headerView.model = model;
    
    [self reloadTableFooterView];
    self.loadBgView.hidden = YES;
    
    [self.classTable layoutIfNeeded];
    [self.classTable reloadData];
}

#pragma mark - getter

- (UITableView *)classTable {
    if (!_classTable) {
        _classTable = [[UITableView alloc]initWithFrame:CGRectMake(0, -0, kWidth, kHeight+0 - kNavBarHeight - kBottomSafeHeight - kStatusBarHeight) style:(UITableViewStyleGrouped)];
        _classTable.delegate = self;
        _classTable.dataSource = self;
        _classTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _classTable.showsVerticalScrollIndicator = NO;
        _classTable.showsHorizontalScrollIndicator = NO;
        _classTable.backgroundColor = UIColor.clearColor;
        _classTable.scrollsToTop = YES;
        
        [_classTable registerNib:[UINib nibWithNibName:NSStringFromClass([KungfuClassInfoCell class]) bundle:nil] forCellReuseIdentifier:classCellId];
        [_classTable registerClass:[KungfuClassMoreCell class] forCellReuseIdentifier:moreCellId];
        
        [_classTable registerClass:[KfClassContainerCell class]
            forCellReuseIdentifier:classConCellId];
        
        _classTable.tableHeaderView = self.headerView;
        _classTable.tableFooterView = self.occupationView;
        
    }
    return _classTable;
}

- (SLPlayerView *__nullable)playerView{
    //    WEAKSELF
    if (!_playerView) {
        _playerView = [[SLPlayerView alloc] initWithFrame:CGRectZero andSkin:AliyunVodPlayerViewSkinBlue];
        _playerView.hidden = YES;
        _playerView.backgroundColor = UIColor.blackColor;
        [_playerView setDelegate:self];
        [_playerView setPrintLog:YES];
        
        _playerView.isScreenLocked = false;
        _playerView.fixedPortrait = false;
        
        self.isLock = _playerView.isScreenLocked||_playerView.fixedPortrait?YES:NO;
        [_playerView addSubview:self.videoEndView];
        
    }
    return _playerView;
}

- (KungfuClassHeaderView *)headerView {
    //    WEAKSELF
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:(NSStringFromClass([KungfuClassHeaderView class])) owner:self options:nil] objectAtIndex:0];
        _headerView.playCallback = ^{
            //            [weakSelf playTheIndex:0];
        };
    }
    return _headerView;
}


- (UIView *)loadBgView {
    if (!_loadBgView) {
        _loadBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        _loadBgView.backgroundColor = UIColor.whiteColor;
    }
    return _loadBgView;
}

- (UIView *)tableFooterView {
    if (!_tableFooterView) {
        _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight - 72 - kNavBarHeight - kBottomSafeHeight - kStatusBarHeight, kScreenWidth, 72)];
        _tableFooterView.backgroundColor = UIColor.clearColor;
        [_tableFooterView addSubview:self.tableFooterViewBuyBtn];
      
        [self.tableFooterViewBuyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(18);
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(40);
        }];
    }
    return _tableFooterView;
}

- (UIButton *)tableFooterViewBuyBtn{
    if (!_tableFooterViewBuyBtn){
        _tableFooterViewBuyBtn = [[UIButton alloc] init];
        _tableFooterViewBuyBtn.backgroundColor = kMainYellow;
        _tableFooterViewBuyBtn.layer.cornerRadius = 20;
        _tableFooterViewBuyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_tableFooterViewBuyBtn setTitle:SLLocalizedString(@"观看教程") forState:UIControlStateNormal];
        [_tableFooterViewBuyBtn addTarget:self action:@selector(playClass) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tableFooterViewBuyBtn;
}


- (UIView *)occupationView {
    if (!_occupationView) {
        _occupationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 75)];
        _occupationView.backgroundColor = UIColor.whiteColor;
    }
    return _occupationView;
}

- (KungfuClassVideoChooseView *)videoEndView {
    WEAKSELF
    if (!_videoEndView) {
        _videoEndView = [KungfuClassVideoChooseView loadXib];
        _videoEndView.hidden = YES;
        _videoEndView.buyHandleBlock = ^{
            UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
            if (orientation != UIInterfaceOrientationPortrait ) {
                [weakSelf.playerView.controlView onClickedfullScreenButtonWithAliyunPVBottomView:nil];
            }
            
            [weakSelf classPay];
        };
        
        _videoEndView.replyHandleBlock = ^{
            
            weakSelf.videoEndView.hidden = YES;
            [weakSelf.playerView replayClass];
        };
        
        _videoEndView.backHandleBlock = ^{
            UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
            if (orientation != UIInterfaceOrientationPortrait ) {
                [weakSelf.playerView.controlView onClickedfullScreenButtonWithAliyunPVBottomView:nil];
            }
            weakSelf.videoEndView.backBtn.hidden = YES;
        };
        
        _videoEndView.nextHandleBlock = ^{
            weakSelf.videoEndView.hidden = YES;
            [weakSelf.playerView stop];
            
            ClassGoodsModel * nextM = weakSelf.model.goodsNext[weakSelf.currentClassIndex + 1];
            // 播放下一节
            [weakSelf readyWithData:nextM selectIndex:weakSelf.currentClassIndex + 1];
        };
    }
    return _videoEndView;
}

#pragma mark - device

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscapeRight;
}

- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscapeRight;
}

- (BOOL)prefersStatusBarHidden {
    return self.isStatusHidden;
}

@end
