//
//  KungfuClassSubCell.m
//  Shaolin
//
//  Created by ws on 2020/5/13.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuClassSubCell.h"
#import "ClassGoodsModel.h"
#import "ClassDetailModel.h"

@interface KungfuClassSubCell()


@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tryIcon;
@property (weak, nonatomic) IBOutlet UILabel *classSubTitleLabel;
@end

@implementation KungfuClassSubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setIsPlaying:(BOOL)isPlaying {
    _isPlaying = isPlaying;
    
    if (isPlaying) {
        self.classSubTitleLabel.textColor = [UIColor hexColor:@"8E2B25"];
        self.timeLabel.textColor = [UIColor hexColor:@"8E2B25"];
        self.tryIcon.image = nil;
        
        if (![self.detailModel.buy boolValue] && [self.model.try_watch intValue] == 1) {
            // 未购买且教程课节是试看时，显示试看标志
            self.tryIcon.image = [UIImage imageNamed:@"try_icon_red"];
        }
    } else {
        self.classSubTitleLabel.textColor = [UIColor hexColor:@"333333"];
        self.timeLabel.textColor = [UIColor hexColor:@"999999"];
        self.tryIcon.image = nil;
        
        if (![self.detailModel.buy boolValue] && [self.model.try_watch intValue] == 1) {
            // 未购买且教程课节是试看时，显示试看标志
            self.tryIcon.image = [UIImage imageNamed:@"try_icon_black"];
        }
    }
}

- (void)setModel:(ClassGoodsModel *)model{
    _model = model;
    
    NSString * indexName = NotNilAndNull(model.classGoodsName)?model.classGoodsName:@"";
    NSString * className = NotNilAndNull(model.value)?model.value:@"";
    
    
    self.classSubTitleLabel.text = [NSString stringWithFormat:@"%@ %@",indexName,className];
    self.timeLabel.text = model ? [NSString stringWithFormat:SLLocalizedString(@"%@ 更新"), model.update_time] : @"";
    
//    if ([model.try_watch intValue] == 1) {
//        //可以试看
//        self.tryIcon.image = [UIImage imageNamed:@"try_icon_black"];
//    } else {
//        self.tryIcon.image = nil;
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
