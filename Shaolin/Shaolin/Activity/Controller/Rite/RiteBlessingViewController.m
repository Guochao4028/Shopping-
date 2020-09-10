//
//  RiteBlessingViewController.m
//  Shaolin
//
//  Created by 王精明 on 2020/8/20.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RiteBlessingViewController.h"
#import "OrderHomePageViewController.h"
#import "WJMCheckBoxView.h"
#import "UIButton+Block.h"
#import "UIView+LGFExtension.h"
#import "UIImage+LGFColorImage.h"
#import "ActivityManager.h"
#import "RiteBlessingModel.h"

#import "ZFPlayerController.h"
#import "ZFPlayerControlView.h"
#import "ZFAVPlayerManager.h"
#import "DefinedHost.h"
#import "SLShareView.h"

static int const blessingWordsBackViewTag = 1001;
static int const HeadImageViewTag = 2000;

@interface RiteBlessingViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *inkStyleEavesImageView;//水墨风-屋檐
@property (nonatomic, strong) UIImageView *inkStyleShipImageView;//水墨风-船
@property (nonatomic, strong) UIView *blessingWordsView;//祝福语view
@property (nonatomic, strong) UIView *blessingWordsViewScreenshot;//祝福语截图view

@property (nonatomic, strong) UIImageView *containerView;
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;

@property (nonatomic, strong) UIView *wechatGroupView;//微信群view
@property (nonatomic, strong) UIView *neitanView;//选择进内坛
@property (nonatomic, strong) UIView *neitanViewFornt;//是否选择进内坛（font）
@property (nonatomic, strong) UIView *neitanViewBack;//是否选择进内坛（back）
@property (nonatomic, strong) UIButton *sharedButton;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) RiteBlessingModel *riteBlessingModel;
@end

@implementation RiteBlessingViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavigationControllerClearColor];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self resetNavigationController];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setNavigationControllerClearColor];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self resetNavigationController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.orderCode){
        self.orderCode = @"";
    }
    self.titleLabe.text = SLLocalizedString(@"支付成功");
    self.titleLabe.textColor = [UIColor whiteColor];
    [self.leftBtn setImage:[UIImage imageNamed:@"video_left"] forState:(UIControlStateNormal)];
    self.view.backgroundColor = [UIColor colorForHex:@"8E2B25"];
    [self setUI];
    [self requestData:nil];
}

#pragma mark - UI
- (void)setNavigationControllerClearColor{
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    
    self.navigationController.navigationBar.hidden = NO;
    UIImage *image = [[UIImage alloc]init];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.navigationController.navigationBar.translucent = YES;

    UIView *v = [self.navigationController.navigationBar.subviews firstObject];
    [v.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = YES;
        obj.alpha = 0;
    }];
}

- (void)resetNavigationController{
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.navigationController.navigationBar.translucent = NO;

    UIView *v = [self.navigationController.navigationBar.subviews firstObject];
    [v.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = NO;
        obj.alpha = 1;
    }];
}

- (void)setUI{
    [self.view addSubview:self.inkStyleEavesImageView];
    [self.view addSubview:self.inkStyleShipImageView];
    [self.view addSubview:self.scrollView];
    
    [self.inkStyleEavesImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
    }];
    [self.inkStyleShipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(0);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NavBar_Height);
        make.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.view);
    }];
}

//创建截图专用图层
- (void)createBlessingWordsViewScreenshot{
    [self.blessingWordsViewScreenshot.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIImage *image = ((UIImageView *)[self.view viewWithTag:HeadImageViewTag]).image;
    
    UIImageView *headImageView = [[UIImageView alloc] init];
    headImageView.image = image;
//    [headImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"default_small"]];
    headImageView.clipsToBounds = YES;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = self.riteBlessingModel.nickname;//@"释永信师父";
    nameLabel.font = kRegular(16);
    nameLabel.textColor = [UIColor colorForHex:@"333333"];
    
    UIImageView *triangleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"upTriangleWhite"]];
    
    UIView *blessingWordsBackView = [[UIView alloc] init];
    blessingWordsBackView.backgroundColor = [UIColor whiteColor];
    blessingWordsBackView.layer.cornerRadius = 5;
    blessingWordsBackView.clipsToBounds = YES;
    
    UILabel *blessingWordsLabel = [[UILabel alloc] init];
    blessingWordsLabel.text = self.riteBlessingModel.blessing;//@"自性本自清净，凡夫徒自烦恼。禅修之戒定慧。让自己面对自己，看到自己，回归自己。";
    blessingWordsLabel.font = kHelveticaFont(18);//kRegular(18);
    blessingWordsLabel.numberOfLines = 0;
    blessingWordsLabel.textColor = [UIColor colorForHex:@"333333"];
    
    //中国风八角窗
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RiteChineseStyleRight"]];
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RiteChineseStyleLeftTop"]];
    
    [self.blessingWordsViewScreenshot addSubview:imageView1];
    [self.blessingWordsViewScreenshot addSubview:imageView2];
    [self.blessingWordsViewScreenshot addSubview:headImageView];
    [self.blessingWordsViewScreenshot addSubview:nameLabel];
    [self.blessingWordsViewScreenshot addSubview:triangleImageView];
    [self.blessingWordsViewScreenshot addSubview:blessingWordsBackView];
    [blessingWordsBackView addSubview:blessingWordsLabel];
    
    [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(120, 187));
    }];
    [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(160, 176));
    }];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.blessingWordsViewScreenshot);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    headImageView.layer.cornerRadius = 40;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headImageView);
        make.top.mas_equalTo(headImageView.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(22.5);
    }];
    [triangleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameLabel.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(headImageView);
        make.size.mas_equalTo(CGSizeMake(24, 15.5));
    }];
    [blessingWordsBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(triangleImageView.mas_bottom);
        make.left.mas_equalTo(21.5);
        make.right.mas_equalTo(-21.5);
        make.bottom.mas_equalTo(-17.5);
    }];
    [blessingWordsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-80);
    }];
}

- (void)reloadBlessingWordsView{
    [self.blessingWordsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIImageView *headImageView = [[UIImageView alloc] init];
    headImageView.tag = 2000;
    [headImageView sd_setImageWithURL:[NSURL URLWithString:self.riteBlessingModel.headUrl] placeholderImage:[UIImage imageNamed:@"default_small"]];
    headImageView.clipsToBounds = YES;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = self.riteBlessingModel.nickname;//@"释永信师父";
    nameLabel.font = kRegular(16);
    nameLabel.textColor = [UIColor colorForHex:@"333333"];
    
    UIImageView *triangleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"upTriangleWhite"]];
    
    UIView *blessingWordsBackView = [[UIView alloc] init];
    blessingWordsBackView.tag = blessingWordsBackViewTag;
    blessingWordsBackView.backgroundColor = [UIColor whiteColor];
    blessingWordsBackView.layer.cornerRadius = 5;
    blessingWordsBackView.clipsToBounds = YES;
    
    UILabel *blessingWordsLabel = [[UILabel alloc] init];
    blessingWordsLabel.text = self.riteBlessingModel.blessing;//@"自性本自清净，凡夫徒自烦恼。禅修之戒定慧。让自己面对自己，看到自己，回归自己。";
    blessingWordsLabel.font = kHelveticaFont(18);//kRegular(18);
    blessingWordsLabel.numberOfLines = 0;
    blessingWordsLabel.textColor = [UIColor colorForHex:@"333333"];
    
    //中国风八角窗
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RiteChineseStyleRight"]];
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RiteChineseStyleLeftTop"]];
    
    [self.blessingWordsView addSubview:imageView1];
    [self.blessingWordsView addSubview:imageView2];
    [self.blessingWordsView addSubview:headImageView];
    [self.blessingWordsView addSubview:nameLabel];
    [self.blessingWordsView addSubview:triangleImageView];
    [self.blessingWordsView addSubview:blessingWordsBackView];
    
    [self.blessingWordsView addSubview:self.sharedButton];
    [self.blessingWordsView addSubview:self.saveButton];
    if (self.riteBlessingModel.video.length){
        [blessingWordsBackView addSubview:self.containerView];
        self.player.assetURL = [NSURL URLWithString:self.riteBlessingModel.video];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-30);
            make.bottom.mas_equalTo(-15);
            make.top.mas_equalTo(20);
            make.size.mas_equalTo(CGSizeMake(240, 150));
        }];
    } else {
        [blessingWordsBackView addSubview:blessingWordsLabel];
        [blessingWordsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(-80);
        }];
    }
    [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(120, 187));
    }];
    [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(160, 176));
    }];
    [self.sharedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(21, 19));
    }];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.blessingWordsView);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    headImageView.layer.cornerRadius = 40;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headImageView);
        make.top.mas_equalTo(headImageView.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(22.5);
    }];
    [triangleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameLabel.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(self.blessingWordsView);
        make.size.mas_equalTo(CGSizeMake(24, 15.5));
    }];
    [blessingWordsBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(triangleImageView.mas_bottom);
        make.left.mas_equalTo(21.5);
        make.right.mas_equalTo(-21.5);
    }];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blessingWordsBackView.mas_bottom).mas_offset(20);
        make.bottom.mas_equalTo(-17.5);
        make.left.right.mas_equalTo(blessingWordsBackView);
        make.height.mas_equalTo(40);
    }];
    self.saveButton.layer.cornerRadius = 20;
}

//是否参加内坛 正面
- (void)reloadNeitanViewFornt:(NSString *)title{
    [self.neitanViewFornt.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = kRegular(15);
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = [UIColor colorForHex:@"333333"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    //中国风八角窗
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RiteChineseStyleRightTop"]];
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RiteChineseStyleLeftBottom"]];
    [self.neitanViewFornt addSubview:imageView1];
    [self.neitanViewFornt addSubview:imageView2];
    [self.neitanViewFornt addSubview:titleLabel];
    
    __block NSString *selectItem = @"";
    NSArray *datas = @[@"是", @"否"];
    WJMCheckBoxView *checkBoxView = [self createCheckBoxView:datas];
    checkBoxView.didSelectItemAtIdentifier = ^(NSString * _Nonnull identifier) {
        selectItem = identifier;
    };
    UIButton *button = [[UIButton alloc] init];
    button.titleLabel.font = kRegular(15);
    button.backgroundColor = [UIColor colorForHex:@"8E2B25"];
    [button setTitle:SLLocalizedString(@"确定") forState:UIControlStateNormal];
    WEAKSELF
    [button handleControlEvent:UIControlEventTouchUpInside block:^(UIButton * _Nonnull button) {
        if (!selectItem.length) return;
        if ([selectItem isEqualToString:datas.firstObject]){
            [self ritePujaSignUpUpdate:^{
                [weakSelf reloadNeitanViewBack:SLLocalizedString(@"您已确认加入内坛，请保持手机畅通。")];
            } failure:nil];
        } else {
            [weakSelf reloadNeitanViewBack:SLLocalizedString(@"您已确认不进入内坛。")];
        }
    }];
    [self.neitanViewFornt addSubview:checkBoxView];
    [self.neitanViewFornt addSubview:button];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(32);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(21);
    }];
    [checkBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(titleLabel);
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(15);
    }];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(checkBoxView.mas_bottom).mas_offset(20);
        make.centerX.mas_equalTo(checkBoxView);
        make.size.mas_equalTo(CGSizeMake(110, 40));
    }];
    button.layer.cornerRadius = 20;
    button.clipsToBounds = YES;
    [self.neitanViewFornt addSubview:button];
    
    
    [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(118, 126));
    }];
    [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(140, 52));
    }];
}

//是否参加内坛 背面
- (void)reloadNeitanViewBack:(NSString *)title{
    [self.neitanViewBack.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.font = kRegular(15);
    titleLabel.textColor = [UIColor colorForHex:@"333333"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    
    //中国风八角窗
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RiteChineseStyleRightTop"]];
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RiteChineseStyleLeftBottom"]];
    [self.neitanViewBack addSubview:imageView1];
    [self.neitanViewBack addSubview:imageView2];
    [self.neitanViewBack addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.neitanViewBack);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(118, 126));
    }];
    [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(140, 52));
    }];
    
    [self.view layoutIfNeeded];
    [UIView transitionFromView:self.neitanViewFornt toView:self.neitanViewBack duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionShowHideTransitionViews | UIViewAnimationOptionAllowUserInteraction completion:^(BOOL finished) {
        
    }];
}

- (void)reloadWechatGroup{
    [self.wechatGroupView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    UIImageView *imageView1 = [[UIImageView alloc] init];
    UIImageView *imageView2 = [[UIImageView alloc] init];
    [self.wechatGroupView addSubview:imageView1];
    [self.wechatGroupView addSubview:imageView2];
    if (self.riteBlessingModel.flag){
        imageView1.image = [UIImage imageNamed:@"RiteChineseStyleRightBottom"];
        imageView2.image = [UIImage imageNamed:@"RiteChineseStyleLeft"];
        
        [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(120, 110));
        }];
        [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(160, 203));
        }];
    } else {
        imageView1.image = [UIImage imageNamed:@"RiteChineseStyleLeftBottom"];
        imageView2.image = [UIImage imageNamed:@"RiteChineseStyleRight_2"];
        
        [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(140, 52));
        }];
        [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(134, 203));
        }];
    }
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = kRegular(15);
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = [UIColor colorForHex:@"333333"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = SLLocalizedString(@"少林结缘群欢迎加入");
    
    __block BOOL saveImage = NO;
    __block UIImage *downloadImage = nil;
    WEAKSELF
    UIImageView *wechatGrouImageView = [[UIImageView alloc] init];
    NSString *urlStr = @"";//https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1598258659113&di=d725597b7207c43fa483187af1084c96&imgtype=0&src=http%3A%2F%2Fforum.xitek.com%2Fpics%2F201503%2F5408%2F540894%2F540894_1426176520.jpg
    [wechatGrouImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"default_small"] options:0 progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        downloadImage = image;
        if (saveImage){
            [weakSelf saveImageToPhoto:image];
        }
    }];
    
    UILabel *tips = [[UILabel alloc] init];
    tips.font = kRegular(15);
    tips.numberOfLines = 0;
    tips.textColor = [UIColor colorForHex:@"333333"];
    tips.textAlignment = NSTextAlignmentCenter;
    tips.text = SLLocalizedString(@"请打开【微信】-【右上角】-【扫一扫】进行扫描");
    
    UIButton *svaeWechatGroupBtn = [[UIButton alloc] init];
    svaeWechatGroupBtn.titleLabel.font = kRegular(15);
    svaeWechatGroupBtn.clipsToBounds = YES;
    [svaeWechatGroupBtn setBackgroundColor:[UIColor colorForHex:@"8E2B25"]];
    [svaeWechatGroupBtn setTitle:SLLocalizedString(@"下载二维码") forState:UIControlStateNormal];
    [svaeWechatGroupBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [svaeWechatGroupBtn handleControlEvent:UIControlEventTouchUpInside block:^(UIButton * _Nonnull button) {
        if (downloadImage) {
            [weakSelf saveImageToPhoto:downloadImage];
        } else {
            saveImage = YES;
        }
    }];
    
    [self.wechatGroupView addSubview:titleLabel];
    [self.wechatGroupView addSubview:wechatGrouImageView];
    [self.wechatGroupView addSubview:tips];
    [self.wechatGroupView addSubview:svaeWechatGroupBtn];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.centerX.mas_equalTo(self.wechatGroupView);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    [wechatGrouImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.wechatGroupView);
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(15);
        make.size.mas_equalTo(CGSizeMake(110, 110));
    }];
    [tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.wechatGroupView);
        make.top.mas_equalTo(wechatGrouImageView.mas_bottom).mas_offset(5);
        make.width.mas_equalTo(200);
    }];
    [svaeWechatGroupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.wechatGroupView);
        make.top.mas_equalTo(tips.mas_bottom).mas_offset(15);
        make.size.mas_equalTo(CGSizeMake(110, 40));
    }];
    svaeWechatGroupBtn.layer.cornerRadius = 20;
}

- (WJMCheckBoxView *)createCheckBoxView:(NSArray *)datas{
    NSMutableArray *checkBoxBtnArray = [@[] mutableCopy];
    for (int i = 0; i < datas.count; i++){
        NSString *title = datas[i];
        WJMCheckboxBtn *btn = [WJMCheckboxBtn radioBtnStyleWithTitle:title identifier:title];
        btn.titleLabel.triangleSide = 15;
        btn.titleLabel.selectImage = [UIImage imageNamed:@"radioSelected"];
        btn.titleLabel.normalImage = [UIImage imageNamed:@"radioNormal"];
        btn.titleLabel.textColor = [UIColor colorForHex:@"333333"];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [checkBoxBtnArray addObject:btn];
    }
    WJMCheckBoxView *checkBoxView = [[WJMCheckBoxView alloc] initCheckboxBtnBtns:checkBoxBtnArray];
    checkBoxView.maximumValue = 1;
    CGFloat padding = 12;
    NSInteger maxContentCount = 2;
    UIView *lastV = nil;
    for (int i = 0; i < checkBoxBtnArray.count; i++){
        WJMCheckboxBtn *button = checkBoxBtnArray[i];
        CGFloat offset = (i+1)*2.0/(checkBoxBtnArray.count+1);
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.centerX.mas_equalTo(checkBoxView).multipliedBy(offset);
            make.width.mas_equalTo(checkBoxView.mas_width).multipliedBy(1.0/maxContentCount).offset(-(padding*(maxContentCount+1) + 15*2));
            if (i == checkBoxBtnArray.count - 1){
                make.bottom.mas_equalTo(-10);
            }
        }];
        lastV = button;
    }
    return checkBoxView;
}

- (void)reloadRiteBlessingView{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.scrollView addSubview:self.blessingWordsView];
    [self.blessingWordsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(16);
        make.width.mas_equalTo(self.scrollView).mas_offset(-32);
    }];
    [self reloadBlessingWordsView];
    BOOL showNeitan = self.riteBlessingModel.flag;// || YES
    BOOL showWechatGroup = NO;
    if (showNeitan){
        [self reloadNeitanViewFornt:SLLocalizedString(@"您已有资格参加内坛，是否参加？")];
        [self.scrollView addSubview:self.neitanView];
        [self.neitanView addSubview:self.neitanViewBack];
        [self.neitanView addSubview:self.neitanViewFornt];
        [self.neitanView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.blessingWordsView);
            make.top.mas_equalTo(self.blessingWordsView.mas_bottom).mas_offset(15);
            make.height.mas_equalTo(184);
        }];
        [self.neitanViewFornt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [self.neitanViewBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    if (showWechatGroup){
        [self reloadWechatGroup];
        [self.scrollView addSubview:self.wechatGroupView];
        [self.wechatGroupView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (showNeitan){
                make.top.mas_equalTo(self.neitanViewFornt.mas_bottom).mas_offset(15);
            } else {
                make.top.mas_equalTo(self.blessingWordsView.mas_bottom).mas_offset(15);
            }
            make.left.right.mas_equalTo(self.blessingWordsView);
            make.height.mas_equalTo(280);
        }];
    }
    [self.view layoutIfNeeded];
    CGFloat height = self.view.height;
    if (showWechatGroup){
        height = self.wechatGroupView.maxY + 15;
    } else if (showNeitan){
        height = self.neitanViewFornt.maxY + 15;
    }
    [self.scrollView setContentSize:CGSizeMake(self.view.width, height)];
    
    [self.controlView showTitle:@"" coverImage:nil fullScreenMode:ZFFullScreenModePortrait];
}
#pragma mark requestData
- (void)requestData:(void (^)(void))finish{
    NSDictionary *params = @{
        @"orderCode" : self.orderCode,
    };
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    WEAKSELF
    [ActivityManager getRiteBlessing:params success:^(NSDictionary * _Nullable resultDic) {
        NSDictionary *dict = resultDic[@"pujaBlessing"];
        BOOL flag = [resultDic[@"flag"] boolValue];
        weakSelf.riteBlessingModel = [RiteBlessingModel mj_objectWithKeyValues:dict];
        if (!weakSelf.riteBlessingModel){
            weakSelf.riteBlessingModel = [[RiteBlessingModel alloc] init];
        }
        weakSelf.riteBlessingModel.flag = flag;
        [weakSelf reloadRiteBlessingView];
    } failure:^(NSString * _Nullable errorReason) {
        [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        [hud hideAnimated:YES];
    }];
}

- (void)ritePujaSignUpUpdate:(void (^)(void))success failure:(void (^)(void))failure{
    NSDictionary *params = @{
        @"orderCode" : self.orderCode,
    };
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [ActivityManager postRitePujaSignUpUpdate:params success:^(NSDictionary * _Nullable resultDic) {
        if (success) success();
    } failure:^(NSString * _Nullable errorReason) {
        [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
        if (failure) failure();
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        [hud hideAnimated:YES];
    }];
}
#pragma mark -
- (void)leftAction{
    OrderHomePageViewController *orderVC = [[OrderHomePageViewController alloc] init];
    [self.navigationController pushViewController:orderVC animated:YES];
}

- (void)sharedButtonClick:(UIButton *)button{
    if (!self.riteBlessingModel) return;
    SharedModel *model = [[SharedModel alloc] init];
    model.type = SharedModelType_URL;
    model.titleStr = self.riteBlessingModel.title;
    model.descriptionStr = self.riteBlessingModel.blessing;
    model.webpageURL = URL_H5_SharedRiteBlessing(self.riteBlessingModel.blessingId);
    model.imageURL = self.riteBlessingModel.headUrl;
    
    SLShareView *slShareView = [[SLShareView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    slShareView.model = model;
    [[self rootWindow] addSubview:slShareView];
}

- (void)saveButtonClick:(UIButton *)button{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted) { // 此应用程序没有被授权访问的照片数据。可能是家长控制权限。
        NSLog(@"因为系统原因, 无法访问相册");
    } else if (status == PHAuthorizationStatusDenied) { // 用户拒绝访问相册
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:SLLocalizedString(@"温馨提示") message:SLLocalizedString(@"请在设置中允许访问相册功能") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:SLLocalizedString(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:SLLocalizedString(@"确定") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }];
        [sureBtn setValue:[UIColor redColor] forKey:@"titleTextColor"];
        [alertVc addAction:cancelBtn];
        [alertVc addAction :sureBtn];
        [self presentViewController:alertVc animated:YES completion:nil];
    } else if (status == PHAuthorizationStatusAuthorized) { // 用户允许访问相册
        // 放一些使用相册的代码
        [self saveBlessingWordsView];
    } else if (status == PHAuthorizationStatusNotDetermined) { // 用户还没有做出选择
        // 弹框请求用户授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) { // 用户点击了好
                dispatch_queue_t mainQueue = dispatch_get_main_queue();
                dispatch_async(mainQueue,^{
                    // 放一些使用相册的代码
                    [self saveBlessingWordsView];
                });
            }
        }];
    }
}

- (void)saveBlessingWordsView {
    if (self.riteBlessingModel.video.length){
        [self.saveButton setBackgroundColor:[UIColor whiteColor]];
        [self.saveButton setTitleColor:[UIColor colorForHex:@"333333"] forState:UIControlStateNormal];
        [self.saveButton setTitle:@"0%" forState:UIControlStateNormal];
        self.saveButton.selected = YES;
        self.saveButton.layer.borderWidth = 1;
        WEAKSELF
        [ActivityManager downloadDatas:self.riteBlessingModel.video params:@{} progress:^(double progress) {
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.saveButton.width*progress, self.saveButton.height)];
            weakSelf.progressLayer.path = [path CGPath];
            [weakSelf.saveButton setTitle:[NSString stringWithFormat:@"%.0f%%", progress*100] forState:UIControlStateNormal];
        } success:^(id  _Nullable responseObject) {
            [weakSelf.saveButton setBackgroundColor:[[UIColor colorForHex:@"8E2B25"] colorWithAlphaComponent:0.65]];
            [weakSelf.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [weakSelf.saveButton setTitle:SLLocalizedString(@"完成") forState:UIControlStateNormal];
            weakSelf.saveButton.enabled = NO;
            
            PHPhotoLibrary *photoLibrary = [PHPhotoLibrary sharedPhotoLibrary];
            [photoLibrary performChanges:^{
                [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:[NSURL fileURLWithPath:responseObject]];
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                if (success) {
                    NSLog(@"已将视频保存至相册");
                } else {
                    NSLog(@"未能保存视频到相册");
                }
            }];
        } failure:^(NSString * _Nullable errorReason) {
            weakSelf.saveButton.selected = NO;
            [weakSelf.saveButton setBackgroundColor:[UIColor colorForHex:@"8E2B25"]];
            [weakSelf.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } finish:^(id  _Nullable responseObject, NSError * _Nullable error) {
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectZero];
            weakSelf.progressLayer.path = [path CGPath];
            weakSelf.saveButton.layer.borderWidth = 0;
        }];
    } else {
        [self createBlessingWordsViewScreenshot];
        [self.scrollView addSubview:self.blessingWordsViewScreenshot];
        [self.scrollView sendSubviewToBack:self.blessingWordsViewScreenshot];
        [self.blessingWordsViewScreenshot mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.left.mas_equalTo(16);
            make.width.mas_equalTo(self.scrollView).mas_offset(-32);
        }];
        [self.view layoutIfNeeded];
        UIGraphicsBeginImageContextWithOptions(self.blessingWordsViewScreenshot.size, NO, 0);
        [self.blessingWordsViewScreenshot.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [self.blessingWordsViewScreenshot removeFromSuperview];
        [self saveImageToPhoto:image];
    }
}

- (void)saveImageToPhoto:(UIImage *)image{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"保存图片成功")];
        } else {
            [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"保存图片失败")];
        }
    }];
}

#pragma mark - getter
- (UIImageView *)inkStyleEavesImageView{
    if (!_inkStyleEavesImageView){
        _inkStyleEavesImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RiteInkStyleEaves"]];
    }
    return _inkStyleEavesImageView;
}
- (UIImageView *)inkStyleShipImageView{
    if (!_inkStyleShipImageView){
        _inkStyleShipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RiteInkStyleShip"]];
    }
    return _inkStyleShipImageView;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _scrollView;
}
- (UIButton *)sharedButton{
    if (!_sharedButton){
        _sharedButton = [[UIButton alloc] init];
        [_sharedButton setBackgroundImage:[UIImage imageNamed:@"shareRad"] forState:UIControlStateNormal];
        [_sharedButton addTarget:self action:@selector(sharedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sharedButton;
}

- (UIButton *)saveButton{
    if (!_saveButton){
        _saveButton = [[UIButton alloc] init];
        _saveButton.titleLabel.font = kRegular(14);
        _saveButton.clipsToBounds = YES;
        _saveButton.backgroundColor = [UIColor colorForHex:@"8E2B25"];
        _saveButton.layer.borderColor = [UIColor colorForHex:@"8E2B25"].CGColor;
        _saveButton.layer.borderWidth = 0;
        [_saveButton setTitle:SLLocalizedString(@"保存到本地") forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(saveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.fillColor = [[UIColor colorForHex:@"8E2B25"] colorWithAlphaComponent:0.6].CGColor;
//        _progressLayer.strokeColor = [[UIColor whiteColor] CGColor];
        _progressLayer.opacity = 1;
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.lineWidth = 0;
        
        [_progressLayer setShadowColor:[UIColor blackColor].CGColor];
        [_progressLayer setShadowOffset:CGSizeMake(1, 1)];
        [_progressLayer setShadowOpacity:0.5];
        [_progressLayer setShadowRadius:2];
        
        [_saveButton.layer addSublayer:_progressLayer];
    }
    return _saveButton;
}

- (UIView *)blessingWordsView{
    if (!_blessingWordsView){
        _blessingWordsView = [[UIView alloc] init];
        _blessingWordsView.layer.cornerRadius = 5;
        _blessingWordsView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    }
    return _blessingWordsView;
}

- (UIView *)blessingWordsViewScreenshot{
    if (!_blessingWordsViewScreenshot){
        _blessingWordsViewScreenshot = [[UIView alloc] init];
        _blessingWordsViewScreenshot.layer.cornerRadius = 5;
        _blessingWordsViewScreenshot.clipsToBounds = YES;
        _blessingWordsViewScreenshot.backgroundColor = [UIColor colorForHex:@"F3EAE9"];
    }
    return _blessingWordsViewScreenshot;
}

- (UIView *)neitanView{
    if (!_neitanView){
        _neitanView = [[UIView alloc] init];
        _neitanView.layer.cornerRadius = 5;
        _neitanView.backgroundColor = [UIColor clearColor];//[UIColor colorWithWhite:1 alpha:0.9];
    }
    return _neitanView;
}

- (UIView *)neitanViewFornt{
    if (!_neitanViewFornt){
        _neitanViewFornt = [[UIView alloc] init];
        _neitanViewFornt.layer.cornerRadius = 5;
        _neitanViewFornt.backgroundColor = [UIColor colorForHex:@"F3EAE9"];//[UIColor colorWithWhite:1 alpha:0.9];
    }
    return _neitanViewFornt;
}

- (UIView *)neitanViewBack {
    if (!_neitanViewBack){
        _neitanViewBack = [[UIView alloc] init];
        _neitanViewBack.layer.cornerRadius = 5;
        _neitanViewBack.backgroundColor = [UIColor colorForHex:@"F3EAE9"];//[UIColor colorWithWhite:1 alpha:0.9];
    }
    return _neitanViewBack;
}

- (UIView *)wechatGroupView{
    if (!_wechatGroupView){
        _wechatGroupView = [[UIView alloc] init];
        _wechatGroupView.layer.cornerRadius = 5;
        _wechatGroupView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    }
    return _wechatGroupView;
}

- (ZFPlayerController *)player{
    if (!_player){
        /// playerManager
        ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
        playerManager.muted = YES;
        playerManager.view.backgroundColor = [UIColor clearColor];
        
        _player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
        //移动网络自动播放视频
        _player.WWANAutoPlay = YES;
        _player.controlView = self.controlView;

        WEAKSELF
        self.player.playerPlayStateChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, ZFPlayerPlaybackState playState) {
            if (playState != ZFPlayerPlayStatePlayStopped) weakSelf.controlView.alwaysControlViewAppeared = NO;
            if (playState == ZFPlayerPlayStatePlaying) [weakSelf.controlView hideControlViewWithAnimated:YES];
        };
        //播放结束
        self.player.playerDidToEnd = ^(id  _Nonnull asset) {
            [playerManager.player seekToTime:CMTimeMake(0, 1) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:nil];
            [weakSelf.player.currentPlayerManager pause];
            weakSelf.controlView.alwaysControlViewAppeared = YES;
            [weakSelf.controlView showControlViewWithAnimated:YES];
        };
    }
    return _player;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
//        _controlView.horizontalPanShowControlView = NO;
        // 显示loading
        _controlView.prepareShowLoading = YES;
        //TODO: 去掉高斯模糊背景
        [_controlView setEffectViewShow:NO];
    }
    return _controlView;
}

- (UIImageView *)containerView{
    if (!_containerView){
        _containerView = [[UIImageView alloc] init];
        _containerView.backgroundColor = [UIColor blackColor];
    }
    return _containerView;
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
