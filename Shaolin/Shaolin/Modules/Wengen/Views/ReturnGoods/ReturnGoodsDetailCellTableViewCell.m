//
//  ReturnGoodsDetailCellTableViewCell.m
//  Shaolin
//
//  Created by ws on 2020/5/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ReturnGoodsDetailCellTableViewCell.h"

#import "GoodsStoreInfoModel.h"

@interface ReturnGoodsDetailCellTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNum;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *unDoBtn;
@property (weak, nonatomic) IBOutlet UIButton *inputBtn;

@end

@implementation ReturnGoodsDetailCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    [self.inputBtn setTitle:SLLocalizedString(@"        我已寄出\n点击填写物流单号") forState:UIControlStateNormal];
    self.inputBtn.titleLabel.lineBreakMode = 0;
    self.inputBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)unDoHandle:(UIButton *)sender {
    if (self.unDoHandle) {
        self.unDoHandle();
    }
}

- (IBAction)inputHandle:(UIButton *)sender {
    if (self.inputHandle) {
        self.inputHandle();
    }
}

-(void)setStoreInfoModel:(GoodsStoreInfoModel *)storeInfoModel{
    _storeInfoModel = storeInfoModel;
    if (storeInfoModel == nil) {
        return;
    }
    [self.nameLabel setText:[NSString stringWithFormat:SLLocalizedString(@"收货人：%@"), storeInfoModel.name]];
    
    if (storeInfoModel.phone != nil) {
        [self.phoneNum setText:storeInfoModel.phone];
    }else{
        [self.phoneNum setText:@""];
    }
    
    [self.addressLabel setText:storeInfoModel.address];
    
}

@end
