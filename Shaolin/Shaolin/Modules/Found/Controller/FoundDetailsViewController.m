//
//  FoundDetailsViewController.m
//  Shaolin
//
//  Created by edz on 2020/3/24.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "FoundDetailsViewController.h"
#import <WebKit/WebKit.h>
#import "HomeManager.h"
#import "SLShareView.h"
#import "DefinedHost.h"
#import "UIButton+HitBounds.h"
#import "ThumbFollowShareManager.h"

@interface FoundDetailsViewController ()<WKUIDelegate,WKNavigationDelegate, WKScriptMessageHandler>
//@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic, copy) NSString *detailId;

@property(nonatomic,strong) UIButton *focusBtn;//收藏
@property(nonatomic,strong) UILabel *focusLabel;

@property(nonatomic,strong) UIButton *praiseBtn;//点赞
@property(nonatomic,strong) UILabel *praiseLabel;

@property(nonatomic,strong) UIButton *shareBtn;//分享
@property(nonatomic,strong) UILabel *shareLabel;
@property(nonatomic,strong) WKWebView *webView;
@property(nonatomic,strong) NSMutableDictionary *dataDic;
@property(nonatomic,strong) SLShareView *slShareView;

@property(nonatomic, strong)MBProgressHUD *hud;

@end

@implementation FoundDetailsViewController
- (instancetype)init{
    self = [super init];
    if (self){
        self.isInteractive = YES;
    }
    return self;
}
- (NSMutableDictionary *)dataDic
{
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}
//- (UIScrollView *)scrollView {
//    if (!_scrollView) {
//         _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NavBar_Height+1, kWidth, kHeight)];
//        //设置画布大小，一般比frame大，这里设置横向能拖动4张图片的范围
//         _scrollView.contentSize = CGSizeMake(kWidth, kHeight);
//    }
//    return _scrollView;
//}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (!self.navigationController || self.navigationController.viewControllers.count == 1) {
        
//        [self wr_setNavBarBackgroundAlpha:0];
        [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"H5inFormLocal"];
    }
}

- (void)dealloc{
    
    [self.webView setNavigationDelegate:nil];
    [self.webView setUIDelegate:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.hideNavigationBarView && !self.hideNavigationBar){
        self.hideNavigationBarView = YES;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    [self setupWebView];
    [self setData];
    [self reloadNavigationBarButtonsHiddenState];
//    if ([self.stateStr isEqualToString:@"2"]) {
//        self.focusBtn.hidden = YES;
//        self.focusLabel.hidden = YES;
//        self.praiseBtn.hidden = YES;
//        self.praiseLabel.hidden = YES;
//        self.shareBtn.hidden = YES;
//        self.shareLabel.hidden = YES;
//    }
}

- (void)reloadNavigationBarButtonsHiddenState {
    if ([self.dataDic allKeys].count == 0 || !self.isInteractive) {
        self.focusBtn.hidden = YES;
        self.focusLabel.hidden = YES;
        self.praiseBtn.hidden = YES;
        self.praiseLabel.hidden = YES;
        self.shareBtn.hidden = YES;
        self.shareLabel.hidden = YES;
    } else {
        self.focusBtn.hidden = NO;
        self.focusLabel.hidden = NO;
        self.praiseBtn.hidden = NO;
        self.praiseLabel.hidden = NO;
        self.shareBtn.hidden = NO;
        self.shareLabel.hidden = NO;
    }
}

- (void)setData
{
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
//    [[HomeManager sharedInstance] getArticleDetails:self.idStr tabbarStr:self.tabbarStr otherParams:^NSDictionary * _Nonnull{
//        if ([self.tabbarStr isEqualToString:@"Found"] && self.stateStr) { return @{@"state" : self.stateStr}; }
//        return nil;
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        [hud hideAnimated:YES];
//        NSLog(@"%@",responseObject);
//        if ([[responseObject objectForKey:@"code"] integerValue]==200) {
//            NSArray *arr = [[responseObject objectForKey:@"data"] objectForKey:@"data"];
//            NSDictionary *dic ;
//            for (NSDictionary *dicc in arr) {
//                dic = dicc;
//            }
//            
//            self.dataDic = [[NSMutableDictionary alloc]initWithDictionary:dic];;
//            NSLog(@"%@",self.dataDic);
//            [self assignment:dic];
//            
//        }
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        [hud hideAnimated:YES];
//    }];
//    
    
    [[HomeManager sharedInstance]getArticleDetails:self.idStr tabbarStr:self.tabbarStr otherParams:^NSDictionary * _Nonnull{
        if ([self.tabbarStr isEqualToString:@"Found"] && self.stateStr) {
            return @{@"state" : self.stateStr};
            
        }
        return nil;
    } success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable responseObject, NSString * _Nullable errorReason) {
        [hud hideAnimated:YES];
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] integerValue]==200) {
            NSArray *arr = [[responseObject objectForKey:@"data"] objectForKey:@"data"];
            NSDictionary *dic ;
            for (NSDictionary *dicc in arr) {
                dic = dicc;
            }
            dic = [ThumbFollowShareManager reloadDictByLocalCache:dic modelItemType:FoundItemType modelItemKind:ImageText];
            self.dataDic = [[NSMutableDictionary alloc]initWithDictionary:dic];;
            NSLog(@"%@",self.dataDic);
            [self assignment:dic];
            [self reloadNavigationBarButtonsHiddenState];
            [self reloadNavigationButtons];
        }
    }];
    
}

#pragma mark - 赋值
- (void)assignment:(NSDictionary *)dic
{
    if (IsNilOrNull(dic)) {
        return;
    }
    NSString *urlStr;
    self.detailId = [dic objectForKey:@"id"];
    NSString * token = [SLAppInfoModel sharedInstance].accessToken;
    if ([self.tabbarStr isEqualToString:@"Found"]) {
        urlStr = URL_H5_ArticleDetail(self.detailId, token);
    }else {
        urlStr = URL_H5_ActivityDetail(self.detailId, token);
    }
    
    
    self.hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.hud hideAnimated:YES];
    });
    
    NSURL *baseURL = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:baseURL];
    
    [self.webView loadRequest:request];
}

- (void)reloadNavigationButtons {
    // 收藏个数
    self.focusLabel.hidden = [[self.dataDic objectForKey:@"collection"] integerValue] == 0;
    self.focusLabel.text = [NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"collection"]];
    // 点赞数
    self.praiseLabel.hidden = [[self.dataDic objectForKey:@"praise"] integerValue] == 0;
    self.praiseLabel.text = [NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"praise"]];
    // 分享数
    self.shareLabel.hidden = [[self.dataDic objectForKey:@"forward"] integerValue] == 0;
    self.shareLabel.text = [NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"forward"]];
    
    if ([[self.dataDic objectForKey:@"praiseState"] boolValue]) {
        [self.praiseBtn setSelected:YES];
        [self.praiseBtn setImage:[UIImage imageNamed:@"praise_select_yellow"] forState:UIControlStateNormal];
        self.praiseLabel.textColor = kMainYellow;
    }else
    {
        [self.praiseBtn setSelected:NO];
        [self.praiseBtn setImage:[UIImage imageNamed:@"praise_normal"] forState:UIControlStateNormal];
        self.praiseLabel.textColor = KTextGray_333;
    }
    
    if ([[self.dataDic objectForKey:@"collectionState"] boolValue]) {
        [self.focusBtn setSelected:YES];
        [self.focusBtn setImage:[UIImage imageNamed:@"focus_select_yellow"] forState:UIControlStateNormal];
        self.focusLabel.textColor = kMainYellow;
    }else
    {
        [self.focusBtn setSelected:NO];
        [self.focusBtn setImage:[UIImage imageNamed:@"focus_normal"] forState:UIControlStateNormal];
        self.focusLabel.textColor = KTextGray_333;
    }
}
- (void)setupWebView
{
    
    WKWebViewConfiguration *webConfiguration = [WKWebViewConfiguration new];
    
    // 创建UserContentController（提供JavaScript向webView发送消息的方法）
    WKUserContentController* userContent = [[WKUserContentController alloc] init];
    // 添加消息处理，注意：self指代的对象需要遵守WKScriptMessageHandler协议，结束时需要移除
    [userContent addScriptMessageHandler:self name:@"H5inFormLocal"];
    // 将UserConttentController设置到配置文件
    webConfiguration.userContentController = userContent;
    
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NavBar_Height+1, kWidth, kHeight-NavBar_Height-1) configuration:webConfiguration];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    [_webView setAllowsLinkPreview:NO];
    
    
    [_webView.scrollView setShowsVerticalScrollIndicator:NO];
    [_webView.scrollView setShowsHorizontalScrollIndicator:NO];
    
    [self.view addSubview:self.webView];
    //    _webView.scrollView.scrollEnabled = NO;
    //    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    //    [self.scrollView addSubview:self.webView];
    
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    if (webView.isLoading) {
        return;
    }
    //     [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '140%'"completionHandler:nil];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [self.hud hideAnimated:YES];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    NSLog(@"message.body : %@", message.body);
    
    NSDictionary * jsonDic = [message.body mj_JSONObject];
    if (IsNilOrNull(jsonDic)) {
        return;
    }
    
    NSString * flagStr = jsonDic[@"flag"];
    if ([flagStr isEqualToString:@"closeLoding"]) {
        [self.hud hideAnimated:YES];
    }
}


- (void)setupUI
{
    UIView *viewBg = [[UIView alloc]initWithFrame:CGRectMake(0, NavBar_Height, kWidth, 1)];
    viewBg.backgroundColor = RGBA(216, 216, 216, 1);
    [self.view addSubview:viewBg];
    
    UIButton *leftBtn =[[UIButton alloc]init];
    [leftBtn setImage:[UIImage imageNamed:@"left"] forState:(UIControlStateNormal)];
    [leftBtn addTarget:self action:@selector(leftAction) forControlEvents:(UIControlEventTouchUpInside)];
    [leftBtn setEnlargeEdgeWithTop:15 right:15 bottom:15 left:15];
    [self.view addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(9);
        make.top.mas_equalTo(10+StatueBar_Height);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
    [self.view addSubview:self.shareBtn];
    [self.view addSubview:self.shareLabel];
    [self.view addSubview:self.praiseBtn];
    [self.view addSubview:self.praiseLabel];
    [self.view addSubview:self.focusBtn];
    [self.view addSubview:self.focusLabel];
    
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-29);
        make.top.mas_equalTo(10.5+StatueBar_Height);
        make.width.mas_equalTo(21);
        make.height.mas_equalTo(19);
    }];
    [self.shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.shareBtn.mas_right);
        
        make.centerY.mas_equalTo(self.praiseLabel);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(19);
    }];
    [self.praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.shareBtn.mas_left).offset(-20);
        make.top.mas_equalTo(10.5+StatueBar_Height);
        make.width.mas_equalTo(19);
        make.height.mas_equalTo(19);
    }];
    [self.praiseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.praiseBtn.mas_right);
        make.centerY.mas_equalTo(self.praiseBtn.mas_top);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(19);
    }];
    
    [self.focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.praiseBtn.mas_left).offset(-20);
        make.top.mas_equalTo(10.5+StatueBar_Height);
        make.width.mas_equalTo(19);
        make.height.mas_equalTo(19);
    }];
    [self.focusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.focusBtn.mas_right);
        make.centerY.mas_equalTo(self.focusBtn.mas_top);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(19);
    }];
    
}

- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIButton *)focusBtn
{
    if (!_focusBtn) {
        _focusBtn = [[UIButton alloc] init];
        [_focusBtn setImage:[UIImage imageNamed:@"focus_normal"] forState:(UIControlStateNormal)];
        [_focusBtn setImage:[UIImage imageNamed:@"focus_select_yellow"] forState:(UIControlStateSelected)];
        [_focusBtn addTarget:self action:@selector(foucsAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _focusBtn;
}
- (void)foucsAction:(UIButton *)btn
{
    
    if (btn.selected) {//取消收藏
        
        [self foucsCancle:btn];
        NSLog(@"====");
    }else
    {  //收藏
        [self foucsSuccess:btn];
        
        
        NSLog(@"LLLLLL");
    }
}
#pragma mark - 收藏成功
- (void)foucsSuccess:(UIButton *)btn
{
    
    NSString *contentId  =[NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"id"]];
    [[HomeManager sharedInstance]postCollectionContentId:contentId Type:self.typeStr Kind:@"1" MemberId:@"" MemberName:@"" Success:^(NSDictionary * _Nullable resultDic) {
        NSInteger likeCount = [[self.dataDic objectForKey:@"collection"] integerValue];
        likeCount += 1;
        [self.dataDic setObject:@"1" forKey:@"collectionState"];
        [self.dataDic setObject:[NSString stringWithFormat:@"%ld",likeCount] forKey:@"collection"];
        [self reloadNavigationButtons];
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"收藏成功") view:self.view afterDelay:TipSeconds];
    } failure:^(NSString * _Nullable errorReason) {
        [ShaolinProgressHUD singleTextHud:errorReason view:self.view afterDelay:TipSeconds];
    } finish:^(NSDictionary * _Nullable responseObject, NSString * _Nullable errorReason) {
//        NSLog(@"%@",responseObject);
//        if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
//
//            NSInteger likeCount = [[self.dataDic objectForKey:@"collection"] integerValue];
//            likeCount += 1;
//            [self.dataDic setObject:@"1" forKey:@"collectionState"];
//            [self.dataDic setObject:[NSString stringWithFormat:@"%ld",likeCount] forKey:@"collection"];
//            [self reloadNavigationButtons];
//            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"收藏成功") view:self.view afterDelay:TipSeconds];
//        }else
//        {
//            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"message"] view:self.view afterDelay:TipSeconds];
//        }
    }];
    
}
#pragma mark - 取消收藏
- (void)foucsCancle:(UIButton *)btn
{
    NSString *strId = [NSString stringWithFormat:@"%@", [self.dataDic objectForKey:@"id"]];
    NSMutableArray *arr = [NSMutableArray array];
    NSDictionary *dic = @{@"contentId":strId,@"type":self.typeStr, @"kind" : @"1"};
    [arr addObject:dic];
    [[HomeManager sharedInstance]postCollectionCancleArray:arr WithBlock:^(id  _Nonnull responseObject, NSString * _Nonnull error) {
        NSLog(@"%@",responseObject);
        NSInteger likeCount = [[self.dataDic objectForKey:@"collection"] integerValue];
        likeCount --;
        if (likeCount < 0) likeCount = 0;
        [self.dataDic setObject:@"0" forKey:@"collectionState"];
        [self.dataDic setObject:[NSString stringWithFormat:@"%ld",likeCount] forKey:@"collection"];
        [self reloadNavigationButtons];
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"取消收藏") view:self.view afterDelay:TipSeconds];
//        if ([[responseObject objectForKey:@"code"] integerValue]== 200) {
//
//
//        }else
//        {
//            [ShaolinProgressHUD singleTextHud:error view:self.view afterDelay:TipSeconds];
//        }
    }];
}
- (UILabel *)focusLabel
{
    if (!_focusLabel) {
        _focusLabel = [[UILabel alloc] init];
        _focusLabel.textColor = KTextGray_333;   //BE0B1F
        _focusLabel.font = kRegular(8);
        _focusLabel.text= @"";
        [_focusLabel setTextAlignment:NSTextAlignmentLeft];
    }
    return _focusLabel;
}
- (UIButton *)praiseBtn
{
    if (!_praiseBtn) {
        
        _praiseBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_praiseBtn setImage:[UIImage imageNamed:@"praise_normal"] forState:(UIControlStateNormal)];
        [_praiseBtn setImage:[UIImage imageNamed:@"praise_select_yellow"] forState:(UIControlStateSelected)];
        [_praiseBtn addTarget:self action:@selector(praiseAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _praiseBtn;
}
- (void)praiseAction:(UIButton *)btn
{
    if (btn.selected) { //取消点赞
        [self praiseCancle:btn];
        NSLog(@"====");
    }else
    {   //点赞
        [self praiseSuccess:btn];
        NSLog(@"LLLLLL");
    }
}
#pragma mark - 点赞成功
- (void)praiseSuccess:(UIButton *)btn
{
    
    NSString *contentId  =[NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"id"]];
    [[HomeManager sharedInstance]postPraiseContentId:contentId Type:self.typeStr Kind:@"1" MemberId:@"" MemberName:@"" Success:^(NSDictionary * _Nullable resultDic) {
        NSInteger likeCount = [[self.dataDic objectForKey:@"praise"] integerValue];
        likeCount += 1;
        [self.dataDic setObject:@"1" forKey:@"praiseState"];
        [self.dataDic setObject:[NSString stringWithFormat:@"%ld",likeCount] forKey:@"praise"];
        [self reloadNavigationButtons];
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"点赞成功") view:self.view afterDelay:TipSeconds];
    } failure:^(NSString * _Nullable errorReason) {
        [ShaolinProgressHUD singleTextHud:errorReason view:self.view afterDelay:TipSeconds];
    } finish:^(NSDictionary * _Nullable responseObject, NSString * _Nullable errorReason) {
//        NSLog(@"%@",responseObject);
//        if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
//
//
//
//        }else
//        {
//            [ShaolinProgressHUD singleTextHud:errorReason view:self.view afterDelay:TipSeconds];
//        }
    }];
}
#pragma mark - 取消点赞
- (void)praiseCancle:(UIButton *)btn
{
    
    NSString *strId = [NSString stringWithFormat:@"%@", [self.dataDic objectForKey:@"id"]];
    NSMutableArray *arr = [NSMutableArray array];
    NSDictionary *dic = @{@"contentId":strId,@"type":self.typeStr, @"kind":@"1"};
    [arr addObject:dic];
    [[HomeManager sharedInstance]postPraiseCancleArray:arr WithBlock:^(id  _Nonnull responseObject, NSString * _Nonnull error) {
        NSLog(@"%@",responseObject);
        NSInteger likeCount = [[self.dataDic objectForKey:@"praise"] integerValue];
        likeCount --;
        if (likeCount < 0) likeCount = 0;
        [self.dataDic setObject:@"0" forKey:@"praiseState"];
        [self.dataDic setObject:[NSString stringWithFormat:@"%ld",likeCount] forKey:@"praise"];
        [self reloadNavigationButtons];
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"取消点赞") view:self.view afterDelay:TipSeconds];
//        if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
//
//        }else
//        {
//            [ShaolinProgressHUD singleTextHud:error view:self.view afterDelay:TipSeconds];
//        }
    }];
}
#pragma mark - 分享
- (void)sharedSuccess{
    WEAKSELF
    NSString *contentId  =[NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"id"]];
    //    [[HomeManager sharedInstance]postSharedContentId:contentId Type:self.typeStr Kind:@"1" MemberId:@"" MemberName:@"" Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
    //        NSLog(@"%@",responseObject);
    //        if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
    //            NSInteger forwardsCount = [[self.dataDic objectForKey:@"forwards"] integerValue];
    //            forwardsCount += 1;
    //
    //            weakSelf.shareLabel.text = [NSString stringWithFormat:@"%ld",forwardsCount];
    //            weakSelf.shareLabel.hidden = NO;
    //            [weakSelf.dataDic setObject:[NSString stringWithFormat:@"%ld",forwardsCount] forKey:@"forwards"];
    //        }
    //    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
    //
    //    }];
    
    
    [[HomeManager sharedInstance]postSharedContentId:contentId Type:self.typeStr Kind:@"1" MemberId:@"" MemberName:@"" Success:^(NSDictionary * _Nullable resultDic) {
        NSInteger forwardsCount = [[self.dataDic objectForKey:@"forward"] integerValue];
        forwardsCount += 1;
        
        weakSelf.shareLabel.text = [NSString stringWithFormat:@"%ld",forwardsCount];
        weakSelf.shareLabel.hidden = NO;
        [weakSelf.dataDic setObject:[NSString stringWithFormat:@"%ld",forwardsCount] forKey:@"forward"];
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable responseObject, NSString * _Nullable errorReason) {
        
//        if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
//
//        }
    }];
}


- (UILabel *)praiseLabel
{
    if (!_praiseLabel) {
        _praiseLabel = [[UILabel alloc] init];
        _praiseLabel.textColor = KTextGray_333;   //BE0B1F
        _praiseLabel.font = kRegular(8);
        _praiseLabel.text= @"";
    }
    return _praiseLabel;
}
- (UIButton *)shareBtn
{
    if (!_shareBtn) {
        
        _shareBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_shareBtn setImage:[UIImage imageNamed:@"share_normal"] forState:(UIControlStateNormal)];
        [_shareBtn addTarget:self action:@selector(shareAction) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _shareBtn;
}
- (void)shareAction {
    SharedModel *model = [[SharedModel alloc] init];
    model.type = SharedModelURLType;
    model.titleStr = [self.dataDic objectForKey:@"title"];
    model.descriptionStr = [self.dataDic objectForKey:@"abstracts"];
    
    NSString *webpageURL = @"";
    if ([self.tabbarStr isEqualToString:@"Found"]) { //发现页 分享 文章详情(暂时只在dev可以，其他环境下该链接是空页)
        webpageURL = URL_H5_SharedArticleDetail(self.detailId);
    }else { //活动页 分享 活动详情(H5还没改)
        webpageURL = URL_H5_SharedArticle(self.detailId);
    }
    model.webpageURL = webpageURL;
    model.image = self.showImage;//[SharedModel toThumbImage:self.showImage];
    
    NSMutableArray *imgArr = [NSMutableArray array];
    NSArray *arr = [self.dataDic objectForKey:@"coverUrlList"];
    if (!IsNilOrNull(arr)) {
        for (NSDictionary *dic in arr) {
            NSString *str = [dic objectForKey:@"route"];
            [imgArr addObject:str];
        }
        if (imgArr.count){
            model.imageURL = imgArr.firstObject;
        }
    }
    WEAKSELF
    _slShareView = [[SLShareView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    _slShareView.model = model;
    _slShareView.shareFinish = ^{
        [weakSelf sharedSuccess];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:_slShareView];
    
}
- (UILabel *)shareLabel
{
    if (!_shareLabel) {
        _shareLabel = [[UILabel alloc] init];
        _shareLabel.textColor = KTextGray_333;   //BE0B1F
        _shareLabel.font = kRegular(8);
        _shareLabel.text= @"";
    }
    return _shareLabel;
}


- (NSString *)compaareCurrentTime:(NSDate *)compareDate
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    
    timeInterval = -timeInterval;
    
    long temp = 0;
    
    NSString *result;
    
    if (timeInterval < 60) {
        
        result = SLLocalizedString(@"刚刚");
        
    }
    
    else if((temp = timeInterval/60) <60){
        
        result = [NSString stringWithFormat:SLLocalizedString(@"%ld分钟前"),temp];
        
    }
    
    
    
    else if((temp = temp/60) <24){
        
        result = [NSString stringWithFormat:SLLocalizedString(@"%ld小时前"),temp];
        
    }
    
    
    
    else if((temp = temp/24) <30){
        
        result = [NSString stringWithFormat:SLLocalizedString(@"%ld天前"),temp];
        
    }
    
    
    
    else if((temp = temp/30) <12){
        
        result = [NSString stringWithFormat:SLLocalizedString(@"%ld月前"),temp];
        
    }
    
    else{
        
        temp = temp/12;
        
        result = [NSString stringWithFormat:SLLocalizedString(@"%ld年前"),temp];
        
    }
    
    return  result;
    
}
- (NSDate *)nsstringConversionNSDate:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datestr = [dateFormatter dateFromString:dateStr];
    return datestr;
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
