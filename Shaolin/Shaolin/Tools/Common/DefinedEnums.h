//
//  DefinedEnums.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/17.
//  Copyright © 2020 syqaxldy. All rights reserved.
// 自定义枚举

#ifndef DefinedEnums_h
#define DefinedEnums_h
//分类 排序类型
typedef NS_ENUM(NSUInteger, ListType){
    ListNormalType = 0,
    ListXiaoLiangAscType = 10,
    ListXiaoLiangDescType = 20,
    
    ListJiaGeAscType = 30,
    ListJiaGeDescType = 40,
    
    ListStarDescType = 50,
    ListStarAscType = 60,
    
};

//地址类型
typedef NS_ENUM(NSUInteger, AddressType){
    
    AddressCreateType = 10,
    AddressModifyType = 20,
};

//购物车 头部显示类型
typedef NS_ENUM(NSUInteger, ShoppingCartHeadViewType){
    
    ShoppingCartHeadViewStoreType = 10,
    ShoppingCartHeadViewTitleType = 20,
};

//购物车 加载数据类型
typedef NS_ENUM(NSUInteger, ShoppingCartLodingType){
    
    ShoppingCartLodingRefreshType = 10,
    ShoppingCartLodingMoreType = 20,
};


//计算合计价格类型
typedef NS_ENUM(NSUInteger, CalculateType){
    
    CalculateShoppingCartListModelType = 10,
    CalculateShoppingCartGoodsModelType = 20,
};


//数值验证类型
typedef NS_ENUM(NSUInteger, NumericalValidationType){
    NumericalValidationAddType = 10,
    NumericalValidationSubType = 20,
    NumericalValidationOrdinaryType = 20,
};

//检查库存类型
typedef NS_ENUM(NSUInteger, CheckInventoryType){
    CheckInventoryCartType = 10,
    CheckInventoryGoodsType = 20,
};


//店铺 排序类型
typedef NS_ENUM(NSUInteger, StoreListSortingType){
    StoreListSortingJiaGeAscType = 10,
    StoreListSortingJiaGeDescType = 20,
    StoreListSortingTuiJianType = 30,
    StoreListSortingXiaoLiangType = 40,
    StoreListSortingOnlyHaveType = 50,
};

//订单详情heardView类型
typedef NS_ENUM(NSUInteger, OrderDetailsType){
    OrderDetailsHeardObligationType = 10,
    OrderDetailsHeardCancelType = 20,
    OrderDetailsHeardNormalType = 50,
};

//订单详情heardView类型
typedef NS_ENUM(NSUInteger, AfterSalesDetailsType){
    AfterSalesDetailsTuiQianType = 10,
    AfterSalesDetailsTuiHuoType = 20,
};

//计算时间类型
typedef NS_ENUM(NSUInteger, CalculatedTimeType){
    CalculatedTimeTypeDonotSecond = 10,
    CalculatedTimeTypeSecond = 20,
};





#endif /* DefinedEnums_h */
