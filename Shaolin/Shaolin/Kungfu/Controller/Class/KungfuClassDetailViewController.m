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

#import "KfClassInfoViewController.h"
#import "KungfuAllScoreViewController.h"
#import "OrderFillCourseViewController.h"
#import "RealNameViewController.h"
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

static NSString *const classCellId = @"KungfuClassInfoCell";
static NSString *const classConCellId = @"KfClassContainerCell";
static NSString *const moreCellId = @"KungfuClassMoreCell";

#define NAVBAR_COLORCHANGE_POINT 70
#define VIEWSAFEAREAINSETS(view) ({UIEdgeInsets i; if(@available(iOS 11.0, *)) {i = view.safeAreaInsets;} else {i = UIEdgeInsetsZero;} i;})

@interface KungfuClassDetailViewController () <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,AliyunVodPlayerViewDelegate>

// 假的导航栏和导航栏按钮 弃用
@property (nonatomic, strong) UIView * navigationView;
@property (nonatomic, strong) UIButton   * backBtn;
@property (nonatomic, strong) UIButton   * collectBtn;

@property (nonatomic, strong) UITableView   * classTable;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) KungfuClassHeaderView  * headerView;

//@property (nonatomic, strong) ZFPlayerController *player;
//@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) ClassGoodsModel *currentClassData;
@property (nonatomic, strong) KungfuClassVideoChooseView *videoEndView;

//控制锁屏
@property (nonatomic, assign) BOOL isLock;
//播放器
@property (nonatomic,strong, nullable) SLPlayerView *playerView;
@property (nonatomic,assign)BOOL isStatusHidden;

@property (nonatomic, strong) KungfuClassInfoView * infoView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UIView * loadBgView; // 加载时遮盖的view
@property (nonatomic, strong) UIView * tableFooterView;
@property (nonatomic, strong) UIButton * tableFooterViewBuyBtn;
@property (nonatomic, strong) UIButton * tableFooterViewAddShoppingCartBtn;
@property (nonatomic, strong) MASConstraint *addShoppingCartBtnWidthConstraint;

@property (nonatomic, strong) ClassDetailModel *model;
@property (nonatomic, strong) NSArray <ClassListModel *> *recommendedClassList;

@property (nonatomic, assign) NSInteger currentClassIndex;
@property(nonatomic, strong) UIButton * carButton;
@property(nonatomic, strong) UILabel * numberLabel;

///tableview底部View，用来增加滑动范围
@property(nonatomic, strong) UIView * occupationView;
@end

@implementation KungfuClassDetailViewController

#pragma mark - life cycle
-(void)dealloc {
    
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    
    AppDelegate * slAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    slAppDelegate.allowOrentitaionRotation = YES;
    
    // 添加教程观看记录
    if (self.currentClassData) {
        [self setCourseReadHistory:self.currentClassData time:self.playerView.saveCurrentTime];
    }
    [self destroyPlayVideo];
    NSLog(@"教程详情界面释放了");
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [ModelTool getUserData];
    [[DataManager shareInstance] getOrderAndCartCount];
    
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *carCountStr = [[ModelTool shareInstance] carCount];
        NSInteger carNumber = [carCountStr integerValue];
        
        if (carNumber > 0) {
            [self.numberLabel setText:carCountStr];
            [self.numberLabel setHidden:NO];
        }else{
            [self.numberLabel setHidden:YES];
        }
    });
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    [self.playerView pause];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGRect frame = self.carButton.frame;
    frame.origin.y = CGRectGetMinY(self.tableFooterView.frame) - CGRectGetHeight(frame) - SLChange(10);
    self.carButton.frame = frame;
    
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
    [self requestDetailData];
}

- (void) initUI {
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self.view addSubview:self.classTable];
    //    [self.view addSubview:self.navigationView];
//    [self.view addSubview:self.carButton];
    [self.view addSubview:self.tableFooterView];
    [self.view addSubview:self.loadBgView];
    
    [self.view addSubview:self.playerView];
    
    [self.rightBtn setImage:[UIImage imageNamed:@"focus_normal"] forState:(UIControlStateNormal)];
    [self.rightBtn setImage:[UIImage imageNamed:@"focus_select"] forState:(UIControlStateSelected)];
    [self.rightBtn addTarget:self action:@selector(foucsAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    
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
    self.navigationController.navigationBar.hidden = isFullScreen;
    if (isFullScreen) {
        self.videoEndView.backBtn.hidden = NO;
    } else {
        self.videoEndView.backBtn.hidden = YES;
    }
}

#pragma mark - event
- (void)setCourseReadHistory:(ClassGoodsModel *)data time:(float)time {
    
    if (!self.classId) {
        return;
    }
//    65949.94
    NSString *goodsId = self.classId;
    NSString *attrId = data.classGoodsId;
    
    if (time == 0.0) {
        time = 1.0;
    }
    NSString *timeStr = [NSString stringWithFormat:@"%d",(int)(time*1000)];
    
    NSDictionary *params = @{
        @"goods_id":goodsId,
        @"attr_id":attrId,
        @"time":timeStr
    };
    [[KungfuManager sharedInstance] setCourseReadHistory:params callback:^(NSDictionary *result) {
        NSLog(@"%@", result);
    }];
}

- (void)readyWithData:(ClassGoodsModel *)goodsModel selectIndex:(NSInteger)selectIndex
{
    if (![self.model.buy boolValue]){
        /** 未购买的视频，判断课节里的try_watch，0  不能试看  1 可以试看*/
        if ([goodsModel.try_watch intValue] == 0) {
            // 不能试看，return
            NSString * buttonTitle = self.tableFooterViewBuyBtn.titleLabel.text;
            
            if ([buttonTitle containsString:SLLocalizedString(@"最低段位")]) {
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
    
    // 添加当前教程播放记录，进度1秒
    [self setCourseReadHistory:goodsModel time:self.playerView.saveCurrentTime];

    self.currentClassData = goodsModel;
    self.currentClassIndex = selectIndex;
    
    if ([self.model.buy boolValue]) {
        if (self.currentClassIndex == self.model.goods_next.count - 1) {
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


-(void)foucsAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        //收藏
        [self collectSuccess:btn];
    }else
    {  //取消收藏
        [self collectCancle:btn];
    }
}

-(void)jumpGoodsCartAction
{
    // 跳转购物车
    ShoppingCartViewController *shoppingCartVC = [[ShoppingCartViewController alloc]init];
    [self.navigationController pushViewController:shoppingCartVC animated:YES];
}

- (void) showBuyAlertWithInfo
{
    [SMAlert setConfirmBtBackgroundColor:[UIColor colorForHex:@"8E2B25"]];
    [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
    [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
    [SMAlert setCancleBtTitleColor:[UIColor colorForHex:@"333333"]];
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
    UILabel *title = [[UILabel alloc]initWithFrame:customView.bounds];
    [title setFont:[UIFont systemFontOfSize:15]];
    [title setTextColor:[UIColor darkGrayColor]];
    title.text = SLLocalizedString(@"是否加入我的教程？");
    [title setTextAlignment:NSTextAlignmentCenter];
    [customView addSubview:title];
    
    [SMAlert showCustomView:customView stroke:YES confirmButton:[SMButton initWithTitle:SLLocalizedString(@"确定") clickAction:^{
        [self goPayClass];
    }] cancleButton:[SMButton initWithTitle:SLLocalizedString(@"取消") clickAction:nil]];
}

#pragma mark - request
- (void) requestDetailData {
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:@""];
    WEAKSELF
    [[KungfuManager sharedInstance] getClassDetailWithDic:@{@"id":self.classId} callback:^(NSDictionary *result) {
        ClassDetailModel *model = [ClassDetailModel mj_objectWithKeyValues:result];
        if (model && model.classDetailId){
            NSDictionary *params = @{
                @"level" : model.level,
            };
            [[KungfuManager sharedInstance] getClassWithDic:params ListAndCallback:^(NSArray *result) {
                weakSelf.recommendedClassList = result;
                [weakSelf setModel:model];
                [hud hideAnimated:YES];
            }];
        } else {
            [weakSelf setModel:nil];
            [hud hideAnimated:YES];
            
            NSString * errorMsg = result[@"msg"];
            [ShaolinProgressHUD singleTextAutoHideHud:NotNilAndNull(errorMsg)?errorMsg:SLLocalizedString(@"教程信息获取失败")];
        }
    }];
}

- (void) requestVideoAuthWithClassModel:(ClassGoodsModel *)goodsModel Block:(void(^)(ClassVideoModel * videoModel))videoBlock {
    
    if (IsNilOrNull(goodsModel.video_id)) {
        [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"视频获取失败，请稍后重试")];
        return;
    }
    
    // 从阿里获取播放凭证
    [[KungfuManager sharedInstance] getVideoAuthWithVideoId:goodsModel.video_id callback:^(NSDictionary *result) {
        
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

// 收藏成功
- (void)collectSuccess:(UIButton *)btn
{
    WEAKSELF
    NSDictionary * dic = @{@"goods_id":self.model.classDetailId,@"type":@"1"};
    [[KungfuManager sharedInstance] getClassCollectWithDic:dic callback:^(Message *message) {
        
        if (message.isSuccess) {
            [btn setSelected:YES];
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"收藏成功") view:weakSelf.view afterDelay:TipSeconds];
        } else {
            [ShaolinProgressHUD singleTextHud:message.reason view:weakSelf.view afterDelay:TipSeconds];
        }
    }];
}

// 取消收藏
-(void)collectCancle:(UIButton *)btn
{
    WEAKSELF
    NSDictionary * dic = @{@"goods_id":self.model.classDetailId,@"type":@"2"};
    [[KungfuManager sharedInstance] getClassCollectWithDic:dic callback:^(Message *message) {
        
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
    
    if ([buttonTitle containsString:SLLocalizedString(@"最低段位")]) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"您当前位阶与该教程不符") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    if ([buttonTitle isEqualToString:SLLocalizedString(@"观看教程")]) {
        if (IsNilOrNull(self.model.goods_next) || !self.model.goods_next.count) {
            return;
        }
        
        if (self.currentClassData) {
            return;
        }
        
        [self.classTable setContentOffset:CGPointMake(0,0) animated:NO];
        [self readyWithData:self.model.goods_next.firstObject selectIndex:0];
    }
    
    if ([buttonTitle isEqualToString:SLLocalizedString(@"免费观看")]) {
        [self goPayClass];
    }
    
    if ([buttonTitle isEqualToString:SLLocalizedString(@"学习教程")]) {
        [self goPayClass];
    }
}

///支付流程
- (void)goPayClass {
    SLRouteRealNameAuthenticationState state = [SLRouteManager pushRealNameAuthenticationState:self.navigationController showAlert:YES];
    if (state == RealNameAuthenticationStateSuccess) {
        NSMutableArray *modelMutabelArray = [NSMutableArray array];
        NSMutableDictionary *tam = [NSMutableDictionary dictionary];
        
        ShoppingCartGoodsModel *cartGoodModel = [[ShoppingCartGoodsModel alloc]init];
        
        cartGoodModel.name = self.model.classDetailName;
        cartGoodModel.desc = self.model.desc;
        cartGoodModel.img_data = self.model.img_data;
        cartGoodModel.price = self.model.old_price;
        cartGoodModel.current_price = self.model.old_price;
        cartGoodModel.stock = @"1";
        cartGoodModel.store_type = @"1";
        cartGoodModel.num = @"1";
        cartGoodModel.desc = self.model.desc;
        cartGoodModel.goods_id = self.model.classDetailId;
        
        [tam setValue:@[cartGoodModel] forKey:@"goods"];
        
        [modelMutabelArray addObject:tam];
        
        OrderFillCourseViewController *orderFillVC = [[OrderFillCourseViewController alloc] init];
        orderFillVC.dataArray = modelMutabelArray;
        [self.navigationController pushViewController:orderFillVC animated:YES];
    }
}
///加入购物车
- (void)addShoppingCartBtn
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    // 数量
    [dic setValue:@(1) forKey:@"num"];
    // 1 商品 2 教程
    [dic setValue:@(2) forKey:@"type"];
    // 商品id
    [dic setValue:self.model.classDetailId forKey:@"goods_id"];
    
    [ShaolinProgressHUD defaultSingleLoadingWithText:nil view:nil];
    [[DataManager shareInstance] addCar:dic Callback:^(Message *message) {
        if (message.isSuccess) {
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"已成功加入我的教程") view:WINDOWSVIEW afterDelay:TipSeconds];
            
            int carNumber = [self.numberLabel.text intValue] + 1;
            [self.numberLabel setText:[NSString stringWithFormat:@"%d",carNumber]];
            [self.numberLabel setHidden:NO];
            
        } else {
            [ShaolinProgressHUD singleTextHud:message.reason view:WINDOWSVIEW afterDelay:TipSeconds];
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
            if ([userModel.level_id intValue] < [self.model.look_level intValue]) {
                NSString *title = [NSString stringWithFormat:SLLocalizedString(@"最低段位%@可观看教程"), self.model.look_level_name];
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
    //    AVCLogModel *model = [[AVCLogModel alloc]initWithEvent:event];
    //    [self.logView haveReceivedNewEvent:model];
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

-(void)onFinishWithAliyunVodPlayerView:(AliyunVodPlayerView *)playerView{
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF
    if (indexPath.section == 0) {
        KungfuClassInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:classCellId forIndexPath:indexPath];
        cell.model = self.model;
        cell.moreHandle = ^{
            
            weakSelf.infoView = [[KungfuClassInfoView alloc]initWithFrame:weakSelf.view.bounds];
            [weakSelf.infoView setAlpha:0];
            
            weakSelf.infoView.classNameStr = weakSelf.model.classDetailName;
            weakSelf.infoView.classContentStr = weakSelf.model.intro;
            
            UIWindow *window = [weakSelf frontWindow];
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
        cell.cellSelectBlock = ^(ClassGoodsModel * _Nonnull classGoodModel, NSInteger indexRow) {
            
            if (IsNilOrNull(classGoodModel)) {
                return;
            }
            [weakSelf readyWithData:classGoodModel selectIndex:indexRow];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 114 + 36;
    }
    
    if (indexPath.section == 1) {
        if (self.model){
            if (self.model.goods_next.count > 3){
                return 3.5 * 64;
            }
            return self.model.goods_next.count*64 ;
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

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 40;
    }
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 10)];
    v.backgroundColor = [UIColor hexColor:@"fafafa"];
    return v;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 10)];
    v.backgroundColor = [UIColor hexColor:@"fafafa"];
    
    if (section == 2) {
        if (self.recommendedClassList.count){
            v.frame = CGRectMake(0, 0, kWidth, 40);
            
            UILabel * sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 5, kWidth - 32, 30)];
            sectionLabel.text = SLLocalizedString(@"相关推荐");
            sectionLabel.textColor = [UIColor hexColor:@"666666"];
            sectionLabel.font = [UIFont boldSystemFontOfSize:16];
            v.backgroundColor = UIColor.whiteColor;
            [v addSubview:sectionLabel];
        } else {
            v.frame = CGRectZero;
        }
    }
    
    return v;
}

#pragma mark - scrollerViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_COLORCHANGE_POINT)
    {
        CGFloat alpha = (offsetY - NAVBAR_COLORCHANGE_POINT) / NavBar_Height;
        self.navigationView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:alpha];
    }
    else
    {
        self.navigationView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    }
    
    if (offsetY > 190)
    {
        //        [self.player.currentPlayerManager pause];
    }
    
    self.playerView.top = - offsetY ;
}

#pragma mark - setter && getter

-(void)setCurrentClassIndex:(NSInteger)currentClassIndex {
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
    self.collectBtn.selected = [collect intValue];
    self.rightBtn.selected = [collect intValue];
    self.headerView.model = model;
    
    [self reloadTableFooterView];
    self.loadBgView.hidden = YES;
    
    [self.classTable layoutIfNeeded];
    [self.classTable reloadData];
}

-(UITableView *)classTable {
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

-(KungfuClassHeaderView *)headerView {
    //    WEAKSELF
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:(NSStringFromClass([KungfuClassHeaderView class])) owner:self options:nil] objectAtIndex:0];
        _headerView.playCallback = ^{
            //            [weakSelf playTheIndex:0];
        };
    }
    return _headerView;
}


-(UIView *)loadBgView {
    if (!_loadBgView) {
        _loadBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        _loadBgView.backgroundColor = UIColor.whiteColor;
    }
    return _loadBgView;
}

//- (ZFPlayerControlView *)controlView {
//    if (!_controlView) {
//        _controlView = [ZFPlayerControlView new];
//        _controlView.fastViewAnimated = YES;
//        _controlView.prepareShowLoading = YES;
//        _controlView.portraitControlView.titleLabel.hidden  = YES;
//    }
//    return _controlView;
//}

-(UIView *)tableFooterView {
    if (!_tableFooterView) {
        CGFloat tableFooterViewW = kWidth - 32;
        CGFloat btnGap = 13;
        _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight - 72 - kNavBarHeight - kBottomSafeHeight - kStatusBarHeight, kScreenWidth, 72)];
        _tableFooterView.backgroundColor = UIColor.clearColor;
//        [_tableFooterView addSubview:self.tableFooterViewAddShoppingCartBtn];
        [_tableFooterView addSubview:self.tableFooterViewBuyBtn];
//        [self.tableFooterViewAddShoppingCartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(18);
//            make.left.mas_equalTo(16);
//            make.width.mas_equalTo((tableFooterViewW - btnGap)/2);
//            make.height.mas_equalTo(40);
//        }];
//        [self.tableFooterViewBuyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.tableFooterViewAddShoppingCartBtn);
//            make.left.mas_equalTo(self.tableFooterViewAddShoppingCartBtn.mas_right).mas_equalTo(btnGap);
//            make.right.mas_equalTo(-16);
//            make.height.mas_equalTo(self.tableFooterViewAddShoppingCartBtn);
//        }];
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
        _tableFooterViewBuyBtn.backgroundColor = [UIColor hexColor:@"8E2B25"];
        _tableFooterViewBuyBtn.layer.cornerRadius = 20;
        _tableFooterViewBuyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_tableFooterViewBuyBtn setTitle:SLLocalizedString(@"观看教程") forState:UIControlStateNormal];
        [_tableFooterViewBuyBtn addTarget:self action:@selector(playClass) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tableFooterViewBuyBtn;
}

- (UIButton *)tableFooterViewAddShoppingCartBtn{
    if (!_tableFooterViewAddShoppingCartBtn){
        _tableFooterViewAddShoppingCartBtn = [[UIButton alloc] init];
        _tableFooterViewAddShoppingCartBtn.backgroundColor = [UIColor hexColor:@"F3F3F3"];
        _tableFooterViewAddShoppingCartBtn.layer.cornerRadius = 20;
        _tableFooterViewAddShoppingCartBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_tableFooterViewAddShoppingCartBtn setTitleColor:[UIColor hexColor:@"333333"] forState:UIControlStateNormal];
        [_tableFooterViewAddShoppingCartBtn setTitle:SLLocalizedString(@"加入我的教程") forState:UIControlStateNormal];
        [_tableFooterViewAddShoppingCartBtn addTarget:self action:@selector(addShoppingCartBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tableFooterViewAddShoppingCartBtn;
}

-(UIButton *)carButton
{
    if (_carButton == nil) {
        _carButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat width = 50, height = width;
        CGFloat x = ScreenWidth - width - 15;
        CGFloat y = ScreenHeight - height - 168;
        
        [_carButton setFrame:CGRectMake(x, y, width, height)];
        [_carButton setImage:[UIImage imageNamed:@"carButton"] forState:UIControlStateNormal];
        [_carButton addTarget:self action:@selector(jumpGoodsCartAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_carButton addSubview:self.numberLabel];
        
        NSString *carCountStr = [[ModelTool shareInstance] carCount];
        NSInteger carNumber = [carCountStr integerValue];
        
        if (carNumber > 0) {
            [self.numberLabel setText:carCountStr];
            [self.numberLabel setHidden:NO];
        }else{
            [self.numberLabel setHidden:YES];
        }
    }
    return _carButton;
}

-(UILabel *)numberLabel{
    if (_numberLabel == nil) {
        CGFloat x = 52 - 21;
        CGFloat y = 0;
        
        _numberLabel  = [[UILabel alloc]initWithFrame:CGRectMake(x, y, 15, 14)];
        [_numberLabel setFont:kRegular(9)];
        [_numberLabel setTextColor:[UIColor colorForHex:@"BE0B1F"]];
        [_numberLabel setTextAlignment:NSTextAlignmentCenter];
        _numberLabel.layer.cornerRadius = 6;
        _numberLabel.layer.borderColor =[UIColor colorForHex:@"BE0B1F"].CGColor;
        _numberLabel.layer.borderWidth = 1;
        [_numberLabel setBackgroundColor:[UIColor whiteColor]];
        [self.numberLabel.layer setMasksToBounds:YES];
    }
    return _numberLabel;
}

-(UIView *)occupationView {
    if (!_occupationView) {
        _occupationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 75)];
        _occupationView.backgroundColor = UIColor.whiteColor;
    }
    return _occupationView;
}

-(KungfuClassVideoChooseView *)videoEndView {
    WEAKSELF
    if (!_videoEndView) {
        _videoEndView = [KungfuClassVideoChooseView loadXib];
        _videoEndView.hidden = YES;
        _videoEndView.buyHandleBlock = ^{
            UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
            if (orientation != UIInterfaceOrientationPortrait ) {
                [weakSelf.playerView.controlView onClickedfullScreenButtonWithAliyunPVBottomView:nil];
            }
            
            [weakSelf goPayClass];
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
            
            ClassGoodsModel * nextM = weakSelf.model.goods_next[weakSelf.currentClassIndex + 1];
            // 播放下一节
            [weakSelf readyWithData:nextM selectIndex:weakSelf.currentClassIndex + 1];
        };
    }
    return _videoEndView;
}

//-(KungfuClassInfoView *)infoView {
//    if (!_infoView) {
//        _infoView = [KungfuClassInfoView new];
//    }
//    return _infoView;;
//}

- (UIWindow *)frontWindow {
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal && window.windowLevel <= UIWindowLevelNormal);
        if(windowOnMainScreen && windowIsVisible && windowLevelSupported) {
            return window;
        }
    }
    return nil;
}

#pragma mark - device

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscapeRight;
}

- (BOOL)shouldAutorotate{
    
    return YES;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscapeRight;
}

-(BOOL)prefersStatusBarHidden {
    return self.isStatusHidden;
}

@end
