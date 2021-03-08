//
//  RiteFourLevelModel.h
//  Shaolin
//
//  Created by 王精明 on 2020/8/17.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RiteFourLevelModel : NSObject
@property (nonatomic, copy) NSString *matterName;
@property (nonatomic, copy) NSString *matterId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *showType;
@property (nonatomic, copy) NSString *puja_event_type_id;
@property (nonatomic, copy) NSString *days;
/*!标识报名人数是否已满, true可报名*/
@property (nonatomic) BOOL flag;
/*!其他诵经礼忏*/
@property (nonatomic, copy) NSString *otherMatterName;
@property (nonatomic, strong) NSNumber *needReturnReceipt;// 1 需要回执， 0，不需要。不需要回执直接跳转支付
@end

NS_ASSUME_NONNULL_END
/*
{
    "code": "200",
    "data": [
        {
            "buddhismId": 1,
            "buddhismName": "",
            "buddhismTypeDetail": "",
            "buddhismTypeId": 14,
            "buddhismTypeImg": "",
            "buddhismTypeIntroduction": "",
            "buddhismTypeName": "",
            "code": "2008121448013212",
            "createTime": "",
            "days": null,
            "flag": true,
            "id": null,
            "matterId": 21,
            "matterName": "增福功德",
            "money": null,
            "name": "",
            "showType": null,
            "type": 1,
            "typeId": null,
            "typeName": "",
            "uniqueness": 1,
            "updateTime": "",
            "valid": null,
            "value": []
        }
    ],
    "msg": "请求成功"
}

                            
参数名    描述    类型
data.code    法会编号    string
data.buddhismId    二级ID    number
data.buddhismTypeId    三级ID    number
data.matterName    四级名称    string
data.type    一级ID    number
data.matterId    四级ID    number
data.flag    判断次法会是否存在唯一性 true 可点 false 不可点    boolean
*/
