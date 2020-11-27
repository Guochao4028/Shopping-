//
//  EditVideoViewController.m
//  Shaolin
//
//  Created by edz on 2020/3/12.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "EditVideoViewController.h"
#import "DyAVAssetExportSession.h"
#import "DyVideoCompression.h"
#import "HomeManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ChooseVideoCollectionCell.h"
#import "ChooseVideoModel.h"
#import "EditVideoViewController.h"
#import "ZFPlayer.h"
#import "ZFAVPlayerManager.h"
#import "ZFIJKPlayerManager.h"
#import "KSMediaPlayerManager.h"
#import "ZFPlayerControlView.h"
#import "ZFUtilities.h"
#import "UIImageView+ZFCache.h"
#import "UITextView+Placeholder.h"

@interface EditVideoViewController ()<UITextViewDelegate>
@property(nonatomic,strong) UITextView *textField;
@property(nonatomic,strong) UITextView *introductionField;
//@property(nonatomic,strong) UIImageView *imageV;
@property(nonatomic,strong) UILabel *titleLabels;
@property(nonatomic,strong) UILabel *inLabel;
@property(nonatomic,strong) UIView *viewBg;
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UIImageView *containerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) NSArray <NSURL *>*assetURLs;

@property(nonatomic,strong) NSString *oneVideoUrl;
@property(nonatomic,strong) UIImageView *oneVideoImage;
@property(nonatomic,strong) UIButton *bgPlayBtn;
@property(nonatomic,strong) UIView *whiteView;

@property(nonatomic,strong) UILabel *titleTipsLabel;
@property(nonatomic,strong) UILabel *introductionTipsLabel;
@property(nonatomic) NSInteger titleTextMaxCount;//标题文最多字数
@property(nonatomic) NSInteger introductionTextMaxCount;//简介最多字数

@end

@implementation EditVideoViewController
- (UIImageView *)oneVideoImage {
    if (!_oneVideoImage) {
        _oneVideoImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 300)];
        _oneVideoImage.userInteractionEnabled = YES;
        _oneVideoImage.contentMode =UIViewContentModeScaleAspectFit;
        _oneVideoImage.backgroundColor = [UIColor blackColor];
        
    }
    return _oneVideoImage;
}
- (UIButton *)bgPlayBtn {
    if (!_bgPlayBtn) {
        _bgPlayBtn = [[UIButton alloc]init];
        [_bgPlayBtn setImage:[UIImage imageNamed:@"found_video_play"] forState:(UIControlStateNormal)];
        [_bgPlayBtn addTarget:self action:@selector(palyerAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _bgPlayBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleTextMaxCount = 40;
    self.introductionTextMaxCount = 60;
    
    self.titleLabe.text = SLLocalizedString(@"发视频");
    [self.view addSubview:self.containerView];
    self.view.backgroundColor = KTextGray_FA;
    [self.containerView addSubview:self.playBtn];
    self.oneVideoImage.image = self.slAssetModel.videoImage;
    [self.view addSubview:self.oneVideoImage];
    [self.oneVideoImage addSubview:self.bgPlayBtn];
    [self setUI];
    
    // 添加通知监听见键盘弹出/退出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillHideNotification object:nil];
    
//    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    [self.introductionField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    [self checkoutViewsFrame];
    //    self.imageV.image = _imageViewStr;
    
}
- (void)setUI {
    [self.bgPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.oneVideoImage);
        make.size.mas_equalTo(SLChange(29));
    }];
    UIView *whiteView  = [[UIView alloc]initWithFrame:CGRectMake(0, 301, kWidth, SLChange(92))];
    whiteView.backgroundColor = UIColor.whiteColor;
    whiteView.userInteractionEnabled = YES;
    self.whiteView =whiteView;
    [self.view addSubview:whiteView];
    self.titleLabels = [[UILabel alloc] initWithFrame:CGRectMake(SLChange(16), SLChange(15), SLChange(40), SLChange(30))];
    NSMutableAttributedString *missionAttributed = [[NSMutableAttributedString alloc]initWithString:SLLocalizedString(@"标题*")];
    [missionAttributed setAttributes:@{NSForegroundColorAttributeName:KTextGray_333} range:NSMakeRange(0, 2)];
    [missionAttributed addAttribute:NSFontAttributeName value:kRegular(15) range:NSMakeRange(0, 2)];
    
    [missionAttributed setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(2, 1)];
    [missionAttributed addAttribute:NSFontAttributeName value:kRegular(15) range:NSMakeRange(2, 1)];
    self.titleLabels.attributedText = missionAttributed;
    [whiteView addSubview:self.titleLabels];
    [whiteView addSubview:self.textField];
    
    
    self.viewBg = [[UIView alloc]initWithFrame:CGRectMake(SLChange(16), CGRectGetMaxY(self.titleLabels.frame) + SLChange(15), kWidth-SLChange(32), SLChange(1))];
    _viewBg.backgroundColor = RGBA(216, 216, 216, 1);
    [whiteView addSubview:self.viewBg];
    
    self.inLabel = [[UILabel alloc]initWithFrame:CGRectMake(SLChange(16), CGRectGetMaxY(self.viewBg.frame) + SLChange(14.5), SLChange(40), SLChange(25))];
//    self.inLabel.text = SLLocalizedString(@"简介");
    
    self.inLabel.textColor = KTextGray_333;
    self.inLabel.font = kRegular(15);
    self.inLabel.text = @"简介";
//    self.inLabel.textColor = KTextGray_333;
    [whiteView addSubview:self.inLabel];
    [whiteView addSubview:self.introductionField];
    
    [whiteView addSubview:self.titleTipsLabel];
    [whiteView addSubview:self.introductionTipsLabel];
    
    UIButton *pushBtn = [[UIButton alloc]initWithFrame:CGRectMake(SLChange(16), kHeight-TabBarButtom_H-SLChange(50)-SLChange(16)-NavBar_Height, kWidth-SLChange(32), SLChange(50))];
    [pushBtn setTitle:SLLocalizedString(@"发布") forState:(UIControlStateNormal)];
    [pushBtn setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
    pushBtn.titleLabel.font = kMediumFont(15);
    pushBtn.layer.masksToBounds = YES;
    pushBtn.layer.cornerRadius = SLChange(25);
    pushBtn.backgroundColor = kMainYellow;
    [pushBtn addTarget:self action:@selector(pushAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:pushBtn];
}
- (void)palyerAction:(UIButton *)button {
    [self.textField resignFirstResponder];
    [self creatZFPlayer];
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
            
        } else {
            [self.player stop];
        }
    };
    
    self.player.assetURL = [NSURL fileURLWithPath:[self getVideoAssetUrlString:self.urlAsset]];
}

- (NSString *)getVideoAssetUrlString:(AVURLAsset *)asset {
    AVURLAsset *urlAsset = (AVURLAsset *)asset;
    NSURL *url = urlAsset.URL;
    NSString * urlStr = [[url absoluteString] substringFromIndex:7];
    return urlStr;
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
    CGFloat y = 0;
    CGFloat w = CGRectGetWidth(self.view.frame);
    CGFloat h = 300;
    self.containerView.frame = CGRectMake(x, y, w, h);
    
    w = 44;
    h = w;
    x = (CGRectGetWidth(self.containerView.frame)-w)/2;
    y = (CGRectGetHeight(self.containerView.frame)-h)/2;
    self.playBtn.frame = CGRectMake(x, y, w, h);
}

- (void)leftAction {
    
    WEAKSELF
    if (self.textField.text.length == 0 && self.introductionField.text.length == 0) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:SLLocalizedString(@"是否退出编辑")
                                                                       message:@""
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"退出编辑")
                                                                style:UIAlertActionStyleDestructive
                                                              handler:^(UIAlertAction * _Nonnull action) {
            // 点击按钮，调用此block
            NSLog(@"确定按钮被按下");
            
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }];
        [alert addAction:defaultAction];
//        UIAlertAction *moreAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"不保存")
//                                                             style:UIAlertActionStyleDefault
//                                                           handler:^(UIAlertAction * _Nonnull action) {
//            // 点击按钮，调用此block
//            [weakSelf.navigationController popViewControllerAnimated:YES];
//        }];
//        [alert addAction:moreAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"取消")
                                                               style:UIAlertActionStyleCancel
                                                             handler:nil];
        [alert addAction:cancelAction];
        [weakSelf presentViewController:alert animated:YES completion:nil];
    }
    
}
#pragma mark - 保存草稿
- (void)saveAction {
    if (self.textField.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请填写标题") view:self.view afterDelay:TipSeconds];
        return;
    }
//    if (self.introductionField.text.length == 0) {
//        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请填写简介") view:self.view afterDelay:TipSeconds];
//        return;
//    }
    //敏感词校验由服务器进行
    [self videoPush:SLLocalizedString(@"草稿")];
}
#pragma mark - 发布视频步骤1
-(void)pushAction
{
    WEAKSELF
    if (self.textField.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请填写标题") view:self.view afterDelay:TipSeconds];
        return;
    }
//    if (self.introductionField.text.length == 0) {
//        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请填写简介") view:self.view afterDelay:TipSeconds];
//        return;
//    }
//    NSString *allStr = [NSString stringWithFormat:@"%@%@",self.textField.text,self.introductionField.text];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:SLLocalizedString(@"提示")
                                                                   message:SLLocalizedString(@"是否发布视频？")
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"确定发布") style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction * action) {
        //敏感词校验由服务器进行
        if ([weakSelf.urlAsset.URL.absoluteString containsString:@".medium."]) {
            // icloud的视频，不能压缩
            [ShaolinProgressHUD defaultSingleLoadingWithText:SLLocalizedString(@"正在上传视频")];
            [weakSelf updatePushVideo:@"" Identifier:SLLocalizedString(@"发布")];
        } else {
            [weakSelf videoPush:SLLocalizedString(@"发布")];
        }
    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"取消") style:UIAlertActionStyleDefault
                                                         handler:nil];
    
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [weakSelf presentViewController:alert animated:YES completion:nil];
    
}
#pragma mark - 发布视频步骤2--压缩视频
-(void)videoPush:(NSString *)identifier
{
    [ShaolinProgressHUD defaultSingleLoadingWithText:SLLocalizedString(@"正在上传视频")];
    NSString *outPutPath;
    // 设置导出文件的存放路径
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    NSDate    *date = [[NSDate alloc] init];
    outPutPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"output-%@.mp4",[formatter stringFromDate:date]]];
    DyVideoCompression *compression = [[DyVideoCompression alloc]init]; // 创建对象
    
    compression.inputURL = self.urlAsset.URL ; // 视频输入路径
    compression.exportURL = [NSURL fileURLWithPath:outPutPath]; // 视频输出路径
    DYAudioConfigurations audioConfigurations;// 音频压缩配置
    audioConfigurations.samplerate = DYAudioSampleRate_11025Hz; // 采样率
    audioConfigurations.bitrate = DYAudioBitRate_32Kbps;// 音频的码率
    audioConfigurations.numOfChannels = 1;// 声道数
    audioConfigurations.frameSize = 8; // 采样深度
    compression.audioConfigurations = audioConfigurations;
    
    DYVideoConfigurations videoConfigurations;
    
    videoConfigurations.fps = 30; // 帧率 一秒中有多少帧
    videoConfigurations.videoBitRate = DY_VIDEO_BITRATE_SUPER; // 视频质量 码率
    videoConfigurations.videoResolution =  DY_VIDEO_RESOLUTION_SUPER; //视频尺寸
    
    compression.videoConfigurations = videoConfigurations;
    
    [compression startCompressionWithCompletionHandler:^(DYVideoCompressionState State) {
        if (State == DY_VIDEO_STATE_FAILURE) {
            NSLog(@"压缩失败");
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"压缩视频失败") view:self.view afterDelay:TipSeconds];
        }else
        {
            NSLog(@"压缩成功");
            //                       AVAsset *newAsset = [AVAsset assetWithURL:compression.exportURL];
            //                          NSArray *tracks = [newAsset tracksWithMediaType:AVMediaTypeVideo];
            //                          AVAssetTrack *newVideoTrack = tracks[0];
            //                          CGSize videoSize = CGSizeApplyAffineTransform(newVideoTrack.naturalSize, newVideoTrack.preferredTransform);
            //                          videoSize = CGSizeMake(fabs(videoSize.width), fabs(videoSize.height));
            //                          NSLog(@"宽%f --- 高%f",videoSize.width,videoSize.height);
            
            __weak typeof(self) weakSelf = self;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *newUrl = [NSString stringWithFormat:@"%@",[compression.exportURL path]];
                
                [weakSelf updatePushVideo:newUrl Identifier:identifier];
            });
        }
    }];
    //    }
    
}

#pragma mark - 发布视频步骤3 -- 上传相关信息
-(void)updatePushVideo:(NSString *)urlStr Identifier:(NSString *)identifier
{
    NSData *data ;
    if (urlStr.length == 0) {
//        AVURLAsset * asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:self.assetUrlStr]];
        data = [NSData dataWithContentsOfURL:self.urlAsset.URL];
    } else {
        data = [[NSData alloc] initWithContentsOfFile:urlStr];
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    
//    [[HomeManager sharedInstance] postSubmitPhotoWithFileData:data isVedio:YES Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSLog(@"%@",responseObject);
//        NSDictionary *dic = responseObject;
//        if ([[dic objectForKey:@"code"] integerValue]== 200) {
//            NSMutableDictionary *dicc= [NSMutableDictionary dictionary];
//            [dicc setValue:@"1" forKey:@"type"];
//            [dicc setValue:@"3" forKey:@"kind"];
//            [dicc setValue:[dic objectForKey:@"data"] forKey:@"route"];
//            [arr addObject:dicc];
//            NSString *stateStr;
//            if ([identifier isEqualToString:SLLocalizedString(@"发布")]) {
//                stateStr = @"2";
//            }else{
//                stateStr = @"1";
//            }
//            [self postTextAndPhoto:self.textField.text Introduction:self.introductionField.text Source:SLLocalizedString(@"原创") Author:@"" Content:@"" Type:@"3" State:stateStr CreateId:@"" CreateName:@"" CreateType:@"2" CoverUrlPlist:arr];
//            //            [self postTextAndPhoto:self.textField.text Source:SLLocalizedString(@"原创") Author:self.introductionField.text Content:@"" Type:@"3" State:@"2" CreateId:@"" CreateName:@"" CreateType:@"2" CoverUrlPlist:arr];
//        }else
//        {
//            [ShaolinProgressHUD hideSingleProgressHUD];
//        }
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//        [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:self.view afterDelay:TipSeconds];
//    }];
//
    
    [[HomeManager sharedInstance]postSubmitPhotoWithFileData:data isVedio:YES Success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable responseObject, NSString * _Nullable errorReason) {
     
      NSDictionary *dic = responseObject;
      if ([[dic objectForKey:@"code"] integerValue]== 200) {
          NSMutableDictionary *dicc= [NSMutableDictionary dictionary];
          [dicc setValue:@"1" forKey:@"type"];
          [dicc setValue:@"3" forKey:@"kind"];
          [dicc setValue:[dic objectForKey:@"data"] forKey:@"route"];
          [arr addObject:dicc];
          NSString *stateStr;
          if ([identifier isEqualToString:SLLocalizedString(@"发布")]) {
              stateStr = @"2";
          }else{
              stateStr = @"1";
          }
          [self postTextAndPhoto:self.textField.text Introduction:self.introductionField.text Source:SLLocalizedString(@"原创") Author:@"" Content:@"" Type:@"3" State:stateStr CreateId:@"" CreateName:@"" CreateType:@"2" CoverUrlPlist:arr];
          //            [self postTextAndPhoto:self.textField.text Source:SLLocalizedString(@"原创") Author:self.introductionField.text Content:@"" Type:@"3" State:@"2" CreateId:@"" CreateName:@"" CreateType:@"2" CoverUrlPlist:arr];
      }else
      {
          [ShaolinProgressHUD hideSingleProgressHUD];
      }
        
    }];
}
-(void)postTextAndPhoto:(NSString *)title Introduction:(NSString *)introductionStr Source:(NSString *)source Author:(NSString *)author Content:(NSString *)content Type:(NSString *)type State:(NSString *)state CreateId:(NSString *)createId CreateName:(NSString *)name CreateType:(NSString *)createType CoverUrlPlist:(NSMutableArray *)plistArr
{
    NSString *alertStr ;
    if ([state isEqualToString:@"1"]) {
        alertStr = NSLocalizedString(@"草稿保存成功,请去我的草稿箱中查看!", nil);
    }else {
        alertStr = SLLocalizedString(@"已提交审核");
    }
    [[HomeManager sharedInstance]postTextAndPhotoWithTitle:title Introduction:introductionStr Source:source Author:author Content:content Type:type State:state CreateId:createId CreateName:name CreateType:createType CoverUrlPlist:plistArr WithBlock:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
        NSLog(@"%@",responseObject);
        [ShaolinProgressHUD hideSingleProgressHUD];
        if ([[responseObject objectForKey:@"code"]integerValue]==200) {
            [ShaolinProgressHUD singleTextHud:alertStr view:self.view afterDelay:TipSeconds];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
            
        }else
        {
            [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:self.view afterDelay:TipSeconds];
        }
        NSLog(@"%@",error);
    }];
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
        //        [_containerView setim];
        _containerView.backgroundColor = [UIColor clearColor];
    }
    return _containerView;
}
- (void)playClick:(UIButton *)sender {
    
    self.controlView.coverImageView.image = self.slAssetModel.videoImage;
    self.controlView.bgImgView.image = self.slAssetModel.videoImage;
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
-(UITextView *)textField
{
    if (!_textField) {
        _textField = [[UITextView alloc] initWithFrame:CGRectMake(SLChange(75), CGRectGetMinY(self.titleLabels.frame) - SLChange(3), kWidth - SLChange(85), SLChange(37))];
        
        [_textField setTextColor:[UIColor blackColor]];
        _textField.font = kRegular(15);
        _textField.textColor = KTextGray_333;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate = self;
        _textField.keyboardType = UIKeyboardTypeDefault;
        [_textField setPlaceholder:SLLocalizedString(@"给视频起个名字吧") placeholdColor:KTextGray_999];
        _textField.scrollEnabled = NO;
    }
    return _textField;
}
-(UITextView *)introductionField
{
    if (!_introductionField) {
        _introductionField = [[UITextView alloc] initWithFrame:CGRectMake(SLChange(75), CGRectGetMinY(self.inLabel.frame)+SLChange(5), kWidth - SLChange(85), SLChange(37))];
        
        [_introductionField setTextColor:[UIColor blackColor]];
        _introductionField.font = kRegular(15);
        [_introductionField setPlaceholder:SLLocalizedString(@"简单介绍下视频吧") placeholdColor:KTextGray_999];
        
        _introductionField.textColor = KTextGray_333;
        _introductionField.returnKeyType = UIReturnKeyDone;
        _introductionField.delegate = self;
        _introductionField.keyboardType = UIKeyboardTypeDefault;
        _introductionField.scrollEnabled = NO;
        
    }
    return _introductionField;
}

- (UILabel *)titleTipsLabel {
    if (!_titleTipsLabel) {
        _titleTipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.textField.frame) + SLChange(3), 0, kWidth - SLChange(32), 0)];
        _titleTipsLabel.font = kRegular(13);
        _titleTipsLabel.textColor = KTextGray_999;
        _titleTipsLabel.text = @"";;//[NSString stringWithFormat:SLLocalizedString(@"标题字数不可超过%ld个字"), self.titleTextMaxCount];
        _titleTipsLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleTipsLabel;
}

- (UILabel *)introductionTipsLabel {
    if (!_introductionTipsLabel) {
        _introductionTipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.introductionField.frame) + SLChange(3), 0, kWidth - SLChange(32), 0)];
        _introductionTipsLabel.font = kRegular(13);
        _introductionTipsLabel.textColor = KTextGray_999;
        _introductionTipsLabel.text = @"";//[NSString stringWithFormat:SLLocalizedString(@"(最多输入%ld字)"), self.introductionTextMaxCount];
        _introductionTipsLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _introductionTipsLabel;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
    [self.introductionField resignFirstResponder];
}
// 点击键盘Return键取消第一响应者
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField resignFirstResponder];
    [self.introductionField resignFirstResponder];
    return  YES;
}

#pragma mark - textViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
   [self changeTipsLabel:textView];
    NSInteger textMaxCount = 1e6;
    UILabel *label;
    if (textView == self.textField) {
        textMaxCount = self.titleTextMaxCount;
        label = self.titleLabels;
    } else if (textView == self.introductionField) {
        textMaxCount = self.introductionTextMaxCount;
        label = self.inLabel;
    }
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    if (!position) {
        NSString *toBeString = textView.text;
        __block NSInteger count = 0;//toBeString.length;
        __block NSInteger realMaxCount = 0;
        [toBeString enumerateSubstringsInRange:NSMakeRange(0, toBeString.length)
                                       options:NSStringEnumerationByComposedCharacterSequences
                                    usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
            count++;
            if (count <= textMaxCount){
                realMaxCount += substring.length;
            }
        }];
        if (count > textMaxCount) {
            NSString *content = [toBeString substringToIndex:realMaxCount];// [self string:toBeString subStrWithUtf8Len:40];
            textView.text = content;
            [textView resignFirstResponder];
        }
    }
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGFloat height = [textView sizeThatFits:constraintSize].height;// [self heightForTextView:textView withText:textView.text];
    frame.origin.y = CGRectGetMinY(label.frame) - SLChange(4);
    frame.size.height = height;
    textView.frame = frame;
    [self checkoutViewsFrame];
}

- (void)changeTipsLabel:(UITextView *)textView{
    UILabel *tipsLabel;
    NSInteger textMaxCount = 0;
    __block NSInteger textCount = 0;
    [textView.text enumerateSubstringsInRange:NSMakeRange(0, textView.text.length)
                                   options:NSStringEnumerationByComposedCharacterSequences
                                usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
        textCount++;
    }];
    if (textView == self.textField){
        textMaxCount = self.titleTextMaxCount;
        if (textCount > textMaxCount){
            self.titleTipsLabel.text = [NSString stringWithFormat:SLLocalizedString(@"标题字数不可超过%ld个字"), textMaxCount];
            self.titleTipsLabel.textColor = kMainYellow;
        } else {
            self.titleTipsLabel.text = @"";
        }
        tipsLabel = self.titleTipsLabel;
    } else if (textView == self.introductionField){
        textMaxCount = self.introductionTextMaxCount;
        if (textCount > textMaxCount){
            self.introductionTipsLabel.text = [NSString stringWithFormat:SLLocalizedString(@"简介字数不可超过%ld个字"), textMaxCount];
            self.introductionTipsLabel.textColor = kMainYellow;
        } else {
            self.introductionTipsLabel.text = @"";
        }
        tipsLabel = self.introductionTipsLabel;
    }
    CGRect frame = tipsLabel.frame;
    if (tipsLabel.text.length == 0) {
        frame.size.height = 0;
    } else {
        frame.size.height = SLChange(18);
    }
    tipsLabel.frame = frame;
}

- (CGFloat)heightForTextView:(UITextView *)textView withText:(NSString *)strText{
    CGSize constraint = CGSizeMake(textView.contentSize.width , CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                             options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                          attributes:@{NSFontAttributeName: textView.font}
                                             context:nil];
    float textHeight = size.size.height + 10;
    return textHeight;
}

- (void)checkoutViewsFrame{

//    self.titleLabels;
//    self.textField;
    
    CGFloat titleTipsLabelOffset = CGRectGetHeight(self.titleTipsLabel.frame) == 0 ? 0 : SLChange(7.5);
    self.titleTipsLabel.frame = CGRectMake(CGRectGetMinX(self.titleTipsLabel.frame),
                                           CGRectGetMaxY(self.textField.frame) + titleTipsLabelOffset,
                                           CGRectGetWidth(self.titleTipsLabel.frame),
                                           CGRectGetHeight(self.titleTipsLabel.frame));//标题提示
    
    self.viewBg.frame = CGRectMake(CGRectGetMinX(self.viewBg.frame),
                                   CGRectGetMaxY(self.titleTipsLabel.frame) + SLChange(15),
                                   CGRectGetWidth(self.viewBg.frame),
                                   CGRectGetHeight(self.viewBg.frame));
    
    self.inLabel.frame = CGRectMake(CGRectGetMinX(self.inLabel.frame),
                                    CGRectGetMaxY(self.viewBg.frame) + SLChange(14.5),
                                    CGRectGetWidth(self.inLabel.frame),
                                    CGRectGetHeight(self.inLabel.frame));
    
    self.introductionField.frame = CGRectMake(CGRectGetMinX(self.introductionField.frame),
                                              CGRectGetMinY(self.inLabel.frame) - SLChange(5),
                                              CGRectGetWidth(self.introductionField.frame),
                                              CGRectGetHeight(self.introductionField.frame));
    
    CGFloat introductionTipsLabelOffset = CGRectGetHeight(self.introductionTipsLabel.frame) == 0 ? 0 : SLChange(7.5);
    self.introductionTipsLabel.frame = CGRectMake(CGRectGetMinX(self.introductionTipsLabel.frame),
                                                  CGRectGetMaxY(self.introductionField.frame) + introductionTipsLabelOffset,
                                                  CGRectGetWidth(self.introductionTipsLabel.frame),
                                                  CGRectGetHeight(self.introductionTipsLabel.frame));
    
    self.whiteView.frame = CGRectMake(CGRectGetMinX(self.whiteView.frame),
                                      CGRectGetMinY(self.whiteView.frame),
                                      CGRectGetWidth(self.whiteView.frame),
                                      CGRectGetMaxY(self.introductionTipsLabel.frame) + SLChange(10));
    
}
// 键盘监听事件
- (void)keyboardAction:(NSNotification*)sender{
    // 通过通知对象获取键盘frame: [value CGRectValue]
    NSDictionary *useInfo = [sender userInfo];
//    NSValue *value = [useInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // <注意>具有约束的控件通过改变约束值进行frame的改变处理
    if([sender.name isEqualToString:UIKeyboardWillShowNotification]){
        //          [value CGRectValue].size.height;
        self.oneVideoImage.frame= CGRectMake(0, -100, kWidth, 300);
        self.whiteView.frame = CGRectMake(0, 201, kWidth, CGRectGetHeight(self.whiteView.frame));
        
    }else{
        //         self.toBottom.constant = 0;
        //        self.imageV.frame= CGRectMake(0, 0, kWidth, kWidth);
        self.oneVideoImage.frame= CGRectMake(0, 0, kWidth, 300);
        self.whiteView.frame = CGRectMake(0, 301, kWidth, CGRectGetHeight(self.whiteView.frame));
        
    }
}


#pragma mark - setter
-(void)setSlAssetModel:(SLAssetModel *)slAssetModel {
    _slAssetModel = slAssetModel;
    
    self.urlAsset = (AVURLAsset *)self.slAssetModel.videoAsset;
}

@end
