//
//  FoundModel.m
//  Shaolin
//
//  Created by edz on 2020/3/6.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "FoundModel.h"
#import "StickCell.h"
#import "AdvertisingOneCell.h"
#import "SinglePhotoCell.h"
#import "MorePhotoCell.h"
#import "LongPhotoCell.h"
#import "PureTextTableViewCell.h"
@implementation FoundModel
-(NSString *)cellIdentifier
{
    if ([self.type isEqualToString:@"1"]) {
        return NSStringFromClass([StickCell class]);
    }else if ([self.type isEqualToString:@"3"])
    {
        return NSStringFromClass([AdvertisingOneCell class]);
    }else
    {
        if (self.coverurlList.count == 0) {
             return NSStringFromClass([PureTextTableViewCell class]);
           
        }else if(self.coverurlList.count == 1 || self.coverurlList.count == 2)
        {
            BOOL photoType = NO;
            for (NSDictionary * dic in self.coverurlList) {
                NSString * urlStr = [dic objectForKey:@"route"];
                if (NotNilAndNull(urlStr) && urlStr.length != 0) {
                    photoType = YES;
                }
            }
            if (photoType) {
                return NSStringFromClass([SinglePhotoCell class]);
            } else {
                return NSStringFromClass([PureTextTableViewCell class]);
            }
        } else
        {
            return NSStringFromClass([MorePhotoCell class]);
        }
        
    }

}

- (NSString *)getVideoTimeByUrlString:(NSString*)urlString {
    NSURL*videoUrl = [NSURL URLWithString:urlString];
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:videoUrl];
    CMTime time = [avUrl duration];
    int seconds = ceil(time.value/time.timescale);
    NSString *str_minute = [NSString stringWithFormat:@"%.2d",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%.2d",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    return format_time;
}

///检查返回数据
+(BOOL) checkResponseObject:(NSDictionary *)responseObject{
    BOOL flag = NO;
    
    
    if (responseObject) {
         NSString * code = [responseObject objectForKey:CODE];
        if (code && code.intValue == 200) {
            //正常成功
            flag = YES;
        }else if (code && code.intValue == 10018) {
            //未登录
            flag = NO;
            [[SLAppInfoModel sharedInstance] setNil];
            [[NSNotificationCenter defaultCenter]postNotificationName:MODELTOOL_CHECKRESPONSEOBJECT_DELETEUSER object:nil];
        }else{
            //其他状态码
            flag = NO;
        }
    }else{
        //数据格式错误,非json
        flag = NO;
    }
    
    
    
    
    return flag;
}

@end
