//
//  KfClassInfoViewController.m
//  Shaolin
//
//  Created by ws on 2020/5/19.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KfClassInfoViewController.h"

#import <WebKit/WebKit.h>

#import "UIView+AutoLayout.h"

@interface KfClassInfoViewController ()<WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *classImgv;
@property (weak, nonatomic) IBOutlet UILabel *classContentLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property(nonatomic, strong)WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *contentView;


@end

@implementation KfClassInfoViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.closeBtn setBackgroundColor:[UIColor redColor]];
    
    
    [self.contentView addSubview:self.webView];
    [self.webView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.webView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.webView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [self.webView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.classNameLabel setText:self.classNameStr];
    
    NSString *htmlStr = [self htmlEntityDecode:self.classContentStr];
    
    NSString *htmlTxt = [NSString stringWithFormat:@"<html> \n"
                         "<head> \n"
                         "<style type=\"text/css\">"
//                         "body {"
//                         "font-size:17pt;"
//                         "text-align: center;"
//                         "}"
//                         "p {"
//                         "text-align:left;"
//                         "}"
                         "img {"
                         "margin-left:10%%;"
                         "transform: translate(-10%%)"
                         "}"
                         
                         "</style>"
                         "</head> \n"
                         "<body>"
                         "<meta content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0;\" name=\"viewport\" />"
                         "<script type='text/javascript'>"
                         "window.onload = function(){\n"
                         "var $img = document.getElementsByTagName('img');\n"
                         "for(var p in  $img){\n"
                         "$img[p].style.width = '95%%';\n"
                         "$img[p].style.height ='auto'\n"
                         "}\n"
                         "}"
                         "</script>%@"
                         "<div id=\"testDiv\" style = \"height:100px; width:100px\"></div>"
                         "</body>"
                         "</html>", htmlStr];
    
    [self.webView loadHTMLString:htmlTxt baseURL:nil];
}

#pragma mark -  methods
- (NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    
    return string;
}


#pragma mark - action

- (IBAction)closeBtnHandle:(UIButton *)sender {

    if (self.shutDownBlock) {
        self.shutDownBlock();
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - WKUIDelegate, WKNavigationDelegate

//- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
//{
//    if (webView == self.webView) {
//        [webView evaluateJavaScript:@"document.getElementById(\"testDiv\").offsetTop"completionHandler:^(id _Nullable result,NSError * _Nullable error) {
//               //获取页面高度，并重置webview的frame
//               CGFloat lastHeight  = [result doubleValue] + 50;
//               webView.mj_h = lastHeight;
//           }];
//    }
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 让webview的内容一直居中显示
    scrollView.contentOffset = CGPointMake((scrollView.contentSize.width - ScreenWidth) / 2, scrollView.contentOffset.y);
}

#pragma mark - setter / getter

-(WKWebView *)webView{
    
    if (_webView == nil) {
        
        _webView = [WKWebView newAutoLayoutView];
        
//        [_webView setUserInteractionEnabled:NO];
        [_webView setUIDelegate:self];
        
        _webView.navigationDelegate = self;
        _webView.scrollView.delegate = self;
        [_webView.scrollView setShowsVerticalScrollIndicator:NO];
        [_webView.scrollView setShowsHorizontalScrollIndicator:NO];
    }
    return _webView;
    
}


@end
