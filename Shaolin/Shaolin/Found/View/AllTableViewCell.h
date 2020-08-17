//
//  AllTableViewCell.h
//  Shaolin
//
//  Created by edz on 2020/3/6.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FoundModel.h"
@interface AllTableViewCell : UITableViewCell
-(void)setFoundModel:(FoundModel *)f indexpath:(NSIndexPath *)indexPath;
-(NSString *)compaareCurrentTime:(NSDate *)compareDate;
-(NSDate *)nsstringConversionNSDate:(NSString *)dateStr;

-(UIImage *)getShowImage;
@end


