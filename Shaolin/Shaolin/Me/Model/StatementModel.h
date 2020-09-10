//
//  StatementModel.h
//  Shaolin
//
//  Created by 王精明 on 2020/7/15.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class StatementValueModel;
@interface StatementModel : NSObject
@property (nonatomic) CGFloat incomeMoney;
@property (nonatomic) CGFloat expenditureMoney;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, strong) NSArray <StatementValueModel *>*value;


@end


@interface StatementValueModel : NSObject
@property (nonatomic) NSInteger orderType;
@property (nonatomic, copy) NSString *orderTypeVo;
@property (nonatomic, copy) NSString *thirdAccount;
@property (nonatomic, copy) NSString *detailTime;
@property (nonatomic, copy) NSString *thirdOrderCode;
@property (nonatomic, copy) NSString *isMonth;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic) NSInteger result;
@property (nonatomic, copy) NSString *valid;
@property (nonatomic) NSInteger revenue;
@property (nonatomic) CGFloat money;
@property (nonatomic) NSInteger payState;
@property (nonatomic, copy) NSString *payStateVo;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *orderCode;
@property (nonatomic, copy) NSString *statementValueId;//id
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *isYearAndMonth;
@property (nonatomic, copy) NSString *memberId;

- (NSString *)showImageName;
@end
/*
 data.incomeMoney           收入
 data.expenditureMoney      支出
 data.time                  时间
 data.value.orderType       订单类型1 商品 2 教程 3 段品质活动 4 退款 5 充值 6 法会
 data.value.detailTime
 data.value.thirdOrderCode  三方单号
 data.value.isMonth         交易时间
 data.value.result
 data.value.revenue         1 退款（收入） 2 充值(收入) 3 消费(支出)
 data.value.money           交易金额
 data.value.orderCode       本平台订单编号
 data.value.payState        交易类型 1 余额 2 支付宝 3 微信 4苹果支付 5 凭证支付 99其他 
 data.value.memberId        用户Id
 data.value.name            商品名称
 data.value.createTime      交易时间
 */

/*
           "incomeMoney": 30,
           "expenditureMoney": 40,
           "time": "2020年7月",
           "value": [
               {
                   "orderType": 3,
                   "thirdAccount": null,
                   "detailTime": "2020-07",
                   "thirdOrderCode": "12345678",
                   "isMonth": "7月1日",
                    "name": "测试充值",
                   "remark": null,
                   "updateTime": null,
                   "result": 1,
                   "valid": null,
                   "revenue": 1,
                   "money": 30,
                   "createTime": "2020-07-14 13:41:01",
                   "orderCode": "12345678",
                   "id": 3,
                   "state": 1,
                   "isYearAndMonth": "2020年7月",
                   "memberId": "31"
               },
*/
NS_ASSUME_NONNULL_END
