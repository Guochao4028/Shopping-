//
//  OrdeItemImageCollectionViewCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/5/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrdeItemImageCollectionViewCell.h"

@interface OrdeItemImageCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;

@end

@implementation OrdeItemImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.goodsImageView.layer.cornerRadius = SLChange(4);
}

- (void)setImageStr:(NSString *)imageStr{
    _imageStr = imageStr;
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"default_small"]];
}

@end
