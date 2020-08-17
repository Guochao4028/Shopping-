//
//  StoreCertificateInformationViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/15.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "StoreCertificateInformationViewController.h"

@interface StoreCertificateInformationViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;


- (IBAction)back:(UIButton *)sender;

@end

@implementation StoreCertificateInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.textView setEditable:NO];
    
    [self initData];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
    [super viewWillAppear:animated];
}

-(void)initData{
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[DataManager shareInstance]getBusiness:@{@"id":self.storeId} Callback:^(NSDictionary *result) {
        [hud hideAnimated:YES];
        NSString *business_address = result[@"business_address"];
        NSString *business_license_number = result[@"business_license_number"];
        NSString *business_location = result[@"business_location"];

        NSString *business_range = result[@"business_range"];
        NSString *registered_capital = result[@"registered_capital"];

        NSString *start_time = result[@"start_time"];
        
        NSString *text = [NSString stringWithFormat:SLLocalizedString(@"企业名称：少林文化严选店\n\n营业执照注册号：%@\n\n营业执照所在地：%@\n\n企业注册资金：%@\n\n营业执照有效期：%@\n\n公司地址：%@\n\n营业执照经营范围：%@"),business_license_number, business_location, registered_capital,start_time,business_address,business_range];
        
        [self.textView setText:text];
        
    }];
}



- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}




@end
