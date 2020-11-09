//
//  AddressViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressNotHasView.h"

#import "AddressListView.h"

#import "AddressListModel.h"
#import "DataManager.h"
#import "CreateAddressViewController.h"

@interface AddressViewController ()<AddressNotHasViewDelegate, AddressListViewDelegate>

@property(nonatomic, strong)AddressNotHasView *notHasView;

@property(nonatomic, strong)AddressListView *listView;

@property(nonatomic, strong)NSArray *dataArray;

@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabe.text = SLLocalizedString(@"收货地址");
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    [super viewWillDisappear:animated];
}



#pragma mark - methods
-(void)initUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.notHasView];
    [self.view addSubview:self.listView];
    
}

-(void)leftAction{
    
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
    createAddressVC.type = AddressCreateType;
    
    [self.navigationController pushViewController:createAddressVC animated:YES];
}

#pragma mark - AddressListViewDelegate
-(void)addressListView:(AddressListView *)view tap:(BOOL)istap{
    
    CreateAddressViewController *createAddressVC = [[CreateAddressViewController alloc]init];
    createAddressVC.type = AddressCreateType;
    [self.navigationController pushViewController:createAddressVC animated:YES];
    
}

-(void)addressListView:(AddressListView *)view isModify:(AddressListModel *)model{
    
    CreateAddressViewController *createAddressVC = [[CreateAddressViewController alloc]init];
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

-(AddressNotHasView *)notHasView{
    
    if (_notHasView == nil) {
        _notHasView = [[AddressNotHasView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBar_Height)];
        [_notHasView setDelegagte:self];
    }
    return _notHasView;

}

-(AddressListView *)listView{
    if (_listView == nil) {
        _listView = [[AddressListView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBar_Height)];
        [_listView setHidden:YES];
        [_listView setDelegate:self];
       }
       return _listView;
}

-(void)setAddressListModel:(AddressListModel *)addressListModel{
    _addressListModel = addressListModel;
}

@end
