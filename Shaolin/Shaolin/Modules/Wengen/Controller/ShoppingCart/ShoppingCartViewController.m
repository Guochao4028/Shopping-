//
//  ShoppingCartViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/6.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ShoppingCartViewController.h"

#import "ShoppingCratFootView.h"

#import "ShoppingCratTableCell.h"

#import "ShoppingCartListModel.h"

#import "ShoppingCratHeadView.h"

#import "ShoppingCartGoodsModel.h"

#import "ShoppingCartNoGoodsView.h"

#import "GoodsSpecificationView.h"

#import "GoodsSpecificationView.h"

#import "GoodsInfoModel.h"

#import "GoodsStoreInfoModel.h"

#import "SMAlert.h"

#import "OrderFillViewController.h"

#import "StoreViewController.h"

#import "WengenGoodsModel.h"

#import "GoodsDetailsViewController.h"

#import "OrderFillCourseViewController.h"

#import "KungfuClassDetailViewController.h"

#import "SLRouteManager.h"
#import "DataManager.h"
#import "SaveBuyCarModel.h"

static NSString *const kShoppingCratTableCellIdentifier = @"ShoppingCratTableCell";

@interface ShoppingCartViewController ()<UITableViewDelegate, UITableViewDataSource, ShoppingCratTableCellDelegate, ShoppingCratHeadViewDelegate>

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)ShoppingCratFootView *footView;

@property(nonatomic, strong)ShoppingCartNoGoodsView *noGoodsView;

@property(nonatomic, strong)NSMutableArray *dataArray;

///是否开始编辑
@property(nonatomic, assign)BOOL isBeginEditing;


@end

@implementation ShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabe.text = SLLocalizedString(@"购物车");
    [self.rightBtn setTitle:SLLocalizedString(@"编辑") forState:UIControlStateNormal];
    [self initUI];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated{
   [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    NSFileManager*fileManager = [NSFileManager defaultManager];

    [fileManager removeItemAtPath:KTemporaryFilePath error:NULL];
}


#pragma mark - methods
- (void)initUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footView];
    [self.view addSubview:self.noGoodsView];
}

- (void)initData{
    
    [ModelTool getUserData:nil];
 
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [self.dataArray removeAllObjects];
    
    [[DataManager shareInstance]getOrderAndCartCount];
    
    [[DataManager shareInstance]getCartList:@{} Callback:^(NSArray *result) {
        [hud hideAnimated:YES];
        [self.tableView.mj_header endRefreshing];
        if (!result || result.count == 0) {
            [self.noGoodsView setHidden:NO];
            /// 删除保存选中信息文件
            [[ModelTool shareInstance] deleteTableEnum:TableNameSaveBuyCar where:@""];

        }else{
            [self.dataArray addObjectsFromArray:result];
            
            
            if (self.isBeginEditing == NO) {
                
                for (ShoppingCartListModel *listModel in self.dataArray) {
                    
                    for (SaveBuyCarModel *carModel in self.idArray) {
                        
                        for (int i = 0;  i < listModel.goods.count; i++) {
                            ShoppingCartGoodsModel *goodsModel = listModel.goods[i];
                            NSString * goodsId = carModel.goodsId;
                            NSString * goodsAttrId = carModel.goodsAttrId;
                            
                            NSInteger stock = [goodsModel.stock integerValue], num = [goodsModel.num integerValue];
                            
                            if(stock - num > 0){
                                if (goodsAttrId.length != 0  && IsNilOrNull(goodsAttrId) == NO && [goodsAttrId isEqualToString:@"(null)"] == NO) {
                                    
                                    
                                    
                                    if([goodsModel.goodsAttrId isEqualToString:goodsAttrId] == YES &&  [goodsModel.goodsId isEqualToString:goodsId] == YES){
                                        
                                        goodsModel.isSelected = YES;
                                    }
                                }else{
                                    if([goodsModel.goodsId isEqualToString:goodsId] == YES){
                                        
                                        goodsModel.isSelected =  YES;
                                    }
                                }
                            }
                            
                        }
                    }
                }
                
                for (ShoppingCartListModel *listModel in self.dataArray) {
                    BOOL flag = NO;
                    NSInteger numberTure = 0;
                    
                    for (ShoppingCartGoodsModel *itmeGoodsModel in listModel.goods) {
                        if (itmeGoodsModel.isSelected == YES) {
                            numberTure ++;
                            
                        }else{
                            numberTure -- ;
                        }
                    }
                    
                    if (numberTure == listModel.goods.count) {
                        flag = YES;
                    }
                    listModel.isSelected = flag;
                    
                }
            }
            
            
            
            [self calculateTotalPrice];
            [self calculateQuantityGoods];
            [self.footView setIsAll:[self decideWhetherChooseAll]];
            [self.tableView reloadData];
        }
    }];
}

//删除数据库数据
-(void)deleteBuyCarData:(NSArray *)dataArray{
    for (SaveBuyCarModel *model in dataArray) {
        
        NSString *goodsId = model.goodsId;
        
        NSString *goodsAttrId = model.goodsAttrId;
        
        NSString *userID = [SLAppInfoModel sharedInstance].id;
        
        [[ModelTool shareInstance] deleteTableEnum:TableNameSaveBuyCar where:[NSString stringWithFormat:@"goodsId = '%@' and goodsAttrId = '%@' and userId = '%@'", goodsId, goodsAttrId, userID]];
    }
}


//插入数据库数据
- (void)insertBuyCarData:(NSArray *)dataArray{
    
    for (SaveBuyCarModel *model in dataArray) {
        
        NSString *goodsId = model.goodsId;
        
        NSString *goodsAttrId = model.goodsAttrId;
        
        [[ModelTool shareInstance] deleteTableEnum:TableNameSaveBuyCar where:[NSString stringWithFormat:@"goodsId = '%@' and goodsAttrId = '%@' and userId = '%@'", goodsId, goodsAttrId, model.userID]];
        [[ModelTool shareInstance] insert:model tableEnum:TableNameSaveBuyCar];
    }
}

//计算结算商品数量
- (void)calculateQuantityGoods{
    NSInteger goodsNumber = 0;
    for (ShoppingCartListModel *model in self.dataArray) {
        
        for (ShoppingCartGoodsModel *goodsModel in model.goods) {
            
            if (goodsModel.isSelected) {
                goodsNumber ++;
            }
        }
    }
    [self.footView setGoodsNumber:goodsNumber];
}

//判断是否全选
- (BOOL)decideWhetherChooseAll{
    BOOL flag = NO;
    NSInteger numberTure = 0;
    
    for (ShoppingCartListModel *itemListModel in self.dataArray) {
        if (itemListModel.isSelected == YES) {
            numberTure ++;
        }else{
            numberTure -- ;
        }
    }
    
    if (numberTure == self.dataArray.count) {
        flag = YES;
    }
    
    return flag;
}

//计算合计价格
- (void)calculateTotalPrice{
    float totaPrice = [ModelTool calculateTotalPrice:self.dataArray calculateType:CalculateShoppingCartListModelType];
    [self.footView setTotalPrice:totaPrice];
}

//刷新
- (void)refresh{
    [self initData];
}

//返回按钮
- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

//编辑
- (void)rightAction{
    //   NSMutableArray *tempArray = [NSMutableArray array];
    
    //    for (ShoppingCartListModel *listModel in self.dataArray) {
    //        listModel.isSelected = NO;
    //        for (ShoppingCartGoodsModel *item in listModel.goods) {
    //            if (item.isEditor == NO) {
    //                NSMutableDictionary *goodsItemDic = [NSMutableDictionary dictionary];
    //                [goodsItemDic setValue:item.goodsId forKey:@"goods_id"];
    //                if (item.goodsAttrId != nil) {
    //                    [goodsItemDic setValue:item.goodsAttrId forKey:@"goodsAttrId"];
    //                }
    //                [tempArray addObject:goodsItemDic];
    //            }
    //
    //        }
    //    }
    //
    //    [tempArray writeToFile:KTemporaryFilePath atomically:YES];
    
    
    
    if (self.rightBtn.isSelected == NO) {
        self.isBeginEditing = YES;
        
        NSMutableArray *tempArray = [NSMutableArray array];
        
        for (ShoppingCartListModel *listModel in self.dataArray) {
            listModel.isSelected = NO;
            for (ShoppingCartGoodsModel *item in listModel.goods) {
                if (item.isEditor == NO) {
                    NSMutableDictionary *goodsItemDic = [NSMutableDictionary dictionary];
                    [goodsItemDic setValue:item.goodsId forKey:@"goods_id"];
                    if (item.goodsAttrId != nil) {
                        [goodsItemDic setValue:item.goodsAttrId forKey:@"goodsAttrId"];
                    }
                    [goodsItemDic setValue:@(item.isSelected) forKey:@"isSelected"];
                    
                    [tempArray addObject:goodsItemDic];
                }
                
            }
        }
        
        [tempArray writeToFile:KTemporaryFilePath atomically:YES];
        
        for (ShoppingCartListModel *listModel in self.dataArray) {
            for (ShoppingCartGoodsModel *item in listModel.goods) {
                item.isEditor = YES;
                item.isSelected = NO;
            }
        }
        [self.rightBtn setTitle:SLLocalizedString(@"完成") forState:UIControlStateNormal];
        [self.footView setIsDelete:YES];
        [self.tableView.mj_header setHidden:YES];
    }else{
        self.isBeginEditing = NO;
        
        NSArray *tempArray = [NSArray arrayWithContentsOfFile:KTemporaryFilePath];
        for (NSMutableDictionary *goodsItemDic in tempArray) {
            NSString *goodsId = [goodsItemDic objectForKey:@"goods_id"];
            NSString *goodsAttrId  = [goodsItemDic objectForKey:@"goodsAttrId"];
            
            BOOL isSelected = [[goodsItemDic objectForKey:@"isSelected"] boolValue];
            
            for (ShoppingCartListModel *listModel in self.dataArray) {
                
                for (ShoppingCartGoodsModel *item in listModel.goods) {
                    
                    if([item.goodsAttrId isEqualToString:goodsAttrId] == YES &&  [item.goodsId isEqualToString:goodsId] == YES){
                        
                        item.isSelected =  isSelected;
                    }
                }
            }
            
            
        }
        
        for (ShoppingCartListModel *listModel in self.dataArray) {
            for (ShoppingCartGoodsModel *item in listModel.goods) {
                item.isEditor = NO;
                NSString *num = item.num;
                NSString *stock = item.stock;
                if ([stock integerValue] < [num integerValue]) {
                    item.isSelected = NO;
                }
            }
        }
        //        NSMutableArray *tempArray = [NSMutableArray arrayWithContentsOfFile:KTemporaryFilePath];
        
        //        for (ShoppingCartListModel *listModel in self.dataArray) {
        
        //            for (NSDictionary *goodsItem in tempArray) {
        //
        ////                           for (int i = 0;  i < listModel.goods.count; i++) {
        ////                               ShoppingCartGoodsModel *goodsModel = listModel.goods[i];
        ////                               NSString * goods_id = goodsItem[@"goods_id"];
        ////                               NSString * goodsAttrId = goodsItem[@"goodsAttrId"];
        ////
        ////                               if([goodsModel.goodsAttrId isEqualToString:goodsAttrId] == YES &&  [goodsModel.goodsId isEqualToString:goods_id] == YES){
        ////
        ////                                   goodsModel.isSelected =  YES;
        ////                               }
        ////                           }
        //                       }
        //                   }
        
        for (ShoppingCartListModel *listModel in self.dataArray) {
            BOOL flag = NO;
            NSInteger numberTure = 0;
            
            for (ShoppingCartGoodsModel *itmeGoodsModel in listModel.goods) {
                if (itmeGoodsModel.isSelected == YES) {
                    numberTure ++;
                    
                }else{
                    numberTure -- ;
                }
            }
            
            if (numberTure == listModel.goods.count) {
                flag = YES;
            }
            listModel.isSelected = flag;
            
        }
        
        [self.rightBtn setTitle:SLLocalizedString(@"编辑") forState:UIControlStateNormal];
        [self.footView setIsDelete:NO];
        
        [self.tableView.mj_header setHidden:NO];
    }
    
    self.rightBtn.selected = !self.rightBtn.selected;
    [self calculateTotalPrice];
    [self calculateQuantityGoods];
    [self.footView setIsAll:[self decideWhetherChooseAll]];
    [self.tableView reloadData];
}

#pragma mark - ShoppingCartNoGoodsViewAction
//去逛逛
- (void)goBuyAction{
    
    self.navigationController.tabBarController.selectedIndex = 3;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - ShoppingCratFootViewAction
//全选
- (void)footerSelectAll:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    [self.footView setIsAll:sender.selected];
   
    
    NSMutableArray *goodsIdArray = [NSMutableArray array];


    if (sender.selected == NO) {
            [goodsIdArray writeToFile:KAgainBuyCarPath atomically:YES];
       }
//
    
    NSInteger goodsNumber = 0;
    
    for (ShoppingCartListModel *model in self.dataArray) {
        model.isSelected = sender.selected;
        for (ShoppingCartGoodsModel *goodsModel in model.goods) {
            
            goodsModel.isSelected = sender.selected;
            NSString *num = goodsModel.num;
            NSString *stock = goodsModel.stock;
            if (goodsModel.isEditor == NO && [goodsModel.type isEqualToString:@"2"] == NO) {
                
                if ([stock integerValue] < [num integerValue]) {
                    goodsModel.isSelected = NO;
                }
                if (goodsModel.isSelected) {
                    
                    goodsNumber ++;
                    
//                    NSMutableDictionary *goodsItemDic = [NSMutableDictionary dictionary];
//
//                    [goodsItemDic setValue:goodsModel.goodsId forKey:@"goods_id"];
//                    if (goodsModel.goodsAttrId != nil) {
//                        [goodsItemDic setValue:goodsModel.goodsAttrId forKey:@"goodsAttrId"];
//                    }
//
                    SaveBuyCarModel *carModel = [[SaveBuyCarModel alloc]init];
                    carModel.goodsId = goodsModel.goodsId;
                    carModel.goodsAttrId = goodsModel.goodsAttrId;

                    [goodsIdArray addObject:carModel];
                    
                }
            }else{
                if (goodsModel.isSelected) {
                    
                    goodsNumber ++;
//
//                    NSMutableDictionary *goodsItemDic = [NSMutableDictionary dictionary];
//
//                    [goodsItemDic setValue:goodsModel.goodsId forKey:@"goods_id"];
//                    if (goodsModel.goodsAttrId != nil) {
//                        [goodsItemDic setValue:goodsModel.goodsAttrId forKey:@"goodsAttrId"];
//                    }
//
//                    [goodsIdArray addObject:goodsItemDic];
                    SaveBuyCarModel *carModel = [[SaveBuyCarModel alloc]init];
                    carModel.goodsId = goodsModel.goodsId;
                    carModel.goodsAttrId = goodsModel.goodsAttrId;

                    [goodsIdArray addObject:carModel];
                }
            }
        }
    }
    [self.tableView reloadData];
    [self.footView setGoodsNumber:goodsNumber];
    [self calculateTotalPrice];
    
    if (sender.selected) {
        [self insertBuyCarData:goodsIdArray];
    }else{
        
        for (ShoppingCartListModel *model in self.dataArray) {
            for (ShoppingCartGoodsModel *goodsModel in model.goods) {
                SaveBuyCarModel *carModel = [[SaveBuyCarModel alloc]init];
                carModel.goodsId = goodsModel.goodsId;
                carModel.goodsAttrId = goodsModel.goodsAttrId;
                [goodsIdArray addObject:carModel];
            }
        }
        [self deleteBuyCarData:goodsIdArray];
    }
    
    
//    if ([goodsIdArray count] > 0) {
//        [goodsIdArray writeToFile:KAgainBuyCarPath atomically:YES];
//    }
}

//删除
- (void)footerDelete:(UIButton *)sender{
    
    NSMutableArray *indexPathArray = [NSMutableArray array];
    for (int i = 0; i < self.dataArray.count; i++) {
        ShoppingCartListModel *mdoel = self.dataArray[i];
        
        for (int j = 0; j < mdoel.goods.count; j++) {
            ShoppingCartGoodsModel *goodsModel = mdoel.goods[j];
            
            if (goodsModel.isSelected) {
                NSIndexPath *temIndexPath = [NSIndexPath indexPathForRow:j inSection:i];
                [indexPathArray addObject:temIndexPath];
            }
        }
        
    }
    
    NSMutableArray *saveBuyCarArray = [NSMutableArray array];
    //id装载集合
//    NSMutableString *idStr = [NSMutableString string];
    NSMutableArray *goodsIdArray = [NSMutableArray array];
    
    for (int i = 0; i < indexPathArray.count; i++) {
        NSIndexPath *indexPath = indexPathArray[i];
        ShoppingCartListModel *mdoel = self.dataArray[indexPath.section];
        
        ShoppingCartGoodsModel *goodsModel = mdoel.goods[indexPath.row];
        
        //开始往id集合中加入购物车id
//        if (idStr.length == 0) {
//            [idStr appendString:goodsModel.cartid];
//        }else{
//            [idStr appendString:@","];
//            [idStr appendString:goodsModel.cartid];
//        }
        
        SaveBuyCarModel *carModel = [[SaveBuyCarModel alloc]init];
        carModel.goodsId = goodsModel.goodsId;
        carModel.goodsAttrId = goodsModel.goodsAttrId;
        [saveBuyCarArray addObject:carModel];
        
        [goodsIdArray addObject:goodsModel.cartid];
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setValue:idStr forKey:@"id"];
    [dic setValue:goodsIdArray forKey:@"goodsId"];
    
//    if ([idStr length] > 0) {
    if ([goodsIdArray count] > 0) {
        [SMAlert setConfirmBtBackgroundColor:kMainYellow];
        [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
        [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
        [SMAlert setCancleBtTitleColor:KTextGray_333];
        [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
        UILabel *title = [[UILabel alloc]initWithFrame:customView.bounds];
        [title setFont:[UIFont systemFontOfSize:15]];
        [title setTextColor:[UIColor darkGrayColor]];
        title.text = SLLocalizedString(@"您是否要删除此商品?");
        [title setTextAlignment:NSTextAlignmentCenter];
        [customView addSubview:title];
        [SMAlert showCustomView:customView stroke:YES confirmButton:[SMButton initWithTitle:SLLocalizedString(@"确定") clickAction:^{
            [[DataManager shareInstance]delCar:dic Callback:^(Message *message) {
                BOOL isSuccess = message.isSuccess;
                if (isSuccess == YES) {
                    [self initData];
                    [self deleteBuyCarData:saveBuyCarArray];
                }
                
                [self.footView setGoodsNumber:0];
                [self.footView setTotalPrice:0];
                [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
            }];
        }] cancleButton:[SMButton initWithTitle:SLLocalizedString(@"取消") clickAction:nil]];
    }else{
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请选择商品") view:self.view afterDelay:TipSeconds];
    }
}

//结算
- (void)settlement{
    NSInteger goodsNumber = self.footView.goodsNumber;
    if (goodsNumber > 0) {
        
        NSMutableArray *modelMutabelArray = [NSMutableArray array];
        
        NSMutableArray *allSelectedGoodsArray = [NSMutableArray array];
        
        for (ShoppingCartListModel *model in self.dataArray) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            NSMutableArray *goodsArray = [NSMutableArray array];
            
            for (ShoppingCartGoodsModel *goodsModel in model.goods) {
                if (goodsModel.isSelected) {
                    [goodsArray addObject:goodsModel];
                    [allSelectedGoodsArray addObject:goodsModel];
                }
            }
            
            if (goodsArray.count > 0) {
                [dic setValue:goodsArray forKey:@"goods"];
                GoodsStoreInfoModel *storeInfoModel = [[GoodsStoreInfoModel alloc]init];
                storeInfoModel.storeId = model.clubId;
                storeInfoModel.name = model.clubName;
                [dic setValue:storeInfoModel forKey:@"stroeInfo"];
                [modelMutabelArray addObject:dic];
            }
            
        }
        
//        BOOL goodsTypeSelect = NO;
//        
//        for (ShoppingCartGoodsModel *goodsModel in allSelectedGoodsArray) {
//            ShoppingCartGoodsModel *temGoodsModel = allSelectedGoodsArray[0];
//            if ([temGoodsModel.type isEqualToString:goodsModel.type]) {
//                goodsTypeSelect = YES;
//            }else{
//                 goodsTypeSelect = NO;
//            }
//        }
//        
//        if (goodsTypeSelect == NO) {
//            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"教程和实物不能同时下单") view:self.view afterDelay:TipSeconds];
//            return;
//        }
        
        
        ShoppingCartGoodsModel *goodsModel  = [allSelectedGoodsArray firstObject];
        //判断商品是否是教程
        if ([goodsModel.type isEqualToString:@"2"]) {
            [SLRouteManager pushRealNameAuthenticationState:self.navigationController showAlert:YES isReloadData:YES finish:^(SLRouteRealNameAuthenticationState state) {
                if (state == RealNameAuthenticationStateSuccess) {
                    //如果实名就跳转填写订单
                    OrderFillCourseViewController *orderFillCourseVC = [[OrderFillCourseViewController alloc]init];
                    orderFillCourseVC.dataArray = modelMutabelArray;
                    [self.navigationController pushViewController:orderFillCourseVC animated:YES];
                }
            }];
        }else{
            //如果是实物就直接跳转到填写订单
            OrderFillViewController *orderFillVC = [[OrderFillViewController alloc]init];
                   
            orderFillVC.dataArray = modelMutabelArray;
                   
            [self.navigationController pushViewController:orderFillVC animated:YES];
        }

    }else{
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请选择商品") view:self.view afterDelay:TipSeconds];
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return [ShoppingCratHeadView getCartHeaderHeight];
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *hIdentifier = @"hIdentifier";
    
    CGFloat height = [ShoppingCratHeadView getCartHeaderHeight];
    
    UITableViewHeaderFooterView *view= [tableView dequeueReusableHeaderFooterViewWithIdentifier:hIdentifier];
    
    ShoppingCartListModel *mdoel = self.dataArray[section];
    
    ShoppingCartGoodsModel *goodsModel = mdoel.goods[0];
    
    ShoppingCartHeadViewType type;
    
    ShoppingCratHeadView *headView;
    
    if ([goodsModel.type isEqualToString:@"1"] == YES) {
        type = ShoppingCartHeadViewStoreType;
    }else{
        type = ShoppingCartHeadViewTitleType;
    }
    
    type = ShoppingCartHeadViewStoreType;
    
    if(view==nil){
        view = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, height)];
        headView = [[ShoppingCratHeadView alloc]initWithFrame:view.bounds ViewType:type];
        [view.contentView addSubview:headView];
    }
    
    [headView setDelegate:self];
    
    [headView setSection:section];
    
    [headView setIsSelected:mdoel.isSelected];
    
    [headView setModel:mdoel];
    
    return view;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = KTextGray_FA;
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ShoppingCartListModel *mdoel = self.dataArray[section];
    return mdoel.goods.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 140;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShoppingCratTableCell *shoppingCartCell = [tableView dequeueReusableCellWithIdentifier:kShoppingCratTableCellIdentifier];
    
    ShoppingCartListModel *mdoel = self.dataArray[indexPath.section];
    ShoppingCartGoodsModel *goodsModel = mdoel.goods[indexPath.row];
    [shoppingCartCell setModel:goodsModel];
    
    shoppingCartCell.indexPath = indexPath;
    
    [shoppingCartCell setDelegate:self];
    
    return shoppingCartCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShoppingCartListModel *mdoel = self.dataArray[indexPath.section];
    ShoppingCartGoodsModel *goodsModel = mdoel.goods[indexPath.row];
//    NSString *goodsType = goodsModel.type;
    
//    if([goodsType isEqualToString:@"1"]){
        //跳转到商品详情
        WengenGoodsModel * goodsItmeModel = [[WengenGoodsModel alloc]init];
        
        goodsItmeModel.goodsId = goodsModel.goodsId;
        
        GoodsDetailsViewController *goodsDetailsVC = [[GoodsDetailsViewController alloc]init];
        goodsDetailsVC.goodsModel = goodsItmeModel;
        [self.navigationController pushViewController:goodsDetailsVC animated:YES];
//    }else{
//        //跳转到教程详情
//        KungfuClassDetailViewController * vc = [[KungfuClassDetailViewController alloc]init];
//        vc.classId = goodsModel.goodsId;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
}

#pragma mark - ShoppingCratTableCellDelegate
//选中商品
- (void)shoppingCratTableCell:(ShoppingCratTableCell *)cellView
                     lcotion:(NSIndexPath *)indexPath
                       model:(ShoppingCartGoodsModel *)model {
    
    ShoppingCartListModel *mdoel = self.dataArray[indexPath.section];
    ShoppingCartGoodsModel *goodsModel = mdoel.goods[indexPath.row];
    
    goodsModel.isSelected = !goodsModel.isSelected;
    
    [cellView setModel:goodsModel];
    
    BOOL flag = NO;
    NSInteger numberTure = 0;
    
    for (ShoppingCartGoodsModel *itmeGoodsModel in mdoel.goods) {
        if (itmeGoodsModel.isSelected == YES) {
            numberTure ++;
        }else{
            numberTure -- ;
        }
    }
    
    if (numberTure == mdoel.goods.count) {
        flag = YES;
    }
    
    mdoel.isSelected = flag;
    UITableViewHeaderFooterView *view = [self.tableView headerViewForSection:indexPath.section];
    ShoppingCratHeadView*headView = view.contentView.subviews[0];
    headView.isSelected = mdoel.isSelected;
    
    
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    
    [self calculateQuantityGoods];
    
    [self.footView setIsAll:[self decideWhetherChooseAll]];
    
    [self calculateTotalPrice];
    
    if (goodsModel.isEditor == NO) {
        if (goodsModel.isSelected == YES) {
//            NSMutableArray *goodsIdArray = [NSMutableArray array];
//
//            NSMutableDictionary *goodsItemDic = [NSMutableDictionary dictionary];
//
//            [goodsItemDic setValue:goodsModel.goodsId forKey:@"goods_id"];
//            if (goodsModel.goodsAttrId != nil) {
//                [goodsItemDic setValue:goodsModel.goodsAttrId forKey:@"goodsAttrId"];
//            }
//
//            [goodsIdArray addObject:goodsItemDic];
//
//            NSArray *tempArray = [NSArray arrayWithContentsOfFile:KAgainBuyCarPath];
//
//            [goodsIdArray addObjectsFromArray:tempArray];
//
//            [goodsIdArray writeToFile:KAgainBuyCarPath atomically:YES];
            
            SaveBuyCarModel *carModel = [[SaveBuyCarModel alloc]init];
            carModel.goodsId = goodsModel.goodsId;
            carModel.goodsAttrId = goodsModel.goodsAttrId;
            
            [self insertBuyCarData:@[carModel]];
            
            
        }else{
//            NSMutableArray *tempArray = [NSMutableArray arrayWithContentsOfFile:KAgainBuyCarPath];
//            for (int i = 0; i < tempArray.count; i++) {
//                NSDictionary *tem = tempArray[i];
//                if ([goodsModel.goodsId isEqualToString:tem[@"goods_id"]] == YES) {
//                    [tempArray removeObject:tem];
//                }
//            }
//
//            [tempArray writeToFile:KAgainBuyCarPath atomically:YES];
            
            SaveBuyCarModel *carModel = [[SaveBuyCarModel alloc]init];
            carModel.goodsId = goodsModel.goodsId;
            carModel.goodsAttrId = goodsModel.goodsAttrId;
            
            
            [self deleteBuyCarData:@[carModel]];
            
            
        }
    }
}

//商品数量
- (void)shoppingCratTableCell:(ShoppingCratTableCell *)cellView calculateCount:(NSInteger)count model:(nonnull ShoppingCartGoodsModel *)model{
    [self calculateTotalPrice];
}

//选择规格
- (void)shoppingCratTableCell:(ShoppingCratTableCell *)cellView jumpSpecificationsViewWithLcotion:(NSIndexPath *)indexPath model:(ShoppingCartGoodsModel *)model{
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    
    [[DataManager shareInstance]getGoodsInfo:@{@"id" : model.goodsId} Callback:^(NSObject *object) {
        
        [hud hideAnimated:YES];
        if ([object isKindOfClass:[GoodsInfoModel class]] == YES) {
            GoodsInfoModel *infoModel = (GoodsInfoModel *)object;
            
            GoodsSpecificationView *specificationView = [[GoodsSpecificationView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            
            UIWindow *window =[[UIApplication sharedApplication]keyWindow];
            specificationView.isCart = YES;
            specificationView.goodsAttrId = model.goodsAttrId;
            //购物车模型， 主要是购物车id
            specificationView.carGoodsModel = model;
            
            specificationView.model = infoModel;
            
            
            [window addSubview:specificationView];
            
            [specificationView setSaveBlock:^(NSDictionary * _Nonnull dic) {
                
                model.goodsAttrStrName = dic[@"attrName"];
                model.num = dic[@"num"];
                model.goodsAttrId = dic[@"attrId"];
                model.price = dic[@"currentPrice"];
                model.oldPrice = dic[@"currentPrice"];

                if(dic[@"stock"]){
                    model.stock = dic[@"stock"];
                }
                
                [cellView setModel:model];
                [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                
                [self calculateTotalPrice];
            }];
        }
    }];
}

#pragma mark - ShoppingCratHeadViewDelegate

//选中店铺
- (void)shoppingCratHeadView:(ShoppingCratHeadView *)headView lcotion:(NSInteger)section model:(ShoppingCartListModel *)storeInfoModel{
    
    ShoppingCartListModel *mdoel = self.dataArray[section];
    
    mdoel.isSelected = !mdoel.isSelected;
    
    for (int i = 0;  i < mdoel.goods.count; i++) {
        ShoppingCartGoodsModel *goodsModel = mdoel.goods[i];
        goodsModel.isSelected =  mdoel.isSelected;
        if (goodsModel.isEditor == NO && [goodsModel.type isEqualToString:@"2"] == NO) {
            NSString *num = goodsModel.num;
            NSString *stock = goodsModel.stock;
            if ([stock integerValue] < [num integerValue]) {
                goodsModel.isSelected = NO;
            }
        }
        ShoppingCratTableCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:section] ];
        
        [cell setModel:goodsModel];
        
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:section] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    headView.isSelected = mdoel.isSelected;
    
    if ([mdoel.goods count] == 1) {
        ShoppingCartGoodsModel *goodsModel = [mdoel.goods lastObject];
        if (goodsModel.isEditor == NO && [goodsModel.type isEqualToString:@"1"]) {
            NSString *num = goodsModel.num;
            NSString *stock = goodsModel.stock;
            if ([stock integerValue] < [num integerValue]) {
                mdoel.isSelected = !mdoel.isSelected;
                headView.isSelected =  mdoel.isSelected;
            }
        }
    }
    
    [self.footView setIsAll:[self decideWhetherChooseAll]];
    
    
    [self calculateQuantityGoods];
    
    [self calculateTotalPrice];
    
    if (mdoel.isSelected == YES) {
        
        NSMutableArray *goodsIdArray = [NSMutableArray array];
        for (int i = 0;  i < mdoel.goods.count; i++) {
            ShoppingCartGoodsModel *goodsModel = mdoel.goods[i];
            if (goodsModel.isEditor == NO) {
//                NSMutableDictionary *goodsItemDic = [NSMutableDictionary dictionary];
//                [goodsItemDic setValue:goodsModel.goodsId forKey:@"goods_id"];
//                if (goodsModel.goodsAttrId != nil) {
//                    [goodsItemDic setValue:goodsModel.goodsAttrId forKey:@"goodsAttrId"];
//                }
                SaveBuyCarModel *carModel = [[SaveBuyCarModel alloc]init];
                carModel.goodsId = goodsModel.goodsId;
                carModel.goodsAttrId = goodsModel.goodsAttrId;
                [goodsIdArray addObject:carModel];
            }
        }
//        NSArray *tempArray = [NSArray arrayWithContentsOfFile:KAgainBuyCarPath];
        
//        [goodsIdArray addObjectsFromArray:tempArray];
        
//        [goodsIdArray writeToFile:KAgainBuyCarPath atomically:YES];
        [self insertBuyCarData:goodsIdArray];
    }else{
//        NSMutableArray *tempArray = [NSMutableArray arrayWithContentsOfFile:KAgainBuyCarPath];
        NSMutableArray *tempArray = [NSMutableArray array];

        for (int i = 0;  i < mdoel.goods.count; i++) {
            ShoppingCartGoodsModel *goodsModel = mdoel.goods[i];
            if (goodsModel.isEditor == NO) {
//                for (int i = 0;  i < tempArray.count; i++) {
//                    NSDictionary *tem = tempArray[i];
//                    if ([goodsModel.goodsId isEqualToString:tem[@"goods_id"]] == YES) {
//                        [tempArray removeObject:tem];
//                    }
//                }
                
                SaveBuyCarModel *carModel = [[SaveBuyCarModel alloc]init];
                carModel.goodsId = goodsModel.goodsId;
                carModel.goodsAttrId = goodsModel.goodsAttrId;
                [tempArray addObject:carModel];
            }
        }
//        [tempArray writeToFile:KAgainBuyCarPath atomically:YES];
        [self deleteBuyCarData:tempArray];
        
        
    }
    
}

//跳转店铺
- (void)shoppingCratHeadView:(ShoppingCratHeadView *)headView jumpStoreModel:(ShoppingCartListModel *)storeInfoModel{
    StoreViewController *storeVC = [[StoreViewController alloc]init];
//    storeVC.storeId = storeInfoModel.storeId;
    storeVC.storeId = storeInfoModel.clubId;
    [self.navigationController pushViewController:storeVC animated:YES];
}

#pragma mark - getter / setter
- (UITableView *)tableView{
    
    if (_tableView == nil) {
        
        CGFloat y = 0;
        
        CGFloat heigth = ScreenHeight - NavBar_Height - 49 - kBottomSafeHeight;
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, heigth) style:UITableViewStyleGrouped];
        
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ShoppingCratTableCell class])bundle:nil] forCellReuseIdentifier:kShoppingCratTableCellIdentifier];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        [header setTitle:SLLocalizedString(@"下拉刷新") forState:MJRefreshStateIdle];
        [header setTitle:SLLocalizedString(@"松手刷新") forState:MJRefreshStatePulling];
        [header setTitle:SLLocalizedString(@"正在刷新...") forState:MJRefreshStateRefreshing];
        _tableView.mj_header = header;
        
        
    }
    return _tableView;
    
}

- (ShoppingCratFootView *)footView{
    
    if (_footView == nil) {
        
        _footView = [[ShoppingCratFootView alloc]initWithFrame:CGRectMake(0, ScreenHeight - NavBar_Height - 49 - kBottomSafeHeight, ScreenWidth, 49)];
        
        [_footView selectedAllTarget:self action:@selector(footerSelectAll:)];
        
        [_footView settlementTarget:self action:@selector(settlement)];
        
        [_footView deleteTarget:self action:@selector(footerDelete:)];
    }
    return _footView;
    
}

- (ShoppingCartNoGoodsView *)noGoodsView{
    
    if (_noGoodsView == nil) {
        
        CGFloat y = 0;
        
        CGFloat heigth = ScreenHeight - NavBar_Height - y;
        
        _noGoodsView = [[ShoppingCartNoGoodsView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, heigth)];
        [_noGoodsView setHidden:YES];
        [_noGoodsView buyTarget:self action:@selector(goBuyAction)];
    }
    return _noGoodsView;
    
}

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSArray *)idArray{
    if (_idArray == nil) {
        NSLog(@"%@", KAgainBuyCarPath);
//        _idArray = [NSArray arrayWithContentsOfFile:KAgainBuyCarPath];
        NSString *userId = [SLAppInfoModel sharedInstance].id;
        _idArray = [[ModelTool shareInstance]select:[SaveBuyCarModel class] tableEnum:TableNameSaveBuyCar where:[NSString stringWithFormat:@"userId = '%@'", userId]];

    }
    return _idArray;
}

@end
