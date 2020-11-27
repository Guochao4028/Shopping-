//
//  LevelModel.h
//  Shaolin
//
//  Created by 郭超 on 2020/5/20.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LevelModel : NSObject<NSCopying>

@property(nonatomic, copy)NSString *classification;
@property(nonatomic, copy)NSString *createTime;
@property(nonatomic, copy)NSString *fid;
@property(nonatomic, copy)NSString *levelId;
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *number;
@property(nonatomic, copy)NSString *type;
@property(nonatomic, copy)NSString *value;

@property(nonatomic, copy)NSString *levelType;

@end

NS_ASSUME_NONNULL_END

/**
  classification = "<null>";
                createTime = "";
                fid = 26;
                id = 26;
                name = "\U56db\U54c1";
                number = "<null>";
                type = "<null>";
                value = "<null>";
 */
