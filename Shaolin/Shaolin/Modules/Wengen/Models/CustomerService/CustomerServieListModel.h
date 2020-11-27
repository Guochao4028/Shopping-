//
//  CustomerServieListModel.h
//  Shaolin
//
//  Created by 郭超 on 2020/6/23.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomerServieListModel : NSObject
///问题
@property(nonatomic, copy)NSString *question;
///答案
@property(nonatomic, copy)NSString *answer;

@end

NS_ASSUME_NONNULL_END


/**
 {
     "code": 200,
     "msg": "获取自助客服成功",
     "data": {
         "list": [{
             "question": "测试",
             "answer": "测试测试测试测试测试测试"
         }, {
             "question": "123456",
             "answer": "345678"
         }, {
             "question": "rtyuio",
             "answer": "tyuio"
         }, {
             "question": "56789",
             "answer": "56789"
         }]
     }
 }
 */
