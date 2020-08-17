//
//  HotClassModel.h
//  Shaolin
//
//  Created by ws on 2020/5/20.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HotClassModel : NSObject

@property (nonatomic, copy) NSString * className;
@property (nonatomic, copy) NSString * classId;
@property (nonatomic, copy) NSString * sort;
@property (nonatomic, assign) BOOL isFire;

@end

NS_ASSUME_NONNULL_END
