//
//  GoodsDetailsViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/25.
//  Copyright © 2020 syqaxldy. All rights reserved.
// 商品详情

#import "GoodsDetailsViewController.h"

#import "WengenGoodsModel.h"

#import "GoodsInfoModel.h"

#import "GoodsStoreInfoModel.h"

#import "GoodsDetailsView.h"

#import "GoodsDetailBottomView.h"

#import "GoodsSpecificationView.h"

#import "WengenNavgationView.h"

#import "AddressViewController.h"

#import "AddressListModel.h"

#import "GoodsAddressListView.h"

#import "CreateAddressViewController.h"

#import "ShoppingCartViewController.h"

#import "OrderFillViewController.h"

#import "ShoppingCartGoodsModel.h"

#import "StoreViewController.h"

#import "EMChatViewController.h"

#import "CustomerServicViewController.h"

@interface GoodsDetailsViewController ()<GoodsDetailBottomViewDelegate, WengenNavgationViewDelegate, GoodsSpecificationViewDelegate, GoodsAddressListViewDelegate, UINavigationControllerDelegate, CreateAddressViewControllerDelegate, AddressViewControllerDelegate>

@property(nonatomic, strong)GoodsDetailsView *goodsDetailsView;

@property(nonatomic, strong)GoodsDetailBottomView *bottomView;

@property(nonatomic, strong)WengenNavgationView *navgationView;

@property(nonatomic, strong)GoodsAddressListView *listView;

@property(nonatomic, strong)NSArray *addressArray;

@property(nonatomic, copy)NSString *goodsNumber;

@property(nonatomic, copy)NSString *attr_id;

@property(nonatomic, copy)NSString *attr_name;

@property(nonatomic, strong)GoodsStoreInfoModel *storeInfoModel;

@property(nonatomic, strong)GoodsInfoModel *infoModel;

@property(nonatomic, strong)AddressListModel *currentAddressModel;




@end

@implementation GoodsDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initUI];
    
    
    
    [self.navigationController setDelegate:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - methods

-(void)initUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view setBackgroundColor:BackgroundColor_White];
    
    [self.view addSubview:self.navgationView];
    
    [self.view addSubview:self.goodsDetailsView];
    
    __weak typeof(self)weakSelf = self;
    
    self.goodsDetailsView.goodsSpecificationBlock = ^(BOOL istap) {
        
        GoodsSpecificationView *specificationView = [[GoodsSpecificationView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        
        [specificationView setGoodsNumber:weakSelf.goodsNumber];
        
        [specificationView setGoods_attr_id:weakSelf.attr_id];
        
        [specificationView setDelegate:weakSelf];
        
        UIWindow *window =[[UIApplication sharedApplication]keyWindow];
        specificationView.model = weakSelf.infoModel;
        [window addSubview:specificationView];
    };
    
    self.goodsDetailsView.goodsStoreInfoCellBlock = ^(BOOL istap) {
        StoreViewController *storeVC = [[StoreViewController alloc]init];
        storeVC.storeId = weakSelf.infoModel.club_id;
        [weakSelf.navigationController pushViewController:storeVC animated:YES];
    };
    
    
    self.goodsDetailsView.goodsStoreInfoCellOnlineCustomerServiceBlock  = ^(BOOL istap) {
//        EMChatViewController *chatVC = [[EMChatViewController alloc] initWithConversationId:@"2" type:EMConversationTypeChat createIfNotExist:YES];
//        [weakSelf.navigationController pushViewController:chatVC animated:YES];
//
        CustomerServicViewController *customerServicVC = [[CustomerServicViewController alloc]init];
        customerServicVC.imID = weakSelf.storeInfoModel.im;
        [weakSelf.navigationController pushViewController:customerServicVC animated:YES];
        
        
    };
    
    self.goodsDetailsView.goodsAddressBlock = ^(BOOL istap) {
        
        if (self.addressArray.count == 0) {
            AddressViewController *addressVC = [[AddressViewController alloc]init];
            addressVC.isAutoBack = YES;
            
            [addressVC setDelegate:weakSelf];
            
            [weakSelf.navigationController pushViewController:addressVC animated:YES];
        }else{
            
            [weakSelf.view addSubview:weakSelf.listView];
            [weakSelf.listView setDataArray:weakSelf.addressArray];
            [weakSelf.listView closeTarget:weakSelf action:@selector(closeAddressListView)];
            
            [weakSelf.listView createAddressTarget:weakSelf action:@selector(createAddress)];
            
        }
    };
    
    [self.view addSubview:self.bottomView];
}

-(void)closeAddressListView{
    [self.listView removeFromSuperview];
}

-(void)createAddress{
    CreateAddressViewController *createAddressVC = [[CreateAddressViewController alloc]init];
    createAddressVC.type = AddressCreateType;
    [createAddressVC setDelegate:self];
    [self.navigationController pushViewController:createAddressVC animated:YES];
    //    [self.listView removeFromSuperview];
}

-(void)initData{
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.goodsModel.goodsId forKey:@"id"];
    //商品详情信息
    [[DataManager shareInstance]getGoodsInfo:param Callback:^(NSObject *object) {
        [hud hideAnimated:YES];
        
        if (object == nil) {
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"获取商品数据失败") view:WINDOWSVIEW afterDelay:TipSeconds];
            
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        if ([object isKindOfClass:[GoodsInfoModel class]] == YES) {
            GoodsInfoModel *model = (GoodsInfoModel *)object;
            self.infoModel = model;
            [self.goodsDetailsView setInfoModel:model];
            
            NSMutableDictionary *storeParam = [NSMutableDictionary dictionary];
            [storeParam setValue:model.club_id forKey:@"id"];
            //店铺信息
            [[DataManager shareInstance]getStoreInfo:storeParam Callback:^(NSObject *object) {
                if ([object isKindOfClass:[GoodsStoreInfoModel class]] == YES) {
                    GoodsStoreInfoModel *storeInfoModel = (GoodsStoreInfoModel *)object;
                    self.storeInfoModel = storeInfoModel;
                    [self.goodsDetailsView setStoreInfoModel:storeInfoModel];
                }
            }];
            //地址列表
            [[DataManager shareInstance]getAddressListCallback:^(NSArray *result) {
                
                
                self.addressArray = result;
                
                AddressListModel *listModel = [ModelTool getAddress:self.addressArray];
                [self.goodsDetailsView setAddressModel:listModel];
                self.currentAddressModel = listModel;
                
                AddressListModel *adressListModel = listModel;
                adressListModel.isSelected = YES;
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                
                NSString *goods = [NSString stringWithFormat:@"id=%@,num=1",model.goodsid];
                
                [dic setValue:goods forKey:@"goods"];
                
                
                [dic setValue:adressListModel.addressId forKey:@"address_id"];
                
                [[DataManager shareInstance]computeGoodsFee:dic Callback:^(NSDictionary *object) {
                    
                    NSArray *array = [object objectForKey:@"list"];
                    NSDictionary *dic = array[0];
                    NSString *fee = [NSString stringWithFormat:@"%@", dic[@"fee"]];
                    [self.goodsDetailsView setFeeStr:fee];
                }];
            }];
            
        }
    }];
}

//跳转到立即购买
-(void)jumpBuyNow{
    NSMutableArray *modelMutabelArray = [NSMutableArray array];
    NSMutableDictionary *tam = [NSMutableDictionary dictionary];
    [tam setValue:self.storeInfoModel forKey:@"stroeInfo"];
    
    ShoppingCartGoodsModel *cartGoodModel = [[ShoppingCartGoodsModel alloc]init];
    
    cartGoodModel.name = self.infoModel.name;
    cartGoodModel.desc = self.infoModel.desc;
    cartGoodModel.img_data = self.infoModel.img_data;
    cartGoodModel.price = self.infoModel.price;
    cartGoodModel.stock = self.infoModel.stock;
    cartGoodModel.store_type = @"1";
    cartGoodModel.user_num = self.infoModel.user_num;
    cartGoodModel.goods_id = self.infoModel.goodsid;
    
    if ([self.infoModel.is_discount boolValue] == YES) {
        cartGoodModel.current_price = self.infoModel.old_price;
    }else{
        cartGoodModel.current_price = self.infoModel.price;
    }
    
    
    cartGoodModel.goods_attr_id = self.attr_id;
    cartGoodModel.num = self.goodsNumber == nil?@"1":self.goodsNumber;
    cartGoodModel.name = self.infoModel.name;
    cartGoodModel.name = self.infoModel.name;
    if (self.attr_id != nil) {
        cartGoodModel.goods_attr_id = self.attr_id;
        cartGoodModel.attr_name = self.attr_name;
    }
    [tam setValue:@[cartGoodModel] forKey:@"goods"];
    
    [modelMutabelArray addObject:tam];
    OrderFillViewController *orderFillVC = [[OrderFillViewController alloc]init];
    orderFillVC.addressId = self.currentAddressModel.addressId;
    orderFillVC.dataArray = modelMutabelArray;
    [self.navigationController pushViewController:orderFillVC animated:YES];
}

#pragma mark - GoodsDetailBottomViewDelegate
//加入购物车
-(void)bottomView:(GoodsDetailBottomView *)view tapAddCart:(BOOL)isTap{
    
    if ([self.infoModel.attr count] > 0){
        //取出所有的规格
        NSArray *attr = [self.infoModel.attr firstObject];
        
        
        if (attr.count > 0) {
            for (int i = 0 ; i < attr.count; i++) {
                NSDictionary *dataDic = attr[i];
                id dataModel =  dataDic[@"attr"][@"name"];
                if([dataModel isKindOfClass:[NSNull class]] != YES){
                    if (self.attr_id == nil ||self.attr_id.length == 0) {
//                        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请选择商品规格") view:self.view afterDelay:TipSeconds];
                        
                        GoodsSpecificationView *specificationView = [[GoodsSpecificationView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                        
                        [specificationView setGoodsNumber:self.goodsNumber];
                        
                        [specificationView setGoods_attr_id:self.attr_id];
                        
                        [specificationView setDelegate:self];
                        
                        UIWindow *window =[[UIApplication sharedApplication]keyWindow];
                        specificationView.model = self.infoModel;
                        [window addSubview:specificationView];
                        
                        return;
                    }
                }
            }
        }
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.infoModel.goodsid forKey:@"goods_id"];
    
    if (self.goodsNumber == nil) {
        [param setValue:@"1" forKey:@"num"];
    }else{
        [param setValue:self.goodsNumber forKey:@"num"];
    }
    
    [param setValue:self.attr_id forKey:@"goods_attr_id"];
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[DataManager shareInstance]addCar:param Callback:^(Message *message) {
        [hud hideAnimated:YES];
        [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
        
    }];
}

//立即购买
-(void)bottomView:(GoodsDetailBottomView *)view tapNowBuy:(BOOL)isTap{
    
    if ([self.infoModel.attr count] > 0){
        //取出所有的规格
        NSArray *attr = [self.infoModel.attr firstObject];
        if (attr.count > 0) {
            for (int i = 0 ; i < attr.count; i++) {
                NSDictionary *dataDic = attr[i];
                id dataModel =  dataDic[@"attr"][@"name"];
                if([dataModel isKindOfClass:[NSNull class]] != YES){
                    if (self.attr_id == nil ||self.attr_id.length == 0) {
//                        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请选择商品规格") view:self.view afterDelay:TipSeconds];
                        
                        GoodsSpecificationView *specificationView = [[GoodsSpecificationView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                        
                        [specificationView setGoodsNumber:self.goodsNumber];
                        
                        [specificationView setGoods_attr_id:self.attr_id];
                        
                        [specificationView setDelegate:self];
                        
                        UIWindow *window =[[UIApplication sharedApplication]keyWindow];
                        specificationView.model = self.infoModel;
                        [window addSubview:specificationView];
                        
                        
                        return;
                    }
                }
            }
        }
        
    }
    
    
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if(self.attr_id != nil && self.attr_id.length > 0){
        [param setValue:self.attr_id forKey:@"goods_attr_id"];
    }
    
    if (self.goodsNumber != nil) {
        [param setValue:self.goodsNumber forKey:@"num"];
    }else{
        [param setValue:@"1" forKey:@"num"];
    }
    
    [param setValue:self.infoModel.goodsid forKey:@"goods_id"];
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:@""];
    
    [ModelTool calculateCountingChamber:[self.goodsNumber integerValue] numericalValidationType:NumericalValidationAddType param:param check:CheckInventoryGoodsType callBack:^(NSInteger currentCountNumber, BOOL isSuccess, Message *message) {
        [hud hideAnimated:YES];
        if (isSuccess == YES) {
            [self jumpBuyNow];
        }else{
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"商品库存不足") view:self.view afterDelay:TipSeconds];
        }
    }];
}

//购物车
-(void)bottomView:(GoodsDetailBottomView *)view tapCart:(BOOL)isTap{
    
    ShoppingCartViewController *shoppingCartVC = [[ShoppingCartViewController alloc]init];
    
    [self.navigationController pushViewController:shoppingCartVC animated:YES];
    
}

//店铺
-(void)bottomView:(GoodsDetailBottomView *)view tapStore:(BOOL)isTap{
    StoreViewController *storeVC = [[StoreViewController alloc]init];
    storeVC.storeId = self.infoModel.club_id;
    [self.navigationController pushViewController:storeVC animated:YES];
}

//在线客服   发送给指定对象
-(void)bottomView:(GoodsDetailBottomView *)view tapService:(BOOL)isTap{
    //    EMChatViewController *chatVC = [[EMChatViewController alloc] initWithConversationId:@"2" type:EMConversationTypeChat createIfNotExist:YES];
    //    [self.navigationController pushViewController:chatVC animated:YES];
    
    
    CustomerServicViewController *customerServicVC = [[CustomerServicViewController alloc]init];
    customerServicVC.imID = self.storeInfoModel.im;
    [self.navigationController pushViewController:customerServicVC animated:YES];
}

#pragma mark - WengenNavgationViewDelegate
-(void)tapBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - GoodsSpecificationViewDelegate

-(void)getSpecification:(NSDictionary *)dic{
    [self.goodsDetailsView setSpecificaationStr:dic[@"attr_s"]];
    self.goodsNumber = dic[@"num"];
    
    if (dic[@"attr_id"] != nil) {
        self.attr_id = dic[@"attr_id"];
    }
    
    if (dic[@"attr_name"] != nil) {
        self.attr_name =dic[@"attr_name"];
    }
    
    
    NSString *currentPrice = dic[@"currentPrice"];
    if (currentPrice != nil) {
        self.infoModel.old_price = currentPrice;
        self.infoModel.price = currentPrice;
        [self.goodsDetailsView setInfoModel:self.infoModel];
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
      [param setValue:self.infoModel.goodsid forKey:@"goods_id"];
      
      if (self.goodsNumber == nil) {
          [param setValue:@"1" forKey:@"num"];
      }else{
          [param setValue:self.goodsNumber forKey:@"num"];
      }
      
      [param setValue:self.attr_id forKey:@"goods_attr_id"];
    
    NSString *goods = [NSString stringWithFormat:@"id=%@,num=%@",self.infoModel.goodsid, param[@"num"]];
    
    [param setValue:goods forKey:@"goods"];
    
    
    [param setValue:self.currentAddressModel.addressId forKey:@"address_id"];
    
    [[DataManager shareInstance]computeGoodsFee:param Callback:^(NSDictionary *object) {
        
        NSArray *array = [object objectForKey:@"list"];
        NSDictionary *dic = array[0];
        NSString *fee = [NSString stringWithFormat:@"%@", dic[@"fee"]];
        [self.goodsDetailsView setFeeStr:fee];
    }];
    
}

//选择规格 加入购物车
-(void)tapAddCart:(NSDictionary *)dic{
    
    [self.goodsDetailsView setSpecificaationStr:dic[@"attr_s"]];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if (dic[@"attr_id"] != nil) {
        
        [param setValue:dic[@"attr_id"] forKey:@"goods_attr_id"];
    }
    
    self.goodsNumber = dic[@"num"];
    
    [param setValue:dic[@"num"] forKey:@"num"];
    [param setValue:self.infoModel.goodsid forKey:@"goods_id"];
    
    NSString *currentPrice = dic[@"currentPrice"];
    if (currentPrice != nil) {
        self.infoModel.old_price = currentPrice;
        [self.goodsDetailsView setInfoModel:self.infoModel];
    }
    
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[DataManager shareInstance]addCar:param Callback:^(Message *message) {
        [hud hideAnimated:YES];
        [ShaolinProgressHUD singleTextHud:message.reason view:WINDOWSVIEW afterDelay:TipSeconds];
        
    }];
}

//选择规格 立即购买
-(void)tapBuy:(NSDictionary *)dic{
    
    //    if ([self.addressArray count] == 0) {
    //        [SLProgressHUDManagar showTipMessageInHUDView:self.view withMessage:SLLocalizedString(@"请选择收货地址") afterDelay:TipSeconds];
    //        return;
    //    }
    
    self.goodsNumber = dic[@"num"];
    
    if (dic[@"attr_id"] != nil) {
        self.attr_id = dic[@"attr_id"];
    }
    
    if (dic[@"attr_name"] != nil) {
        self.attr_name =dic[@"attr_name"];
    }
    
    NSString *currentPrice = dic[@"currentPrice"];
    if (currentPrice != nil) {
        self.infoModel.old_price = currentPrice;
        [self.goodsDetailsView setInfoModel:self.infoModel];
    }
    
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if(self.attr_id != nil && self.attr_id.length > 0){
        [param setValue:self.attr_id forKey:@"goods_attr_id"];
    }
    
    [param setValue:self.goodsNumber forKey:@"num"];
    
    [param setValue:self.infoModel.goodsid forKey:@"goods_id"];
    
    [ModelTool calculateCountingChamber:[self.goodsNumber integerValue] numericalValidationType:NumericalValidationAddType param:param check:CheckInventoryGoodsType callBack:^(NSInteger currentCountNumber, BOOL isSuccess, Message *message) {
        
        if (isSuccess == YES) {
            [self jumpBuyNow];
        }else{
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"商品库存不足") view:self.view afterDelay:TipSeconds];
        }
    }];
}

#pragma mark - GoodsAddressListViewDelegate
-(void)tapAddress:(NSInteger)row{
    self.currentAddressModel = self.addressArray[row];
    [self.goodsDetailsView setAddressModel:self.currentAddressModel];
    
    
    
}

#pragma mark - CreateAddressViewControllerDelegate
-(void)isHasNewAddress{
    //地址列表
    [[DataManager shareInstance]getAddressListCallback:^(NSArray *result) {
        self.addressArray = result;
        
        
        [self.listView setDataArray:self.addressArray];
    }];
    
}

#pragma mark -  AddressViewControllerDelegate
-(void)addressViewController:(AddressViewController *)vc tapList:(AddressListModel *)model{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.addressArray];
    [array addObject:model];
    
    self.addressArray = array;
    
    [self.goodsDetailsView setAddressModel:model];
}

-(void)addressViewController:(AddressViewController *)vc tapBack:(AddressListModel *)model{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.addressArray];
    [array addObject:model];
    
    self.addressArray = array;
    
    self.currentAddressModel = model;
    [self.goodsDetailsView setAddressModel:model];
}

#pragma mark - setter / getter

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

-(GoodsDetailsView *)goodsDetailsView{
    if (_goodsDetailsView == nil) {
        CGFloat height = ScreenHeight - Height_TabBar - 44;
        
        CGFloat y = CGRectGetMaxY(self.navgationView.frame);
        
        _goodsDetailsView = [[GoodsDetailsView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, height)];
    }
    
    return _goodsDetailsView;
}

-(GoodsDetailBottomView *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [[GoodsDetailBottomView alloc]initWithFrame:CGRectMake(0, ScreenHeight - Height_TabBar, ScreenWidth, Height_TabBar)];
        
        [_bottomView setDelegagte:self];
    }
    return _bottomView;
}

-(GoodsAddressListView *)listView{
    
    if (_listView == nil) {
        _listView = [[GoodsAddressListView alloc]initWithFrame:self.view.bounds];
        [_listView setDelegate:self];
    }
    return _listView;
}

-(void)setCurrentAddressModel:(AddressListModel *)currentAddressModel{
    _currentAddressModel = currentAddressModel;
    
    
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
      [param setValue:self.infoModel.goodsid forKey:@"goods_id"];
      
      if (self.goodsNumber == nil) {
          [param setValue:@"1" forKey:@"num"];
      }else{
          [param setValue:self.goodsNumber forKey:@"num"];
      }
      
      [param setValue:self.attr_id forKey:@"goods_attr_id"];
    
    NSString *goods = [NSString stringWithFormat:@"id=%@,num=%@",self.infoModel.goodsid, param[@"num"]];
    
    [param setValue:goods forKey:@"goods"];
    
    
    [param setValue:currentAddressModel.addressId forKey:@"address_id"];
    
    [[DataManager shareInstance]computeGoodsFee:param Callback:^(NSDictionary *object) {
        
        NSArray *array = [object objectForKey:@"list"];
        NSDictionary *dic = array[0];
        NSString *fee = [NSString stringWithFormat:@"%@", dic[@"fee"]];
        [self.goodsDetailsView setFeeStr:fee];
    }];
    
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
