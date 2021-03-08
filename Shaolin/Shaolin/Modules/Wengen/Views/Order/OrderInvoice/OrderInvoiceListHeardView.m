//
//  OrderInvoiceListHeardView.m
//  Shaolin
//
//  Created by 郭超 on 2021/1/19.
//  Copyright © 2021 syqaxldy. All rights reserved.
//

#import "OrderInvoiceListHeardView.h"
#import "OrderStoreModel.h"

@interface OrderInvoiceListHeardView ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation OrderInvoiceListHeardView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"OrderInvoiceListHeardView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

- (void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.tapBlock) {
        self.tapBlock(YES, self.model);
    }
}


#pragma mark -  getter / setter
-(void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    [self.titleLabel setText:titleStr];
}

-(void)setModel:(OrderStoreModel *)model{
    _model = model;
    [self.titleLabel setText:model.name];
}

@end
