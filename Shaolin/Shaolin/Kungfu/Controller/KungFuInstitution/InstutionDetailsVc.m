//
//  InstutionDetailsVc.m
//  Shaolin
//
//  Created by edz on 2020/4/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "InstutionDetailsVc.h"
#import <WebKit/WebKit.h>
#import "DefinedHost.h"

@interface InstutionDetailsVc ()<WKUIDelegate,WKNavigationDelegate>
@property(nonatomic,strong) WKWebView *webView;
@property(nonatomic,strong) UIButton *nextBtn;
@property(nonatomic,strong) UIButton *leftBtn;
@end

@implementation InstutionDetailsVc
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
       self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [self setupWebView];
    self.view.backgroundColor = [UIColor colorForHex:@"FFFFFF"];
     self.leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, StatueBar_Height, 70, 40)];
      [self.leftBtn setImage:[UIImage imageNamed:@"left"] forState:(UIControlStateNormal)];
    self.leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 60);
    [self.leftBtn addTarget:self action:@selector(leftAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.leftBtn];
    [self.view addSubview:self.nextBtn];
}
-(void)leftAction  {
        
          [self.navigationController popViewControllerAnimated:NO];
       
}
- (void)setupWebView {
        
//        WKWebViewConfiguration *webConfiguration = [WKWebViewConfiguration new];
//        
//
//        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-SLChange(84)) configuration:webConfiguration];
//        _webView.UIDelegate = self;
//        _webView.navigationDelegate = self;
//        [_webView setAllowsLinkPreview:NO];
//        _webView.scrollView.scrollEnabled = NO;
//        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URL_H5_Help]]];
//        [self.view addSubview:self.webView];
       
       
        
}
- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(SLChange(16), kHeight-SLChange(74), kWidth-SLChange(32), SLChange(50))];
        [_nextBtn setTitle:SLLocalizedString(@"报名学习") forState:(UIControlStateNormal)];
           [_nextBtn addTarget:self action:@selector(nextAction) forControlEvents:(UIControlEventTouchUpInside)];
           [_nextBtn setTitleColor:[UIColor colorForHex:@"FFFFFF"] forState:(UIControlStateNormal)];
           _nextBtn.titleLabel.font = kRegular(15);
           _nextBtn.backgroundColor = [UIColor colorForHex:@"8E2B25"];
        _nextBtn.layer.cornerRadius = SLChange(25);
        _nextBtn.layer.masksToBounds = YES;
    }
    return _nextBtn;
}
- (void)nextAction {
    
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
