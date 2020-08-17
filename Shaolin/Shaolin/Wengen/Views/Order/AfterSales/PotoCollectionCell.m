//
//  PotoCollectionCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/29.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "PotoCollectionCell.h"

@interface PotoCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *potoImageView;
- (IBAction)deleteButtonAction:(UIButton *)sender;

@end

@implementation PotoCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - setter / getter
-(void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
    [self.potoImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"default_small"]];
}

- (IBAction)deleteButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(potoCollectionCell:tapDeletePoto:location:)] == YES) {
        [self.delegate potoCollectionCell:self tapDeletePoto:YES location:self.location];
    }
}

@end
