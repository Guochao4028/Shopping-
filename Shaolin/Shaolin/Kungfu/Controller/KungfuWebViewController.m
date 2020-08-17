//
//  KungfuWebViewController.m
//  Shaolin
//
//  Created by ws on 2020/5/25.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuWebViewController.h"
#import <WebKit/WebKit.h>

#import "SMAlert.h"
#import "SharedModel.h"

#import "EnrollmentRegistrationInfoViewController.h"
#import "RealNameViewController.h"
#import "RiteRegistrationFormViewController.h"
#import "InstitutionSignupViewController.h"

#import "SLShareView.h"
#import "HomeManager.h"

@interface KungfuWebViewController () <WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic, assign) KfWebViewType webType;

@property (nonatomic, strong) UIButton * backButton;
@property (nonatomic, strong) MBProgressHUD * hud;

@property (nonatomic, strong) NSString * urlStr;;
@property (nonatomic, strong) WKWebView * webView;

@property (nonatomic, strong) UIProgressView * progressView;

@property (nonatomic, strong) UIButton * collectBtn;//收藏
@property (nonatomic, strong) UILabel * collectLabel;

@property (nonatomic, strong) UIButton * likeBtn;//点赞
@property (nonatomic, strong) UILabel * likeLabel;

@property (nonatomic, strong) UIButton * shareBtn;//分享
@property (nonatomic, strong) UILabel * shareLabel;

@property (nonatomic, strong) NSMutableDictionary * subJsonDic;
@property(nonatomic,strong) SLShareView *slShareView;

@end

@implementation KungfuWebViewController

#pragma mark - life cycle
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    self.titleLabe.text = self.titleStr;
    if (self.webType != KfWebView_rite) {
        self.likeBtn.hidden = YES;
        self.likeLabel.hidden = YES;
        self.collectBtn.hidden = YES;
        self.collectLabel.hidden = YES;
        self.shareBtn.hidden = YES;
        self.shareLabel.hidden = YES;
    } else {
        self.likeBtn.hidden = NO;
        self.likeLabel.hidden = NO;
        self.collectBtn.hidden = NO;
        self.collectLabel.hidden = NO;
        self.shareBtn.hidden = NO;
        self.shareLabel.hidden = NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.likeBtn.hidden = YES;
    self.likeLabel.hidden = YES;
    self.collectBtn.hidden = YES;
    self.collectLabel.hidden = YES;
    self.shareBtn.hidden = YES;
    self.shareLabel.hidden = YES;
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    if (!self.navigationController || self.navigationController.viewControllers.count == 1) {
//        NSLog(@"移除wkWebView注入的脚本");
        [self wr_setNavBarBackgroundAlpha:0];
        [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"H5inFormLocal"];
    }
}

- (void)dealloc{
    NSLog(@"%@释放了",NSStringFromClass([self class]));
//    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.likeBtn removeFromSuperview];
    [self.likeLabel removeFromSuperview];
    [self.collectBtn removeFromSuperview];
    [self.collectLabel removeFromSuperview];
    [self.shareBtn removeFromSuperview];
    [self.shareLabel removeFromSuperview];
    [self.webView setNavigationDelegate:nil];
    [self.webView setUIDelegate:nil];
}


-(instancetype)initWithUrl:(NSString *)url type:(KfWebViewType)type {
    self = [super init];
    if (self) {
        self.urlStr = url;
        self.webType = type;
        
        switch (type) {
            case KfWebView_activityDetail:
                self.titleStr = SLLocalizedString(@"活动详情");
                break;
            case KfWebView_mechanismDetail:
                self.titleStr = SLLocalizedString(@"机构详情");
                break;
            case KfWebView_applyDetail:
                self.titleStr = SLLocalizedString(@"报名详情");
                break;
            case KfWebView_examNoti:
                self.titleStr = SLLocalizedString(@"考试通知");
                break;
            case KfWebView_rite:
                self.titleStr = @"";
                break;
            default:
                break;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

-(void)initUI{
    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(self.webView.frame), ScreenWidth, 2)];
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.backButton];
 
    
    [self.navigationController.navigationBar addSubview:self.likeBtn];
    [self.navigationController.navigationBar addSubview:self.likeLabel];
    [self.navigationController.navigationBar addSubview:self.collectBtn];
    [self.navigationController.navigationBar addSubview:self.collectLabel];
    [self.navigationController.navigationBar addSubview:self.shareBtn];
    [self.navigationController.navigationBar addSubview:self.shareLabel];
    
    self.shareBtn.frame = CGRectMake(kScreenWidth - 29 - 21, self.navigationController.navigationBar.height/2 - 10, 21, 19);
    self.shareLabel.frame = CGRectMake(self.shareBtn.right, self.shareBtn.top - 10, 25, 19);
    
    self.likeBtn.frame = CGRectMake(self.shareBtn.left - 20 - 21, self.shareBtn.top, self.shareBtn.width, self.shareBtn.height);
    self.likeLabel.frame = CGRectMake(self.likeBtn.right, self.shareLabel.top, 25, 19);
    
    self.collectBtn.frame = CGRectMake(self.likeBtn.left - 20 - 21, self.likeBtn.top, self.likeBtn.width, self.likeBtn.height);
    self.collectLabel.frame = CGRectMake(self.collectBtn.right, self.likeLabel.top, self.likeBtn.width, self.likeBtn.height);
//    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-29);
////        make.top.mas_equalTo(10.5+StatueBar_Height);
//        make.centerY.mas_equalTo(self.navigationController.navigationBar);
//        make.width.mas_equalTo(21);
//        make.height.mas_equalTo(19);
//    }];
//    [self.shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.shareBtn.mas_right);
//        make.centerY.mas_equalTo(self.likeLabel);
//        make.width.mas_equalTo(25);
//        make.height.mas_equalTo(19);
//    }];
//    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.shareBtn.mas_left).offset(-20);
//        make.top.mas_equalTo(10.5+StatueBar_Height);
//        make.centerY.mas_equalTo(self.navigationController.navigationBar);
//        make.width.mas_equalTo(19);
//        make.height.mas_equalTo(19);
//    }];
//    [self.likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.likeBtn.mas_right);
//        make.centerY.mas_equalTo(self.likeBtn.mas_top);
//        make.width.mas_equalTo(25);
//        make.height.mas_equalTo(19);
//    }];
    
//    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.likeBtn.mas_left).offset(-20);
//        make.top.mas_equalTo(10.5+StatueBar_Height);
//        make.centerY.mas_equalTo(self.navigationController.navigationBar);
//        make.width.mas_equalTo(19);
//        make.height.mas_equalTo(19);
//    }];
//    [self.collectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.collectBtn.mas_right);
//        make.centerY.mas_equalTo(self.collectBtn.mas_top);
//        make.width.mas_equalTo(25);
//        make.height.mas_equalTo(19);
//    }];
    
    
    
    [self initData];
}

-(void)initData{
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [self.webView loadRequest:request];
}

- (void)hideWebViewScrollIndicator{
    [self.webView.scrollView setShowsVerticalScrollIndicator:NO];
    [self.webView.scrollView setShowsHorizontalScrollIndicator:NO];
}
#pragma mark - event
- (void)backHandle {
    if (self.navigationController.topViewController == self) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)collectAction {
    self.collectBtn.selected = !self.collectBtn.selected;
    if (self.collectBtn.selected) { //收藏成功调用的
        [self foucsSuccess:self.collectBtn];
    }else
    {  //取消收藏
        [self foucsCancle:self.collectBtn];
    }
}
#pragma mark - 收藏成功
-(void)foucsSuccess:(UIButton *)btn
{
    NSString *contentId  = [NSString stringWithFormat:@"%@",[self.subJsonDic objectForKey:@"pujaCode"]];
    [[HomeManager sharedInstance]postCollectionContentId:contentId Type:@"4" Kind:@"1" MemberId:@"" MemberName:@"" Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] integerValue] == 200) {

            NSString * collectStr = [self getNotnilString:[self.subJsonDic objectForKey:@"collections"]];
            NSInteger likeCount = [collectStr integerValue];

            likeCount += 1;

            [btn setSelected:YES];
            self.collectLabel.text = [NSString stringWithFormat:@"%ld",likeCount];
            self.collectLabel.hidden = NO;
            [self.subJsonDic setObject:[NSString stringWithFormat:@"%ld",likeCount] forKey:@"collections"];
            self.collectLabel.textColor = WENGEN_RED;
            [ShaolinProgressHUD singleTextHud:@"收藏成功" view:self.view afterDelay:TipSeconds];
        }else
        {
            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"message"] view:self.view afterDelay:TipSeconds];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:self.view afterDelay:TipSeconds];
    }];
}
#pragma mark - 取消收藏
-(void)foucsCancle:(UIButton *)btn
{
    NSString *strId = [NSString stringWithFormat:@"%@", [self.subJsonDic objectForKey:@"pujaCode"]];
    NSMutableArray *arr = [NSMutableArray array];
    NSDictionary *dic = @{@"pujaCode":strId,@"type":@"4"};
    [arr addObject:dic];
    [[HomeManager sharedInstance]postCollectionCancleArray:arr WithBlock:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] integerValue]== 200) {
            
            NSString * collectStr = [self getNotnilString:[self.subJsonDic objectForKey:@"collections"]];
            NSInteger likeCount = [collectStr integerValue];
            likeCount --;
            
            
            [btn setSelected:NO];
            if (likeCount == 0) {
                self.collectLabel.hidden = YES;
            }else
            {
                self.collectLabel.text = [NSString stringWithFormat:@"%ld",likeCount];
            }
            
            [self.subJsonDic setObject:[NSString stringWithFormat:@"%ld",likeCount] forKey:@"collections"];
            self.collectLabel.textColor = [UIColor hexColor:@"333333"];
            [ShaolinProgressHUD singleTextHud:@"取消收藏" view:self.view afterDelay:TipSeconds];
        }else
        {
            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"message"] view:self.view afterDelay:TipSeconds];
        }
    }];
}

- (void)likeAction {
    self.likeBtn.selected = !self.likeBtn.selected;
    if (self.likeBtn.selected) {
        //收藏成功调用的
        [self praiseSuccess:self.likeBtn];
    } else {  //取消收藏
        [self praiseCancle:self.likeBtn];
    }
}

#pragma mark - 点赞成功
-(void)praiseSuccess:(UIButton *)btn
{
    NSString *contentId  =[NSString stringWithFormat:@"%@",[self.subJsonDic objectForKey:@"pujaCode"]];
    [[HomeManager sharedInstance]postPraiseContentId:contentId Type:@"4" Kind:@"1" MemberId:@"" MemberName:@"" Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] integerValue] == 200) {

            NSString * likeStr = [self getNotnilString:[self.subJsonDic objectForKey:@"praises"]];
            NSInteger likeCount = [likeStr integerValue];
            likeCount += 1;


            [btn setSelected:YES];
            self.likeLabel.text = [NSString stringWithFormat:@"%ld",likeCount];
            self.likeLabel.hidden = NO;
            [self.subJsonDic setObject:[NSString stringWithFormat:@"%ld",likeCount] forKey:@"praises"];
            self.likeLabel.textColor = WENGEN_RED;
            [ShaolinProgressHUD singleTextHud:@"点赞成功" view:self.view afterDelay:TipSeconds];
        }else
        {
            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"message"] view:self.view afterDelay:TipSeconds];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:self.view afterDelay:TipSeconds];
    }];
}
#pragma mark - 取消点赞
-(void)praiseCancle:(UIButton *)btn
{
    NSString *strId = [NSString stringWithFormat:@"%@", [self.subJsonDic objectForKey:@"pujaCode"]];
    NSMutableArray *arr = [NSMutableArray array];
    NSDictionary *dic = @{@"pujaCode":strId,@"type":@"4"};
    [arr addObject:dic];
    [[HomeManager sharedInstance]postPraiseCancleArray:arr WithBlock:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] integerValue]== 200) {

            NSString * likeStr = [self getNotnilString:[self.subJsonDic objectForKey:@"praises"]];
            NSInteger likeCount = [likeStr integerValue];
            likeCount --;

            [btn setSelected:NO];
            if (likeCount == 0) {
                self.likeLabel.hidden = YES;
            }else
            {
                self.likeLabel.text = [NSString stringWithFormat:@"%ld",likeCount];
            }

            [self.subJsonDic setObject:[NSString stringWithFormat:@"%ld",likeCount] forKey:@"praises"];

            self.likeLabel.textColor = [UIColor hexColor:@"333333"];
            [ShaolinProgressHUD singleTextHud:@"取消点赞" view:self.view afterDelay:TipSeconds];
        }else
        {
            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"message"] view:self.view afterDelay:TipSeconds];
        }
    }];
}

- (void)shareAction {
    NSString * thumbnailUrl = [self getNotnilString:[self.subJsonDic objectForKey:@"thumbnailUrl"]];
    SharedModel *model = [[SharedModel alloc] init];
    model.type = SharedModelType_URL;
    model.titleStr = [self.subJsonDic objectForKey:@"pujaName"];
    model.descriptionStr = [self.subJsonDic objectForKey:@"pujaIntroduction"];
    NSString *webpageURL = self.urlStr;
//        if ([self.tabbarStr isEqualToString:@"Found"]) { //发现页 分享 文章详情(暂时只在dev可以，其他环境下该链接是空页)
//            webpageURL = URL_H5_SharedArticleDetail(self.detailId);
//        }else { //活动页 分享 活动详情(H5还没改)
//            webpageURL = URL_H5_SharedArticle(self.detailId);
//        }
    model.webpageURL = webpageURL;
    model.imageURL = thumbnailUrl;
    [self showShareView:model];
}

- (void)showShareView:(SharedModel *)model{
    WEAKSELF
    _slShareView = [[SLShareView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    _slShareView.model = model;
    _slShareView.shareFinish = ^{
        [weakSelf sharedSuccess];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:_slShareView];
}
#pragma mark - 分享
-(void)sharedSuccess{
    WEAKSELF
    NSString *contentId  =[NSString stringWithFormat:@"%@",[self.subJsonDic objectForKey:@"pujaCode"]];
    [[HomeManager sharedInstance]postSharedContentId:contentId Type:@"4" Kind:@"1" MemberId:@"" MemberName:@"" Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
            
            NSString * shareStr = [self getNotnilString:[self.subJsonDic objectForKey:@"forward"]];
            NSInteger forwardsCount = [shareStr integerValue];
            forwardsCount += 1;

            weakSelf.shareLabel.text = [NSString stringWithFormat:@"%ld",forwardsCount];
            weakSelf.shareLabel.hidden = NO;
            [weakSelf.subJsonDic setObject:[NSString stringWithFormat:@"%ld",forwardsCount] forKey:@"forward"];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {

    }];
}

#pragma mark - kvo
//kvo 监听进度 必须实现此方法
//-(void)observeValueForKeyPath:(NSString *)keyPath
//                     ofObject:(id)object
//                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
//                      context:(void *)context{
//    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
//        && object == _webView) {
//        self.progressView.progress = self.webView.estimatedProgress;
//        if (_webView.estimatedProgress >= 1.0f) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                self.progressView.progress = 0;
//            });
//        }
//    }else{
//        [super observeValueForKeyPath:keyPath
//                             ofObject:object
//                               change:change
//                              context:context];
//    }
//}

#pragma mark - WKUIDelegate & WKNavigationDelegate
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self.progressView setProgress:0.0f animated:NO];
     [self.hud hideAnimated:YES];
}

//提交发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.progressView setProgress:0.0f animated:NO];
     [self.hud hideAnimated:YES];
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [self.progressView setProgress:0.0f animated:NO];
     [self.hud hideAnimated:YES];
}

// 接收到服务器跳转请求即服务重定向时之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"1");
}

// 内容开始加载
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
     self.hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"body:%@",message.body);
    
    NSDictionary * jsonDic = [message.body mj_JSONObject];
    if (IsNilOrNull(jsonDic)) {
        return;
    }
    
    NSString * flagStr = jsonDic[@"flag"];
    NSString * subJsonStr = jsonDic[@"json"];
    
    self.subJsonDic = [NSMutableDictionary dictionaryWithDictionary:[subJsonStr mj_JSONObject]];
    
    if ([flagStr isEqualToString:@"closeLoding"]) {
        [self.hud hideAnimated:YES];
    }
    
    if ([flagStr isEqualToString:@"pujaInfo"]) {
        
        NSString * likeCount = [self getNotnilString:[self.subJsonDic objectForKey:@"praises"]];
        NSString * collectCount = [self getNotnilString:[self.subJsonDic objectForKey:@"collections"]];
        NSString * forwardsCount = [self getNotnilString:[self.subJsonDic objectForKey:@"forward"]];
        
        NSString * likeState = [self getNotnilString:[self.subJsonDic objectForKey:@"praisesState"]];
        NSString * collectState = [self getNotnilString:[self.subJsonDic objectForKey:@"collectionsState"]];
        
        self.likeLabel.text = likeCount;
        self.collectLabel.text = collectCount;
        self.shareLabel.text = forwardsCount;
        
        if ([likeState intValue] != 0) {
            [self.likeBtn setSelected:YES];
            self.likeLabel.textColor = WENGEN_RED;
            self.likeLabel.hidden = NO;
        }
        
        if ([collectState intValue] != 0) {
            [self.collectBtn setSelected:YES];
            self.collectLabel.hidden = NO;
            self.collectLabel.textColor = WENGEN_RED;
        }
        return;
    }
    
    if (IsNilOrNull(self.subJsonDic) && self.webType != KfWebView_rite) {
        return;
    }
    
    if ([self.subJsonDic.allKeys containsObject:@"isAuthentication"]) {
        // 实名认证状态 0：未认证 1：已认证 2：审核中
        NSString * isAuthenticationStr = [NSString stringWithFormat:@"%@",self.subJsonDic[@"isAuthentication"]];
        if ([isAuthenticationStr isEqualToString:@"0"]) {
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"您还没有实名认证，请进行实名认证后报名") view:self.view afterDelay:TipSeconds];
            RealNameViewController *realNameVC = [[RealNameViewController alloc]init];
            [self.navigationController pushViewController:realNameVC animated:YES];
            return;
        }
        if ([isAuthenticationStr isEqualToString:@"2"]) {
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"实名认证正在审核中，请耐心等待") view:self.view afterDelay:TipSeconds];
            return;
        }
    }
    
    if (self.webType == KfWebView_activityDetail) {
        // 活动id
        NSString * activityCode = self.subJsonDic[@"activityCode"];
        
        [[DataManager shareInstance] activityCheckedLevel:@{
            @"activityCode":activityCode
        } callbacl:^(NSObject *object) {
            if ([object isKindOfClass:[Message class]] == YES) {
                Message *message = (Message *)object;
                [ShaolinProgressHUD singleTextHud:message.reason view:WINDOWSVIEW afterDelay:TipSeconds];
            }else{
                EnrollmentRegistrationInfoViewController * vc = [EnrollmentRegistrationInfoViewController new];
                vc.flag = flagStr;
                vc.activityCode = activityCode;
                vc.model = (EnrollmentListModel *)object;

                [self.navigationController pushViewController:vc animated:YES];
//                }else{
//                    [SMAlert setConfirmBtBackgroundColor:[UIColor colorForHex:@"8E2B25"]];
//                    [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
//                    [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
//                    [SMAlert setCancleBtTitleColor:[UIColor colorForHex:@"333333"]];
//                    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
//                    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
//                    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 300, 21)];
//                    [title setFont:kMediumFont(15)];
//                    [title setTextColor:[UIColor colorForHex:@"333333"]];
//                    title.text = SLLocalizedString(@"实名认证");
//                    [title setTextAlignment:NSTextAlignmentCenter];
//                    [customView addSubview:title];
//
//                    UILabel *neirongLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(title.frame)+10, 270, 38)];
//                    [neirongLabel setFont:kRegular(13)];
//                    [neirongLabel setTextColor:[UIColor colorForHex:@"333333"]];
//                    neirongLabel.text = SLLocalizedString(@"您还没有实名认证，请进行实名认证");
//                    neirongLabel.numberOfLines = 0;
//                    [customView addSubview:neirongLabel];
//
//                    [SMAlert showCustomView:customView stroke:YES confirmButton:[SMButton initWithTitle:SLLocalizedString(@"实名认证") clickAction:^{
//
//                        //如果没有实名就跳转实名认证
//                        RealNameViewController *realNameVC = [[RealNameViewController alloc]init];
//                        [self.navigationController pushViewController:realNameVC animated:YES];
//
//                    }] cancleButton:[SMButton initWithTitle:SLLocalizedString(@"取消") clickAction:nil]];
//                }
            }
        }];
    }
    
    if (self.webType == KfWebView_mechanismDetail) {
        NSString * mechanismCodeStr = self.subJsonDic[@"mechanismCode"];
        
        InstitutionSignupViewController *institutionSignupVC = [[InstitutionSignupViewController alloc]init];
        institutionSignupVC.mechanismCodeStr = mechanismCodeStr;
        [self.navigationController pushViewController:institutionSignupVC animated:YES];
    }
    
    if (self.webType == KfWebView_applyDetail) {
        NSString * activityCode = self.subJsonDic[@"activityCode"];
        
        EnrollmentRegistrationInfoViewController * vc = [EnrollmentRegistrationInfoViewController new];
        vc.flag = flagStr;
        vc.activityCode = activityCode;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (self.webType == KfWebView_rite && self.subJsonDic && self.subJsonDic.count) {
        //1:水路法会 2 普通法会 3 全年佛事 4 建寺安僧
        NSString * pujaType = self.subJsonDic[@"pujaType"] ? [NSString stringWithFormat:@"%@",self.subJsonDic[@"pujaType"]] : @"";
        NSString *pujaCode = self.subJsonDic[@"pujaCode"] ? [NSString stringWithFormat:@"%@", self.subJsonDic[@"pujaCode"]] : @"";
        RiteRegistrationFormViewController *vc = [[RiteRegistrationFormViewController alloc] init];
        vc.pujaType = pujaType;
        vc.pujaCode = pujaCode;
        [self.navigationController pushViewController:vc animated:YES];
//        if ([pujaType isEqualToString:@"1"] || [pujaType isEqualToString:@"2"]) {
//            RiteSLRegistrationFormViewController * vc = [RiteSLRegistrationFormViewController new];
//            [self.navigationController pushViewController:vc animated:YES];
//        } else if ([pujaType isEqualToString:@"3"]) {
//            [ShaolinProgressHUD singleTextAutoHideHud:@"全年佛事类型错误"];
//        } else if ([pujaType isEqualToString:@"4"]) {
//            RiteBuildRegistrationFormViewController * vc = [RiteBuildRegistrationFormViewController new];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
    }
}

#pragma mark - getter / setter
- (WKWebView *)webView{
    if (!_webView){
        WKWebViewConfiguration *config = [WKWebViewConfiguration new];
        config.preferences = [WKPreferences new];
        config.preferences.minimumFontSize = 10;
        config.preferences.javaScriptEnabled = YES;
        config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        
        
        [config.userContentController addScriptMessageHandler:self name:@"H5inFormLocal"];
        
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBar_Height) configuration:config];
        [_webView setAllowsLinkPreview:NO];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
//    [self.webView addObserver:self
//                   forKeyPath:@"estimatedProgress"
//                      options:0
//                      context:nil];

// UserAgent中添加"shaolin"，用于给h5标识该请求是通过app端发起的
        typeof(_webView) weakWebView = _webView;
        [_webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
            NSString *oldUserAgent = result;
            NSString *newUserAgent = [NSString stringWithFormat:@"%@ %@",oldUserAgent,@"shaolin"];
            weakWebView.customUserAgent = newUserAgent;
        }];
    }
    return _webView;
}
-(UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(21, 40, 35, 35)];
        [_backButton setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backHandle) forControlEvents:UIControlEventTouchUpInside];
        _backButton.hidden = YES;
    }
    return _backButton;
}

-(UIButton *)collectBtn{
    if (!_collectBtn) {
        _collectBtn = [[UIButton alloc] init];
        [_collectBtn setImage:[UIImage imageNamed:@"focus_normal"] forState:(UIControlStateNormal)];
        [_collectBtn setImage:[UIImage imageNamed:@"focus_select"] forState:(UIControlStateSelected)];
        [_collectBtn addTarget:self action:@selector(collectAction) forControlEvents:(UIControlEventTouchUpInside)];
        _collectBtn.hidden = YES;
    }
    return _collectBtn;
}

-(UILabel *)collectLabel{
    if (!_collectLabel) {
        _collectLabel = [[UILabel alloc] init];
        _collectLabel.textColor = [UIColor colorForHex:@"333333"];   //BE0B1F
        _collectLabel.font = kRegular(8);
        _collectLabel.text= @"";
        [_collectLabel setTextAlignment:NSTextAlignmentLeft];
    }
    return _collectLabel;
}

-(UIButton *)likeBtn{
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_likeBtn setImage:[UIImage imageNamed:@"praise_normal"] forState:(UIControlStateNormal)];
        [_likeBtn setImage:[UIImage imageNamed:@"praise_select"] forState:(UIControlStateSelected)];
        [_likeBtn addTarget:self action:@selector(likeAction) forControlEvents:(UIControlEventTouchUpInside)];
        _likeBtn.hidden = YES;
    }
    return _likeBtn;
}

-(UILabel *)likeLabel{
    if (!_likeLabel) {
        _likeLabel = [[UILabel alloc] init];
        _likeLabel.textColor = [UIColor colorForHex:@"333333"];   //BE0B1F
        _likeLabel.font = kRegular(8);
        _likeLabel.text= @"";
    }
    return _likeLabel;
}

-(UIButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_shareBtn setImage:[UIImage imageNamed:@"share_normal"] forState:(UIControlStateNormal)];
        [_shareBtn addTarget:self action:@selector(shareAction) forControlEvents:(UIControlEventTouchUpInside)];
        _shareBtn.hidden = YES;
    }
    return _shareBtn;
}

-(UILabel *)shareLabel{
    if (!_shareLabel) {
        _shareLabel = [[UILabel alloc] init];
        _shareLabel.textColor = [UIColor colorForHex:@"333333"];   //BE0B1F
        _shareLabel.font = kRegular(8);
        _shareLabel.text= @"";
    }
    return _shareLabel;
}

-(NSMutableDictionary *)subJsonDic {
    if (!_subJsonDic) {
        _subJsonDic = [NSMutableDictionary new];
    }
    return _subJsonDic;
}

-(NSString *)getNotnilString:(NSString *)string {
    if ([string isKindOfClass:[NSNumber class]]) {
         NSString * temp = [NSString stringWithFormat:@"%@",string];
           return NotNilAndNull(temp)?temp:@"";
    }
    if ([string isKindOfClass:[NSString class]]) {
        return NotNilAndNull(string)?string:@"";
    }
    return @"";
}

#pragma mark - device
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
@end
