//
//  OrderFillInvoiceTableCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderFillInvoiceTableCell.h"

@interface OrderFillInvoiceTableCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *personalView;
@property (weak, nonatomic) IBOutlet UIView *unitView;
@property (weak, nonatomic) IBOutlet UITextField *personalTextField;
@property (weak, nonatomic) IBOutlet UITextField *unitNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *unitNumberTextField;


@property(nonatomic, copy)NSString *personal;
@property(nonatomic, copy)NSString *unitName;
@property(nonatomic, copy)NSString *unitNumber;

@end

@implementation OrderFillInvoiceTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    NSMutableAttributedString *placeHolder = [[NSMutableAttributedString alloc]initWithString: SLLocalizedString(@"请在此填写纳税人识别号")];
    [placeHolder addAttribute:NSForegroundColorAttributeName value:[UIColor colorForHex:@"BE0B1F"] range:NSMakeRange(0, placeHolder.length)];
    
    self.unitNumberTextField.attributedPlaceholder = placeHolder;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - setter / getter
-(void)setIsPersonal:(BOOL)isPersonal{
    _isPersonal = isPersonal;
    
    if (isPersonal == YES) {
        [self.unitView setHidden:YES];
        [self.personalView setHidden:NO];
    }else{
        [self.personalView setHidden:YES];
        [self.unitView setHidden:NO];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    UIView *view = textField.superview;
    while (![view isKindOfClass:[UITableViewCell class]]) {
        
        view = [view superview];
    }
    
    UITableViewCell *cell = (UITableViewCell*)view;
    
    CGRect rect = [cell convertRect:cell.frame toView:self.tabelView];
    
    if (rect.origin.y + rect.size.height>=ScreenHeight-216) {
        
        self.tabelView.contentInset = UIEdgeInsetsMake(0, 0, 216, 0);
        
        [self.tabelView scrollToRowAtIndexPath:[self.tabelView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
   [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    if (textField == self.personalTextField) {
        self.personal = self.personalTextField.text;
    }
    if (textField == self.unitNameTextField) {
        self.unitName = self.unitNameTextField.text;

    }
    
    if (textField == self.unitNumberTextField) {
        self.unitNumber = self.unitNumberTextField.text;
    }
    return YES;
}

#pragma mark - getter / setter

-(NSString *)personalStr{
    return self.personal;
}
-(NSString *)unitNameStr{
   return self.unitName;
}
-(NSString *)unitNumberStr{
    return self.unitNumber;
}

@end
