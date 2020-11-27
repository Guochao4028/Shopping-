//
//  GoodsAttrBasisModel.h
//  Shaolin
//
//  Created by 郭超 on 2020/5/25.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodsAttrBasisModel : NSObject

@property(nonatomic, copy) NSString *attrBasisId;
@property(nonatomic, copy) NSString *name;

//默认是0， 未选中，1， 已选中
@property(nonatomic, assign)BOOL isSeleced;

//默认是1， 可选，0， 不可选
@property(nonatomic, assign)BOOL isOptional;

@end

NS_ASSUME_NONNULL_END

/**
  "id": "23",
 "name": "50ml"
 */
