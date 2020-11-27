//
//  XLPagePictureAndTextTitleCell.h
//  Shaolin
//
//  Created by 王精明 on 2020/11/3.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "XLPageTitleCell.h"

NS_ASSUME_NONNULL_BEGIN
@class FieldModel;
@interface XLPagePictureAndTextTitleCell : XLPageTitleCell
@property (nonatomic, strong) FieldModel *model;


+ (CGSize)cellSize;
+ (CGFloat)pictureViewHeight;
@end

NS_ASSUME_NONNULL_END
