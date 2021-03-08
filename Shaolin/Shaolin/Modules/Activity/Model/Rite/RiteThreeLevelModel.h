//
//  RiteThreeLevelModel.h
//  Shaolin
//
//  Created by 王精明 on 2020/8/14.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RiteThreeLevelModel : NSObject
@property (nonatomic, copy) NSString *buddhismTypeId;
@property (nonatomic, copy) NSString *buddhismTypeImg;
@property (nonatomic, copy) NSString *buddhismTypeName;
@property (nonatomic, copy) NSString *buddhismTypeDetail;
@property (nonatomic, copy) NSString *buddhismTypeIntroduction;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *days;
@property (nonatomic, copy) NSString *showDate;
@property (nonatomic, copy) NSString *showType;
@property (nonatomic, copy) NSString *uniqueness;
@property (nonatomic, strong) NSNumber *needReturnReceipt;// 1 需要回执， 0，不需要。不需要回执直接跳转支付
/*!标识报名人数是否已满, true可报名*/
@property (nonatomic) BOOL flag;
+ (instancetype)testModel;
@end

/*
data.value.buddhismTypeDetail    三级分类详情    string
data.value.buddhismTypeId    三级分类ID    number
data.value.buddhismTypeImg    三级分类图片    string
data.value.buddhismTypeIntroduction    三级分类简介    string
data.value.buddhismTypeName    三级分类名称    string
data.value.matterId    四级分类ID    number
data.value.matterName    四级分类名称    string
data.value.money    金额    number
data.value.uniqueness    是否具有唯一性（人数）1 是 0 否
*/
NS_ASSUME_NONNULL_END
