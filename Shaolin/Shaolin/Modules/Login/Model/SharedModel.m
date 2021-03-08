//
//  SharedModel.m
//  Shaolin
//
//  Created by 王精明 on 2020/7/13.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "SharedModel.h"
#import "UIImage+LGFImage.h"

NSString *SharedModelURLType = @"URL";
NSString *SharedModelVideoType = @"Video";
@implementation SharedModel
- (UIImage *)toThumbImage {
    if (!self.image) return nil;
    UIImage *newImage = [UIImage lgf_ResizeImage:self.image withNewSize:CGSizeMake(100, 100)];
    NSData *imageData = UIImagePNGRepresentation(newImage);
    CGFloat length_kb = imageData.length/1024;
    CGFloat maxLength_kb = 31; //微博缩略图最多允许32kb
    if (length_kb > maxLength_kb){
        CGFloat compression = maxLength_kb/length_kb;
        imageData = UIImageJPEGRepresentation(newImage,compression);
    }
    
    newImage = [UIImage imageWithData:imageData];
    return newImage;
}
@end
