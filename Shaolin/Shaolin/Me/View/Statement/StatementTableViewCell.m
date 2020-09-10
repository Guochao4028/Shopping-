//
//  StatementTableViewCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/7/13.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "StatementTableViewCell.h"
#import "StatementModel.h"
@implementation StatementTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(StatementValueModel *)model{
    _model = model;
    self.title.text = model.name;
    if (model.revenue == 2){//支出
        self.money.text = [NSString stringWithFormat:@"-%.2f", model.money];
        self.money.textColor = [UIColor colorForHex:@"333333"];
    } else {//收入
        self.money.text = [NSString stringWithFormat:@"+%.2f", model.money];
        self.money.textColor = [UIColor colorForHex:@"BE0B1F"];
    }
    
    NSString *imageName = [model showImageName];
    self.imageV.image = [UIImage imageNamed:imageName];
    self.orderType.text = model.orderTypeVo;
    self.payState.text = model.payStateVo;
    self.createTime.text = model.isMonth;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
