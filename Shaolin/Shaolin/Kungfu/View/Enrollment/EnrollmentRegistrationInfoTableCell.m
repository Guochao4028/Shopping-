//
//  EnrollmentRegistrationInfoTableCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/5/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "EnrollmentRegistrationInfoTableCell.h"

#import "EnrollmentRegistModel.h"
#import "GCTextField.h"

@interface EnrollmentRegistrationInfoTableCell () <GCTextFieldDelegate>


/** 正常  （标题 加 输入框） */
@property (weak, nonatomic) IBOutlet UIView *normalView;
@property (weak, nonatomic) IBOutlet UILabel *normalTitleLabel;
@property (weak, nonatomic) IBOutlet GCTextField *normalInputTextField;
@property (weak, nonatomic) IBOutlet UILabel *normalFocusLabel;

/** 单选  （选择 性别 男 女 ）*/
@property (weak, nonatomic) IBOutlet UIView *radioView;
@property (weak, nonatomic) IBOutlet UILabel *radioTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *radio1View;
@property (weak, nonatomic) IBOutlet UIView *radio2View;
@property (weak, nonatomic) IBOutlet UIImageView *radio1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *radio2ImageView;
@property (weak, nonatomic) IBOutlet UILabel *radioFocusLabel;



@property (weak, nonatomic) IBOutlet UILabel *radio2ItemTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *radio1ItemTitleLabel;




/** 下拉列表 */
@property (weak, nonatomic) IBOutlet UIView *dropDownView;
@property (weak, nonatomic) IBOutlet UILabel *dropDownTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dropDownContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dropDownFocusLabel;

@property (weak, nonatomic) IBOutlet UIImageView *dropDownContentImageView;

@end

@implementation EnrollmentRegistrationInfoTableCell

+(instancetype)xibRegistrationCell{
    return (EnrollmentRegistrationInfoTableCell *)[[[NSBundle mainBundle] loadNibNamed:@"EnrollmentRegistrationInfoTableCell" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self decorationView:self.radioView];
    [self decorationView:self.dropDownView];
    [self decorationView:self.normalView];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.normalInputTextField setDelegate:self];

//    self.normalInputTextField.delegate = self;
    
    UITapGestureRecognizer *radio1Tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(radio1TapSelected:)];
    [self.radio1View addGestureRecognizer:radio1Tap];
    
    UITapGestureRecognizer *radio2Tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(radio2TapSelected:)];
    [self.radio2View addGestureRecognizer:radio2Tap];
    [self.dropDownContentLabel setAdjustsFontSizeToFitWidth:YES];
    
//    [self.normalInputTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
//    [self.normalInputTextField setDidEndEditBlock:^(GCTextField * _Nonnull textField, NSString * _Nonnull text) {
//        NSString * type = self.model[@"type"];
//        NSString * title = self.model[@"title"];
//
//        if (![type isEqualToString:@"1"]) {
//            return;
//        }
//
//        NSString * saveText = self.model[@"saveText"];
//        if(saveText){
//            if ([saveText isEqualToString:SLLocalizedString(@"民族")]) {
//                self.registModel.nation = textField.text;
//            }
//        }
//
//
//        if ([title isEqualToString:SLLocalizedString(@"身份证号：")]) {
//            self.registModel.idCard = textField.text;
//        }
//        if ([title isEqualToString:SLLocalizedString(@"出生年月：")]||[title isEqualToString:SLLocalizedString(@"年     龄：")]) {
//            self.registModel.bormtime = textField.text;
//        }
//        if ([title isEqualToString:SLLocalizedString(@"民      族：")]) {
//            self.registModel.nation = textField.text;
//        }
//        if ([title isEqualToString:SLLocalizedString(@"学      历：")]) {
//            self.registModel.education = textField.text;
//        }
//        if ([title isEqualToString:SLLocalizedString(@"职      称：")]) {
//            self.registModel.title = textField.text;
//        }
//        if ([title isEqualToString:SLLocalizedString(@"职      务：")]) {
//            self.registModel.post = textField.text;
//        }
//        if ([title isEqualToString:SLLocalizedString(@"微      信：")]) {
//            self.registModel.wechat = textField.text;
//        }
//        if ([title isEqualToString:SLLocalizedString(@"邮      箱：")]) {
//            self.registModel.mailbox = textField.text;
//        }
//        if ([title isEqualToString:SLLocalizedString(@"手      机：")]||[title isEqualToString:SLLocalizedString(@"联系方式：")]) {
//            self.registModel.telephone = textField.text;
//        }
//        if ([title isEqualToString:SLLocalizedString(@"通讯地址：")]) {
//            self.registModel.mailingAddress = textField.text;
//        }
//        if ([title isEqualToString:SLLocalizedString(@"护  照 号：")]) {
//            self.registModel.passportNumber = textField.text;
//        }
//        if ([title isEqualToString:SLLocalizedString(@"姓名：")]) {
//            self.registModel.realname = textField.text;
//        }
//        if ([title isEqualToString:SLLocalizedString(@"姓      名：")]) {
//            self.registModel.realname = textField.text;
//        }
//
//        if ([title isEqualToString:SLLocalizedString(@"年      龄：")]) {
//            self.registModel.bormtime = textField.text;
//        }
//
//        if ([title isEqualToString:SLLocalizedString(@"联系方式：")]) {
//            self.registModel.telephone = textField.text;
//        }
//    }];
}

///装饰view
-(void)decorationView:(UIView *)view{
    view.layer.cornerRadius = 4;
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = [UIColor colorForHex:@"CECECE"].CGColor;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - action
-(void)radio1TapSelected:(UITapGestureRecognizer *)sender{
    [self.radio1ImageView setImage:[UIImage imageNamed:@"exam_choose"]];
    [self.radio2ImageView setImage:[UIImage imageNamed:@"exam_unChoose"]];

    NSString *itemType = self.model[@"itemType"];
    
    NSInteger itemTypeInteger = [itemType integerValue];
    
    if (itemTypeInteger == 1) {
        [self.registModel setValueType:@"1"];
    }else{
        [self.registModel setGender:@"男"];
    }
    
    

}

-(void)radio2TapSelected:(UITapGestureRecognizer *)sender{
    
    [self.radio2ImageView setImage:[UIImage imageNamed:@"exam_choose"]];
    [self.radio1ImageView setImage:[UIImage imageNamed:@"exam_unChoose"]];

    
    
    NSString *itemType = self.model[@"itemType"];
    
    NSInteger itemTypeInteger = [itemType integerValue];
    
    if (itemTypeInteger == 1) {
        [self.registModel setValueType:@"2"];
    }else{
        [self.registModel setGender:@"女"];
    }

    
}

#pragma mark - UITextFieldDelegate

//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if ([string length] == 0) {
//        return YES;
//    }
//    NSString * title = self.model[@"title"];
//    if ([title isEqualToString:SLLocalizedString(@"微      信：")] == YES) {
//        //只允许英文+数字
//        BOOL onlyNumbersAndEnglishFlag = [string onlyNumbersAndEnglish];
//        if (onlyNumbersAndEnglishFlag == NO) {
//            return NO;
//        }
//    }else if ([title isEqualToString:SLLocalizedString(@"邮      箱：")] == YES) {
//        NSArray *symbolArray = @[@"@", @"-", @"_", @"."];
//        for (int i = 0; i < symbolArray.count; i++){
//            if ([string isEqualToString:symbolArray[i]]) return YES;
//        }
//        BOOL wordeFlag = [string onlyNumbersAndEnglish];
//        if (wordeFlag == NO){
//            return NO;
//        }
//    }else if ([title isEqualToString:SLLocalizedString(@"电      话：")] == YES||[title isEqualToString:SLLocalizedString(@"联系方式：")] == YES) {
//        //仅支持数字
//        BOOL bothNumberFlag = [string onlyNumbers];
//        //11个字符
//        if (bothNumberFlag == NO) {
//            return NO;
//        }
//    }else if ([title isEqualToString:SLLocalizedString(@"身份证号：")] == YES) {
//        //只允许输入英文数字
//        BOOL bothChinessEnglishFlag = [string onlyNumbersAndEnglish];
//        //支持中英文, 18个字
//        if (bothChinessEnglishFlag == NO) {
//            return NO;
//        }
//    }else if ([title containsString:SLLocalizedString(@"年  ")] == YES){
//        BOOL numberFlag = [string onlyNumbers];
//        if (numberFlag == NO) {
//            return NO;
//        }
//    }else if ([title isEqualToString:SLLocalizedString(@"护  照 号：")] ) {
//        //只允许输入英文数字
//        BOOL flag = [string onlyNumbersAndEnglish];
//        if (flag == NO) {
//            return NO;
//        }
//    }else if ([title isEqualToString:SLLocalizedString(@"通讯地址：")] ) {
//        //通讯地址
//        BOOL flag = [string ChineseAndEnglishAndNumber];
//        if (flag == NO) {
//            return NO;
//        }
//    }else {//民族、学历、职称、职务
//        BOOL flag = [string onlyChineseAndEnglish];
//        if (!flag){
//            return NO;
//        }
//    }
//
//    return YES;
//}

//- (void)textFieldDidChange:(UITextField *)textField{
//    NSString * title = self.model[@"title"];
//    NSInteger maxLength = 20;
//    if ([title isEqualToString:SLLocalizedString(@"电      话：")] || [title isEqualToString:SLLocalizedString(@"联系方式：")]) {
//        maxLength = 11;
//    }else if ([title isEqualToString:SLLocalizedString(@"身份证号：")]) {
//        maxLength = 18;
//    }else if ([title isEqualToString:SLLocalizedString(@"护  照 号：")]) {
//        maxLength = 30;
//    }else if ([title isEqualToString:SLLocalizedString(@"通讯地址：")]){
//        maxLength = 60;
//    }
//    NSString *toBeString = textField.text;
//    UITextRange *selectedRange = [textField markedTextRange];
//    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
//    if (!position && toBeString.length > maxLength) {
//        NSString *content = [toBeString substringToIndex:maxLength];
//        textField.text = content;
//    }
//}


- (void)textFieldDidEndEditing:(GCTextField *_Nonnull)textField{
    
    NSString * type = self.model[@"type"];
    NSString * title = self.model[@"title"];
    
    if (![type isEqualToString:@"1"]) {
        return;
    }
    if ([title isEqualToString:SLLocalizedString(@"身份证号：")]) {
        self.registModel.idCard = textField.text;
    }
    if ([title isEqualToString:SLLocalizedString(@"出生年月：")]||[title isEqualToString:SLLocalizedString(@"年     龄：")]) {
        self.registModel.bormtime = textField.text;
    }
    if ([title isEqualToString:SLLocalizedString(@"民      族：")]) {
        self.registModel.nation = textField.text;
    }
    if ([title isEqualToString:SLLocalizedString(@"学      历：")]) {
        self.registModel.education = textField.text;
    }
    if ([title isEqualToString:SLLocalizedString(@"职      称：")]) {
        self.registModel.title = textField.text;
    }
    if ([title isEqualToString:SLLocalizedString(@"职      务：")]) {
        self.registModel.post = textField.text;
    }
    if ([title isEqualToString:SLLocalizedString(@"微      信：")]) {
        self.registModel.wechat = textField.text;
    }
    if ([title isEqualToString:SLLocalizedString(@"邮      箱：")]) {
        self.registModel.mailbox = textField.text;
    }
    if ([title isEqualToString:SLLocalizedString(@"手      机：")]||[title isEqualToString:SLLocalizedString(@"联系方式：")]) {
        self.registModel.telephone = textField.text;
    }
    if ([title isEqualToString:SLLocalizedString(@"通讯地址：")]) {
        self.registModel.mailingAddress = textField.text;
    }
    if ([title isEqualToString:SLLocalizedString(@"护  照 号：")]) {
        self.registModel.passportNumber = textField.text;
    }
    if ([title isEqualToString:SLLocalizedString(@"姓名：")]) {
        self.registModel.realname = textField.text;
    }

    if ([title isEqualToString:@"姓      名："]) {
        self.registModel.realname = textField.text;
    }
    
    if ([title isEqualToString:@"年      龄："]) {
        self.registModel.bormtime = textField.text;
    }
    
    if ([title isEqualToString:@"联系方式："]) {
        self.registModel.telephone = textField.text;

    }
    
    
    if ([title isEqualToString:@"身      高："]) {
        self.registModel.height = textField.text;
    }
    
    if ([title isEqualToString:@"练武年限："]) {
        self.registModel.martialArtsYears = textField.text;
    }
    
    NSString * saveText = self.model[@"saveText"];

    if(saveText){
        if ([saveText isEqualToString:@"民族"]) {
            
            self.registModel.nation = textField.text;
        }
    }
    
    if ([title isEqualToString:@"体      重："]) {
        self.registModel.weight = textField.text;
    }
    

}


#pragma mark - setter / getter

-(void)setModel:(NSDictionary *)model{
    _model = model;
    NSString *type = model[@"type"];
    
    BOOL isEditor = [model[@"isEditor"] boolValue];
    
    if([type isEqualToString:@"1"] == YES){
        [self.normalView setHidden:NO];
        [self.dropDownView setHidden:YES];
        [self.radioView setHidden:YES];
        [self.normalTitleLabel setText:model[@"title"]];
        
        
        if (isEditor == NO && model[@"subArray"]) {
            [self.normalInputTextField setText:model[@"content"]];
        }
        
        if (isEditor == NO) {
            [self.normalInputTextField setEnabled:NO];
        }
        NSString *hexColor = [model objectForKey:@"hexColor"];
        if (hexColor && hexColor.length){
            self.normalTitleLabel.textColor = [UIColor colorForHex:hexColor];
            self.normalInputTextField.textColor = [UIColor colorForHex:hexColor];
        }
        
    }else if ([type isEqualToString:@"2"] == YES){
       [self.normalView setHidden:YES];
        [self.dropDownView setHidden:YES];
        [self.radioView setHidden:NO];
         [self.radioTitleLabel setText:model[@"title"]];
        
        [self.radio1ItemTitleLabel setText:model[@"item1Title"]];
        [self.radio2ItemTitleLabel setText:model[@"item2Title"]];
        
    }else if ([type isEqualToString:@"3"] == YES){
        [self.normalView setHidden:YES];
        [self.dropDownView setHidden:NO];
        [self.radioView setHidden:YES];
        [self.dropDownTitleLabel setText:model[@"title"]];
        
        NSString *isSelected = model[@"isSelected"];
        
        if ([isSelected boolValue]) {
            [self.dropDownContentImageView setImage:[UIImage imageNamed:@"pdown"]];
        }else{
            [self.dropDownContentImageView setImage:[UIImage imageNamed:@"hdown"]];
        }
        
        NSString *content = model[@"content"];
        
        [self.dropDownContentLabel setText:content];
        
    }
    
    BOOL isMust = [model[@"isMust"] boolValue];
    
    [self.normalFocusLabel setHidden:!isMust];
    [self.radioFocusLabel setHidden:!isMust];
    [self.dropDownFocusLabel setHidden:!isMust];
    
    if (model[@"placeholder"]) {
        [self.normalInputTextField setPlaceholder:model[@"placeholder"]];
    }
    
}


-(void)setRegistModel:(EnrollmentRegistModel *)registModel {
    _registModel = registModel;
    
    NSString * title = self.model[@"title"];
    
    BOOL isEditor = [self.model[@"isEditor"] boolValue];
    
    NSString * textFieldStr = @"";
    if ([title isEqualToString:SLLocalizedString(@"身份证号：")]) {
        textFieldStr =  self.registModel.idCard;
        //        [self.normalInputTextField setKeyboardType:UIKeyboardTypeASCIICapable];
        //        self.normalInputTextField.maxLength = 18;
        //        self.normalInputTextField.inputType = TextInputTypeLetterOrNum;
    }
    if ([title isEqualToString:SLLocalizedString(@"姓      名：")]) {
        textFieldStr =  self.registModel.realname;
        
        //        self.normalInputTextField.inputType = TextInputTypeNormal;
    }
    
    if ([title isEqualToString:SLLocalizedString(@"年      龄：")]) {
        
        textFieldStr =  self.registModel.bormtime;
        self.normalInputTextField.inputType = CCCheckeNumber;
    }
    
    if ([title isEqualToString:SLLocalizedString(@"联系方式：")]) {
        textFieldStr = self.registModel.telephone;
        self.normalInputTextField.inputType = CCCheckPhone;
    }
    
    if ([title isEqualToString:SLLocalizedString(@"出生年月：")]) {
        textFieldStr = self.registModel.bormtime;
    }
    if ([title isEqualToString:SLLocalizedString(@"民      族：")]) {
        textFieldStr = self.registModel.nation;
        
        [self.dropDownContentLabel setText:textFieldStr];
        
        //        self.normalInputTextField.inputType = TextInputTypeChineseOrLetter;
    }
    
    if ([title isEqualToString:SLLocalizedString(@"学      历：")]) {
        textFieldStr = self.registModel.education;
        [self.dropDownContentLabel setText:textFieldStr];
    }
    
    if ([title isEqualToString:SLLocalizedString(@"职      称：")]) {
        textFieldStr = self.registModel.title;
        //        self.normalInputTextField.inputType = TextInputTypeChineseOrLetter;
    }
    if ([title isEqualToString:SLLocalizedString(@"职      务：")]) {
        textFieldStr = self.registModel.post;
        //        self.normalInputTextField.inputType = TextInputTypeChineseOrLetter;
    }
    if ([title isEqualToString:SLLocalizedString(@"微      信：")]){
        
        textFieldStr = self.registModel.wechat;
        self.normalInputTextField.inputType = CCCheckStrongTypeWinXin;
    }
    if ([title isEqualToString:SLLocalizedString(@"邮      箱：")]) {
        
        textFieldStr = self.registModel.mailbox;
        
        self.normalInputTextField.inputType = CCCheckEmail;
    }
    if ([title isEqualToString:SLLocalizedString(@"手      机：")]) {
        
        textFieldStr = self.registModel.telephone;
        self.normalInputTextField.inputType = CCCheckPhone;
        
    }
    if ([title isEqualToString:SLLocalizedString(@"通讯地址：")]) {
        textFieldStr = self.registModel.mailingAddress;
    }
    if ([title isEqualToString:SLLocalizedString(@"护  照 号：")]) {
        //        self.normalInputTextField.inputType = TextInputTypeLetterOrNum;
        
        textFieldStr = self.registModel.passportNumber;
        //        self.normalInputTextField.inputType = TextInputTypeLetterOrNum;
    }
    
    
    
    if ([title isEqualToString:SLLocalizedString(@"身      高：")]) {
        textFieldStr = self.registModel.height;
        self.normalInputTextField.inputType = CCCheckeNumber;
    }
    

    
    if ([title isEqualToString:@"体      重："]) {
        textFieldStr = self.registModel.weight;
        self.normalInputTextField.inputType = CCCheckeNumber;
    }
    
    if ([title isEqualToString:@"练武年限："]) {

        textFieldStr = self.registModel.martialArtsYears;
        self.normalInputTextField.inputType = CCCheckeNumber;
    }
    
    if ([title isEqualToString:SLLocalizedString(@"鞋      码：")]) {
        textFieldStr = self.registModel.shoeSize;
        
        [self.dropDownContentLabel setText:textFieldStr];
        
    }
    
    self.normalInputTextField.text = textFieldStr;
    
    
    if (isEditor == NO && self.model[@"subArray"]) {
        [self.normalInputTextField setText:self.registModel.examAddress];
    }
    
    
    //    if ([title isEqualToString:@"民      族："]) {
    //
    //        [self.normalInputTextField setText:self.registModel.nation];
    //
    //    }
    
    //    NSString * saveText = self.model[@"saveText"];
    //    if(saveText){
    //        if ([saveText isEqualToString:@"民族"]) {
    //
    //            [self.normalInputTextField setText:self.registModel.nation];
    //        }
    //    }
    
    
    if ([title isEqualToString:SLLocalizedString(@"证书显示名：")]) {
        //valueType 姓名 1 曾名或法名  2
        NSInteger valueType = [self.registModel.valueType integerValue];
        if (valueType == 1 || valueType == 0) {
            [self.radio1ImageView setImage:[UIImage imageNamed:@"exam_choose"]];
            [self.radio2ImageView setImage:[UIImage imageNamed:@"exam_unChoose"]];
            self.registModel.valueType = @"1";
        }else if(valueType == 2) {
            [self.radio1ImageView setImage:[UIImage imageNamed:@"exam_unChoose"]];
            [self.radio2ImageView setImage:[UIImage imageNamed:@"exam_choose"]];
            self.registModel.valueType = @"2";
        }
    }else if ([title isEqualToString:SLLocalizedString(@"性      别：")]){
        [self.radio1ImageView setImage:[UIImage imageNamed:@"exam_unChoose"]];
        [self.radio2ImageView setImage:[UIImage imageNamed:@"exam_unChoose"]];
    }
    
    
}


-(void)setMechanismName:(NSString *)mechanismName{
    _mechanismName = mechanismName;
    
   NSString *title = self.model[@"title"];
    NSString *isEditor = self.model[@"isEditor"];
    if ([title isEqualToString:SLLocalizedString(@"举办机构：")] && [isEditor isEqualToString:@"0"]) {
        [self.normalInputTextField setText:mechanismName];
    }

}

@end
