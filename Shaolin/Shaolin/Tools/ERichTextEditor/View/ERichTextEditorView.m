//
//  ERichTextEditorView.m
//  KCWC
//
//  Created by Eleven on 2018/2/6.
//  Copyright © 2018年 HAWK. All rights reserved.
//

#import "ERichTextEditorView.h"
#import <JavaScriptCore/JavaScriptCore.h>



static CGFloat const kItemWidth = 37.5;
static CGFloat const kItemHeight = 47;

@interface ERichTextEditorView () <WKUIDelegate,WKNavigationDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic,   copy) NSString *imageBase64String;
@property(nonatomic,strong) NSString *contentStrr;
@end

@implementation ERichTextEditorView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame ContentStr:(NSString *)contentStr
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentStrr = contentStr;
        [self setupSubviews:contentStr];

    }
    return self;
}

- (void)dealloc {
    self.webView.UIDelegate=nil;
    self.webView.navigationDelegate = nil;

    [self.webView stopLoading];
}

- (void)setupSubviews:(NSString *)contentStr {
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.bounds];
    [webView setAllowsLinkPreview:NO];
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    webView.scrollView.delegate = self;
//    webView.keyboardDisplayRequiresUserAction = NO;
//    webView.scalesPageToFit = YES;
//    webView.dataDetectorTypes = UIDataDetectorTypeNone;
    webView.scrollView.bounces = NO;
    webView.userInteractionEnabled = YES;
    webView.backgroundColor = UIColor.whiteColor;
    self.webView = webView;
    [self addSubview:webView];
    

//    if ([contentStr isEqualToString:@"1"]) {
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"editor"
                                                                      ofType:@"html"];
        NSString *htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                                encoding:NSUTF8StringEncoding
                                                                   error:nil];
       // NSLog(@"%@",htmlCont);
        [webView loadHTMLString:htmlCont baseURL:baseURL];
//    }else {
        
//        [self.webView loadHTMLString:contentStr baseURL:nil];
//
//        [self setHTML:contentStr];
//        [self getHTML];
//         NSString *path = [[NSBundle mainBundle] bundlePath];
//                NSURL *baseURL = [NSURL fileURLWithPath:path];
//                NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"editor"
//                                                                              ofType:@"html"];
//                NSString *htmlCont = [NSString stringWithContentsOfFile:htmlPath
//                                                                        encoding:NSUTF8StringEncoding
//                                                                           error:nil];
//                NSLog(@"%@",htmlCont);
//                [webView loadHTMLString:htmlCont baseURL:baseURL];
//        [self setHTML:contentStr];
        
//    }

}
#pragma mark - set text
- (void)setBold {
    NSString *trigger = @"zss_editor.setBold();";
//    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
    [self.webView evaluateJavaScript:trigger completionHandler:nil];
}

- (void)setItalic {
    NSString *trigger = @"zss_editor.setItalic();";
//    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
    [self.webView evaluateJavaScript:trigger completionHandler:nil];
}

- (void)setUnorderedList {
    NSString *trigger = @"zss_editor.setUnorderedList();";
//    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
    [self.webView evaluateJavaScript:trigger completionHandler:nil];
}

- (void)setOrderedList {
    NSString *trigger = @"zss_editor.setOrderedList();";
//    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
    [self.webView evaluateJavaScript:trigger completionHandler:nil];
}

- (void)setBlockquote {
    NSString *trigger = @"zss_editor.e_setBlockquote();";
//    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
    [self.webView evaluateJavaScript:trigger completionHandler:nil];
}

- (void)setStrikethrough {
    NSString *trigger = @"zss_editor.setStrikeThrough();";
//    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
    [self.webView evaluateJavaScript:trigger completionHandler:nil];
}

- (void)setSelectedColor:(NSString *)hexColor {
    NSString *trigger = [NSString stringWithFormat:@"zss_editor.setTextColor(\"%@\");", hexColor];
//    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
    [self.webView evaluateJavaScript:trigger completionHandler:nil];
}

- (void)heading1 {
    NSString *trigger = @"zss_editor.setHeading('h1');";
//    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
    [self.webView evaluateJavaScript:trigger completionHandler:nil];
}

- (void)heading2 {
    NSString *trigger = @"zss_editor.setHeading('h2');";
//    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
    [self.webView evaluateJavaScript:trigger completionHandler:nil];
}

- (void)heading3 {
    NSString *trigger = @"zss_editor.setHeading('h3');";
//    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
    [self.webView evaluateJavaScript:trigger completionHandler:nil];
}

- (void)heading4 {
    NSString *trigger = @"zss_editor.setHeading('h4');";
//    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
    [self.webView evaluateJavaScript:trigger completionHandler:nil];
}

- (void)undo {
    NSString *trigger = @"zss_editor.undo();";
//    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
    [self.webView evaluateJavaScript:trigger completionHandler:nil];
}

- (void)getCaretYPosition {
    NSString *trigger = @"zss_editor.positionLast();";
    
//    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
    [self.webView evaluateJavaScript:trigger completionHandler:nil];
}

- (void)recordCursorPosition {
    NSString *trigger = @"zss_editor.prepareInsert();";
//    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
    [self.webView evaluateJavaScript:trigger completionHandler:nil];
}

- (void)setContentHeight:(float)contentHeight {
    
    //Call the contentHeight javascript method
    NSString *js = [NSString stringWithFormat:@"zss_editor.contentHeight = %f;", contentHeight];
//    [self.webView stringByEvaluatingJavaScriptFromString:js];
    [self.webView evaluateJavaScript:js completionHandler:nil];
    
    
    NSString *jsStr = [NSString stringWithFormat:@"zss_editor.calculateEditorHeightWithCaretPosition();"];
       
       [self.webView evaluateJavaScript:jsStr completionHandler:nil];
       
    
}
- (void)setHTML:(NSString *)html {
    NSString *trigger = [NSString stringWithFormat:@"zss_editor.setHTML(\"%@\");", html];
//    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
    [self.webView evaluateJavaScript:trigger completionHandler:nil];
    
}
#pragma mark - Image
- (void)insertImageBase64String:(NSString *)imageBase64String {
    NSString *trigger = [NSString stringWithFormat:@"zss_editor.insertImageBase64String(\"%@\");", imageBase64String];
//    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
    [self.webView evaluateJavaScript:trigger completionHandler:nil];
}

- (void)updateImageBase64String:(NSString *)imageBase64String {
    NSString *trigger = [NSString stringWithFormat:@"zss_editor.updateImageBase64String(\"%@\");", imageBase64String];
//    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
    [self.webView evaluateJavaScript:trigger completionHandler:nil];
}

- (void)insertImage:(NSString *)url {
    [self.webView evaluateJavaScript:@"zss_editor.prepareInsert();" completionHandler:nil];
    NSString *trigger = [NSString stringWithFormat:@"zss_editor.e_insertImage(\"%@\"\n\n);", url];
//    NSString *trigger = [NSString stringWithFormat:@"zss_editor.e_insertImage(\"%@\"<br\\><br\\>);", url];
    
//    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
    [self.webView evaluateJavaScript:trigger completionHandler:nil];
}

- (void)updateImage:(NSString *)url {
    NSString *trigger = [NSString stringWithFormat:@"zss_editor.updateImage(\"%@\");", url];
//    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
    [self.webView evaluateJavaScript:trigger completionHandler:nil];
}

#pragma mark - export html
- (void)getHTMLAndBlock:(void (^)(NSString * html))block {
//    NSString *html = [self.webView stringByEvaluatingJavaScriptFromString:@"zss_editor.getHTML();"];
    [self.webView evaluateJavaScript:@"zss_editor.getHTML();" completionHandler:^(id _Nullable HTMLSource, NSError * _Nullable error) {
   
        NSString * html;
        html = [self removeQuotesFromHTML:HTMLSource];
//        html = [self tidyHTML:html];
        [self tidyHTML:html block:^(NSString *htmlStr) {
            block(htmlStr);
        }];
    }];
}

- (NSString *)removeQuotesFromHTML:(NSString *)html {
    html = [html stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    html = [html stringByReplacingOccurrencesOfString:@"“" withString:@"&quot;"];
    html = [html stringByReplacingOccurrencesOfString:@"”" withString:@"&quot;"];
    html = [html stringByReplacingOccurrencesOfString:@"\r"  withString:@"\\r"];
    html = [html stringByReplacingOccurrencesOfString:@"\n"  withString:@"\\n"];
    
    if (IsNilOrNull(html)) {
        html = @"";
    }
    
    return html;
}

- (void)tidyHTML:(NSString *)html block:(void (^)(NSString * htmlStr))block {
    html = [html stringByReplacingOccurrencesOfString:@"<br>" withString:@"<br />"];
    html = [html stringByReplacingOccurrencesOfString:@"<hr>" withString:@"<hr />"];
//        if (self.formatHTML) {
//    html = [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"style_html(\"%@\");", html]];
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"style_html(\"%@\");", html] completionHandler:^(id _Nullable htmlSource, NSError * _Nullable error) {
        
        block(htmlSource);
    }];
//        }

}


// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
     if ([self.contentStrr isEqualToString:@"1"]) {
         NSString *bodyString = @"document.body.outerHTML";
    
//         NSString *body = [webView  stringByEvaluatingJavaScriptFromString:bodyString];
//                  NSLog(@"%@",body);
//               JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//                  @weakify(self);

//                  context[@"e_finishLoad"] = ^(CGFloat height) {
//                      @strongify(self);

//                  };
//                   webView.keyboardDisplayRequiresUserAction = NO;
        [self setContentHeight:webView.bounds.size.height];
     }else {
        NSString *strUrl = [self.contentStrr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
         NSString *btn = @"var btn = document.getElementById('zss_editor_content');" ;
         [webView evaluateJavaScript:btn completionHandler:nil];
//         [webView  stringByEvaluatingJavaScriptFromString:btn];
         
         NSString *attr = [NSString stringWithFormat:@"btn.innerHTML = '%@';",strUrl];
         
//         [webView  stringByEvaluatingJavaScriptFromString:attr];
         [webView evaluateJavaScript:attr completionHandler:nil];
         
        NSString *bodyString = @"document.body.outerHTML";
        [webView evaluateJavaScript:bodyString completionHandler:nil];
     }
}

    
//        if (!webView.isLoading) {
//            NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
//            BOOL complete = [readyState isEqualToString:@"complete"];
//            if (complete) {
//
////                 [webView stringByEvaluatingJavaScriptFromString:self.contentStrr];
//
//            }else
//            {
////                 [self setHTML:self.contentStrr];
////                  [webView stringByEvaluatingJavaScriptFromString:self.contentStrr];
//
//            }
//        }
//         webView.keyboardDisplayRequiresUserAction = NO;
//         [self setContentHeight:webView.bounds.size.height];
      
//      
//        NSString *bodyString = @"document.body.outerHTML";
//                     NSString *body = [webView  stringByEvaluatingJavaScriptFromString:bodyString];
//                        NSLog(@"%@",body);
//                     JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//                        @weakify(self);
//
//                        context[@"e_finishLoad"] = ^(CGFloat height) {
//                            @strongify(self);
//                         [self setHTML:self.contentStrr];
//                        };
//                         webView.keyboardDisplayRequiresUserAction = NO;
//                        [self setContentHeight:webView.bounds.size.height];
       

#pragma mark - UIScrollViewDelegate
//- (UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView {
//    NSLog(@"%f", scrollView.contentOffset.y);
//    return nil;
//}

#pragma mark - getter



@end



@interface ERichTextToolBar ()

@property (nonatomic, strong) ERichTextEditorView *editView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *colorBoardView;
@property (nonatomic, strong) UIScrollView *colorScrollView;
@property (nonatomic, strong) NSArray *colorsValue;

@property (nonatomic,   copy) NSString *imageBase64String;

@end

@implementation ERichTextToolBar

- (instancetype)initWithFrame:(CGRect)frame editView:(ERichTextEditorView *)editView
{
    self = [super initWithFrame:frame];
    if (self) {
        _editView = editView;
        self.backgroundColor = UIColor.whiteColor;
        [self setupToolBar];
        [self setupColorBoard];
    }
    return self;
}

- (void)setupToolBar {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView = scrollView;
    [self addSubview:scrollView];
    
    NSArray *icons = @[@"icon_jiacu", @"icon_qingx", @"icon_lieb", @"icon_lieb3", @"icon_yinyong", @"icon_shanc", @"icon_yanse", @"icon_H1", @"icon_H2", @"icon_H3", @"icon_H4"];
    for (NSInteger i = 0; i < icons.count; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kItemWidth * i, 0, kItemWidth, kItemHeight)];
        [button setImage:EImageNamed(icons[i]) forState:UIControlStateNormal];
        button.tag = 500 + i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
    }
    scrollView.contentSize = CGSizeMake(icons.count * kItemWidth, kItemHeight);
    if (icons.count * kItemWidth > SCREEN_WIDTH) {
        UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - kItemWidth, 0, kItemWidth, kItemHeight)];
        [nextBtn setImage:EImageNamed(@"icon_arrow") forState:UIControlStateNormal];
        [nextBtn addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:nextBtn];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 8, 1, 28)];
        line.backgroundColor = HexColorInt32_t(e0e0e0);
        [nextBtn addSubview:line];
        scrollView.width = SCREEN_WIDTH - kItemWidth;
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    line.backgroundColor = HexColorInt32_t(e0e0e0);
    [self addSubview:line];
}

- (void)setupColorBoard {
    UIView *colorBoardView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, kItemHeight)];
    colorBoardView.backgroundColor = self.backgroundColor;
    self.colorBoardView = colorBoardView;
    [self addSubview:colorBoardView];
    
    UIScrollView *colorScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - kItemWidth, kItemHeight)];
    colorScrollView.showsHorizontalScrollIndicator = NO;
    self.colorScrollView = colorScrollView;
    [colorBoardView addSubview:colorScrollView];
    
    NSArray *colorsValue = @[@"#636363", @"#d0d0d0", @"#ff583d", @"#fdaa26", @"#44c77b", @"#14b2e1", @"#b066e3"];
    self.colorsValue = colorsValue;
    CGFloat width = (SCREEN_WIDTH - kItemWidth) / colorsValue.count;
    for (NSInteger i = 0; i < colorsValue.count; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(width * i, 0, width, kItemHeight)];
        button.tag = 600 + i;
        [button addTarget:self action:@selector(colorClick:) forControlEvents:UIControlEventTouchUpInside];
        [colorScrollView addSubview:button];
        
        UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        colorView.userInteractionEnabled = NO;
        colorView.layer.cornerRadius = 7.5;
        colorView.layer.masksToBounds = YES;
        colorView.backgroundColor = [UIColor hexColor:colorsValue[i]];
        colorView.ly_centerX = width * 0.5;
        colorView.ly_centerY = kItemHeight * 0.5;
        
        [button addSubview:colorView];
    }
    colorScrollView.contentSize = CGSizeMake(colorsValue.count * width, kItemHeight);
    
    UIButton *returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - kItemWidth, 0, kItemWidth, kItemHeight)];
    [returnBtn setImage:EImageNamed(@"icon_return") forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(returnBack) forControlEvents:UIControlEventTouchUpInside];
    [colorBoardView addSubview:returnBtn];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 8, 1, 28)];
    line.backgroundColor = HexColorInt32_t(e0e0e0);
    [returnBtn addSubview:line];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    topLine.backgroundColor = HexColorInt32_t(e0e0e0);
    [colorBoardView addSubview:topLine];
}

#pragma mark - event response
- (void)nextClick {
    CGPoint offset = CGPointMake(self.scrollView.contentOffset.x, 0);
    CGFloat maxOffsetX = self.scrollView.contentSize.width - (SCREEN_WIDTH - kItemWidth);
    if (offset.x >= maxOffsetX) return;
    if (offset.x + kItemWidth > maxOffsetX) {
        offset.x = maxOffsetX;
    } else {
        offset.x += kItemWidth;
    }
    [self.scrollView setContentOffset:offset animated:YES];
}

- (void)buttonClick:(UIButton *)button {
    NSArray *methodsName = @[NSStringFromSelector(@selector(setBold)),
                             NSStringFromSelector(@selector(setItalic)),
                             NSStringFromSelector(@selector(setUnorderedList)),
                             NSStringFromSelector(@selector(setOrderedList)),
                             NSStringFromSelector(@selector(setBlockquote)),
                             NSStringFromSelector(@selector(setStrikethrough)),
                             NSStringFromSelector(@selector(showColorBoard)),
                             NSStringFromSelector(@selector(heading1)),
                             NSStringFromSelector(@selector(heading2)),
                             NSStringFromSelector(@selector(heading3)),
                             NSStringFromSelector(@selector(heading4))];
    SEL method = NSSelectorFromString(methodsName[button.tag - 500]);
    if ([self.editView respondsToSelector:method]) {
        [self.editView performSelector:method];
    }
    if ([self respondsToSelector:method]) {
        [self performSelector:method];
    }
}

- (void)colorClick:(UIButton *)button {
    [self.editView recordCursorPosition];
    [self.editView setSelectedColor:self.colorsValue[button.tag - 600]];
}

- (void)showColorBoard {
    [UIView animateWithDuration:0.25 animations:^{
        self.colorBoardView.x = 0;
    }];
}

- (void)returnBack {
    [UIView animateWithDuration:0.1 animations:^{
        self.colorBoardView.x = SCREEN_WIDTH;
    }];
}


@end
