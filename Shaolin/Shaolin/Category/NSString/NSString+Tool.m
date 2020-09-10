//
//  NSString+Tool.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/26.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "NSString+Tool.h"


@implementation NSString (Tool)

/**
 验证码手机号

 @param mobileNum 手机号
 @return YES 通过 NO 不通过
 */
+ (BOOL)validateContactNumber:(NSString *)mobileNum{
      /**
          * 手机号码:
          * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 16[6], 17[5, 6, 7, 8], 18[0-9], 170[0-9], 19[89]
          * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705,198
          * 联通号段: 130,131,132,155,156,185,186,145,175,176,1709,166
          * 电信号段: 133,153,180,181,189,177,1700,199
          */
         NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|6[6]|7[05-8]|8[0-9]|9[89])\\d{8}$";

         NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478]|9[8])\\d{8}$)|(^1705\\d{7}$)";
        
         NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|66|7[56]|8[56])\\d{8}$)|(^1709\\d{7}$)";

         NSString *CT = @"([0-9]{11}$)";
         
         /**
          * 大陆地区固话及小灵通
          * 区号：010,020,021,022,023,024,025,027,028,029
          * 号码：七位或八位
          */
        // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
         
         NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
         NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
         NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
         NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
        // NSPredicate *regextestPHS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
         
         if(([regextestmobile evaluateWithObject:mobileNum] == YES)
            || ([regextestcm evaluateWithObject:mobileNum] == YES)
            || ([regextestct evaluateWithObject:mobileNum] == YES)
            || ([regextestcu evaluateWithObject:mobileNum] == YES)) {
             return YES;
         } else {
             return NO;
         }
}

/**
 计算字符串高度或者宽度
 */
+(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize string:(NSString *)string{
    NSDictionary *attrs = @{NSFontAttributeName:font};

    return [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

/**
 时间转化成 时间戳
*/
+(NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format]; //(@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:formatTime];
    //------------将字符串按formatter转成nsdate
    //时间转时间戳的方法:
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    NSLog(@"timeSp:%ld",(long)timeSp); //时间戳的值
    return timeSp;
}

///时间戳变为格式时间
+ (NSString *)convertStrToTime:(NSInteger)time{
    
    //    如果服务器返回的是13位字符串，需要除以1000，否则显示不正确(13位其实代表的是毫秒，需要除以1000)
    //    long long time=[timeStr longLongValue] / 1000;
    
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:(time)];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:SLLocalizedString(@"剩余：mm分钟ss秒")];
    
    NSString*timeString=[formatter stringFromDate:date];
    
    return timeString;
    
}


///隐藏手机号码中间的四位数字
+ (NSString *)numberSuitScanf:(NSString *)numberStr{
    
    if (numberStr.length == 0 || numberStr == nil) {
        return @"";
    }
    //首先验证是不是手机号码
   BOOL isOk = [self validateContactNumber:numberStr];
    
    if (isOk) {//如果是手机号码的话

    NSString *numberString = [numberStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];

    return numberString;

    }
    return numberStr;
    
}

+ (NSString *)nameDataMasking:(NSString *)name{
    if (name == nil) return @"";
    if (name.length <= 1) return name;
    name = [name dataMasking:NSMakeRange(1, name.length - 1)];
    return name;
}

+ (NSString *)idCardDataMasking:(NSString *)idCard{
    if (idCard == nil) return @"";
    if (idCard.length <= 3) return @"";
    idCard = [idCard dataMasking:NSMakeRange(1, idCard.length - 2)];
    return idCard;
}

- (NSString *)dataMasking:(NSRange)rang{
    NSString *string = self;
    NSInteger begin = rang.location;
    while (begin < NSMaxRange(rang) && string.length >= begin + 1) {
        string = [string stringByReplacingCharactersInRange:NSMakeRange(begin, 1) withString:@"*"];
        begin++;
    }
    return string;
}

+(NSString*)currentTime{
  
        // 创建日历对象
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        // 获取当前时间
    NSDate *currentDate = [NSDate date];
        
        // 获取当前时间的年、月、日。利用日历
        NSDateComponents *components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
//        NSInteger currentYear = components.year;
//        NSInteger currentMonth = components.month;
//        NSInteger currentDay = components.day;
//        NSInteger currentHours = components.hour;
        // 进行判断
        NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
      
        //今天
//        if (currentHours < 12) {
//            dateFmt.dateFormat = SLLocalizedString(@"上午 hh:mm");
//        }else{
//            dateFmt.dateFormat = SLLocalizedString(@"下午 hh:mm");
//        }
           dateFmt.dateFormat = @"HH:mm";
        
        // 返回处理后的结果
        return [dateFmt stringFromDate:currentDate];
    
}

+(NSString*)currentTimeSayHello{
    // 创建日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 获取当前时间
    NSDate *currentDate = [NSDate date];
    
    // 获取当前时间的年、月、日。利用日历
    NSDateComponents *components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    NSInteger currentHours = components.hour;
    
    NSString *helloStr;
    //今天
    if (currentHours < 12) {
        helloStr = SLLocalizedString(@"上午好");
    }else if(currentHours >= 12 && currentHours <= 14){
        helloStr = SLLocalizedString(@"中午好");
    }else{
        helloStr = SLLocalizedString(@"下午好");
    }
    
    // 返回处理后的结果
    return helloStr;
}

// 是否包含表情
+(BOOL)isContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar high = [substring characterAtIndex: 0];
        
        // Surrogate pair (U+1D000-1F9FF)
        if (0xD800 <= high && high <= 0xDBFF) {
            const unichar low = [substring characterAtIndex: 1];
            const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
            
            if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                returnValue = YES;
            }
            
            // Not surrogate pair (U+2100-27BF)
        } else {
            if (0x2100 <= high && high <= 0x27BF){
                returnValue = YES;
            }
        }
    }];
    
    return returnValue;
}

///只允许输入中英文
-(BOOL)onlyChineseAndEnglish{
    NSString *regular = [NSString stringWithFormat:@"[a-zA-Z\\u4E00-\\u9FA5]{%ld}", self.length];
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
    
    NSLog(@"[regextestmobile evaluateWithObject:self] : %d", [regextestmobile evaluateWithObject:self]);
    
    if(([regextestmobile evaluateWithObject:self] == YES)) {
        return YES;
    } else {
        return NO;
    }
}

///只允许输入数字
-(BOOL)onlyNumbers{
    NSString *regular = @"[\\u0030-\\u0039]";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
    if(([regextestmobile evaluateWithObject:self] == YES)) {
        return YES;
    } else {
        return NO;
    }
}

///只允许输入数字英文
-(BOOL)onlyNumbersAndEnglish{
    
    
    NSString *regular = [NSString stringWithFormat:@"[a-zA-Z\\u0030-\\u0039]{%ld}", self.length];
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
    
    if(([regextestmobile evaluateWithObject:self] == YES)) {
        return YES;
    } else {
        return NO;
    }
}

///输入中英文和数字
-(BOOL)ChineseAndEnglishAndNumber{
    NSString *regular = [NSString stringWithFormat:@"[a-zA-Z\\u4E00-\\u9FA5\\u0030-\\u0039]{%ld}", self.length];
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
    
    NSLog(@"[regextestmobile evaluateWithObject:self] : %d", [regextestmobile evaluateWithObject:self]);
    
    if(([regextestmobile evaluateWithObject:self] == YES)) {
        return YES;
    } else {
        return NO;
    }
}

///验证邮箱
-(BOOL)validationEmail{
    NSString *regular = @"^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
    if(([regextestmobile evaluateWithObject:self] == YES)) {
        return YES;
    } else {
        return NO;
    }
}

///验证密码复杂度
///必须包含大写字母，小写字母，数字，长度要求8到16位
-(BOOL)passwordComplexityVerification{
    NSString *regular = @"(?=.*[0-9])(?=.*[a-zA-Z]).{8,16}";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
    if(([regextestmobile evaluateWithObject:self] == YES)) {
        return YES;
    } else {
        return NO;
    }
}


@end
