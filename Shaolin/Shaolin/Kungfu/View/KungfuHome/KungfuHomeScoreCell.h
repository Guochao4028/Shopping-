//
//  KungfuHomeScoreCell.h
//  Shaolin
//
//  Created by ws on 2020/5/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KungfuHomeScoreCell : UITableViewCell

@property (nonatomic, copy) void(^ learnHandle)(void);
@property (nonatomic, copy) void(^ examHandle)(void);

//@property (nonatomic, strong) NSDictionary * resultDic;

@property (nonatomic, copy) NSString * kungfuLevel;

@end

NS_ASSUME_NONNULL_END
