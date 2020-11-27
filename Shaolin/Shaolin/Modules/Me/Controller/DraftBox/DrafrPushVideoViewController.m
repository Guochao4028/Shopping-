//
//  DrafrPushVideoViewController.m
//  Shaolin
//
//  Created by syqaxldy on 2020/4/19.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "DrafrPushVideoViewController.h"
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
#import "PostManagementVc.h"

@interface DrafrPushVideoViewController ()<UITextFieldDelegate>
@property(nonatomic,strong) UITextField *textField;
@property(nonatomic,strong) UITextField *introductionField;
//@property(nonatomic,strong) UIImageView *imageV;
@property(nonatomic,strong) UILabel *titleLabels;
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

@end

@implementation DrafrPushVideoViewController

#pragma mark - life cycle

-(void)dealloc {
    [self removeKeyboardNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabe.text = SLLocalizedString(@"发视频");
    self.view.backgroundColor = KTextGray_FA;
    
    [self.view addSubview:self.containerView];
    [self.view addSubview:self.oneVideoImage];
    
    [self.containerView addSubview:self.playBtn];
    [self.oneVideoImage addSubview:self.bgPlayBtn];
    
    
    [self setUI];
    
    
    self.oneVideoImage.image = self.videoImage;
    
    self.textField.text = [NSString stringWithFormat:@"%@",self.model.title];
    self.introductionField.text = [NSString stringWithFormat:@"%@",self.model.abstracts];
    
    // 添加通知监听见键盘弹出/退出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)setUI {
    [self.oneVideoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(300);
        make.top.mas_equalTo(0);
    }];
    [self.bgPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.oneVideoImage);
        make.size.mas_equalTo(SLChange(29));
    }];
    
    UIView *whiteView  = [[UIView alloc]initWithFrame:CGRectMake(0, 301, kWidth, SLChange(92))];
    whiteView.backgroundColor = UIColor.whiteColor;
    whiteView.userInteractionEnabled = YES;
    self.whiteView =whiteView;
    [self.view addSubview:whiteView];
    
    self.titleLabels = [[UILabel alloc]initWithFrame:CGRectMake(SLChange(16), 0, SLChange(40), SLChange(45))];
    NSMutableAttributedString *missionAttributed = [[NSMutableAttributedString alloc]initWithString:SLLocalizedString(@"标题*")];
    [missionAttributed setAttributes:@{NSForegroundColorAttributeName:KTextGray_333} range:NSMakeRange(0, 2)];
    [missionAttributed addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:NSMakeRange(0, 2)];
    [missionAttributed setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(2, 1)];
    [missionAttributed addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:NSMakeRange(2, 1)];
    self.titleLabels.attributedText = missionAttributed;
    [whiteView addSubview:self.titleLabels];
    [whiteView addSubview:self.textField];
    
    
    self.viewBg = [[UIView alloc]initWithFrame:CGRectMake(SLChange(16), SLChange(45), kWidth-SLChange(32), SLChange(1))];
    _viewBg.backgroundColor = RGBA(216, 216, 216, 1);
    [whiteView addSubview:self.viewBg];
    
    UILabel *inLabel = [[UILabel alloc]initWithFrame:CGRectMake(SLChange(16), SLChange(46), SLChange(40), SLChange(45))];
//    inLabel.text = SLLocalizedString(@"简介");
    NSMutableAttributedString *missionAttributed2 = [[NSMutableAttributedString alloc]initWithString:SLLocalizedString(@"简介*")];
    [missionAttributed2 setAttributes:@{NSForegroundColorAttributeName:KTextGray_333} range:NSMakeRange(0, 2)];
    [missionAttributed2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:NSMakeRange(0, 2)];
    [missionAttributed2 setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(2, 1)];
    [missionAttributed2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:NSMakeRange(2, 1)];
    inLabel.attributedText = missionAttributed2;
    
//    inLabel.textColor = KTextGray_333;
    inLabel.font = kRegular(15);
    [whiteView addSubview:inLabel];
    [whiteView addSubview:self.introductionField];
    
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
    //    [self.textField resignFirstResponder];
    
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
    self.player.assetURL = self.videoUrl;
    //    if ([self.type isEqualToString:@"0"]) {
    //        self.player.assetURL = self.videoStr;
    //    }else {
    //
    //    }
    
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
            for (UIViewController * controller in weakSelf.navigationController.viewControllers) {
                if ([controller isKindOfClass:[PostManagementVc class]]) {
                    [weakSelf.navigationController popToViewController:controller animated:YES];
                }
            }
        }];
        [alert addAction:defaultAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"取消")
                                                               style:UIAlertActionStyleCancel
                                                             handler:nil];
        [alert addAction:cancelAction];
        [weakSelf presentViewController:alert animated:YES completion:nil];
    }
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
   
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:SLLocalizedString(@"提示")
                                                                   message:SLLocalizedString(@"是否发布视频？")
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"确定发布") style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction * action) {
        if (weakSelf.slAssetModel) {
            [weakSelf compressionVideo];
        }else {
            [weakSelf uploadVideoWithUrl:weakSelf.videoUrl.absoluteString];
        }
    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"取消") style:UIAlertActionStyleDefault
                                                         handler:nil];
    
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [weakSelf presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 发布视频步骤2--压缩视频
-(void)compressionVideo
{
    NSString *outPutPath;
    // 设置导出文件的存放路径
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    NSDate    *date = [[NSDate alloc] init];
    outPutPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"outputt-%@.mp4",[formatter stringFromDate:date]]];
    DyVideoCompression *compression = [[DyVideoCompression alloc]init]; // 创建对象
    compression.inputURL = self.videoUrl ;
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
    
    [ShaolinProgressHUD defaultSingleLoadingWithText:SLLocalizedString(@"正在上传视频")];
    [compression startCompressionWithCompletionHandler:^(DYVideoCompressionState State) {
        if (State == DY_VIDEO_STATE_FAILURE) {
            NSLog(@"压缩失败");
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"压缩视频失败") view:self.view afterDelay:TipSeconds];
        }else
        {
            NSLog(@"压缩成功");
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *newUrl = [NSString stringWithFormat:@"%@",[compression.exportURL path]];
                [weakSelf uploadVideoWithUrl:newUrl];
            });
        }
    }];
}
#pragma mark - 发布视频步骤3 -- 上传相关信息
- (void) uploadVideoWithUrl:(NSString *)videoUrl {
    
    NSMutableArray * coverUrlPlist = [NSMutableArray new];
    NSMutableDictionary * paramerDic = [NSMutableDictionary dictionary];
    [paramerDic setValue:@"1" forKey:@"type"];
    [paramerDic setValue:@"3" forKey:@"kind"];
    [paramerDic setValue:self.model.id forKey:@"contentId"];
    [ShaolinProgressHUD defaultSingleLoadingWithText:SLLocalizedString(@"发布视频中...")];
    if (!self.slAssetModel) {
        [paramerDic setValue:videoUrl forKey:@"route"];
        [coverUrlPlist addObject:paramerDic];
        [self postDataWithCoverUrlPlist:coverUrlPlist];
    }else {
        NSData *data = [[NSData alloc] initWithContentsOfFile:videoUrl];
//        [[HomeManager sharedInstance] postSubmitPhotoWithFileData:data isVedio:YES Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
//        {
//            NSDictionary *dic = responseObject;
//            if ([[dic objectForKey:@"code"] integerValue]== 200) {
//                [paramerDic setValue:[dic objectForKey:@"data"] forKey:@"route"];
//                [coverUrlPlist addObject:paramerDic];
//                [self postDataWithCoverUrlPlist:coverUrlPlist];
//            } else {
//                [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"发布失败") view:[UIApplication sharedApplication].keyWindow afterDelay:TipSeconds];
//            }
//        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//            NSLog(@"%@",error);
//            [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:self.view afterDelay:TipSeconds];
//        }];
        
        
        
        [[HomeManager  sharedInstance]postSubmitPhotoWithFileData:data isVedio:YES Success:^(NSDictionary * _Nullable resultDic) {
        } failure:^(NSString * _Nullable errorReason) {
        } finish:^(NSDictionary * _Nullable responseObject, NSString * _Nullable errorReason) {
         
           NSDictionary *dic = responseObject;
                     if ([[dic objectForKey:@"code"] integerValue]== 200) {
                         [paramerDic setValue:[dic objectForKey:@"data"] forKey:@"route"];
                         [coverUrlPlist addObject:paramerDic];
                         [self postDataWithCoverUrlPlist:coverUrlPlist];
                     } else {
                         [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"发布失败") view:[UIApplication sharedApplication].keyWindow afterDelay:TipSeconds];
                     }
            
        }];
    }
}

#pragma mark 修改文章
-(void)postDataWithCoverUrlPlist:(NSMutableArray *)plistArr {
    
    NSArray * coverurilids = @[self.model.id];
    
    [[HomeManager sharedInstance] postUserChangeTextWithTitle:self.textField.text Introduction:self.introductionField.text textId:self.model.id Content:@"" Type:@"3" State:@"2" CreateId:@"" CreateName:@"" CreateType:@"2" Coverurilids:coverurilids CoverUrlPlist:plistArr WithBlock:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
        if ([[responseObject objectForKey:@"code"]integerValue]==200) {
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"已提交审核") view:self.view afterDelay:TipSeconds];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        } else {
            if (error){
                [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:self.view afterDelay:TipSeconds];
            } else {
                NSString *message = [responseObject objectForKey:@"data"];
                [ShaolinProgressHUD singleTextHud:message view:self.view afterDelay:TipSeconds];
            }
        }
        NSLog(@"%@",error);
    }];
}

- (void)playClick:(UIButton *)sender {
    
    self.controlView.coverImageView.image = self.videoImage;
    self.controlView.bgImgView.image = self.videoImage;
    [self.player playTheIndex:0];
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
    [self.introductionField resignFirstResponder];
}

#pragma mark - delegate && notication
// 点击键盘Return键取消第一响应者
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField resignFirstResponder];
    [self.introductionField resignFirstResponder];
    return  YES;
}
// 键盘监听事件
- (void)keyboardAction:(NSNotification*)sender{
    // 通过通知对象获取键盘frame: [value CGRectValue]
    //    NSDictionary *useInfo = [sender userInfo];
    //    NSValue *value = [useInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    // <注意>具有约束的控件通过改变约束值进行frame的改变处理
    if([sender.name isEqualToString:UIKeyboardWillShowNotification]){
        self.oneVideoImage.frame= CGRectMake(0, -100, kWidth, 300);
        self.whiteView.frame = CGRectMake(0, 201, kWidth, SLChange(92));
        
    }else{
        self.oneVideoImage.frame= CGRectMake(0, 0, kWidth, 300);
        self.whiteView.frame = CGRectMake(0, 301, kWidth, SLChange(92));
        
    }
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
        //        [_containerView setim];
        _containerView.backgroundColor = [UIColor clearColor];
    }
    return _containerView;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"new_allPlay_44x44_"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}
-(UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(SLChange(80),0, kWidth - SLChange(85), SLChange(45))];
        
        [_textField setTextColor:[UIColor blackColor]];
        _textField.font = kMediumFont(13);
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.placeholder = SLLocalizedString(@"给视频起个名字吧");
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        //               _textField.returnKeyType = UIReturnKeySearch;
        _textField.delegate = self;
        _textField.keyboardType = UIKeyboardTypeDefault;
        [_textField setValue:KTextGray_999 forKeyPath:@"placeholderLabel.textColor"];
        [_textField setValue:kMediumFont(13) forKeyPath:@"placeholderLabel.font"];
        _textField.returnKeyType = UIReturnKeyDone;
        
    }
    return _textField;
}
-(UITextField *)introductionField
{
    if (!_introductionField) {
        _introductionField = [[UITextField alloc] initWithFrame:CGRectMake(SLChange(80),SLChange(46), kWidth - SLChange(85), SLChange(45))];
        
        [_introductionField setTextColor:[UIColor blackColor]];
        _introductionField.font = kMediumFont(13);
        _introductionField.leftViewMode = UITextFieldViewModeAlways;
        _introductionField.placeholder = SLLocalizedString(@"简单介绍下视频吧");
        _introductionField.clearButtonMode = UITextFieldViewModeWhileEditing;
        //               _textField.returnKeyType = UIReturnKeySearch;
        _introductionField.delegate = self;
        _introductionField.keyboardType = UIKeyboardTypeDefault;
        [_introductionField setValue:KTextGray_999 forKeyPath:@"placeholderLabel.textColor"];
        [_introductionField setValue:kMediumFont(13) forKeyPath:@"placeholderLabel.font"];
        _introductionField.returnKeyType = UIReturnKeyDone;
        
    }
    return _introductionField;
}

- (UIImageView *)oneVideoImage {
    if (!_oneVideoImage) {
        _oneVideoImage = [[UIImageView alloc]init];
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

@end
