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
//#define URL_POST_SHOPAPI_COMMON_GOODS_CATE_GETALLGOODSCATELIST @"/shopapi/common/goods_cate/getAllGoodsCateList"
#define URL_POST_SHOPAPI_COMMON_GOODS_CATE_GETALLGOODSCATELIST @"/goods/cateList"

// 首页 banner
#define URL_POST_BANNERURL @"/banner/list"

//商品一/二级分类列表
//#define URL_POST_SHOPAPI_COMMON_GOODS_CATE_GETGOODSCATELIST  @"/shopapi/common/goods_cate/getGoodsCateList"
#define URL_POST_SHOPAPI_COMMON_GOODS_CATE_GETGOODSCATELIST  @"/goods/cateList"


//新人推荐商品
//#define  URL_POST_SHOPAPI_COMMON_GOODS_GETNEW @"/shopapi/common/goods/getNew"
#define  URL_POST_SHOPAPI_COMMON_GOODS_GETNEW @"/goods/newList"


//首页 严选商品
//#define URL_POST_SHOPAPI_COMMON_GOODS_GETDELICATE @"/shopapi/common/goods/getDelicate"
#define URL_POST_SHOPAPI_COMMON_GOODS_GETDELICATE @"/goods/delicateList"


//商品列表
//#define URL_POST_SHOPAPI_COMMON_GOODS_GETGOODSLIST @"/shopapi/common/goods/getGoodsList"
#define URL_POST_SHOPAPI_COMMON_GOODS_GETGOODSLIST @"/goods/list"



//商品详情
//#define URL_POST_SHOPAPI_COMMON_GOODS_GETGOODSINFO @"/shopapi/common/goods/getGoodsInfo"
#define URL_POST_SHOPAPI_COMMON_GOODS_GETGOODSINFO @"/goods/detail"



//检查商品库存
#define URL_POST_SHOPAPI_COMMON_GOODS_CHECKSTOCK @"/goods/checkStock"

/********************************店铺*******************************/
//TODO: ---------------以下未改
//查看店铺证照信息
//#define URL_POST_SHOPAPI_COMMON_CLUB_GETBUSINESS @"/shopapi/common/club/getBusiness"
//TODO: ---------------以上未改

//店铺信息
//#define URL_POST_SHOPAPI_COMMON_CLUB_GETCLUBINFO @"/shopapi/common/club/getClubInfo"
#define URL_POST_SHOPAPI_COMMON_CLUB_GETCLUBINFO @"/club/detail"


//店铺取消收藏
//#define URL_POST_SHOPAPI_COMMON_COLLECT_CANCELCOLLECT @"/shopapi/common/collect/cancelCollect"
#define URL_POST_SHOPAPI_COMMON_COLLECT_CANCELCOLLECT @"/collect/cancel"


//店铺添加收藏
//#define URL_POST_SHOPAPI_COMMON_COLLECT_ADDCOLLECT @"/shopapi/common/collect/addCollect"
#define URL_POST_SHOPAPI_COMMON_COLLECT_ADDCOLLECT @"/collect/add"


//收藏店铺列表
//#define URL_POST_SHOPAPI_COMMON_COLLECT_MYCOLLECT @"/shopapi/common/collect/myCollect"
#define URL_POST_SHOPAPI_COMMON_COLLECT_MYCOLLECT @"/collect/getList"


/*********************************收货地址********************************************/

//收货地址列表
//#define URL_POST_SHOPAPI_COMMON_ADDRESS_ADDRESSLIST @"/shopapi/common/address/addressList"
#define URL_POST_SHOPAPI_COMMON_ADDRESS_ADDRESSLIST @"/address/list"

//收货地址文件
#define URL_GET_AREA_LIST_TXT @"/data/area_list.txt"

//添加收货地址
//#define URL_POST_SHOPAPI_COMMON_ADDRESS_ADDADDRESS @"/shopapi/common/address/addAddress"
#define URL_POST_SHOPAPI_COMMON_ADDRESS_ADDADDRESS @"/address/add"

//计算商品运费
//#define URL_POST_SHOPAPI_COMMON_ORDER_COMPUTEGOODSFEE @"/shopapi/common/order/computeGoodsFee"

//计算商品运费
#define URL_POST_SHOPAPI_COMMON_ORDER_COMPUTEGOODSFEE @"/shipping/getShippingFee"

//修改收货地址
//#define URL_POST_SHOPAPI_COMMON_ADDRESS_EDITADDRESS @"/shopapi/common/address/editAddress"
#define URL_POST_SHOPAPI_COMMON_ADDRESS_EDITADDRESS  @"/address/edit"

//删除收货地址
//#define URL_POST_SHOPAPI_COMMON_ADDRESS_DELADDRESS @"/shopapi/common/address/delAddress"
#define URL_POST_SHOPAPI_COMMON_ADDRESS_DELADDRESS @"/address/delete"



//收货地址详情
//#define URL_POST_SHOPAPI_COMMON_ADDRESS_GETADDRESSINFO @"/shopapi/common/address/getAddressInfo"
#define URL_POST_SHOPAPI_COMMON_ADDRESS_GETADDRESSINFO @"/address/info"


//添加购物车
#define URL_POST_SHOPAPI_COMMON_GOODS_CAR_ADDCAR @"/cart/save"

/*********************************购物车********************************************/

//购物车列表
//#define URL_POST_SHOPAPI_COMMON_GOODS_CAR_CARLIST @"/shopapi/common/goods_car/CarList"
#define URL_POST_SHOPAPI_COMMON_GOODS_CAR_CARLIST @"/cart/list"

//删除购物车
#define URL_POST_SHOPAPI_COMMON_GOODS_CAR_DELCAR @"/cart/delete"

////购物车添加商品数量
//#define URL_POST_SHOPAPI_COMMON_GOODS_CAR_INCRCARNUM @"/shopapi/common/goods_car/incrCarNum"
//
////购物车减少商品数量
//#define URL_POST_SHOPAPI_COMMON_GOODS_CAR_DECRCARNUM @"/shopapi/common/goods_car/decrCarNum"

//购物车修改商品数量
#define URL_POST_SHOPAPI_COMMON_GOODS_CAR_UPDATENUM @"/cart/updateNum"

//购物车修改规格
#define URL_POST_SHOPAPI_COMMON_GOODS_CAR_CHANGEGOODSATTR @"/cart/updateAttr"

/********************************订单****************************************/
//TODO: ---------------以下未改
//生成订单
#define URL_POST_SHOPAPI_COMMON_ORDER_CREATODER @"/order/add"
//申请开发票
#define URL_POST_INVOICE_ADD     @"/invoice/add"

//订单统计
#define URL_POST_SHOPAPI_COMMON_ORDER_GETCOUNT @"/order/getCount"

//删除订单
#define URL_POST_SHOPAPI_COMMON_ORDER_DELORDER @"/order/delete"

//#define URL_POST_SHOPAPI_COMMON_ORDER_ORDERINFONEW @"/shopapi/common/order/OrderInfoNew"

//确认订单
#define URL_POST_SHOPAPI_COMMON_ORDER_CONFIRMRECEIPT @"/order/receipt"

//评论订单
#define URL_POST_SHOPAPI_COMMON_EVALUATE_ADDEVALUATE @"/evaluate/add"

//取消订单
#define URL_POST_SHOPAPI_COMMON_ORDER_CANCELORDER @"/order/cancel"

//订单申请售后
#define URL_POST_SHOPAPI_COMMON_REFUND_ADDREFUND @"/refund/add"


//订单取消售后
#define URL_POST_SHOPAPI_COMMON_REFUND_CANNELREFUND @"/refund/cancel"

//售后申请详情
#define URL_POST_SHOPAPI_COMMON_REFUND_GETREFUNINFO @"/refund/info"

//申请售后发货
#define URL_POST_SHOPAPI_COMMON_REFUND_SENDREFUNDGOODS @"/refund/sendGoods"

//删除售后
#define  URL_POST_SHOPAPI_COMMON_ORDER_DELREFUNDORDER @"/refund/delete"

//用户资质信息
#define URL_POST_SHOPAPI_COMMON_INVOICE_USERQUALIFICATIONS @"/qualification/info"


//添加用户资质信息
#define URL_POST_SHOPAPI_COMMON_INVOICE_ADDQUALIFICATIONS @"/qualification/add"
//TODO: ---------------以上未改

//#define URL_GET_SHOPAPI_COMMON_GOODS_GETGOODSINVOICE @"/shopapi/common/goods/getGoodsInvoice"
//申请开发票
#define URL_POST_SHOPAPI_COMMON_INVOICE_INVOICING @"/invoice/add"
//换开发票
#define URL_POST_SHOPAPI_COMMON_INVOICE_CHANGEINVOICE  @"/invoice/change"
//修改发票信息
#define URL_POST_SHOPAPI_COMMON_INVOICE_EDITINVOICE  @"/invoice/edit"

//我的订单
//#define URL_POST_SHOPAPI_COMMON_ORDER_USERORDERLIST @"/shopapi/common/order/UserOrderList"
//
//#define URL_POST_SHOPAPI_COMMON_ORDER_USERORDERLIST_NEW @"/shopapi/common/order/UserOrderListNew"
#define URL_POST_SHOPAPI_COMMON_ORDER_USERORDERLIST @"/order/list"


#define URL_POST_SHOPAPI_COMMON_REFUND_LIST @"/refund/list"

//订单详情
#define URL_POST_SHOPAPI_COMMON_ORDER_ORDERINFO @"/order/info"
////ahq 列表
//#define URL_POST_SHOPAPI_COMMON_AHP_GETAHQLIST @"/shopapi/common/ahq/getAhqList"
////猜你想问
//#define URL_POST_SHOPAPI_COMMON_AHP_GUESSLIST @"/shopapi/common/ahq/guessList"

//ahq 列表
#define URL_POST_SHOPAPI_COMMON_AHP_GETAHQLIST @"/faq/getList"
//猜你想问
#define URL_POST_SHOPAPI_COMMON_AHP_GUESSLIST @"/faq/getList"

//发送邮件
#define URL_POST_SHOPAPI_COMMON_SENDMAIL  @"/common/sendMail"


//订单详情
#define URL_GET_SHOPAPI_COMMON_INVOICE_LIST @"/invoice/list"


//发票详情
#define URL_POST_SHOPAPI_COMMON_INVOICE_INFO @"/invoice/info"

#pragma mark - 以上都是商城相关接口


/*********************************支付********************************************/
//支付密码校验
#define  URL_POST_USER_PAYPASSWORDCHECK @"/user/payPasswordCheck"
//获取余额
//#define  URL_POST_USER_BALANCE @"/user/balance"
//设置支付密码
#define  URL_POST_USER_PAYPASSWORDSETTING @"/user/payPasswordSetting"
//修改支付密码
#define  URL_POST_USER_PAYPASSWORDMODIFY @"/user/payPasswordModify"
//支付
#define  URL_POST_USER_PAY_ORDERPAY @"/pay/orderPay"
//验证订单支付状态
#define  URL_POST_USER_PAY_CHECK @"/pay/checkedPay"

//忘记支付密码-验证码校验
#define  URL_GET_USER_PAY_CODECHECK @"/common/codeCheck"
//忘记支付密码-设置支付密码
#define  URL_GET_USER_PAY_PASSWORDFORGET @"/user/payPasswordForget"

//活动编号查询是否有符合该位阶且该机构的考试凭证
#define  URL_GET_USER_PAY_CHECKPROOF @"/pay/CheckProof"


/*********************************登录模块********************************************/
#define URL_GET_REFRESHTOKEN @"/login/refreshToken" //刷新用户token
#define URL_POST_USER_LOGIN @"/login/passwordLogin" //登录
#define URL_POST_USER_CODELOGIN @"/login/codeLogin" //验证码登录

#define URL_POST_USER_LOGIN_OTHER @"/login/other" // 第三方授权登录
#define URL_POST_USER_LOGIN_OTHERBINDLIST @"/login/otherBindList" //第三方授权列表
#define URL_POST_USER_LOGIN_OTHERBIND @"/login/otherBind" // 已登录账号绑定第三方
#define URL_POST_USER_LOGIN_OTHERCABCELBIND @"/login/otherBindCancel" // 已登录账号解除第三方绑定

#define URL_POST_USER_Register @"/login/register"//注册
#define URL_POST_USER_PhoneCheck @"/login/phoneCheck" //验证手机号是否被注册
/*********************************所有验证码********************************************/
#define URL_POST_ALL_CODE @"/common/phoneVerifyCode" //获取验证码
#define URL_POST_CHECK_CODE @"/common/codeCheck" //校验验证码是否正确

#define URL_GET_AD @"/openScreen/list" //开屏广告
/*********************************发现模块********************************************/
#define URL_GET_HomeSegment @"/find/field/list" //分段标签
#define URL_GET_HomeList @"/find/list" //发现列表接口
#define Video_First_Photo @"?x-oss-process=video/snapshot,t_3000,m_fast,ar_auto" //视频首帧
#define Found_Video_List @"/find/video" //发现的视频列表
#define Found_POST_Photo @"/common/uploadImage"//上传图片
#define Found_POST_WebNewsInforMation @"/find/save" //发布文章

#define Foune_POST_ADDVIDEOREADHISTORY @"/readHistory/save" //发现-添加视频阅读记录
#define Foune_POST_DetailsCollection @"/collection/save" //收藏
#define Foune_POST_DetailsPraise @"/praise/save" //点赞
#define Foune_POST_CanclePraise @"/praise/delete" //取消点赞
#define Foune_POST_CancleCollection @"/collection/delete" //取消收藏
#define Foune_Get_Topic @"/topic/find"//热搜
#define Foune_Get_SearchAndDetails @"/find/search"    //发现-搜索（// 或 文章详情
#define Foune_Get_ArticleDetails @"/find/detail"     //发现-文章详情

/*********************************活动模块********************************************/
//#pragma mark - *****以下接口*****
//#define Activity_GET_Segment @"/activityApp/HdFieldApp/hdField"// 活动标签
//#define Activity_GET_List @"/activityApp/HdNewsinformationAPP/hdNewsinformation" //活动列表
//#define Activity_GET_Search @"/activityApp/HdNewsinformationAPP/hdNewsinformation/search" //活动搜索
//#define Activity_Video_List @"/activityApp/HdNewsinformationAPP/hdNewsinformation/video"//活动视频列表
//#define Activity_Get_Topic @"/topicApp/topicApp/topic/activity"//热搜
////检查筛查所适用报名的位阶
//#define ACTIVITY_LEVEL_ACTIVITYCHECKEDLEVEL @"/activity/activityCheckedLevel"

//#pragma mark - *****以上接口不用了*****

#define Activity_GET_ArticleDetails @"/puja/detail" // 活动-文章详情
//法会列表
#define Activity_RiteList @"/puja/list"
/*!法会二级、三级类别列表*/
#define Activity_RiteSecondList @"/puja/pujaClassification"
/*!法会四级类别列表*/
#define Activity_RiteFourList @"/puja/matterInfoList"
//#define Activity_RiteFourList @"/puja/matterInfoList"

/*! 法会时间*/
#define Activity_RiteDate @"/puja/rulesCorrespondTime"

/*! 法会详情*/
//#define Activity_RiteDetails @"/puja/details"

/*! 法会表单结构*/
#define Activity_RiteFormModel @"/puja/pujaType"
/*! 提交表单*/
#define Activity_RiteFormSignUp @"/puja/signUp"
/*! 法会订单支付成功获取祝福语*/
#define Activity_RiteBlessing @"/puja/blessing"
/*! 是否去内坛*/
#define Activity_RitePujaSignUpUpdate @"/puja/signUpUpdate"

//法会最早最晚时间，筛选用
#define Activity_RiteTimeRange @"/puja/timeInterval"

//法会 报名详情
#define Activity_RitePujaSignUpOrderCodeInfo @"/puja/signUpOrderCodeInfo"

//往期法会时间
#define Activity_RitePastReviewTime @"/puja/pastReviewTime"

//检查四级法会事项时间
#define Activity_RiteCheckedTime @"/puja/checkTime"


/*! 获取法会列表公告数据*/
#define Activity_RiteMarqueeList @"/puja/notice"

//搜索法会
#define Activity_SearchRite @"/puja/search"
//往期法会
#define Activity_PastRiteList @"/puja/pastReviewList"


#pragma mark - 段品制
// 分类查询适配活动 || 段 品阶 品查询适配活动
#define Activity_ActivityList @"/activity/list"
// 段品制活动分类
#define Activity_Classification @"/activity/classification"//活动分类
// 机构热门城市
#define KungFu_HotCity @"/mechanism/popularCity"
// 热门活动
#define KungFu_HotActivity @"/activity/hot"
// 我的成就
#define KungFu_Achievements @"/level/achievements"
// 提交报名信息
#define KungFu_ApplicationsSave @"/application/save"
// 机构报名
#define KungFu_MECHANISM_MECHANISMSIGNUP @"/mechanism/signUp"
//// 查询报名信息（目前未使用）
//#define KungFu_applicationsSearch @"/applicationsApp/applications/get"
//// 报名信息详情（目前未使用）
//#define KungFu_applicationsDetail @"/applicationsApp/applications/details"
//// 保存答题信息（目前未使用）
//#define KungFu_ExaminationSave @"/examinationApp/examination/save"
//// 考试通知（目前未使用）
//#define KungFu_examinationNotice @"/applicationsApp/applications/notice"
//// 开始理论考试（目前未使用）
//#define KungFu_Examination @"/examinationApp/examination/get"
//// 提交考卷（目前未使用）
//#define KungFu_ExaminationSubmit @"/examinationApp/examination/achievements"
//// 领取实物证书（目前未使用）
//#define KungFu_ApplicationCertificate @"/certificateApp/certificate/application"
// 查看证书列表
#define KungFu_Certificate @"/user/myCertificate"
// 查看成绩详情
#define KungFu_ScoreDetail @"/achievement/detail"
// 机构列表
#define KungFu_InstitutionList @"/mechanism/list"
// 查看成绩列表
#define KungFu_ScoreList @"/achievement/list"
// 苹果内购验证
#define Me_ApplePayCheck @"/pay/setApplePayCertificate"
//// 苹果余额充值商品（暂时不用）
//#define Me_ApplePayProductList @"/common/appleVirtualCurrencyList"
// 从阿里获取播放凭证
#define KungFu_VideoAuth @"/video/getAuth"
// 活动报名 表单 学历
#define COMMON_EDUCATIONDATA @"/common/educationData"
// 活动报名 表单 民族
#define COMMON_NATIONDATA @"/common/nationData"
// 活动公告 公告列表
#define ACTIVITY_ANNOINCEMENT   @"/announcement/list"
// 活动公告 公告未读数量
#define ACTIVITY_ANNOINCEMENTUNREADNUMBER   @"/announcement/unreadNumber"
// 活动公告 标记已读
#define ACTIVITY_ANNOINCEMENTMARKREAD   @"/announcement/read"
// 段 、品、品阶
#define Activity_LEVEL_LEVELLIST  @"/level/list"
// 段品制 - 报名页面回显信息(新)
#define KungFu_applicationsEcho @"/application/info"

#pragma mark - 我的
//#define Me_GetUserBalance @"/user/balance" //获取用户余额信息
//#define Me_QueryPayPassword @"/user/payPasswordStatus"//查询支付密码设置状态
// 交易明细
#define Me_ConsumerDetails @"/common/consumerDetail"
// 个人信息
#define Me_UserData @"/user"
// 修改手机号
#define Me_UserChangePhoneNumber @"/user/changePhoneNumber"
// 修改个人资料
#define Me_UserChangeDate @"/user/update"
//// 退出登录（未使用）
//#define Me_OutLogin @"/login/quit"

// 新增实名认证
#define Me_RealNameIdCard @"/idCardCheck/save"
// 实名认证拒绝原因
#define Me_IdcardReason @"/idCardCheck/reason"
// 获取实人认证token及BizId
#define Me_PersonAuthenticationToken @"/idCardCheck/RPManualToken"
// 获取实人认证结果
#define Me_PersonAuthenticationResult @"/idCardCheck/RPManualVerifyResult"
// 实名认证回显
#define Me_ShareAppDetail @"/idCardCheck/detail"

// 阅读历史
#define Me_Readhistory @"/readHistory/list"
// 删除阅读历史
#define Me_DeleteHistory @"/readHistory/delete"
// 我的活动
#define Me_Get_ActivityList @"/application/myself"
//// 考试凭证列表（接口废弃）
//#define Me_POST_ExamProof @"/pay/examProofList"
// 草稿箱
#define Me_Get_DraftboxList @"/find/draft"
// 发文管理
#define Me_Get_DispatchList @"/find/dispatch"
// 删除文章 和 草稿箱
#define Me_POST_DeleteText @"/find/delete"
// 修改文章
#define Me_User_ChangeText @"/find/update"
// 查看审批批语
#define Me_LookTextRefused @"/find/approval"
// 我的收藏 - 法会
#define Me_Collection_Rite @"/puja/collection"
// 检查版本
#define Me_CheckAppVersion @"/common/latestVersion"
// 我的报名信息
#define KungFu_MyApplications @"/application/myApplication"

/// 店铺入驻
// 获取用户填写资料详情
#define Me_StoreInfo_OpenInformation @"/applyClub/info"
// 店铺入驻
#define Me_StoreInfo_LegalPerson @"/applyClub/add"



// 我的收藏
//#define Me_Collection @"/shopapi/common/collect/myCollect"
#define Me_Collection @"/collect/getList"

// 我的收藏 文章 & 视频
#define Me_Collection_List  @"/collection/list"

//我的法会
#define Activity_MyRite @"/puja/signUpList"

// 修改密码
#define Me_ChangePassword @"/user/updatePassword"
//找回密码
#define Me_BackPassword @"/login/forgetPassword"

// 查看教程列表
#define KungFu_ClassList @"/course/list"
// 热门教程
#define KungFu_HotClass @"/course/hotList"
// 科目列表
#define Kungfu_SubjectList @"/subject/getList"
// 查询教程详情
#define KungFu_ClassDetail @"/course/info"
// 教程观看历史
#define Me_POST_CourseReadHistory @"/course/historyList"
// 教程购买历史
#define Me_POST_CourseBuyHistory @"/course/buyList"
// 添加教程观看历史
#define KungFu_SetCourseReadHistory @"/courseHistory/add"
// 根据活动编号查询电话和姓名
#define KungFu_OrderDetailUserInfo @"/activity/memberByOrderCode"
// 物流列表
#define Me_LogisticsList @"/common/logisticsList"
// 课程详情下方更多推荐
#define KungFu_ClasDetail_Recomment @"/course/recommendList"
//// 收藏教程（未使用）
//#define KungFu_ClassCollect @"/gradeapi/common/Course/setList"



#endif /* DefinedURLs_h */
