//
//  DefineBlocks.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/17.
//  Copyright © 2020 syqaxldy. All rights reserved.
// block， 常用的一些回调

#ifndef DefineBlocks_h
#define DefineBlocks_h

#import "Message.h"

typedef void (^NSDictionaryCallBack)(NSDictionary * result);

typedef void (^NSArrayCallBack) (NSArray * result);

typedef void (^NSObjectCallBack) (NSObject* object);

typedef void (^NSDataCallBack) (NSData* data);

typedef void (^MessageCallBack) (Message * message);

typedef void (^NSStringCallBack) (NSString* string);

#endif /* DefineBlocks_h */
