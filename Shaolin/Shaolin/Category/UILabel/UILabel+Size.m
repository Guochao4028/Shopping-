//
//  UILabel+Size.m
//  Shaolin
//
//  Created by edz on 2020/3/25.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "UILabel+Size.h"




@implementation UILabel (Size)
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return ceil(height);
}

+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    CGFloat width = label.frame.size.width+2;
    return ceil(width);
}
- (void) textLeftTopAlign

{

NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];

paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;

NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12.f], NSParagraphStyleAttributeName:paragraphStyle.copy};

CGSize labelSize = [self.text boundingRectWithSize:CGSizeMake(207, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;

CGRect dateFrame =CGRectMake(2, 140, CGRectGetWidth(self.frame)-5, labelSize.height);

self.frame = dateFrame;

}


///计算label的高度
+(CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size.height;
}

@end
