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
#import "DataManager.h"

#import "SaveBuyCarModel.h"

@interface GoodsDetailsViewController ()<GoodsDetailBottomViewDelegate, GoodsSpecificationViewDelegate, GoodsAddressListViewDelegate, UINavigationControllerDelegate, CreateAddressViewControllerDelegate, AddressViewControllerDelegate>

@property(nonatomic, strong)GoodsDetailsView *goodsDetailsView;

@property(nonatomic, strong)GoodsDetailBottomView *bottomView;

@property(nonatomic, strong)GoodsAddressListView *listView;

@property(nonatomic, strong)NSArray *addressArray;

@property(nonatomic, copy)NSString *goodsNumber;

@property(nonatomic, copy)NSString *attrId;

@property(nonatomic, copy)NSString *attrGoodsImageStr;

@property(nonatomic, copy)NSString *attrName;

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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:KVideoPlayStatusStop object:@(YES)];
}

#pragma mark - methods

- (void)initUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view setBackgroundColor:BackgroundColor_White];
    [self.view addSubview:self.goodsDetailsView];
    
    __weak typeof(self)weakSelf = self;
    //商品规格
    self.goodsDetailsView.goodsSpecificationBlock = ^(BOOL istap) {
        
        GoodsSpecificationView *specificationView = [[GoodsSpecificationView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        
        [specificationView setGoodsNumber:weakSelf.goodsNumber];
        
        [specificationView setGoodsAttrId:weakSelf.attrId];
        
        [specificationView setDelegate:weakSelf];
        
        UIWindow *window =[[UIApplication sharedApplication]keyWindow];
        specificationView.model = weakSelf.infoModel;
        [window addSubview:specificationView];
    };
    // 跳转店铺
    self.goodsDetailsView.goodsStoreInfoCellBlock = ^(BOOL istap) {
        StoreViewController *storeVC = [[StoreViewController alloc]init];
        storeVC.storeId = weakSelf.infoModel.clubId;
        [weakSelf.navigationController pushViewController:storeVC animated:YES];
    };
    
    //在线客服
    self.goodsDetailsView.goodsStoreInfoCellOnlineCustomerServiceBlock  = ^(BOOL istap) {
//        EMChatViewController *chatVC = [[EMChatViewController alloc] initWithConversationId:@"2" type:EMConversationTypeChat createIfNotExist:YES];
//        [weakSelf.navigationController pushViewController:chatVC animated:YES];
//
        CustomerServicViewController *customerServicVC = [[CustomerServicViewController alloc]init];
        customerServicVC.imID = weakSelf.storeInfoModel.im;
        customerServicVC.servicType = @"1";
        customerServicVC.chatName = weakSelf.storeInfoModel.name;

        [weakSelf.navigationController pushViewController:customerServicVC animated:YES];
        
        
    };
    // 地址
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

- (void)closeAddressListView{
    [self.listView removeFromSuperview];
}

- (void)createAddress{
    CreateAddressViewController *createAddressVC = [[CreateAddressViewController alloc]init];
    createAddressVC.type = AddressCreateType;
    [createAddressVC setDelegate:self];
    [self.navigationController pushViewController:createAddressVC animated:YES];
    //    [self.listView removeFromSuperview];
}

- (void)initData{
    
    [[DataManager shareInstance] getOrderAndCartCount];
    
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
            [storeParam setValue:model.clubId forKey:@"clubId"];
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
                
//                NSString *goods = [NSString stringWithFormat:@"id=%@,num=1",model.goodsid];
                
                
                NSArray *goods = @[@{@"id" : model.goodsid,
                                     @"num" : @"1"
                                     
                }];
                
                [dic setValue:goods forKey:@"goods"];
                
                
                [dic setValue:adressListModel.addressId forKey:@"addressId"];
//                [dic setValue:model.templateId forKey:@"templateId"];
                
                [[DataManager shareInstance]computeGoodsFee:dic Callback:^(NSDictionary *object) {
                    
                    NSArray *array = [object objectForKey:DATAS];
                    NSDictionary *dic = array[0];
                    NSString *fee = [NSString stringWithFormat:@"%@", dic[@"goodsFee"]];
                    [self.goodsDetailsView setFeeStr:fee];
                }];
            }];
            
        }
    }];
}

//跳转到立即购买
- (void)jumpBuyNow{
    NSMutableArray *modelMutabelArray = [NSMutableArray array];
    NSMutableDictionary *tam = [NSMutableDictionary dictionary];
    [tam setValue:self.storeInfoModel forKey:@"stroeInfo"];
    
    ShoppingCartGoodsModel *cartGoodModel = [[ShoppingCartGoodsModel alloc]init];
    
    cartGoodModel.desc = self.infoModel.desc;
    
    //商品图片,当规格有图片就用规格图片，规格图片没有就用商品封面图
    if (NotNilAndNull(self.attrGoodsImageStr)) {
        cartGoodModel.imgDataList = @[self.attrGoodsImageStr];
    } else {
        cartGoodModel.imgDataList = self.infoModel.imgDataList;
    }
//    cartGoodModel.imgDataList = @[NotNilAndNull(self.attrGoodsImageStr)?self.attrGoodsImageStr:@""];
//    cartGoodModel.imgDataList = self.infoModel.imgDataList;
    
    cartGoodModel.price = self.infoModel.price;
    cartGoodModel.stock = self.infoModel.stock;
    cartGoodModel.storeType = @"1";
    cartGoodModel.user_num = self.infoModel.userNum;
    cartGoodModel.goodsId = self.infoModel.goodsid;
    
    
    cartGoodModel.price = self.infoModel.price;
  
    
    cartGoodModel.goodsAttrId = self.attrId;
    cartGoodModel.num = self.goodsNumber == nil?@"1":self.goodsNumber;
    cartGoodModel.goodsName = self.infoModel.name;
    if (self.attrId != nil) {
        cartGoodModel.goodsAttrId = self.attrId;
        cartGoodModel.goodsAttrStrName = self.attrName;
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
- (void)bottomView:(GoodsDetailBottomView *)view tapAddCart:(BOOL)isTap{
    
    if ([self.infoModel.attr count] > 0){
        //取出所有的规格
//        NSArray *attr = [self.infoModel.attr firstObject];
        NSArray *attr = self.infoModel.attr;

        
        if (attr.count > 0) {
            for (int i = 0 ; i < attr.count; i++) {

                NSDictionary *dataDic = attr[i];
                id dataModel =  dataDic[@"name"];
                if([dataModel isKindOfClass:[NSNull class]] != YES){
                    if (self.attrId == nil ||self.attrId.length == 0) {
//                        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请选择商品规格") view:self.view afterDelay:TipSeconds];
                        
                        GoodsSpecificationView *specificationView = [[GoodsSpecificationView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                        
                        [specificationView setGoodsNumber:self.goodsNumber];
                        
                        [specificationView setGoodsAttrId:self.attrId];
                        
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
    [param setValue:self.infoModel.goodsid forKey:@"goodsId"];
    
    if (self.goodsNumber == nil) {
        [param setValue:@"1" forKey:@"num"];
    }else{
        [param setValue:self.goodsNumber forKey:@"num"];
    }
    
    [param setValue:self.attrId forKey:@"attrId"];
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[DataManager shareInstance]addCar:param Callback:^(Message *message) {
        [hud hideAnimated:YES];
        [[DataManager shareInstance] getOrderAndCartCount];
        
        SaveBuyCarModel *model = [[SaveBuyCarModel alloc]init];
        model.goodsId = self.infoModel.goodsid;
        model.goodsAttrId = self.attrId;
        
        [[ModelTool shareInstance] deleteTableEnum:TableNameSaveBuyCar where:[NSString stringWithFormat:@"goodsId = '%@' and goodsAttrId = '%@' and userId = '%@'",  model.goodsId, model.goodsAttrId, model.userID]];
        
        [[ModelTool shareInstance] insert:model tableEnum:TableNameSaveBuyCar];
        
        [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
        
    }];
}

//立即购买
- (void)bottomView:(GoodsDetailBottomView *)view tapNowBuy:(BOOL)isTap{
    
    if ([self.infoModel.attr count] > 0){
        //取出所有的规格
//        NSArray *attr = [self.infoModel.attr firstObject];
        NSArray *attr = self.infoModel.attr;
        if (attr.count > 0) {
            for (int i = 0 ; i < attr.count; i++) {
                NSDictionary *dataDic = attr[i];
                id dataModel =  dataDic[@"name"];
                if([dataModel isKindOfClass:[NSNull class]] != YES){
                    if (self.attrId == nil ||self.attrId.length == 0) {
//                        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请选择商品规格") view:self.view afterDelay:TipSeconds];
                        
                        GoodsSpecificationView *specificationView = [[GoodsSpecificationView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                        
                        [specificationView setGoodsNumber:self.goodsNumber];
                        
                        [specificationView setGoodsAttrId:self.attrId];
                        
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
    
    if(self.attrId != nil && self.attrId.length > 0){
        [param setValue:self.attrId forKey:@"goodsAttrId"];
    }
    
    if (self.goodsNumber != nil) {
        [param setValue:self.goodsNumber forKey:@"num"];
    }else{
        [param setValue:@"1" forKey:@"num"];
    }
    
    
    
    [param setValue:self.infoModel.goodsid forKey:@"goodsId"];
    
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
- (void)bottomView:(GoodsDetailBottomView *)view tapCart:(BOOL)isTap{
    
    ShoppingCartViewController *shoppingCartVC = [[ShoppingCartViewController alloc]init];
    
    [self.navigationController pushViewController:shoppingCartVC animated:YES];
    
}

//店铺
- (void)bottomView:(GoodsDetailBottomView *)view tapStore:(BOOL)isTap{
    StoreViewController *storeVC = [[StoreViewController alloc]init];
    storeVC.storeId = self.infoModel.clubId;
    [self.navigationController pushViewController:storeVC animated:YES];
}

//在线客服   发送给指定对象
- (void)bottomView:(GoodsDetailBottomView *)view tapService:(BOOL)isTap{
    //    EMChatViewController *chatVC = [[EMChatViewController alloc] initWithConversationId:@"2" type:EMConversationTypeChat createIfNotExist:YES];
    //    [self.navigationController pushViewController:chatVC animated:YES];
    
    
    CustomerServicViewController *customerServicVC = [[CustomerServicViewController alloc]init];
    
    customerServicVC.imID = self.storeInfoModel.im;
    customerServicVC.servicType = @"1";
    customerServicVC.chatName = self.storeInfoModel.name;
    [self.navigationController pushViewController:customerServicVC animated:YES];
}

- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - GoodsSpecificationViewDelegate

- (void)getSpecification:(NSDictionary *)dic{
    [self.goodsDetailsView setSpecificaationStr:dic[@"attrS"]];
    self.goodsNumber = dic[@"num"];
    
    if (dic[@"attrId"] != nil) {
        self.attrId = dic[@"attrId"];
    }
    
    if (dic[@"attrName"] != nil) {
        self.attrName =dic[@"attrName"];
    }
    
    
    self.attrGoodsImageStr = dic[@"attrGoodsImage"];
    
    NSString *currentPrice = dic[@"currentPrice"];
    if (currentPrice != nil) {
//        if ([self.infoModel.isDiscount boolValue] == YES) {
            self.infoModel.oldPrice = dic[@"oldPrice"];
            self.infoModel.price = currentPrice;
           
//        }else{
//            self.infoModel.oldPrice = currentPrice;
//        }
//        self.infoModel.old_price = currentPrice;
//        self.infoModel.price = currentPrice;
        [self.goodsDetailsView setInfoModel:self.infoModel];
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//      [param setValue:self.infoModel.goodsid forKey:@"goods_id"];
      
    NSString *number;
      if (self.goodsNumber == nil) {
//          [param setValue:@"1" forKey:@"num"];
          number = @"1";
      }else{
//          [param setValue:self.goodsNumber forKey:@"num"];
          number = self.goodsNumber;
      }
    
    NSArray *goods = @[@{@"id" : self.infoModel.goodsid,
                         @"num" : number,
                         @"attrId" : self.attrId
    }];
    
      
//    [param setValue:self.attr_id forKey:@"goods_attr_id"];
    
//    NSString *goods = [NSString stringWithFormat:@"id=%@,num=%@",self.infoModel.goodsid, param[@"num"]];
    
    [param setValue:goods forKey:@"goods"];
    
    
    [param setValue:self.currentAddressModel.addressId forKey:@"addressId"];
    
    [[DataManager shareInstance]computeGoodsFee:param Callback:^(NSDictionary *object) {
        
        NSArray *array = [object objectForKey:DATAS];
        NSDictionary *dic = array[0];
        NSString *fee = [NSString stringWithFormat:@"%@", dic[@"goodsFee"]];
        [self.goodsDetailsView setFeeStr:fee];
    }];
    
}

//选择规格 加入购物车
- (void)tapAddCart:(NSDictionary *)dic{
    
    [self.goodsDetailsView setSpecificaationStr:dic[@"attrS"]];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if (dic[@"attrId"] != nil) {
        
        [param setValue:dic[@"attrId"] forKey:@"attrId"];
    }
    
    self.goodsNumber = dic[@"num"];
    
    [param setValue:dic[@"num"] forKey:@"num"];
    [param setValue:self.infoModel.goodsid forKey:@"goodsId"];
    
    NSString *currentPrice = dic[@"currentPrice"];
    if (currentPrice != nil) {
//        self.infoModel.oldPrice = currentPrice;
//        [self.goodsDetailsView setInfoModel:self.infoModel];
        self.infoModel.oldPrice = dic[@"oldPrice"];
        self.infoModel.price = currentPrice;
        [self.goodsDetailsView setInfoModel:self.infoModel];
    }
    
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[DataManager shareInstance]addCar:param Callback:^(Message *message) {
        [hud hideAnimated:YES];
        
        
        [[DataManager shareInstance] getOrderAndCartCount];
        
        
        SaveBuyCarModel *model = [[SaveBuyCarModel alloc]init];
        model.goodsId = self.infoModel.goodsid;
        model.goodsAttrId = dic[@"attrId"];
        
        [[ModelTool shareInstance] deleteTableEnum:TableNameSaveBuyCar where:[NSString stringWithFormat:@"goodsId = '%@' and goodsAttrId = '%@' and userId = '%@'",  model.goodsId, model.goodsAttrId, model.userID]];
        
        [[ModelTool shareInstance] insert:model tableEnum:TableNameSaveBuyCar];
        
        
        [ShaolinProgressHUD singleTextHud:message.reason view:WINDOWSVIEW afterDelay:TipSeconds];
        
    }];
}

//选择规格 立即购买
- (void)tapBuy:(NSDictionary *)dic{
    
    //    if ([self.addressArray count] == 0) {
    //        [SLProgressHUDManagar showTipMessageInHUDView:self.view withMessage:SLLocalizedString(@"请选择收货地址") afterDelay:TipSeconds];
    //        return;
    //    }
    
    self.goodsNumber = dic[@"num"];
    
    if (dic[@"attrId"] != nil) {
        self.attrId = dic[@"attrId"];
    }
    
    if (dic[@"attrName"] != nil) {
        self.attrName =dic[@"attrName"];
    }
    
    self.attrGoodsImageStr = dic[@"attrGoodsImage"];
    
    NSString *currentPrice = dic[@"currentPrice"];
    if (currentPrice != nil) {
//        self.infoModel.oldPrice = currentPrice;
//        [self.goodsDetailsView setInfoModel:self.infoModel];
        self.infoModel.oldPrice = dic[@"oldPrice"];
        self.infoModel.price = currentPrice;
        [self.goodsDetailsView setInfoModel:self.infoModel];
    }
    
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if(self.attrId != nil && self.attrId.length > 0){
        [param setValue:self.attrId forKey:@"goodsAttrId"];
    }
    
    [param setValue:self.goodsNumber forKey:@"num"];
    
    [param setValue:self.infoModel.goodsid forKey:@"goodsId"];
    
    [ModelTool calculateCountingChamber:[self.goodsNumber integerValue] numericalValidationType:NumericalValidationAddType param:param check:CheckInventoryGoodsType callBack:^(NSInteger currentCountNumber, BOOL isSuccess, Message *message) {
        
        if (isSuccess == YES) {
            [self jumpBuyNow];
        }else{
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"商品库存不足") view:self.view afterDelay:TipSeconds];
        }
    }];
}

#pragma mark - GoodsAddressListViewDelegate
- (void)tapAddress:(NSInteger)row{
    self.currentAddressModel = self.addressArray[row];
    [self.goodsDetailsView setAddressModel:self.currentAddressModel];
    
    
    
}

#pragma mark - CreateAddressViewControllerDelegate
- (void)isHasNewAddress{
    //地址列表
    [[DataManager shareInstance]getAddressListCallback:^(NSArray *result) {
        self.addressArray = result;
        
        
        [self.listView setDataArray:self.addressArray];
    }];
    
}

#pragma mark -  AddressViewControllerDelegate
- (void)addressViewController:(AddressViewController *)vc tapList:(AddressListModel *)model{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.addressArray];
    [array addObject:model];
    
    self.addressArray = array;
    
    [self.goodsDetailsView setAddressModel:model];
}

- (void)addressViewController:(AddressViewController *)vc tapBack:(AddressListModel *)model{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.addressArray];
    [array addObject:model];
    
    self.addressArray = array;
    
    self.currentAddressModel = model;
    [self.goodsDetailsView setAddressModel:model];
}

- (GoodsDetailsView *)goodsDetailsView{
    if (_goodsDetailsView == nil) {
        _goodsDetailsView = [[GoodsDetailsView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBar_Height - Height_TabBar)];
    }
    
    return _goodsDetailsView;
}

- (GoodsDetailBottomView *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [[GoodsDetailBottomView alloc]initWithFrame:CGRectMake(0, ScreenHeight - NavBar_Height - Height_TabBar, self.view.width, Height_TabBar)];
        
        [_bottomView setDelegagte:self];
    }
    return _bottomView;
}

- (GoodsAddressListView *)listView{
    
    if (_listView == nil) {
        _listView = [[GoodsAddressListView alloc]initWithFrame:self.view.bounds];
        [_listView setDelegate:self];
    }
    return _listView;
}

- (void)setCurrentAddressModel:(AddressListModel *)currentAddressModel{
    _currentAddressModel = currentAddressModel;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//      [param setValue:self.infoModel.goodsid forKey:@"goods_id"];
      
    NSString *number;
      if (self.goodsNumber == nil) {
//          [param setValue:@"1" forKey:@"num"];
          number = @"1";
      }else{
//          [param setValue:self.goodsNumber forKey:@"num"];
          number = self.goodsNumber;
      }
      
//      [param setValue:self.attr_id forKey:@"goods_attr_id"];
    
//    NSString *goods = [NSString stringWithFormat:@"id=%@,num=%@",self.infoModel.goodsid, param[@"num"]];
    NSArray *goods;
    if (self.attrId) {
        goods = @[@{@"id" : self.infoModel.goodsid,
                             @"num" : number,
                             @"attrId" : self.attrId
        }];
    }else{
        goods = @[@{@"id" : self.infoModel.goodsid,
                             @"num" : number,
        }];
    }
    
    
    
    [param setValue:goods forKey:@"goods"];
    
    
    [param setValue:currentAddressModel.addressId forKey:@"addressId"];
    
    [[DataManager shareInstance]computeGoodsFee:param Callback:^(NSDictionary *object) {
        
        NSArray *array = [object objectForKey:@"data"];
        NSDictionary *dic = array[0];
        NSString *fee = [NSString stringWithFormat:@"%@", dic[@"goodsFee"]];
        [self.goodsDetailsView setFeeStr:fee];
    }];
    

    
}


- (void)dealloc{
   
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - device
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
@end
