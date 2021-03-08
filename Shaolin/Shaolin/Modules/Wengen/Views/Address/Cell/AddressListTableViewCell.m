//
//  AddressListTableViewCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/2.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "AddressListTableViewCell.h"
#import "AddressListModel.h"
#import "NSString+Tool.h"

@interface AddressListTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *addressNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIView *defaultView;

- (IBAction)tapButtonAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *defaultImageViewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *intervalW;
@property (weak, nonatomic) IBOutlet UIImageView *defaultImageView;

@end

@implementation AddressListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.defaultView.layer.cornerRadius = SLChange(4);
    
    [self.defaultView setHidden:YES];
    
    [self.defaultImageView setHidden:YES];
    self.intervalW.constant = 0;
    self.defaultImageViewW.constant = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(AddressListModel *)model{
    _model = model;
    
    [self.addressNameLabel setText:model.realname];
    [self.addressPhoneLabel setText:[NSString numberSuitScanf:model.phone]];
    
    NSString *status = model.status;
    
    if ([status isEqualToString:@"1"] == YES) {
        [self.defaultView setHidden:NO];
    }else{
        [self.defaultView setHidden:YES];
    }
    
    if (model.isSelected == YES) {
        [self.defaultImageView setHidden:NO];
        self.intervalW.constant = 8;
        self.defaultImageViewW.constant = 16;
    }else{
        [self.defaultImageView setHidden:YES];
        self.intervalW.constant = 0;
        self.defaultImageViewW.constant = 0;
    }
    
    NSMutableString *addressStr = [NSMutableString string];
    
    if (NotNilAndNull(model.countryS)) {
        if ([model.countryS isEqualToString:SLLocalizedString(@"中国")] == NO) {
            [addressStr appendString:[NSString stringWithFormat:@"%@ ", model.countryS]];
        }
    }
    
    
    if (NotNilAndNull(model.provinceS)) {
       [addressStr appendString:[NSString stringWithFormat:@"%@", model.provinceS]];
    }
    
    if (NotNilAndNull(model.cityS)) {
       [addressStr appendString:[NSString stringWithFormat:@" %@",model.cityS]];
    }
    if (NotNilAndNull(model.reS)) {
        [addressStr appendString:[NSString stringWithFormat:@" %@",model.reS]];
    }
    if (NotNilAndNull(model.address)) {
        [addressStr appendString:[NSString stringWithFormat:@" %@",model.address]];
    }
    [self.addressLabel setText:addressStr];
}

- (IBAction)tapButtonAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(addressListCell:tap:)] == YES) {
        [self.delegate addressListCell:self tap:self.model];
    }
}


@end
