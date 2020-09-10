//
//  RiteCell.m
//  Shaolin
//
//  Created by ws on 2020/7/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RiteCell.h"
#import "RiteModel.h"

@interface RiteCell ()

@property (weak, nonatomic) IBOutlet UIImageView *photoImgv;
@property (weak, nonatomic) IBOutlet UIView *cellLine;
@property (weak, nonatomic) IBOutlet UIImageView *ovalImgv;
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cnTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIButton *stateBtn;

@property (weak, nonatomic) IBOutlet UIView *topVerLine;
@property (weak, nonatomic) IBOutlet UIView *bottomVerLine;


@property (weak, nonatomic) IBOutlet UILabel *centerLabel;

@property (weak, nonatomic) IBOutlet UILabel *allYearLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelTop;

@property (weak, nonatomic) IBOutlet UIButton *cellSelectBtn;

@end

@implementation RiteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameLabelTop.constant = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)layoutSubviews {
    
    self.topVerLine.hidden = NO;
    self.bottomVerLine.hidden = NO;
    self.cellLine.hidden = NO;
    
    if (self.positionType == RiteCellPositionFirst) {
        self.topVerLine.hidden = YES;
    } else if (self.positionType == RiteCellPositionLast) {
        self.bottomVerLine.hidden = YES;
        self.cellLine.hidden = YES;
    } else if (self.positionType == RiteCellPositionOnlyOne){
        self.topVerLine.hidden = YES;
        self.bottomVerLine.hidden = YES;
        self.cellLine.hidden = YES;
    }
    
}


-(void)setCellModel:(RiteModel *)cellModel {
    _cellModel = cellModel;
    
    self.stateBtn.hidden = YES;
    
    if (!cellModel.endDate.length) {
        self.endTimeLabel.text = cellModel.startDate;
        self.beginTimeLabel.hidden = YES;
        self.centerLabel.hidden = YES;
    } else {
        self.beginTimeLabel.text = cellModel.startDate;
        self.endTimeLabel.text = cellModel.endDate;
        self.centerLabel.hidden = NO;
    }
    
    if (cellModel.startDate == nil) {
        self.beginTimeLabel.hidden = YES;
        self.centerLabel.hidden = YES;
    }
    
    
    
    self.cnTimeLabel.text = cellModel.lunarTime;
    
    self.nameLabel.text = cellModel.name;
    self.contentLabel.text = cellModel.introduction;
    
    if (cellModel.introduction == nil) {
        self.nameLabelTop.constant = 24;
    }else{
        self.nameLabelTop.constant = 0;
    }
    
//    [self.photoImgv sd_setImageWithURL:[NSURL URLWithString:cellModel.imgUrl] placeholderImage:[UIImage imageNamed:@"default_small"]];
    [self.photoImgv sd_setImageWithURL:[NSURL URLWithString:cellModel.thumbnailUrl] placeholderImage:[UIImage imageNamed:@"default_big"]];//default_big，default_small
//    if ([cellModel.state isEqualToString:@"1"]) {
//        self.stateBtn.hidden = NO;
//        [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"rite_ing"] forState:UIControlStateNormal];
//        [self.stateBtn setTitle:@"进行中" forState:UIControlStateNormal];
        [self updateLabelColor:[UIColor hexColor:@"333333"]];
//    } else if ([cellModel.state isEqualToString:@"2"]) {
//        self.stateBtn.hidden = NO;
//        [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"rite_ed"] forState:UIControlStateNormal];
//        [self.stateBtn setTitle:@"已结束" forState:UIControlStateNormal];
//        [self updateLabelColor:[UIColor hexColor:@"999999"]];
//    } else {
//        [self updateLabelColor:[UIColor hexColor:@"999999"]];
//    }
    
    if (cellModel.isThroughoutYear) {
        [self.allYearLabel setHidden:NO];
        self.beginTimeLabel.hidden = YES;
        self.endTimeLabel.hidden = YES;
    }else{
        [self.allYearLabel setHidden:YES];
        self.beginTimeLabel.hidden = NO;
        self.endTimeLabel.hidden = NO;
    }
}

- (IBAction)cellSelectBtnEvent:(UIButton *)sender {
    if (self.cellSelectHandle) {
        self.cellSelectHandle();
    }
}

- (void) updateLabelColor:(UIColor *)color {
    self.beginTimeLabel.textColor = color;
    self.endTimeLabel.textColor = color;
    self.centerLabel.textColor = color;
    self.cnTimeLabel.textColor = color;
}

@end
