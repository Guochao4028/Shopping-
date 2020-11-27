//
//  PostALLCell.h
//  Shaolin
//
//  Created by edz on 2020/4/1.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MePostManagerModel.h"

@interface PostALLCell : UITableViewCell
@property(nonatomic,copy) void (^changeTextAction)(NSIndexPath *indexPath);
@property(nonatomic,copy) void (^lookRefusedTextAction)(NSIndexPath *indexPath);
@property(nonatomic,copy) NSString *typeStr;
-(void)setMePostManagerModel:(MePostManagerModel *)f indexpath:(NSIndexPath *)indexPath;
-(NSString *)compaareCurrentTime:(NSDate *)compareDate;
-(NSDate *)nsstringConversionNSDate:(NSString *)dateStr;
@end


