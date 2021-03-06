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
#import "DefinedURLs.h"
#import "AppDelegate+AppService.h"
#import "ShaolinWindow.h"

@interface RecommendViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *foundArray;
@property(nonatomic,strong) NSMutableArray *topArray;
@property (nonatomic, copy) NSString *totalStr;
@property (nonatomic, assign) NSInteger pager;
@property(nonatomic,strong) LYEmptyView *emptyView;

@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@end

@implementation RecommendViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideNavigationBarShadow];
    self.player.viewControllerDisappear = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.player.viewControllerDisappear = YES;
    [self stopCurrentVideo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KTextGray_FA;
    /**
        置顶的cell高度  60
          广告的cell 高度 353
                最右侧单图文章 116
             多张图片 203
               单张长图  227
     */
    NSLog(@"==============");
    self.foundArray = [@[] mutableCopy];
    self.topArray = [@[] mutableCopy];
    [self update];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getSelectPageData:) name:@"ReloadCurrentPage" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerCellAction:) name:@"VideoPlayerAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemVolumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    
    WEAKSELF
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf update];
      }];
    MJRefreshAutoFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    footer.triggerAutomaticallyRefreshPercent = -20;
    self.tableView.mj_footer = footer;

    self.tableView.mj_footer.hidden = YES;
    
     [self.view addSubview:self.tableView];
     [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.mas_equalTo(10);
         make.left.mas_equalTo(15);
         make.right.mas_equalTo(-15);
         make.bottom.mas_equalTo(0);
//           make.edges.equalTo(self.view);
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
    emptyView.actionBtnBackGroundColor = UIColor.whiteColor;
    self.emptyView = emptyView;
}
- (void)getSelectPageData:(NSNotification *)user
{
//     [self.foundArray removeAllObjects];
    NSDictionary *dic = user.userInfo;
    NSLog(@"%@",dic);
    NSInteger identifier = [[dic objectForKey:@"identifier"] integerValue];
    if (self.identifier != identifier) return;
    [self update];
}
- (void)playerCellAction:(NSNotification *)user
{
    NSDictionary *dic = user.userInfo;
    NSIndexPath *indexpath = [dic objectForKey:@"indexPath"];
    NSString *identifier = [dic objectForKey:@"identifier"];
    if (identifier && [identifier intValue] != self.selectPage) return;
    FoundModel *model = self.foundArray[indexpath.row];
    if ([model.type isEqualToString:@"3"]) {
        // 是广告
        if ([model.kind isEqualToString:@"3"]){ //视频广告
            [self playTheVideoAtIndexPath:indexpath scrollAnimated:NO];
        } else {
            [[SLAppInfoModel sharedInstance] advertEventResponseWithFoundModel:model];
        }
    } else
    {
        FoundVideoListVc *vC = [[FoundVideoListVc alloc]init];
           vC.hidesBottomBarWhenPushed = YES;
           vC.hideNavigationBarView = YES;
           vC.fieldId = model.fieldId;
           vC.videoId = model.id;
           vC.tabbarStr = @"Found";
           vC.typeStr = @"1";
           [self.navigationController pushViewController:vC animated:YES];
    }
}

/// play the video
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollAnimated:(BOOL)animated {
    FoundModel *model = self.foundArray[indexPath.row];
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
//    [[HomeManager sharedInstance] getHomeListFieldld:fieldId PageNum:pageNum PageSize:pageSize Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        [hud hideAnimated:YES];
//        if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
//            NSArray *arr = [solveJsonData changeType:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
//            NSArray *foundModelArray = [FoundModel mj_objectArrayWithKeyValuesArray:arr];
//            [self.foundArray addObjectsFromArray:foundModelArray];
//            if (self.foundArray.count == 0){
//                self.tableView.ly_emptyView = self.emptyView;
//            }
//            [self.tableView reloadData];
//            [self.tableView layoutIfNeeded];
//            if (success) success(foundModelArray);
//        } else {
//            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"message"] view:self.view afterDelay:TipSeconds];
//        }
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        [hud hideAnimated:YES];
//        if (failure) failure(error);
//    }];
    
    [[HomeManager sharedInstance] getHomeListFieldld:fieldId PageNum:pageNum PageSize:pageSize Success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable responseObject, NSString * _Nullable errorReason) {
        [hud hideAnimated:YES];
        if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
            NSArray *arr = [solveJsonData changeType:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
            NSMutableArray *foundModelArray = [[FoundModel mj_objectArrayWithKeyValuesArray:arr] mutableCopy];
            if (self.foundArray.count == 0){
                for (FoundModel *model in foundModelArray) {
                    if ([model.cellIdentifier isEqualToString:NSStringFromClass([StickCell class])]){
                        [self.topArray addObject:model];
                    }
                }
                
                [foundModelArray removeObjectsInArray:self.topArray];
            }
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
    }];
    
}

- (void)update{
    self.pager = 1;
    [self.foundArray removeAllObjects];
    [self.topArray removeAllObjects];
    
    WEAKSELF
    [self requestData:^(NSArray *foundModelArray) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
//        CGFloat tableViewHeight = CGRectGetHeight(self.tableView.frame);
//        CGFloat y = CGRectGetMinY(self.tableView.mj_footer.frame);
//        if (y < tableViewHeight){
//            self.tableView.mj_footer.hidden = YES;
//        } else {
            weakSelf.tableView.mj_footer.hidden = foundModelArray.count == 0;
//        }
    } failure:^(NSError * _Nonnull error) {
        [weakSelf.tableView.mj_header endRefreshing];
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
    WEAKSELF
    @try {
        [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    } @catch (NSException *exception) {
        
    } @finally {
        [weakSelf.tableView.mj_header beginRefreshing];
    }
    
}

- (void)registerCell
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.topArray.count > 0) return 2;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.topArray.count > 0){
        if (section == 0) {
            return self.topArray.count;
        } else {
            return self.foundArray.count;
        }
    }
    return self.foundArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *currentArray = self.foundArray;
    if (indexPath.section == 0 && self.topArray.count > 0){
        currentArray = self.topArray;
    }
    FoundModel *model = currentArray[indexPath.row];
    AllTableViewCell *cell;
    NSString *cellIdentifier;
    cellIdentifier = model.cellIdentifier;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setFoundModel:model indexpath:indexPath];
    cell.identifier = [NSString stringWithFormat:@"%ld", self.selectPage];
    
    if (currentArray.count == 1){
        cell.cellPosition = CellPosition_OnlyOne;
    } else if (indexPath.row == 0){
        cell.cellPosition = CellPosition_Top;
    } else if (indexPath.row == currentArray.count - 1){
        cell.cellPosition = CellPosition_Bottom;
    } else {
        cell.cellPosition = CellPosition_Center;
    }
   
    NSMutableArray *typeNum = [NSMutableArray array];
    for (FoundModel *dic in self.topArray) {
        if ([dic.type isEqualToString:@"1"]) {
             [typeNum addObject:dic.type];
        }
    }
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
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(tintColor)]) {
        if (tableView == self.tableView) {
            // 圆角弧度半径
            CGFloat cornerRadius = 10.f;
            // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
            cell.backgroundColor = UIColor.clearColor;
            
            // 创建一个shapeLayer
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            CAShapeLayer *backgroundLayer = [[CAShapeLayer alloc] init]; //显示选中
            // 创建一个可变的图像Path句柄，该路径用于保存绘图信息
            CGMutablePathRef pathRef = CGPathCreateMutable();
            // 获取cell的size
            CGRect bounds = CGRectInset(cell.bounds, 0, 0);
            
            // CGRectGetMinY：返回对象顶点坐标
            // CGRectGetMaxY：返回对象底点坐标
            // CGRectGetMinX：返回对象左边缘坐标
            // CGRectGetMaxX：返回对象右边缘坐标
            
            // 这里要判断分组列表中的第一行，每组section的第一行，每组section的中间行
            BOOL addLine = NO;
            // CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
            if (indexPath.row == 0) {
                // 初始起点为cell的左下角坐标
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
                // 起始坐标为左下角，设为p1，（CGRectGetMinX(bounds), CGRectGetMinY(bounds)）为左上角的点，设为p1(x1,y1)，(CGRectGetMidX(bounds), CGRectGetMinY(bounds))为顶部中点的点，设为p2(x2,y2)。然后连接p1和p2为一条直线l1，连接初始点p到p1成一条直线l，则在两条直线相交处绘制弧度为r的圆角。
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                // 终点坐标为右下角坐标点，把绘图信息都放到路径中去,根据这些路径就构成了一块区域了
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
                addLine = YES;
            } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                // 初始起点为cell的左上角坐标
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                // 添加一条直线，终点坐标为右下角坐标点并放到路径中去
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            } else {
                // 添加cell的rectangle信息到path中（不包括圆角）
                CGPathAddRect(pathRef, nil, bounds);
                addLine = YES;
            }
            // 把已经绘制好的可变图像路径赋值给图层，然后图层根据这图像path进行图像渲染render
            layer.path = pathRef;
            backgroundLayer.path = pathRef;
            // 注意：但凡通过Quartz2D中带有creat/copy/retain方法创建出来的值都必须要释放
            CFRelease(pathRef);
            // 按照shape layer的path填充颜色，类似于渲染render
            // layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
            layer.fillColor = [UIColor whiteColor].CGColor;
            
            //置顶分组里不画分割线
            if (self.topArray.count && indexPath.section == 0){
                addLine = NO;
            }
            //TODO:绘制cell间的分隔线
            if (addLine == YES) {
                CALayer *lineLayer = [[CALayer alloc] init];
                CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
                lineLayer.frame = CGRectMake(10, bounds.size.height-lineHeight, bounds.size.width - 20, lineHeight);
                // 分隔线颜色取自于原来tableview的分隔线颜色
                lineLayer.backgroundColor = tableView.separatorColor.CGColor;
                [layer addSublayer:lineLayer];
            }
            
            // view大小与cell一致
            UIView *roundView = [[UIView alloc] initWithFrame:bounds];
            // 添加自定义圆角后的图层到roundView中
            [roundView.layer insertSublayer:layer atIndex:0];
            roundView.backgroundColor = UIColor.clearColor;
            //cell的背景view
            //cell.selectedBackgroundView = roundView;
            cell.backgroundView = roundView;
            
            //以上方法存在缺陷当点击cell时还是出现cell方形效果，因此还需要添加以下方法
            UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:bounds];
            backgroundLayer.fillColor = tableView.separatorColor.CGColor;
            [selectedBackgroundView.layer insertSublayer:backgroundLayer atIndex:0];
            selectedBackgroundView.backgroundColor = UIColor.clearColor;
            cell.selectedBackgroundView = selectedBackgroundView;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    FoundModel *model;
    if (indexPath.section == 0 && self.topArray.count > 0){
        model = self.topArray[indexPath.row];
    }
    if (!model) {
        model = self.foundArray[indexPath.row];
    }
    if ([model.type isEqualToString:@"3"]) {
        // 是广告
        [[SLAppInfoModel sharedInstance] advertEventResponseWithFoundModel:model];
    }else{
       if ([model.kind isEqualToString:@"3"]) {
           FoundVideoListVc *vC = [[FoundVideoListVc alloc]init];
           vC.hidesBottomBarWhenPushed = YES;
           vC.hideNavigationBarView = YES;
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
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    FoundModel *model;
//    if (indexPath.section == 0 && self.topArray.count > 0){
//        model = self.topArray[indexPath.row];
//    }
//    if (!model) {
//        model = self.foundArray[indexPath.row];
//    }
////
////    if ([model.cellIdentifier isEqualToString:@"MorePhotoCell"] || [model.cellIdentifier isEqualToString:@"PureTextTableViewCell"]) {
////
////    } else {
////        return model.cellHeight;
////    }
//    return tableView.rowHeight;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, SLChange(10))];
//    view.backgroundColor = UIColor.whiteColor;
//    return view;
//}

#pragma mark - Getters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.rowHeight = 227;
        
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = [UIColor clearColor];

      
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
        
        @weakify(self)
        _player.playerDidToEnd = ^(id  _Nonnull asset) {
            @strongify(self)
            BOOL isFullScreen = self.player.isFullScreen;
            [self.player stopCurrentPlayingCell];
            // 全屏状态下播放结束后，[self.player stopCurrentPlayingCell] 无法正确的结束播放状态
            if (isFullScreen){
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.player.orientationObserver.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    // 这里手动在结束播放一下
                    [self.player stop];
                    // 过短视频(如3秒)全屏播放结束后，应用主window没有被正确的显示在最上层，导致应用出现无法点击的假死状态
                    for (UIWindow *window in UIApplication.sharedApplication.windows){
                        if ([window isKindOfClass:[ShaolinWindow class]]) {
                            [window makeKeyAndVisible];
                        }
                    }
                });
            }
        };
        
        _player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
            @strongify(self)
            [AppDelegate shareAppDelegate].allowOrentitaionRotation = isFullScreen;
            
            //切全屏时播放声音，切回列表时静音
            playerManager.muted = !isFullScreen;
            NSString *title = @"";
            if (isFullScreen){
                FoundModel *model = self.foundArray[self.player.playingIndexPath.row];
                title = model.title;
            }
            [self.controlView.portraitControlView showTitle:title fullScreenMode:ZFFullScreenModeLandscape];
            [self.controlView.landScapeControlView showTitle:title fullScreenMode:ZFFullScreenModeLandscape];
        };
        _player.zf_playerDidAppearInScrollView = ^(NSIndexPath * _Nonnull indexPath) {
            @strongify(self)
            if (!self.player.playingIndexPath) {
                [self playTheVideoAtIndexPath:indexPath scrollAnimated:NO];
            }
        };
        /// 停止的时候找出最合适的播放(只能找到设置了tag值cell)
        _player.zf_scrollViewDidEndScrollingCallback = ^(NSIndexPath * _Nonnull indexPath) {
            @zf_strongify(self)
            if (!self.player.playingIndexPath) {
                [self playTheVideoAtIndexPath:indexPath scrollAnimated:NO];
            }
        };

        /// 滑动中找到适合的就自动播放
        /// 如果是停止后再寻找播放可以忽略这个回调
        /// 如果在滑动中就要寻找到播放的indexPath，并且开始播放，那就要这样写
        _player.zf_playerShouldPlayInScrollView = ^(NSIndexPath * _Nonnull indexPath) {
            @zf_strongify(self)
            if ([indexPath compare:self.player.playingIndexPath] != NSOrderedSame) {
                [self playTheVideoAtIndexPath:indexPath scrollAnimated:NO];
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
