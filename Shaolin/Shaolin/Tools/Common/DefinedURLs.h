//
//  DefinedURLs.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/17.
//  Copyright © 2020 syqaxldy. All rights reserved.
//  url文件，所有的url都在里面

#ifndef DefinedURLs_h
#define DefinedURLs_h




/********************************文创商城*******************************/
//商品全部分类
#define URL_POST_SHOPAPI_COMMON_GOODS_CATE_GETALLGOODSCATELIST @"/shopapi/common/goods_cate/getAllGoodsCateList"

// 首页 banner
#define URL_POST_BANNERURL @"/bannerurlApp/bannerurlApp/banner"

//商品一/二级分类列表
#define URL_POST_SHOPAPI_COMMON_GOODS_CATE_GETGOODSCATELIST  @"/shopapi/common/goods_cate/getGoodsCateList"

//新人推荐商品
#define  URL_POST_SHOPAPI_COMMON_GOODS_GETNEW @"/shopapi/common/goods/getNew"

//首页 严选商品
#define URL_POST_SHOPAPI_COMMON_GOODS_GETDELICATE @"/shopapi/common/goods/getDelicate"

//商品列表
#define URL_POST_SHOPAPI_COMMON_GOODS_GETGOODSLIST @"/shopapi/common/goods/getGoodsList"

//商品详情
#define URL_POST_SHOPAPI_COMMON_GOODS_GETGOODSINFO @"/shopapi/common/goods/getGoodsInfo"


//检查商品库存
#define URL_POST_SHOPAPI_COMMON_GOODS_CHECKSTOCK @"/shopapi/common/goods/checkStock"

/********************************店铺*******************************/
//店铺信息
#define URL_POST_SHOPAPI_COMMON_CLUB_GETCLUBINFO @"/shopapi/common/club/getClubInfo"

//查看店铺证照信息
#define URL_POST_SHOPAPI_COMMON_CLUB_GETBUSINESS @"/shopapi/common/club/getBusiness"


//店铺取消收藏
#define URL_POST_SHOPAPI_COMMON_COLLECT_CANCELCOLLECT @"/shopapi/common/collect/cancelCollect"


//店铺添加收藏
#define URL_POST_SHOPAPI_COMMON_COLLECT_ADDCOLLECT @"/shopapi/common/collect/addCollect"

//收藏店铺列表
#define URL_POST_SHOPAPI_COMMON_COLLECT_MYCOLLECT @"/shopapi/common/collect/myCollect"


/*********************************收货地址********************************************/

//收货地址列表
#define URL_POST_SHOPAPI_COMMON_ADDRESS_ADDRESSLIST @"/shopapi/common/address/addressList"

//收货地址文件
#define URL_GET_AREA_LIST_TXT @"/area_list.txt"

//添加收货地址
#define URL_POST_SHOPAPI_COMMON_ADDRESS_ADDADDRESS @"/shopapi/common/address/addAddress"

//计算商品运费
#define URL_POST_SHOPAPI_COMMON_ORDER_COMPUTEGOODSFEE @"/shopapi/common/order/computeGoodsFee"

//计算商品运费
#define URL_POST_SHOPAPI_COMMON_ORDER_COMPUTEGOODSFEE @"/shopapi/common/order/computeGoodsFee"

//修改收货地址
#define URL_POST_SHOPAPI_COMMON_ADDRESS_EDITADDRESS @"/shopapi/common/address/editAddress"

//删除收货地址
#define URL_POST_SHOPAPI_COMMON_ADDRESS_DELADDRESS @"/shopapi/common/address/delAddress"

//收货地址详情
#define URL_POST_SHOPAPI_COMMON_ADDRESS_GETADDRESSINFO @"/shopapi/common/address/getAddressInfo"

//添加购物车
#define URL_POST_SHOPAPI_COMMON_GOODS_CAR_ADDCAR @"/shopapi/common/goods_car/addCar"

/*********************************购物车********************************************/

//购物车列表
#define URL_POST_SHOPAPI_COMMON_GOODS_CAR_CARLIST @"/shopapi/common/goods_car/CarList"

//删除购物车
#define URL_POST_SHOPAPI_COMMON_GOODS_CAR_DELCAR @"/shopapi/common/goods_car/delCar"

//购物车添加商品数量
#define URL_POST_SHOPAPI_COMMON_GOODS_CAR_INCRCARNUM @"/shopapi/common/goods_car/incrCarNum"

//购物车减少商品数量
#define URL_POST_SHOPAPI_COMMON_GOODS_CAR_DECRCARNUM @"/shopapi/common/goods_car/decrCarNum"

//购物车修改规格
#define URL_POST_SHOPAPI_COMMON_GOODS_CAR_CHANGEGOODSATTR @"/shopapi/common/goods_car/changeGoodsAttr"

/********************************订单****************************************/

//生成订单
#define URL_POST_SHOPAPI_COMMON_ORDER_CREATODER @"/shopapi/common/order/CreatOrder"

//我的订单
#define URL_POST_SHOPAPI_COMMON_ORDER_USERORDERLIST @"/shopapi/common/order/UserOrderList"

#define URL_POST_SHOPAPI_COMMON_ORDER_USERORDERLIST_NEW @"/shopapi/common/order/UserOrderListNew"

//订单统计
#define URL_POST_SHOPAPI_COMMON_ORDER_GETCOUNT @"/shopapi/common/order/getCount"

//删除订单
#define URL_POST_SHOPAPI_COMMON_ORDER_DELORDER @"/shopapi/common/order/delOrder"

//订单详情
#define URL_POST_SHOPAPI_COMMON_ORDER_ORDERINFO @"/shopapi/common/order/OrderInfo"


#define URL_POST_SHOPAPI_COMMON_ORDER_ORDERINFONEW @"/shopapi/common/order/OrderInfoNew"


//确认订单
#define URL_POST_SHOPAPI_COMMON_ORDER_CONFIRMRECEIPT @"/shopapi/common/order/confirmReceipt"

//评论订单
#define URL_POST_SHOPAPI_COMMON_EVALUATE_ADDEVALUATE @"/shopapi/common/evaluate/addEvaluate"

//取消订单
#define URL_POST_SHOPAPI_COMMON_ORDER_CANCELORDER @"/shopapi/common/order/CancelOrder"

//订单申请售后
#define URL_POST_SHOPAPI_COMMON_REFUND_ADDREFUND @"/shopapi/common/refund/addRefund"


//订单取消售后
#define URL_POST_SHOPAPI_COMMON_REFUND_CANNELREFUND @"/shopapi/common/refund/cannelRefund"

//售后申请详情
#define URL_POST_SHOPAPI_COMMON_REFUND_GETREFUNINFO @"/shopapi/common/refund/getRefundInfo"
//申请售后发货
#define URL_POST_SHOPAPI_COMMON_REFUND_SENDREFUNDGOODS @"/shopapi/common/refund/sendRefundGoods"

//删除售后
#define  URL_POST_SHOPAPI_COMMON_ORDER_DELREFUNDORDER @"/shopapi/common/order/delRefundOrder"

//用户资质信息
#define URL_POST_SHOPAPI_COMMON_INVOICE_USERQUALIFICATIONS @"/shopapi/common/invoice/userQualifications"


//添加用户资质信息
#define URL_POST_SHOPAPI_COMMON_INVOICE_ADDQUALIFICATIONS @"/shopapi/common/invoice/addQualifications"

//申请开发票
#define URL_POST_SHOPAPI_COMMON_INVOICE_INVOICING @"/shopapi/common/Invoice/Invoicing"

//ahq 列表
#define URL_POST_SHOPAPI_COMMON_AHP_GETAHQLIST @"/shopapi/common/ahq/getAhqList"
//猜你想问
#define URL_POST_SHOPAPI_COMMON_AHP_GUESSLIST @"/shopapi/common/ahq/guessList"



/*********************************支付********************************************/
//支付密码校验
#define  URL_POST_USER_PAYPASSWORDCHECK @"/user/payPasswordCheck"
//获取余额
#define  URL_POST_USER_BALANCE @"/user/balance"
//设置支付密码
#define  URL_POST_USER_PAYPASSWORDSETTING @"/user/payPasswordSetting"
//修改支付密码
#define  URL_POST_USER_PAYPASSWORDMODIFY @"/user/payPasswordModify"
//支付
#define  URL_POST_USER_PAY_ORDERPAY @"/pay/orderPay"
//忘记支付密码-验证码校验
#define  URL_GET_USER_PAY_CODECHECK @"/common/codeCheck"
//忘记支付密码-设置支付密码
#define  URL_GET_USER_PAY_PASSWORDFORGET @"/user/payPasswordForget"

//活动编号查询是否有符合该段位且该机构的考试凭证
#define  URL_GET_USER_PAY_CHECKPROOF @"/pay/CheckProof"


/*********************************登录模块********************************************/
#define URL_GET_REFRESHTOKEN @"/login/refreshToken" //刷新用户token
#define URL_POST_USER_LOGIN @"/login/passwordLogin" //登录
#define URL_POST_USER_CODELOGIN @"/login/CodeLogin" //验证码登录

#define URL_POST_USER_LOGIN_OTHER @"/login/other" // 第三方授权登录
#define URL_POST_USER_LOGIN_OTHERBINDLIST @"/login/otherBindList" //第三方授权列表
#define URL_POST_USER_LOGIN_OTHERBIND @"/login/otherBind" // 已登录账号绑定第三方
#define URL_POST_USER_LOGIN_OTHERCABCELBIND @"/login/otherBindCancel" // 已登录账号解除第三方绑定

#define URL_POST_USER_Register @"/login/register"//注册
#define URL_POST_USER_PhoneCheck @"/login/phoneCheck" //验证手机号是否被注册
/*********************************所有验证码********************************************/
#define URL_POST_ALL_CODE @"/common/phoneVerifyCode" //获取验证码
#define URL_POST_CHECK_CODE @"/common/AppCodeCheck" //校验验证码是否正确

#define URL_GET_AD @"/openScreenApp/get" //开屏广告
/*********************************发现模块********************************************/
#define URL_GET_HomeSegment @"/findApp/fieldApp/field" //分段标签
#define URL_GET_HomeList @"/findApp/newsinformationApp/newsinformation" //发现列表接口
#define Video_First_Photo  @"?x-oss-process=video/snapshot,t_3000,m_fast" //视频首帧
#define Found_Video_List @"/findApp/newsinformationApp/newsinformation/video" //发现的视频列表
#define Found_POST_Photo @"/common/uploadImage"//上传图片
#define Found_POST_WebNewsInforMation @"/findApp/newsinformationApp/newsinformation"//发布文章

#define Found_POST_TextContentCheck @"/shareApp/shareApp/share/textcontentcheck" //敏感词判断
#define Foune_POST_DetailsCollection @"/collectionApp/collectionApp/collection" //收藏
#define Foune_POST_DetailsPraise @"/praiseApp/praiseApp/praise" //点赞
#define Foune_POST_CanclePraise @"/praiseApp/praiseApp/praise/delete" //取消点赞
#define Foune_POST_CancleCollection @"/collectionApp/collectionApp/collection/delete" //取消收藏
#define Foune_Get_Topic @"/topicApp/topicApp/topic"//热搜
#define Foune_Get_SearchAndDetails @"/findApp/newsinformationApp/newsinformation/search"    //发现-搜索（// 或 文章详情
#define Foune_Get_ArticleDetails @"/findApp/newsinformationApp/newsinformation/details"     //发现-文章详情

/*********************************活动模块********************************************/
#define Activity_GET_Segment @"/activityApp/HdFieldApp/hdField"// 活动标签
#define Activity_GET_List @"/activityApp/HdNewsinformationAPP/hdNewsinformation" //活动列表
#define Activity_GET_Search @"/activityApp/HdNewsinformationAPP/hdNewsinformation/search" //活动搜索
#define Activity_Video_List @"/activityApp/HdNewsinformationAPP/hdNewsinformation/video"//活动视频列表
#define Activity_Get_Topic @"/topicApp/topicApp/topic/activity"//热搜

#define Activity_Classification @"/activity/activityClassification"//活动分类

#define Activity_ActivityList @"/activity/activityList"//分类查询适配活动 || 段 品阶 品查询适配活动
#define Activity_GET_ArticleDetails @"/activityApp/HdNewsinformationAPP/hdNewsinformation/details" // 活动-文章详情

//段 、品、品阶
#define Activity_LEVEL_LEVELLIST  @"/level/levelList"

//检查筛查所适用报名的段位
#define ACTIVITY_LEVEL_ACTIVITYCHECKEDLEVEL @"/activity/activityCheckedLevel"
//法会列表
#define Activity_RiteList @"/pujaController/pujaList"

/*!法会二级、三级类别列表*/
#define Activity_RiteSecondList @"/pujaController/pujaClassification"
/*!法会四级类别列表*/
#define Activity_RiteFourList @"/pujaController/matterInfoList"

/*! 法会时间*/
#define Activity_RiteDate @"/pujaController/rulesCorrespondTime"

/*! 法会详情*/
#define Activity_RiteDetails @"/pujaController/pujaDetails"
/*! 法会表单结构*/
#define Activity_RiteFormModel @"/pujaController/pujaType"
/*! 提交表单*/
#define Activity_RiteFormSignUp @"/pujaController/pujaSignUp"
/*! 法会订单支付成功获取祝福语*/
#define Activity_RiteBlessing @"/pujaController/blessing"
/*! 是否去内坛*/
#define Activity_RitePujaSignUpUpdate @"/pujaController/pujaSignUpUpdate"

//法会最早最晚时间，筛选用
#define Activity_RiteTimeRange @"/pujaController/timeInterval"

//法会 报名详情
#define Activity_RitePujaSignUpOrderCodeInfo @"/pujaController/pujaSignUpOrderCodeInfo"

//往期法会时间
#define Activity_RitePastReviewTime @"/pujaController/pastReviewTime"

//检查四级法会事项时间
#define Activity_RiteCheckedTime @"/pujaController/checkedTime"


/*! 获取法会列表公告数据*/
#define Activity_RiteMarqueeList @"/pujaController/notice"

//搜索法会
#define Activity_SearchRite @"/pujaController/search"
//往期法会
#define Activity_PastRiteList @"/pujaController/pastReviewList"
//我的法会
#define Activity_MyRite @"/pujaController/pujaSignUpByMemberId"

/*********************************我的模块********************************************/
#define Me_GetUserBalance @"/user/balance" //获取用户余额信息
#define Me_QueryPayPassword @"/user/payPasswordStatus"//查询支付密码设置状态
#define Me_ConsumerDetails @"/common/consumerDetails"//交易明细
#define Me_UserData @"/user" //个人信息
#define Me_UserChangePhoneNumber @"/login/replacePhoneNumber" //修改手机号
#define Me_UserChangeDate @"/memberApp/memberApp/member/update" //修改个人资料
#define Me_RealNameIdCard @"/shareApp/shareApp/share/idcardverify" //实名认证
#define Me_IdcardReason @"/shareApp/shareApp/share/idcardReason"    //实名认证拒绝原因
#define Me_PersonAuthenticationToken @"/common/RPManualToken"    //获取实人认证token及BizId
#define Me_PersonAuthenticationResult @"/common/RPManualVerifyResult"   //获取实人认证结果

#define Me_ChangePassword @"/memberApp/memberApp/member/updatepas"//修改密码
#define Me_BackPassword @"/memberApp/memberApp/member/updateseek" //找回密码
#define Me_Readhistory @"/readhistoryApp/readhistoryApp/readhistory"//阅读历史
#define Me_OutLogin @"/login/quit" //退出登录
#define Me_Get_ActivityList @"/activity/activityMyself"//我的活动
#define Me_POST_CourseReadHistory @"/gradeapi/common/Course/getCourseReadHistory"//教程观看历史
#define Me_POST_CourseBuyHistory @"/gradeapi/common/Course/getCourseBuyHistory"//教程购买历史
#define Me_POST_ExamProof @"/pay/examProofList" //考试凭证列表

#define Me_Get_WebNewsList @"/findApp/newsinformationApp/newsinformation/search" // 发文管理 和 草稿箱
#define Me_Get_DraftboxList @"/findApp/newsinformationApp/newsinformation/draft"    //草稿箱
#define Me_Get_DispatchList @"/findApp/newsinformationApp/newsinformation/dispatch" //发文管理
#define Me_POST_DeleteText @"/findApp/newsinformationApp/newsinformation/delete" //删除文章 和 草稿箱
#define Me_User_ChangeText @"/findApp/newsinformationApp/newsinformation/update" //修改文章
#define Me_LookTextRefused @"/findApp/newsinformationApp/newsinformation/approval" //查看被拒原因
#define Me_ReadHistory @"/readhistoryApp/readhistoryApp/readhistory"// 阅读历史
#define Me_Collection @"/collectionApp/collectionApp/collection" //我的收藏
#define Me_Collection_Rite @"pujaController/collection"//我的收藏 - 法会

#define Me_DeleteHistory @"/readhistoryApp/readhistoryApp/readhistory/delete"//删除阅读历史
/*********************************我的模块----> 商家入驻********************************************/
#define Me_StoreInfo_OpenInformation @"/shopapi/common/club/getClubInfoStep" //获取用户填写资料详情
#define Me_StoreInfo_LegalPerson @"/shopapi/common/club/applicationClub" //法人信息

//物流列表
#define Me_LogisticsList @"/common/logisticsList"

//检查版本
#define Me_CheckAppVersion @"/common/sendingData"
/*********************************段品制********************************************/
#define KungFu_HotCity @"/mechanism/popularCities" //机构热门城市
#define KungFu_HotClass @"/shopapi/common/goods/getHotWord" //热门教程
#define KungFu_HotActivity @"/activity/applicationsHot" //热门活动
#define KungFu_Achievements @"/level/achievements" //我的成就
// 查看证书列表
#define KungFu_Certificate @"/certificateApp/certificate/get"
// 查看成绩列表
#define KungFu_ScoreList @"/achievementsApp/achievements/get"
// 查看教程列表
#define KungFu_ClassList @"/gradeapi/common/Course/getCourseList"
// 机构列表
#define KungFu_InstitutionList @"/mechanism/mechanismList"
// 提交报名信息
#define KungFu_ApplicationsSave @"/activity/applicationsSave"
// 我的报名信息
#define KungFu_MyApplications @"/applicationsApp/applications/myApplications"
// 查询报名信息
#define KungFu_applicationsSearch @"/applicationsApp/applications/get"
// 报名信息详情
#define KungFu_applicationsDetail @"/applicationsApp/applications/details"
// 考试通知
#define KungFu_examinationNotice @"/applicationsApp/applications/notice"
// 开始理论考试
#define KungFu_Examination @"/examinationApp/examination/get"
// 提交考卷
#define KungFu_ExaminationSubmit @"/examinationApp/examination/achievements"
// 保存答题信息
#define KungFu_ExaminationSave @"/examinationApp/examination/save"
// 查询报名信息
//#define KungFu_applicationsSearch @"/applicationsApp/applications/get"


#define KungFu_Certificate @"/certificateApp/certificate/get" // 查看证书列表
/**领取实物证书*/
#define KungFu_ApplicationCertificate @"/certificateApp/certificate/application"

#define KungFu_ScoreList @"/achievementsApp/achievements/get" // 查看成绩列表
#define KungFu_ScoreDetail @"/achievementsApp/achievements/detail" // 查看成绩详情

#define KungFu_ClassList @"/gradeapi/common/Course/getCourseList" // 查看教程列表

#define KungFu_InstitutionList @"/mechanism/mechanismList"  // 机构列表
#define KungFu_ApplicationsSave @"/activity/applicationsSave"  // 提交报名信息

#define KungFu_MyApplications @"/applicationsApp/applications/myApplications"  // 我的报名信息
// 根据活动编号查询电话和姓名
#define KungFu_OrderDetailUserInfo @"/activity/userInfoByOrderCode"


//#define KungFu_applicationsSearch @"/applicationsApp/applications/get"  // 查询报名信息

// 查询教程详情
#define KungFu_ClassDetail @"/gradeapi/common/Course/getCourseInfo"
#define KungFu_SetCourseReadHistory @"/gradeapi/common/Course/setCourseReadHistory" //添加教程观看历史

// 收藏教程
#define KungFu_ClassCollect @"/gradeapi/common/Course/setList"

// 苹果内购验证
#define Me_ApplePayCheck @"/pay/setApplePayCertificate"

// 苹果余额充值商品
#define Me_ApplePayProductList @"/common/appleVirtualCurrencyList"

// 实名认证回显
#define Me_ShareAppDetail @"/shareApp/shareApp/share/details"


#define KungFu_MECHANISM_MECHANISMSIGNUP @"/mechanism/mechanismSignUp" //机构报名

#define KungFu_VideoAuth @"/vodApp/getAuth" //从阿里获取播放凭证

// 活动报名 表单 学历
#define COMMON_EDUCATIONDATA @"/common/educationData"

// 活动报名 表单 民族
#define COMMON_NATIONDATA @"/common/nationData"



#endif /* DefinedURLs_h */
