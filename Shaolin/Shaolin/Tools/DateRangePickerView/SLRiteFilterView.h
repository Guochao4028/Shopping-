//
//  SLRiteFilterView.h
//  Shaolin
//
//  Created by ws on 2020/7/28.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLRiteFilterView : UIView

- (void)showWithPickerOrigin:(CGPoint )origin;
- (void)dismiss;


@property (nonatomic, copy) void (^ typeFilterHandle)(NSString * typeName);

@property (nonatomic, copy) NSString * typeName;

@end

NS_ASSUME_NONNULL_END
