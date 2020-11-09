//
//  KfExamRadioQuestionSubCell.m
//  Shaolin
//
//  Created by ws on 2020/5/19.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KfExamRadioQuestionSubCell.h"

@interface KfExamRadioQuestionSubCell ()

@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end


@implementation KfExamRadioQuestionSubCell

+(instancetype)xibRegistrationCell{
    return (KfExamRadioQuestionSubCell *)[[[NSBundle mainBundle] loadNibNamed:@"KfExamRadioQuestionSubCell" owner:nil options:nil] lastObject];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = UIColor.clearColor;
    self.contentView.backgroundColor = UIColor.clearColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setAnserStr:(NSString *)anserStr {
    _anserStr = anserStr;
    
    self.contentLabel.text = anserStr;
}

-(void)setIsChoose:(BOOL)isChoose {
    _isChoose = isChoose;
    
    if (isChoose) {
        self.bgView.layer.borderColor = kMainYellow.CGColor;
        self.contentLabel.textColor = kMainYellow;
    } else {
        self.bgView.layer.borderColor = [UIColor hexColor:@"DDDDDD"].CGColor;
        self.contentLabel.textColor = [UIColor hexColor:@"333333"];
    }
}

@end
