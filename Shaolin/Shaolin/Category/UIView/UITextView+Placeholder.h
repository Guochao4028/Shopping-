//
//  UITextView+Placeholder.h
//  Shaolin
//
//  Created by edz on 2020/4/17.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

//系统版本
#define HKVersion [[[UIDevice currentDevice] systemVersion] floatValue]

@interface UITextView (Placeholder)
-(void)setPlaceholder:(NSString *)placeholdStr placeholdColor:(UIColor *)placeholdColor;
@end


