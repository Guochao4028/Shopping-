//
//  EnrollmentRegistrationCollectionViewCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/6/1.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "EnrollmentRegistrationCollectionViewCell.h"

#import "EnrollmentAddressModel.h"

#import "AddressInfoModel.h"

#import "DegreeNationalDataModel.h"

@interface EnrollmentRegistrationCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation EnrollmentRegistrationCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setDataModel:(NSDictionary *)dataModel{
    _dataModel = dataModel;
    [self.lineLabel setHidden:YES];
    NSString *color = dataModel[@"color"];
    [self.titleLabel setFont:kRegular(14)];
    [self.titleLabel setBackgroundColor:[UIColor colorForHex:@"FAFAFA"]];
    
    [self.titleLabel.layer setMasksToBounds:YES];
    [self.titleLabel.layer setCornerRadius:15];
    
    if ([color boolValue]) {
        [self.titleLabel setTextColor:[UIColor colorForHex:@"BE0000"]];
        self.titleLabel.layer.borderWidth = 1;
        self.titleLabel.layer.borderColor = [UIColor colorForHex:@"BE0000"].CGColor;
        
        
    }else{
        [self.titleLabel setTextColor:[UIColor colorForHex:@"999999"]];
        self.titleLabel.layer.borderWidth = 0;
        self.titleLabel.layer.backgroundColor = [UIColor colorForHex:@"999999"].CGColor;
    }
    
    [self.titleLabel setText:dataModel[@"name"]];
    
}

-(void)setAddressModel:(EnrollmentAddressModel *)addressModel{
    _addressModel = addressModel;
    
    [self.titleLabel setTextColor:[UIColor colorForHex:@"999999"]];
    self.titleLabel.layer.borderWidth = 0;
    self.titleLabel.layer.borderColor = [UIColor colorForHex:@"999999"].CGColor;
    
    [self.titleLabel.layer setMasksToBounds:YES];
    [self.titleLabel.layer setCornerRadius:0];
    self.titleLabel.layer.backgroundColor = [UIColor whiteColor].CGColor;
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setFont:kRegular(15)];
    [self.lineLabel setHidden:NO];
     [self.titleLabel setTextColor:[UIColor colorForHex:@"333333"]];
    [self.titleLabel setText:addressModel.addressDetails];
    
}

-(void)setAddressInfoModel:(AddressInfoModel *)addressInfoModel{
    _addressInfoModel = addressInfoModel;
       
       [self.titleLabel setTextColor:[UIColor colorForHex:@"999999"]];
       self.titleLabel.layer.borderWidth = 0;
       self.titleLabel.layer.borderColor = [UIColor colorForHex:@"999999"].CGColor;
       
       [self.titleLabel.layer setMasksToBounds:YES];
       [self.titleLabel.layer setCornerRadius:0];
       self.titleLabel.layer.backgroundColor = [UIColor whiteColor].CGColor;
       [self.titleLabel setBackgroundColor:[UIColor clearColor]];
       [self.titleLabel setFont:kRegular(15)];
       [self.lineLabel setHidden:NO];
        [self.titleLabel setTextColor:[UIColor colorForHex:@"333333"]];
    [self.titleLabel setText:addressInfoModel.cname];
}


-(void)setDataInfoModel:(DegreeNationalDataModel *)dataInfoModel{
    _dataInfoModel = dataInfoModel;
          
          [self.titleLabel setTextColor:[UIColor colorForHex:@"999999"]];
          self.titleLabel.layer.borderWidth = 0;
          self.titleLabel.layer.borderColor = [UIColor colorForHex:@"999999"].CGColor;
          
          [self.titleLabel.layer setMasksToBounds:YES];
          [self.titleLabel.layer setCornerRadius:0];
          self.titleLabel.layer.backgroundColor = [UIColor whiteColor].CGColor;
          [self.titleLabel setBackgroundColor:[UIColor clearColor]];
          [self.titleLabel setFont:kRegular(15)];
          [self.lineLabel setHidden:NO];
           [self.titleLabel setTextColor:[UIColor colorForHex:@"333333"]];
       [self.titleLabel setText:dataInfoModel.name];
}

-(void)setTitleStr:(NSString *)titleStr{
    
    [self.titleLabel setTextColor:[UIColor colorForHex:@"999999"]];
       self.titleLabel.layer.borderWidth = 0;
       self.titleLabel.layer.borderColor = [UIColor colorForHex:@"999999"].CGColor;
       
       [self.titleLabel.layer setMasksToBounds:YES];
       [self.titleLabel.layer setCornerRadius:0];
       self.titleLabel.layer.backgroundColor = [UIColor whiteColor].CGColor;
       [self.titleLabel setBackgroundColor:[UIColor clearColor]];
       [self.titleLabel setFont:kRegular(15)];
       [self.lineLabel setHidden:NO];
        [self.titleLabel setTextColor:[UIColor colorForHex:@"333333"]];
    [self.titleLabel setText:titleStr];
}

@end
