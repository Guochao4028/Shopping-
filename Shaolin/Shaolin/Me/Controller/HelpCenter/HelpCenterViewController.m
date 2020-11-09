//
//  HelpCenterViewController.m
//  Shaolin
//
//  Created by edz on 2020/4/29.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "HelpCenterViewController.h"
#import <WebKit/WebKit.h>
#import "DefinedHost.h"
@interface HelpCenterViewController ()<WKUIDelegate,WKNavigationDelegate>
@property(nonatomic,strong) WKWebView *webView;
@end

@implementation HelpCenterViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBarRedTintColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.titleLabe.text = SLLocalizedString(@"帮助中心");
    [self setupWebView];
    
}
-(void)setupWebView
{
    
    WKWebViewConfiguration *webConfiguration = [WKWebViewConfiguration new];
    

    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-NavBar_Height) configuration:webConfiguration];
    [_webView setAllowsLinkPreview:NO];
     _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    
    _webView.scrollView.scrollEnabled = NO;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URL_H5_Help([SLAppInfoModel sharedInstance].access_token)]]];
    [self.view addSubview:self.webView];
   
    
}

- (void)leftAction{
    if ([self.webView canGoBack]){
        [self.webView goBack];
    } else {
        [super leftAction];
    }
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
