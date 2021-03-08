//
//  KungfuOrderDetailInfoCell.m
//  Shaolin
//
//  Created by ws on 2020/6/1.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuOrderDetailInfoCell.h"

@interface KungfuOrderDetailInfoCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIView *cellLine;

@property (weak, nonatomic) IBOutlet UIButton *copButton;

@end


@implementation KungfuOrderDetailInfoCell


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.text = self.titleStr;
    self.contentLabel.text = self.contentStr;
    
    self.cellLine.hidden = self.isHideLine;
    
    
    self.copButton.hidden = ![self.titleStr isEqualToString:SLLocalizedString(@"订单编号：")];
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)copButtonHandle:(UIButton *)sender {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.contentStr;
    [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"复制成功") view:WINDOWSVIEW afterDelay:TipSeconds];
}

@end
