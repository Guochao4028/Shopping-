//
//  ClassifyMenuView.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/23.
//  Copyright © 2020 syqaxldy. All rights reserved.
//  分类菜单栏

#import "ClassifyMenuView.h"
#import "WengenEnterModel.h"

@interface ClassifyMenuView ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *classifyNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *classifyDirectionImageView;
@property (weak, nonatomic) IBOutlet UIImageView *priceSortImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *salesVolumeLabel;


@end

@implementation ClassifyMenuView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"ClassifyMenuView" owner:self options:nil];
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

/// 重写系统方法
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self.contentView setFrame:self.bounds];
}

-(void)changeClassifyDirection:(NSInteger)dirction{
    if (dirction == 0) {
        [self.classifyDirectionImageView setImage:[UIImage imageNamed:@"down"]];
        
    }else{
        [self.classifyDirectionImageView setImage:[UIImage imageNamed:@"selecgedUp"]];
        
        [self.classifyNameLabel setTextColor:WENGEN_RED];
    }
}
#pragma mark - action

- (IBAction)tapClassifyView:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(view:tapClassifyView:)]) {
        [self.delegate view:self tapClassifyView:YES];
    }
}

- (IBAction)tapPriceView:(id)sender {
    if ([self.delegate respondsToSelector:@selector(view:tapPriceView:)] == YES) {
        [self.delegate view:self tapPriceView:YES];
    }
}

- (IBAction)tapSalesVolumeView:(id)sender {
    if ([self.delegate respondsToSelector:@selector(view:tapSalesVolumeView:)] == YES) {
        [self.delegate view:self tapSalesVolumeView:YES];
    }
}

#pragma mark - setter / getter

-(void)setModel:(WengenEnterModel *)model{
    
    [self.classifyNameLabel setText:model.name];
    
    if (model.son.count > 0) {
        [self.classifyDirectionImageView setHidden:NO];
    }else{
        [self.classifyDirectionImageView setHidden:YES];
    }
    
}

-(void)setSelectdModel:(WengenEnterModel *)selectdModel{
    _selectdModel = selectdModel;
     [self.classifyDirectionImageView setImage:[UIImage imageNamed:@"down"]];
    [self.classifyNameLabel setTextColor:WENGEN_RED];
    [self.classifyNameLabel setText:selectdModel.name];
}

-(void)setType:(ListType)type{
    _type = type;
    switch (type) {
        case ListXiaoLiangAscType:{
            [self.salesVolumeLabel setTextColor:WENGEN_GREY];
            
        }
            break;
        case ListXiaoLiangDescType:{
            [self.salesVolumeLabel setTextColor:WENGEN_RED];
            [self.priceLabel setTextColor:WENGEN_GREY];
            [self.priceSortImageView setImage:[UIImage imageNamed:@"normal"]];
        }
            break;
        case ListJiaGeAscType:{
            [self.salesVolumeLabel setTextColor:WENGEN_GREY];
            [self.priceLabel setTextColor:WENGEN_RED];
            [self.priceSortImageView setImage:[UIImage imageNamed:@"ascending"]];
        }
            break;
        case ListJiaGeDescType:{
            [self.salesVolumeLabel setTextColor:WENGEN_GREY];
            [self.priceLabel setTextColor:WENGEN_RED];
            [self.priceSortImageView setImage:[UIImage imageNamed:@"descending"]];
            
        }
            break;
            
        default:
            break;
    }
}


@end
