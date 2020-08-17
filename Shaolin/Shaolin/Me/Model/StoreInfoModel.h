//
//  StoreInfoModel.h
//  Shaolin
//
//  Created by edz on 2020/4/7.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StoreInfoModel : NSObject
/** cell的高度*/
@property (nonatomic, assign) CGFloat cellHeight;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString *imageStr;
@end

NS_ASSUME_NONNULL_END
