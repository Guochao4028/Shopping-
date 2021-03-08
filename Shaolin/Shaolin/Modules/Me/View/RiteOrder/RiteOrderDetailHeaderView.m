//
//  RiteOrderDetailHeaderView.m
//  Shaolin
//
//  Created by 郭超 on 2020/7/31.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RiteOrderDetailHeaderView.h"
#import "OrderDetailsModel.h"
#import "NSString+Tool.h"
#import "OrderDetailsNewModel.h"

@interface RiteOrderDetailHeaderView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;


@property (weak, nonatomic) IBOutlet UIImageView *statusIcon;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payBtnH;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *contactView;

@property(nonatomic, strong)dispatch_source_t timer;

@end

@implementation RiteOrderDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"RiteOrderDetailHeaderView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

/// 初始化UI
- (void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];

    [self.bgView setBackgroundColor:kMainYellow];
    [self setBackgroundColor:kMainYellow];

    
    [self setRoundedCornersView:self.contactView corners:UIRectCornerTopLeft | UIRectCornerTopRight];

}

- (IBAction)payHandle:(UIButton *)sender {
    if (self.payHandle) {
        self.payHandle();
    }
}

//设置圆角
- (void)setRoundedCornersView:(UIView *)view corners:(UIRectCorner)corners{
    UIBezierPath* maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(10, 10)];
    maskPath.lineWidth     = 0.f;
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

- (void)setDetailsModel:(OrderDetailsNewModel *)detailsModel {
    _detailsModel = detailsModel;
    
    NSString * nameStr ;
    NSString * telephoneStr ;
    
    OrderAddressModel *addressModel = detailsModel.address;
    
    
    nameStr = addressModel.name;
    telephoneStr = addressModel.phone;
    
    
    if (nameStr.length == 0) {
//        nameStr = [SLAppInfoModel sharedInstance].realName;
        nameStr = [SLAppInfoModel sharedInstance].nickName;
        telephoneStr = [SLAppInfoModel sharedInstance].phoneNumber;
    }
    
    
    
    self.nameLabel.text = NotNilAndNull(nameStr)?nameStr:@"";
//    self.phoneLabel.text = NotNilAndNull(telephoneStr)?telephoneStr:@"";
    
    self.phoneLabel.text = [NSString numberSuitScanf:telephoneStr];
    
    NSInteger status = [detailsModel.status integerValue];
    
    /**
     判断 法会 是否需要有回执，有回执 需要有回执布局
     */
    if ([detailsModel.needReturnReceipt boolValue]) {
        
        if (status == 1){
            [self p_HasReturnReceiptobligation];
        }else if (status == 6 || status == 7 ){
            [self cancelLayout];
        }else if (status == 4 || status == 5){
            [self completeLayout];
        }
    }else{
        if (status == 1)
        {
            [self obligationLayout];
    //        NSString *currentTime  = detailsModel.time;
    //        NSString *createTimeStr  = detailsModel.createTime;
    //
    //        NSInteger create = [NSString timeSwitchTimestamp:createTimeStr andFormatter:@"YYYY-MM-dd HH:mm:ss"];
    //        /**
    //         1800 = 30 * 60(30分钟 时间 转秒)
    //         ([currentTime integerValue] - [createTime integerValue]) 剩下的时间
    //         */
            
//            NSString *currentTimeStr  = detailsModel.time;
//            NSString *createTimeStr  = detailsModel.createTime2TimeStamp;
//
//    //            NSInteger create = [NSString timeSwitchTimestamp:createTimeStr andFormatter:@"YYYY-MM-dd HH:mm:ss"];
//
//             NSInteger createTime = [createTimeStr integerValue] / 1000;
//             /**
//              1800 = 30 * 60(30分钟 时间 转秒)
//              ([currentTime integerValue] - [createTime integerValue]) 剩下的时间
//              */
//             NSInteger currentTime = [currentTimeStr integerValue] / 1000;
//
//
//
//
//            NSInteger timeDifference = ((30 * 60) - (currentTime - createTime));
//            [self timerFireWithTimeLeft:timeDifference];
            
            self.contentLabel.text = [NSString stringWithFormat:@"需付款：%@ ",[self.detailsModel.money formattingPriceString]];
            
        }else if (status == 6 || status == 7 )
        {
            if (self.timer) {
                dispatch_source_cancel(self.timer);
            }
            [self cancelLayout];
        }else if (status == 4 || status == 5)
        {
            [self completeLayout];
        }
    }
    
    
    
}

- (void)timerFireWithTimeLeft:(NSInteger)timeLeft {
    
    //设置倒计时时间
    __block NSInteger timeout = timeLeft;
    dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, global);
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.timer, ^{
        timeout --;
        if (timeout <= 0) {
            //关闭定
            dispatch_source_cancel(self.timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.timeOutHandle) {
                    self.timeOutHandle();
                }
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString * title;
                if (timeout > 60) {
                    title = [NSString stringWithFormat:@"%d分钟%ld秒",(int)timeout/60,timeout%60];
                } else {
                    title = [NSString stringWithFormat:@"%ld秒",(long)timeout];
                }
                self.contentLabel.text = [NSString stringWithFormat:@"需付款：¥%@  剩余：%@",self.detailsModel.money,title];
            });
        }
    });
    
    dispatch_resume(self.timer);
}


- (void) obligationLayout {
    self.statusIcon.image = [UIImage imageNamed:@"Waiting"];
    self.statusLabel.text = @"等待支付";
    
    self.payBtn.hidden = NO;
    
    self.payBtnH.constant = 40;
    
    self.contentLabel.text = [NSString stringWithFormat:@"需付款：¥%@  剩余：1分钟",self.detailsModel.money];
}


- (void) p_HasReturnReceiptobligation {
    self.statusIcon.image = [UIImage imageNamed:@"Waiting"];
    self.statusLabel.text = @"等待支付";
    
    self.payBtn.hidden = YES;
    
    self.payBtnH.constant = 0;
    
    self.contentLabel.text = [NSString stringWithFormat:@"需付款：%@ ",[self.detailsModel.money formattingPriceString]];
    
    
    [self.contentLabel setHidden:![self.detailsModel.payable boolValue]];
}


- (void) cancelLayout {
    self.statusIcon.image = [UIImage imageNamed:@"warning-circle"];
    self.statusLabel.text = @"已取消";
    
    self.payBtn.hidden = YES;
    
    self.contentLabel.text = [NSString stringWithFormat:@"取消原因：%@",self.detailsModel.cancel];
}

- (void) completeLayout{
    self.statusIcon.image = [UIImage imageNamed:@"wancheng"];
    self.statusLabel.text = @"完成";

    self.payBtn.hidden = YES;
    
    self.contentLabel.text = @"";
}

@end
