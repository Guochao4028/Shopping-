//
//  InvoiceModel.m
//  Shaolin
//
//  Created by ws on 2020/5/14.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "InvoiceModel.h"

@implementation InvoiceModel


+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"invoiceId" : @"id",
             };
}

@end
