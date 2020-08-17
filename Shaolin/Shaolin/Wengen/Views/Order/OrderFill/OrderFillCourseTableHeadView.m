//
//  OrderFillCourseTableHeadView.m
//  Shaolin
//
//  Created by 郭超 on 2020/6/4.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderFillCourseTableHeadView.h"
#import "NSString+Tool.h"


@interface OrderFillCourseTableHeadView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;

@end

@implementation OrderFillCourseTableHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"OrderFillCourseTableHeadView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

-(void)initUI{
    
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
    
    SLAppInfoModel *model = [SLAppInfoModel sharedInstance];
    
    if (model.nickname.length > 0) {
        [self.nameLabel setText:model.nickname];
    }else{
        [self.nameLabel setText:model.realname];
    }
    
    [self.phoneNumberLabel setText:[NSString numberSuitScanf:model.phoneNumber]];
}




@end
