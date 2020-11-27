//
//  PersonalDataView.h
//  Shaolin
//
//  Created by edz on 2020/3/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^PersonDataClick)(NSDictionary *dic);
@interface PersonalDataView : UIView
@property(nonatomic,strong) NSDictionary *dicData;
@property (nonatomic , copy) void (^itemDidClick)(NSInteger index);
@property (nonatomic , copy) PersonDataClick personDataClick;
@property(nonatomic,strong) NSNumber *balanceNumber;
@end

NS_ASSUME_NONNULL_END
