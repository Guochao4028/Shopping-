//
//  OrderFillContentTableHeadView.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
// 填写订单 地址

#import "OrderFillContentTableHeadView.h"

#import "AddressListModel.h"

#import "UILabel+Size.h"

#import "NSString+Tool.h"

@interface OrderFillContentTableHeadView ()
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *defaultLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *defaultLabelW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *defaultLabelSpacing;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressLabelH;
@property (weak, nonatomic) IBOutlet UIImageView *positioningImageView;



@end

@implementation OrderFillContentTableHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"OrderFillContentTableHeadView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

/// 初始化UI
-(void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
    
    self.defaultLabel.layer.cornerRadius = SLChange(4);
    [self.defaultLabel.layer setMasksToBounds:YES];
    [self.defaultLabel setHidden:YES];
    
    [self.defaultLabel setHidden:YES];
    [self.positioningImageView setHidden:YES];
}

/// 重写系统方法
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self.contentView setFrame:self.bounds];
}

#pragma mark - action
-(void)orderFillContentTableHeadTarget:(nullable id)target action:(SEL)action{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
}

#pragma mark - setter / getter

-(void)setAddressListModel:(AddressListModel *)addressListModel{
    _addressListModel = addressListModel;
    [self.addressLabel setText:addressListModel.address];
    
    self.addressLabelH.constant = [UILabel getLabelHeightWithText:addressListModel.address width:(ScreenWidth - 40) font:kMediumFont(16)] +1;
    
    [self.nameLabel setText:addressListModel.realname];
    [self.phoneLabel setText:[NSString numberSuitScanf:addressListModel.phone]];
    
    NSString *str;
       if ([addressListModel.country_s isEqualToString:SLLocalizedString(@"中国")] == NO) {
           str  = [NSString stringWithFormat:@"%@ %@ %@ %@ ",addressListModel.country_s, addressListModel.province_s, addressListModel.city_s, addressListModel.re_s];
       }else{
          str = [NSString stringWithFormat:@"%@ %@ %@", addressListModel.province_s, addressListModel.city_s, addressListModel.re_s];
       }
    
    if (addressListModel == nil) {
        str = SLLocalizedString(@"请选择地址");
    }
    
    [self.areaLabel setText:str];
    
    BOOL status = [addressListModel.status boolValue];
    
    [self.defaultLabel setHidden:!status];
    
    if (status == NO) {
        self.defaultLabelW.constant = 15;
        self.defaultLabelSpacing.constant = 7;
        [self.defaultLabel setHidden:YES];
        [self.positioningImageView setHidden:NO];
    }else{
        self.defaultLabelW.constant = 31;
        self.defaultLabelSpacing.constant = 7;
        [self.defaultLabel setHidden:NO];
        [self.positioningImageView setHidden:YES];
    }
}




@end
