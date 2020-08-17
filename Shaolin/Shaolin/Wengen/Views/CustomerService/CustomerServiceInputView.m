//
//  CustomerServiceInputView.m
//  Shaolin
//
//  Created by 郭超 on 2020/6/23.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "CustomerServiceInputView.h"

#import "UITextView+STAutoHeight.h"

static CGFloat inputViewDefaultHeight = 45; //输入框默认高度
static CGFloat chatTextInputHeight  = 34; //默认输入框的高度

@interface CustomerServiceInputView () <UITextViewDelegate>
/**
 键盘容器(存放表情键盘和上传文件view)
 */

@property (nonatomic,strong)UIView *keyBoardContainer ;


@property (nonatomic,strong)UITextView *chatText;


/**
 输入框容器,(存放输入框)
 */
@property (nonatomic,strong)UIView *inputViewContainer;

/**
 线 输入框 底线
 */
@property (nonatomic,strong)UIView *bottomline;

/**
发送按钮
*/
@property(nonatomic, strong)UIButton *sendButton;



@end

@implementation CustomerServiceInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"self.frame =:%@",NSStringFromCGRect(self.frame));
        [self setUI];
        //        [self addNotification];
    }
    return self;
}

-(void)setUI{
    
    self.backgroundColor = [UIColor whiteColor];
    //  输入框
    [self addSubview:self.inputViewContainer];
    //   表情键盘
    [self addSubview:self.keyBoardContainer];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        
        if (self.inputWordBlock) {
            self.inputWordBlock(textView.text);
            textView.text = @"";
        }
    }
    
    [self.sendButton setEnabled:YES];
    [self.sendButton setBackgroundColor:[UIColor colorWithRed:(142/255.0) green:(43/255.0) blue:(37/255.0) alpha:1]];
 
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        [self.sendButton setEnabled:NO];
        [self.sendButton setBackgroundColor:[UIColor colorWithRed:(142/255.0) green:(43/255.0) blue:(37/255.0) alpha:0.6]];
    }
}

-(void)sendAction{
    
    if (self.chatText.text.length > 0) {
        if (self.inputWordBlock) {
            self.inputWordBlock(self.chatText.text);
            self.chatText.text = @"";
            if([self.chatText isFirstResponder] == NO){
                [self.sendButton setEnabled:NO];
                [self.sendButton setBackgroundColor:[UIColor colorWithRed:(142/255.0) green:(43/255.0) blue:(37/255.0) alpha:0.6]];
            }
        }
    }
    
   
}

#pragma mark - setter / getter

/**
 输入框容器
 */
-(UIView *)inputViewContainer{
    if (!_inputViewContainer){
        _inputViewContainer =[[UIView alloc]init];
        _inputViewContainer.frame =CGRectMake(0, 0, ScreenWidth, inputViewDefaultHeight);
        
        UIView *line = [[UIView alloc] init];
        line.frame = CGRectMake(0, 0, ScreenWidth, 0.5);
        line.backgroundColor = [UIColor colorForHex:@"F3F3F3"];
        [_inputViewContainer addSubview:line];
        [_inputViewContainer addSubview:self.chatText];
        [_inputViewContainer addSubview:self.sendButton];
        //添加顶部分割线
        UIView *topline = [[UIView alloc] init];
        topline.frame = CGRectMake(0, 1, ScreenWidth, 0.5);
        topline.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [_inputViewContainer addSubview:topline];
        
        
    }
    return _inputViewContainer;
}

//聊天输入框
-(UITextView *)chatText{
    if (!_chatText) {
        _chatText =[[UITextView alloc]init];
        CGFloat w = 257, h = chatTextInputHeight;
//        CGFloat x = (ScreenWidth - w) / 2;
        
        
        CGFloat x = CGRectGetMinX(self.sendButton.frame) - 15 - w;
        
        
        CGFloat y = (inputViewDefaultHeight - chatTextInputHeight) / 2;
        _chatText.frame =CGRectMake(x, y, w, h);
        _chatText.delegate=self;
        _chatText.backgroundColor = [UIColor colorForHex:@"F3F3F3"];
        _chatText.textColor = [UIColor colorForHex:@"333333"];
        _chatText.returnKeyType=UIReturnKeySend;
        _chatText.enablesReturnKeyAutomatically = YES;
        
        _chatText.textAlignment = NSTextAlignmentLeft;
        _chatText.font = [UIFont systemFontOfSize:17];
        
        _chatText.layer.cornerRadius = 6;
        _chatText.layer.masksToBounds = YES;
        
        [_chatText setSt_placeHolder:SLLocalizedString(@"请输入您要咨询的问题")];
        [_chatText setSt_placeHolderColor:[UIColor colorForHex:@"999999"]];
        //观察输入框的高度变化(contentSize)
        //       [_chatText addObserver:self forKeyPath:SDInputViewTextContentSize options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        
        
    }
    return _chatText;
}

-(UIButton *)sendButton{
    
    if (_sendButton == nil) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:SLLocalizedString(@"发送") forState:UIControlStateNormal];
        [_sendButton.titleLabel setFont:kRegular(14)];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendButton setBackgroundColor:[UIColor colorWithRed:(142/255.0) green:(43/255.0) blue:(37/255.0) alpha:0.6]];
        CGFloat y = (inputViewDefaultHeight - 28) / 2;
        [_sendButton setFrame:CGRectMake(ScreenWidth - 16 - 50, y, 50, 28)];
        _sendButton.layer.cornerRadius = 4;
        [_sendButton setEnabled:NO];
        [_sendButton addTarget:self action:@selector(sendAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _sendButton;

}




@end
