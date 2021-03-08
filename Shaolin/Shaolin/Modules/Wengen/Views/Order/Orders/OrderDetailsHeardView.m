//
//  OrderDetailsHeardView.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/20.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderDetailsHeardView.h"

#import "NSString+Tool.h"

#import "OrderDetailsModel.h"

#import "OrderDetailsNewModel.h"

@interface OrderDetailsHeardView ()

@property (nonatomic, assign)OrderDetailsType viewType;

@property (nonatomic, weak)UIView *contentView;

/******* WAITING VIEW ****/

@property (strong, nonatomic) IBOutlet UIView *waitingView;
@property (weak, nonatomic) IBOutlet UILabel *waitingPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *waitingTimeLabel;
- (IBAction)gotoPayAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *waitingAddressView;
@property (weak, nonatomic) IBOutlet UILabel *waitingNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *waitingPhoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *waitingAddressLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *waitingPriceLabelW;


/******* CANCE VIEW ****/

@property (strong, nonatomic) IBOutlet UIView *cancelView;
@property (weak, nonatomic) IBOutlet UIView *canceAddressView;
@property (weak, nonatomic) IBOutlet UILabel *canceReasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *canceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cancePhoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *canceAddressLabel;


/******* NORMAL VIEW ****/

@property (strong, nonatomic) IBOutlet UIView *normalView;
@property (weak, nonatomic) IBOutlet UIView *normalInstructionsView;
@property (weak, nonatomic) IBOutlet UILabel *normalTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *normalIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *normalInstructionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *normalNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *normalPhoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *normalAddressLabel;

// timer
@property (nonatomic, strong) NSTimer *timer;

//剩余时间
@property (nonatomic, assign) NSInteger timeDifference;

@end

@implementation OrderDetailsHeardView

- (instancetype)initWithFrame:(CGRect)frame viewType:(OrderDetailsType)type{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"OrderDetailsHeardView" owner:self options:nil];
        self.backgroundColor = [UIColor whiteColor];
         self.viewType = type;
        [self initUI];
        self.normalInstructionsLabel.userInteractionEnabled = YES;
    }
    return self;
}


#pragma mark - methods

//设置圆角
- (void)setRoundedCornersView:(UIView *)view corners:(UIRectCorner)corners{
    UIBezierPath* maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(10, 10)];
    maskPath.lineWidth     = 0.f;
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

- (void)initUI{
    switch (self.viewType) {
        case OrderDetailsHeardObligationType:{
            
            [self setRoundedCornersView:self.waitingAddressView corners:UIRectCornerTopLeft | UIRectCornerTopRight];
            
            self.contentView = self.waitingView;
        }
            break;
        case OrderDetailsHeardCancelType:{
            
            [self setRoundedCornersView:self.canceAddressView corners:UIRectCornerTopLeft | UIRectCornerTopRight];
            self.contentView = self.cancelView;

        }
            break;
        case OrderDetailsHeardNormalType:{
            [self setRoundedCornersView:self.normalInstructionsView corners:UIRectCornerTopLeft | UIRectCornerTopRight];
            self.contentView = self.normalView;
        }
            break;
            
        default:
            break;
    }
    
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
}


- (void)setupTimer {
    
    [self startTimer];
}

- (void)timeChange {
    if(self.viewType ==OrderDetailsHeardObligationType){
        self.timeDifference -= 1;
               
           if (self.timeDifference > 0) {
               [self.waitingTimeLabel setText:[NSString convertStrToTime:self.timeDifference]];
           }else{
               [[NSNotificationCenter defaultCenter] postNotificationName:ORDERDETAILSHEARDVIEW_TIMECHANGE_ENDTIME object:nil];
           }
    }
   
}


#pragma mark -action

- (IBAction)gotoPayAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(orderDetailsHeardView:gotoPay:)] == YES) {
        [self.delegate orderDetailsHeardView:self gotoPay:self.model];
    }
}

#pragma mark - action

- (void)setModel:(OrderDetailsNewModel *)model{
    _model = model;
    
    OrderAddressModel *addressModel = model.address;
    
    switch (self.viewType) {
        case OrderDetailsHeardObligationType:{
            [self.waitingNameLabel setText:addressModel.name];
            
            
            [self.waitingPhoneNumberLabel setText:[NSString numberSuitScanf:addressModel.phone]];
            
//            [self.waitingPhoneNumberLabel setText:model.phone];
            [self.waitingAddressLabel setText:[NSString stringWithFormat:SLLocalizedString(@"地址：%@"),addressModel.addressInfo]];
            
            NSString *money = [NSString stringWithFormat:@"¥%@", model.money];
            
            NSAttributedString *attrStr = [money moneyStringWithFormatting:MoneyStringFormattingMoneyAllFormattingType fontArrat:@[kMediumFont(13), kMediumFont(17), kMediumFont(14)]];
            
            self.waitingPriceLabel.attributedText = attrStr;
            
            CGSize size = [attrStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 21) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                    context:nil].size;
            
            self.waitingPriceLabelW.constant = size.width+3.5;
            
           NSString *currentTimeStr  = model.time;
           NSString *createTimeStr  = model.createTime2TimeStamp;
            
//            NSInteger create = [NSString timeSwitchTimestamp:createTimeStr andFormatter:@"YYYY-MM-dd HH:mm:ss"];
            
            NSInteger create = [createTimeStr integerValue] / 1000;
            /**
             1800 = 30 * 60(30分钟 时间 转秒)
             ([currentTime integerValue] - [createTime integerValue]) 剩下的时间
             */
            NSInteger currentTime = [currentTimeStr integerValue] / 1000;
            
            self.timeDifference = (1800 - (currentTime - create));
            
            [self.waitingTimeLabel setText:[NSString convertStrToTime:self.timeDifference]];
            
            
            [self setupTimer];
            
        }
            break;
        case OrderDetailsHeardCancelType:{
            
            [self.canceNameLabel setText:addressModel.name];
//            [self.cancePhoneNumberLabel setText:model.phone];
            
            [self.cancePhoneNumberLabel setText:[NSString numberSuitScanf:addressModel.phone]];
            
            [self.canceAddressLabel setText:[NSString stringWithFormat:SLLocalizedString(@"地址：%@"),addressModel.addressInfo]];
            
            [self.canceReasonLabel setText:[NSString stringWithFormat:SLLocalizedString(@"取消原因：%@"),model.cancel]];
        }
            break;
        case OrderDetailsHeardNormalType:{
            [self.normalNameLabel setText:addressModel.name];
//            [self.normalPhoneNumberLabel setText:model.phone];
            
            [self.normalPhoneNumberLabel setText:[NSString numberSuitScanf:addressModel.phone]];
            
            [self.normalAddressLabel setText:[NSString stringWithFormat:SLLocalizedString(@"地址：%@"),addressModel.addressInfo]];
            
            NSString *status = model.status;
          if ([status isEqualToString:@"2"] == YES){
                [self.normalTitleLabel setText:SLLocalizedString(@"等待发货")];
              [self.normalInstructionsLabel setText:SLLocalizedString(@"您提交了订单，耐心等候发货时间，非常感谢您的支持！")];
              [self.normalIconImageView setImage:[UIImage imageNamed:@"daishouh"]];

            }else if ([status isEqualToString:@"3"] == YES) {
                [self.normalTitleLabel setText:SLLocalizedString(@"等待收货")];
                [self.normalInstructionsLabel setText:SLLocalizedString(@"您的订单已发货，请留察物流信息，非常感谢您的支持！")];
                [self.normalIconImageView setImage:[UIImage imageNamed:@"daishouh"]];

            }else if ([status isEqualToString:@"4"] == YES ||[status isEqualToString:@"5"] == YES) {
                [self.normalTitleLabel setText:SLLocalizedString(@"完成")];
                [self.normalInstructionsLabel setText:SLLocalizedString(@"您的订单已签收，感谢您在少林购物，欢迎您再次光临！")];
                
                [self.normalIconImageView setImage:[UIImage imageNamed:@"wancheng"]];
                UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookOrdertracking)];
                      [_normalInstructionsLabel addGestureRecognizer:tapGes];
            }
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - 查看物流信息(订单已完成)
- (void)lookOrdertracking {
    if ([self.delegate respondsToSelector:@selector(lookOrderDetails:look:)]== YES) {
        [self.delegate lookOrderDetails:self look:self.model];
    }
}

- (void)deleteTimer{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)startTimer{
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
}

- (void)setType:(OrderDetailsType)type{
    
    [self.contentView removeFromSuperview];
    self.contentView = nil;
    self.viewType = type;
    
    switch (self.viewType) {
        case OrderDetailsHeardObligationType:{
            
            [self setRoundedCornersView:self.waitingAddressView corners:UIRectCornerTopLeft | UIRectCornerTopRight];
            
            self.contentView = self.waitingView;
        }
            break;
        case OrderDetailsHeardCancelType:{
            
            [self setRoundedCornersView:self.canceAddressView corners:UIRectCornerTopLeft | UIRectCornerTopRight];
            self.contentView = self.cancelView;

        }
            break;
        case OrderDetailsHeardNormalType:{
            [self setRoundedCornersView:self.normalInstructionsView corners:UIRectCornerTopLeft | UIRectCornerTopRight];
            self.contentView = self.normalView;
        }
            break;
            
        default:
            break;
    }
    
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
}

- (NSTimer *)timer{
    
    if (_timer == nil) {
        _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    }
    return _timer;

}

- (void)setOrderPrice:(NSString *)orderPrice{
    
    NSString *money = [NSString stringWithFormat:@"¥%@", orderPrice];
    
//    NSRange range = [money rangeOfString:@"."];
//
//    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:money];
//
//    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:13] range:NSMakeRange(0, 1)];
//
//    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:17] range:NSMakeRange(1, range.location-1)];
//    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:14] range:NSMakeRange(range.location, 3)];
//
//    self.waitingPriceLabel.attributedText = attrStr;
    
    
    NSAttributedString *attrStr = [money moneyStringWithFormatting:MoneyStringFormattingMoneyAllFormattingType fontArrat:@[kMediumFont(13), kMediumFont(17), kMediumFont(14)]];
    
    self.waitingPriceLabel.attributedText = attrStr;
    
    
    CGSize size = [attrStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 21) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                            context:nil].size;
    
    self.waitingPriceLabelW.constant = size.width+3.5;
    
}

@end
