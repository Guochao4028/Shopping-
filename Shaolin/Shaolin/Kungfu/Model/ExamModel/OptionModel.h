//
//  OptionModel.h
//  Shaolin
//
//  Created by ws on 2020/5/27.
//  Copyright © 2020 syqaxldy. All rights reserved.
//
//
//  选项model

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OptionModel : NSObject


@property (nonatomic , copy) NSString              * createTime;
@property (nonatomic , copy) NSString              * optionId;
///选项答案
@property (nonatomic , copy) NSString              * optionsName;
///选项名称
@property (nonatomic , copy) NSString              * optionsTitle;
///考题编号
@property (nonatomic , copy) NSString              * questionCode;

@end

NS_ASSUME_NONNULL_END
