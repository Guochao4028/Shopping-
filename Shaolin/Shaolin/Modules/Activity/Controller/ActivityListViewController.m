//
//  ActivityListViewController.m
//  Shaolin
//
//  Created by edz on 2020/4/7.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ActivityListViewController.h"
#import "StickCell.h"
#import "AdvertisingOneCell.h"
#import "SinglePhotoCell.h"
#import "MorePhotoCell.h"
#import "LongPhotoCell.h"
#import "FoundModel.h"
#import "AllTableViewCell.h"
#import "ActivityManager.h"
#import "FoundDetailsViewController.h"
#import "FoundModel.h"
#import "FoundVideoListVc.h"
#import "PureTextTableViewCell.h"
#import "AdverDetailsViewController.h"
#import "KungfuWebViewController.h"

#import "ZFUtilities.h"
#import "ZFPlayer.h"
#import "ZFPlayerController.h"
#import "ZFPlayerControlView.h"
#import "ZFAVPlayerManager.h"
#import "UIScrollView+ZFPlayer.h"
#import "DefinedURLs.h"
#import "AppDelegate+AppService.h"

@interface ActivityListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *foundArray;
@property (nonatomic, copy) NSString *totalStr;
@property (nonatomic, assign) NSInteger pager;
//@property(nonatomic,strong) NoDataView *noDataView;


@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@end

@implementation ActivityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.hideNavigationBar = YES;
    
    [self getData:self.selectPage];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getSelectPageData:) name:@"Activity_ReloadCurrentPage" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerCellAction:) name:@"VideoPlayerAction" object:nil];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData:self.selectPage];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 上拉加载
        [self loadNowMoreAction];
    }];
    
    
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(0);
    }];
    
    [self registerCell];
    [self setNoData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.player.viewControllerDisappear = NO;
    [self hideNavigationBarShadow];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self playCurrentVideo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.player.viewControllerDisappear = YES;
    [self stopCurrentVideo];
}
- (void)setNoData {
    WEAKSELF
    LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"categorize_nogoods"
                                                             titleStr:SLLocalizedString(@"暂无数据")
                                                            detailStr:@""
                                                          btnTitleStr:SLLocalizedString(@"点击加载")
                                                        btnClickBlock:^(){
        [weakSelf getData:self.selectPage];
    }];
    emptyView.subViewMargin = 12.f;
    emptyView.titleLabTextColor = RGBA(125, 125, 125,1);
    emptyView.detailLabTextColor =  RGBA(192, 192, 192,1);
    emptyView.actionBtnFont = [UIFont systemFontOfSize:15.f];
    emptyView.actionBtnTitleColor =  RGBA(90, 90, 90,1);
    emptyView.actionBtnHeight = 35.f;
    emptyView.actionBtnHorizontalMargin = 22.f;
    emptyView.actionBtnCornerRadius = 2.f;
    emptyView.actionBtnBorderColor =  RGBA(150, 150, 150,1);
    emptyView.actionBtnBorderWidth = 0.5;
    emptyView.actionBtnBackGroundColor = UIColor.whiteColor;
    self.tableView.ly_emptyView = emptyView;
}
- (void)getSelectPageData:(NSNotification *)user
{
    //     [self.foundArray removeAllObjects];
    NSDictionary *dic = user.userInfo;
    NSLog(@"%@",dic);
    NSInteger identifier = [[dic objectForKey:@"identifier"] integerValue];
    if (self.identifier != identifier) return;
    
    [self getData:self.selectPage];
}
- (void)playerCellAction:(NSNotification *)user
{
    NSDictionary *dic = user.userInfo;
    NSIndexPath *indexpath = [dic objectForKey:@"indexPath"];
    
    FoundModel *model = self.foundArray[indexpath.row];
    if ([model.type isEqualToString:@"3"]) {
        // 是广告
        if ([model.kind isEqualToString:@"3"]){ //视频广告
            [self playTheVideoAtIndexPath:indexpath scrollAnimated:NO];
        } else {
            [[SLAppInfoModel sharedInstance] advertEventResponseWithFoundModel:model];
        }
    } else {
        FoundVideoListVc *vC = [[FoundVideoListVc alloc]init];
        vC.hidesBottomBarWhenPushed = YES;
        vC.fieldId = model.fieldId;
        vC.videoId = model.id;
        vC.tabbarStr = @"Activity";
        vC.typeStr = @"2";
        [self.navigationController pushViewController:vC animated:YES];
    }
}

/// play the video
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollAnimated:(BOOL)animated {
    FoundModel *model = _foundArray[indexPath.row];
    //type 3:广告，kind 3:视频，非视频广告return，其实非视频广告进到这里就已经出错了
    if (!([model.type isEqualToString:@"3"] && [model.kind isEqualToString:@"3"])){
        return;
    }
    //    self.titleL.text = model.title;
    NSString *urlStr;
    for (NSDictionary *dic in model.coverUrlList) {
        urlStr = [dic objectForKey:@"route"];
    }
    if (animated) {
        [self.player playTheIndexPath:indexPath assetURL:[NSURL URLWithString:urlStr] scrollPosition:ZFPlayerScrollViewScrollPositionTop animated:YES];
    } else {
        [self.player playTheIndexPath:indexPath assetURL:[NSURL URLWithString:urlStr]];
    }
    [self.controlView showTitle:@""
                 coverURLString:[NSString stringWithFormat:@"%@%@",urlStr, Video_First_Photo]
               placeholderImage:[ZFUtilities imageWithColor:[UIColor clearColor] size:CGSizeMake(100, 100)]
                 fullScreenMode:ZFFullScreenModeLandscape];
}

- (void)playCurrentVideo{
    if (self.player.playingIndexPath){
        [self.player.currentPlayerManager play];
    }
}

- (void)pauseCurrentVideo{
    if (self.player.playingIndexPath){
        [self.player.currentPlayerManager pause];
    }
}

- (void)stopCurrentVideo{
    if (self.player.playingIndexPath){
        [self.player stopCurrentPlayingCell];
    }
}

- (void)refreshAndScrollToTop {
    @try {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    } @catch (NSException *exception) {
        
    } @finally {
        [self.tableView.mj_header beginRefreshing];
    }
}

#pragma mark - 下拉刷新
- (void)getData:(NSInteger)selectPage {
    self.pager = 1;
//    NSString *selectStr = [NSString stringWithFormat:@"%ld",selectPage];
//    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
//    [[ActivityManager sharedInstance] getHomeListFieldld:selectStr PageNum:@"1" PageSize:@"30" success:nil failure:nil finish:^(id _Nonnull responseObject, NSString * _Nonnull errorReason) {
//        [hud hideAnimated:YES];
//        if ([ModelTool checkResponseObject:responseObject]){
//            NSDictionary *data = responseObject[DATAS];
//            NSArray *arr = [data objectForKey:@"data"];
//            if ([arr isKindOfClass:[NSArray class]] && arr.count >0) {
//                self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//                    [self loadNowMoreAction];
//                }];
//                self.foundArray = [FoundModel mj_objectArrayWithKeyValuesArray:arr];
//                [self.tableView reloadData];
//                [self.tableView.mj_header endRefreshing];
//                //                self.noDataView.hidden = YES;
//            } else {
//                [self.foundArray removeAllObjects];
//                [self.tableView.mj_header endRefreshing];
//                self.tableView.mj_footer.hidden = YES;
//                [self.tableView reloadData];
//            }
//        } else {
//            [self.foundArray removeAllObjects];
//            [self.tableView.mj_header endRefreshing];
//            self.tableView.mj_footer.hidden = YES;
//            [self.tableView reloadData];
//            [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
//        }
//    }];
}

#pragma mark - 上拉加载
- (void)loadNowMoreAction {
    self.pager ++;
//    NSString *selectStr =@"";
//    if (self.selectPage == 0) {
//        
//    } else {
//        selectStr = [NSString stringWithFormat:@"%ld",self.selectPage];
//    }
//    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
//    [[ActivityManager sharedInstance] getHomeListFieldld:selectStr PageNum:[NSString stringWithFormat:@"%tu",self.pager] PageSize:@"30" success:nil failure:nil finish:^(id  _Nonnull responseObject, NSString * _Nonnull errorReason) {
//        [hud hideAnimated:YES];
//        if ([ModelTool checkResponseObject:responseObject]){
//            NSDictionary *data = responseObject[DATAS];
//            NSArray *arr = [data objectForKey:@"data"];
//            if ([arr isKindOfClass:[NSArray class]] && arr.count >0) {
//                NSArray * modelArray = [FoundModel mj_objectArrayWithKeyValuesArray:arr];
//                [self.foundArray addObjectsFromArray:modelArray];
//                [self.tableView reloadData];
//                [self.tableView.mj_footer endRefreshing];
//            } else {
//                [self.tableView.mj_header endRefreshing];
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            }
//        } else {
//            [self.tableView.mj_header endRefreshing];
//            [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
//        }
//    }];
}
- (void)registerCell
{
    [_tableView registerClass:[StickCell class] forCellReuseIdentifier:NSStringFromClass([StickCell class])];
    [_tableView registerClass:[AdvertisingOneCell class] forCellReuseIdentifier:NSStringFromClass([AdvertisingOneCell class])];
    [_tableView registerClass:[SinglePhotoCell class] forCellReuseIdentifier:NSStringFromClass([SinglePhotoCell class])];
    [_tableView registerClass:[MorePhotoCell class] forCellReuseIdentifier:NSStringFromClass([MorePhotoCell class])];
    [_tableView registerClass:[PureTextTableViewCell class] forCellReuseIdentifier:NSStringFromClass([PureTextTableViewCell class])];
    
    
}

#pragma mark - UIScrollViewDelegate   列表播放必须实现

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidEndDecelerating];
    
    // 非正常途径解决滑动结束播放视频
    scrollView.zf_stopPlay = NO;
    [scrollView zf_scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [scrollView zf_scrollViewDidEndDraggingWillDecelerate:decelerate];
    
    // 非正常途径解决滑动结束播放视频
    if (decelerate == NO){
        scrollView.zf_stopPlay = NO;
        [scrollView zf_scrollViewDidScroll];
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScrollToTop];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScroll];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewWillBeginDragging];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _foundArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FoundModel *model = _foundArray[indexPath.row];
    AllTableViewCell *cell;
    NSString *cellIdentifier;
    cellIdentifier = model.cellIdentifier;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [cell setFoundModel:model indexpath:indexPath];
    
    NSMutableArray *typeNum = [NSMutableArray array];
    for (FoundModel *dic in self.foundArray) {
        if ([dic.type isEqualToString:@"1"]) {
            [typeNum addObject:dic.type];
        }
    }
    
    if ([model.type isEqualToString:@"1"]) {
        if (indexPath.row == typeNum.count-1) {
            cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
        }else
        {
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width*10);
        }
        
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    FoundModel *model = self.foundArray[indexPath.row];
    
    if ([model.type isEqualToString:@"3"]) {
        // 是广告
        [[SLAppInfoModel sharedInstance] advertEventResponseWithFoundModel:model];
    }else{
        if ([model.kind isEqualToString:@"3"]) {
            FoundVideoListVc *vC = [[FoundVideoListVc alloc]init];
            vC.hidesBottomBarWhenPushed = YES;
            vC.fieldId = model.fieldId;
            vC.videoId = model.id;
            vC.tabbarStr = @"Activity";
            vC.typeStr = @"2";
            [self.navigationController pushViewController:vC animated:YES];
        } else {
            AllTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            FoundDetailsViewController *vC = [[FoundDetailsViewController alloc]init];
            vC.idStr = model.id;
            vC.tabbarStr = @"Activity";
            vC.typeStr = @"2";
            vC.stateStr = !model.state ? @"" : model.state;
            vC.showImage = [cell getShowImage];
            vC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vC animated:YES];
        }
    }
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    FoundModel *model = self.foundArray[indexPath.row];
//    return model.cellHeight;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 10)];
    view.backgroundColor = UIColor.whiteColor;
    return view;
}
#pragma mark - Getters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        //        _tableView.rowHeight = 227;
        _tableView.separatorColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

- (ZFPlayerController *)player{
    if (!_player){
        /// playerManager
        ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
        playerManager.view.backgroundColor = [UIColor clearColor];
        playerManager.muted = YES;
        /// player,tag值必须在cell里设置
        _player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:playerManager containerViewTag:100];
        _player.WWANAutoPlay = YES;
        _player.controlView = self.controlView;
        /// 1.0是消失100%时候
        _player.playerDisapperaPercent = 0.8;
        /// 播放器view露出一半时候开始播放
        _player.playerApperaPercent = 0.1;
        
        WEAKSELF
        _player.playerDidToEnd = ^(id  _Nonnull asset) {
            [weakSelf.player stopCurrentPlayingCell];
        };
        
        _player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
            [AppDelegate shareAppDelegate].allowOrentitaionRotation = isFullScreen;
            //        kAPPDelegate.allowOrentitaionRotation = isFullScreen;
            //        [weakSelf setNeedsStatusBarAppearanceUpdate];
            if (!isFullScreen) {
                /// 解决导航栏上移问题
                //            self.navigationController.navigationBar.zf_height = KNavBarHeight;
            }
            //切全屏时播放声音，切回列表时静音
            playerManager.muted = !isFullScreen;
            //            weakSelf.tableView.scrollsToTop = NO;//!isFullScreen;
            NSString *title = @"";
            if (isFullScreen){
                FoundModel *model = weakSelf.foundArray[weakSelf.player.playingIndexPath.row];
                title = model.title;
            }
            [weakSelf.controlView.portraitControlView showTitle:title fullScreenMode:ZFFullScreenModeLandscape];
            [weakSelf.controlView.landScapeControlView showTitle:title fullScreenMode:ZFFullScreenModeLandscape];
        };
        _player.zf_playerDidAppearInScrollView = ^(NSIndexPath * _Nonnull indexPath) {
            if (!weakSelf.player.playingIndexPath) {
                [weakSelf playTheVideoAtIndexPath:indexPath scrollAnimated:NO];
            }
        };
    }
    return _player;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
        _controlView.horizontalPanShowControlView = NO;
        // 显示loading
        _controlView.prepareShowLoading = YES;
        //TODO: 去掉高斯模糊背景
        [_controlView setEffectViewShow:NO];
    }
    return _controlView;
}

//- (NoDataView *)noDataView {
//    if (_noDataView) {
//        _noDataView = [[NoDataView alloc]init];
//        _noDataView.hidden = YES;
//        WEAKSELF
//        _noDataView.RefreshBlock = ^{
//            [weakSelf.tableView.mj_header beginRefreshing];
//        };
//    }
//    return _noDataView;
//}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
