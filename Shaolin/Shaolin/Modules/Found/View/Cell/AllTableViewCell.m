//
//  AllTableViewCell.m
//  Shaolin
//
//  Created by edz on 2020/3/6.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "AllTableViewCell.h"

@implementation AllTableViewCell
- (NSString *)compaareCurrentTime:(NSDate *)compareDate
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];

    timeInterval = -timeInterval;

    long temp = 0;

    NSString *result;

    if (timeInterval < 60) {

        result = SLLocalizedString(@"刚刚");

    }

    else if((temp = timeInterval/60) <60){

        result = [NSString stringWithFormat:SLLocalizedString(@"%ld分钟前"),temp];

    }



    else if((temp = temp/60) <24){

        result = [NSString stringWithFormat:SLLocalizedString(@"%ld小时前"),temp];

    }



    else if((temp = temp/24) <30){

        result = [NSString stringWithFormat:SLLocalizedString(@"%ld天前"),temp];

    }



    else if((temp = temp/30) <12){

        result = [NSString stringWithFormat:SLLocalizedString(@"%ld月前"),temp];

    }

    else{

        temp = temp/12;

        result = [NSString stringWithFormat:SLLocalizedString(@"%ld年前"),temp];

    }



    return  result;
  
}
- (NSDate *)nsstringConversionNSDate:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datestr = [dateFormatter dateFromString:dateStr];
    return datestr;
}

- (UIImage *)getShowImage {
    return [UIImage imageNamed:@"default_small"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
