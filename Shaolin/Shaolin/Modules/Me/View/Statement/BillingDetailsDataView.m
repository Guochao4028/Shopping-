//
//  BillingDetailsDataView.m
//  Shaolin
//
//  Created by 郭超 on 2020/7/13.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "BillingDetailsDataView.h"
#import "StatementModel.h"

@interface BillingDetailsDataView ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *payStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rderCodeLabel;
@property (weak, nonatomic) IBOutlet UIView *detilsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *listViewH;

@end

@implementation BillingDetailsDataView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"BillingDetailsDataView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self reloadView];
}
#pragma mark - methods


/// 初始化UI
-(void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
}

- (void)reloadView{
    if (!self.model) return;
    NSString *imageName = [self.model showImageName];
    self.imageView.image = [UIImage imageNamed:imageName];
    self.titleLabel.text = self.model.name;
    if (self.model.revenue == 2){//消费
        self.moneyLabel.text = [NSString stringWithFormat:@"-%.2f", self.model.money];
        self.moneyLabel.textColor = KTextGray_333;
    } else {//收入
        self.moneyLabel.text = [NSString stringWithFormat:@"+%.2f", self.model.money];
        self.moneyLabel.textColor = KPriceRed;
    }
    self.orderTypeLabel.text = self.model.orderTypeVo;
    self.payStateLabel.text = self.model.payStateVo;
    self.createTimeLabel.text = self.model.createTime;
    
    NSString *orderCode = self.model.orderCode;
    NSArray *orderArray = [self.model.orderCode componentsSeparatedByString:@"_"];
    // TOOD: 多商品合并下单，退款单个商品，界面展示主订单号
    if (orderArray.count > 1){
        orderCode = orderArray.firstObject;
    }
    self.rderCodeLabel.text = orderCode;
    if (self.model.orderType == 5) {//充值，不显示查看详情按钮
        self.detilsView.hidden = YES;
    } else {
        self.detilsView.hidden = NO;
    }
}

- (void)setModel:(StatementValueModel *)model{
    _model = model;
    [self reloadView];
}

- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    if (self.gotoOrderDetails){
        self.gotoOrderDetails(self.model);
    }
}
@end
