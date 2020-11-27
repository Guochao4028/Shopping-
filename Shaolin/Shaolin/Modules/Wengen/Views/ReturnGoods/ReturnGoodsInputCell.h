//
//  ReturnGoodsInputCell.h
//  Shaolin
//
//  Created by ws on 2020/5/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReturnGoodsInputCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTF;

@property (nonatomic, copy) void(^ inputBlock)(NSString * string);

@end

NS_ASSUME_NONNULL_END
