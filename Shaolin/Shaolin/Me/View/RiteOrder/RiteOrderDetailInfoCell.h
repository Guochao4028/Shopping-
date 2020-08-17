//
//  RiteOrderDetailInfoCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/7/31.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RiteOrderDetailInfoCell : UITableViewCell

@property (nonatomic, copy) NSString * titleStr;
@property (nonatomic, copy) NSString * contentStr;
@property (nonatomic, assign) BOOL isHideLine;

@end

NS_ASSUME_NONNULL_END
