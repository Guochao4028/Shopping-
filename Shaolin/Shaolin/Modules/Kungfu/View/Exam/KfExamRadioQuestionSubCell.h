//
//  KfExamRadioQuestionSubCell.h
//  Shaolin
//
//  Created by ws on 2020/5/19.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KfExamRadioQuestionSubCell : UITableViewCell

//@property (nonatomic, copy) NSString * indexStr;

@property (nonatomic, copy) NSString * anserStr;
@property (nonatomic, assign) BOOL isChoose;

+(instancetype)xibRegistrationCell;

@end

NS_ASSUME_NONNULL_END
