//
//  CreateAddressTableViewCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "CreateAddressTableViewCell.h"
#import "NSString+Tool.h"

@interface CreateAddressTableViewCell ()<UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *wordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *moreImageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewH;
@property(nonatomic, copy)NSString *contentStr;


@end

@implementation CreateAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
     [self.wordTextField setDelegate:self];
    [self.textView setHidden:YES];
    [self.textView setFont:kRegular(15)];
    self.textView.textContainerInset = UIEdgeInsetsZero;
    self.textView.textContainer.lineFragmentPadding = 0;
    [self.textView setDelegate:self];
    self.textViewH.constant = 21;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    BOOL isMore = [self.dataDic[@"isMore"] boolValue];
    
    if (isMore == YES) {
        if ([self.delegate respondsToSelector:@selector(createAddressCell:tap:)] == YES) {
            [self.delegate createAddressCell:self tap:YES];
        }
    }
    return !isMore;
}


-(void)textFieldDidChange:(UITextField*)textField{
    
    NSString *titleStr = self.dataDic[@"title"];
    if ([titleStr isEqualToString:SLLocalizedString(@"手机号")] == YES) {
        if (textField.text.length > 11) {
           textField.text = [textField.text substringToIndex:11];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([NSString isContainsEmoji:string]) {
        return NO;
    }
    return YES;
}
#pragma mark - UITextViewDelegate
-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text length] < 1){
        textView.text = self.contentStr;
        textView.textColor = [UIColor hexColor:@"909090"];
        self.wordTextField.text = @"";
     
    }else{
        self.wordTextField.text = textView.text;
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:self.contentStr]){
        textView.text = @"";
        self.wordTextField.text = @"";
        textView.textColor = KTextGray_333;
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([NSString isContainsEmoji:text]) {
        return NO;
    }
    return YES;
}

#pragma mark - setter / getter

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    
   NSString *titleStr = dataDic[@"title"];
    
    BOOL isMore = [dataDic[@"isMore"] boolValue];
    [self.moreImageView setHidden:!isMore];
    
    [self.titleLabel setText:titleStr];
    
    self.contentStr = dataDic[@"content"];
    
    [self.wordTextField setPlaceholder:self.contentStr];
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:self.contentStr];
    [placeholder addAttribute:NSForegroundColorAttributeName
                            value:KTextGray_96
                            range:NSMakeRange(0, self.contentStr.length)];
    [placeholder addAttribute:NSFontAttributeName
                            value:kRegular(15)
                            range:NSMakeRange(0, self.contentStr.length)];
    self.wordTextField.attributedPlaceholder = placeholder;
    
    
    if ([titleStr isEqualToString:SLLocalizedString(@"详细地址")]) {
        [self.textView setHidden:NO];
        [self.wordTextField setHidden:YES];
        [self.textView setText:self.contentStr];
        [self.textView setTextColor:KTextGray_96];
    }else{
        [self.textView setHidden:YES];
        [self.wordTextField setHidden:NO];
    }
    
    NSString *txt = dataDic[@"txt"];
    
    if (txt.length > 0) {
        self.wordTextField.text = txt;
        [self.textView setText:txt];
        [self.textView setTextColor:KTextGray_333];
    }
    
    BOOL isNumber = [dataDic[@"isNumber"] boolValue];
    
    if (isNumber == YES) {
        [self.wordTextField setKeyboardType:UIKeyboardTypeNumberPad];
        
        [self.wordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
}

-(void)setAddressStr:(NSString *)addressStr{
    _addressStr = addressStr;
    [self.wordTextField setText:addressStr];
}

@end
