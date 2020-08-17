//
//  NSString+Tool.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/26.
//  Copyright © 2020 syqaxldy. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Tool)

/**
 验证码手机号

 @param mobileNum 手机号
 @return YES 通过 NO 不通过
 */
+ (BOOL)validateContactNumber:(NSString *)mobileNum;
/**
 计算字符串高度或者宽度
 */
+(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize string:(NSString *)string;

/**
  时间转化成 时间戳
 */
+(NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format;

///时间戳变为格式时间
+ (NSString *)convertStrToTime:(NSInteger)time;

///隐藏手机号码中间的四位数字
+ (NSString *)numberSuitScanf:(NSString *)numberStr;
///当前时间 时间格式 00:13
+(NSString*)currentTime;

///当前时间 时间格式 00:13
+(NSString*)currentTimeSayHello;

///是否包含表情
+(BOOL)isContainsEmoji:(NSString *)string;

///只允许输入中英文
-(BOOL)onlyChineseAndEnglish;

///只允许输入数字
-(BOOL)onlyNumbers;

///只允许输入数字英文
-(BOOL)onlyNumbersAndEnglish;

///验证邮箱
-(BOOL)validationEmail;

///输入中英文和数字
-(BOOL)ChineseAndEnglishAndNumber;

///验证密码复杂度
///必须包含大写字母，小写字母，数字，特殊字符四种中的三种，长度要求8到16位
-(BOOL)passwordComplexityVerification;
@end

NS_ASSUME_NONNULL_END
