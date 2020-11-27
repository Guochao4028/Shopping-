//
//  OrdeItemImageCollectionViewCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/5/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrdeItemImageCollectionViewCell : UICollectionViewCell

@property(nonatomic, copy)NSString *imageStr;
@property (weak, nonatomic) IBOutlet UIImageView *playIcon;

@end

NS_ASSUME_NONNULL_END
