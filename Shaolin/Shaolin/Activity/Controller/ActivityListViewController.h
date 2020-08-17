//
//  ActivityListViewController.h
//  Shaolin
//
//  Created by edz on 2020/4/7.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ActivityListViewController : UIViewController
@property(nonatomic,assign) NSInteger  selectPage;
@property(nonatomic,assign) NSInteger identifier;

- (void)refreshAndScrollToTop;
@end

NS_ASSUME_NONNULL_END
