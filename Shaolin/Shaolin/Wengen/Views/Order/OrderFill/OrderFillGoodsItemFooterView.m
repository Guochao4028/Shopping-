//
//  OrderFillGoodsItemFooterView.m
//  Shaolin
//
//  Created by 郭超 on 2020/6/28.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderFillGoodsItemFooterView.h"
#import "ShoppingCartGoodsModel.h"

@interface OrderFillGoodsItemFooterView ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *freightLabel;
@end

@implementation OrderFillGoodsItemFooterView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"OrderFillGoodsItemFooterView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

/// 初始化UI
-(void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
    
  
}

#pragma mark - setter / getter

-(void)setGoodsDic:(NSDictionary *)goodsDic{
    _goodsDic = goodsDic;
    
    
    NSArray *goodsArray = goodsDic[@"goods"];
    NSInteger freight = 0;
    for (ShoppingCartGoodsModel *cartGoodsModel in goodsArray) {
        freight += [cartGoodsModel.freight integerValue];
    }
    
    if (freight == 0) {
        [self.freightLabel setText:SLLocalizedString(@"免运费")];
    }else{
        [self.freightLabel setText:[NSString stringWithFormat:@"￥%ld",freight]];
    }
}



@end
