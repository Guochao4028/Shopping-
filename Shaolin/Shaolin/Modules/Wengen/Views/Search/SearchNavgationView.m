//
//  SearchNavgationView.m
//  Shaolin
//
//  Created by 郭超 on 2020/5/6.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "SearchNavgationView.h"
#import "NSString+Tool.h"

@interface SearchNavgationView ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

- (IBAction)backAction:(UIButton *)sender;

- (IBAction)searchAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@end

@implementation SearchNavgationView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"SearchNavgationView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

#pragma mark - methods

/// 初始化UI
- (void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
    [self.searchView.layer setCornerRadius:16];
    
    [self.searchTextField setDelegate:self];
    [self.searchTextField setReturnKeyType:UIReturnKeySearch];
}

- (void)becomeFirstResponder{
    if (!self.searchTextField.isFirstResponder) {
           [self.searchTextField becomeFirstResponder];
       }
}

- (void)resignFirstResponder{
    [self.searchTextField resignFirstResponder];
}

- (void)forwardingSearchWord{
    [self resignFirstResponder];
    NSString *str = self.searchTextField.text;
    if ([self.delegate respondsToSelector:@selector(searchNavgationView:searchWord:)] == YES) {
        [self.delegate searchNavgationView:self searchWord:str];
    }
}

#pragma mark - action

- (IBAction)backAction:(UIButton *)sender{
    
    if ([self.delegate respondsToSelector:@selector(tapBack)] == YES) {
        [self.delegate tapBack];
    }
    
}

- (IBAction)searchAction:(UIButton *)sender{
    
    [self forwardingSearchWord];
}



#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self forwardingSearchWord];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([NSString isContainsEmoji:string]) {
        return NO;
    }
    return YES;
}
#pragma mark -  getter / setter
- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    [self.searchTextField setText:titleStr];
}
@end
