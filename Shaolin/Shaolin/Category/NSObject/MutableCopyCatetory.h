//
//  MutableCopyCatetory.h
//  Shaolin
//
//  Created by 郭超 on 2020/6/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MutableCopyCatetory : NSObject

@end

@interface NSArray (Catetory)
-(NSMutableArray *)mutableArrayDeeoCopy;
@end

@interface NSDictionary (Catetory)
-(NSMutableDictionary *)mutableDicDeepCopy;
@end


NS_ASSUME_NONNULL_END
