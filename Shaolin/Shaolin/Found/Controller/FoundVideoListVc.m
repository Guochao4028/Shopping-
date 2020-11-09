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
#import "KSMediaPlayerManager.h"
#import "ZFPlayerControlView.h"
#import "ZFTableViewCellLayout.h"
#import "ZFTableViewCell.h"
#import "ZFTableData.h"
#import "HomeManager.h"
#import "SLShareView.h"
#import "SLPlayerControlView.h"
#import "ZFUtilities.h"
#import "DefinedHost.h"

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
@end

@implementation FoundVideoListVc
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    @weakify(self)
    [self.tableView zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
        @strongify(self)
        [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.hideNavigationBar && !self.hideNavigationBarView){
        self.hideNavigationBar = YES;
    }
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.tableView];
    
    [self requestData];
    
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
        if (self.player.playingIndexPath.row < self.urls.count - 1) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.player.playingIndexPath.row+1 inSection:0];
//            [self playTheVideoAtIndexPath:indexPath scrollToTop:YES];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.player.playingIndexPath.row inSection:0];

            
            [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
            
            
        } else {
            [self.player stopCurrentPlayingCell];
        }
    };
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
        [UIViewController attemptRotationToDeviceOrientation];
        self.tableView.scrollsToTop = !isFullScreen;
    };
    
    
    
    self.backButton = [[UIButton alloc]initWithFrame:CGRectMake(16, StatueBar_Height + 3, 30, 30)];
    
    [self.backButton setImage:[UIImage imageNamed:@"video_left"] forState:(UIControlStateNormal)];

    [self.backButton addTarget:self action:@selector(leftAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.backButton];

}
-(void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestData {
    self.urls = @[].mutableCopy;
    self.dataSource = @[].mutableCopy;
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
//    [[HomeManager sharedInstance]getHomeVideoListFieldld:self.fieldId TabbarStr:self.tabbarStr VideoId:self.videoId PageNum:@"1" PageSize:@"30" Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        [hud hideAnimated:YES];
//        NSLog(@"%@",responseObject);
//        if ([[responseObject objectForKey:@"code"]integerValue]==200) {
//            NSArray *videoList = [[responseObject objectForKey:@"data"] objectForKey:@"data"];
//            for (NSDictionary *dataDic in videoList) {
//                if ([[dataDic allKeys] containsObject:@"coverurl"]) {
//                    ZFTableData *data = [[ZFTableData alloc] init];
//                    [data setValuesForKeysWithDictionary:dataDic];
//                    ZFTableViewCellLayout *layout = [[ZFTableViewCellLayout alloc] initWithData:data];
//                    [self.dataSource addObject:layout];
//                    NSString *URLString = [data.coverurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//                    NSURL *url = [NSURL URLWithString:URLString];
//                    [self.urls addObject:url];
//                    //                self.player.assetURLs = self.urls;
//                    [self.tableView reloadData];
//                }
//            }
//        }else {
//            
//        }
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        
//    }];
    
    
    [[HomeManager sharedInstance]getHomeVideoListFieldld:self.fieldId TabbarStr:self.tabbarStr VideoId:self.videoId PageNum:@"1" PageSize:@"30" Success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable responseObject, NSString * _Nullable errorReason) {
        [hud hideAnimated:YES];
        if ([[responseObject objectForKey:@"code"]integerValue]==200) {
            NSArray *videoList = [[responseObject objectForKey:@"data"] objectForKey:@"data"];
            for (NSDictionary *dataDic in videoList) {
                if ([[dataDic allKeys] containsObject:@"coverurl"]) {
                    ZFTableData *data = [[ZFTableData alloc] init];
                    [data setValuesForKeysWithDictionary:dataDic];
                    ZFTableViewCellLayout *layout = [[ZFTableViewCellLayout alloc] initWithData:data];
                    [self.dataSource addObject:layout];
                    NSString *URLString = [data.coverurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                    NSURL *url = [NSURL URLWithString:URLString];
                    [self.urls addObject:url];
                    //                self.player.assetURLs = self.urls;
                    [self.tableView reloadData];
                }
            }
        }else {
            
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
    
    [self playTheVideoAtIndexPath:indexPath scrollToTop:YES];
}
#pragma mark - 点赞
-(void)prasieActionButton:(UIButton *)btn IndexPath:(NSInteger)indexPath IndexPathRow:(NSIndexPath *)row
{
    //    /// 如果正在播放的index和当前点击的index不同
    if (self.player.playingIndexPath != row) {
        
    }else
    {
        ZFTableViewCellLayout *data = self.dataSource[indexPath];
        
        btn.selected = !btn.selected;
        if (btn.selected) { //点赞
            
            [self praiseAction:data IndexPath:indexPath button:btn];
            
        }else
        {
            
            NSString *strId = [NSString stringWithFormat:@"%@", data.data.id];
            NSMutableArray *arr = [NSMutableArray array];
            NSDictionary *dic = @{@"contentId":strId,@"type":self.typeStr};
            [arr addObject:dic];
            [self canclePraiseAction:arr Model:data IndexPath:indexPath button:btn];
        }
        
    }
}
#pragma mark - 点赞成功
-(void)praiseAction:(ZFTableViewCellLayout *)layout IndexPath:(NSInteger)indexPath button:(UIButton *)btn
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
               if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
                   
                   layout.data.praise = [NSNumber numberWithInteger:2];
                   NSInteger likeCount = [layout.data.praises integerValue];
                   likeCount += 1;
                   
                   layout.data.praises = [NSNumber numberWithInteger:likeCount];
                   [self.dataSource setObject:layout atIndexedSubscript:indexPath];
                   [btn setSelected:YES];
                   [btn setTitle:[NSString stringWithFormat:@" %ld",likeCount] forState:(UIControlStateNormal)];
                   
                   [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"点赞成功") view:self.view afterDelay:TipSeconds];
               }else
               {
                   [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"message"] view:self.view afterDelay:TipSeconds];
               }
    }];
}
#pragma mark - 取消点赞
-(void)canclePraiseAction:(NSMutableArray *)arr Model:(ZFTableViewCellLayout *)layout IndexPath:(NSInteger)indexPath button:(UIButton *)btn
{
    
    [[HomeManager sharedInstance]postPraiseCancleArray:arr WithBlock:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] integerValue]== 200) {
            layout.data.praise = [NSNumber numberWithInteger:1];
            NSInteger likeCount = [layout.data.praises integerValue];
            likeCount --;
            
            layout.data.praises = [NSNumber numberWithInteger:likeCount];
            [self.dataSource setObject:layout atIndexedSubscript:indexPath];
            [btn setSelected:NO];
            
            [btn setTitle:[NSString stringWithFormat:@" %ld",likeCount] forState:(UIControlStateNormal)];
            
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"取消点赞") view:self.view afterDelay:TipSeconds];
        }else
        {
            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"message"] view:self.view afterDelay:TipSeconds];
        }
    }];
}

#pragma mark - 收藏
-(void)foucsActionButton:(UIButton *)btn IndexPath:(NSInteger)indexPath IndexPathRow:(NSIndexPath *)row
{
    if (self.player.playingIndexPath != row) {
        
    }else
    {
        ZFTableViewCellLayout *data = self.dataSource[indexPath];
        // 收藏
        btn.selected = !btn.selected;
        if (btn.selected) { //收藏成功调用的
            [self foucsAction:data IndexPath:indexPath button:btn];
        }else
        {
            
            //取消收藏
            NSString *strId = [NSString stringWithFormat:@"%@", data.data.id];
            NSMutableArray *arr = [NSMutableArray array];
            NSDictionary *dic = @{@"contentId":strId,@"type":self.typeStr};
            [arr addObject:dic];
            //                        [arr setValue:strId forKey:@"contentId"];
            //                        [arr setValue:self.typeStr forKey:@"type"];
            NSLog(@"%@",arr);
            
            [self cancleCollectionAction:arr Model:data IndexPath:indexPath button:btn];
        }
    }
}
#pragma mark - 收藏成功
-(void)foucsAction:(ZFTableViewCellLayout *)layout IndexPath:(NSInteger)indexPath button:(UIButton *)btn
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
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable responseObject, NSString * _Nullable errorReason) {
        NSLog(@"%@",responseObject);
               if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
                   layout.data.collection = [NSNumber numberWithInteger:2];
                   NSInteger likeCount = [layout.data.collections integerValue];
                   likeCount += 1;
                   
                   layout.data.collections = [NSNumber numberWithInteger:likeCount];
                   [self.dataSource setObject:layout atIndexedSubscript:indexPath];
                   [btn setSelected:YES];
                   [btn setTitle:[NSString stringWithFormat:@" %ld",likeCount] forState:(UIControlStateNormal)];
                   [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"收藏成功") view:self.view afterDelay:TipSeconds];
               }else
               {
                   [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"message"] view:self.view afterDelay:TipSeconds];
               }
    }];
    
}
#pragma mark - 取消收藏
-(void)cancleCollectionAction:(NSMutableArray *)arr Model:(ZFTableViewCellLayout *)layout IndexPath:(NSInteger)indexPath button:(UIButton *)btn
{
    NSLog(@"%@",arr);
    
    [[HomeManager sharedInstance]postCollectionCancleArray:arr WithBlock:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] integerValue]== 200) {
            layout.data.collection = [NSNumber numberWithInteger:1];
            NSInteger likeCount = [layout.data.collections integerValue];
            likeCount --;
            
            layout.data.collections = [NSNumber numberWithInteger:likeCount];
            [self.dataSource setObject:layout atIndexedSubscript:indexPath];
            [btn setSelected:NO];
            
            [btn setTitle:[NSString stringWithFormat:@" %ld",likeCount] forState:(UIControlStateNormal)];
            
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"取消收藏") view:self.view afterDelay:TipSeconds];
        }else
        {
            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"message"] view:self.view afterDelay:TipSeconds];
        }
    }];
}
#pragma mark - 分享
-(void)sharedSuccess:(UIButton *)btn data:(ZFTableViewCellLayout *)layout IndexPath:(NSInteger)indexPath {
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
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable responseObject, NSString * _Nullable errorReason) {
        
        if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
            NSInteger forwards = [layout.data.forwards integerValue];
            forwards += 1;
            
            layout.data.forwards = [NSString stringWithFormat:@"ld", forwards];
            [weakSelf.dataSource setObject:layout atIndexedSubscript:indexPath];
            [btn setTitle:[NSString stringWithFormat:@" %ld",forwards] forState:UIControlStateNormal];
        }
    }];
}

-(void)shareActionButton:(UIButton *)btn IndexPath:(NSInteger)indexPath IndexPathRow:(NSIndexPath *)row {
    if (self.player.playingIndexPath != row) {
        NSLog(@"--------------------");
    }else
    {
        ZFTableViewCell *cell = [self.tableView cellForRowAtIndexPath:row];
        ZFTableViewCellLayout *data = self.dataSource[indexPath];
        NSLog(@"%@",data.data.id);
        NSMutableArray *imgArr = [NSMutableArray array];
        [imgArr addObject:[NSString stringWithFormat:@"%@%@",data.data.coverurl,Video_First_Photo]];
        
        SharedModel *model = [[SharedModel alloc] init];
        model.type = SharedModelType_URL;//SharedModelType_Video;
        model.titleStr = data.data.author;
        model.descriptionStr = data.data.title;
        if ([self.tabbarStr isEqualToString:@"Found"]) {
            model.webpageURL = URL_H5_SharedVideo(self.videoId, @"1");//data.data.coverurl;
        } else {
            model.webpageURL = URL_H5_SharedVideo(self.videoId, @"2");//data.data.coverurl;
        }
        model.image = [cell getShowImage];//[SharedModel toThumbImage:[cell getShowImage]];
        if (imgArr.count){
            model.imageURL = imgArr.firstObject;
        }
        WEAKSELF
        _slShareView = [[SLShareView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        _slShareView.model = model;
        _slShareView.shareFinish = ^{
            [weakSelf sharedSuccess:btn data:data IndexPath:indexPath];
        };
        [[UIApplication sharedApplication].keyWindow addSubview:_slShareView];
    }
}


#pragma mark - private method

/// play the video
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {
    
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
    
    if (scrollToTop) {
        /// 自定义滑动动画时间
        [self.tableView zf_scrollToRowAtIndexPath:indexPath animateWithDuration:0.8 completionHandler:^{
            [self.player playTheIndexPath:indexPath];
        }];
    } else {
        [self.player playTheIndexPath:indexPath];
    }
    ZFTableViewCellLayout *layout = self.dataSource[indexPath.row];
    [self.controlView showTitle:layout.data.title
                 coverURLString:[NSString stringWithFormat:@"%@%@",layout.data.coverurl,Video_First_Photo]
               placeholderImage:[ZFUtilities imageWithColor:[UIColor clearColor] size:CGSizeMake(100, 100)]
                 fullScreenMode:layout.isVerticalVideo?ZFFullScreenModePortrait:ZFFullScreenModeLandscape];
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
        /// 停止的时候找出最合适的播放
        @weakify(self)
        _tableView.zf_scrollViewDidStopScrollCallback = ^(NSIndexPath * _Nonnull indexPath) {
            @strongify(self)
            if (!self.player.playingIndexPath) {
                [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
            }
        };
        
        /// 明暗回调
        _tableView.zf_shouldPlayIndexPathCallback = ^(NSIndexPath * _Nonnull indexPath) {
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
