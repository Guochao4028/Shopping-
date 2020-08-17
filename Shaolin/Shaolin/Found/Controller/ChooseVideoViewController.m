//
//  ChooseVideoViewController.m
//  Shaolin
//
//  Created by edz on 2020/3/12.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ChooseVideoViewController.h"

#import <AVFoundation/AVFoundation.h>
#import "ChooseVideoCollectionCell.h"

#import "EditVideoViewController.h"
#import "ZFPlayer.h"
#import "ZFAVPlayerManager.h"
#import "ZFPlayerControlView.h"

#import <TZImageManager.h>
#import "ChooseVideoiCloudView.h"
#import "UIButton+HitBounds.h"


static NSString *kVideoCover = @"https://upload-images.jianshu.io/upload_images/635942-14593722fe3f0695.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240";

@interface ChooseVideoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UIImageView *containerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;

@property (nonatomic, strong) NSMutableArray * slAssetModelList;
@property (nonatomic, strong) SLAssetModel * currentAssetModel;
@property (nonatomic, strong) ChooseVideoiCloudView * iCloudView;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic,strong) UICollectionViewFlowLayout *layout;
// 选中cell的indexPath
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
// 取消选中的cell，防止由于重用，在取消选中的代理方法中没有设置
@property (nonatomic, strong) NSIndexPath *DeselectIndexpath;

@property(nonatomic,strong) UIImageView *topVideoImageV;
@property(nonatomic,strong) UIButton *topVideoPlayBtn;

@property(nonatomic) NSInteger videoMaxSize;//最大视频大小 MB

@end

@implementation ChooseVideoViewController

#pragma mark - life cycle

-(void)dealloc
{
//    [self.urlArr removeAllObjects];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.player.viewControllerDisappear = NO;
    self.navigationController.navigationBar.hidden = NO;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.player.viewControllerDisappear = YES;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = CGRectGetWidth(self.view.frame);
    CGFloat h = 300;
    self.containerView.frame = CGRectMake(x, y, w, h);
    
    w = 44;
    h = w;
    x = (CGRectGetWidth(self.containerView.frame)-w)/2;
    y = (CGRectGetHeight(self.containerView.frame)-h)/2;
//    self.playBtn.frame = CGRectMake(x, y, w, h);
    self.iCloudView.frame = CGRectMake(0, 0, kWidth, 300);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.videoMaxSize = 100;
    [self setUI];
    
    [self getVideoData];
}

- (void)setUI {
    
    self.titleLabe.text = SLLocalizedString(@"发视频");
    self.selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.rightBtn setTitle:SLLocalizedString(@"下一步") forState:(UIControlStateNormal)];
    [self.rightBtn setTitleColor:[UIColor colorForHex:@"333333"] forState:(UIControlStateNormal)];
    self.rightBtn.titleLabel.font = kRegular(14);
    [self.rightBtn addTarget:self action:@selector(rightAction) forControlEvents:(UIControlEventTouchUpInside)];
    self.rightBtn.frame = CGRectMake(0, 0, 50, 30);
    [self.view addSubview:self.collectionView];
    
    [self.view addSubview:self.containerView];
    
//    [self.containerView addSubview:self.playBtn];
    
    [self.view addSubview:self.topVideoImageV];
    [self.topVideoImageV addSubview:self.topVideoPlayBtn];
    
    [self.view addSubview:self.iCloudView];
        
    [self.topVideoImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(300);
        make.top.mas_equalTo(0);
    }];
    [self.topVideoPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.topVideoImageV);
        make.size.mas_equalTo(SLChange(29));
    }];
}

- (void)getVideoData {
    
    TZImagePickerConfig * config = [TZImagePickerConfig sharedInstance];
    config.allowPickingVideo = YES;
    config.allowPickingImage = NO;
    config.showSelectedIndex = NO;
    config.showPhotoCannotSelectLayer = YES;
    config.notScaleImage = YES;
    config.needFixComposition = NO;
    
    [TZImageManager manager].sortAscendingByModificationDate = NO;
    WEAKSELF
    [[TZImageManager manager] getCameraRollAlbum:YES allowPickingImage:YES needFetchAssets:YES completion:^(TZAlbumModel *model) {

        for (TZAssetModel * assetModel in model.models) {
            SLAssetModel * slModel = [SLAssetModel new];
            slModel.tzAssetModel = assetModel;
            
            [weakSelf.slAssetModelList addObject:slModel];
        }
        
        if (weakSelf.slAssetModelList.count) {
            weakSelf.currentAssetModel = weakSelf.slAssetModelList.firstObject;
            if (weakSelf.currentAssetModel.isICloudAsset) {
                weakSelf.iCloudView.hidden = NO;
                weakSelf.iCloudView.infoLabel.text = SLLocalizedString(@"视频存储在iCloud上，是否同步？");
            } else {
                weakSelf.iCloudView.hidden = YES;
                [weakSelf getVideoWithAsset:self.currentAssetModel.tzAssetModel.asset networkAccessAllowed:NO progressHandler:^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
                    ;
                } completion:^(AVAsset *asset, NSDictionary *info) {
                    weakSelf.currentAssetModel.videoAsset = asset;
                }];
            }
            NSInteger idx = [weakSelf.slAssetModelList indexOfObject:weakSelf.currentAssetModel];
            [weakSelf collectionView:weakSelf.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
        }
        
        [self.collectionView reloadData];
    }];
    
//    PHFetchOptions *options = [[PHFetchOptions alloc] init];
//    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
//
//    PHFetchResult * assetsFetchResultsTwo = [PHAsset fetchAssetsWithMediaType:(PHAssetMediaTypeVideo) options:options];
//
//    __block NSInteger assetsCount = assetsFetchResultsTwo.count;
//
//    if (assetsCount ==0) {
//        self.rightBtn.hidden = YES;
//
//        return;
//    }
//
//    [ShaolinProgressHUD defaultSingleLoadingWithText:SLLocalizedString(@"视频获取中")];
    
    
    // 这时 assetsFetchResults 中包含的，应该就是各个资源（PHAsset）
//    for (NSInteger i = 0; i < assetsCount; i++) {
        // 获取一个资源（PHAsset）
//        PHAsset *phAsset = assetsFetchResultsTwo[i];
        
//        if (phAsset.mediaType == PHAssetMediaTypeVideo) {
//            PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
//            options.version = PHVideoRequestOptionsVersionCurrent;
//            options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
//            options.networkAccessAllowed = YES;
//            PHImageManager *manager = [PHImageManager defaultManager];
////            Disk space is very low
//            [manager requestAVAssetForVideo:phAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
//
//                if (asset && [asset isKindOfClass:[AVURLAsset class]]) {
//                    NSLog(@"第%ld个asset获取成功", nil),i);
//                    AVURLAsset *urlAsset = (AVURLAsset *)asset;
//                    NSURL *url = urlAsset.URL;
//                    NSString *urlStr = [[url absoluteString] substringFromIndex:7];
//
//
//                    NSDictionary *dicc = [weakSelf getVideoInfoWithSourcePath:urlStr];
//                    UIImage *image =[weakSelf firstFrameWithVideoURL:url size:CGSizeMake(kWidth, kWidth)];
//                    NSString *timeStr = [dicc objectForKey:@"duration"];
//
//                    [weakSelf.timeArr insertObject:timeStr atIndex:0];
//                    [weakSelf.urlArr insertObject:urlStr atIndex:0];
//                    [weakSelf.imageArr insertObject:image atIndex:0];
//                    [weakSelf.dataArr insertObject:url atIndex:0];
//
//
//                    if (weakSelf.urlArr.count == assetsCount) {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [weakSelf.collectionView reloadData];
//                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//                            [weakSelf.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
//                            [weakSelf collectionView:weakSelf.collectionView didSelectItemAtIndexPath:indexPath];
//                            if (weakSelf.imageArr.count > 0) {
//                                weakSelf.topVideoImageV.image = weakSelf.imageArr[0];
//                            }
//                            if (weakSelf.urlArr.count > 0) {
//                                weakSelf.oneVideoUrl = [NSString stringWithFormat:@"%@",weakSelf.urlArr[0]];
//                            }
//                            [ShaolinProgressHUD hideSingleProgressHUD];
//                            self.noDataView.hidden = YES;
//                            self.rightBtn.hidden = NO;
//                        });
//                    }
//                } else {
//                    NSLog(@"第%ld个的asset为空", nil),i);
//                    assetsCount -= 1;
//                }
//            }];
//
//        }
//    }
}

#pragma mark - event
- (void)palyerAction:(UIButton *)button {
    [self creatZFPlayer];
}

- (void)creatZFPlayer {
    
    AVURLAsset *urlAsset = (AVURLAsset *)self.currentAssetModel.videoAsset;
    if (!urlAsset || ![urlAsset isKindOfClass:[AVURLAsset class]]) {
        [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"视频解析失败")];
        return;
    }
    
    self.controlView.hidden = NO;
    self.topVideoImageV.hidden = YES;
    self.topVideoPlayBtn.hidden = YES;
    self.containerView.hidden = NO;
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    /// 播放器相关
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
    self.player.controlView = self.controlView;
    /// 设置退到后台继续播放
    self.player.pauseWhenAppResignActive = NO;
    self.player.shouldAutoPlay = NO;
    @weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
    };
    
    /// 播放完成
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        [self playerEnd];
    };
    
    
    
    self.player.assetURL = [NSURL fileURLWithPath:[self getVideoAssetUrlString:urlAsset]];
}

- (void) playerEnd {
    [self.player.currentPlayerManager stop];
    self.topVideoImageV.hidden = NO;
    self.topVideoPlayBtn.hidden = NO;
    self.controlView.hidden = YES;
    self.containerView.hidden = YES;
    [self.player stop];
}

- (NSString *)getVideoAssetUrlString:(AVURLAsset *)asset {
    AVURLAsset *urlAsset = (AVURLAsset *)asset;
    NSURL *url = urlAsset.URL;
    NSString * urlStr = [[url absoluteString] substringFromIndex:7];
    return urlStr;
}

- (void)rightAction
{
    AVURLAsset *urlAsset = (AVURLAsset *)self.currentAssetModel.videoAsset;
    if (!urlAsset || ![urlAsset isKindOfClass:[AVURLAsset class]]) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"无效的视频，如果是iCloud视频，请同步后再继续") view:nil afterDelay:2.5];
        return;
    }
    //    self.player.playState = ZFPlayerStatePause;
//    NSLog(@"%@---%@",self.pushUrl,self.pushImage);
//    if (!self.pushUrl && !self.pushImage) {
//        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"视频不能为空") view:self.view afterDelay:TipSeconds];
//        return;
//    }
    NSUInteger size = 0;
    NSFileManager* manager = [NSFileManager defaultManager];
    NSString * fileStr = [self getVideoAssetUrlString:urlAsset];
    if ([manager fileExistsAtPath:fileStr]){
        size = [[manager attributesOfItemAtPath:fileStr error:nil] fileSize]/1000/1000;
    }
    if (size > self.videoMaxSize){
        [ShaolinProgressHUD singleTextAutoHideHud:[NSString stringWithFormat:SLLocalizedString(@"视频不能大于%ldMB"), self.videoMaxSize]];
        return;
    }
    EditVideoViewController *editVC = [[EditVideoViewController alloc] init];
    editVC.slAssetModel = self.currentAssetModel;
//    editVC.imageViewStr = self.currentAssetModel.videoImage;
//    editVC.assetUrlStr = fileStr;
//    editVC.urlArr = self.pushUrl;
    [self.navigationController pushViewController:editVC animated:YES];
}

#pragma mark - DZNEmptyDataSetDelegate && dataSource
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    if (self.slAssetModelList.count) {
        self.rightBtn.hidden = NO;
        self.topVideoImageV.hidden = NO;
        self.topVideoPlayBtn.hidden = NO;
        self.containerView.hidden = NO;
        self.collectionView.backgroundColor = UIColor.blackColor;
        return NO;
    }
    self.rightBtn.hidden = YES;
    self.topVideoImageV.hidden = YES;
    self.topVideoPlayBtn.hidden = YES;
    self.containerView.hidden = YES;
    self.collectionView.backgroundColor = UIColor.whiteColor;
    return YES;
}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -100;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = SLLocalizedString(@"暂无视频");
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName: [UIColor hexColor:@"999999"]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"categorize_nogoods"];
}

#pragma mark - collectionViewDelegate && dataSources

/// collectinView section header 在高版本存在系统BUG，需要设置zPosition = 0.0
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    view.layer.zPosition = 0.0;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.slAssetModelList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ChooseVideoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChooseVideoCollectionCell" forIndexPath:indexPath];

    SLAssetModel * assetModel = self.slAssetModelList[indexPath.row];
    cell.assetModel = assetModel;
    
    if ([self.selectIndexPath isEqual:indexPath]) {
        cell.selectView.hidden = NO;
        if (assetModel.videoImage) {
            self.topVideoImageV.image = assetModel.videoImage;
        }
    } else {
        cell.selectView.hidden = YES;
    }
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    WEAKSELF
    if ([self.selectIndexPath isEqual:indexPath]) {
        return;
    }
    
    [self playerEnd];
    
    self.selectIndexPath = indexPath;
    self.currentAssetModel = self.slAssetModelList[indexPath.row];
    
    if (self.currentAssetModel.isICloudAsset) {
        self.iCloudView.hidden = NO;
        self.iCloudView.infoLabel.text = SLLocalizedString(@"视频存储在iCloud上，是否同步？");
    } else {
        self.iCloudView.hidden = YES;
        [self getVideoWithAsset:self.currentAssetModel.tzAssetModel.asset networkAccessAllowed:NO progressHandler:^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
            ;
        } completion:^(AVAsset *asset, NSDictionary *info) {
            weakSelf.currentAssetModel.videoAsset = asset;
        }];
    }
    
    [self.collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.DeselectIndexpath = indexPath;
    ChooseVideoCollectionCell *cell = (ChooseVideoCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell == nil) { // 如果重用之后拿不到cell,就直接返回
        return;
    }
    cell.selectView.hidden = YES;
}


- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    ChooseVideoCollectionCell *chooseCell = (ChooseVideoCollectionCell *)cell;
    if (self.DeselectIndexpath && [self.DeselectIndexpath isEqual:indexPath]) {
        
        chooseCell.selectView.hidden = NO;
    }
    
    if ([self.selectIndexPath isEqual:indexPath]) {
        chooseCell.selectView.hidden = NO;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - device

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

- (BOOL)shouldAutorotate {
    return self.player.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - setter && getter
- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
        _controlView.autoHiddenTimeInterval = 5;
        _controlView.autoFadeTimeInterval = 0.5;
        _controlView.prepareShowLoading = YES;
        _controlView.prepareShowControlView = YES;
    }
    return _controlView;
}

- (UIImageView *)containerView {
    if (!_containerView) {
        _containerView = [UIImageView new];
        _containerView.backgroundColor = [UIColor blackColor];
    }
    return _containerView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 300, kWidth, kHeight - 300 -  NavBar_Height) collectionViewLayout:self.layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.emptyDataSetSource = self;
        _collectionView.emptyDataSetDelegate = self;
        _collectionView.backgroundColor = [UIColor blackColor];
        [_collectionView registerClass:[ChooseVideoCollectionCell class] forCellWithReuseIdentifier:@"ChooseVideoCollectionCell"];
    }
    return _collectionView;
}

-(UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        _layout = [UICollectionViewFlowLayout new];
        _layout.minimumLineSpacing = 1;
        _layout.minimumInteritemSpacing = 1;
        _layout.itemSize = CGSizeMake((kWidth-3)/4, (kWidth-3)/4);
        //            _layout.sectionInset = UIEdgeInsetsMake(0 ,0 , 45,0);
    }
    return _layout;
}

- (UIImageView *)topVideoImageV {
    if (!_topVideoImageV) {
        _topVideoImageV = [[UIImageView alloc]init];
        _topVideoImageV.userInteractionEnabled = YES;
        _topVideoImageV.contentMode = UIViewContentModeScaleAspectFit;
        _topVideoImageV.clipsToBounds = YES;
        _topVideoImageV.backgroundColor = [UIColor blackColor];
    }
    return _topVideoImageV;
}

- (UIButton *)topVideoPlayBtn {
    if (!_topVideoPlayBtn) {
        _topVideoPlayBtn = [[UIButton alloc]init];
        [_topVideoPlayBtn setImage:[UIImage imageNamed:@"found_video_play"] forState:(UIControlStateNormal)];
        [_topVideoPlayBtn addTarget:self action:@selector(palyerAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [_topVideoPlayBtn setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
    }
    return _topVideoPlayBtn;
}

-(ChooseVideoiCloudView *)iCloudView {
    WEAKSELF
    if (!_iCloudView) {
        _iCloudView = [[NSBundle mainBundle] loadNibNamed:@"ChooseVideoiCloudView" owner:self options:nil].firstObject;
        _iCloudView.frame = CGRectMake(0, 0, kWidth, 300);
        _iCloudView.hidden = YES;
        _iCloudView.downProgressView.hidden = YES;
        [_iCloudView setNeedsDisplay];
        
        _iCloudView.downloadBlock = ^{
            
            [weakSelf getVideoWithAsset:weakSelf.currentAssetModel.tzAssetModel.asset networkAccessAllowed:YES progressHandler:^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
                
                weakSelf.iCloudView.infoLabel.text = SLLocalizedString(@"正在与iCloud同步...");
                weakSelf.iCloudView.downBtn.hidden = YES;
                weakSelf.iCloudView.downProgressView.hidden = NO;
                weakSelf.iCloudView.downProgressView.progress = progress;
                
            } completion:^(AVAsset *asset, NSDictionary *info) {
                
                weakSelf.iCloudView.downBtn.hidden = NO;
                weakSelf.iCloudView.downProgressView.hidden = YES;
                weakSelf.iCloudView.downProgressView.progress = 0.0;
                weakSelf.iCloudView.hidden = YES;
                weakSelf.currentAssetModel.videoAsset = asset;
                weakSelf.currentAssetModel.isICloudAsset = NO;
            }];
        };
    }
    return _iCloudView;
}

-(NSMutableArray *)slAssetModelList {
    if (!_slAssetModelList) {
        _slAssetModelList = [NSMutableArray new];
    }
    return _slAssetModelList;
}

#pragma mark - getVideoWithAsset
- (void)getVideoWithAsset:(PHAsset *)asset networkAccessAllowed:(BOOL)networkAccessAllowed progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler completion:(void (^)(AVAsset *asset, NSDictionary *info))completion
{
    PHVideoRequestOptions *option = [[PHVideoRequestOptions alloc] init];
       option.networkAccessAllowed = networkAccessAllowed;
       option.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
           dispatch_async(dispatch_get_main_queue(), ^{
               if (progressHandler) {
                   progressHandler(progress, error, stop, info);
               }
           });
       };
    
   [[PHCachingImageManager defaultManager] requestAVAssetForVideo:asset options:option resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
       dispatch_async(dispatch_get_main_queue(), ^{
           if (completion) completion(asset,info);
       });
   }];
}

@end
