//
//  SLSearchResultView.h
//  Shaolin
//
//  Created by edz on 2020/3/23.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLSearchResultView : UIView
- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSMutableArray *)dataArr;

- (void)refreshResultViewWithIsDouble:(BOOL)isDouble;
@end

NS_ASSUME_NONNULL_END
