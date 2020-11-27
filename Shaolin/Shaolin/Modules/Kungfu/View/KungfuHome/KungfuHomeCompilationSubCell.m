//
//  KungfuHomeCompilationSubCell.m
//  Shaolin
//
//  Created by ws on 2020/5/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuHomeCompilationSubCell.h"

@interface KungfuHomeCompilationSubCell ()

@property (weak, nonatomic) IBOutlet UIImageView *classImgv;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;



@end

@implementation KungfuHomeCompilationSubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    [self.classImgv sd_setImageWithURL:[NSURL URLWithString:@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1142166796,2385197542&fm=26&gp=0.jpg"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setCellModel:(ClassListModel *)cellModel {
    _cellModel = cellModel;
    
    self.nameLabel.text = cellModel.name;
    
    NSString *timeStr = [ModelTool calculatedTimeWith:CalculatedTimeTypeDonotSecond secondStr:cellModel.weight];
    
    self.contentLabel.text = [NSString stringWithFormat:@"%@ · %@",cellModel.level_name,timeStr];
    [self.classImgv sd_setImageWithURL:[NSURL URLWithString:cellModel.cover] placeholderImage:[UIImage imageNamed:@"default_small"]];
}

@end
