//
//  WSIAPModel.m
//  Shaolin
//
//  Created by ws on 2020/7/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "WSIAPModel.h"

@implementation WSIAPModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _transactionId = [aDecoder decodeObjectForKey:@"transactionId"];
        _receiptString = [aDecoder decodeObjectForKey:@"receiptString"];
        _createTime = [aDecoder decodeObjectForKey:@"createTime"];
//        _transaction = [aDecoder decodeObjectForKey:@"transaction"];
        _checkType = [[aDecoder decodeObjectForKey:@"checkType"] integerValue];
        _payCode = [aDecoder decodeObjectForKey:@"payCode"];
        _payMoney =[aDecoder decodeObjectForKey:@"payMoney"];
        _customIdentifier =[aDecoder decodeObjectForKey:@"customIdentifier"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.transactionId forKey:@"transactionId"];
    [aCoder encodeObject:self.receiptString forKey:@"receiptString"];
    [aCoder encodeObject:self.createTime forKey:@"createTime"];
//    [aCoder encodeObject:self.transaction forKey:@"transaction"];
    [aCoder encodeObject:@(self.checkType) forKey:@"checkType"];
    [aCoder encodeObject:self.payCode forKey:@"payCode"];
    [aCoder encodeObject:self.payMoney forKey:@"payMoney"];
    [aCoder encodeObject:self.customIdentifier forKey:@"customIdentifier"];
    
}


@end
