//
//  EditTextViewController.m
//  Shaolin
//
//  Created by edz on 2020/4/2.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "EditTextViewController.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import "ERichTextEditorView.h"
#import "ContentEditFooterView.h"
#import "HomeManager.h"

#import "UITextView+Placeholder.h"
static CGFloat kFooterHeight = 47.f;
@interface EditTextViewController ()<UITextViewDelegate,UITextFieldDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) ERichTextEditorView *editorView;
@property (nonatomic, strong) ContentEditFooterView *footerView;
@property(nonatomic,strong) UITextView *titleTextView;//标题
@property(nonatomic,strong) UILabel *titleTipsLabel;//标题提示
@property(nonatomic,strong) UITextView *introductionTextView;//简介
@property(nonatomic,strong) UILabel *introductionTipsLabel;//简介提示
@property(nonatomic,strong) NSMutableArray *imageArr;
@property(nonatomic) NSInteger titleTextMaxCount;//标题文最多字数
@property(nonatomic) NSInteger introductionTextMaxCount;//简介最多字数
@property(nonatomic) NSInteger contentTextMaxCount;//正文最多字数
@property(nonatomic,strong) UIView *viewLine1;
@property(nonatomic,strong) UIView *viewLine2;
@end

@implementation EditTextViewController
-(NSMutableArray *)imageArr
{
    if (!_imageArr) {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleTextMaxCount = 30;
    self.introductionTextMaxCount = 60;
    self.contentTextMaxCount = 5000;
    self.titleLabe.text = SLLocalizedString(@"编辑文章");
    [self.rightBtn setTitle:SLLocalizedString(@"发布") forState:(UIControlStateNormal)];
    [self.rightBtn setTitleColor:[UIColor colorForHex:@"333333"] forState:(UIControlStateNormal)];
    self.rightBtn.titleLabel.font = kRegular(14);
    [self.rightBtn addTarget:self action:@selector(rightAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:self.titleTextView];
    [self.view addSubview:self.titleTipsLabel];
    [self.view addSubview:self.introductionTextView];
    [self.view addSubview:self.introductionTipsLabel];
    
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.viewLine1 = [[UIView alloc] initWithFrame:CGRectMake(0,SLChange(70), kWidth, 1)];
    self.viewLine1.backgroundColor = [UIColor colorForHex:@"E5E5E5"];
    [self.view addSubview:self.viewLine1];
    
    self.viewLine2 = [[UIView alloc]initWithFrame:CGRectMake(0,SLChange(141), kWidth, 1)];
    self.viewLine2.backgroundColor = [UIColor colorForHex:@"E5E5E5"];
    [self.view addSubview:self.viewLine2];
    
    [self.view addSubview:self.editorView];
    [self.view addSubview:self.footerView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self pushData];
    for (UITextView *textView in @[self.titleTextView, self.introductionTextView]){
        CGRect frame = textView.frame;
        CGFloat height = [self heightForTextView:textView withText:textView.text];
        frame.size.height = height;
        textView.frame = frame;
    }
    [self changeTipsLabel:self.titleTextView];
    [self changeTipsLabel:self.introductionTextView];
    [self checkoutViewsFrame];
}

- (void)pushData {
    if (self.titleStr.length == 0) {
        [_titleTextView setPlaceholder:SLLocalizedString(@"请输入标题") placeholdColor:[UIColor colorForHex:@"333333"]];
    } else {
        _titleTextView.text = self.titleStr;
    }
    if (self.introductStr.length == 0) {
        [_introductionTextView setPlaceholder:SLLocalizedString(@"请输入简介") placeholdColor:[UIColor colorForHex:@"333333"]];
    } else {
        _introductionTextView.text = self.introductStr;
    }
}

- (void)rightAction
{
    if (self.titleTextView.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入标题") view:self.view afterDelay:TipSeconds];
        return;
    }
    if (self.introductionTextView.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入内容") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    [self.editorView getHTMLAndBlock:^(NSString *html) {
        NSString *htmlStr = html;
        
        if (htmlStr.length == 0) {
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入内容") view:self.view afterDelay:TipSeconds];
            return;
        }
        
        NSString *strUrl = [htmlStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSArray *arr = [self getImageurlFromHtml:strUrl];
        
        [self.imageArr removeAllObjects];
        NSMutableArray *lidsArr = [NSMutableArray array];
        MePostManagerModel *model = self.model;
        //    for (NSDictionary *dic in model.coverurlList) {
        //        [lidsArr addObject:[dic objectForKey:@"id"]];
        //    }
        [lidsArr addObject:model.id];
        
        for (int i = 0; i<arr.count; i++) {
            NSMutableDictionary *dicc= [NSMutableDictionary dictionary];
            NSString *str = arr[i];
            [dicc setValue:@"1" forKey:@"type"];
            [dicc setValue:@"1" forKey:@"kind"];
            [dicc setValue:str forKey:@"route"];
            [dicc setValue:model.id forKey:@"contentId"];
            [self.imageArr addObject:dicc];
        }
        NSLog(@"%@",self.imageArr);
        
        NSString *typeStr = @"";
        if (self.imageArr.count == 0) {
            typeStr = @"1";
        }else
        {
            typeStr = @"2";
        }
        
//        NSString *textNumber = [EditTextViewController filterHTML:htmlStr];
        //            NSString *allStr = [NSString stringWithFormat:@"%@%@%@",self.titleTextView.text,textNumber,self.introductionTextView.text];
        WEAKSELF
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:SLLocalizedString(@"提示")
                                                                       message:SLLocalizedString(@"是否发布文章")
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"确定发布") style:UIAlertActionStyleDestructive
                                                              handler:^(UIAlertAction * action) {
            
            //敏感词校验由服务器进行
//            [weakSelf postTextAndPhoto:self.titleTextView.text Introduction:self.introductionTextView.text TextId:model.id Source:@"" Author:@"" Content:htmlStr Type:typeStr State:@"2" CreateId:@"" CreateName:@"" CreateType:@"2" Coverurlids:lidsArr CoverUrlPlist:self.imageArr];
            [weakSelf postTextAndPhoto:self.titleTextView.text Introduction:self.introductionTextView.text TextId:model.id Source:@"" Author:@"" Content:strUrl Type:typeStr State:@"2" CreateId:@"" CreateName:@"" CreateType:@"2" Coverurlids:lidsArr CoverUrlPlist:self.imageArr];
        }];
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"取消") style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
            
        }];
        
        [alert addAction:defaultAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

#pragma mark - 发布文章
-(void)postTextAndPhoto:(NSString *)title Introduction:(NSString *)introductionStr TextId:(NSString *)textId Source:(NSString *)source Author:(NSString *)author Content:(NSString *)content Type:(NSString *)type State:(NSString *)state CreateId:(NSString *)createId CreateName:(NSString *)name CreateType:(NSString *)createType Coverurlids:(NSMutableArray *)urlLids CoverUrlPlist:(NSMutableArray *)plistArr
{
    [ShaolinProgressHUD defaultSingleLoadingWithText:SLLocalizedString(@"正在发布文章")];
    NSString *alertStr =@"";
    if ([state isEqualToString:@"1"]) {
        alertStr = SLLocalizedString(@"保存草稿成功!");
        
    }else
    {
        alertStr = SLLocalizedString(@"发布成功!请等待审核...");
        
    }
    
    [[HomeManager sharedInstance]postUserChangeTextWithTitle:title Introduction:introductionStr textId:textId Content:content Type:type State:state CreateId:createId CreateName:name CreateType:createType Coverurilids:urlLids CoverUrlPlist:plistArr WithBlock:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"]integerValue]==200) {
            [ShaolinProgressHUD singleTextHud:alertStr view:self.view afterDelay:TipSeconds];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshData" object:nil];
                
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        } else {
            if (error){
                [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:self.view afterDelay:TipSeconds];
            } else {
                NSString * msg = [responseObject objectForKey:@"msg"];
                [ShaolinProgressHUD singleTextHud:msg view:self.view afterDelay:TipSeconds];
            }
        }
        NSLog(@"%@",error);
    }];
    
    
}

- (void)leftAction {
    if ([self.pushStr isEqualToString:SLLocalizedString(@"发文管理")]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:SLLocalizedString(@"提示")
                                                                       message:SLLocalizedString(@"是否放弃编辑")
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"确定") style:UIAlertActionStyleDestructive
                                                              handler:^(UIAlertAction * action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"取消") style:UIAlertActionStyleDefault
                                                             handler:nil];
        
        [alert addAction:defaultAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    [self.editorView getHTMLAndBlock:^(NSString *html) {
        NSString *htmlStr = html;
        NSString *newStr = [EditTextViewController filterHTML:htmlStr];
        NSArray *newArr = [self getImageurlFromHtml:htmlStr];
        NSString *oldStr = [EditTextViewController filterHTML:self.contentStr];
        NSArray *oldArr = [self getImageurlFromHtml:self.contentStr];
        NSString *sssss;
        if ([oldArr isEqual:newArr]) {
            sssss = @"1";
        } else {
            sssss = @"2";
        }
        if (self.titleTextView.text.length == 0 && htmlStr.length == 0 && self.introductionTextView.text.length==0) {
            NSLog(@"3333");
            [self.navigationController popViewControllerAnimated:YES];
            return;
        } else if(self.titleTextView.text == self.titleStr && [sssss isEqualToString:@"1"] && self.introductStr == self.introductionTextView.text && [newStr isEqualToString:oldStr]) {
            NSLog(@"22222");
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            NSLog(@"1111");
            WEAKSELF
            //
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:SLLocalizedString(@"提示")
                                                                           message:SLLocalizedString(@"是否保存草稿")
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            //
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"保存")
                                                                    style:UIAlertActionStyleDestructive
                                                                  handler:^(UIAlertAction * _Nonnull action) {
                // 点击按钮，调用此block
                NSLog(@"确定按钮被按下");
                [weakSelf saveAction];
            }];
            [alert addAction:defaultAction];
            
            //UIAlertActionStyleDefault
            UIAlertAction *moreAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"不保存")
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * _Nonnull action) {
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            [alert addAction:moreAction];
            
            //
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"取消")
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:nil];
            [alert addAction:cancelAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}
#pragma mark - 保存草稿
-(void)saveAction
{
    [self.editorView getHTMLAndBlock:^(NSString *html) {
        NSString *htmlStr = html;
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[htmlStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
        NSString *string = [attributedString.string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSUInteger length = string.length;
        if (length > self.contentTextMaxCount){
            [ShaolinProgressHUD singleTextAutoHideHud:[NSString stringWithFormat:SLLocalizedString(@"正文内容不能超过%ld字"), self.contentTextMaxCount]];
            return;
        }
        NSString *strUrl = [htmlStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSArray *arr = [self getImageurlFromHtml:strUrl];
        
        [self.imageArr removeAllObjects];
        NSMutableArray *lidsArr = [NSMutableArray array];
        MePostManagerModel *model = self.model;
        //    for (NSDictionary *dic in model.coverurlList) {
        //        [lidsArr addObject:[dic objectForKey:@"id"]];
        //    }
        [lidsArr addObject:model.id];
        for (int i = 0; i<arr.count; i++) {
            NSMutableDictionary *dicc= [NSMutableDictionary dictionary];
            NSString *str = arr[i];
            [dicc setValue:@"1" forKey:@"type"];
            [dicc setValue:@"1" forKey:@"kind"];
            [dicc setValue:str forKey:@"route"];
            [dicc setValue:model.id forKey:@"contentId"];
            [self.imageArr addObject:dicc];
        }
        
        NSString *typeStr = @"";
        if (self.imageArr.count == 0) {
            typeStr = @"1";
        } else {
            typeStr = @"2";
        }
        
        //敏感词校验由服务器进行
//        [self postTextAndPhoto:self.titleTextView.text Introduction:self.introductionTextView.text TextId:model.id Source:@"" Author:@"" Content:htmlStr Type:@"2" State:@"1" CreateId:@"" CreateName:@"" CreateType:@"2" Coverurlids:lidsArr CoverUrlPlist:self.imageArr];
        [self postTextAndPhoto:self.titleTextView.text Introduction:self.introductionTextView.text TextId:model.id Source:@"" Author:@"" Content:strUrl Type:@"2" State:@"1" CreateId:@"" CreateName:@"" CreateType:@"2" Coverurlids:lidsArr CoverUrlPlist:self.imageArr];
    }];
}

+ (NSString *)filterHTML:(NSString *)html{
    NSDictionary *dic = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
    NSData *data = [html dataUsingEncoding:NSUnicodeStringEncoding];
    NSAttributedString *attriStr = [[NSAttributedString alloc] initWithData:data options:dic documentAttributes:nil error:nil];
    NSString *str = attriStr.string;
    //str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    return str;
    
}

#pragma mark - notification
- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    CGSize size = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.footerView.y = SCREEN_HEIGHT - size.height - self.footerView.height-TAB_BAR_SAFE_BOTTOM_MARGIN-kNavBarHeight-kStatusBarHeight;
    
    [self.editorView setContentHeight:SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT - TAB_BAR_SAFE_BOTTOM_MARGIN - kFooterHeight - size.height-SLChange(142)];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    self.footerView.y = SCREEN_HEIGHT - TAB_BAR_SAFE_BOTTOM_MARGIN - self.footerView.height-kNavBarHeight-kStatusBarHeight;
    
    [self.editorView setContentHeight:SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT - TAB_BAR_SAFE_BOTTOM_MARGIN - kFooterHeight-SLChange(142)];
}

#pragma mark - change frame
- (void)checkoutViewsFrame{
    self.titleTextView.frame = CGRectMake(self.titleTextView.x, SLChange(13), self.titleTextView.width, self.titleTextView.height);//标题
    
    CGFloat titleTipsLabelOffset = CGRectGetHeight(self.titleTipsLabel.frame) == 0 ? 0 : SLChange(7.5);
    self.titleTipsLabel.frame = CGRectMake(CGRectGetMinX(self.titleTipsLabel.frame),
                                           CGRectGetMaxY(self.titleTextView.frame) + titleTipsLabelOffset,
                                           CGRectGetWidth(self.titleTipsLabel.frame),
                                           CGRectGetHeight(self.titleTipsLabel.frame));//标题提示
    
    self.viewLine1.frame = CGRectMake(CGRectGetMinX(self.viewLine1.frame),
                                      CGRectGetMaxY(self.titleTipsLabel.frame) + SLChange(9.5),
                                      CGRectGetWidth(self.viewLine1.frame),
                                      CGRectGetHeight(self.viewLine1.frame));
    
    self.introductionTextView.frame = CGRectMake(CGRectGetMinX(self.introductionTextView.frame),
                                                 CGRectGetMaxY(self.viewLine1.frame) + SLChange(15),
                                                 CGRectGetWidth(self.introductionTextView.frame),
                                                 CGRectGetHeight(self.introductionTextView.frame));//简介
    
    CGFloat introductionTipsLabelOffset = CGRectGetHeight(self.introductionTipsLabel.frame) == 0 ? 0 : SLChange(7.5);
    self.introductionTipsLabel.frame = CGRectMake(CGRectGetMinX(self.introductionTipsLabel.frame),
                                                  CGRectGetMaxY(self.introductionTextView.frame) + introductionTipsLabelOffset,
                                                  CGRectGetWidth(self.introductionTipsLabel.frame),
                                                  CGRectGetHeight(self.introductionTipsLabel.frame));//简介提示
    
    
    self.viewLine2.frame = CGRectMake(CGRectGetMinX(self.viewLine2.frame),
                                      CGRectGetMaxY(self.introductionTipsLabel.frame) + SLChange(9.5),
                                      CGRectGetWidth(self.viewLine2.frame),
                                      CGRectGetHeight(self.viewLine2.frame));
    
    self.editorView.frame = CGRectMake(CGRectGetMinX(self.editorView.frame),
                                       CGRectGetMaxY(self.viewLine2.frame) + SLChange(11.5),
                                       CGRectGetWidth(self.editorView.frame),
                                       CGRectGetHeight(self.editorView.frame));
    //    self.footerView;
}

- (void)changeTipsLabel:(UITextView *)textView {
    UILabel *tipsLabel;
    NSInteger textMaxCount = 0;
    __block NSInteger textCount = 0;
    [textView.text enumerateSubstringsInRange:NSMakeRange(0, textView.text.length)
                                      options:NSStringEnumerationByComposedCharacterSequences
                                   usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
        textCount++;
    }];
    if (textView == self.titleTextView){
        textMaxCount = self.titleTextMaxCount;
        if (textCount == 0){
            self.titleTipsLabel.text = [NSString stringWithFormat:SLLocalizedString(@"(最多输入%ld字)"), textMaxCount];
            self.titleTipsLabel.textColor = [UIColor colorForHex:@"999999"];
        } else if (textCount > textMaxCount){
            self.titleTipsLabel.text = [NSString stringWithFormat:SLLocalizedString(@"标题字数不可超过%ld个字"), textMaxCount];
            self.titleTipsLabel.textColor = kMainYellow;
        } else {
            self.titleTipsLabel.text = @"";
        }
        tipsLabel = self.titleTipsLabel;
    } else if (textView == self.introductionTextView){
        textMaxCount = self.introductionTextMaxCount;
        if (textCount == 0){
            self.introductionTipsLabel.text = [NSString stringWithFormat:SLLocalizedString(@"(最多输入%ld字)"), textMaxCount];
            self.introductionTipsLabel.textColor = [UIColor colorForHex:@"999999"];
        } else if (textCount > textMaxCount){
            self.introductionTipsLabel.text = [NSString stringWithFormat:SLLocalizedString(@"简介字数不可超过%ld个字"), textMaxCount];
            self.introductionTipsLabel.textColor = kMainYellow;
        } else {
            self.introductionTipsLabel.text = @"";
        }
        tipsLabel = self.introductionTipsLabel;
    }
    CGRect frame = tipsLabel.frame;
    if (tipsLabel.text.length == 0) {
        frame.size.height = 0;
    } else {
        frame.size.height = SLChange(18);
    }
    tipsLabel.frame = frame;
}
#pragma mark - textView Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.footerView.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.footerView.hidden = NO;
}

- (void)textViewDidChange:(UITextView *)textView {
    [self changeTipsLabel:textView];
    NSInteger textMaxCount = 1e6;
    if (textView == self.titleTextView) {
        textMaxCount = self.titleTextMaxCount;
    } else if (textView == self.introductionTextView) {
        textMaxCount = self.introductionTextMaxCount;
    }
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    if (!position) {
        NSString *toBeString = textView.text;
        __block NSInteger count = 0;//toBeString.length;
        __block NSInteger realMaxCount = 0;
        [toBeString enumerateSubstringsInRange:NSMakeRange(0, toBeString.length)
                                       options:NSStringEnumerationByComposedCharacterSequences
                                    usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
            count++;
            if (count <= textMaxCount){
                realMaxCount += substring.length;
            }
        }];
        if (count > textMaxCount) {
            NSString *content = [toBeString substringToIndex:realMaxCount];// [self string:toBeString subStrWithUtf8Len:40];
            textView.text = content;
            [textView resignFirstResponder];
        }
    }
    CGRect frame = textView.frame;
    //    CGFloat height = [self heightForTextView:textView withText:textView.text];
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGFloat height = [textView sizeThatFits:constraintSize].height;
    frame.size.height = height;
    textView.frame = frame;
    [self checkoutViewsFrame];
}

- (CGFloat)heightForTextView:(UITextView *)textView withText:(NSString *)strText{
    CGSize constraint = CGSizeMake(textView.contentSize.width , CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: textView.font}
                                        context:nil];
    float textHeight = size.size.height + 20.0;
    return textHeight;
}

#pragma mark - getter
- (ERichTextEditorView *)editorView {
    if (!_editorView) {
        NSString *str=@"";
        if (self.contentStr.length == 0) {
            str = @"1";
        }else
        {
            str = self.contentStr;
        }
        
        _editorView = [[ERichTextEditorView alloc] initWithFrame:CGRectMake(0, SLChange(142), SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT - TAB_BAR_SAFE_BOTTOM_MARGIN - kFooterHeight - SLChange(142)) ContentStr:str];
        _editorView.backgroundColor = [UIColor blueColor];
    }
    return _editorView;
}

- (ContentEditFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[ContentEditFooterView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - TAB_BAR_SAFE_BOTTOM_MARGIN - kFooterHeight - kNavBarHeight-kStatusBarHeight, SCREEN_WIDTH, kFooterHeight) editView:self.editorView];
        @weakify(self);
        _footerView.pictureBlock = ^{
            @strongify(self);
            [self.editorView recordCursorPosition];
            WEAKSELF
            [self.editorView getHTMLAndBlock:^(NSString *html) {
                NSString *htmlStr = html;
                NSArray *imgA = [self getImageurlFromHtml:htmlStr];
                NSInteger photoNum ;
                if (imgA.count == 0) {
                    photoNum = 9;
                }else {
                    photoNum = 9 -imgA.count;
                }
                if (imgA.count > 8) {
                    [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"最多只能选择9张图片") view:self.view afterDelay:TipSeconds];
                    return;
                }
                TZImagePickerController   *imagePicker=  [[TZImagePickerController alloc]initWithMaxImagesCount:photoNum delegate:self];
                //允许选择图片、视频和gif
                imagePicker.allowPickingVideo = NO;
                //让完成按钮一直可以点击，无须最少选择一张图片
                imagePicker.alwaysEnableDoneBtn = YES;
                [imagePicker setBarItemTextColor:[UIColor blackColor]];
                [imagePicker setDidFinishPickingPhotosWithInfosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto, NSArray<NSDictionary *> *infos) {
                    NSLog(@"%@",photos);
                    MBProgressHUD *hud = [ShaolinProgressHUD textHud:SLLocalizedString(@"正在上传图片") view:[UIApplication sharedApplication].keyWindow];
                    // 创建队列组，可以使多个网络请求异步执行，执行完之后再进行操作
                    dispatch_group_t group = dispatch_group_create();
                    //创建全局队列
                    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
                    
                    dispatch_group_async(group, queue, ^{
                        for (int i = 0; i<photos.count; i++) {
                            //创建dispatch_semaphore_t对象
                            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                            UIImage *image = photos[i];
                            NSData *imageData = UIImageJPEGRepresentation(image, 1);
//                            [[HomeManager sharedInstance] postSubmitPhotoWithFileData:imageData isVedio:NO Success:^(NSURLSessionDataTask *task, id responseObject) {
//                                NSDictionary *dic = responseObject;
//                                NSLog(@"submitPhoto+++%@", dic);
//                                if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
//
//                                    [weakSelf.editorView insertImage:[dic objectForKey:@"data"]];
//
//
//                                } else {
//                                    [ShaolinProgressHUD singleTextHud:[dic objectForKey:@"msg"] view:[UIApplication sharedApplication].keyWindow afterDelay:TipSeconds];
//                                }
//                                dispatch_semaphore_signal(semaphore);
//                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                                NSLog(@"%@",error.debugDescription);
//
//                                [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:[UIApplication sharedApplication].keyWindow afterDelay:TipSeconds];
//                                dispatch_semaphore_signal(semaphore);
//                            }];
//
                            
                            [[HomeManager sharedInstance]postSubmitPhotoWithFileData:imageData isVedio:NO Success:^(NSDictionary * _Nullable resultDic) {
                            } failure:^(NSString * _Nullable errorReason) {
                            } finish:^(NSDictionary * _Nullable responseObject, NSString * _Nullable errorReason) {
                                NSDictionary *dic = responseObject;
                                NSLog(@"submitPhoto+++%@", dic);
                                if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                                    
                                    [weakSelf.editorView insertImage:[dic objectForKey:@"data"]];
                                    
                                    
                                } else {
                                    [ShaolinProgressHUD singleTextHud:[dic objectForKey:@"msg"] view:[UIApplication sharedApplication].keyWindow afterDelay:TipSeconds];
                                }
                                dispatch_semaphore_signal(semaphore);
                                
                            }];
                            
                            
                            
                            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                        }
                    });
                    // 当所有队列执行完成之后
                    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [hud hideAnimated:YES];
                        });
                    });
                    
                }];
                imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }];
        };
        _footerView.tagBlock = ^{
        };
    }
    return _footerView;
}

- (UITextView *)titleTextView {
    if (!_titleTextView) {
        _titleTextView = [[UITextView alloc] initWithFrame:CGRectMake(SLChange(13), 0, kWidth - SLChange(32), SLChange(25))];
        
        [_titleTextView setTextColor:[UIColor blackColor]];
        _titleTextView.font = kMediumFont(15);
        _titleTextView.textColor = [UIColor colorForHex:@"333333"];
        _titleTextView.returnKeyType = UIReturnKeyDone;
        _titleTextView.delegate = self;
        _titleTextView.keyboardType = UIKeyboardTypeDefault;
        [_titleTextView setPlaceholder:SLLocalizedString(@"请输入标题") placeholdColor:[UIColor colorForHex:@"333333"]];
        _titleTextView.scrollEnabled = NO;
    }
    return _titleTextView;
}
- (UILabel *)titleTipsLabel {
    if (!_titleTipsLabel) {
        _titleTipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(SLChange(16), 0, kWidth - SLChange(32), SLChange(18))];
        _titleTipsLabel.font = kRegular(13);
        _titleTipsLabel.textColor = [UIColor colorForHex:@"999999"];
        _titleTipsLabel.text = [NSString stringWithFormat:SLLocalizedString(@"(最多输入%ld字"), self.titleTextMaxCount];
        _titleTipsLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleTipsLabel;
}

- (UITextView *)introductionTextView {
    if (!_introductionTextView) {
        _introductionTextView = [[UITextView alloc] initWithFrame:CGRectMake(SLChange(13), 0, kWidth-SLChange(32), SLChange(25))];
        [_introductionTextView setTextColor:[UIColor blackColor]];
        _introductionTextView.font = kMediumFont(14);
        [_introductionTextView setPlaceholder:SLLocalizedString(@"请输入简介") placeholdColor:[UIColor colorForHex:@"333333"]];
        _introductionTextView.textColor = [UIColor colorForHex:@"666666"];
        _introductionTextView.returnKeyType = UIReturnKeyDone;
        _introductionTextView.delegate = self;
        _introductionTextView.keyboardType = UIKeyboardTypeDefault;
        _introductionTextView.scrollEnabled = NO;
        
    }
    return _introductionTextView;
}

- (UILabel *)introductionTipsLabel {
    if (!_introductionTipsLabel) {
        _introductionTipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(SLChange(16), 0, kWidth/2, SLChange(18))];
        _introductionTipsLabel.font = kRegular(13);
        _introductionTipsLabel.textColor = [UIColor colorForHex:@"999999"];
        _introductionTipsLabel.text = [NSString stringWithFormat:SLLocalizedString(@"(最多输入%ld字"), self.introductionTextMaxCount];
        _introductionTipsLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _introductionTipsLabel;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//获取webView中的所有图片URL
- (NSArray *) getImageurlFromHtml:(NSString *) html
{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<(img|IMG)(.*?)(/>|></img>|>)" options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    NSArray *result = [regex matchesInString:html options:NSMatchingReportCompletion range:NSMakeRange(0, html.length)];
    
    for (NSTextCheckingResult *item in result) {
        NSString *imgHtml = [html substringWithRange:[item rangeAtIndex:0]];
        
        NSArray *tmpArray = nil;
        if ([imgHtml rangeOfString:@"src=\""].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:@"src=\""];
        } else if ([imgHtml rangeOfString:@"src="].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:@"src="];
        }
        
        if (tmpArray.count >= 2) {
            NSString *src = tmpArray[1];
            
            NSUInteger loc = [src rangeOfString:@"\""].location;
            if (loc != NSNotFound) {
                src = [src substringToIndex:loc];
                [resultArray addObject:src];
            }
        }
    }
    
    return resultArray;
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
