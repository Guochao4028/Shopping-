//
//  EnrollmentDanPop.h
//  Shaolin
//
//  Created by EDZ on 2020/5/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "MMPopupView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EnrollmentDanPop : MMPopupView

@property (nonatomic, strong) NSMutableArray *datalist;


// 教研方法
@property (nonatomic, strong) NSArrayCallBack blockArr;

@end

NS_ASSUME_NONNULL_END
