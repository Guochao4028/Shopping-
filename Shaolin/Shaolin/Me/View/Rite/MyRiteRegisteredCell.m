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
}

-(void)setRiteModel:(MyRiteCellModel *)riteModel {
    _riteModel = riteModel;
    
    self.nameLabel.text = riteModel.pujaName;
    self.contentLabel.text = riteModel.pujaIntroduction;
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@",riteModel.actuallyPaidMoney];
    
    [self.riteImgv sd_setImageWithURL:[NSURL URLWithString:riteModel.thumbnailUrl] placeholderImage:[UIImage imageNamed:@"default_small"]];

}

@end
