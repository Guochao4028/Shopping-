//
//  RiteOrderDetailInfoCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/7/31.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RiteOrderDetailInfoCell.h"

@interface RiteOrderDetailInfoCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIView *cellLine;

@property (weak, nonatomic) IBOutlet UIButton *copButton;

@end

@implementation RiteOrderDetailInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.text = self.titleStr;
    self.contentLabel.text = self.contentStr;
    
    self.cellLine.hidden = self.isHideLine;
    
    
    self.copButton.hidden = ![self.titleStr isEqualToString:@"功德编号："];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)copButtonHandle:(UIButton *)sender {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.contentStr;
    [ShaolinProgressHUD singleTextHud:@"复制成功" view:WINDOWSVIEW afterDelay:TipSeconds];
}


@end
