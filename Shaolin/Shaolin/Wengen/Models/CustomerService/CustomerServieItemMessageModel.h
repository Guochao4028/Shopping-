//
//  CustomerServieItemMessageModel.h
//  Shaolin
//
//  Created by 郭超 on 2020/6/24.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum NSInteger{
    ///右
    MessageTypeMe = 0,
    ///左
    MessageTypeOther = 1
    
}MessageType;

@interface CustomerServieItemMessageModel : NSObject
///内容
@property(nonatomic, copy)NSString * text ;
///时间
@property(nonatomic, copy)NSString * time ;
///类型
@property(nonatomic, assign)MessageType type;
@property(nonatomic, assign)CGFloat cellHeigth;
@property(nonatomic, assign, getter = isHidden)BOOL timeHidden;
///扩展数据
@property(nonatomic, strong)NSDictionary *extensionDic;

@property(nonatomic, assign)BOOL isHasMessage;

@end

NS_ASSUME_NONNULL_END
