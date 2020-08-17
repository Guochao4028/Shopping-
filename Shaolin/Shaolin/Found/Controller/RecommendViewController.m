//
//  RecommendViewController.m
//  Shaolin
//
//  Created by edz on 2020/3/5.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RecommendViewController.h"
#import "StickCell.h"
#import "AdvertisingOneCell.h"
#import "SinglePhotoCell.h"
#import "MorePhotoCell.h"
#import "LongPhotoCell.h"
#import "FoundModel.h"
#import "BannerSubModel.h"
#import "AllTableViewCell.h"
#import "HomeManager.h"
#import "FoundDetailsViewController.h"
#import "KungfuWebViewController.h"

#import "FoundVideoListVc.h"
#import "PureTextTableViewCell.h"
#import "AdverDetailsViewController.h"

#import "ZFUtilities.h"
#import "ZFPlayer.h"
#import "ZFPlayerController.h"
#import "ZFPlayerControlView.h"
#import "ZFAVPlayerManager.h"
#import "UIScrollView+ZFPlayer.h"

@interface RecommendViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *foundArray;
@property (nonatomic, copy) NSString *totalStr;
@property (nonatomic, assign) NSInteger pager;
@property(nonatomic,strong) LYEmptyView *emptyView;

@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /**
        置顶的cell高度  60
          广告的cell 高度 353
                最右侧单图文章 116
             多张图片 203
               单张长图  227
     */
    NSLog(@"==============");
    self.foundArray = [@[] mutableCopy];
    [self update];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getSelectPageData:) name:@"ReloadCurrentPage" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerCellAction:) name:@"VideoPlayerAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemVolumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self update];
      }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    self.tableView.mj_footer.hidden = YES;
    
     [self.view addSubview:self.tableView];
     [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.edges.equalTo(self.view);
       }];
   
    [_tableView setTableFooterView:[[UIView alloc] init]];
    
    [self registerCell];
    [self setNoData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self playCurrentVideo];
}

- (void)setNoData {
    WEAKSELF
    LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"categorize_nogoods"
                                                             titleStr:SLLocalizedString(@"暂无数据")
                                                            detailStr:@""
                                                          btnTitleStr:SLLocalizedString(@"点击加载")
                                                        btnClickBlock:^(){
        [weakSelf update];
    }];
    emptyView.subViewMargin = 12.f;
    
    emptyView.titleLabTextColor = RGBA(125, 125, 125,1);
    
    emptyView.detailLabTextColor =  RGBA(192, 192, 192,1);
    
    emptyView.actionBtnFont = [UIFont systemFontOfSize:15.f];
    emptyView.actionBtnTitleColor =  RGBA(90, 90, 90,1);
    emptyView.actionBtnHeight = 30.f;
    emptyView.actionBtnHorizontalMargin = 22.f;
    emptyView.actionBtnCornerRadius = 2.f;
    emptyView.actionBtnBorderColor =  RGBA(150, 150, 150,1);
    emptyView.actionBtnBorderWidth = 0.5;
    emptyView.actionBtnBackGroundColor = [UIColor colorForHex:@"FFFFFF"];
    self.emptyView = emptyView;
}
-(void)getSelectPageData:(NSNotification *)user
{
//     [self.foundArray removeAllObjects];
    NSDictionary *dic = user.userInfo;
    NSLog(@"%@",dic);
    NSInteger identifier = [[dic objectForKey:@"identifier"] integerValue];
    if (self.identifier != identifier) return;
    [self update];
}
-(void)playerCellAction:(NSNotification *)user
{
    NSDictionary *dic = user.userInfo;
    NSIndexPath *indexpath = [dic objectForKey:@"indexPath"];
    
    FoundModel *model = self.foundArray[indexpath.row];
    if ([model.type isEqualToString:@"3"]) {
        // 是广告
        if ([model.kind isEqualToString:@"3"]){ //视频广告
            [self playTheVideoAtIndexPath:indexpath scrollToTop:NO];
        } else {
            [[SLAppInfoModel sharedInstance] advertEventResponseWithFoundModel:model];
        }
    } else
    {
        FoundVideoListVc *vC = [[FoundVideoListVc alloc]init];
           vC.hidesBottomBarWhenPushed = YES;
           vC.fieldId = model.fieldId;
           vC.videoId = model.id;
           vC.tabbarStr = @"Found";
           vC.typeStr = @"1";
           [self.navigationController pushViewController:vC animated:YES];
    }
}

/// play the video
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {
    FoundModel *model = _foundArray[indexPath.row];
    //type 3:广告，kind 3:视频，非视频广告return，其实非视频广告进到这里就已经出错了
    if (!([model.type isEqualToString:@"3"] && [model.kind isEqualToString:@"3"])){
        return;
    }
//    self.titleL.text = model.title;
    NSString *urlStr;
    for (NSDictionary *dic in model.coverurlList) {
        urlStr = [dic objectForKey:@"route"];
    }
    [self.player playTheIndexPath:indexPath assetURL:[NSURL URLWithString:urlStr] scrollToTop:scrollToTop];
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

- (void)systemVolumeChanged:(NSNotification *)notification{
//    self.player.currentPlayerManager.muted = NO;
    NSLog(@"Parameter:%@", notification.userInfo[@"AVSystemController_AudioVolumeNotificationParameter"]);
}
#pragma mark - requestData
- (void)requestData:(void (^)(NSArray *foundModelArray))success failure:(void (^)(NSError * _Nonnull error))failure{
    NSString *fieldId = @"";
    if (self.selectPage != 0){
        fieldId = [NSString stringWithFormat:@"%ld", self.selectPage];
    }
    NSString *pageNum = [NSString stringWithFormat:@"%ld", self.pager];
    NSString *pageSize = @"30";
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[HomeManager sharedInstance] getHomeListFieldld:fieldId PageNum:pageNum PageSize:pageSize Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [hud hideAnimated:YES];
        if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
            NSArray *arr = [solveJsonData changeType:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
            NSArray *foundModelArray = [FoundModel mj_objectArrayWithKeyValuesArray:arr];
            [self.foundArray addObjectsFromArray:foundModelArray];
            if (self.foundArray.count == 0){
                self.tableView.ly_emptyView = self.emptyView;
            }
            [self.tableView reloadData];
            [self.tableView layoutIfNeeded];
            if (success) success(foundModelArray);
        } else {
            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"message"] view:self.view afterDelay:TipSeconds];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        if (failure) failure(error);
    }];
}

- (void)update{
    self.pager = 1;
    [self.foundArray removeAllObjects];
    [self requestData:^(NSArray *foundModelArray) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
//        CGFloat tableViewHeight = CGRectGetHeight(self.tableView.frame);
//        CGFloat y = CGRectGetMinY(self.tableView.mj_footer.frame);
//        if (y < tableViewHeight){
//            self.tableView.mj_footer.hidden = YES;
//        } else {
            self.tableView.mj_footer.hidden = foundModelArray.count == 0;
//        }
    } failure:^(NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreData{
    self.pager++;
    [self requestData:^(NSArray *foundModelArray) {
        [self.tableView.mj_footer endRefreshing];
        if (foundModelArray.count == 0){
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)refreshAndScrollToTop {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self.tableView.mj_header beginRefreshing];
}

-(void)registerCell
{
    //置顶cell
    [_tableView registerClass:[StickCell class]
       forCellReuseIdentifier:NSStringFromClass([StickCell class])];
    //广告cell
    [_tableView registerClass:[AdvertisingOneCell class]
       forCellReuseIdentifier:NSStringFromClass([AdvertisingOneCell class])];
    //单图片cell(图片在右侧)
    [_tableView registerClass:[SinglePhotoCell class]
       forCellReuseIdentifier:NSStringFromClass([SinglePhotoCell class])];
    //多图cell(图片在下面)
    [_tableView registerClass:[MorePhotoCell class]
       forCellReuseIdentifier:NSStringFromClass([MorePhotoCell class])];
    //纯文字cell
    [_tableView registerClass:[PureTextTableViewCell class]
       forCellReuseIdentifier:NSStringFromClass([PureTextTableViewCell class])];
}


#pragma mark - UIScrollViewDelegate   列表播放必须实现

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidEndDecelerating];
    
    // 非正常途径解决滑动结束自动播放视频，应该有更合适的方法而不是在这调用zf_scrollViewDidScroll
    scrollView.zf_stopPlay = NO;
    [scrollView zf_scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [scrollView zf_scrollViewDidEndDraggingWillDecelerate:decelerate];
    
    // 非正常途径解决滑动结束自动播放视频
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self pauseCurrentVideo];
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
           vC.tabbarStr = @"Found";
           vC.typeStr = @"1";
           [self.navigationController pushViewController:vC animated:YES];
       } else {
           AllTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
           FoundDetailsViewController *vC = [[FoundDetailsViewController alloc]init];
           vC.idStr = model.id;
           vC.tabbarStr = @"Found";
           vC.typeStr = @"1";
           vC.stateStr = !model.state ? @"" : model.state;
           vC.showImage = [cell getShowImage];
           vC.hidesBottomBarWhenPushed = YES;
           [self.navigationController pushViewController:vC animated:YES];
       }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FoundModel *model = self.foundArray[indexPath.row];
    return model.cellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SLChange(10);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, SLChange(10))];
    view.backgroundColor = [UIColor colorForHex:@"FFFFFF"];
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
        
    }
    return _tableView;
}

- (ZFPlayerController *)player{
    if (!_player){
        /// playerManager
        ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
        playerManager.muted = YES;
        playerManager.view.backgroundColor = [UIColor clearColor];
        
        /// player,tag值必须在cell里设置
        _player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:playerManager containerViewTag:100];
        //移动网络自动播放视频
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
                [weakSelf playTheVideoAtIndexPath:indexPath scrollToTop:NO];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
