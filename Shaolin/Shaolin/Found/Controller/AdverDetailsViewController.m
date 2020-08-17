//
//  AdverDetailsViewController.m
//  Shaolin
//
//  Created by edz on 2020/4/14.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "AdverDetailsViewController.h"
#import <WebKit/WebKit.h>
@interface AdverDetailsViewController ()<WKUIDelegate>
@property(nonatomic,strong) WKWebView *webView;
@end

@implementation AdverDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabe.text = self.titleStr;
     [self setupWebView];
}
-(void)setupWebView
{
    
    WKWebViewConfiguration *webConfiguration = [WKWebViewConfiguration new];
    

    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) configuration:webConfiguration];
     _webView.UIDelegate = self;
    [_webView setAllowsLinkPreview:NO];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.contentStr]]];
    
    [self.view addSubview:self.webView];
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
