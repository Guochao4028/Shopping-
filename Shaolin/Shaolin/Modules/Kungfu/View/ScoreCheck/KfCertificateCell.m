//
//  KfCertificateCell.m
//  Shaolin
//
//  Created by ws on 2020/5/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KfCertificateCell.h"
#import "CertificateModel.h"

@interface KfCertificateCell()

@property (weak, nonatomic) IBOutlet UIView *cellLine;

@property (weak, nonatomic) IBOutlet UIImageView *cerImgv;
@property (weak, nonatomic) IBOutlet UILabel *cerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *finishedLabel;

@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet UIButton *cerGetBtn;

@end

@implementation KfCertificateCell

- (void)drawArc:(CGContextRef)context
{
  
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)detailHandle:(UIButton *)sender {
    if (self.detailHandle) {
        self.detailHandle();
    }
}

- (IBAction)cerGetHandle:(UIButton *)sender {
    if (self.receiveHandle) {
        self.receiveHandle([self.cellModel.state intValue]);
    }
}

-(void)setCellModel:(CertificateModel *)cellModel {
    _cellModel = cellModel;
    
//    self.cerGetBtn.userInteractionEnabled = YES;
    
    [self.cerImgv sd_setImageWithURL:[NSURL URLWithString:cellModel.certificateUrl] placeholderImage:[UIImage imageNamed:@"default_small"]];
    self.cerNameLabel.text = [NSString stringWithFormat:SLLocalizedString(@"段品制%@证书"),cellModel.levelName];
    
    if (NotNilAndNull(cellModel.createTime)) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDate * date = [formatter dateFromString:cellModel.createTime];
        
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        [formatter2 setDateFormat:SLLocalizedString(@"yyyy年MM月dd日")];
        
        NSString *time = [formatter2 stringFromDate:date];
        self.timeLabel.text = [NSString stringWithFormat:SLLocalizedString(@"授段时间：%@"),time];
    }
    
/*
   int state = [cellModel.state intValue];
    
    if (state == 0) {
        self.finishedLabel.text = SLLocalizedString(@"未领取实物证书");
        self.finishedLabel.textColor = KPriceRed;
        [self.cerGetBtn setTitleColor:KTextGray_333 forState:UIControlStateNormal];
        self.cerGetBtn.userInteractionEnabled = YES;
        [self.cerGetBtn setTitle:SLLocalizedString(@"领取证书") forState:UIControlStateNormal];
    } else if(state == 1){
//        self.finishedLabel.text = SLLocalizedString(@"等待发送实物证书");
        self.finishedLabel.text = SLLocalizedString(@"已申请实物证书");
        self.finishedLabel.textColor = KTextGray_999;
        [self.cerGetBtn setTitleColor:KTextGray_999 forState:UIControlStateNormal];
        [self.cerGetBtn setTitle:SLLocalizedString(@"待发证") forState:UIControlStateNormal];
        self.cerGetBtn.userInteractionEnabled = NO;
    }else if(state == 2){
//            self.finishedLabel.text = SLLocalizedString(@"已经发送实物证书");
        self.finishedLabel.text = SLLocalizedString(@"已申请实物证书");
            self.finishedLabel.textColor = KTextGray_999;
            [self.cerGetBtn setTitleColor:KTextGray_333 forState:UIControlStateNormal];
            [self.cerGetBtn setTitle:SLLocalizedString(@"查看物流") forState:UIControlStateNormal];
        self.cerGetBtn.userInteractionEnabled = YES;
        }else if(state == 3){
//                self.finishedLabel.text = SLLocalizedString(@"已领取实物证书");
                self.finishedLabel.text = SLLocalizedString(@"已领取");
                self.finishedLabel.textColor = KTextGray_999;
                [self.cerGetBtn setTitleColor:KTextGray_999 forState:UIControlStateNormal];
                [self.cerGetBtn setTitle:SLLocalizedString(@"已领取") forState:UIControlStateNormal];
                self.cerGetBtn.userInteractionEnabled = NO;
            }
    
*/
}



@end
