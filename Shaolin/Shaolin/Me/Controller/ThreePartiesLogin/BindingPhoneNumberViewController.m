//
//  BindingPhoneNumberViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/6/23.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "BindingPhoneNumberViewController.h"

@interface BindingPhoneNumberViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;

@end

@implementation BindingPhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.titleLabe setText:SLLocalizedString(@"绑定手机号")];
}



@end
