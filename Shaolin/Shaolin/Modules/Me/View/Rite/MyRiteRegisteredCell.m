//
//  MyRiteRegisteredCell.m
//  Shaolin
//
//  Created by ws on 2020/8/5.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "MyRiteRegisteredCell.h"
#import "MyRiteCellModel.h"

@interface MyRiteRegisteredCell()

@property (weak, nonatomic) IBOutlet UIImageView *riteImgv;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIButton *detailBtn;

@end


@implementation MyRiteRegisteredCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)detailHandle:(UIButton *)sender {
    if (self.detailSelectHandle) {
        self.detailSelectHandle();
    }
}

- (void)setRiteModel:(MyRiteCellModel *)riteModel {
    _riteModel = riteModel;
    
    self.nameLabel.text = riteModel.pujaName;
    self.contentLabel.text = riteModel.introduction;
//    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@",riteModel.actuallyPaidMoney];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//        formatter.positiveFormat = @",###.##"; // 正数格式
    // 整数最少位数
    formatter.minimumIntegerDigits = 1;
    // 小数位最多位数
    formatter.maximumFractionDigits = 2;
    // 小数位最少位数
    formatter.minimumFractionDigits = 2;
    NSString *money = [formatter stringFromNumber:riteModel.actuallyPaidMoney];
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@",money];
    
    [self.riteImgv sd_setImageWithURL:[NSURL URLWithString:riteModel.thumbnailUrl] placeholderImage:[UIImage imageNamed:@"default_small"]];

}

@end
