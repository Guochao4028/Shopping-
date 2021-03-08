//
//  StoreInformationModel.m
//  Shaolin
//
//  Created by 王精明 on 2020/7/17.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "StoreInformationModel.h"

@implementation StoreInformationModel

-(NSString *)startTime {
    if ([_startTime isEqualToString:@"0"]) {
        return @"";
    }
    return _startTime;
}

- (NSString *)cardStartTime {
    if ([_cardStartTime isEqualToString:@"0"]) {
        return @"";
    }
    return _cardStartTime;
}

-(NSString *)cardEndTime {
    if ([_cardEndTime isEqualToString:@"0"]) {
        return @"";
    }
    return _cardEndTime;
}

-(NSString *)organizationEndTime {
    if ([_organizationEndTime isEqualToString:@"0"]) {
        return @"";
    }
    return _organizationEndTime;
}

-(NSString *)organizationStartTime {
    if ([_organizationStartTime isEqualToString:@"0"]) {
        return @"";
    }
    return _organizationStartTime;
}

-(NSString *)businessStartTime {
    if ([_businessStartTime isEqualToString:@"0"]) {
        return @"";
    }
    return _businessStartTime;
}

-(NSString *)businessEndTime {
    if ([_businessEndTime isEqualToString:@"0"]) {
        return @"";
    }
    return _businessEndTime;
}

-(NSString *)phone {
    if ([_phone isEqualToString:@"0"]) {
        return @"";
    }
    return _phone;
}

@end
