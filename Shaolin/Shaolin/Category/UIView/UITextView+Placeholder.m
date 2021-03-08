//
//  UITextView+Placeholder.m
//  Shaolin
//
//  Created by edz on 2020/4/17.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "UITextView+Placeholder.h"

@implementation UITextView (Placeholder)
- (void)setPlaceholder:(NSString *)placeholdStr placeholdColor:(UIColor *)placeholdColor
{
    /*
    [self setValue:(nullable id) forKey:(nonnull NSString *)]
    ps: KVC键值编码，对UITextView的私有属性进行修改
    */
    UILabel *placeholder = [self valueForKey:@"placeholderLabel"];
    //防止重复
    if (!placeholder) {
        placeholder = [[UILabel alloc] init];//WithFrame:self.bounds
        placeholder.numberOfLines = 0;
        [self addSubview:placeholder];
        [self setValue:placeholder forKey:@"placeholderLabel"];
    }
    placeholder.font = self.font;
    placeholder.text = placeholdStr;
    [placeholder sizeToFit];
    placeholder.textColor = placeholdColor;
}

@end
