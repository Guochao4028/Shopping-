
//
//  LookVideoViewController.m
//  Shaolin
//
//  Created by edz on 2020/4/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "LookVideoViewController.h"
#import "DyAVAssetExportSession.h"
#import "DyVideoCompression.h"
#import "HomeManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ZFPlayer.h"
#import "ZFAVPlayerManager.h"
#import "ZFIJKPlayerManager.h"
#import "KSMediaPlayerManager.h"
#import "ZFPlayerControlView.h"
#import "ZFUtilities.h"
#import "UIImageView+ZFCache.h"
#import "SLShareView.h"
#import "SLPlayerControlView.h"
#import "DefinedHost.h"

@interface LookVideoViewController ()
@property(nonatomic,strong) UIButton *backButton;
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UIImageView *containerView;
@property (nonatomic, strong) SLPlayerControlView *controlView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) NSArray <NSURL *>*assetURLs;

@property(nonatomic,strong) NSString *oneVideoUrl;
@property(nonatomic,strong) UIImageView *oneVideoImage;
@property(nonatomic,strong) UIButton *bgPlayBtn;
@property (nonatomic,strong) UIImageView *headerImage; //头像
@property (nonatomic,strong) UILabel *nameLabel;//姓名
@property (nonatomic,strong) UILabel *abstractsLabel;//简介
@property(nonatomic,strong) UIButton *praiseBtn; //点赞
@property(nonatomic,strong) UIButton *shareBnt;//分享
@property (nonatomic,strong) UIButton *collectionBtn;//收藏
@property (nonatomic,strong) NSString *collectionStr;
@property (nonatomic,strong) NSString *sharedStr;
@property (nonatomic,strong) NSString *praiseStr;
@property(nonatomic,strong) SLShareView *slShareView;
@end

@implementation LookVideoViewController
- (UIImageView *)oneVideoImage {
    if (!_oneVideoImage) {
        _oneVideoImage = [[UIImageView alloc]init];
        _oneVideoImage.userInteractionEnabled = YES;
        _oneVideoImage.contentMode = UIViewContentModeScaleAspectFill;
        _oneVideoImage.backgroundColor = [UIColor blackColor];
        
    }
    return _oneVideoImage;
}
- (UIButton *)bgPlayBtn {
    if (!_bgPlayBtn) {
        _bgPlayBtn = [[UIButton alloc]init];
        [_bgPlayBtn setImage:[UIImage imageNamed:@"new_allPlay_44x44_"] forState:(UIControlStateNormal)];
        [_bgPlayBtn addTarget:self action:@selector(palyerAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _bgPlayBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hideNavigationBar = YES;
    self.view.backgroundColor = [UIColor blackColor];
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, NavBar_Height, kWidth, 1)];
    viewLine.backgroundColor =RGBA(36, 36, 36, 1);
    [self.view addSubview:viewLine];
    self.backButton = [[UIButton alloc]initWithFrame:CGRectMake(SLChange(16), StatueBar_Height + 3, 30, 30)];
    
    [self.backButton setImage:[UIImage imageNamed:@"video_left"] forState:(UIControlStateNormal)];
    
    [self.backButton addTarget:self action:@selector(leftAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:self.containerView];
    
    [self.containerView addSubview:self.playBtn];
    [self.view addSubview:self.oneVideoImage];
    [self.oneVideoImage sd_setImageWithURL:[NSURL URLWithString:self.imgUrl]];
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:self.model.headurl] placeholderImage:[UIImage imageNamed:@"shaolinlogo"]];
    self.nameLabel.text = [NSString stringWithFormat:@"@%@",self.model.title];
    self.abstractsLabel.text = self.model.title;
    [self.view addSubview:self.headerImage];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.abstractsLabel];
    [self.oneVideoImage addSubview:self.bgPlayBtn];
    [self.view addSubview:self.shareBnt];
    [self.view addSubview:self.collectionBtn];
    [self.view addSubview:self.praiseBtn];
    [self.view addSubview:self.backButton];
    [self setUI];
    if ([self.model.state isEqualToString:@"6"]) {
        
    }else {
        self.shareBnt.hidden = YES;
        self.praiseBtn.hidden = YES;
        self.collectionBtn.hidden = YES;
    }
    
    [self getData];
}
- (void)getData {
//    [[HomeManager sharedInstance] getHomeVideoListFieldld:@"" TabbarStr:@"Found" VideoId:self.model.id PageNum:@"1" PageSize:@"30" Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        if ([[responseObject objectForKey:@"code"] integerValue]== 200) {
//            NSArray *arr = [[responseObject objectForKey:@"data"] objectForKey:@"data"];
//            NSString *collection;
//            NSString *praise;
//            
//            for (NSDictionary *dic in arr) {
//                praise =[NSString stringWithFormat:@"%@", [dic objectForKey:@"praise"]];
//                collection = [NSString stringWithFormat:@"%@",[dic objectForKey:@"collection"]];
//                self.collectionStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"collections"]];
//                self.praiseStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"praises"]];
//            }
//            if ([praise isEqualToString:@"1"]) {
//                [self.praiseBtn setSelected:NO];
//            }else {
//                [self.praiseBtn setSelected:YES];
//            }
//            if ([collection isEqualToString:@"1"]) {
//                [self.collectionBtn setSelected:NO];
//            }else {
//                [self.collectionBtn setSelected:YES];
//            }
//            [self.praiseBtn setTitle:self.praiseStr forState:(UIControlStateNormal)];
//            [self.collectionBtn setTitle:self.collectionStr forState:(UIControlStateNormal)];
//            
//            [self restyleButtons];
//        }
//        NSLog(@"%@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        
//    }];
    
    
    [[HomeManager sharedInstance]getHomeVideoListFieldld:@"" TabbarStr:@"Found" VideoId:self.model.id PageNum:@"1" PageSize:@"30" Success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable responseObject, NSString * _Nullable errorReason) {
        if ([[responseObject objectForKey:@"code"] integerValue]== 200) {
            NSArray *arr = [[responseObject objectForKey:@"data"] objectForKey:@"data"];
            NSString *collection;
            NSString *praise;
            
            for (NSDictionary *dic in arr) {
                praise =[NSString stringWithFormat:@"%@", [dic objectForKey:@"praise"]];
                collection = [NSString stringWithFormat:@"%@",[dic objectForKey:@"collection"]];
                self.collectionStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"collections"]];
                self.praiseStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"praises"]];
            }
            if ([praise isEqualToString:@"1"]) {
                [self.praiseBtn setSelected:NO];
            }else {
                [self.praiseBtn setSelected:YES];
            }
            if ([collection isEqualToString:@"1"]) {
                [self.collectionBtn setSelected:NO];
            }else {
                [self.collectionBtn setSelected:YES];
            }
            [self.praiseBtn setTitle:self.praiseStr forState:(UIControlStateNormal)];
            [self.collectionBtn setTitle:self.collectionStr forState:(UIControlStateNormal)];
            
            [self restyleButtons];
        }
        NSLog(@"%@",responseObject);
    }];
}
- (void)setUI {
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = kWidth;
    CGFloat min_view_h = kHeight;
    CGFloat margin = SLChange(10);
    CGFloat bottom = SLChange(40) + BottomMargin_X;
    
    min_x = SLChange(16);
    
    CGFloat abstractsW = min_view_w - min_x*2, abstractsH = SLChange(42.5);
    CGFloat buttonW = SLChange(40), buttonH = SLChange(50);
    CGFloat imageViewW = SLChange(43), imageViewH = SLChange(43);
    CGFloat nickNameW = abstractsW - imageViewH - min_x, nickNameH = SLChange(22.5);
    min_y = min_view_h - bottom - abstractsH;
    //TODO: 这里的布局是从下往上创建的
    //摘要
    self.abstractsLabel.frame = CGRectMake(min_x, min_y , abstractsW, abstractsH);
    
    min_y = min_y - nickNameH - margin;
    //昵称
    self.nameLabel.frame = CGRectMake(min_x, min_y, nickNameW, nickNameH);
    
    min_x = (min_view_w - margin - imageViewW + (imageViewW - buttonW)/2);
    min_y = min_y - buttonH/2;
    //分享
    self.shareBnt.frame = CGRectMake(min_x, min_y, buttonW, buttonH);
    
    min_y = min_y - buttonH - margin;
    //喜欢
    self.collectionBtn.frame = CGRectMake(min_x, min_y, buttonW, buttonH);
    
    min_y = min_y - buttonH - margin;
    //点赞
    self.praiseBtn.frame = CGRectMake(min_x, min_y, buttonW, buttonH);
    
    min_x = (min_view_w - margin - imageViewW);
    min_y = min_y - margin*3 - imageViewH;
    //头像
    self.headerImage.frame = CGRectMake(min_x, min_y, imageViewW, imageViewH);
    self.headerImage.layer.cornerRadius = imageViewH/2;
    
    min_w = SLChange(44);
    min_h = min_w;
    min_x = (min_view_w-min_w)/2;
    min_y = (min_view_h-min_h)/2;
    self.bgPlayBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.playBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.oneVideoImage.frame = self.view.bounds;
    [self restyleButtons];
}

- (void)restyleButtons{
    NSArray *restyleButtons = @[self.shareBnt, self.collectionBtn, self.praiseBtn];
    for (UIButton *button in restyleButtons){
        [self restyleButton:button];
    }
}

- (void)restyleButton:(UIButton *)button{
    CGFloat spacing = 5;
    CGSize imageSize = button.imageView.frame.size;
    CGSize titleSize = button.titleLabel.frame.size;
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:button.titleLabel.font forKey:NSFontAttributeName];
    CGSize textSize = [button.titleLabel.text sizeWithAttributes:attributes];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    
    CGFloat totalHeight = imageSize.height + titleSize.height;
    button.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height + spacing), 0.0, 0.0, - titleSize.width);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height + spacing), 0);
}

- (void)palyerAction:(UIButton *)button {
    //获取视频size
//    NSURL *mediaFileUrl;
//    NSString *defaultVideoPath = [NSString stringWithFormat:@"%@",self.videoStr];
//    NSLog(@"%@",defaultVideoPath);
//    mediaFileUrl = [NSURL URLWithString:defaultVideoPath];
    //获取视频尺寸
//    AVURLAsset  *asset = [AVURLAsset assetWithURL:mediaFileUrl];
//    NSArray *array = asset.tracks;
//    CGSize videoSize = CGSizeZero;
    
//    for (AVAssetTrack *track in array) {
//        if ([track.mediaType isEqualToString:AVMediaTypeVideo]) {
//            videoSize = track.naturalSize;
//        }
//    }
    [self creatZFPlayer];
    //    [self.controlView showTitle:@""
    //                    coverURLString:[NSString stringWithFormat:@"%@",self.videoStr]
    //                    fullScreenMode:videoSize.width<videoSize.height?ZFFullScreenModePortrait:ZFFullScreenModeLandscape];
    
}
- (void)creatZFPlayer {
    self.controlView.hidden = NO;
    self.oneVideoImage.hidden = YES;
    self.bgPlayBtn.hidden = YES;
    self.containerView.hidden = NO;
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    /// 播放器相关
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
    self.player.controlView = self.controlView;
    /// 设置退到后台继续播放
    self.player.pauseWhenAppResignActive = NO;
    
    @weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
    };
    
    /// 播放完成
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        [self.player.currentPlayerManager stop];
        //     [self.player playTheNext];
        self.oneVideoImage.hidden = NO;
        self.bgPlayBtn.hidden = NO;
        self.controlView.hidden = YES;
        self.containerView.hidden = YES;
        if (!self.player.isLastAssetURL) {
            NSString *title = [NSString stringWithFormat:@"%@",self.model.title];
            [self.controlView showTitle:title coverURLString:[NSString stringWithFormat:@"%@%@",self.videoStr,Video_First_Photo] fullScreenMode:ZFFullScreenModeLandscape];
        } else {
            [self.player stop];
        }
    };
    
    self.player.assetURL = [NSURL URLWithString:self.videoStr];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.player.viewControllerDisappear = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.player.viewControllerDisappear = YES;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat x = 0;
    CGFloat y = NavBar_Height+SLChange(81);
    CGFloat w = CGRectGetWidth(self.view.frame);
    CGFloat h = w*9/16;
    self.containerView.frame = self.view.bounds;
    
    w = 44;
    h = w;
    x = (CGRectGetWidth(self.containerView.frame)-w)/2;
    y = (CGRectGetHeight(self.containerView.frame)-h)/2;
    self.playBtn.frame = CGRectMake(x, y, w, h);
    
    
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

- (BOOL)shouldAutorotate {
    return self.player.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (SLPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [SLPlayerControlView new];
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
        [_containerView setImageWithURLString:[NSString stringWithFormat:@"%@%@",self.videoStr,Video_First_Photo] placeholder:[ZFUtilities imageWithColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1] size:CGSizeMake(1, 1)]];
        //        [_containerView setim];
        //        _containerView.backgroundColor = [UIColor clearColor];
    }
    return _containerView;
}
- (void)playClick:(UIButton *)sender {
    
    
    [self.player playTheIndex:0];
    //    [self.controlView showTitle:@"" coverImage:self.pushImage fullScreenMode:(ZFFullScreenModeLandscape)];
}
- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"new_allPlay_44x44_"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}
- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}
-(UIButton *)shareBnt
{
    if (!_shareBnt) {
        _shareBnt  =[[ UIButton alloc]init];
        [_shareBnt setTitle:@" " forState:(UIControlStateNormal)];
        [_shareBnt setImage:[UIImage imageNamed:@"video_share_normal"] forState:(UIControlStateNormal)];
        _shareBnt.titleLabel.font = kRegular(13);
        [_shareBnt setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
        [_shareBnt addTarget:self action:@selector(shareAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _shareBnt;
}
- (void)shareAction {
    
    NSMutableArray *imgArr = [NSMutableArray array];
    [imgArr addObject:[NSString stringWithFormat:@"%@",self.imgUrl]];
    
    SharedModel *model = [[SharedModel alloc] init];
    model.type = SharedModelType_URL;
    model.titleStr = self.model.title;
    model.descriptionStr = self.model.abstracts;
//    model.webpageURL = self.videoStr;
//    if ([self.tabbarStr isEqualToString:@"Found"]) {
        model.webpageURL = URL_H5_SharedVideo(self.model.id, @"1");//data.data.coverurl;
//    } else {
//        model.webpageURL = URL_H5_SharedVideo(self.model.id, @"2");//data.data.coverurl;
//    }
    model.image = self.oneVideoImage.image;//[SharedModel toThumbImage:self.oneVideoImage.image];
    if (imgArr.count){
        model.imageURL = imgArr.firstObject;
    }
    WEAKSELF
    _slShareView = [[SLShareView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    _slShareView.model = model;
    _slShareView.shareFinish = ^{
        [weakSelf sharedSuccess:weakSelf.shareBnt];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:_slShareView];
}
- (void)sharedSuccess:(UIButton *)btn {
    NSString *contentId = [NSString stringWithFormat:@"%@",self.model.id];
//    [[HomeManager sharedInstance]postPraiseContentId:contentId Type:@"1" Kind:@"2" MemberId:@"" MemberName:@"" Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSLog(@"%@",responseObject);
//        if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
//            
//            NSInteger sharedStrCount = [self.sharedStr integerValue];
//            sharedStrCount += 1;
//            self.sharedStr =[NSString stringWithFormat:@" %ld",sharedStrCount];
//            [btn setSelected:YES];
//            [btn setTitle:[NSString stringWithFormat:@" %ld",sharedStrCount] forState:(UIControlStateNormal)];
//        }
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        
//    }];
//    
    
    [[HomeManager sharedInstance]postPraiseContentId:contentId Type:@"1" Kind:@"2" MemberId:@"" MemberName:@"" Success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable responseObject, NSString * _Nullable errorReason) {
        NSLog(@"%@",responseObject);
             if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
                 
                 NSInteger sharedStrCount = [self.sharedStr integerValue];
                 sharedStrCount += 1;
                 self.sharedStr =[NSString stringWithFormat:@" %ld",sharedStrCount];
                 [btn setSelected:YES];
                 [btn setTitle:[NSString stringWithFormat:@" %ld",sharedStrCount] forState:(UIControlStateNormal)];
             }
    }];
}

-(UIButton *)praiseBtn
{
    if (!_praiseBtn) {
        _praiseBtn  =[[ UIButton alloc]init];
        
        [_praiseBtn setImage:[UIImage imageNamed:@"video_praise_normal"] forState:(UIControlStateNormal)];
        [_praiseBtn setImage:[UIImage imageNamed:@"praise_select_yellow"] forState:(UIControlStateSelected)];
        _praiseBtn.titleLabel.font = kRegular(13);
        [_praiseBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_praiseBtn addTarget:self action:@selector(praiseAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _praiseBtn;
}
#pragma mark - 点赞点击事件
- (void)praiseAction:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) { //点赞
        [self praiseSuccess:btn];
    }else {
        NSString *strId = [NSString stringWithFormat:@"%@", self.model.id];
        NSMutableArray *arr = [NSMutableArray array];
        NSDictionary *dic = @{@"contentId":strId,@"type":@"1"};
        [arr addObject:dic];
        [self canclePraiseAction:arr Button:btn];
    }
}

#pragma mark - 点赞成功
- (void)praiseSuccess:(UIButton *)btn {
    NSString *contentId = [NSString stringWithFormat:@"%@",self.model.id];
//    [[HomeManager sharedInstance]postPraiseContentId:contentId Type:@"1" Kind:@"2" MemberId:@"" MemberName:@"" Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSLog(@"%@",responseObject);
//        if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
//
//            NSInteger likeCount = [self.praiseStr integerValue];
//            likeCount += 1;
//            self.praiseStr =[NSString stringWithFormat:@" %ld",likeCount];
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
    [[HomeManager sharedInstance]postPraiseContentId:contentId Type:@"1" Kind:@"2" MemberId:@"" MemberName:@"" Success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable responseObject, NSString * _Nullable errorReason) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
            
            NSInteger likeCount = [self.praiseStr integerValue];
            likeCount += 1;
            self.praiseStr =[NSString stringWithFormat:@" %ld",likeCount];
            [btn setSelected:YES];
            [btn setTitle:[NSString stringWithFormat:@" %ld",likeCount] forState:(UIControlStateNormal)];
            
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"点赞成功") view:self.view afterDelay:TipSeconds];
        }else
        {
            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"message"] view:self.view afterDelay:TipSeconds];
        }
    }];
}
-(void)canclePraiseAction:(NSMutableArray *)arr Button:(UIButton *)btn {
    [[HomeManager sharedInstance]postPraiseCancleArray:arr WithBlock:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] integerValue]== 200) {
            NSInteger likeCount = [self.praiseStr integerValue];
            likeCount --;
            self.praiseStr =[NSString stringWithFormat:@" %ld",likeCount];
            [btn setSelected:NO];
            [btn setTitle:[NSString stringWithFormat:@" %ld",likeCount] forState:(UIControlStateNormal)];
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"取消点赞") view:self.view afterDelay:TipSeconds];
        }else
        {
            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"message"] view:self.view afterDelay:TipSeconds];
        }
    }];
}
-(UIButton *)collectionBtn
{
    if (!_collectionBtn) {
        _collectionBtn  =[[ UIButton alloc]init];
        [_collectionBtn setTitle:@" 10" forState:(UIControlStateNormal)];
        [_collectionBtn setImage:[UIImage imageNamed:@"video_focus_normal"] forState:(UIControlStateNormal)];
        [_collectionBtn setImage:[UIImage imageNamed:@"focus_select_yellow"] forState:(UIControlStateSelected)];
        _collectionBtn.titleLabel.font = kRegular(13);
        [_collectionBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_collectionBtn addTarget:self action:@selector(collectionAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _collectionBtn;
}
#pragma mark - 收藏点击事件
- (void)collectionAction:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) { //收藏
        [self collectionSuccess:btn];
    }else {
        //取消收藏
        NSString *strId = [NSString stringWithFormat:@"%@", self.model.id];
        NSMutableArray *arr = [NSMutableArray array];
        NSDictionary *dic = @{@"contentId":strId,@"type":@"1"};
        [arr addObject:dic];
        
        NSLog(@"%@",arr);
        [self cancleCollectionAction:arr button:btn];
    }
}
#pragma mark - 收藏成功
- (void)collectionSuccess:(UIButton *)btn {
    NSString *contentId = [NSString stringWithFormat:@"%@",self.model.id];
//    [[HomeManager sharedInstance]postCollectionContentId:contentId Type:@"1" Kind:@"2" MemberId:@"" MemberName:@"" Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSLog(@"%@",responseObject);
//        if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
//            
//            NSInteger likeCount = [self.collectionStr integerValue];
//            likeCount += 1;
//            self.collectionStr = [NSString stringWithFormat:@" %ld",likeCount];
//            [btn setSelected:YES];
//            [btn setTitle:[NSString stringWithFormat:@" %ld",likeCount] forState:(UIControlStateNormal)];
//            
//            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"收藏成功") view:self.view afterDelay:TipSeconds];
//        }else
//        {
//            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"message"] view:self.view afterDelay:TipSeconds];
//        }
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:self.view afterDelay:TipSeconds];
//    }];
//    
    [[HomeManager sharedInstance]postCollectionContentId:contentId Type:@"1" Kind:@"2" MemberId:@"" MemberName:@"" Success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable responseObject, NSString * _Nullable errorReason) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
            
            NSInteger likeCount = [self.collectionStr integerValue];
            likeCount += 1;
            self.collectionStr = [NSString stringWithFormat:@" %ld",likeCount];
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
-(void)cancleCollectionAction:(NSMutableArray *)arr button:(UIButton *)btn {
    [[HomeManager sharedInstance]postCollectionCancleArray:arr WithBlock:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] integerValue]== 200) {
            
            NSInteger likeCount = [self.collectionStr integerValue];
            likeCount --;
            self.collectionStr = [NSString stringWithFormat:@" %ld",likeCount];
            [btn setSelected:NO];
            [btn setTitle:[NSString stringWithFormat:@" %ld",likeCount] forState:(UIControlStateNormal)];
            
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"取消收藏") view:self.view afterDelay:TipSeconds];
        }else
        {
            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"message"] view:self.view afterDelay:TipSeconds];
        }
    }];
}
-(UIImageView *)headerImage {
    if (!_headerImage) {
        _headerImage = [[UIImageView alloc]init];
        _headerImage.clipsToBounds = YES;
        _headerImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headerImage;
}
-(UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = kMediumFont(16);
        _nameLabel.textColor = UIColor.whiteColor;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UILabel *)abstractsLabel{
    if (!_abstractsLabel) {
        _abstractsLabel = [[UILabelLeftTopAlign alloc] init];
        _abstractsLabel.textColor = UIColor.whiteColor;
        _abstractsLabel.font = kRegular(15);
    }
    return _abstractsLabel;
}

@end
