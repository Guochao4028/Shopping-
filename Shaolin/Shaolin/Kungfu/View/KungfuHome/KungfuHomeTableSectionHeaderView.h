//
//  KungfuHomeTableSectionHeaderView.h
//  Shaolin
//
//  Created by ws on 2020/5/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KungfuHomeTableSectionHeaderView : UIView


@property (nonatomic, assign) BOOL arrowHidden;
@property (nonatomic, copy) NSString * titleString;

@property (nonatomic, copy) void(^ sectionViewHandle)(void);

@end

NS_ASSUME_NONNULL_END
