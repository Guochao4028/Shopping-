//
//  AddressViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "AddressViewController.h"

#import "WengenNavgationView.h"

#import "AddressNotHasView.h"

#import "AddressListView.h"

#import "AddressListModel.h"

#import "CreateAddressViewController.h"

@interface AddressViewController ()<WengenNavgationViewDelegate, AddressNotHasViewDelegate, AddressListViewDelegate>

@property(nonatomic, strong)WengenNavgationView *navgationView;

@property(nonatomic, strong)AddressNotHasView *notHasView;

@property(nonatomic, strong)AddressListView *listView;

@property(nonatomic, strong)NSArray *dataArray;

@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.isHiddenNav) {
        [self.navigationController.navigationBar setHidden:YES];
    }
    [self.notHasView setHidden:YES];
    WEAKSELF
    MBProgressHUD * hud = [ShaolinProgressHUD defaultLoadingWithText:SLLocalizedString(@"加载中")];
    [[DataManager shareInstance]getAddressListCallback:^(NSArray *result) {
        [hud hideAnimated:YES];
        BOOL notHasViewHidden = result.count > 0;
        if (result.count > 0) {
            weakSelf.dataArray = result;
            for (AddressListModel *model in result) {
                if (model.addressId == weakSelf.addressListModel.addressId) {
                    model.isSelected = weakSelf.addressListModel.isSelected;
                }
            }
            [weakSelf.listView setDataArray:result];
        }
        [weakSelf.listView setHidden:!notHasViewHidden];
        [weakSelf.notHasView setHidden:notHasViewHidden];
    }];
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
    [self.view addSubview:self.notHasView];
    [self.view addSubview:self.listView];
    
}

#pragma mark - WengenNavgationViewDelegate
-(void)tapBack{
    
    if ([self.dataArray count] == 1) {
        if ([self.delegate respondsToSelector:@selector(addressViewController:tapBack:)] == YES) {
            [self.delegate addressViewController:self tapBack:self.dataArray[0]];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - AddressNotHasViewDelegate
-(void)notHasView:(AddressNotHasView *)view tapAddress:(BOOL)istap{
    CreateAddressViewController *createAddressVC = [[CreateAddressViewController alloc]init];
    createAddressVC.isHiddenNav = self.isHiddenNav;
    createAddressVC.type = AddressCreateType;
    
    [self.navigationController pushViewController:createAddressVC animated:YES];
}

#pragma mark - AddressListViewDelegate
-(void)addressListView:(AddressListView *)view tap:(BOOL)istap{
    
    CreateAddressViewController *createAddressVC = [[CreateAddressViewController alloc]init];
    createAddressVC.isHiddenNav = self.isHiddenNav;
    createAddressVC.type = AddressCreateType;
    [self.navigationController pushViewController:createAddressVC animated:YES];
    
}

-(void)addressListView:(AddressListView *)view isModify:(AddressListModel *)model{
    
    CreateAddressViewController *createAddressVC = [[CreateAddressViewController alloc]init];
    
    createAddressVC.isHiddenNav = self.isHiddenNav;
    createAddressVC.type = AddressModifyType;
    createAddressVC.addressId = model.addressId;
    [self.navigationController pushViewController:createAddressVC animated:YES];
}

-(void)addressListView:(AddressListView *)view isTap:(AddressListModel *)model{
    
    if ([self.delegate respondsToSelector:@selector(addressViewController:tapList:) ] == YES) {
        [self.delegate addressViewController:self tapList:model];
        if (self.isAutoBack == YES) {
            [self.navigationController popViewControllerAnimated:YES];
        }
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
        [_navgationView setTitleStr:SLLocalizedString(@"收货地址")];
    }
    return _navgationView;

}

-(AddressNotHasView *)notHasView{
    
    if (_notHasView == nil) {
        
        CGFloat y = CGRectGetMaxY(self.navgationView.frame);
        
        _notHasView = [[AddressNotHasView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, ScreenHeight - y)];
        [_notHasView setDelegagte:self];
    }
    return _notHasView;

}

-(AddressListView *)listView{
    if (_listView == nil) {
           
           CGFloat y = CGRectGetMaxY(self.navgationView.frame);
           
           _listView = [[AddressListView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, ScreenHeight - y)];
        
        [_listView setHidden:YES];
        [_listView setDelegate:self];
       }
       return _listView;
}

-(void)setAddressListModel:(AddressListModel *)addressListModel{
    _addressListModel = addressListModel;
}

@end
