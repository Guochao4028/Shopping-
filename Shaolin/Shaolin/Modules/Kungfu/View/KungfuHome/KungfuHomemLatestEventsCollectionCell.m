//
//  KungfuHomemLatestEventsCollectionCell.m
//  Shaolin
//
//  Created by ws on 2020/5/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuHomemLatestEventsCollectionCell.h"
#import "EnrollmentListModel.h"


@interface KungfuHomemLatestEventsCollectionCell()

@property (weak, nonatomic) IBOutlet UIImageView *eventsImgv;
@property (weak, nonatomic) IBOutlet UILabel *eventsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventsNumberLabel;


@end

@implementation KungfuHomemLatestEventsCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


-(void)setCellModel:(EnrollmentListModel *)cellModel {
    _cellModel = cellModel;
    
    [self.eventsImgv sd_setImageWithURL:[NSURL URLWithString:cellModel.mechanismImage] placeholderImage:[UIImage imageNamed:@"default_big"]];
    self.eventsNameLabel.text = NotNilAndNull(cellModel.activityName)?cellModel.activityName:@"";
    self.eventsNumberLabel.text = [NSString stringWithFormat:SLLocalizedString(@"%@人已参加"),NotNilAndNull(cellModel.hotCount)?cellModel.hotCount:@""];
}

@end
