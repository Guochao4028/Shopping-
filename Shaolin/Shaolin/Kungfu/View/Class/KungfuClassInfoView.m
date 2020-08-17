//
//  KungfuClassInfoView.m
//  Shaolin
//
//  Created by 郭超 on 2020/6/16.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuClassInfoView.h"

#import <WebKit/WebKit.h>

#import "UIView+AutoLayout.h"

@interface KungfuClassInfoView ()<WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *webContentView;
@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;

@property(nonatomic, strong)WKWebView *webView;
- (IBAction)closeAction:(UIButton *)sender;

@end

@implementation KungfuClassInfoView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"KungfuClassInfoView" owner:self options:nil];
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
        [self initUI];
    }
    return self;
}

#pragma mark - methods

/// 初始化UI
-(void)initUI{
    [self addSubview:self.contentView];
    
    
    
    [self.contentView setFrame:CGRectMake(0, 200, ScreenWidth, ScreenHeight - 200)];
    
//    [self.contentView setFrame:self.bounds];
    
    [self.webContentView addSubview:self.webView];
    [self.webView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.webView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.webView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [self.webView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.shutDownBlock) {
        self.shutDownBlock();
    }
}

/// 重写系统方法
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self.contentView setFrame:self.bounds];
}

- (NSString *)htmlEntityDecode:(NSString *)string{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    
    return string;
}

#pragma mark - action
- (IBAction)closeAction:(UIButton *)sender{
    if (self.shutDownBlock) {
        self.shutDownBlock();
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 让webview的内容一直居中显示
    scrollView.contentOffset = CGPointMake((scrollView.contentSize.width - ScreenWidth) / 2, scrollView.contentOffset.y);
}


#pragma mark - setter / getter

-(WKWebView *)webView{
    
    if (_webView == nil) {
        
        _webView = [WKWebView newAutoLayoutView];
        
        [_webView setUIDelegate:self];
        
        _webView.navigationDelegate = self;
        _webView.scrollView.delegate = self;
        [_webView.scrollView setShowsVerticalScrollIndicator:NO];
        [_webView.scrollView setShowsHorizontalScrollIndicator:NO];
    }
    return _webView;
    
}

-(void)setClassNameStr:(NSString *)classNameStr{
    _classNameStr = classNameStr;
    [self.classNameLabel setText:classNameStr];
}

-(void)setClassContentStr:(NSString *)classContentStr{
    NSString *htmlStr = [self htmlEntityDecode:classContentStr];
        
        NSString *htmlTxt = [NSString stringWithFormat:@"<html> \n"
                             "<head> \n"
                             "<style type=\"text/css\">"
                             "img {"
                             "margin-left:5%%;"
                             "margin-right:5%%;"
                             
//                             "transform: translate(-10%%)"
                             "}"
                             "p {"
//                             "text-align: center;"
                                "margin-left:16px;"
//                                "margin-left:16px;"
                             "margin-right:16px;"
//                                "transform: translate(-15%%)"
                                "}"
                             "</style>"
                             "</head> \n"
                             "<body>"
                             "<meta content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0;\" name=\"viewport\" />"
                             "<script type='text/javascript'>"
                             "window.onload = function(){\n"
                             "var $img = document.getElementsByTagName('img');\n"
                             "for(var p in  $img){\n"
                             "$img[p].style.width = '90%%';\n"
                             "$img[p].style.height ='auto'\n"
                             "}\n"
                             "}"
                             "</script>%@"
                             "</body>"
                             "</html>", htmlStr];
        
    
        [self.webView loadHTMLString:htmlTxt baseURL:nil];
}


@end
