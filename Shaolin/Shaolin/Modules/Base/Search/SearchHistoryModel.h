//
//  SearchHistoryModel.h
//  Shaolin
//
//  Created by 郭超 on 2020/10/12.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchHistoryModel : NSObject

@property(nonatomic, strong)NSString *type;
@property(nonatomic, strong)NSString *userId;
@property(nonatomic, strong)NSString *searchContent;

- (void)addSearchWordWithDataArray:(NSMutableArray *)dataArray;

@end

NS_ASSUME_NONNULL_END
