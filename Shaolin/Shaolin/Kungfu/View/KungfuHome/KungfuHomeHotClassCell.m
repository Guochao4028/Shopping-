//
//  KungfuHomeHotClassCell.m
//  Shaolin
//
//  Created by ws on 2020/5/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuHomeHotClassCell.h"
#import "HotClassModel.h"

@implementation KungfuHomeHotClassCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.tagView = [[KungfuHomeHotTagView alloc] initWithFrame:CGRectMake(16, 0, [UIScreen mainScreen].bounds.size.width - 32, 0)];
        self.contentView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.tagView];

    }
    return self;
}

-(void)setHotSearchArr:(NSArray *)hotSearchArr
{
    _hotSearchArr = hotSearchArr;

    /** 注意cell的subView的重复创建！（内部已经做了处理了......） */
    [self.tagView setTagWithTagArray:hotSearchArr];

}


@end
