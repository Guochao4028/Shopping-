//
//  Message.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/17.
//  Copyright © 2020 syqaxldy. All rights reserved.
// 消息类 一般消息，记录 成功/失败， 原因

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Message : NSObject

@property (nonatomic, assign) BOOL isSuccess;

@property (nonatomic, copy) NSString * reason;

///扩展 纯放字符串
@property (nonatomic, copy) NSString *extension;

///扩展 其他不能用字符串表示的
@property (nonatomic, strong) NSDictionary *extensionDic;

@end

NS_ASSUME_NONNULL_END
