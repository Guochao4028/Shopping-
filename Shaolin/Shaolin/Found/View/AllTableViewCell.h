//
//  AllTableViewCell.h
//  Shaolin
//
//  Created by edz on 2020/3/6.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoundModel.h"

typedef NS_ENUM(NSInteger, CellPosition) {
    CellPosition_Center,
    CellPosition_Top,
    CellPosition_Bottom,
    CellPosition_OnlyOne,
};

@interface AllTableViewCell : UITableViewCell
@property (nonatomic) CellPosition cellPosition;

-(void)setFoundModel:(FoundModel *)f indexpath:(NSIndexPath *)indexPath;
-(NSString *)compaareCurrentTime:(NSDate *)compareDate;
-(NSDate *)nsstringConversionNSDate:(NSString *)dateStr;

-(UIImage *)getShowImage;
@end


