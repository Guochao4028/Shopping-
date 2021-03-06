//
//  DefinedKeys.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#ifndef DefinedKeys_h
#define DefinedKeys_h

///当有验证失败的内购订单时，就存在这里，找机会重新与后台验证
//#define IAPPayList \
//({\
//NSArray * applePayList = [[NSUserDefaults standardUserDefaults] objectForKey:@"applePayList"];\
//NSMutableArray * iapPayList = [NSMutableArray arrayWithArray:applePayList];\
//(iapPayList);\
//})

///环信key
//#define EMAppKey @"1133200611065275#shaolintemple"
#define EMAppKey @"1122200428010315#shaolin"
#define EMAppUrlKey @"1122200428010315/shaolin"

///设备屏幕的宽度
#define ScreenWidth [[UIScreen mainScreen]bounds].size.width
///设备屏幕的高度
#define ScreenHeight [[UIScreen mainScreen]bounds].size.height
///iPhone 6 的高
#define IPHONE6HEIGHT 667
///iPhone 6 的宽
#define IPHONE6WIDTH  375
///高度比
#define HEIGHTPROPROTION (ScreenHeight / IPHONE6HEIGHT)
///宽度比
#define WIDTHTPROPROTION (ScreenWidth / IPHONE6WIDTH)

//是否为空或是[NSNull null]
#define NotNilAndNull(_ref)  (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]))
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))


#define kIs_iPhoneX [[UIApplication sharedApplication] statusBarFrame].size.height>20
 
/*状态栏高度*/
#define kStatusBarHeight (kIs_iPhoneX?(44.0):(20.0))
/*导航栏高度*/
#define kNavBarHeight (44)

/*状态栏和导航栏总高度*/
#define kNavBarAndStatusBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?88:64)

/*顶部安全区域远离高度*/
#define kTopBarSafeHeight (kIs_iPhoneX?(44.0):(0))
/*底部安全区域远离高度*/
#define kBottomSafeHeight (kIs_iPhoneX?(34.0):(0))
/*iPhoneX的状态栏高度差值*/
#define kTopBarDifHeight (kIs_iPhoneX?(24.0):(0))
/*导航条和Tabbar总高度*/
#define kNavAndTabHeight (kNavBarAndStatusBarHeight + kTabBarHeight)
/*TabBar高度*/
#define TabbarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
//常规
#define RegularFont @"PingFangSC-Regular"
//中黑
#define MediumFont @"PingFangSC-Medium"

//背景颜色
#define BackgroundColor_White [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:0.99]

/** 16进制转RGB*/
#define HEX_COLOR(x_RGB) [UIColor colorWithRed:((float)((x_RGB & 0xFF0000) >> 16))/255.0 green:((float)((x_RGB & 0xFF00) >> 8))/255.0 blue:((float)(x_RGB & 0xFF))/255.0 alpha:1.0f]


//字体红色
#define WENGEN_RED [UIColor colorWithRed:142.0/255.0 green:43.0/255.0 blue:37.0/255.0 alpha:0.99]
//字体灰色
#define WENGEN_GREY [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:0.99]

//导航底线颜色
#define ColorNavSepGapLine [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:0.99]

//主windowsView
//#define WINDOWSVIEW [[UIApplication sharedApplication].windows lastObject]
#define WINDOWSVIEW [ModelTool lastWindow]

#define VERSION_ID [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] intValue]
#define VERSION_STR [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define BUILD_STR [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]


// 发现 - page切换的通知
#define KNotificationFoundPageChange @"FoundPageChange"
// 功夫 - page切换的通知
#define KNotificationKungfuPageChange @"KungfuPageChange"
// 活动 - page切换的通知
#define KNotificationActivityPageChange @"ActivityPageChange"
// 功夫 - 功夫详情播放视频
#define KNotificationClassVideoPlay @"ClassVideoPlay"
// 功夫 - page切换的通知
// 功夫 - 首页
//#define KNotificationKfPageChangeHome @"KungFuExaminationSelectHome"
//// 功夫 - 考试
//#define KNotificationKfPageChangeExam @"KungFuExaminationSelectExam"
//// 功夫 - 活动报名
//#define KNotificationKfPageChangeActivity @"KungFuExaminationSelectActivity"
//// 功夫 - 教程
//#define KNotificationKfPageChangeClass @"KungFuExaminationSelectClass"
//// 功夫 - 报名查询
//#define KNotificationKfPageChangeEnrollment @"KungFuExaminationSelectEnrollment"
//// 功夫 - 机构列表
//#define KNotificationKfPageChangeInstitution @"KungFuExaminationSelectInstitution"
//// 功夫 - 段品制介绍
//#define KNotificationKfInfo @"KNotificationKfInfo"


#define DATAS @"data"//数据
#define LIST @"list"
#define CODE @"code"
#define MSG @"msg"

#define MODELTOOL_CHECKRESPONSEOBJECT_DELETEUSER   @"MODELTOOL_CHECKRESPONSEOBJECT_DELETEUSER"

#define  ORDERDETAILSHEARDVIEW_TIMECHANGE_ENDTIME @"OrderDetailsHeardView_timeChange_endTime"

#define WENGENMANAGER_GETORDERANDCARTCOUNT  @"WengenManager_getOrderAndCartCount"

#define keyBoardDefaultHeight 225 //自定义键盘的高度



//查看视频首帧图片
//#define Video_First_Photo  @"?x-oss-process=video/snapshot,t_3000,m_fast,ar_auto"


//秘钥(用于AES加密)(弃用)
#define ENCRYPTION_AES_KEY      @"E9iV7M4buSPyYRFc"

//秘钥(用于MD5加密)
#define ENCRYPTION_MD5_KEY      @"Vg*2m5nI2y9yajVd"

//秘钥(用于AES加密) 控制密钥
#define VERSIONKEY @"v1"

//秘钥->公钥(用于RSA加密)
#define ENCRYPTION_RSA_KEY  @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAj0F3NLM2Tw1R7mvP7dIstPaj4hn7k0xOR/Hx6wZk5MwGfGvvt0Fhk7tbDxW6ON2mYAg6+mqDXO3j4y7Yq+XJcSakjtYqUIuix5sZHvcO/MxwCqJYfmInkrIeTtMFyv6UZjQHuCUkjfpiy+4HRMp7n6ya2h7/1PKewDSoB7IMulyO23dOxrU/ZyDlBn7w4mW4RG/zz+l7HclmRu1iAOtcUKaBLmw1R0EXtMn/tDXO1cHHFnTtDFdkmoXX6PdPJ7QMg3gzwKktE7olqwo+atUSKjAEibVg2HC6/RnzDRaOzEWh1gamtFoJ4/e4i63H1CLDHFkwIytOpUV8pCPd8ZAaIQIDAQAB"

#endif /* DefinedKeys_h */
