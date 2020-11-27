//
//  ClassifyDropDownView.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/24.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WengenEnterModel;

@interface ClassifyDropDownView : UIView

typedef void (^Selected)(WengenEnterModel* model);

@property(nonatomic, strong)NSArray *dataArray;

@property (nonatomic, copy) Selected selectedBlock;

@property(nonatomic)CGPoint starPoint;



@end


NS_ASSUME_NONNULL_END
