//
//  RitePastListCell.m
//  Shaolin
//
//  Created by ws on 2020/8/14.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RitePastListCell.h"
#import "RitePastModel.h"

@interface RitePastListCell()

@property (weak, nonatomic) IBOutlet UIImageView *riteImgv;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *cellLine;

@end

@implementation RitePastListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews {
    if (self.isFirst) {
        self.cellLine.hidden = true;
    } else {
        self.cellLine.hidden = false;
    }
}

-(void)setCellModel:(RitePastModel *)cellModel {
    _cellModel = cellModel;

    self.nameLabel.text = cellModel.reviewTitle;
    self.contentLabel.text = cellModel.reviewIntroduction;

    [self.riteImgv sd_setImageWithURL:[NSURL URLWithString:cellModel.reviewThumbnailUrl] placeholderImage:[UIImage imageNamed:@"default_big"]];//default_big，default_small
}


@end
