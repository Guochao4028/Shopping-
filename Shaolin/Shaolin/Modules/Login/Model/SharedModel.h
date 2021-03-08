//
//  SharedModel.h
//  Shaolin
//
//  Created by 王精明 on 2020/7/13.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SharedModel : NSObject
//type:URL, video,
@property (nonatomic, copy) NSString *type;

/*! 分享内容标题 */
@property (nonatomic, copy) NSString *titleStr;
/*! 分享内容简介*/
@property (nonatomic, copy) NSString *descriptionStr;
/*! 分享内容网页链接*/
@property (nonatomic, copy) NSString *webpageURL;
/*! 缩略图URL，只有image为nil是会使用*/
@property (nonatomic, copy) NSString *imageURL;
/*! 缩略图*/
@property (nonatomic, strong) UIImage *image;
//@property (nonatomic, strong) UIImage *thumbImage;

- (UIImage *)toThumbImage;

@end

extern NSString *SharedModelURLType;
extern NSString *SharedModelVideoType;
NS_ASSUME_NONNULL_END
