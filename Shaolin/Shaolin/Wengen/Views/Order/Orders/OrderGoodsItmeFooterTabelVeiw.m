//
//  OrderGoodsItmeFooterTabelVeiw.m
//  Shaolin
//
//  Created by 郭超 on 2020/5/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderGoodsItmeFooterTabelVeiw.h"

@interface OrderGoodsItmeFooterTabelVeiw ()



@end

@implementation OrderGoodsItmeFooterTabelVeiw

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"OrderGoodsItmeFooterTabelVeiw" owner:self options:nil];
        self.backgroundColor = [UIColor whiteColor];
         
        [self initUI];
    }
    return self;
}

-(void)initUI{
    
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
}





@end
