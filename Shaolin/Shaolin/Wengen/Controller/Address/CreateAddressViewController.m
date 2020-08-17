//
//  CreateAddressViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "CreateAddressViewController.h"
#import "WengenNavgationView.h"
#import "AddressListModel.h"
#import "CreateAddressView.h"
#import "SMAlert.h"

@interface CreateAddressViewController ()<WengenNavgationViewDelegate, CreateAddressViewDelegate>

@property(nonatomic, strong)WengenNavgationView *navgationView;

@property(nonatomic, strong)CreateAddressView *createAddressView;

@property(nonatomic, strong)AddressListModel *addressModel;



@end

@implementation CreateAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated{
    
    if (self.isHiddenNav) {
           [self.navigationController.navigationBar setHidden:YES];
       }
    
    if (self.type == AddressModifyType) {
        
        [self.navgationView setTitleStr:SLLocalizedString(@"编辑收货地址")];
        [self.navgationView setRightStr:SLLocalizedString(@"删除")];
        [self.navgationView rightTarget:self action:@selector(rightAction)];
        [[DataManager shareInstance]getAddressInfo:@{@"id":self.addressId} Callback:^(NSObject *object) {
            
            if ([object isKindOfClass:[AddressListModel class]] == YES) {
                AddressListModel *model = (AddressListModel *)object;
                self.addressModel = model;
                
                [self.createAddressView setAddressListModel:self.addressModel];
            }
        }];
    }else{
        [self.navgationView setTitleStr:SLLocalizedString(@"新建收货地址")];
    }
     [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    if (self.isHiddenNav) {
        [self.navigationController.navigationBar setHidden:NO];
    }
    [super viewWillDisappear:animated];
}

#pragma mark - methods
-(void)initUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.navgationView];
    [self.view addSubview:self.createAddressView];
}

#pragma mark - action

-(void)rightAction{
    [SMAlert setConfirmBtBackgroundColor:[UIColor colorForHex:@"8E2B25"]];
    [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
    [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
    [SMAlert setCancleBtTitleColor:[UIColor colorForHex:@"333333"]];
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
    UILabel *title = [[UILabel alloc]initWithFrame:customView.bounds];
    [title setFont:kMediumFont(15)];
    [title setTextColor:[UIColor darkGrayColor]];
    title.text = SLLocalizedString(@"是否删除该地址？");
    [title setTextAlignment:NSTextAlignmentCenter];
    [customView addSubview:title];
    [SMAlert showCustomView:customView stroke:YES confirmButton:[SMButton initWithTitle:SLLocalizedString(@"确定") clickAction:^{
        
        if (self.addressId) {
            NSDictionary *param = @{@"id" : self.addressId};
            [[DataManager shareInstance]delAddress:param Callback:^(Message *message) {
                
                if (message != nil) {
                    BOOL isSuccess = message.isSuccess;
                    if (isSuccess == YES) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
                }else{
                    [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"网络异常") view:self.view afterDelay:TipSeconds];
                }
                
            }];
        }
       
    }] cancleButton:[SMButton initWithTitle:SLLocalizedString(@"取消") clickAction:nil]];
}

#pragma mark - WengenNavgationViewDelegate
-(void)tapBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - CreateAddressViewDelegate
-(void)createAddressView:(CreateAddressView *)view tapSave:(NSDictionary *)model{
    
    if (self.type == AddressModifyType) {
        
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:model];
        
        [param setValue:self.addressId forKey:@"id"];
        
        [[DataManager shareInstance]editAddress:param Callback:^(Message *message) {
            if (message != nil) {
                BOOL isSuccess = message.isSuccess;
                if (isSuccess == YES) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
                [self.createAddressView setIsEnabled:YES];
            }else{
                [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"网络异常") view:self.view afterDelay:TipSeconds];
                 [self.createAddressView setIsEnabled:YES];
            }
        }];
        
    }else{
        [[DataManager shareInstance]addAddress:model Callback:^(Message *message) {
            
            if (message != nil) {
                BOOL isSuccess = message.isSuccess;
                if (isSuccess == YES) {
                    
                    if ([self.delegate respondsToSelector:@selector(isHasNewAddress)] == YES) {
                        [self.delegate isHasNewAddress];
                    }
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
                [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
                 [self.createAddressView setIsEnabled:YES];
            }else{
                [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"网络异常") view:self.view afterDelay:TipSeconds];
                 [self.createAddressView setIsEnabled:YES];
            }
        }];
    }
}

#pragma mark - WengenNavgationView
-(WengenNavgationView *)navgationView{
    
    if (_navgationView == nil) {
        //状态栏高度
        CGFloat barHeight ;
        /** 判断版本
         获取状态栏高度
         */
        if (@available(iOS 13.0, *)) {
            barHeight = [[[[[UIApplication sharedApplication] keyWindow] windowScene] statusBarManager] statusBarFrame].size.height;
        } else {
            barHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        }
        _navgationView = [[WengenNavgationView alloc]initWithFrame:CGRectMake(0, barHeight, ScreenWidth, 44)];
        [_navgationView setDelegate:self];
    }
    return _navgationView;

}

-(CreateAddressView *)createAddressView{
    
    if (_createAddressView == nil) {
        
        CGFloat y = CGRectGetMaxY(self.navgationView.frame);
        _createAddressView = [[CreateAddressView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, ScreenHeight - y)];
        [_createAddressView setDelegate:self];
    }
    return _createAddressView;

}

@end
