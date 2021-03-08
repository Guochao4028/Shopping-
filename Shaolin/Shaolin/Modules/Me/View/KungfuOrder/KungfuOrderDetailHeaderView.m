//
//  KungfuOrderDetailHeaderView.m
//  Shaolin
//
//  Created by ws on 2020/5/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuOrderDetailHeaderView.h"
#import "OrderDetailsModel.h"
#import "NSString+Tool.h"

#import "OrderDetailsNewModel.h"

@interface KungfuOrderDetailHeaderView()

@property (weak, nonatomic) IBOutlet UIImageView *statusIcon;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property(nonatomic, strong)dispatch_source_t timer;

@end

@implementation KungfuOrderDetailHeaderView

+(instancetype)loadXib{
    return (KungfuOrderDetailHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"KungfuOrderDetailHeaderView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (IBAction)payHandle:(UIButton *)sender {
    if (self.payHandle) {
        self.payHandle();
    }
}

- (void)setDetailsModel:(OrderDetailsNewModel *)detailsModel {
    _detailsModel = detailsModel;
    
    NSString * nameStr ;
    NSString * telephoneStr ;
    
    OrderAddressModel *addressModel = detailsModel.address;
    nameStr = addressModel.name;
    telephoneStr = addressModel.phone;
    
    OrderDetailsGoodsModel *goodsModel = [detailsModel.goods firstObject];


    if ([goodsModel.type intValue] == 3) {
        // 活动
//        nameStr = detailsModel.order_user_realName;
//        telephoneStr = detailsModel.order_user_telephone;

        if (nameStr.length == 0) {
            nameStr = [SLAppInfoModel sharedInstance].realName;
            telephoneStr = [SLAppInfoModel sharedInstance].phoneNumber;
        }
    } else {
        
        if (nameStr.length == 0) {
            nameStr = [SLAppInfoModel sharedInstance].nickName;
            telephoneStr = [SLAppInfoModel sharedInstance].phoneNumber;
        }
    }
    
   
    
    self.nameLabel.text = NotNilAndNull(nameStr)?nameStr:@"";
//    self.phoneLabel.text = NotNilAndNull(telephoneStr)?telephoneStr:@"";
    
    self.phoneLabel.text = [NSString numberSuitScanf:telephoneStr];
    
    if ([detailsModel.status isEqualToString:@"1"])
    {
        [self obligationLayout];
//        NSString *currentTime  = detailsModel.time;
//        NSString *createTimeStr  = detailsModel.create_time;
        
        NSString *currentTimeStr  = detailsModel.time;
        NSString *createTimeStr  = detailsModel.createTime2TimeStamp;
        
//        NSInteger create = [NSString timeSwitchTimestamp:createTimeStr andFormatter:@"YYYY-MM-dd HH:mm:ss"];
        
        NSInteger currentTime = [currentTimeStr integerValue] / 1000;
        NSInteger createTime = [createTimeStr integerValue] / 1000;
        /**
         1800 = 30 * 60(30分钟 时间 转秒)
         ([currentTime integerValue] - [createTime integerValue]) 剩下的时间
         */
        /**
         教程和商品 是30分钟
         活动和法会 是2个小时  120分钟
         */
        ///1：实物，2：教程，3：报名，5:法事佛事类型-法会，6:法事佛事类型-佛事， 7:法事佛事类型-建寺供僧
//        NSInteger timeDifference = (1800 - ([currentTime integerValue] - create));
//        if ([detailsModel.type intValue] == 3) {
//            timeDifference =((120 * 60) - ([currentTime integerValue] - create));
//        }
        
        NSInteger timeDifference = ((30 * 60) - (currentTime - createTime));
        [self timerFireWithTimeLeft:timeDifference];
        
    }else if ([detailsModel.status isEqualToString:@"6"]
              || [detailsModel.status isEqualToString:@"7"] )
    {
        if (self.timer) {
            dispatch_source_cancel(self.timer);
        }
        [self cancelLayout];
    }else if ([detailsModel.status isEqualToString:@"4"]
              ||[detailsModel.status isEqualToString:@"5"])
    {
        [self completeLayout];
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
                    title = [NSString stringWithFormat:SLLocalizedString(@"%d分钟%ld秒"),(int)timeout/60,timeout%60];
                } else {
                    title = [NSString stringWithFormat:SLLocalizedString(@"%ld秒"),(long)timeout];
                }
                self.contentLabel.text = [NSString stringWithFormat:SLLocalizedString(@"需付款：¥%@  剩余：%@"),self.detailsModel.money,title];
            });
        }
    });
    
    dispatch_resume(self.timer);
}


- (void) obligationLayout {
    self.statusIcon.image = [UIImage imageNamed:@"Waiting"];
    self.statusLabel.text = SLLocalizedString(@"等待支付");
    
    self.payBtn.hidden = NO;
    
    self.contentLabel.text = [NSString stringWithFormat:SLLocalizedString(@"需付款：¥%@  剩余：1分钟"),self.detailsModel.money];
}

- (void) cancelLayout {
    self.statusIcon.image = [UIImage imageNamed:@"warning-circle"];
    self.statusLabel.text = SLLocalizedString(@"已取消");
    
    self.payBtn.hidden = YES;
    
    NSString *cannel = self.detailsModel.cancel.length == 0? @"支付超时": self.detailsModel.cancel;
    
    self.contentLabel.text = [NSString stringWithFormat:SLLocalizedString(@"取消原因：%@"),cannel];
    
}

- (void) completeLayout{
    self.statusIcon.image = [UIImage imageNamed:@"wancheng"];
    self.statusLabel.text = SLLocalizedString(@"完成");

    self.payBtn.hidden = YES;
    
    self.contentLabel.text = @"";
}

@end
