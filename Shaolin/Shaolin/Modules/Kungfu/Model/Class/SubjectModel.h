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

@property (nonatomic, copy) NSString * isUse;
@property (nonatomic, copy) NSString * courseId;
//@property (nonatomic, copy) NSString * create_time;
@property (nonatomic, copy) NSString * levelName;
@property (nonatomic, copy) NSString * time;
@property (nonatomic, copy) NSString * num;

@end

NS_ASSUME_NONNULL_END
