//
//  ToolModel.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/1.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ModelTool.h"
#import "AddressInfoModel.h"
#import "AddressListModel.h"
#import "ShoppingCartListModel.h"
#import "ShoppingCartGoodsModel.h"
#import "OrderStoreModel.h"
#import "OrderDetailsModel.h"

#import "OrderDetailsModel.h"

#import "OrderStoreModel.h"

#import <FMDB.h>

#import <objc/runtime.h>

#import "MeManager.h"
#import "DataManager.h"

#import "OrderGoodsModel.h"

#import "OrderStoreModel.h"

#import "OrderListModel.h"

#import "OrderDetailsNewModel.h"

#import "SaveBuyCarModel.h"

@interface ModelTool ()

@property(nonatomic, copy)NSString * dbPath;

@end


@implementation ModelTool

///检查返回数据
+(BOOL) checkResponseObject:(NSDictionary *)responseObject{
    BOOL flag = NO;
    
    if (responseObject) {
         NSString * code = [responseObject objectForKey:CODE];
        if (code && code.intValue == 200) {
            //正常成功
            flag = YES;
        }else if (code && code.intValue == 10018) {
            //未登录
            flag = NO;
            [[SLAppInfoModel sharedInstance]setNil];
            [[NSNotificationCenter defaultCenter]postNotificationName:MODELTOOL_CHECKRESPONSEOBJECT_DELETEUSER object:nil];
            printf("  ===========================================================================================\n");
            printf("||后台返回10018，发送MODELTOOL_CHECKRESPONSEOBJECT_DELETEUSER消息，进入LoginViewController\n");
            printf("  ===========================================================================================\n");
        }else{
            //其他状态码
            flag = NO;
        }
    }else{
        //数据格式错误,非json
        flag = NO;
    }
    
    
    
    
    return flag;
}

///处理地址数据
+(void)processingAddressData:(NSString *)filePath{
    
    NSString *content = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];

    NSArray *array = [self jsonStringToKeyValues:content];
    
    if ([array count] == 0) {
        
        NSString *bundleFilePath =[[NSBundle mainBundle] pathForResource:@"area_list" ofType:@"txt"];
        
        NSString *bundleFileContent = [[NSString alloc] initWithContentsOfFile:bundleFilePath encoding:NSUTF8StringEncoding error:nil];
        
        array = [self jsonStringToKeyValues:bundleFileContent];
        
    }
    
    
    NSArray *modelArray  = [AddressInfoModel mj_objectArrayWithKeyValuesArray:array];
    
    for (AddressInfoModel *model in modelArray) {
        NSArray *tem = [model.childern lastObject];
        model.childern = tem;
    }
    
    
    //获取全局并发队列
    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //2.添加任务到队列中，就可以执行任务
    dispatch_async(queue, ^{
        //处理地址数据
        NSMutableArray *dataArray = [NSMutableArray array];
        // 中字索引
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:SLLocalizedString(@"中") forKey:@"firstLetter"];
        [dataArray addObject:dic];
        // 26字母 索引
        for(int i=0;i<26;i++){
            NSString *firstCharactor = [NSString stringWithFormat:@"%c",'A'+i];
            
            if ([firstCharactor isEqualToString:@"O"] ||[firstCharactor isEqualToString:@"U"]||[firstCharactor isEqualToString:@"V"]||[firstCharactor isEqualToString:@"Q"]||[firstCharactor isEqualToString:@"I"]) {
                continue;
            }
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:firstCharactor forKey:@"firstLetter"];
            [dataArray addObject:dic];
        }
        
        //通过字母索引 导入对应数据
        for (NSMutableDictionary *dic in dataArray) {
            NSString *firstLetter = dic[@"firstLetter"];
            
            NSMutableArray *subArray = [NSMutableArray array];
            
            for (AddressInfoModel *model in modelArray) {
                if ([firstLetter isEqualToString:SLLocalizedString(@"中")] == YES && [model.cname isEqualToString:SLLocalizedString(@"中国")] == YES) {
                    [subArray addObject:model];
                }else{
                    if ([model.cname isEqualToString:SLLocalizedString(@"中国")] == YES) {
                        continue;
                    }
                    NSString *firstCharactor = [self firstCharactor:model.cname];
                    if ([firstCharactor isEqualToString:firstLetter] == YES) {
                        [subArray addObject:model];
                    }
                }
                
            }
            
            [dic setValue:subArray forKey:@"subArray"];
        }
        
        //保存数据
        ModelTool *tool = [ModelTool shareInstance];
        
        tool.addressArray = dataArray;
    });
    
}

//字符串转拼音，返回首字母
+(NSString *)firstCharactor:(NSString *)aString{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}

//json解析
+(id)jsonStringToKeyValues:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = nil;
    if (JSONData) {
        responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
    }
    
    return responseJSON;
}

+(void)getUserData:(void (^_Nullable)(void))finish{
//    MBProgressHUD *hud = [XXAlertViewfillLoadingWithText:nil view:nil];
    [[MeManager sharedInstance] getUserDataSuccess:^(id  _Nonnull responseObject) {
        NSDictionary *dic = responseObject;
        if ([dic isKindOfClass:[NSDictionary class]]){
            NSMutableDictionary *userDic =  [[NSMutableDictionary alloc]initWithDictionary:dic];
            [userDic setObject:[SLAppInfoModel sharedInstance].accessToken forKey:kToken];
            
            NSDictionary *allDic = [[NSDictionary alloc]initWithDictionary:userDic];
            NSLog(@"%@",allDic);
            
            [[SLAppInfoModel sharedInstance] modelWithDictionary:allDic];
            [[SLAppInfoModel sharedInstance] saveCurrentUserData];
        }
    } failure:nil finish:^(id  _Nonnull responseObject, NSString * _Nonnull errorReason) {
        if (finish) finish();
        //        [hud hideAnimated: YES];
    }];
}

+(AddressListModel *)getAddress:(NSArray *)addressArray{
    AddressListModel *listModel;
    
    for (int i = 0; i < addressArray.count; i++) {
        AddressListModel *tem = addressArray[i];
        BOOL states = [tem.status boolValue];
        if (states == YES) {
            listModel = tem;
        }
    }
    if (!listModel) {
        listModel = [addressArray firstObject];
    }
    return listModel;
}


+(AddressListModel *)getAddress:(NSArray *)addressArray withId:(NSString *)addressId{
     AddressListModel *listModel;
    if (addressId == nil) {
        for (int i = 0; i < addressArray.count; i++) {
            AddressListModel *tem = addressArray[i];
            BOOL states = [tem.status boolValue];
            if (states == YES) {
                listModel = tem;
            }
        }
        if (!listModel) {
            listModel = [addressArray firstObject];
        }
    }else{
        for (int i = 0; i < addressArray.count; i++) {
            AddressListModel *tem = addressArray[i];
            if ([tem.addressId isEqualToString:addressId] == YES) {
                listModel = tem;
            }
        }
    }
    return listModel;
}

/// 计算总价
/// @param listModel 数据数组 ShoppingCartListModel，ShoppingCartGoodsModel
/// @param type 类型  数据数组对应的类型
+(float)calculateTotalPrice:(NSArray*)listModel calculateType:(CalculateType)type{
    
    float totaPrice = 0;
    
    if (type == CalculateShoppingCartListModelType) {
        for (ShoppingCartListModel *model in listModel) {
            
            for (ShoppingCartGoodsModel *goodsModel in model.goods) {
                
                if (goodsModel.isSelected) {
                    
//                    BOOL isDiscount = [goodsModel.isDiscount boolValue];
                    float price;
//                    if (isDiscount) {
                        price = [goodsModel.price floatValue];
//                    }else{
//                        price = [goodsModel.oldPrice floatValue];
//                    }
                    
                    
//                    float price = [goodsModel.current_price floatValue];
                    int count = [goodsModel.num intValue];
                    
                    totaPrice += (price * count);
                }
            }
        }
    }else if(type == CalculateShoppingCartGoodsModelType){
        for (ShoppingCartGoodsModel *goodsModel in listModel) {
            
//            float price = [goodsModel.current_price floatValue];
            
//            BOOL isDiscount = [goodsModel.isDiscount boolValue];
            float price;
//            if (isDiscount) {
                price = [goodsModel.price floatValue];
//            }else{
//                price = [goodsModel.oldPrice floatValue];
//            }
            
            int count = [goodsModel.num intValue];
            
            totaPrice += (price * count);
            
        }
    }
    
    return totaPrice;
    
}

/// 计算数量，每次传值 调用网络，后台验证
+(void)calculateCountingChamber:(NSInteger)number
numericalValidationType:(NumericalValidationType)type
                  param:(NSDictionary *)dic
                  check:(CheckInventoryType)checkType
               callBack:(CountingChamber)counting{
    
    
    if (checkType == CheckInventoryCartType) {
        if (type == NumericalValidationAddType) {

//            [[DataManager shareInstance]incrCarNum:dic Callback:^(Message *message) {
//
//                counting(number, message.isSuccess, message);
//            }];
            
            [[DataManager shareInstance]changeGoodsNum:dic Callback:^(Message *message) {
                counting(number, message.isSuccess, message);

            }];

        }else if (type == NumericalValidationSubType){
//            [[DataManager shareInstance]decrCarNum:dic Callback:^(Message *message) {
//
//                counting(number, message.isSuccess, message);
//            }];
            
            [[DataManager shareInstance]changeGoodsNum:dic Callback:^(Message *message) {
                counting(number, message.isSuccess, message);

            }];

        }
    }else if (checkType == CheckInventoryGoodsType){
        [[DataManager shareInstance]checkStock:dic Callback:^(Message *message){
            
            counting(number, message.isSuccess, message);
        }];
    }
    
    
}

//处理再次购买逻辑
+(void)processPurchasLogicAgain:(NSArray *)itemArray callBack:(MessageCallBack)call{
    
    NSMutableArray *goodsArray = [NSMutableArray array];
    
    for (OrderStoreModel *storeModel in itemArray) {
        for (OrderDetailsModel *item in storeModel.goods) {
            [goodsArray addObject:item];
        }
    }
       NSMutableArray *goodsIdArray = [NSMutableArray array];
       
       dispatch_group_t group = dispatch_group_create();
       dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
       dispatch_group_async(group, queue, ^{
           
           for (OrderDetailsGoodsModel *goodsItem in goodsArray) {
               dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
               NSMutableDictionary *param = [NSMutableDictionary dictionary];
               [param setValue:goodsItem.goodsNum forKey:@"num"];
               [param setValue:goodsItem.goodsId forKey:@"goodsId"];
               if (goodsItem.goodsAttId) {
                   [param setValue:goodsItem.goodsAttId forKey:@"attrId"];
               }
               
               
               [param setValue:goodsItem.type forKey:@"type"];
               
               [[DataManager shareInstance]addCar:param Callback:^(Message *message) {
                   
                   if (message.isSuccess == YES) {
//                       NSMutableDictionary *goodsItemDic = [NSMutableDictionary dictionary];
                       
                       SaveBuyCarModel *buyCarModel = [[SaveBuyCarModel alloc]init];
                       buyCarModel.goodsId = goodsItem.goodsId;
                       
                       
//                       [goodsItemDic setValue:goodsItem.goodsId forKey:@"goods_id"];
                       if (goodsItem.goodsAttId != nil) {
//                           [goodsItemDic setValue:goodsItem.goodsAttId forKey:@"goods_attr_id"];
                           buyCarModel. goodsAttrId = goodsItem.goodsAttId;
                       }
                       
//                       [goodsIdArray addObject:goodsItemDic];
                       [goodsIdArray addObject:buyCarModel];
                   }
                   
                   dispatch_semaphore_signal(semaphore);
                   
               }];
               dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);
           }
           
           
           
           // 当所有队列执行完成之后
           dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
              dispatch_async(dispatch_get_main_queue(), ^{
                  
                  for (SaveBuyCarModel *model in goodsIdArray) {
                      
                      NSString *goodsId = model.goodsId;
                      
                      NSString *goodsAttrId = model.goodsAttrId;
                      
                      [[ModelTool shareInstance] deleteTableEnum:TableNameSaveBuyCar where:[NSString stringWithFormat:@"goodsId = '%@' and goodsAttrId = '%@' and userId = '%@'", goodsId, goodsAttrId, model.userID]];
                      
                      [[ModelTool shareInstance] insert:model tableEnum:TableNameSaveBuyCar];
                  }
                  
//                NSArray *tempArray = [NSArray arrayWithContentsOfFile:KAgainBuyCarPath];
//
//                  [goodsIdArray addObjectsFromArray:tempArray];
//
//                  [goodsIdArray writeToFile:KAgainBuyCarPath atomically:YES];
                  
                  call(nil);
                  
               });
           });
           
       });
}

///课程处理再次购买逻辑
+(NSArray *)courseDealsProcessPurchasLogicAgain:(NSArray *)itemArray{
    NSMutableArray *modelMutabelArray = [NSMutableArray array];
    NSMutableArray *saveGoodsArray = [NSMutableArray array];
    NSMutableDictionary *tam = [NSMutableDictionary dictionary];
    /**
     整理数据  itemArray所有的数据
     把 整理好的数据 放入 goodsArray
     */
    NSMutableArray *goodsArray = [NSMutableArray array];
    for (OrderStoreModel *storeModel in itemArray) {
        for (OrderDetailsModel *item in storeModel.goods) {
            [goodsArray addObject:item];
        }
    }
    
    for (OrderDetailsGoodsModel *goodsItem in goodsArray) {
        ShoppingCartGoodsModel *cartGoodModel = [[ShoppingCartGoodsModel alloc]init];
//        cartGoodModel.name = goodsItem.goods_name;
        cartGoodModel.goodsName = goodsItem.goodsName;
        cartGoodModel.desc = goodsItem.desc;
        cartGoodModel.imgDataList = goodsItem.goodsImages;
        cartGoodModel.price = goodsItem.goodsPrice;
//        cartGoodModel.current_price = goodsItem.money;
        cartGoodModel.oldPrice = goodsItem.goodsPrice;
        cartGoodModel.stock = @"1";
        cartGoodModel.storeType = @"1";
        cartGoodModel.num = goodsItem.goodsNum;
        cartGoodModel.goodsId = goodsItem.goodsId;
        cartGoodModel.appStoreId = goodsItem.appStoreId;
        
        [saveGoodsArray addObject:cartGoodModel];
    }
    
   [tam setValue:saveGoodsArray forKey:@"goods"];
   
   [modelMutabelArray addObject:tam];
    
    return modelMutabelArray;
}


/// 拼装订单数据
+(NSArray *)assembleData:(NSArray *)dataArray{
    
    NSMutableArray *storeArray = [NSMutableArray array];
       
       for (OrderDetailsModel *model in dataArray) {
           
           OrderStoreModel *storeModel = [[OrderStoreModel alloc]init];
           storeModel.storeId = model.club_id;
           storeModel.name = model.club_name;
           storeModel.is_self = model.is_self;
           int flag = 1;
           
           for (OrderStoreModel *storeItem in storeArray) {
               if ([storeItem.storeId isEqualToString:storeModel.storeId] == YES) {
                   flag = 0;
                   break;
               }
           }
           
           if (flag == 1) {
               [storeArray addObject:storeModel];
           }
           
       }
    
       for (OrderStoreModel *storeItem in storeArray) {
           NSMutableArray *goodsArray = [NSMutableArray array];
           for (OrderDetailsModel *model in dataArray) {
               if ([storeItem.storeId isEqualToString:model.club_id] == YES) {
                   [goodsArray addObject:model];
                   
               }
           }
           
           storeItem.goods = goodsArray;
       }
    return storeArray;
}

/// 拼装订单数据
+(NSArray *)assembleOrderDetailsData:(OrderDetailsNewModel *)model{
    NSMutableArray *storeArray = [NSMutableArray array];
    
    if ([model.clubs count] == 0) {
        OrderStoreModel *storeModel = [[OrderStoreModel alloc]init];
        [storeArray addObject:storeModel];
        for (OrderStoreModel *storeItem in storeArray) {
            NSMutableArray *goodsArray = [NSMutableArray array];
            for (OrderDetailsGoodsModel *goodsModel in model.goods) {
               
                [goodsArray addObject:goodsModel];
            }
            
            storeItem.goods = goodsArray;
        }
    }else{
        for (OrderClubsInfoModel *clubsModel in model.clubs) {
            
            OrderStoreModel *storeModel = [[OrderStoreModel alloc]init];
            storeModel.storeId = clubsModel.orderClubsInfoModelId;
            storeModel.name = clubsModel.name;
            storeModel.is_self = clubsModel.isSelf;
           
            [storeArray addObject:storeModel];
        }
     
        for (OrderStoreModel *storeItem in storeArray) {
            NSMutableArray *goodsArray = [NSMutableArray array];
            for (OrderDetailsGoodsModel *goodsModel in model.goods) {
                if ([goodsModel.clubId isEqualToString:storeItem.storeId] == YES) {
                    goodsModel.clubName = storeItem.name;
                    [goodsArray addObject:goodsModel];
                    
                }
            }
            
            storeItem.goods = goodsArray;
        }
        
    }
    
    
    return storeArray;
}


/// 根据订单列表数据 计算高度 并返回数据
+(NSArray *)calculateHeight:(NSArray<OrderListModel *> *)dataArray{
    NSMutableArray *tem = [NSMutableArray array];
//    for (OrderListModel *listModel in dataArray) {
//
//        NSString *num_type = listModel.num_type;
//
//        NSString *is_virtual = listModel.is_virtual;
//
//        if ([num_type isEqualToString:@"1"] == YES || num_type == nil) {
//
//            if ([is_virtual isEqualToString:@"1"]) {
//                listModel.cellHight = 235;
//
//            }else if ([is_virtual isEqualToString:@"0"]) {
//
//                BOOL isEqual = YES;
//
//                NSString *goods_typeStr;
//
//                NSArray *orderStoreArray = listModel.order_goods;
//
//                for (OrderStoreModel *storeModel in orderStoreArray) {
//                    for (OrderGoodsModel *goodsModel in storeModel.goods) {
//
//                        OrderGoodsModel *temGoodsModel = storeModel.goods[0];
//                        if ([goodsModel.goods_type isEqualToString:temGoodsModel.goods_type]) {
//                            isEqual = YES;
//                            goods_typeStr = goodsModel.goods_type;
//                        }else{
//                            isEqual = NO;
//                        }
//                    }
//                }
//                if (isEqual) {
//
//                    if ([goods_typeStr isEqualToString:@"1"]) {
//                        listModel.cellHight = 235;
//                    }else{
//                        if ([listModel.status isEqualToString:@"6"]||[listModel.status isEqualToString:@"7"]) {
//                            listModel.cellHight = 180;
//                        }else{
//                            listModel.cellHight = 235;
//                        }
//                    }
//                }else{
//                    if ([listModel.status isEqualToString:@"6"]||[listModel.status isEqualToString:@"7"]) {
//                        listModel.cellHight = 180;
//                    }else{
//                        listModel.cellHight = 235;
//                    }
//                }
//            } else{
//                if ([listModel.status isEqualToString:@"6"]||[listModel.status isEqualToString:@"7"]) {
//                    listModel.cellHight = 180;
//                }else{
//                    listModel.cellHight = 235;
//                }
//            }
//        }else{
//             if ([is_virtual isEqualToString:@"1"]) {
//                           listModel.cellHight = 235;
//
//                       }else if ([is_virtual isEqualToString:@"0"]) {
//
//                           BOOL isEqual = YES;
//
//                           NSString *goods_typeStr;
//
//                           NSArray *orderStoreArray = listModel.order_goods;
//
//                           for (OrderStoreModel *storeModel in orderStoreArray) {
//                               for (OrderGoodsModel *goodsModel in storeModel.goods) {
//
//                                   OrderGoodsModel *temGoodsModel = storeModel.goods[0];
//                                   if ([goodsModel.goods_type isEqualToString:temGoodsModel.goods_type]) {
//                                       isEqual = YES;
//                                       goods_typeStr = goodsModel.goods_type;
//                                   }else{
//                                       isEqual = NO;
//                                   }
//                               }
//                           }
//                           if (isEqual) {
//
//                               if ([goods_typeStr isEqualToString:@"1"]) {
//                                   listModel.cellHight = 235;
//                               }else{
//                                   if ([listModel.status isEqualToString:@"6"]||[listModel.status isEqualToString:@"7"]) {
//                                       listModel.cellHight = 180;
//                                   }else{
//                                       listModel.cellHight = 235;
//                                   }
//                               }
//                           }else{
//                               if ([listModel.status isEqualToString:@"6"]||[listModel.status isEqualToString:@"7"]) {
//                                   listModel.cellHight = 180;
//                               }else{
//                                   listModel.cellHight = 235;
//                               }
//                           }
//                       } else{
//                           if ([listModel.status isEqualToString:@"6"]||[listModel.status isEqualToString:@"7"]) {
//                               listModel.cellHight = 180;
//                           }else{
//                               listModel.cellHight = 235;
//                           }
//                       }
//        }
//
//        [tem addObject:listModel];
//    }
    
    for(OrderListModel *listModel in dataArray) {
        
        //订单状态
        NSInteger statusInteger = [listModel.status integerValue];
        
//        NSArray *orderStoreArray = listModel.order_goods;
//        OrderStoreModel *storeModel = [orderStoreArray firstObject];
//        OrderGoodsModel *goodsModel = [storeModel.goods firstObject];
//        NSInteger goods_type = [goodsModel.goods_type integerValue];
        NSInteger type = [listModel.type integerValue];
        CGFloat cellHight = 225;
        
        ///1：实物，2：教程，3：报名，5:法事佛事类型-法会，6:法事佛事类型-佛事， 7:法事佛事类型-建寺供僧 8:普通法会 4:交流会
//        if (goods_type == 2 || goods_type == 3 || goods_type == 4) {
//            if (statusInteger == 6 || statusInteger == 7) {
//                cellHight = 180;
//            }
//        }
//
        if (type == 2 || type == 3 || type == 4) {
            if (statusInteger == 6 || statusInteger == 7) {
                cellHight = 180;
            }
        }
        
//        if (goods_type == 1) {
//            if([goodsModel.status isEqualToString:@"2"] && [goodsModel.is_invoice isEqualToString:@"0"]){
//
//                if ([goodsModel.is_foreign isEqualToString:@"1"]) {
//                    cellHight = 225 - 30;
//                }
//            }
//        }
        
        
        if (type == 1) {
            float goodsMoney = [listModel.money floatValue];
            if (goodsMoney == 0 && statusInteger == 2) {
                cellHight = 225 - 30;
            }
//            if(statusInteger == 2 && [listModel.isInvoice isEqualToString:@"0"]){
//
//                if ([listModel.isForeign isEqualToString:@"1"]) {
//                    cellHight = 225 - 30;
//                }
//            }
        }
        
        listModel.cellHight = cellHight;
        [tem addObject:listModel];
    }
    
    
    return tem;
}

///计算教程时间
///type
///CalculatedTimeTypeDonotSecond 不带秒 超过30秒进一
+(NSString *)calculatedTimeWith:(CalculatedTimeType)type secondStr:(NSString *)secondStr{
    NSInteger time = [secondStr integerValue];
       NSInteger minute = time/60;
       NSInteger seconds = time%60;
    
    NSString *timeStr;
    
    if (type == CalculatedTimeTypeDonotSecond) {
        
        if (seconds > 30) {
            minute += 1;
        }
        
        if (minute == 0) {
            minute = 1;
        }
        
        timeStr = [NSString stringWithFormat:SLLocalizedString(@"%ld分钟"), minute];
        
    }else if(type == CalculatedTimeTypeSecond){
        timeStr = [NSString stringWithFormat:SLLocalizedString(@"%ld分钟%ld秒"),minute, seconds];
    }else{
        timeStr = @"";
    }
    
    return timeStr;
       
}


+(UIWindow *)lastWindow{
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal && window.windowLevel <= UIWindowLevelNormal);
        if(windowOnMainScreen && windowIsVisible && windowLevelSupported) {
            return window;
        }
    }
    return nil;
}


/// 创建数据库
- (void)createBatabase{
    
   NSArray *sqlStringsArray = @[
       @"CREATE TABLE level('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , 'classification' VARCHAR(255), 'levelId' VARCHAR(30), 'createTime' VARCHAR(255), 'fid' VARCHAR(255), 'name' VARCHAR(255), 'number' VARCHAR(255), 'type' VARCHAR(255), 'value' VARCHAR(255), 'levelType' VARCHAR(255));",
       @"CREATE TABLE searchHistory('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , 'userId' VARCHAR(255), 'type' VARCHAR(30), 'searchContent' VARCHAR(255));",
       ///分享，关注，点赞
       @"CREATE TABLE thumbFollowShare('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , 'userId' VARCHAR(255), 'type' VARCHAR(30), 'itemId' VARCHAR(255),'itemType' VARCHAR(255),'itemKind' VARCHAR(255), 'updateStatus' VARCHAR(30), 'time' VARCHAR(30), 'sharedCount' VARCHAR(30), 'pujaType' VARCHAR(30), 'buddhismId' VARCHAR(30), 'buddhismTypeId' VARCHAR(30));",
       ///购物车 商品表
       @"CREATE TABLE saveBuyCar('userId' VARCHAR(255), 'goodsId' VARCHAR(255), 'goodsAttrId' VARCHAR(255));",
   ];
    
    NSArray *tableNames = @[@"level", @"searchHistory", @"thumbFollowShare", @"againBuyCar"];
    
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
       NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
       self.dbPath = [doc stringByAppendingPathComponent:@"User.sqlite"];
    if ([fileManager fileExistsAtPath:self.dbPath] == NO) {
           FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
           if ([db open]) {
               for (NSString *sql in sqlStringsArray) {
                   BOOL res = [db executeUpdate:sql];
                   if (res == NO) {
                       NSLog(@"创建数据表成功");
                   }
               }
               [db close];
           } else {
               NSLog(@"创建数据库失败");
           }
    }else{
        //检查数据库有是否有想要创建的数据表
        
        NSLog(@"self.dbPath : %@", self.dbPath);
        
        FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
        
        if ([db open]) {
            int i = 0;
            for (NSString *tableName in tableNames) {
                NSString *existsSql = [NSString stringWithFormat:@"select count(name) as countNum from sqlite_master where type = 'table' and name = '%@'", tableName ];
                
                FMResultSet *rs = [db executeQuery:existsSql];
                
                if ([rs next]) {
                    NSInteger count = [rs intForColumn:@"countNum"];
                    
                    if (count == 1) {
                        NSLog(@"存在");
                    }else{
                        NSString *sql = sqlStringsArray[i];
                        BOOL res = [db executeUpdate:sql];
                        if (res == NO) {
                            NSLog(@"创建数据表成功");
                        }
                    }
                }
                i++;
            }
            [db close];
        }
    }
}


- (void)creatTable:(Class)cls tableName:(NSString*)tbName keyName:(NSString*)keyName primaryKey:(NSString*) key{
    
    NSArray *array = [self getModelAllProperty:cls];
    NSMutableString *sql = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (",tbName];
    
    for (int i = 0; i < array.count; i++) {
        NSDictionary *dic = array[i];
        [sql appendFormat:@"%@  %@ ",[dic objectForKey:@"name"],[dic objectForKey:@"type"]];
        if(keyName != nil && [keyName isEqualToString:[dic objectForKey:@"name"]]){
            [sql appendString:key];
        }
        if (i < array.count - 1){
            [sql appendString:@","];
        }
    }
    
    [sql appendString:@")"];
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    self.dbPath = [doc stringByAppendingPathComponent:@"User.sqlite"];
     
    if ([fileManager fileExistsAtPath:self.dbPath] == NO) {
       FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
        if ([db open]) {
            
            BOOL res = [db executeUpdate:[sql copy]];
            if (res == YES) {
                NSLog(@"创建数据表成功");
            }else{
                NSLog(@"创建数据库失败");
            }
            
            [db close];
        } else {
            NSLog(@"创建数据库失败");
        }
    }else{
        //检查数据库有是否有想要创建的数据表
        
        FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
        
        if ([db open]) {
            
            NSString *existsSql = [NSString stringWithFormat:@"select count(name) as countNum from sqlite_master where type = 'table' and name = '%@'", @"level" ];
            
            FMResultSet *rs = [db executeQuery:existsSql];
            
            if ([rs next]) {
                NSInteger count = [rs intForColumn:@"countNum"];
                
                if (count == 1) {
                    NSLog(@"存在");
                }else{
                    
                    BOOL res = [db executeUpdate:sql];
                    if (res == YES) {
                        NSLog(@"创建数据表成功");
                    }
                }
            }
            [db close];
        }
    }
}

- (BOOL)insert:(id)model tableEnum:(TableNameEnum)tableEnum {
    return [self insert:model tableName:[self getTableName:tableEnum]];
}
///插入数据 到数据库
- (BOOL)insert:(id)model tableName:(NSString*)tbName{
    
     FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    
    NSArray *array = [self getModelAllProperty:[model class]];
    
    NSMutableString *propertyStr = [[NSMutableString alloc]init];
    NSMutableString *valuesStr = [[NSMutableString alloc]init];
    
    
    for (int i = 0; i < array.count; i++) {
        NSDictionary *dic = array[i];
        [propertyStr appendString:[dic objectForKey:@"name"]];
        [valuesStr appendFormat:@"'%@'",[model valueForKey:[dic objectForKey:@"name"]]];
        
        if (i < array.count - 1){
            [propertyStr appendString:@","];
            [valuesStr appendString:@","];
        }
    }
    NSMutableString *sql = [NSMutableString stringWithFormat:@"INSERT INTO %@ (%@) values (%@)",tbName,propertyStr ,valuesStr];
    NSLog(@"添加数据 : %@",sql);
    [db open];
    BOOL result = [db executeUpdate:[sql copy]];
    [db close];
    NSLog(@"添加数据:%@",result ? @"成功":@"失败");
    
    return result;
}

///按条件查询
- (NSArray*)select:(Class)model tableEnum:(TableNameEnum)tableEnum where:(NSString*)str {
    return [self select:model tableName:[self getTableName:tableEnum] where:str];
}

- (NSArray*)select:(Class)model tableName:(NSString*)tbName where:(NSString*)str{
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@",tbName,str];
    NSArray *array = [self getModelAllProperty:[model class]];
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    [db open];
    NSLog(@"查询数据 : %@",sql);
    FMResultSet *set = [db executeQuery:sql];
    NSMutableArray *allArray = [[NSMutableArray alloc]init];
    while ([set next]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        for (int i = 0; i < array.count; i++) {
            NSDictionary *dic1 = array[i];
            NSString *pro = [dic1 objectForKey:@"name"];
            [dic setValue:[set stringForColumn:pro] forKey:pro];
        }
        [allArray addObject:dic];
    }
    
    [set close];
    [db close];
    NSArray *dataArray = [[model class] mj_objectArrayWithKeyValuesArray:allArray];
//    return [allArray copy];
    return dataArray;
}

///查询所有
- (NSArray*)selectALL:(Class)model tableEnum:(TableNameEnum)tableEnum {
    return [self selectALL:model tableName:[self getTableName:tableEnum]];
}

- (NSArray*)selectALL:(Class)model tableName:(NSString*)tbName {
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    NSString *sql = [NSString stringWithFormat:@"select * from %@ ",tbName];
    NSArray *array = [self getModelAllProperty:[model class]];
    [db open];
    NSLog(@"查询数据 : %@",sql);
    FMResultSet *set = [db executeQuery:sql];
    NSMutableArray *allArray = [[NSMutableArray alloc]init];
    while ([set next]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        for (int i = 0; i < array.count; i++) {
            NSDictionary *dic1 = array[i];
            NSString *pro = [dic1 objectForKey:@"name"];
            [dic setValue:[set stringForColumn:pro] forKey:pro];
        }
        [allArray addObject:dic];
    }
    
    [set close];
    [db close];
    return [allArray copy];
}

///修改表数据数据
- (BOOL)update:(id)model tableEnum:(TableNameEnum)tableEnum where:(NSString*)str {
    return [self update:model tableName:[self getTableName:tableEnum] where:str];
}

- (BOOL)update:(id)model tableName:(NSString*)tbName where:(NSString*)str{
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    NSArray *array = [self getModelAllProperty:[model class]];
    NSMutableString *sql = [NSMutableString stringWithFormat:@"UPDATE %@ SET ",tbName];
    
    for (int i = 0; i < array.count; i++) {
        NSDictionary *dic = array[i];
        NSString *pro = [dic objectForKey:@"name"];
        [sql appendFormat:@"%@ = '%@'",pro,[model valueForKey:pro]];
        if (i < array.count - 1){
            [sql appendString:@","];
        }
    }
    
    if (str.length){
        [sql appendFormat:@" where %@",str];
    }
    NSLog(@"修改数据 : %@",sql);
    [db open];
    BOOL result = [db executeUpdate:[sql copy]];
    [db close];
    NSLog(@"更新数据:%@",result ? @"成功":@"失败");
    return result;
}

- (BOOL)deleteTableEnum:(TableNameEnum)tableEnum where:(NSString*)str {
    return [self deleteTableName:[self getTableName:tableEnum] where:str];
}

- (BOOL)deleteTableName:(NSString*)tbName where:(NSString*)str{
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    NSString *sql = [NSString stringWithFormat:@"delete from %@",tbName];;
    if (str.length) {
        sql = [NSString stringWithFormat:@"%@ where %@", sql, str];
    }
    NSLog(@"删除数据 : %@",sql);
    [db open];
    BOOL result = [db executeUpdate:sql];
    [db close];
    NSLog(@"更新数据:%@",result ? @"成功":@"失败");
    return result;
}


- (NSString *)getTableName:(TableNameEnum)tableNameEnum {
    switch (tableNameEnum) {
        case TableNameLevel:
            return @"level";
            break;
        case TableNameSearchHistory:
            return @"searchHistory";
            break;
        case TableNameThumbFollowShare:
            return @"thumbFollowShare";
            break;
        case TableNameSaveBuyCar:
            return @"saveBuyCar";
            break;
        default:
            return @"";
    }
}
#pragma mark - 单例构造
+(instancetype)shareInstance{
    static ModelTool *_sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //不能再使用alloc方法
        //因为已经重写了allocWithZone方法，所以这里要调用父类的分配空间的方法
        _sharedSingleton = [[super allocWithZone:NULL] init];
    });
    return _sharedSingleton;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    return [ModelTool shareInstance];
}

- (id)copyWithZone:(nullable NSZone *)zone {
    return [ModelTool shareInstance];
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    return [ModelTool shareInstance];;
}

/**
 *  获取 model 类全部的属性和属性类型
 *
 *  @param cls model 类 class
 *
 *  @return 返回 model 的属性和属性类型
 */
- (NSArray *)getModelAllProperty:(Class)cls{
    
    unsigned int count = 0;
    objc_property_t *propertys = class_copyPropertyList(cls, &count);
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        
        objc_property_t property = propertys[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        NSString *type = [self getPropertyAttributeValue:property name:@"T"];
        
        if ([type isEqualToString:@"q"]||[type isEqualToString:@"i"]) {
            type = @"INTEGER";
        }else if([type isEqualToString:@"f"] || [type isEqualToString:@"d"]){
            type = @"FLOAT";
        }else{
            type = @"TEXT";
        }
               
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:propertyName , @"name",type , @"type", nil];
        
        [array addObject:dic];
        
    }
    free(propertys);
    
    return array.copy;
}

/**
 *  获取属性的特征值
 */

- (NSString*)getPropertyAttributeValue:(objc_property_t) pro name:(NSString*)name{
    
    unsigned int count = 0;
    objc_property_attribute_t *attributes = property_copyAttributeList(pro, &count);
    
    for (int i = 0 ; i < count; i++) {
        objc_property_attribute_t attribute = attributes[i];
        if (strcmp(attribute.name, name.UTF8String) == 0) {
            return [NSString stringWithCString:attribute.value encoding:NSUTF8StringEncoding];
        }
    }
    free(attributes);
    return nil;
}

+(NSArray *)assembleFilterCourierData:(NSArray *)dataArray orderId:(NSString *)orderId bySstortModel:(OrderStoreModel *)stortModel{
    //存放所有商品
    NSMutableArray *goodsArray = [NSMutableArray array];
    //存放所有根据快递单号的数组。
    //根据数组个数 进行排序
    NSMutableArray *sortingArray = [NSMutableArray array];
    // 过滤 快递单号
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSMutableDictionary *companyDic = [NSMutableDictionary dictionary];
    // 取出所有的 单号 去重
    for (OrderDetailsGoodsModel *goodsModel in dataArray) {


        [companyDic setValue:goodsModel.logisticsName forKey:goodsModel.logisticsName];
        [dic setValue:goodsModel.logisticsNo forKey:goodsModel.logisticsNo];
    }

    if ([[companyDic allValues] count] == 1) {
        if ([[dic allValues] count] == 1) {
            stortModel.isUnifiedNumber = YES;
        }else{
            stortModel.isUnifiedNumber = NO;
        }
    }else{
        stortModel.isUnifiedNumber = NO;
    }

    
    
    //如果 不是统一快递单号
    if(stortModel.isUnifiedNumber == NO){
        
//        NSArray *logisticsNoArray = [dic allValues];
        for (NSString *numberStr in [dic allValues]) {
            
            
        for (NSString *name in [companyDic allValues]) {
                NSMutableArray *itemArray = [NSMutableArray array];
                
                
                for (OrderDetailsGoodsModel *goodsModel in dataArray) {
                    
                    if ([goodsModel.logisticsNo isEqualToString:numberStr] == YES && [goodsModel.logisticsName isEqualToString:name] == YES) {
                        [itemArray addObject:goodsModel];
                    }
                }
                
                if (itemArray.count > 1) {
                    //多个商品的 控制面板是单独的
                    //处理方法 ：添加空数据 通过 isOperationPanel显示不同cell
                    
                    //存储 多个商品 所有订单号
                    NSMutableArray *allOrderNumberArray = [NSMutableArray array];
                    NSString *status;
                    for (OrderDetailsGoodsModel *goodsModel in itemArray) {
//                        [allOrderNumberArray addObject:goodsModel.order_no];
                        [allOrderNumberArray addObject:goodsModel.orderId];
                        status = goodsModel.status;
                    }
                    
                    OrderDetailsModel *model = [[OrderDetailsModel alloc]init];
                    model.allOrderNoStr = [allOrderNumberArray componentsJoinedByString:@","];
                    model.isOperationPanel = YES;
                    model.order_sn = orderId;
                    model.status = status;
                    [itemArray addObject:model];
                }else{
                    //单个商品 只需要自己有控制面板
                    for (OrderDetailsModel *model in itemArray) {
                        model.isSelfViewOperationPanel = YES;
                    }
                }
                [sortingArray addObject:itemArray];
            }
        }
        //排序
        NSArray *sortedArray = [sortingArray sortedArrayUsingComparator:^(NSArray *array1, NSArray *array2) {
            NSInteger val1 = [array1 count];
            
            NSInteger val2 = [array2 count];
            
            if(val1 < val2){
                return NSOrderedAscending;
            }else{
                return NSOrderedDescending;
            }
        }];
        
        for (NSArray *itemArray in sortedArray) {
            for (OrderDetailsModel *model in itemArray) {
                [goodsArray addObject:model];
            }
        }
    }else{
        //如果是统一单号
        //存储 多个商品 所有订单号
        NSMutableArray *allOrderNumberArray = [NSMutableArray array];
        NSString *status;
        //处理 多个商品 显示
        if ([dataArray count] > 1) {
            for (OrderDetailsGoodsModel *goodsModel in dataArray) {
                [allOrderNumberArray addObject:goodsModel.orderId];
                status = goodsModel.status;
            }
            
            OrderDetailsGoodsModel *model = [[OrderDetailsGoodsModel alloc]init];
            model.allOrderNoStr = [allOrderNumberArray componentsJoinedByString:@","];
            model.isOperationPanel = YES;
            model.status = status;
            [goodsArray addObjectsFromArray:dataArray];
            
            [goodsArray addObject:model];
        }else{
            //处理 单个商品 显示
            
            for (OrderDetailsGoodsModel *model in dataArray) {
                model.isSelfViewOperationPanel = YES;
            }
            [goodsArray addObjectsFromArray:dataArray];
        }
        
    }
    
    return goodsArray;
    
}


@end
