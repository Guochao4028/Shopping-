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
@property(nonatomic) BOOL originNavigationBarHidden;

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
-(NSMutableDictionary *)dataDic
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
    self.originNavigationBarHidden = self.navigationController.navigationBar.hidden;
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = self.originNavigationBarHidden;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    [self setupWebView];
    [self setData];
    if (!self.isInteractive){
        self.focusBtn.hidden = YES;
        self.focusLabel.hidden = YES;
        self.praiseBtn.hidden = YES;
        self.praiseLabel.hidden = YES;
        self.shareBtn.hidden = YES;
        self.shareLabel.hidden = YES;
    }
//    if ([self.stateStr isEqualToString:@"2"]) {
//        self.focusBtn.hidden = YES;
//        self.focusLabel.hidden = YES;
//        self.praiseBtn.hidden = YES;
//        self.praiseLabel.hidden = YES;
//        self.shareBtn.hidden = YES;
//        self.shareLabel.hidden = YES;
//    }
}

-(void)setData
{
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[HomeManager sharedInstance] getArticleDetails:self.idStr tabbarStr:self.tabbarStr otherParams:^NSDictionary * _Nonnull{
        if ([self.tabbarStr isEqualToString:@"Found"] && self.stateStr) { return @{@"state" : self.stateStr}; }
        return nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [hud hideAnimated:YES];
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] integerValue]==200) {
            NSArray *arr = [[responseObject objectForKey:@"data"] objectForKey:@"data"];
            NSDictionary *dic ;
            for (NSDictionary *dicc in arr) {
                dic = dicc;
            }
            
            self.dataDic = [[NSMutableDictionary alloc]initWithDictionary:dic];;
            NSLog(@"%@",self.dataDic);
            [self assignment:dic];
            
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [hud hideAnimated:YES];
    }];
    
    
}

#pragma mark - 赋值
-(void)assignment:(NSDictionary *)dic
{
    if (IsNilOrNull(dic)) {
        return;
    }
    NSString *htmlStr;
    self.detailId = [dic objectForKey:@"id"];
    NSString * token = [SLAppInfoModel sharedInstance].access_token;
    if ([self.tabbarStr isEqualToString:@"Found"]) {
        htmlStr = URL_H5_ArticleDetail(self.detailId, token);
    }else {
        htmlStr = URL_H5_ActivityDetail(self.detailId, token);
    }
    
    
    
    NSURL *baseURL = [NSURL URLWithString:htmlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:baseURL];
    
    [self.webView loadRequest:request];
    
    
    
    // 收藏个数
    if ([[dic objectForKey:@"collections"] integerValue]==0) {
        self.focusLabel.hidden = YES;
    }else
    {
        self.focusLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"collections"]];
    }
    // 点赞数
    if ([[dic objectForKey:@"praises"] integerValue]==0) {
        self.praiseLabel.hidden = YES;
    }else
    {
        self.praiseLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"praises"]];
    }
    // 分享数
    if ([[dic objectForKey:@"forwards"] integerValue]==0) {
        self.shareLabel.hidden = YES;
    }else
    {
        self.shareLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"forwards"]];
    }
    if ([[dic objectForKey:@"praise"] integerValue]==1) {
        [self.praiseBtn setSelected:NO];
        self.praiseLabel.textColor = [UIColor colorForHex:@"333333"];
    }else
    {
        [self.praiseBtn setSelected:YES];
        self.praiseLabel.textColor = [UIColor colorForHex:@"BE0B1F"];
    }
    if ([[dic objectForKey:@"collection"] integerValue]==1) {
        [self.focusBtn setSelected:NO];
        self.focusLabel.textColor = [UIColor colorForHex:@"333333"];
    }else
    {
        [self.focusBtn setSelected:YES];
        self.focusLabel.textColor = [UIColor colorForHex:@"BE0B1F"];
    }
}
-(void)setupWebView
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

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    if (webView.isLoading) {
        return;
    }
    //     [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '140%'"completionHandler:nil];
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


-(void)setupUI
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
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(10.5+StatueBar_Height);
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

-(void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIButton *)focusBtn
{
    if (!_focusBtn) {
        _focusBtn = [[UIButton alloc] init];
        [_focusBtn setImage:[UIImage imageNamed:@"focus_normal"] forState:(UIControlStateNormal)];
        [_focusBtn setImage:[UIImage imageNamed:@"focus_select"] forState:(UIControlStateSelected)];
        [_focusBtn addTarget:self action:@selector(foucsAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _focusBtn;
}
-(void)foucsAction:(UIButton *)btn
{
    
    btn.selected = !btn.selected;
    if (btn.selected) { //收藏成功调用的
        [self foucsSuccess:btn];
        
        NSLog(@"====");
    }else
    {  //取消收藏
        [self foucsCancle:btn];
        
        NSLog(@"LLLLLL");
    }
}
#pragma mark - 收藏成功
-(void)foucsSuccess:(UIButton *)btn
{
    
    NSString *contentId  =[NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"id"]];
    [[HomeManager sharedInstance]postCollectionContentId:contentId Type:self.typeStr Kind:@"1" MemberId:@"" MemberName:@"" Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
            
            NSInteger likeCount = [[self.dataDic objectForKey:@"collections"] integerValue];
            likeCount += 1;
            
            
            [btn setSelected:YES];
            self.focusLabel.text = [NSString stringWithFormat:@"%ld",likeCount];
            self.focusLabel.hidden = NO;
            [self.dataDic setObject:[NSString stringWithFormat:@"%ld",likeCount] forKey:@"collections"];
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"收藏成功") view:self.view afterDelay:TipSeconds];
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
    
    
    NSString *strId = [NSString stringWithFormat:@"%@", [self.dataDic objectForKey:@"id"]];
    NSMutableArray *arr = [NSMutableArray array];
    NSDictionary *dic = @{@"contentId":strId,@"type":self.typeStr};
    [arr addObject:dic];
    [[HomeManager sharedInstance]postCollectionCancleArray:arr WithBlock:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] integerValue]== 200) {
            
            NSInteger likeCount = [[self.dataDic objectForKey:@"collections"] integerValue];
            likeCount --;
            
            
            [btn setSelected:NO];
            if (likeCount == 0) {
                self.focusLabel.hidden = YES;
            }else
            {
                self.focusLabel.text = [NSString stringWithFormat:@"%ld",likeCount];
            }
            
            [self.dataDic setObject:[NSString stringWithFormat:@"%ld",likeCount] forKey:@"collections"];
            
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"取消收藏") view:self.view afterDelay:TipSeconds];
        }else
        {
            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"message"] view:self.view afterDelay:TipSeconds];
        }
    }];
}
-(UILabel *)focusLabel
{
    if (!_focusLabel) {
        _focusLabel = [[UILabel alloc] init];
        _focusLabel.textColor = [UIColor colorForHex:@"333333"];   //BE0B1F
        _focusLabel.font = kRegular(8);
        _focusLabel.text= @"";
        [_focusLabel setTextAlignment:NSTextAlignmentLeft];
    }
    return _focusLabel;
}
-(UIButton *)praiseBtn
{
    if (!_praiseBtn) {
        
        _praiseBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_praiseBtn setImage:[UIImage imageNamed:@"praise_normal"] forState:(UIControlStateNormal)];
        [_praiseBtn setImage:[UIImage imageNamed:@"praise_select"] forState:(UIControlStateSelected)];
        [_praiseBtn addTarget:self action:@selector(praiseAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _praiseBtn;
}
-(void)praiseAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) { //收藏成功调用的
        [self praiseSuccess:btn];
        
        NSLog(@"====");
    }else
    {  //取消收藏
        [self praiseCancle:btn];
        
        NSLog(@"LLLLLL");
    }
}
#pragma mark - 点赞成功
-(void)praiseSuccess:(UIButton *)btn
{
    
    NSString *contentId  =[NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"id"]];
    [[HomeManager sharedInstance]postPraiseContentId:contentId Type:self.typeStr Kind:@"1" MemberId:@"" MemberName:@"" Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
            
            
            NSInteger likeCount = [[self.dataDic objectForKey:@"praises"] integerValue];
            likeCount += 1;
            
            
            [btn setSelected:YES];
            self.praiseLabel.text = [NSString stringWithFormat:@"%ld",likeCount];
            self.praiseLabel.hidden = NO;
            [self.dataDic setObject:[NSString stringWithFormat:@"%ld",likeCount] forKey:@"praises"];
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"点赞成功") view:self.view afterDelay:TipSeconds];
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
    
    NSString *strId = [NSString stringWithFormat:@"%@", [self.dataDic objectForKey:@"id"]];
    NSMutableArray *arr = [NSMutableArray array];
    NSDictionary *dic = @{@"contentId":strId,@"type":self.typeStr};
    [arr addObject:dic];
    [[HomeManager sharedInstance]postPraiseCancleArray:arr WithBlock:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] integerValue]== 200) {
            
            NSInteger likeCount = [[self.dataDic objectForKey:@"praises"] integerValue];
            likeCount --;
            
            [btn setSelected:NO];
            if (likeCount == 0) {
                self.praiseLabel.hidden = YES;
            }else
            {
                self.praiseLabel.text = [NSString stringWithFormat:@"%ld",likeCount];
            }
            
            [self.dataDic setObject:[NSString stringWithFormat:@"%ld",likeCount] forKey:@"praises"];
            
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"取消点赞") view:self.view afterDelay:TipSeconds];
        }else
        {
            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"message"] view:self.view afterDelay:TipSeconds];
        }
    }];
}
#pragma mark - 分享
-(void)sharedSuccess{
    WEAKSELF
    NSString *contentId  =[NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"id"]];
    [[HomeManager sharedInstance]postSharedContentId:contentId Type:self.typeStr Kind:@"1" MemberId:@"" MemberName:@"" Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
            NSInteger forwardsCount = [[self.dataDic objectForKey:@"forwards"] integerValue];
            forwardsCount += 1;
            
            weakSelf.shareLabel.text = [NSString stringWithFormat:@"%ld",forwardsCount];
            weakSelf.shareLabel.hidden = NO;
            [weakSelf.dataDic setObject:[NSString stringWithFormat:@"%ld",forwardsCount] forKey:@"forwards"];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
    }];
}


-(UILabel *)praiseLabel
{
    if (!_praiseLabel) {
        _praiseLabel = [[UILabel alloc] init];
        _praiseLabel.textColor = [UIColor colorForHex:@"333333"];   //BE0B1F
        _praiseLabel.font = kRegular(8);
        _praiseLabel.text= @"";
    }
    return _praiseLabel;
}
-(UIButton *)shareBtn
{
    if (!_shareBtn) {
        
        _shareBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_shareBtn setImage:[UIImage imageNamed:@"share_normal"] forState:(UIControlStateNormal)];
        [_shareBtn addTarget:self action:@selector(shareAction) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _shareBtn;
}
-(void)shareAction {
    NSMutableArray *imgArr = [NSMutableArray array];
    NSArray *arr = [self.dataDic objectForKey:@"coverurlList"];
    if (IsNilOrNull(arr)) {
        return;
    }
    for (NSDictionary *dic in arr) {
        NSString *str = [dic objectForKey:@"route"];
        [imgArr addObject:str];
    }
    
    SharedModel *model = [[SharedModel alloc] init];
    model.type = SharedModelType_URL;
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
    if (imgArr.count){
        model.imageURL = imgArr.firstObject;
    }
    WEAKSELF
    _slShareView = [[SLShareView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    _slShareView.model = model;
    _slShareView.shareFinish = ^{
        [weakSelf sharedSuccess];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:_slShareView];
    
}
-(UILabel *)shareLabel
{
    if (!_shareLabel) {
        _shareLabel = [[UILabel alloc] init];
        _shareLabel.textColor = [UIColor colorForHex:@"333333"];   //BE0B1F
        _shareLabel.font = kRegular(8);
        _shareLabel.text= @"";
    }
    return _shareLabel;
}


-(NSString *)compaareCurrentTime:(NSDate *)compareDate
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    
    timeInterval = -timeInterval;
    
    long temp = 0;
    
    NSString *result;
    
    if (timeInterval < 60) {
        
        result = [NSString stringWithFormat:SLLocalizedString(@"刚刚")];
        
    }
    
    else if((temp = timeInterval/60) <60){
        
        result = [NSString stringWithFormat:SLLocalizedString(@"%ld分前"),temp];
        
    }
    
    
    
    else if((temp = temp/60) <24){
        
        result = [NSString stringWithFormat:SLLocalizedString(@"%ld小前"),temp];
        
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
-(NSDate *)nsstringConversionNSDate:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datestr = [dateFormatter dateFromString:dateStr];
    return datestr;
}

#pragma mark - device
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

-(void)dealloc{
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"H5inFormLocal"];
    [self.webView setNavigationDelegate:nil];
    [self.webView setUIDelegate:nil];
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
