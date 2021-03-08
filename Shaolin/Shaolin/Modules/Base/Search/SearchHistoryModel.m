//
//  SearchHistoryModel.m
//  Shaolin
//
//  Created by 郭超 on 2020/10/12.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "SearchHistoryModel.h"

@implementation SearchHistoryModel

- (void)addSearchWordWithDataArray:(NSMutableArray *)dataArray{
//    SearchHistoryArticleType

    for (int i = 0; i < dataArray.count; i++) {
        SearchHistoryModel *tempHistoryModel = dataArray[i];
        if ([tempHistoryModel.searchContent isEqualToString:self.searchContent]) {
            [dataArray removeObjectAtIndex:i];
            [[ModelTool shareInstance]deleteTableName:@"searchHistory" where:[NSString stringWithFormat:@"userId = '%@' AND searchContent = '%@' AND type = '%@' ", self.userId, self.searchContent, self.type]];
            break;
        }
    }
    
    [dataArray insertObject:self atIndex:0];
    
    
//    for(int i = 0 ; i < 1000; i++){
//        [[ModelTool shareInstance]insert:self tableName:@"searchHistory"];
//    }
//
    
    [[ModelTool shareInstance]insert:self tableName:@"searchHistory"];

    NSArray *tempDataArray = [[ModelTool shareInstance] select:[SearchHistoryModel class] tableName:@"searchHistory" where:[NSString stringWithFormat:@"type = '%@' AND userId = '%@' ORDER BY id DESC", self.type, self.userId]];

    if ([tempDataArray count] > 20) {
//        [[ModelTool shareInstance]deleteTableName:@"searchHistory" where:[NSString stringWithFormat:@"id <(select max(id) - 20 from searchHistory where userId = '%@' AND type = '%@')", self.userId, self.type]];

        [[ModelTool shareInstance]deleteTableName:@"searchHistory" where:[NSString stringWithFormat:@"id not in (select id from searchHistory where userId = '%@' AND type = '%@' ORDER BY id LIMIT 0,20)", self.userId, self.type]];



    }
}

@end
