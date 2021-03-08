//
//  RiteBlessingModel.h
//  Shaolin
//
//  Created by 王精明 on 2020/8/20.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RiteBlessingModel : NSObject
/*! 是否显示去内坛  true展示去内坛 否则不展示*/
@property (nonatomic) BOOL flag;
/*!祝福语*/
@property (nonatomic, copy) NSString *blessing;
/*!祝福语视频*/
@property (nonatomic, copy) NSString *video;
/*!头像*/
@property (nonatomic, copy) NSString *headUrl;
/*!名字*/
@property (nonatomic, copy) NSString *name;
/*!法号*/
@property (nonatomic, copy) NSString *nickName;
/*!标题(分享用)*/
@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *blessingId;
@end

NS_ASSUME_NONNULL_END
/*
 {
     "code": "200",
     "data": {
         "flag": false,
         "pujaBlessing": {
             "blessing": "测试修改祝福",
             "classif": null,
             "classifName": "",
             "createTime": "",
             "forward": null,
             "headUrl": "测试修改头像",
             "id": null,
             "name": "测试修改姓名",
             "nickname": "测试修改法号",
             "orderCode": "",
             "title": "",
             "updateTime": "",
             "valid": null,
             "video": ""
         }
     },
     "msg": "请求成功"
 }
 */
