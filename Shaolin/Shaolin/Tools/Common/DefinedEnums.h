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

//订单类型
typedef NS_ENUM(NSUInteger, OrderStatusType){
    ///1：待付款
    OrderStatusPaymentType = 1,
    ///2：待发货
    OrderStatusSendGoodsType = 2,
    ///3：待收货
    OrderStatusForGoddsType = 3,
    ///4：已收货
    OrderStatusHaveGoodsType = 4,
    ///5：完成
    OrderStatusCompleteType = 5,
    ///6：取消
    OrderStatusCancelType = 6,
    ///7：支付超时
    OrderStatusTimeoutType = 7,
};

//活动报名 费用类型
typedef NS_ENUM(NSUInteger, KungfuApplyExpenseType){
    ///报名费
    KungfuApplyExpenseSignUpType = 0,
    ///考试费
    KungfuApplyExpenseExaminationType = 1,
    /// 未选则任何选项
    KungfuApplyExpenseNoSelectedType = 404,
};


//订单详情 类型
typedef NS_ENUM(NSUInteger, OrderDetailsStatusType){
    ///教程
    OrderDetailsTutorialType = 2,
    ///活动
    OrderDetailsActivityType = 3,
};

//订单详情 类型
typedef NS_ENUM(NSUInteger, SearchHistoryType){
    ///文章
    SearchHistoryArticleType = 10,
    ///课程
    SearchHistoryCourseType = 20,
    ///商品
    SearchHistoryGoodsType = 30,
    ///活动 法会 - 少林客堂
    SearchHistoryRiteClassroomType = 40,
    ///活动 法会 -  少林慈善
    SearchHistoryRiteCharityType = 50,
};





#endif /* DefinedEnums_h */
