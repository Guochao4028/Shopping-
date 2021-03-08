//
//  FoundVideoListVc.m
//  Shaolin
//
//  Created by edz on 2020/3/26.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "FoundVideoListVc.h"
#import "ZFPlayer.h"
#import "ZFAVPlayerManager.h"
#import "ZFIJKPlayerManager.h"
#import "ZFPlayerControlView.h"
#import "ZFTableViewCellLayout.h"
#import "ZFTableViewCell.h"
#import "ZFTableData.h"
#import "HomeManager.h"
#import "SLShareView.h"
#import "SLPlayerControlView.h"
#import "ZFUtilities.h"
#import "DefinedHost.h"
#import "DefinedURLs.h"
#import "AppDelegate+AppService.h"
#import "MePostManagerModel.h"
#import "ThumbFollowShareManager.h"

static NSString *kIdentifier = @"kIdentifier";

@interface FoundVideoListVc ()<UITableViewDelegate,UITableViewDataSource,ZFTableViewCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) SLPlayerControlView *controlView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *urls;
@property(nonatomic,assign) NSInteger praiseInteger;
@property(nonatomic,assign) NSInteger collectionInteger;
@property(nonatomic,strong) UIButton *backButton;
@property(nonatomic,strong) SLShareView *slShareView;
@property(nonatomic) BOOL originNavigationBarHidden;

@property (nonatomic) NSInteger pageNum;
@property (nonatomic) NSInteger pageSize;
@end

@implementation FoundVideoListVc

- (instancetype)init
{
    self = [super init];
    self.pageNum = 1;
    self.pageSize = 10;
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.player.viewControllerDisappear = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.player.viewControllerDisappear = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    @weakify(self)
    [self.tableView zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
        @strongify(self)
        [self playTheVideoAtIndexPath:indexPath scrollAnimated:NO];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.hideNavigationBar && !self.hideNavigationBarView){
        self.hideNavigationBar = YES;
    }
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.tableView];
    
    [self update];
    
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    
    /// player的tag值必须在cell里设置
    self.player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:playerManager containerViewTag:100];
    self.player.controlView = self.controlView;
    self.player.assetURLs = self.urls;
    /// 0.8是消失80%时候
    self.player.playerDisapperaPercent = 0.8;
    /// 移动网络依然自动播放
    self.player.WWANAutoPlay = YES;
    //        self.player.shouldAutoPlay = YES;
    @weakify(self)
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        // 重新播放
        [self.player.currentPlayerManager replay];
        // 自动播放下一个
//        if (self.player.playingIndexPath.row < self.urls.count - 1) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.player.playingIndexPath.row+1 inSection:0];
//            [self playTheVideoAtIndexPath:indexPath scrollToTop:YES];
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.player.playingIndexPath.row inSection:0];
//            [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
//        } else {
//            [self.player stopCurrentPlayingCell];
//        }
    };
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        [AppDelegate shareAppDelegate].allowOrentitaionRotation = isFullScreen;
    };
    
    /// 停止的时候找出最合适的播放(只能找到设置了tag值cell)
    self.player.zf_scrollViewDidEndScrollingCallback = ^(NSIndexPath * _Nonnull indexPath) {
        @zf_strongify(self)
        if (!self.player.playingIndexPath) {
            [self playTheVideoAtIndexPath:indexPath scrollAnimated:NO];
        }
    };

     
    /// 滑动中找到适合的就自动播放
    /// 如果是停止后再寻找播放可以忽略这个回调
    /// 如果在滑动中就要寻找到播放的indexPath，并且开始播放，那就要这样写
    self.player.zf_playerShouldPlayInScrollView = ^(NSIndexPath * _Nonnull indexPath) {
        @zf_strongify(self)
        if ([indexPath compare:self.player.playingIndexPath] != NSOrderedSame) {
            [self playTheVideoAtIndexPath:indexPath scrollAnimated:NO];
        }
    };
    
    self.backButton = [[UIButton alloc]initWithFrame:CGRectMake(16, StatueBar_Height + 3, 30, 30)];
    
    [self.backButton setImage:[UIImage imageNamed:@"video_left"] forState:(UIControlStateNormal)];

    [self.backButton addTarget:self action:@selector(leftAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.backButton];

}
- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)update{
    self.pageNum = 1;
    self.urls = @[].mutableCopy;
    self.dataSource = @[].mutableCopy;
    WEAKSELF
    [self requestData:^(NSArray *foundModelArray) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        weakSelf.tableView.mj_footer.hidden = foundModelArray.count == 0;
    } failure:^(NSString * errorReason) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreData{
    self.pageNum ++;
    WEAKSELF
    [self requestData:^(NSArray *array) {
        [weakSelf.tableView.mj_footer endRefreshing];
        if (array.count == 0){
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSString * errorReason) {
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)requestData:(void (^)(NSArray *array))success failure:(void (^)(NSString * errorReason))failure{
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[HomeManager sharedInstance]getHomeVideoListFieldld:self.fieldId TabbarStr:self.tabbarStr VideoId:self.videoId PageNum:[NSString stringWithFormat:@"%ld", self.pageNum] PageSize:[NSString stringWithFormat:@"%ld", self.pageSize] Success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable responseObject, NSString * _Nullable errorReason) {
        [hud hideAnimated:YES];
        if ([[responseObject objectForKey:@"code"]integerValue]==200) {
            NSArray *videoList = [[responseObject objectForKey:@"data"] objectForKey:@"data"];
            for (NSDictionary *dataDic in videoList) {
                if ([[dataDic allKeys] containsObject:@"coverUrl"]) {
                    ZFTableData *data = [[ZFTableData alloc] init];
                    NSDictionary *newDataDict = [ThumbFollowShareManager reloadDictByLocalCache:dataDic modelItemType:FoundItemType  modelItemKind:Video];
                    [data setValuesForKeysWithDictionary:newDataDict];
                    ZFTableViewCellLayout *layout = [[ZFTableViewCellLayout alloc] initWithData:data];
                    [self.dataSource addObject:layout];
                    NSString *URLString = [data.coverUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                    NSURL *url = [NSURL URLWithString:URLString];
                    [self.urls addObject:url];
                    //                self.player.assetURLs = self.urls;
                    [self.tableView reloadData];
                }
            }
            // 如果是审核中的视频，通过这个接口找不到,特殊处理一下
            if (videoList.count == 0 && self.model) {
                NSString *videoStr ;
                for (NSDictionary *dic in self.model.coverUrlList) {
                    videoStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"route"]];
                }
                NSDictionary *dict = [self.model mj_keyValues];
                ZFTableData *data = [ZFTableData mj_objectWithKeyValues:dict];
                data.coverUrl = videoStr;
                data.praise = nil;
                data.praiseState = nil;
                data.collectionState = nil;
                data.collection = nil;
                ZFTableViewCellLayout *layout = [[ZFTableViewCellLayout alloc] initWithData:data];
                [self.dataSource addObject:layout];
                [self.urls addObject:[NSURL URLWithString:videoStr]];
                [self.tableView reloadData];
            }
            if (success) success(videoList);
        }else {
            if (failure) failure(errorReason);
        }
    }];
    
}
- (BOOL)shouldAutorotate {
    return self.player.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.player.isFullScreen && self.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

#pragma mark - UIScrollViewDelegate  列表播放必须实现

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidEndDecelerating];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [scrollView zf_scrollViewDidEndDraggingWillDecelerate:decelerate];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    
    [scrollView zf_scrollViewDidScrollToTop];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScroll];
    @weakify(self)
    [scrollView zf_filterShouldPlayCellWhileScrolling:^(NSIndexPath *indexPath) {
        if ([indexPath compare:self.tableView.zf_shouldPlayIndexPath] != NSOrderedSame) {
            @strongify(self)
            /// 显示黑色蒙版
            ZFTableViewCell *cell1 = [self.tableView cellForRowAtIndexPath:self.tableView.zf_shouldPlayIndexPath];
            
            [cell1 showMaskView];
            /// 隐藏黑色蒙版
            ZFTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            [cell hideMaskView];
        }
    }];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewWillBeginDragging];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier];
    [cell setDelegate:self withIndexPath:indexPath];
    cell.layout = self.dataSource[indexPath.row];
//    cell.backgroundColor = [UIColor blackColor];
    //    cell.alpha = 0.8;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    if (self.player.playingIndexPath != indexPath) {
    //        [self.player stopCurrentPlayingCell];
    //    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    ZFTableViewCellLayout *layout = self.dataSource[indexPath.row];
    //    return layout.height;
    return kHeight;
}

#pragma mark - ZFTableViewCellDelegate

- (void)zf_playTheVideoAtIndexPath:(NSIndexPath *)indexPath {
    
    [self playTheVideoAtIndexPath:indexPath scrollAnimated:YES];
}
#pragma mark - 点赞
- (void)prasieActionButton:(ZFTableViewCell *)cell IndexPath:(NSInteger)indexPath IndexPathRow:(NSIndexPath *)row
{
    //    /// 如果正在播放的index和当前点击的index不同
    if (self.player.playingIndexPath != row) {
        
    }else
    {
        ZFTableViewCellLayout *data = self.dataSource[indexPath];
        [cell setPraiseBtnSelected:!cell.praiseBtn.selected];
        if (cell.praiseBtn.selected) { //点赞
            
            [self praiseAction:data IndexPath:indexPath cell:cell];
            
        }else
        {
            
            NSString *strId = [NSString stringWithFormat:@"%@", data.data.id];
            NSMutableArray *arr = [NSMutableArray array];
            NSDictionary *dic = @{@"contentId":strId,@"type":self.typeStr, @"kind":@"2"};
            [arr addObject:dic];
            [self canclePraiseAction:arr Model:data IndexPath:indexPath cell:cell];
        }
        
    }
}
#pragma mark - 点赞成功
- (void)praiseAction:(ZFTableViewCellLayout *)layout IndexPath:(NSInteger)indexPath cell:(ZFTableViewCell *)cell
{
    
    NSString *contentId = [NSString stringWithFormat:@"%@",layout.data.id];
//    [[HomeManager sharedInstance]postPraiseContentId:contentId Type:self.typeStr Kind:@"2" MemberId:@"" MemberName:@"" Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSLog(@"%@",responseObject);
//        if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
//            
//            layout.data.praise = [NSNumber numberWithInteger:2];
//            NSInteger likeCount = [layout.data.praises integerValue];
//            likeCount += 1;
//            
//            layout.data.praises = [NSNumber numberWithInteger:likeCount];
//            [self.dataSource setObject:layout atIndexedSubscript:indexPath];
//            [btn setSelected:YES];
//            [btn setTitle:[NSString stringWithFormat:@" %ld",likeCount] forState:(UIControlStateNormal)];
//            
//            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"点赞成功") view:self.view afterDelay:TipSeconds];
//        }else
//        {
//            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"message"] view:self.view afterDelay:TipSeconds];
//        }
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:self.view afterDelay:TipSeconds];
//    }];
    
    [[HomeManager sharedInstance]postPraiseContentId:contentId Type:self.typeStr Kind:@"2" MemberId:@"" MemberName:@"" Success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable responseObject, NSString * _Nullable errorReason) {
        NSLog(@"%@",responseObject);
        layout.data.praiseState = [NSNumber numberWithInteger:1];
        NSInteger likeCount = [layout.data.praise integerValue];
        likeCount += 1;
        
        layout.data.praise = [NSNumber numberWithInteger:likeCount];
        [self.dataSource setObject:layout atIndexedSubscript:indexPath];
        [cell setPraiseBtnSelected:YES];
        cell.praiseLabel.text = [NSString stringWithFormat:@"%ld",likeCount];
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"点赞成功") view:self.view afterDelay:TipSeconds];
//               if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
//
//                   layout.data.praiseState = [NSNumber numberWithInteger:1];
//                   NSInteger likeCount = [layout.data.praise integerValue];
//                   likeCount += 1;
//
//                   layout.data.praise = [NSNumber numberWithInteger:likeCount];
//                   [self.dataSource setObject:layout atIndexedSubscript:indexPath];
//                   [cell setPraiseBtnSelected:YES];
//                   cell.praiseLabel.text = [NSString stringWithFormat:@"%ld",likeCount];
//                   [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"点赞成功") view:self.view afterDelay:TipSeconds];
//               }else
//               {
//                   [ShaolinProgressHUD singleTextHud:errorReason view:self.view afterDelay:TipSeconds];
//               }
    }];
}
#pragma mark - 取消点赞
- (void)canclePraiseAction:(NSMutableArray *)arr Model:(ZFTableViewCellLayout *)layout IndexPath:(NSInteger)indexPath cell:(ZFTableViewCell *)cell
{
    
    [[HomeManager sharedInstance]postPraiseCancleArray:arr WithBlock:^(id  _Nonnull responseObject, NSString * _Nonnull error) {
        NSLog(@"%@",responseObject);
        layout.data.praiseState = [NSNumber numberWithInteger:0];
        NSInteger likeCount = [layout.data.praise integerValue];
        likeCount --;
        if (likeCount < 0) likeCount = 0;
        layout.data.praise= [NSNumber numberWithInteger:likeCount];
        [self.dataSource setObject:layout atIndexedSubscript:indexPath];
        [cell setPraiseBtnSelected:NO];
        cell.praiseLabel.text = [NSString stringWithFormat:@"%ld",likeCount];
        
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"取消点赞") view:self.view afterDelay:TipSeconds];
//        if ([[responseObject objectForKey:@"code"] integerValue]== 200) {
//            layout.data.praiseState = [NSNumber numberWithInteger:0];
//            NSInteger likeCount = [layout.data.praise integerValue];
//            likeCount --;
//            if (likeCount < 0) likeCount = 0;
//            layout.data.praise= [NSNumber numberWithInteger:likeCount];
//            [self.dataSource setObject:layout atIndexedSubscript:indexPath];
//            [cell setPraiseBtnSelected:NO];
//            cell.praiseLabel.text = [NSString stringWithFormat:@"%ld",likeCount];
//
//            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"取消点赞") view:self.view afterDelay:TipSeconds];
//        }else
//        {
//            [ShaolinProgressHUD singleTextHud:error view:self.view afterDelay:TipSeconds];
//        }
    }];
}

#pragma mark - 收藏
- (void)foucsActionButton:(ZFTableViewCell *)cell IndexPath:(NSInteger)indexPath IndexPathRow:(NSIndexPath *)row
{
    if (self.player.playingIndexPath != row) {
        
    }else
    {
        ZFTableViewCellLayout *data = self.dataSource[indexPath];
        // 收藏
        [cell setCollectionBtnSelected:!cell.collectionBtn.selected];
        if (cell.collectionBtn.selected) { //收藏成功调用的
            [self foucsAction:data IndexPath:indexPath cell:cell];
        }else
        {
            
            //取消收藏
            NSString *strId = [NSString stringWithFormat:@"%@", data.data.id];
            NSMutableArray *arr = [NSMutableArray array];
            NSDictionary *dic = @{@"contentId":strId,@"type":self.typeStr, @"kind": @"2"};
            [arr addObject:dic];
            //                        [arr setValue:strId forKey:@"contentId"];
            //                        [arr setValue:self.typeStr forKey:@"type"];
            NSLog(@"%@",arr);
            
            [self cancleCollectionAction:arr Model:data IndexPath:indexPath cell:cell];
        }
    }
}
#pragma mark - 收藏成功
- (void)foucsAction:(ZFTableViewCellLayout *)layout IndexPath:(NSInteger)indexPath cell:(ZFTableViewCell *)cell
{
    
    NSString *contentId = [NSString stringWithFormat:@"%@",layout.data.id];
    NSLog(@"%@ --- %@",contentId,self.typeStr);
    
//    [[HomeManager sharedInstance]postCollectionContentId:contentId Type:self.typeStr Kind:@"2" MemberId:@"" MemberName:@"" Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSLog(@"%@",responseObject);
//        if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
//            layout.data.collection = [NSNumber numberWithInteger:2];
//            NSInteger likeCount = [layout.data.collections integerValue];
//            likeCount += 1;
//            
//            layout.data.collections = [NSNumber numberWithInteger:likeCount];
//            [self.dataSource setObject:layout atIndexedSubscript:indexPath];
//            [btn setSelected:YES];
//            [btn setTitle:[NSString stringWithFormat:@" %ld",likeCount] forState:(UIControlStateNormal)];
//            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"收藏成功") view:self.view afterDelay:TipSeconds];
//        }else
//        {
//            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"message"] view:self.view afterDelay:TipSeconds];
//        }
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:self.view afterDelay:TipSeconds];
//    }];
    
    
    [[HomeManager sharedInstance]postCollectionContentId:contentId Type:self.typeStr Kind:@"2" MemberId:@"" MemberName:@"" Success:^(NSDictionary * _Nullable resultDic) {
        layout.data.collectionState = [NSNumber numberWithInteger:1];
        NSInteger likeCount = [layout.data.collection integerValue];
        likeCount += 1;
        
        layout.data.collection = [NSNumber numberWithInteger:likeCount];
        [self.dataSource setObject:layout atIndexedSubscript:indexPath];
        [cell setCollectionBtnSelected:YES];
        cell.collectionLabel.text = [NSString stringWithFormat:@"%ld",likeCount];
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"收藏成功") view:self.view afterDelay:TipSeconds];
    } failure:^(NSString * _Nullable errorReason) {
        [ShaolinProgressHUD singleTextHud:errorReason view:self.view afterDelay:TipSeconds];
    } finish:^(NSDictionary * _Nullable responseObject, NSString * _Nullable errorReason) {
//        NSLog(@"%@",responseObject);
//               if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
//                   layout.data.collectionState = [NSNumber numberWithInteger:1];
//                   NSInteger likeCount = [layout.data.collection integerValue];
//                   likeCount += 1;
//
//                   layout.data.collection = [NSNumber numberWithInteger:likeCount];
//                   [self.dataSource setObject:layout atIndexedSubscript:indexPath];
//                   [cell setCollectionBtnSelected:YES];
//                   cell.collectionLabel.text = [NSString stringWithFormat:@"%ld",likeCount];
//                   [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"收藏成功") view:self.view afterDelay:TipSeconds];
//               }else
//               {
//                   [ShaolinProgressHUD singleTextHud:errorReason view:self.view afterDelay:TipSeconds];
//               }
    }];
    
}
#pragma mark - 取消收藏
- (void)cancleCollectionAction:(NSMutableArray *)arr Model:(ZFTableViewCellLayout *)layout IndexPath:(NSInteger)indexPath cell:(ZFTableViewCell *)cell
{
    NSLog(@"%@",arr);
    
    [[HomeManager sharedInstance]postCollectionCancleArray:arr WithBlock:^(id  _Nonnull responseObject, NSString * _Nonnull error) {
        layout.data.collectionState = [NSNumber numberWithInteger:0];
        NSInteger likeCount = [layout.data.collection integerValue];
        likeCount --;
        if (likeCount < 0) likeCount = 0;
        layout.data.collection = [NSNumber numberWithInteger:likeCount];
        [self.dataSource setObject:layout atIndexedSubscript:indexPath];
        [cell setCollectionBtnSelected:NO];
        cell.collectionLabel.text = [NSString stringWithFormat:@"%ld",likeCount];
        
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"取消收藏") view:self.view afterDelay:TipSeconds];
        NSLog(@"%@",responseObject);
//        if ([[responseObject objectForKey:@"code"] integerValue]== 200) {
//
//        }else
//        {
//            [ShaolinProgressHUD singleTextHud:error view:self.view afterDelay:TipSeconds];
//        }
    }];
}
#pragma mark - 分享
- (void)sharedSuccess:(ZFTableViewCell *)cell data:(ZFTableViewCellLayout *)layout IndexPath:(NSInteger)indexPath {
    WEAKSELF
    NSString *contentId = [NSString stringWithFormat:@"%@",layout.data.id];
//    [[HomeManager sharedInstance] postSharedContentId:contentId Type:self.typeStr Kind:@"2" MemberId:@"" MemberName:@"" Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSLog(@"%@",responseObject);
//        if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
//            NSInteger forwards = [layout.data.forwards integerValue];
//            forwards += 1;
//
//            layout.data.forwards = [NSString stringWithFormat:@"ld", forwards];
//            [weakSelf.dataSource setObject:layout atIndexedSubscript:indexPath];
//            [btn setTitle:[NSString stringWithFormat:@" %ld",forwards] forState:UIControlStateNormal];
//        }
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//
//    }];
    
    [[HomeManager sharedInstance]postSharedContentId:contentId Type:self.typeStr Kind:@"2" MemberId:@"" MemberName:@"" Success:^(NSDictionary * _Nullable resultDic) {
        NSInteger forwards = [layout.data.forward integerValue];
        forwards += 1;
        
        layout.data.forward = [NSString stringWithFormat:@"%ld", forwards];
        [weakSelf.dataSource setObject:layout atIndexedSubscript:indexPath];
        cell.shareLabel.text = [NSString stringWithFormat:@"%ld",forwards];
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable responseObject, NSString * _Nullable errorReason) {
        
//        if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
//
//        }
    }];
}

- (void)shareActionButton:(ZFTableViewCell *)cell IndexPath:(NSInteger)indexPath IndexPathRow:(NSIndexPath *)row {
    if (self.player.playingIndexPath != row) {
        NSLog(@"--------------------");
    }else
    {
        ZFTableViewCell *cell = [self.tableView cellForRowAtIndexPath:row];
        ZFTableViewCellLayout *data = self.dataSource[indexPath];
        NSLog(@"%@",data.data.id);

        SharedModel *model = [[SharedModel alloc] init];
        model.type = SharedModelURLType;//SharedModelVideoType;
        model.titleStr = data.data.author;
        model.descriptionStr = data.data.title;
        if ([self.tabbarStr isEqualToString:@"Found"]) {
            model.webpageURL = URL_H5_SharedVideo(self.videoId, @"1");//data.data.coverurl;
        } else {
            model.webpageURL = URL_H5_SharedVideo(self.videoId, @"2");//data.data.coverurl;
        }
        
        model.image = [cell getShowImage];//[SharedModel toThumbImage:[cell getShowImage]];
        if (data.data.coverUrl && data.data.coverUrl.length){
            model.imageURL = [NSString stringWithFormat:@"%@%@",data.data.coverUrl,Video_First_Photo];
        }
        WEAKSELF
        _slShareView = [[SLShareView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        _slShareView.model = model;
        _slShareView.shareFinish = ^{
            [weakSelf sharedSuccess:cell data:data IndexPath:indexPath];
        };
        [[UIApplication sharedApplication].keyWindow addSubview:_slShareView];
    }
}


#pragma mark - private method

/// play the video
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollAnimated:(BOOL)animated {
    
    ZFTableViewCellLayout *data = self.dataSource[indexPath.row];
//    [[HomeManager sharedInstance]postHistoryVideoContentId:data.data.id TypeStr:self.typeStr KindStr:@"" Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSLog(@"%@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        
//    }];
    
    [[HomeManager sharedInstance]postHistoryVideoContentId:data.data.id TypeStr:self.typeStr KindStr:@"" Success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable responseObject, NSString * _Nullable errorReason) {
        NSLog(@"%@",responseObject);
    }];
    
    ZFTableViewCellLayout *layout = self.dataSource[indexPath.row];
    if (animated) {
        [self.player playTheIndexPath:indexPath assetURL:[NSURL URLWithString:layout.data.coverUrl] scrollPosition:ZFPlayerScrollViewScrollPositionTop animated:YES];
    } else {
        [self.player playTheIndexPath:indexPath assetURL:[NSURL URLWithString:layout.data.coverUrl]];
    }
    
//    if (scrollToTop) {
//        /// 自定义滑动动画时间
//        [self.tableView zf_scrollToRowAtIndexPath:indexPath atScrollPosition:ZFPlayerScrollViewScrollPositionTop animateDuration:0.8 completionHandler:^{
//            [self.player playTheIndexPath:indexPath];
//        }];
//    } else {
//        [self.player playTheIndexPath:indexPath];
//    }
    [self.controlView showTitle:layout.data.title
                 coverURLString:[NSString stringWithFormat:@"%@%@",layout.data.coverUrl,Video_First_Photo]
               placeholderImage:[ZFUtilities imageWithColor:[UIColor clearColor] size:CGSizeMake(100, 100)]
                 fullScreenMode:ZFFullScreenModeLandscape];
}

#pragma mark - getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStylePlain];
        [_tableView registerClass:[ZFTableViewCell class] forCellReuseIdentifier:kIdentifier];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.pagingEnabled = YES;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.separatorStyle = NO;
        _tableView.backgroundColor = [UIColor blackColor];
        _tableView.separatorColor = [UIColor darkGrayColor];
        //        _tableView.contentSize = CGSizeMake(kWidth, kHeight + 60);
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        WEAKSELF
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf update];
          }];
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadMoreData];
        }];
        self.tableView.mj_footer.hidden = YES;
        /// 停止的时候找出最合适的播放
        @weakify(self)
        _tableView.zf_scrollViewDidEndScrollingCallback = ^(NSIndexPath * _Nonnull indexPath) {
            @strongify(self)
            if (!self.player.playingIndexPath) {
                [self playTheVideoAtIndexPath:indexPath scrollAnimated:NO];
            }
        };
        
        /// 明暗回调
        _tableView.zf_playerShouldPlayInScrollView = ^(NSIndexPath * _Nonnull indexPath) {
            @strongify(self)
            if ([indexPath compare:self.tableView.zf_shouldPlayIndexPath] != NSOrderedSame) {
                /// 显示黑色蒙版
                ZFTableViewCell *cell1 = [self.tableView cellForRowAtIndexPath:self.tableView.zf_shouldPlayIndexPath];
                cell1.praiseBtn.userInteractionEnabled = NO;
                cell1.shareBnt.userInteractionEnabled = NO;
                
                [cell1 showMaskView];
                /// 隐藏黑色蒙版
                ZFTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                cell.praiseBtn.userInteractionEnabled = YES;
                cell.shareBnt.userInteractionEnabled = YES;
                [cell hideMaskView];
            }
        };
    }
    return _tableView;
}

- (SLPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [SLPlayerControlView new];
        _controlView.fastViewAnimated = YES;
        _controlView.horizontalPanShowControlView = NO;
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
