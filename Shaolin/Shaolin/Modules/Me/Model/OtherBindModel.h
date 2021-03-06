//
//  OtherBindModel.h
//  Shaolin
//
//  Created by 王精明 on 2020/7/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OtherBindModel : NSObject
@property (nonatomic) BOOL bindStatus;

// 1.微信 2.微博 3.QQ 4.苹果
@property (nonatomic, copy) NSString *type;
@end

NS_ASSUME_NONNULL_END
