//
//  NSString+Tool.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/26.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "NSString+Tool.h"

#import "NSData+AES256.h"

#import <CommonCrypto/CommonCrypto.h>
#import "NSString+LGFEncodeDecode.h"
#import "NSDictionary+LGFToJSONString.h"

#define gIv             @"0102030405060708"


@implementation NSString (Tool)

static NSString *base64_encode_data(NSData *data){
    data = [data base64EncodedDataWithOptions:0];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

static NSData *base64_decode(NSString *str){
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}

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

/**
 时间 转化成 时间
 2020-09-29 10:27:48 => 2020-09-29
 */
+(NSString *)timeStrIntoTimeWithString:(NSString *)formatTime andFormatter:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    //----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSDate* date = [formatter dateFromString:formatTime];
    //------------将字符串按formatter转成nsdate
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//    fmt.dateFormat = @"yyyy-MM-dd";   //创建日期格式（年-月-日）
    fmt.dateFormat = format;
    NSString *temp = [fmt stringFromDate:date];
    
    return temp;
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
    NSDateComponents *components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:currentDate];
    NSInteger currentHours = components.hour;
    
    NSString *helloStr;
    //今天
    if (currentHours < 12) {
        helloStr = SLLocalizedString(@"上午好");
    }else if(currentHours >= 12 && currentHours < 14){
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
    NSString *other = @"➋➌➍➎➏➐➑➒";     //九宫格的输入值
    if ([other rangeOfString:string].location != NSNotFound){
        return  NO;
    }
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
        }else {
            
            if (0x2100 <= high && high <= 0x27FF){
                
                //判断 char 是否是9宫格 ➋➌➍➎➏➐➑➒
                if (0x278b <= high && high <= 0x2792) {
                    returnValue = NO;
                }else{
                    returnValue = YES;
                }
            }
            
        }
    }];
    
    
    
    
    return returnValue;
}

///只允许输入中英文
- (BOOL)onlyChineseAndEnglish{
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
- (BOOL)onlyNumbers{
    NSString *regular = @"[\\u0030-\\u0039]";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
    if(([regextestmobile evaluateWithObject:self] == YES)) {
        return YES;
    } else {
        return NO;
    }
}

///只允许输入数字英文
- (BOOL)onlyNumbersAndEnglish{
    
    
    NSString *regular = [NSString stringWithFormat:@"[a-zA-Z\\u0030-\\u0039]{%ld}", self.length];
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
    
    if(([regextestmobile evaluateWithObject:self] == YES)) {
        return YES;
    } else {
        return NO;
    }
}

///输入中英文和数字
- (BOOL)ChineseAndEnglishAndNumber{
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
- (BOOL)validationEmail{
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
- (BOOL)passwordComplexityVerification{
    NSString *regular = @"(?=.*[0-9])(?=.*[a-zA-Z]).{8,16}";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
    if(([regextestmobile evaluateWithObject:self] == YES)) {
        return YES;
    } else {
        return NO;
    }
}


///保留首尾字符，中间全部变为星号
- (NSString *)replaceStringWithAsterisk:(NSInteger)frontNum endNum:(NSInteger)endNum{
    
    NSString *replaceStr = self;
    
    NSInteger len = replaceStr.length;
    
    if (frontNum >= len || frontNum < 0 || endNum >= len || endNum < 0)return self;
    
    if (endNum >= len)return self;
    
    if (replaceStr.length == 1 || replaceStr.length == 2)return @"*";
    
    
    
    
    NSInteger beginIndex = frontNum;
    NSInteger endIndex = endNum;
    for (NSInteger i = beginIndex; i < endIndex; i++) {
        NSRange range = NSMakeRange(beginIndex, 1);
        replaceStr = [replaceStr stringByReplacingCharactersInRange:range withString:@"*"];
        beginIndex ++;
    }
    
    return replaceStr;
    
}


- (NSAttributedString *)moneyStringWithFormatting:(MoneyStringFormattingType)type{
    
    NSArray *fontArray;
    
    if (type == MoneyStringFormattingMoneyCoincidenceType) {
        
        fontArray = @[kMediumFont(12), kMediumFont(16)];
    }else if (type == MoneyStringFormattingMoneyAllFormattingType){
        
        
        fontArray = @[kMediumFont(12), kMediumFont(16), kMediumFont(13)];
    }
    
    return [self moneyStringWithFormatting:type fontArrat:fontArray];
}

///格式化价格
-(NSString *)formattingPriceString{
    NSString *replaceStr = self;
    NSString *firstCharacter = [replaceStr substringToIndex:1];
    
    if (![firstCharacter isEqualToString:@"¥"]) {
        replaceStr =[NSString stringWithFormat:@"¥%@",replaceStr];
    }
    NSRange range = [replaceStr rangeOfString:@"."];
    if (range.location == NSNotFound) {
        replaceStr =[NSString stringWithFormat:@"%@.00",replaceStr];
    }
    
    if (range.location != NSNotFound) {
        NSString *subString = [replaceStr substringFromIndex:range.location + 1];
        if([subString length] < 2){
            replaceStr =[NSString stringWithFormat:@"%@0",replaceStr];
        }
        
    }
    NSString *temPrice = [replaceStr substringFromIndex:1];
    replaceStr = [NSString stringWithFormat:@"¥%@",[temPrice formattedPrice]];
    
    return replaceStr;
}

- (NSAttributedString *)moneyStringWithFormatting:(MoneyStringFormattingType)type fontArrat:(NSArray <UIFont *>*)fontArray{
    NSString *replaceStr = self;
    
    NSString *firstCharacter = [replaceStr substringToIndex:1];
    
    if (![firstCharacter isEqualToString:@"¥"]) {
        replaceStr =[NSString stringWithFormat:@"¥%@",replaceStr];
    }
    NSRange range = [replaceStr rangeOfString:@"."];
    if (range.location == NSNotFound) {
        replaceStr =[NSString stringWithFormat:@"%@.00",replaceStr];
    }
    
    if (range.location != NSNotFound) {
        NSString *subString = [replaceStr substringFromIndex:range.location + 1];
        if([subString length] < 2){
            replaceStr =[NSString stringWithFormat:@"%@0",replaceStr];
        }
        
    }
    NSString *temPrice = [replaceStr substringFromIndex:1];
    replaceStr = [NSString stringWithFormat:@"¥%@",[temPrice formattedPrice]];
    
    
    range = [replaceStr rangeOfString:@"."];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:replaceStr];
    
    if (type == MoneyStringFormattingMoneyCoincidenceType) {
        [attrStr addAttribute:NSFontAttributeName value:[fontArray firstObject] range:NSMakeRange(0, 1)];
        
        [attrStr addAttribute:NSFontAttributeName value:[fontArray lastObject] range:NSMakeRange(1, replaceStr.length -1)];
        
    }else if (type == MoneyStringFormattingMoneyAllFormattingType){
        if ([fontArray count] == 3) {
            [attrStr addAttribute:NSFontAttributeName value:[fontArray firstObject] range:NSMakeRange(0, 1)];
            
            [attrStr addAttribute:NSFontAttributeName value:[fontArray objectAtIndex:1]  range:NSMakeRange(1, range.location-1)];
            [attrStr addAttribute:NSFontAttributeName value:[fontArray lastObject]  range:NSMakeRange(range.location, 3)];
        }else{
            return attrStr;
        }
        
    }
    
    return attrStr;
}

/// 加密
- (NSString *)aes256_encrypt:(NSString *)key{
    
    //    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    //    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    //    //对数据进行加密
    //    NSData *result = [data aes256_encrypt:key];
    //
    //    //转换为2进制字符串
    //    if (result && result.length > 0) {
    //
    //        Byte *datas = (Byte*)[result bytes];
    //        NSMutableString *output = [NSMutableString stringWithCapacity:result.length * 2];
    //        for(int i = 0; i < result.length; i++){
    //            [output appendFormat:@"%02x", datas[i]];
    //        }
    //
    //
    //        return  output;
    //    }
    //    return nil;
    
    char keyPtr[kCCKeySizeAES128+1];
    
    memset(keyPtr, 0, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128+1];
    
    memset(ivPtr, 0, sizeof(ivPtr));
    
    [gIv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    NSUInteger diff = kCCKeySizeAES128 - (dataLength % kCCKeySizeAES128);
    
    NSUInteger newSize = 0;
    
    if(diff > 0){
        newSize = dataLength + diff;
    }
    char dataPtr[newSize];
    
    memcpy(dataPtr, [data bytes], [data length]);
    
    for(int i = 0; i < diff; i++){
        dataPtr[i + dataLength] = 0x00;
    }
    size_t bufferSize = newSize + kCCBlockSizeAES128;
    
    void *buffer = malloc(bufferSize);
    
    memset(buffer, 0, bufferSize);
    
    size_t numBytesCrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          
                                          kCCAlgorithmAES128,
                                          
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,  // 补码方式
                                          
                                          keyPtr,
                                          
                                          kCCKeySizeAES128,
                                          
                                          ivPtr,
                                          
                                          dataPtr,
                                          
                                          sizeof(dataPtr),
                                          
                                          buffer,
                                          
                                          bufferSize,
                                          
                                          &numBytesCrypted);
    
    
    
    if (cryptStatus == kCCSuccess) {
        
        NSData *result = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        
        if (result && result.length > 0) {
            
            
            
            Byte *datas = (Byte*)[result bytes];
            
            NSMutableString *output = [NSMutableString stringWithCapacity:result.length * 2];
            
            for(int i = 0; i < result.length; i++){
                
                [output appendFormat:@"%02x", datas[i]];
                
            }
            
            return output;
            
        }
        
    }
    
    free(buffer);
    
    return nil;
    
}

/// 解密
- (NSString *)aes256_decrypt:(NSString *)key{
    
    //    //转换为2进制Data
    //    NSMutableData *data = [NSMutableData dataWithCapacity:self.length / 2];
    //    unsigned char whole_byte;
    //    char byte_chars[3] = {'\0','\0','\0'};
    //    int i;
    //    for (i=0; i < [self length] / 2; i++) {
    //        byte_chars[0] = [self characterAtIndex:i*2];
    //        byte_chars[1] = [self characterAtIndex:i*2+1];
    //        whole_byte = strtol(byte_chars, NULL, 16);
    //        [data appendBytes:&whole_byte length:1];
    //    }
    //
    //    //对数据进行解密
    //    NSData* result = [data aes256_decrypt:key];
    //    if (result && result.length > 0) {
    //
    //        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    //    }
    //    return nil;
    
    char keyPtr[kCCKeySizeAES128 + 1];
    
    memset(keyPtr, 0, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    
    
    char ivPtr[kCCBlockSizeAES128 + 1];
    
    memset(ivPtr, 0, sizeof(ivPtr));
    
    [gIv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    
    
    NSMutableData *data = [NSMutableData dataWithCapacity:self.length / 2];
    
    unsigned char whole_byte;
    
    char byte_chars[3] = {'\0','\0','\0'};
    
    int i;
    
    for (i=0; i < [self length] / 2; i++) {
        
        byte_chars[0] = [self characterAtIndex:i*2];
        
        byte_chars[1] = [self characterAtIndex:i*2+1];
        
        whole_byte = strtol(byte_chars, NULL, 16);
        
        [data appendBytes:&whole_byte length:1];
        
    }
    
    
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    
    void *buffer = malloc(bufferSize);
    
    
    
    size_t numBytesCrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          
                                          kCCAlgorithmAES128,
                                          
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          
                                          keyPtr,
                                          
                                          kCCBlockSizeAES128,
                                          
                                          ivPtr,
                                          
                                          [data bytes],
                                          
                                          dataLength,
                                          
                                          buffer,
                                          
                                          bufferSize,
                                          
                                          &numBytesCrypted);
    
    if (cryptStatus == kCCSuccess) {
        
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        
        return [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        
    }
    
    free(buffer);
    
    return nil;
    
    
}


///数据加密
+(NSDictionary *)dataEncryption:(NSDictionary *)packetDic{
    
    NSString *encryptionAESKey;
    
    if ([VERSIONKEY isEqualToString:@"v1"]) {
        encryptionAESKey = @"E9iV7M4buSPyYRFc";
    }else if ([VERSIONKEY isEqualToString:@"v2"]) {
        encryptionAESKey = @"QfwBdnQY9RRpHw8f";
    }else if ([VERSIONKEY isEqualToString:@"v3"]) {
        encryptionAESKey = @"6rtvbp6a1guEoCSo";
    }else{
        encryptionAESKey = @"hcvZ9gPDqhcnytEF";
    }
    
    NSString *josnStr = [packetDic lgf_DictionaryToJson];
    
    NSString *encryptStr = [josnStr aes256_encrypt:encryptionAESKey];
    
    //    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:packetDic];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:encryptStr forKey:@"aesEncryption"];
    return param;
}


///精度格式化价格
-(NSString *)formattedPrice{
    NSNumber *moneyNumber = [NSNumber numberWithDouble:[self doubleValue]];
    if (!moneyNumber) moneyNumber = @(0);
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    //    formatter.positiveFormat = @",###.##"; // 正数格式
    // 整数最少位数
    formatter.minimumIntegerDigits = 1;
    // 小数位最多位数
    formatter.maximumFractionDigits = 2;
    // 小数位最少位数
    formatter.minimumFractionDigits = 2;
    
    // 注意传入参数的数据长度，可用double
    return [formatter stringFromNumber:moneyNumber];
}




/**
 * -------RSA 字符串公钥加密-------
 @param plainDic 明文，待加密的数据字典
 @param pubKey 公钥字符串
 @return 密文，加密后的字符串
 */

+ (NSDictionary *)encryptRSA:(NSDictionary *)plainDic{
    if ([plainDic.allKeys count] == 0) {
        return nil;
    }
    
    NSMutableDictionary *tempPlainDic = [NSMutableDictionary dictionaryWithDictionary:plainDic];
    
    [tempPlainDic setValue:@{@"timestamp": [self getNowTimeTimestamp]} forKey:@"commonData"];
    
    
//    NSString *josnStr = [plainDic lgf_DictionaryToJson];
    NSString *josnStr = [tempPlainDic lgf_DictionaryToJson];

    NSData *data = [self encryptData:[josnStr dataUsingEncoding:NSUTF8StringEncoding] publicKey:ENCRYPTION_RSA_KEY];
    NSString *ret = base64_encode_data(data);
//    return ret;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:ret forKey:@"rsaEncryption"];
    return param;
}

+ (NSData *)encryptData:(NSData *)data publicKey:(NSString *)pubKey{
    if(!data || !pubKey){
        return nil;
    }
    SecKeyRef keyRef = [self addPublicKey:pubKey];
    NSData *enData = [self encryptData:data withKeyRef:keyRef];
    if (keyRef) CFRelease(keyRef);
    
    return enData;
}

+ (SecKeyRef)addPublicKey:(NSString *)key{
    NSRange spos = [key rangeOfString:@"-----BEGIN PUBLIC KEY-----"];
    NSRange epos = [key rangeOfString:@"-----END PUBLIC KEY-----"];
    if(spos.location != NSNotFound && epos.location != NSNotFound){
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        key = [key substringWithRange:range];
    }
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];
    
    // This will be base64 encoded, decode it.
    NSData *data = base64_decode(key);
    data = [self stripPublicKeyHeader:data];
    if(!data){
        return nil;
    }
    
    //a tag to read/write keychain storage
    NSString *tag = @"RSAUtil_PubKey";
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    
    // Delete any old lingering key with the same tag
    NSMutableDictionary *publicKey = [[NSMutableDictionary alloc] init];
    [publicKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [publicKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)publicKey);
    
    // Add persistent version of the key to system keychain
    [publicKey setObject:data forKey:(__bridge id)kSecValueData];
    [publicKey setObject:(__bridge id) kSecAttrKeyClassPublic forKey:(__bridge id)
     kSecAttrKeyClass];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
     kSecReturnPersistentRef];
    
    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)publicKey, &persistKey);
    if (persistKey != nil){
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }
    
    [publicKey removeObjectForKey:(__bridge id)kSecValueData];
    [publicKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)publicKey, (CFTypeRef *)&keyRef);
    if(status != noErr){
        return nil;
    }
    return keyRef;
}

+ (NSData *)stripPublicKeyHeader:(NSData *)d_key{
    // Skip ASN.1 public key header
    if (d_key == nil) return(nil);
    
    unsigned long len = [d_key length];
    if (!len) return(nil);
    
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx     = 0;
    
    if (c_key[idx++] != 0x30) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    // PKCS #1 rsaEncryption szOID_RSA_RSA
    static unsigned char seqiod[] =
    { 0x30,   0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,
        0x01, 0x05, 0x00 };
    if (memcmp(&c_key[idx], seqiod, 15)) return(nil);
    
    idx += 15;
    
    if (c_key[idx++] != 0x03) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    if (c_key[idx++] != '\0') return(nil);
    
    return ([NSData dataWithBytes:&c_key[idx] length:len - idx]);
}

+ (NSData *)encryptData:(NSData *)data withKeyRef:(SecKeyRef)keyRef{
    if(!keyRef){
        return nil;
    }
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    void *outbuf = malloc(block_size);
    size_t src_block_size = block_size - 11;
    
    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size){
        //NSLog(@"%d/%d block_size: %d", idx, (int)srclen, (int)block_size);
        size_t data_len = srclen - idx;
        if(data_len > src_block_size){
            data_len = src_block_size;
        }
        
        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyEncrypt(keyRef,
                               kSecPaddingPKCS1,
                               srcbuf + idx,
                               data_len,
                               outbuf,
                               &outlen
                               );
        if (status != 0) {
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", (int)status);
            ret = nil;
            break;
        }else{
            [ret appendBytes:outbuf length:outlen];
        }
    }
    
    free(outbuf);
    return ret;
}

//获取当前时间戳方法(以毫秒为单位)
+ (NSString *)getNowTimeTimestamp{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;

    [formatter setDateStyle:NSDateFormatterMediumStyle];

    [formatter setTimeStyle:NSDateFormatterShortStyle];

    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制

    //设置时区,这个对于时间的处理有时很重要

    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];

    [formatter setTimeZone:timeZone];

    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式

    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970] *1000];

    return timeSp;

}






@end
