//
//  InstitutionSignupSuccessfulViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/6/3.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "InstitutionSignupSuccessfulViewController.h"

@interface InstitutionSignupSuccessfulViewController ()
- (IBAction)finishButtonAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *neirongTop;

@end

@implementation InstitutionSignupSuccessfulViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.titleLabe setText:SLLocalizedString(@"报名成功")];
    [self.leftBtn addTarget:self action:@selector(leftAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    self.finishButton.layer.borderWidth = 1;
    self.finishButton.layer.borderColor = kMainYellow.CGColor;
    self.finishButton.layer.cornerRadius = SLChange(15);
    [self.finishButton.layer setMasksToBounds:YES];
    

}

#pragma mark - action
-(void)leftAction{
    
    UIViewController *vc = [self.navigationController viewControllers][1];
    
    [self.navigationController popToViewController:vc animated:YES];
}





- (IBAction)finishButtonAction:(UIButton *)sender {
    [self leftAction];
}

@end
