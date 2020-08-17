//
//  WengenManager.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "WengenManager.h"
#import <AFNetworking.h>
#import "WengenEnterModel.h"
#import "WengenGoodsModel.h"
#import "GoodsInfoModel.h"
#import "GoodsStoreInfoModel.h"
#import "AddressListModel.h"
#import "ModelTool.h"
#import "ShoppingCartListModel.h"
#import "OrderListModel.h"
#import "OrderDetailsModel.h"
#import "WengenBannerModel.h"
#import "OrderRefundInfoModel.h"
#import "InvoiceQualificationsModel.h"
#import "DefinedHost.h"

#import "SLRequest.h"

#import "CustomerServieListModel.h"

@interface WengenManager ()

@property(strong, nonatomic)AFHTTPSessionManager *manager;

@end

@implementation WengenManager


#pragma mark - methods

///文创商城 获取商品全部分类
-(void)getAllGoodsCateList:(NSArrayCallBack)call{
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_GOODS_CATE_GETALLGOODSCATELIST parameters:@{} success:^(NSDictionary * _Nullable resultDic) {
        
        NSArray *dataArray;
        if ([resultDic isKindOfClass:[NSArray class]] == YES) {
            dataArray = (NSArray *)resultDic;
        }else{
            dataArray =  resultDic[LIST];
        }
        if (dataArray.count > 0) {
            NSArray *dataList = [WengenEnterModel mj_objectArrayWithKeyValuesArray:dataArray];
            if (call) call(dataList);
        }else{
            if (call) call(nil);
        }
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
    }];
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_GOODS_CATE_GETALLGOODSCATELIST) parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        NSArray *dataArray;
    //             if ([dic[DATAS] isKindOfClass:[NSArray class]] == YES) {
    //                 dataArray = dic[DATAS];
    //             }else{
    //                 dataArray =  dic[DATAS][LIST];
    //             }
    //             if (dataArray.count > 0) {
    //                 NSArray *dataList = [WengenEnterModel mj_objectArrayWithKeyValuesArray:dataArray];
    //                 if (call) call(dataList);
    //             }else{
    //                 if (call) call(nil);
    //             }
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///文创商城 首页 banner
-(void)getBanner:(NSDictionary *)param Callback:(NSArrayCallBack)call{
    
    [SLRequest postJsonRequestWithApi:URL_POST_BANNERURL parameters:param success:^(NSDictionary * _Nullable resultDic) {
        
        NSArray *array = resultDic[@"bannerurl"];
        
        NSArray *dataList = [WengenBannerModel mj_objectArrayWithKeyValuesArray:array];
        
        if (call) call(dataList);
        
    } failure:^(NSString * _Nullable errorReason) {
        if (call) call(nil);
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
    }];
    
    //    [self.manager POST:ADD(URL_POST_BANNERURL) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //
    //        if ([ModelTool checkResponseObject:dic]) {
    //
    //            NSDictionary *data = dic[DATAS];
    //            NSArray *array = data[@"bannerurl"];
    //
    //            NSArray *dataList = [WengenBannerModel mj_objectArrayWithKeyValuesArray:array];
    //
    //            if (call) call(dataList);
    //        } else {
    //            if (call) call(nil);
    //        }
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //
    //        NSLog(@"error : %@", error);
    //        if (call) call(nil);
    //    }];
}

///新人推荐 商品
-(void)getRecommendGoodsCallback:(NSArrayCallBack)call{
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_GOODS_GETNEW parameters:@{} success:^(NSDictionary * _Nullable resultDic) {
        
        NSArray *dataArray;
        if ([resultDic isKindOfClass:[NSArray class]] == YES) {
            dataArray = (NSArray *)resultDic;
        }else{
            dataArray =  resultDic[LIST];
        }
        if (dataArray.count > 0) {
            NSArray *dataList = [WengenGoodsModel mj_objectArrayWithKeyValuesArray:dataArray];
            if (call) call(dataList);
        }else{
            if (call) call(nil);
        }
        
    } failure:^(NSString * _Nullable errorReason) {
        if (call) call(nil);
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
    }];
    //
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_GOODS_GETNEW) parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //        NSArray *dataArray;
    //        if ([dic[DATAS] isKindOfClass:[NSArray class]] == YES) {
    //            dataArray = dic[DATAS];
    //        }else{
    //            dataArray =  dic[DATAS][LIST];
    //        }
    //        if (dataArray.count > 0) {
    //            NSArray *dataList = [WengenGoodsModel mj_objectArrayWithKeyValuesArray:dataArray];
    //            if (call) call(dataList);
    //        }else{
    //            if (call) call(nil);
    //        }
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///(文创 商城 首页)严选 商品
-(void)getStrictSelectionGoodsCallback:(NSArrayCallBack)call{
    
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_GOODS_GETDELICATE parameters:@{} success:^(NSDictionary * _Nullable resultDic) {
        
        NSArray *dataArray;
        if ([resultDic isKindOfClass:[NSArray class]] == YES) {
            dataArray = (NSArray *)resultDic;
        }else{
            dataArray =  resultDic[LIST];
        }
        if (dataArray.count > 0) {
            NSArray *dataList = [WengenGoodsModel mj_objectArrayWithKeyValuesArray:dataArray];
            if (call) call(dataList);
        }else{
            if (call) call(nil);
        }
        
    } failure:^(NSString * _Nullable errorReason) {
        if (call) call(nil);
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
    }];
    
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_GOODS_GETDELICATE) parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        NSArray *dataArray;
    //        if ([dic[DATAS] isKindOfClass:[NSArray class]] == YES) {
    //            dataArray = dic[DATAS];
    //        }else{
    //            dataArray =  dic[DATAS][LIST];
    //        }
    //        if (dataArray.count > 0) {
    //            NSArray *dataList = [WengenGoodsModel mj_objectArrayWithKeyValuesArray:dataArray];
    //            if (call) call(dataList);
    //        }else{
    //            if (call) call(nil);
    //        }
    //
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}


///文创商城 首页 分类
-(void)getIndexClassification:(NSArrayCallBack)call{
    
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_GOODS_CATE_GETGOODSCATELIST parameters:@{} success:^(NSDictionary * _Nullable resultDic) {
        
        NSArray *dataArray;
        if ([resultDic isKindOfClass:[NSArray class]] == YES) {
            dataArray = (NSArray *)resultDic;
        }else{
            dataArray =  resultDic[LIST];
        }
        if (dataArray.count > 0) {
            NSArray *dataList = [WengenEnterModel mj_objectArrayWithKeyValuesArray:dataArray];
            if (call) call(dataList);
        }else{
            if (call) call(nil);
        }
        
    } failure:^(NSString * _Nullable errorReason) {
        if (call) call(nil);
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
    }];
    
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_GOODS_CATE_GETGOODSCATELIST) parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        NSArray *dataArray;
    //        if ([dic[DATAS] isKindOfClass:[NSArray class]] == YES) {
    //            dataArray = dic[DATAS];
    //        }else{
    //            dataArray =  dic[DATAS][LIST];
    //        }
    //        if (dataArray.count > 0) {
    //            NSArray *dataList = [WengenEnterModel mj_objectArrayWithKeyValuesArray:dataArray];
    //            if (call) call(dataList);
    //        }else{
    //            if (call) call(nil);
    //        }
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///(文创 商城) 商品商品列表
-(void)getGoodsList:(NSDictionary *)param Callback:(NSArrayCallBack)call{
    
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_GOODS_GETGOODSLIST parameters:param success:^(NSDictionary * _Nullable resultDic) {
        
        NSArray *dataArray;
        if ([resultDic isKindOfClass:[NSArray class]] == YES) {
            dataArray = (NSArray *)resultDic;
        }else{
            dataArray =  resultDic[LIST];
        }
        if (dataArray.count > 0) {
            NSArray *dataList = [WengenGoodsModel mj_objectArrayWithKeyValuesArray:dataArray];
            if (call) call(dataList);
        }else{
            if (call) call(nil);
        }
        
    } failure:^(NSString * _Nullable errorReason) {
        if (call) call(nil);
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
    }];
    
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_GOODS_GETGOODSLIST) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //
    //        NSArray *dataArray;
    //        if ([dic[DATAS] isKindOfClass:[NSArray class]] == YES) {
    //            dataArray = dic[DATAS];
    //        }else{
    //            dataArray =  dic[DATAS][LIST];
    //        }
    //        if (dataArray.count > 0) {
    //            NSArray *dataList = [WengenGoodsModel mj_objectArrayWithKeyValuesArray:dataArray];
    //            if (call) call(dataList);
    //        }else{
    //            if (call) call(nil);
    //        }
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///(文创 商城) 商品详情
-(void)getGoodsInfo:(NSDictionary *)param Callback:(NSObjectCallBack)call{
    
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_GOODS_GETGOODSINFO parameters:param success:^(NSDictionary * _Nullable resultDic) {
        
        GoodsInfoModel *mode =[GoodsInfoModel mj_objectWithKeyValues:resultDic];
        if (call) call(mode);
        
    } failure:^(NSString * _Nullable errorReason) {
        if (call) call(nil);
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
    }];
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_GOODS_GETGOODSINFO) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        if ([ModelTool checkResponseObject:dic]) {
    //
    //            NSDictionary *data = dic[DATAS];
    //
    //            GoodsInfoModel *mode =[GoodsInfoModel mj_objectWithKeyValues:data];
    //            if (call) call(mode);
    //        }else{
    //            if (call) call(nil);
    //        }
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///(文创 商城) 店铺信息
-(void)getStoreInfo:(NSDictionary *)param Callback:(NSObjectCallBack)call{
    
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_CLUB_GETCLUBINFO parameters:param success:^(NSDictionary * _Nullable resultDic) {
        
        GoodsStoreInfoModel *mode =[GoodsStoreInfoModel mj_objectWithKeyValues:resultDic];
        if (call) call(mode);
        
    } failure:^(NSString * _Nullable errorReason) {
        if (call) call(nil);
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
    }];
    
    
    
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_CLUB_GETCLUBINFO) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //        if ([ModelTool checkResponseObject:dic]) {
    //
    //            NSDictionary *data = dic[DATAS];
    //
    //            GoodsStoreInfoModel *mode =[GoodsStoreInfoModel mj_objectWithKeyValues:data];
    //
    //            if (call) call(mode);
    //        } else {
    //            if (call) call(nil);
    //        }
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///(文创 商城) 收货地址列表
-(void)getAddressListCallback:(NSArrayCallBack)call{
    
    
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_ADDRESS_ADDRESSLIST parameters:@{} success:^(NSDictionary * _Nullable resultDic) {
        
        NSArray *dataList = [AddressListModel mj_objectArrayWithKeyValuesArray:resultDic[@"list"]];
        if (call) call(dataList);
        
    } failure:^(NSString * _Nullable errorReason) {
        if (call) call(nil);
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
    }];
    
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_ADDRESS_ADDRESSLIST) parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //        if ([ModelTool checkResponseObject:dic]) {
    //
    //
    //            NSDictionary *data = dic[DATAS];
    //            NSArray *dataList = [AddressListModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
    //            if (call) call(dataList);
    //        }else{
    //            if (call) call(nil);
    //        }
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///(文创 商城) 新建收货地址文件
-(void)getAddressListFile{
    /* 创建网络下载对象 */
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    /* 下载地址 */
    NSURL *url = [NSURL URLWithString:ADD(URL_GET_AREA_LIST_TXT)];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    /* 下载路径 */
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [path stringByAppendingPathComponent:url.lastPathComponent];
    /* 开始请求下载 */
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        /* 设定下载到的位置 */
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePathUrl, NSError * _Nullable error) {
        NSLog(@"下载完成");
        [ModelTool processingAddressData:filePath];
    }];
    [downloadTask resume];
    [SLRequest refreshToken];
}

///(文创 商城) 添加收货地址
-(void)addAddress:(NSDictionary *)param Callback:(MessageCallBack)call{
    
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_ADDRESS_ADDADDRESS parameters:param success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        Message *message = [[Message alloc]init];
        BOOL isSuccess = NO;
        if ([ModelTool checkResponseObject:resultDic]){
            isSuccess = YES;
        }else{
            isSuccess = NO;
        }
        message.isSuccess = isSuccess;
        message.reason = resultDic[MSG];
        
        if (call) call(message);
        
    }];
    
    
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_ADDRESS_ADDADDRESS) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        Message *message = [[Message alloc]init];
    //        BOOL isSuccess = NO;
    //        if ([ModelTool checkResponseObject:dic]){
    //            isSuccess = YES;
    //        }else{
    //            isSuccess = NO;
    //        }
    //        message.isSuccess = isSuccess;
    //        message.reason = dic[MSG];
    //
    //        if (call) call(message);
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///(文创 商城) 计算商品运费
-(void)computeGoodsFee:(NSDictionary *)param Callback:(NSDictionaryCallBack)call{
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_ORDER_COMPUTEGOODSFEE parameters:param success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        if ([ModelTool checkResponseObject:resultDic]) {
            NSDictionary *tem = resultDic[DATAS];
            if (call) call(tem);
        }else{
            if (call) call(nil);
        }
        
    }];
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_ORDER_COMPUTEGOODSFEE) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //
    //        if ([ModelTool checkResponseObject:dic]) {
    //
    //
    //            NSDictionary *tem = dic[DATAS];
    //            if (call) call(tem);
    //        }else{
    //            if (call) call(nil);
    //        }
    //
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}


///(文创 商城) 收货地址详情
-(void)getAddressInfo:(NSDictionary *)param Callback:(NSObjectCallBack)call{
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_ADDRESS_GETADDRESSINFO parameters:param success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        if ([ModelTool checkResponseObject:resultDic]) {
            
            
            NSDictionary *dataDic = resultDic[DATAS];
            AddressListModel *model = [AddressListModel mj_objectWithKeyValues:dataDic];
            
            if (call) call(model);
            
        }else{
            if (call) call(nil);
        }
        
    }];
    
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_ADDRESS_GETADDRESSINFO) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        if ([ModelTool checkResponseObject:dic]) {
    //
    //
    //            NSDictionary *dataDic = dic[DATAS];
    //            AddressListModel *model = [AddressListModel mj_objectWithKeyValues:dataDic];
    //
    //            if (call) call(model);
    //
    //        }else{
    //            if (call) call(nil);
    //        }
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///(文创 商城) 修改收货地址
-(void)editAddress:(NSDictionary *)param Callback:(MessageCallBack)call{
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_ADDRESS_EDITADDRESS parameters:param success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        Message *message = [[Message alloc]init];
        BOOL isSuccess = NO;
        if ([ModelTool checkResponseObject:resultDic]){
            isSuccess = YES;
        }else{
            isSuccess = NO;
        }
        message.isSuccess = isSuccess;
        message.reason = resultDic[MSG];
        
        if (call) call(message);
        
    }];
    
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_ADDRESS_EDITADDRESS) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        Message *message = [[Message alloc]init];
    //        BOOL isSuccess = NO;
    //        if ([ModelTool checkResponseObject:dic]){
    //            isSuccess = YES;
    //        }else{
    //            isSuccess = NO;
    //        }
    //        message.isSuccess = isSuccess;
    //        message.reason = dic[MSG];
    //
    //        if (call) call(message);
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///(文创 商城) 删除收货地址
-(void)delAddress:(NSDictionary *)param Callback:(MessageCallBack)call{
    
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_ADDRESS_DELADDRESS parameters:param success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        Message *message = [[Message alloc]init];
        BOOL isSuccess = NO;
        if ([ModelTool checkResponseObject:resultDic]){
            isSuccess = YES;
            NSArray *tem =resultDic[DATAS];
            
            NSDictionary *dataDic =  [tem lastObject];
            
            [[ModelTool shareInstance]setCarCount:[NSString stringWithFormat:@"%@",dataDic[@"carCount"]]];
            [[NSNotificationCenter defaultCenter]postNotificationName:WENGENMANAGER_GETORDERANDCARTCOUNT object:nil userInfo:dataDic];
        }else{
            isSuccess = NO;
        }
        message.isSuccess = isSuccess;
        message.reason = resultDic[MSG];
        
        if (call) call(message);
        
    }];
    
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_ADDRESS_DELADDRESS) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        Message *message = [[Message alloc]init];
    //        BOOL isSuccess = NO;
    //        if ([ModelTool checkResponseObject:dic]){
    //            isSuccess = YES;
    //            NSArray *tem =dic[DATAS];
    //
    //            NSDictionary *dataDic =  [tem lastObject];
    //
    //            [[ModelTool shareInstance]setCarCount:[NSString stringWithFormat:@"%@",dataDic[@"carCount"]]];
    //            [[NSNotificationCenter defaultCenter]postNotificationName:WENGENMANAGER_GETORDERANDCARTCOUNT object:nil userInfo:dataDic];
    //        }else{
    //            isSuccess = NO;
    //        }
    //        message.isSuccess = isSuccess;
    //        message.reason = dic[MSG];
    //
    //        if (call) call(message);
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///(文创 商城) 添加购物车
-(void)addCar:(NSDictionary *)param Callback:(MessageCallBack)call{
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_GOODS_CAR_ADDCAR parameters:param success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        Message *message = [[Message alloc]init];
        BOOL isSuccess = NO;
        if ([ModelTool checkResponseObject:resultDic]){
            isSuccess = YES;
            NSArray *tem = resultDic[DATAS];
            
            NSDictionary *dataDic =  [tem lastObject];
            
            [[ModelTool shareInstance]setCarCount:[NSString stringWithFormat:@"%@",dataDic[@"carCount"]]];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:WENGENMANAGER_GETORDERANDCARTCOUNT object:nil userInfo:dataDic];
        }else{
            isSuccess = NO;
        }
        message.isSuccess = isSuccess;
        message.reason = resultDic[MSG];
        
        if (call) call(message);
        
    }];
    
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_GOODS_CAR_ADDCAR) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        Message *message = [[Message alloc]init];
    //        BOOL isSuccess = NO;
    //        if ([ModelTool checkResponseObject:dic]){
    //            isSuccess = YES;
    //            NSArray *tem =dic[DATAS];
    //
    //            NSDictionary *dataDic =  [tem lastObject];
    //
    //            [[ModelTool shareInstance]setCarCount:[NSString stringWithFormat:@"%@",dataDic[@"carCount"]]];
    //
    //            [[NSNotificationCenter defaultCenter]postNotificationName:WENGENMANAGER_GETORDERANDCARTCOUNT object:nil userInfo:dataDic];
    //        }else{
    //            isSuccess = NO;
    //        }
    //        message.isSuccess = isSuccess;
    //        message.reason = dic[MSG];
    //
    //        if (call) call(message);
    //
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}


///(文创 商城) 购物车列表
-(void)getCartList:(NSDictionary *)param Callback:(NSArrayCallBack)call{
    
    
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_GOODS_CAR_CARLIST parameters:param success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        if ([ModelTool checkResponseObject:resultDic]){
            
            NSArray *dicArray = resultDic[DATAS][LIST];
            NSArray *dataList = [ShoppingCartListModel mj_objectArrayWithKeyValuesArray:dicArray];
            if (call) call(dataList);
        }else{
            if (call) call(nil);
        }
        
    }];
    
    
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_GOODS_CAR_CARLIST) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //
    //        if ([ModelTool checkResponseObject:dic]){
    //
    //            NSArray *dicArray = dic[DATAS][LIST];
    //            NSArray *dataList = [ShoppingCartListModel mj_objectArrayWithKeyValuesArray:dicArray];
    //            if (call) call(dataList);
    //        }else{
    //            if (call) call(nil);
    //        }
    //
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///(文创 商城) 删除购物车
-(void)delCar:(NSDictionary *)param Callback:(MessageCallBack)call{
    
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_GOODS_CAR_DELCAR parameters:param success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        Message *message = [[Message alloc]init];
        BOOL isSuccess = NO;
        if ([ModelTool checkResponseObject:resultDic]){
            isSuccess = YES;
        }else{
            isSuccess = NO;
        }
        message.isSuccess = isSuccess;
        message.reason = resultDic[MSG];
        
        if (call) call(message);
        
    }];
    
    
    
    
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_GOODS_CAR_DELCAR) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        Message *message = [[Message alloc]init];
    //        BOOL isSuccess = NO;
    //        if ([ModelTool checkResponseObject:dic]){
    //            isSuccess = YES;
    //        }else{
    //            isSuccess = NO;
    //        }
    //        message.isSuccess = isSuccess;
    //        message.reason = dic[MSG];
    //
    //        if (call) call(message);
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///(文创 商城) 购物车减少商品数量
-(void)decrCarNum:(NSDictionary *)param Callback:(MessageCallBack)call{
    
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_GOODS_CAR_DECRCARNUM parameters:param success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        Message *message = [[Message alloc]init];
        BOOL isSuccess = NO;
        if ([ModelTool checkResponseObject:resultDic]){
            isSuccess = YES;
        }else{
            isSuccess = NO;
        }
        message.isSuccess = isSuccess;
        message.reason = resultDic[MSG];
        
        if (call) call(message);
        
    }];
    
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_GOODS_CAR_DECRCARNUM) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        Message *message = [[Message alloc]init];
    //        BOOL isSuccess = NO;
    //        if ([ModelTool checkResponseObject:dic]){
    //            isSuccess = YES;
    //        }else{
    //            isSuccess = NO;
    //        }
    //        message.isSuccess = isSuccess;
    //        message.reason = dic[MSG];
    //
    //        if (call) call(message);
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///(文创 商城) 购物车添加商品数量
-(void)incrCarNum:(NSDictionary *)param Callback:(MessageCallBack)call{
    
    
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_GOODS_CAR_INCRCARNUM parameters:param success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        Message *message = [[Message alloc]init];
        BOOL isSuccess = NO;
        if ([ModelTool checkResponseObject:resultDic]){
            isSuccess = YES;
        }else{
            isSuccess = NO;
            message.extension = resultDic[DATAS][@"stock"];
        }
        message.isSuccess = isSuccess;
        message.reason = resultDic[MSG];
        
        if (call) call(message);
        
    }];
    
    
    
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_GOODS_CAR_INCRCARNUM) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        NSLog(@"dic : %@", dic);
    //
    //        Message *message = [[Message alloc]init];
    //        BOOL isSuccess = NO;
    //        if ([ModelTool checkResponseObject:dic]){
    //            isSuccess = YES;
    //        }else{
    //            isSuccess = NO;
    //            message.extension = dic[DATAS][@"stock"];
    //        }
    //        message.isSuccess = isSuccess;
    //        message.reason = dic[MSG];
    //
    //        if (call) call(message);
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///(文创 商城) 购物车修改规格
-(void)changeGoodsAttr:(NSDictionary *)param Callback:(MessageCallBack)call{
    
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_GOODS_CAR_CHANGEGOODSATTR parameters:param success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        
        Message *message = [[Message alloc]init];
        BOOL isSuccess = NO;
        if ([ModelTool checkResponseObject:resultDic]){
            isSuccess = YES;
        }else{
            isSuccess = NO;
        }
        message.isSuccess = isSuccess;
        message.reason = resultDic[MSG];
        
        if (call) call(message);
    }];
    
    
    
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_GOODS_CAR_CHANGEGOODSATTR) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        Message *message = [[Message alloc]init];
    //        BOOL isSuccess = NO;
    //        if ([ModelTool checkResponseObject:dic]){
    //            isSuccess = YES;
    //        }else{
    //            isSuccess = NO;
    //        }
    //        message.isSuccess = isSuccess;
    //        message.reason = dic[MSG];
    //
    //        if (call) call(message);
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///(文创 商城) 检查商品库存
-(void)checkStock:(NSDictionary *)param Callback:(MessageCallBack)call{
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_GOODS_CHECKSTOCK parameters:param success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        
        Message *message = [[Message alloc]init];
        BOOL isSuccess = NO;
        if ([ModelTool checkResponseObject:resultDic]){
            isSuccess = YES;
        }else{
            isSuccess = NO;
        }
        message.isSuccess = isSuccess;
        message.reason = resultDic[MSG];
        NSArray *data = resultDic[DATAS];
        NSDictionary *dictionary = [data firstObject];
        message.extension = dictionary[@"stock"];
        
        if (call) call(message);
    }];
    
    
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_GOODS_CHECKSTOCK) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        Message *message = [[Message alloc]init];
    //        BOOL isSuccess = NO;
    //        if ([ModelTool checkResponseObject:dic]){
    //            isSuccess = YES;
    //        }else{
    //            isSuccess = NO;
    //        }
    //        message.isSuccess = isSuccess;
    //        message.reason = dic[MSG];
    //        NSArray *data = dic[DATAS];
    //        NSDictionary *dictionary = [data firstObject];
    //        message.extension = dictionary[@"stock"];
    //
    //        if (call) call(message);
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///(文创 商城) 生成订单
-(void)creatOrder:(NSDictionary *)param Callback:(MessageCallBack)call{
    
    
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_ORDER_CREATODER parameters:param success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        
        Message *message = [[Message alloc]init];
        BOOL isSuccess = NO;
        if ([ModelTool checkResponseObject:resultDic]){
            isSuccess = YES;
            message.extension = resultDic[DATAS][@"order_no"];
        }else{
            isSuccess = NO;
        }
        message.isSuccess = isSuccess;
        message.reason = resultDic[MSG];
        
        if (call) call(message);
    }];
    
    
    
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_ORDER_CREATODER) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        Message *message = [[Message alloc]init];
    //        BOOL isSuccess = NO;
    //        if ([ModelTool checkResponseObject:dic]){
    //            isSuccess = YES;
    //            message.extension = dic[DATAS][@"order_no"];
    //        }else{
    //            isSuccess = NO;
    //        }
    //        message.isSuccess = isSuccess;
    //        message.reason = dic[MSG];
    //
    //        if (call) call(message);
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///(文创 商城) 添加收藏
-(void)addCollect:(NSDictionary *)param Callback:(MessageCallBack)call{
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_COLLECT_ADDCOLLECT parameters:param success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        
        Message *message = [[Message alloc]init];
        BOOL isSuccess = NO;
        if ([ModelTool checkResponseObject:resultDic]){
            isSuccess = YES;
        }else{
            isSuccess = NO;
        }
        message.isSuccess = isSuccess;
        message.reason = resultDic[MSG];
        
        if (call) call(message);
    }];
    
    
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_COLLECT_ADDCOLLECT) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        Message *message = [[Message alloc]init];
    //        BOOL isSuccess = NO;
    //        if ([ModelTool checkResponseObject:dic]){
    //            isSuccess = YES;
    //        }else{
    //            isSuccess = NO;
    //        }
    //        message.isSuccess = isSuccess;
    //        message.reason = dic[MSG];
    //
    //        if (call) call(message);
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///(文创 商城) 取消收藏
-(void)cancelCollect:(NSDictionary *)param Callback:(MessageCallBack)call{
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_COLLECT_CANCELCOLLECT parameters:param success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        
        Message *message = [[Message alloc]init];
        BOOL isSuccess = NO;
        if ([ModelTool checkResponseObject:resultDic]){
            isSuccess = YES;
        }else{
            isSuccess = NO;
        }
        message.isSuccess = isSuccess;
        message.reason = resultDic[MSG];
        
        if (call) call(message);
    }];
    
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_COLLECT_CANCELCOLLECT) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        Message *message = [[Message alloc]init];
    //        BOOL isSuccess = NO;
    //        if ([ModelTool checkResponseObject:dic]){
    //            isSuccess = YES;
    //        }else{
    //            isSuccess = NO;
    //        }
    //        message.isSuccess = isSuccess;
    //        message.reason = dic[MSG];
    //
    //        if (call) call(message);
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///(文创 商城) 查看店铺证照信息
-(void)getBusiness:(NSDictionary *)param Callback:(NSDictionaryCallBack)call{
    
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_CLUB_GETBUSINESS parameters:param success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        
        if (call) call(resultDic[DATAS]);
    }];
    
    
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_CLUB_GETBUSINESS) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //        if (call) call(dic[DATAS]);
    //
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///(文创 商城) 我的订单
-(void)userOrderList:(NSDictionary *)param Callback:(NSArrayCallBack)call{
    
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_ORDER_USERORDERLIST_NEW parameters:param success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        
        if ([ModelTool checkResponseObject:resultDic]){
            NSLog(@"%@",resultDic);
            NSArray *dicArray = resultDic[DATAS][LIST];
            NSArray *dataList = [OrderListModel mj_objectArrayWithKeyValuesArray:dicArray];
            
            NSArray *finishingArray = [ModelTool calculateHeight:dataList];
            
            if (call) call(finishingArray);
            
        }else{
            if (call) call(nil);
        }
    }];
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_ORDER_USERORDERLIST_NEW) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        if ([ModelTool checkResponseObject:dic]){
    //            NSLog(@"%@",dic);
    //            NSArray *dicArray = dic[DATAS][LIST];
    //            NSArray *dataList = [OrderListModel mj_objectArrayWithKeyValuesArray:dicArray];
    //
    //            NSArray *finishingArray = [ModelTool calculateHeight:dataList];
    //
    //            if (call) call(finishingArray);
    //
    //        }else{
    //            if (call) call(nil);
    //        }
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///(文创 商城) 订单统计
-(void)getOrderAndCartCount{
    
    
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_ORDER_GETCOUNT parameters:@{} success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        
        if ([ModelTool checkResponseObject:resultDic]){
            
            NSDictionary *dataDic = resultDic[DATAS];
            
            ModelTool *tool = [ModelTool shareInstance];
            
            tool.carCount = [NSString stringWithFormat:@"%@",dataDic[@"carCount"]];
            tool.orderCount = [NSString stringWithFormat:@"%@",dataDic[@"orderCount"]];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:WENGENMANAGER_GETORDERANDCARTCOUNT object:nil userInfo:dataDic];
            
            
            //            [[ModelTool shareInstance]setOrderCount:[NSString stringWithFormat:@"%@",dataDic[@"orderCount"]]];
            //            [[ModelTool shareInstance]setCarCount:[NSString stringWithFormat:@"%@",dataDic[@"carCount"]]];
        }
    }];
    
    
    
    
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_ORDER_GETCOUNT) parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        if ([ModelTool checkResponseObject:dic]){
    //
    //            NSDictionary *dataDic = dic[DATAS];
    //
    //            ModelTool *tool = [ModelTool shareInstance];
    //
    //            tool.carCount = [NSString stringWithFormat:@"%@",dataDic[@"carCount"]];
    //            tool.orderCount = [NSString stringWithFormat:@"%@",dataDic[@"orderCount"]];
    //
    //            [[NSNotificationCenter defaultCenter]postNotificationName:WENGENMANAGER_GETORDERANDCARTCOUNT object:nil userInfo:dataDic];
    //
    //
    //            //            [[ModelTool shareInstance]setOrderCount:[NSString stringWithFormat:@"%@",dataDic[@"orderCount"]]];
    //            //            [[ModelTool shareInstance]setCarCount:[NSString stringWithFormat:@"%@",dataDic[@"carCount"]]];
    //        }
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //    }];
}


///(文创 商城) 删除订单
-(void)delOrder:(NSDictionary *)param Callback:(MessageCallBack)call{
    
    
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_ORDER_DELORDER parameters:param success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        Message *message = [[Message alloc]init];
        BOOL isSuccess = NO;
        if ([ModelTool checkResponseObject:resultDic]){
            isSuccess = YES;
        }else{
            isSuccess = NO;
        }
        message.isSuccess = isSuccess;
        message.reason = resultDic[MSG];
        
        if (call) call(message);
    }];
    
    
    
    
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_ORDER_DELORDER) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        Message *message = [[Message alloc]init];
    //        BOOL isSuccess = NO;
    //        if ([ModelTool checkResponseObject:dic]){
    //            isSuccess = YES;
    //        }else{
    //            isSuccess = NO;
    //        }
    //        message.isSuccess = isSuccess;
    //        message.reason = dic[MSG];
    //
    //        if (call) call(message);
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///(文创 商城) 订单详情
-(void)getOrderInfo:(NSDictionary *)param Callback:(NSObjectCallBack)call{
    
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_ORDER_ORDERINFONEW parameters:param success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        if ([ModelTool checkResponseObject:resultDic]) {
            NSArray *dicArray = resultDic[DATAS][LIST];
            NSArray *dataList = [OrderDetailsModel mj_objectArrayWithKeyValuesArray:dicArray];
            if (call) call(dataList);
        }
    }];
    
    
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_ORDER_ORDERINFONEW) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //        if ([ModelTool checkResponseObject:dic]) {
    //            NSArray *dicArray = dic[DATAS][LIST];
    //            NSArray *dataList = [OrderDetailsModel mj_objectArrayWithKeyValuesArray:dicArray];
    //            if (call) call(dataList);
    //        }
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///(文创 商城) 订单详情
-(void)getOrderInfoNew:(NSDictionary *)param Callback:(NSObjectCallBack)call{
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_ORDER_ORDERINFONEW parameters:param success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        if ([ModelTool checkResponseObject:resultDic]) {
            NSDictionary *dataDic = resultDic[DATAS];
            
            NSArray *dataList = [OrderDetailsModel mj_objectArrayWithKeyValuesArray:dataDic[@"list"]];
            if (call) call(dataList);
        } else {
            if (call) call(nil);
        }
    }];
    
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_ORDER_ORDERINFONEW) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        if ([ModelTool checkResponseObject:dic]) {
    //            NSDictionary *dataDic = dic[DATAS];
    //
    //            NSArray *dataList = [OrderDetailsModel mj_objectArrayWithKeyValuesArray:dataDic[@"list"]];
    //            if (call) call(dataList);
    //        } else {
    //            if (call) call(nil);
    //        }
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///(文创 商城) 确认订单
-(void)confirmReceipt:(NSDictionary *)param Callback:(MessageCallBack)call{
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_ORDER_CONFIRMRECEIPT parameters:param success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        
        Message *message = [[Message alloc]init];
        BOOL isSuccess = NO;
        if ([ModelTool checkResponseObject:resultDic]){
            isSuccess = YES;
        }else{
            isSuccess = NO;
        }
        message.isSuccess = isSuccess;
        message.reason = resultDic[MSG];
        
        if (call) call(message);
    }];
    
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_ORDER_CONFIRMRECEIPT) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        Message *message = [[Message alloc]init];
    //        BOOL isSuccess = NO;
    //        if ([ModelTool checkResponseObject:dic]){
    //            isSuccess = YES;
    //        }else{
    //            isSuccess = NO;
    //        }
    //        message.isSuccess = isSuccess;
    //        message.reason = dic[MSG];
    //
    //        if (call) call(message);
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///(文创 商城) 添加评论订单
-(void)addEvaluate:(NSDictionary *)param Callback:(MessageCallBack)call{
    
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_EVALUATE_ADDEVALUATE parameters:param success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        Message *message = [[Message alloc]init];
        BOOL isSuccess = NO;
        if ([ModelTool checkResponseObject:resultDic]){
            isSuccess = YES;
        }else{
            isSuccess = NO;
        }
        message.isSuccess = isSuccess;
        message.reason = resultDic[MSG];
        
        if (call) call(message);
    }];
    
    
    
    
    
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_EVALUATE_ADDEVALUATE) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        Message *message = [[Message alloc]init];
    //        BOOL isSuccess = NO;
    //        if ([ModelTool checkResponseObject:dic]){
    //            isSuccess = YES;
    //        }else{
    //            isSuccess = NO;
    //        }
    //        message.isSuccess = isSuccess;
    //        message.reason = dic[MSG];
    //
    //        if (call) call(message);
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///(文创 商城) 取消订单
-(void)cancelOrder:(NSDictionary *)param Callback:(MessageCallBack)call{
    
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_ORDER_CANCELORDER parameters:param success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        Message *message = [[Message alloc]init];
        BOOL isSuccess = NO;
        if ([ModelTool checkResponseObject:resultDic]){
            isSuccess = YES;
        }else{
            isSuccess = NO;
        }
        message.isSuccess = isSuccess;
        message.reason = resultDic[MSG];
        
        if (call) call(message);
    }];
    
    
    
    
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_ORDER_CANCELORDER) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        Message *message = [[Message alloc]init];
    //        BOOL isSuccess = NO;
    //        if ([ModelTool checkResponseObject:dic]){
    //            isSuccess = YES;
    //        }else{
    //            isSuccess = NO;
    //        }
    //        message.isSuccess = isSuccess;
    //        message.reason = dic[MSG];
    //
    //        if (call) call(message);
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///(文创 商城) 订单申请售后
-(void)addRefund:(NSDictionary *)param Callback:(MessageCallBack)call{
    
    
    
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_REFUND_ADDREFUND parameters:param success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        Message *message = [[Message alloc]init];
        BOOL isSuccess = NO;
        if ([ModelTool checkResponseObject:resultDic]){
            isSuccess = YES;
        }else{
            isSuccess = NO;
        }
        message.isSuccess = isSuccess;
        message.reason = resultDic[MSG];
        
        if (call) call(message);
    }];
    
    
    
    
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_REFUND_ADDREFUND) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        Message *message = [[Message alloc]init];
    //        BOOL isSuccess = NO;
    //        if ([ModelTool checkResponseObject:dic]){
    //            isSuccess = YES;
    //        }else{
    //            isSuccess = NO;
    //        }
    //        message.isSuccess = isSuccess;
    //        message.reason = dic[MSG];
    //
    //        if (call) call(message);
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///(文创 商城) 订单取消售后
-(void)cannelRefund:(NSDictionary *)param Callback:(MessageCallBack)call{
    
    
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_REFUND_CANNELREFUND parameters:param success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        Message *message = [[Message alloc]init];
        BOOL isSuccess = NO;
        if ([ModelTool checkResponseObject:resultDic]){
            isSuccess = YES;
        }else{
            isSuccess = NO;
        }
        message.isSuccess = isSuccess;
        message.reason = resultDic[MSG];
        
        if (call) call(message);
    }];
    
    
    
    
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_REFUND_CANNELREFUND) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        Message *message = [[Message alloc]init];
    //        BOOL isSuccess = NO;
    //        if ([ModelTool checkResponseObject:dic]){
    //            isSuccess = YES;
    //        }else{
    //            isSuccess = NO;
    //        }
    //        message.isSuccess = isSuccess;
    //        message.reason = dic[MSG];
    //
    //        if (call) call(message);
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///(文创 商城) 售后申请详情
-(void)getRefundInfo:(NSDictionary *)param Callback:(NSObjectCallBack)call{
    
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_REFUND_GETREFUNINFO parameters:param success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        if ([ModelTool checkResponseObject:resultDic]) {
            NSDictionary *dataDic = resultDic[DATAS];
            
            OrderRefundInfoModel *model = [OrderRefundInfoModel mj_objectWithKeyValues:dataDic[@"list"]];
            
            if (call) call(model);
        } else {
            if (call) call(nil);
        }
    }];
    
    
    
    
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_REFUND_GETREFUNINFO) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        if ([ModelTool checkResponseObject:dic]) {
    //            NSDictionary *dataDic = dic[DATAS];
    //
    //            OrderRefundInfoModel *model = [OrderRefundInfoModel mj_objectWithKeyValues:dataDic[@"list"]];
    //
    //            if (call) call(model);
    //        } else {
    //            if (call) call(nil);
    //        }
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}


///(文创 商城) 支付密码校验
-(void)payPasswordCheck:(NSDictionary *)param Callback:(MessageCallBack)call{
    
    
    
    [SLRequest postJsonRequestWithApi:URL_POST_USER_PAYPASSWORDCHECK parameters:param success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        Message *message = [[Message alloc]init];
        BOOL isSuccess = NO;
        if ([ModelTool checkResponseObject:resultDic]){
            isSuccess = YES;
        }else{
            isSuccess = NO;
        }
        message.isSuccess = isSuccess;
        message.reason = resultDic[MSG];
        
        if (call) call(message);
    }];
    
    
    
    //    [self.manager POST:[NSString stringWithFormat:@"%@%@", Found, URL_POST_USER_PAYPASSWORDCHECK] parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        Message *message = [[Message alloc]init];
    //        BOOL isSuccess = NO;
    //        if ([ModelTool checkResponseObject:dic]){
    //            isSuccess = YES;
    //        }else{
    //            isSuccess = NO;
    //        }
    //        message.isSuccess = isSuccess;
    //        message.reason = dic[MSG];
    //
    //        if (call) call(message);
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///(文创 商城) 支付
-(void)orderPay:(NSDictionary *)param Callback:(MessageCallBack)call{
    
    
    
    
    
    [SLRequest postJsonRequestWithApi:URL_POST_USER_PAY_ORDERPAY parameters:param success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        Message *message = [[Message alloc]init];
        BOOL isSuccess = NO;
        if ([ModelTool checkResponseObject:resultDic]){
            isSuccess = YES;
        }else{
            isSuccess = NO;
        }
        message.isSuccess = isSuccess;
        message.reason = resultDic[MSG];
        
        if (call) call(message);
    }];
    
    
    
    
    //    [self.manager POST:[NSString stringWithFormat:@"%@%@", Found, URL_POST_USER_PAY_ORDERPAY] parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        Message *message = [[Message alloc]init];
    //        BOOL isSuccess = NO;
    //        if ([ModelTool checkResponseObject:dic]){
    //            isSuccess = YES;
    //        }else{
    //            isSuccess = NO;
    //        }
    //        message.isSuccess = isSuccess;
    //        message.reason = dic[MSG];
    //
    //        if (call) call(message);
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///(文创 商城) 获取余额
-(void)userBalanceCallback:(MessageCallBack)call{
    
    
    [SLRequest postJsonRequestWithApi:URL_POST_USER_BALANCE parameters:@{} success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        Message *message = [[Message alloc]init];
        BOOL isSuccess = NO;
        if ([ModelTool checkResponseObject:resultDic]){
            isSuccess = YES;
            message.extensionDic = resultDic[DATAS];
        }else{
            isSuccess = NO;
        }
        message.isSuccess = isSuccess;
        message.reason = resultDic[MSG];
        
        
        if (call) call(message);
        
        if (call) call(message);
    }];
    
    
    
    
    //
    //    [self.manager POST:[NSString stringWithFormat:@"%@%@", Found, URL_POST_USER_BALANCE] parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        Message *message = [[Message alloc]init];
    //        BOOL isSuccess = NO;
    //        if ([ModelTool checkResponseObject:dic]){
    //            isSuccess = YES;
    //            message.extensionDic = dic[DATAS];
    //        }else{
    //            isSuccess = NO;
    //        }
    //        message.isSuccess = isSuccess;
    //        message.reason = dic[MSG];
    //
    //
    //        if (call) call(message);
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///收藏店铺列表
-(void)getMyCollectCallback:(NSArrayCallBack)call{
    
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_COLLECT_MYCOLLECT parameters:@{} success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        NSArray *dataArray;
        if ([resultDic[DATAS] isKindOfClass:[NSArray class]] == YES) {
            dataArray = resultDic[DATAS];
        }else{
            dataArray =  resultDic[DATAS][LIST];
        }
        if (dataArray.count > 0) {
            NSArray *dataList = [GoodsStoreInfoModel mj_objectArrayWithKeyValuesArray:dataArray];
            
            for (GoodsStoreInfoModel *itme in dataList) {
                itme.collect = @"1";
            }
            
            if (call) call(dataList);
        }else{
            if (call) call(nil);
        }
    }];
    
    
    
    
    
    //
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_COLLECT_MYCOLLECT) parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        NSArray *dataArray;
    //        if ([dic[DATAS] isKindOfClass:[NSArray class]] == YES) {
    //            dataArray = dic[DATAS];
    //        }else{
    //            dataArray =  dic[DATAS][LIST];
    //        }
    //        if (dataArray.count > 0) {
    //            NSArray *dataList = [GoodsStoreInfoModel mj_objectArrayWithKeyValuesArray:dataArray];
    //
    //            for (GoodsStoreInfoModel *itme in dataList) {
    //                itme.collect = @"1";
    //            }
    //
    //            if (call) call(dataList);
    //        }else{
    //            if (call) call(nil);
    //        }
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///(文创 商城) 申请售后发货
-(void)sendRefundGoods:(NSDictionary *)param Callback:(MessageCallBack)call{
    
    
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_REFUND_SENDREFUNDGOODS parameters:param success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        Message *message = [[Message alloc]init];
        BOOL isSuccess = NO;
        if ([ModelTool checkResponseObject:resultDic]){
            isSuccess = YES;
        }else{
            isSuccess = NO;
        }
        message.isSuccess = isSuccess;
        message.reason = resultDic[MSG];
        
        if (call) call(message);
    }];
    
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_REFUND_SENDREFUNDGOODS) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        Message *message = [[Message alloc]init];
    //        BOOL isSuccess = NO;
    //        if ([ModelTool checkResponseObject:dic]){
    //            isSuccess = YES;
    //        }else{
    //            isSuccess = NO;
    //        }
    //        message.isSuccess = isSuccess;
    //        message.reason = dic[MSG];
    //
    //        if (call) call(message);
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///(文创 商城) 删除售后
-(void)delRefundOrder:(NSDictionary *)param Callback:(MessageCallBack)call{
    
    
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_ORDER_DELREFUNDORDER parameters:param success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        Message *message = [[Message alloc]init];
        BOOL isSuccess = NO;
        if ([ModelTool checkResponseObject:resultDic]){
            isSuccess = YES;
        }else{
            isSuccess = NO;
        }
        message.isSuccess = isSuccess;
        message.reason = resultDic[MSG];
        
        if (call) call(message);
    }];
    
    
    
    
    
    //
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_ORDER_DELREFUNDORDER) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        Message *message = [[Message alloc]init];
    //        BOOL isSuccess = NO;
    //        if ([ModelTool checkResponseObject:dic]){
    //            isSuccess = YES;
    //        }else{
    //            isSuccess = NO;
    //        }
    //        message.isSuccess = isSuccess;
    //        message.reason = dic[MSG];
    //
    //        if (call) call(message);
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///(文创 商城) 用户资质信息
-(void)userQualifications:(NSDictionary *)param Callback:(NSObjectCallBack)call{
    
    
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_INVOICE_USERQUALIFICATIONS parameters:param success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        if ([ModelTool checkResponseObject:resultDic]) {
            NSDictionary *dataDic = resultDic[DATAS];
            
            InvoiceQualificationsModel *model = [InvoiceQualificationsModel mj_objectWithKeyValues:dataDic];
            
            if (call) call(model);
        }else{
            if (call) call(nil);
        }
    }];
    
    
    
    
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_INVOICE_USERQUALIFICATIONS) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        if ([ModelTool checkResponseObject:dic]) {
    //            NSDictionary *dataDic = dic[DATAS];
    //
    //            InvoiceQualificationsModel *model = [InvoiceQualificationsModel mj_objectWithKeyValues:dataDic];
    //
    //            if (call) call(model);
    //        }else{
    //            if (call) call(nil);
    //        }
    //
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
    
}


///(文创 商城) 添加用户资质
-(void)addQualifications:(NSDictionary *)param Callback:(MessageCallBack)call{
    
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_INVOICE_ADDQUALIFICATIONS parameters:param success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        Message *message = [[Message alloc]init];
        BOOL isSuccess = NO;
        if ([ModelTool checkResponseObject:resultDic]){
            isSuccess = YES;
        }else{
            isSuccess = NO;
        }
        message.isSuccess = isSuccess;
        message.reason = resultDic[MSG];
        
        if (call) call(message);
    }];
    
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_INVOICE_ADDQUALIFICATIONS) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        Message *message = [[Message alloc]init];
    //        BOOL isSuccess = NO;
    //        if ([ModelTool checkResponseObject:dic]){
    //            isSuccess = YES;
    //        }else{
    //            isSuccess = NO;
    //        }
    //        message.isSuccess = isSuccess;
    //        message.reason = dic[MSG];
    //
    //        if (call) call(message);
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///(文创 商城) 申请开发票
-(void)invoicing:(NSDictionary *)param Callback:(MessageCallBack)call{
    
    
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_INVOICE_INVOICING parameters:param success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        Message *message = [[Message alloc]init];
        BOOL isSuccess = NO;
        if ([ModelTool checkResponseObject:resultDic]){
            isSuccess = YES;
        }else{
            isSuccess = NO;
        }
        message.isSuccess = isSuccess;
        message.reason = resultDic[MSG];
        
        if (call) call(message);
    }];
    
    
    
    
    
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_INVOICE_INVOICING) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        Message *message = [[Message alloc]init];
    //        BOOL isSuccess = NO;
    //        if ([ModelTool checkResponseObject:dic]){
    //            isSuccess = YES;
    //        }else{
    //            isSuccess = NO;
    //        }
    //        message.isSuccess = isSuccess;
    //        message.reason = dic[MSG];
    //
    //        if (call) call(message);
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}

///(文创 商城) ahq 列表
-(void)getAhqList:(NSDictionary *)param Callback:(NSArrayCallBack)call{
    
    
    
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_AHP_GETAHQLIST parameters:param success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        if ([ModelTool checkResponseObject:resultDic]) {
            
            NSLog(@"dic : %@", resultDic);
            
            NSArray *dataArray;
            if ([resultDic[DATAS] isKindOfClass:[NSArray class]] == YES) {
                dataArray = resultDic[DATAS];
            }else{
                dataArray =  resultDic[DATAS][LIST];
            }
            
            NSArray *dataList = [CustomerServieListModel mj_objectArrayWithKeyValuesArray:dataArray];
            
            if (call) {
                call(dataList);
            }
            
        }else{
            if (call) {
                call(nil);
            }
        }
    }];
    
    
    
    //    [self.manager POST:ADD(URL_POST_SHOPAPI_COMMON_AHP_GETAHQLIST) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        if ([ModelTool checkResponseObject:dic]) {
    //
    //            NSLog(@"dic : %@", dic);
    //
    //            NSArray *dataArray;
    //            if ([dic[DATAS] isKindOfClass:[NSArray class]] == YES) {
    //                dataArray = dic[DATAS];
    //            }else{
    //                dataArray =  dic[DATAS][LIST];
    //            }
    //
    //            NSArray *dataList = [CustomerServieListModel mj_objectArrayWithKeyValuesArray:dataArray];
    //
    //            if (call) {
    //                call(dataList);
    //            }
    //
    //        }else{
    //            if (call) {
    //                call(nil);
    //            }
    //        }
    //
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
}


#pragma mark - 构造单例
+(instancetype)shareInstance{
    static WengenManager *_sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //不能再使用alloc方法
        //因为已经重写了allocWithZone方法，所以这里要调用父类的分配空间的方法
        _sharedSingleton = [[super allocWithZone:NULL] init];
    });
    return _sharedSingleton;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    return [WengenManager shareInstance];
}

-(id)copyWithZone:(nullable NSZone *)zone {
    return [WengenManager shareInstance];
}

-(id)mutableCopyWithZone:(nullable NSZone *)zone {
    return [WengenManager shareInstance];;
}

-(void)updateToken{
    SLAppInfoModel *appInfoModel = [[SLAppInfoModel sharedInstance] getCurrentUserInfo];
    
    
    
    if (appInfoModel != nil && appInfoModel.access_token != nil) {
        
        //        [_manager.requestSerializer setValue:@"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ7cGFzZXRpbWU9MTU4OTA3OTIzNTM4NiwgaWQ9Mn0iLCJleHAiOjE1ODkwMjE2MzUsIm5iZiI6MTU4ODk5MjgzNX0.v56m__nUqo7Tw7rZlnwcLtSazKUdJPKggZwbx3wwFRg" forHTTPHeaderField:@"access_token"];
        //        struct utsname systemInfo;
        //        uname(&systemInfo);
        //        NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        [_manager.requestSerializer setValue:appInfoModel.access_token forHTTPHeaderField:@"token"];
        [_manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"cellphoneType"];
        [_manager.requestSerializer setValue:BUILD_STR forHTTPHeaderField:@"version"];
        [_manager.requestSerializer setValue:VERSION_STR forHTTPHeaderField:@"versionName"];
        [_manager.requestSerializer setValue:[SLAppInfoModel sharedInstance].deviceString forHTTPHeaderField:@"device-type"];
        
        NSString * systemStr = [NSString stringWithFormat:@"%.2f",SYSTEM_VERSION];
        [_manager.requestSerializer setValue:systemStr forHTTPHeaderField:@"SystemVersionCode"];
    }
}

#pragma mark - gettet / setter
-(AFHTTPSessionManager *)manager{
    if (_manager == nil) {
        //获取请求对象
        _manager= [AFHTTPSessionManager manager];
        // 设置请求格式
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        // 设置返回格式
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        // 返回数据解析类型
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
        [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        //
        //        [_manager.requestSerializer setValue:@"multipart/form-data;" forHTTPHeaderField:@"Content-Type"];
        
        _manager.requestSerializer.timeoutInterval = 60;
    }
    [SLRequest refreshToken];
    [self updateToken];
    return _manager;
}


@end
