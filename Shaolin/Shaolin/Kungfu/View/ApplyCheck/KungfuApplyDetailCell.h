//
//  KungfuApplyDetailCell.h
//  Shaolin
//
//  Created by ws on 2020/6/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KungfuApplyDetailCell : UITableViewCell

+(instancetype)xibRegistrationCell;

@property (weak, nonatomic) IBOutlet UILabel *applyTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyContentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentRightCon;



@end

NS_ASSUME_NONNULL_END
