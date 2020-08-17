//
//  MyRiteCollectModel.h
//  Shaolin
//
//  Created by 王精明 on 2020/7/31.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyRiteCollectModel : NSObject
/*!法会活动code*/
@property (nonatomic, copy) NSString *pujaCode;
/*!法会活动type*/
@property (nonatomic, copy) NSString *pujaType;
/*!法会活动name*/
@property (nonatomic, copy) NSString *pujaName;
/*!法会活动简介*/
@property (nonatomic, copy) NSString *pujaIntroduction;
/*!法会缩略图*/
@property (nonatomic, copy) NSString *thumbnailUrl;

/*!是否点赞*/
@property (nonatomic, copy) NSString *collectionsState;
@end

NS_ASSUME_NONNULL_END
