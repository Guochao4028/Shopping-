//
//  FieldModel.h
//  Shaolin
//
//  Created by 王精明 on 2020/11/3.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FieldModel : NSObject
@property (nonatomic, copy) NSString *fieldId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *showImg;
@property (nonatomic, copy) NSString *checkedImg;

+ (instancetype)createFieldModel:(NSString *)fieldId name:(NSString *)name showImg:(NSString *)showImg checkedImg:(NSString *)checkedImg;
@end

NS_ASSUME_NONNULL_END
