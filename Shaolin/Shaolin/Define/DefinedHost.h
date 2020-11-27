//
//  DefinedHost.h
//  Shaolin
//
//  Created by ws on 2020/6/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#ifndef DefinedHost_h
#define DefinedHost_h

// 是否是生产上线环境
//#define IsAppStore YES

// 是否是预发布环境
//#define IsPre YES

// 是否是开发环境，注释掉为演示测试环境
//#define IsDevelop YES

#ifdef IsAppStore

#define Host @"https://api.shaolinapp.com"
#define H5Host @"https://h5.shaolinapp.com/#"

// IAP内购验证，是否是正式
#define IapCheckEnv YES

#else

#ifdef IsPre

#define Host @"https://api-pre.shaolinapp.com"
#define H5Host @"https://h5-pre.shaolinapp.com/#"
#define IapCheckEnv NO

#else

#ifdef IsDevelop

#define Host @"http://php.shaolin.gaoshier.cn"
#define H5Host @"http://shaolin-app.gaoshier.cn/#"
#define IapCheckEnv NO

#else

//#define Host  @"http://192.168.31.123:8080"
#define Host  @"http://test.php.shaolin.gaoshier.cn"
#define H5Host @"http://test.shaolin-app.gaoshier.cn/#"
#define IapCheckEnv NO

#endif
#endif
#endif

#define Found  Host


#define ADD(x) [NSString stringWithFormat:@"%@%@",Host,(x)]
#define MKURL(baseUrl,x)  [NSString stringWithFormat:@"%@%@", (baseUrl),(x)]


/******************************** html界面 *******************************/

///注册协议
#define URL_H5_RegisterUrl [NSString stringWithFormat:@"%@/register",H5Host]

///隐私协议
#define URL_H5_PrivacyPolicyUrl [NSString stringWithFormat:@"%@/privacyPolicy",H5Host]

/*
    文章详情
    articleDetail?id=123
 */
#define URL_H5_ArticleDetail(a,b) [NSString stringWithFormat:@"%@/articleDetail?id=%@&token=%@",H5Host,a,b]

/*
    活动模块-活动详情
    activityDetail?id=123
*/
#define URL_H5_ActivityDetail(a,b) [NSString stringWithFormat:@"%@/activityDetail?id=%@&token=%@",H5Host,a,b]

/*
    文章详情分享链接
    shareFindDetail??id=123
 */
#define URL_H5_SharedArticleDetail(a) [NSString stringWithFormat:@"%@/shareFindDetail?id=%@",H5Host,a]
/*
    活动详情分享链接
    shareActivity??id=123
 */
#define URL_H5_SharedArticle(a) [NSString stringWithFormat:@"%@/shareActivity?id=%@",H5Host,a]

/*
    视频分享链接
    shareActivity??id=123
 */
#define URL_H5_SharedVideo(videoid,type) [NSString stringWithFormat:@"%@/video?id=%@&type=%@",H5Host,videoid, type]

/*
    活动模块-活动详情
    activityDetail?id=123
*/
#define URL_H5_SharedActivityDetail(a) [NSString stringWithFormat:@"%@/activityDetail?id=%@",H5Host,a]

/*
    我的模块-我的活动
    扫码签到失败
 */
#define URL_H5_MyActivityScanQRCodeError [NSString stringWithFormat:@"%@/activityRegistration?error=0", H5Host]
/*
 法会活动祝福语分享链接
 */
#define URL_H5_SharedRiteBlessing(a) [NSString stringWithFormat:@"%@/blessing?id=%@", H5Host, a]
/*
    店铺详情页证照信息
    shopInfo?id=123&token=789
*/
#define URL_H5_ShopInfo(a,b) [NSString stringWithFormat:@"%@/shopInfo?id=%@&token=%@",H5Host,a,b]

// 帮助中心
#define URL_H5_Help(a) [NSString stringWithFormat:@"%@/helpCenter?token=%@",H5Host,a]

// 发票详情
#define URL_H5_InvoiceDetail(a,b) [NSString stringWithFormat:@"%@/invoiceDetail?order_id=%@&token=%@",H5Host,a,b]

// 申请开具增值税专用发票确认书
#define URL_H5_InvoiceConfirmation H5Host@"/invoiceConfirmation"


//邀请好友
#define URL_H5_Invitation H5Host@"/invitation"

/*
    物流信息
    orderTrack?orderId=20201015398961194&token=
*/
#define URL_H5_OrderTrack(a,b) [NSString stringWithFormat:@"%@/orderTrack?orderId=%@&token=%@",H5Host,a,b]

/*
 证书物流
 */
#define URL_H5_CertificateTrack(a,b) [NSString stringWithFormat:@"%@/certificateTrack?id=%@&token=%@",H5Host,a,b]

/*
    考试通知
    notice?token=789
 */
#define URL_H5_ExamNotice(a) [NSString stringWithFormat:@"%@/notice?token=%@",H5Host,a]

/*
    功夫模块-活动详情
    eventRegistration?activityCode=2005111400012585&token=789
 */
#define URL_H5_EventRegistration(a,b) [NSString stringWithFormat:@"%@/eventRegistration?activityCode=%@&token=%@",H5Host,a,b]

/*
    机构详情
    mechanismDetail?mechanismCode=2005141855012661&token=789
 */
#define URL_H5_MechanismDetail(a,b) [NSString stringWithFormat:@"%@/mechanismDetail?mechanismCode=%@&token=%@",H5Host,a,b]

// 段品制介绍
#define URL_H5_Introduce H5Host@"/introduce"
/*
    报名详情
    signupDetail?accuratenumber=2005141518012533&token=
 */
#define URL_H5_SignupDetail(a,b) [NSString stringWithFormat:@"%@/signupDetail?accuratenumber=%@&token=%@",H5Host,a,b]

/*
    商品规格
    parameter?goodsId=8
 */
#define URL_H5_Parameter(a,b) [NSString stringWithFormat:@"%@/parameter?goodsId=%@&token=%@",H5Host,a,b]


//建寺
//#define URL_H5_RiteBuild(pujaType, pujaCode, token) [NSString stringWithFormat:@"%@/buildingTemples?pujaType=%@&pujaCode=%@&token=%@",H5Host,pujaType,pujaCode,token]

//法会详情
#define URL_H5_RiteDetail(pujaCode, token) [NSString stringWithFormat:@"%@/lawSocietDetail?code=%@&token=%@",H5Host,pujaCode,token]
//法会三级页详情
#define URL_H5_RiteThreeDetail(pujaType, pujaCode, buddhismTypeId, token) [NSString stringWithFormat:@"%@/buddhismTypeIdFindDetail?type=%@&code=%@&id=%@&token=%@",H5Host, pujaType, pujaCode, buddhismTypeId, token]
//本期回顾
#define URL_H5_RiteDetailFinished(pujaCode, token) [NSString stringWithFormat:@"%@/oldLawSocietDetail?code=%@&token=%@",H5Host,pujaCode,token]

#endif /* DefinedHost_h */
