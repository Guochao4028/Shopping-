//
//  OrderGoodsItmeHeardTabelVeiw.m
//  Shaolin
//
//  Created by 郭超 on 2020/5/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderGoodsItmeHeardTabelVeiw.h"

#import "OrderStoreModel.h"

@interface OrderGoodsItmeHeardTabelVeiw ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *storeTitleLabel;
- (IBAction)jumpStoreAction:(UIButton *)sender;

@end

@implementation OrderGoodsItmeHeardTabelVeiw

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"OrderGoodsItmeHeardTabelVeiw" owner:self options:nil];
        self.backgroundColor = [UIColor whiteColor];
         
        [self initUI];
    }
    return self;
}

-(void)initUI{
    
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
}

-(void)setStoreModel:(OrderStoreModel *)storeModel{
    _storeModel = storeModel;
    [self.storeTitleLabel setText:storeModel.name];
}

- (IBAction)jumpStoreAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(orderGoodsItmeHeardTabelVeiw:jummp:)] == YES) {
        [self.delegate orderGoodsItmeHeardTabelVeiw:self jummp:self.storeModel];
    }
}
@end
