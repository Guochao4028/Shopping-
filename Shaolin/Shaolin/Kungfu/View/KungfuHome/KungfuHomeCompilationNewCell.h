//
//  KungfuHomeCompilationNewCell.h
//  Shaolin
//
//  Created by 王精明 on 2020/11/4.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KungfuHomeCompilationNewCell : UITableViewCell
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, copy) void(^ selectHandle)(NSString * classId);
@property (nonatomic, copy) NSString *tagString;
+ (CGSize)cellSize;
@end

NS_ASSUME_NONNULL_END
