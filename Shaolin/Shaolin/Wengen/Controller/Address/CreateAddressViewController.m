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
#import "DataManager.h"

@interface CreateAddressViewController ()<CreateAddressViewDelegate>

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
    [super viewWillAppear:animated];
    if (self.type == AddressModifyType) {
        [self.rightBtn setTitle:SLLocalizedString(@"删除") forState:UIControlStateNormal];
        self.titleLabe.text = SLLocalizedString(@"编辑收货地址");
        [[DataManager shareInstance]getAddressInfo:@{@"id":self.addressId} Callback:^(NSObject *object) {
            
            if ([object isKindOfClass:[AddressListModel class]] == YES) {
                AddressListModel *model = (AddressListModel *)object;
                self.addressModel = model;
                
                [self.createAddressView setAddressListModel:self.addressModel];
            }
        }];
    }else{
        self.titleLabe.text = SLLocalizedString(@"新建收货地址");
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark - methods
-(void)initUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.createAddressView];
}

#pragma mark - action

-(void)rightAction{
    [SMAlert setConfirmBtBackgroundColor:kMainYellow];
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

-(void)leftAction{
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

- (CreateAddressView *)createAddressView{
    
    if (_createAddressView == nil) {
        _createAddressView = [[CreateAddressView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBar_Height)];
        [_createAddressView setDelegate:self];
    }
    return _createAddressView;

}

@end
