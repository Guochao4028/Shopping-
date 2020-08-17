//
//  ClassVideoModel.h
//  Shaolin
//
//  Created by ws on 2020/7/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassVideoMeta.h"

NS_ASSUME_NONNULL_BEGIN

@interface ClassVideoModel : NSObject

@property (nonatomic, copy) NSString * playAuth;
@property (nonatomic, copy) NSString * requestId;
@property (nonatomic, strong) ClassVideoMeta * videoMeta;


@end

NS_ASSUME_NONNULL_END
