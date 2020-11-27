//
//  KungfuExamNoticeTabelHeardView.m
//  Shaolin
//
//  Created by 郭超 on 2020/9/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuExamNoticeTabelHeardView.h"
#import "ExamNoticeModel.h"

@interface KungfuExamNoticeTabelHeardView ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
- (IBAction)tapContentView:(UITapGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *spreadImageView;
@property (weak, nonatomic) IBOutlet UIImageView *redPoint;

@end


@implementation KungfuExamNoticeTabelHeardView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [[NSBundle mainBundle] loadNibNamed:@"KungfuExamNoticeTabelHeardView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

#pragma mark - methods

/// 初始化UI
-(void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
}


- (IBAction)tapContentView:(UITapGestureRecognizer *)sender {
    NSLog(@"%s", __func__);
    if (self.examNoticeTabletActionBclok) {
        self.examNoticeTabletActionBclok(self.section);
    }
}

#pragma mark - setter / getter
-(void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    [self.titleLabel setText:titleStr];
}



-(void)setModel:(ExamNoticeModel *)model{
    _model = model;
    
    
    if (model.isSelected) {
        [self.spreadImageView setImage:[UIImage imageNamed:@"examNoticeUp"]];
    }else{
        [self.spreadImageView setImage:[UIImage imageNamed:@"examNoticeDown"]];
    }
    
    BOOL ifRead = [model.ifRead boolValue];
    
    [self.redPoint setHidden:ifRead];
    
}

@end
