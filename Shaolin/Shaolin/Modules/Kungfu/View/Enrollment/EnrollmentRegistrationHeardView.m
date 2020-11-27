//
//  EnrollmentRegistrationHeardView.m
//  Shaolin
//
//  Created by 郭超 on 2020/5/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "EnrollmentRegistrationHeardView.h"
#import "EnrollmentRegistModel.h"
#import "NSString+Tool.h"
#import "GCTextField.h"

@interface EnrollmentRegistrationHeardView () <GCTextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutlet UIView *nameView;
@property (strong, nonatomic) IBOutlet UIView *formerNameView;
@property (strong, nonatomic) IBOutlet UIView *nationalityView;

@property (weak, nonatomic) IBOutlet GCTextField * nameTF;
@property (weak, nonatomic) IBOutlet GCTextField * oldNameTF;
@property (weak, nonatomic) IBOutlet GCTextField * nationalityTF;

@property (weak, nonatomic) IBOutlet UIView *logoView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@end

@implementation EnrollmentRegistrationHeardView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [[NSBundle mainBundle] loadNibNamed:@"EnrollmentRegistrationHeardView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

#pragma mark - methods
-(void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
    
    [self decorationView:self.nameView];
    [self decorationView:self.formerNameView];
    [self decorationView:self.nationalityView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadPicturesAction)];
    [self.logoView addGestureRecognizer:tap];
    
    self.nameTF.delegate = self;
    self.oldNameTF.delegate = self;
    self.nationalityTF.delegate = self;
    for (UILabel *lab in self.nameView.subviews){
        if ([lab respondsToSelector:@selector(setTextColor:)]){
            lab.textColor = KTextGray_999;
        }
    }
    
//    [self.oldNameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    [self.nationalityTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

///装饰View
-(void)decorationView:(UIView *)view{
    view.layer.cornerRadius = 4;
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = [UIColor colorForHex:@"CECECE"].CGColor;
}

#pragma mark - action
-(void)uploadPicturesAction{
    if ([self.delegate respondsToSelector:@selector(enrollmentRegistrationHeardView:tapUploadPictures:)]) {
        [self.delegate enrollmentRegistrationHeardView:self tapUploadPictures:YES];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    self.registModel.realName = self.nameTF.text;
    self.registModel.beforeName = self.oldNameTF.text;
//    self.registModel.nationality = self.nationalityTF.text;
}

//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    //只允许输入中英文
//    if ([string length] == 0) {
//        return YES;
//    }
//
//    NSLog(@"string : %@", string);
//    BOOL bothChinessEnglishFlag = [string onlyChineseAndEnglish];
//
//    if (bothChinessEnglishFlag == NO ) {
//        return NO;
//    }
//
//    return YES;
//}

//- (void)textFieldDidChange:(UITextField *)textField{
//    NSInteger maxLength = 20;
//    NSString *toBeString = textField.text;
//    UITextRange *selectedRange = [textField markedTextRange];
//    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
//    if (!position && toBeString.length > maxLength) {
//        NSString *content = [toBeString substringToIndex:maxLength];
//        textField.text = content;
//    }
//}


#pragma mark - setter / getter

-(void)setRegistModel:(EnrollmentRegistModel *)registModel {
    _registModel = registModel;
    
    self.nameTF.text = self.registModel.realName;
    self.oldNameTF.text = self.registModel.beforeName;
    self.nationalityTF.text = self.registModel.nationality;
    
    if (self.registModel.realName == nil|| self.registModel.realName.length == 0) {
        for (UILabel *lab in self.nameView.subviews){
            if ([lab respondsToSelector:@selector(setTextColor:)]){
                lab.textColor = KTextGray_333;
            }
        }
        
        [self.nameTF setEnabled:YES];
    }
    
    
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:registModel.photosUrl] placeholderImage:[UIImage imageNamed:@"Group"]];
}

-(void)setPicUrlStr:(NSString *)picUrlStr{
    _picUrlStr = picUrlStr;
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:picUrlStr] placeholderImage:[UIImage imageNamed:@"default_small"]];
}



@end
