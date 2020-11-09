//
//  SubjectModel.h
//  Shaolin
//
//  Created by ws on 2020/9/10.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SubjectModel : NSObject


@property (nonatomic, copy) NSString * subjectId;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * level;
@property (nonatomic, copy) NSString * recommend;
@property (nonatomic, copy) NSString * image;

@property (nonatomic, copy) NSString * is_use;
@property (nonatomic, copy) NSString * course_id;
@property (nonatomic, copy) NSString * create_time;
@property (nonatomic, copy) NSString * level_name;
@property (nonatomic, copy) NSString * time;
@property (nonatomic, copy) NSString * num;

@end

NS_ASSUME_NONNULL_END
