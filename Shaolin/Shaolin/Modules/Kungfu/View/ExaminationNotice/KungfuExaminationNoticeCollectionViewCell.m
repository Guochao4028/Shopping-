//
//  KungfuExaminationNoticeCollectionViewCell.m
//  Shaolin
//
//  Created by 王精明 on 2020/6/2.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuExaminationNoticeCollectionViewCell.h"
#import "ExaminationNoticeModel.h"

@interface KungfuExaminationNoticeCollectionViewCell()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *activityNameLabel;
@property (nonatomic, strong) UILabel *certificateLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *telephoneLabel;
@property (nonatomic, strong) UILabel *theoryTestStartTimeLabel;
@property (nonatomic, strong) UILabel *theoryTestEndTimeLabel;
@property (nonatomic, strong) UILabel *skillTestStartTimeLabel;
@property (nonatomic, strong) UILabel *skillTestEndTimeLabel;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UIView *stateBackView;
@property (nonatomic, strong) UILabel *stateLabel;

@end

@implementation KungfuExaminationNoticeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

#pragma mark - UI
- (void)setUI{
    [self addSubview:self.backView];
    self.stateBackView = [[UIView alloc] init];
    self.stateBackView.backgroundColor = UIColor.whiteColor;
    
    [self.backView addSubview:self.imageV];
    [self.imageV addSubview:self.stateBackView];
    [self.stateBackView addSubview:self.stateLabel];
    [self.backView addSubview:self.activityNameLabel];
    [self.backView addSubview:self.certificateLabel];
    [self.backView addSubview:self.nameLabel];
    [self.backView addSubview:self.telephoneLabel];
    [self.backView addSubview:self.theoryTestStartTimeLabel];
    [self.backView addSubview:self.theoryTestEndTimeLabel];
    [self.backView addSubview:self.skillTestStartTimeLabel];
    [self.backView addSubview:self.skillTestEndTimeLabel];
    [self.backView addSubview:self.positionLabel];
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = KTextGray_E5;
    
    [self.backView addSubview:self.lineView];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat topPadding5 = SLChange(5), topPadding10 = SLChange(10), bottomPadding = SLChange(15);
    CGFloat imageHeight = SLChange(130), labelHeight = SLChange(20);
    CGSize stateLabelSize = CGSizeMake(SLChange(50), SLChange(25));
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topPadding5 + topPadding10);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(imageHeight);
    }];
    
    [self.stateBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-bottomPadding);
        make.size.mas_equalTo(stateLabelSize);
    }];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-SLChange(6));
        make.centerY.mas_equalTo(self.stateBackView);
        make.size.mas_equalTo(CGSizeMake(SLChange(36), SLChange(16.5)));
    }];
    [self.activityNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageV.mas_bottom).mas_offset(topPadding10);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(labelHeight);
    }];
    UIView *lastV = self.activityNameLabel;
    NSArray *views = @[self.certificateLabel, self.nameLabel, self.telephoneLabel, self.theoryTestStartTimeLabel, self.theoryTestEndTimeLabel, self.skillTestStartTimeLabel, self.skillTestEndTimeLabel, self.positionLabel];
    for (UIView *view in views){
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lastV.mas_bottom).mas_offset(topPadding5);
            make.left.right.mas_equalTo(lastV);
            make.height.mas_equalTo(labelHeight);
        }];
        lastV = view;
    }
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(-1);
    }];
    
    CGFloat cornerRadii = stateLabelSize.height/2;
    CGRect maskFrame = CGRectMake(0, 0, stateLabelSize.width, stateLabelSize.height);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:maskFrame byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(cornerRadii,cornerRadii)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = maskFrame;
    maskLayer.path = maskPath.CGPath;
    self.stateBackView.layer.mask = maskLayer;
}
#pragma mark - test UI
- (void)testUI{
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1142166796,2385197542&fm=26&gp=0.jpg"] placeholderImage:nil];
    [self setNewText:SLLocalizedString(@"少林友谊学校首期少林功夫段品制培训班") label:self.activityNameLabel];
    [self setNewText:@"1101138423678" label:self.certificateLabel];
    [self setNewText:SLLocalizedString(@"某某某") label:self.nameLabel];
    [self setNewText:@"13045627720" label:self.telephoneLabel];
    [self setNewText:@"2020.5.28-2020.5.31" label:self.theoryTestStartTimeLabel];
    [self setNewText:@"2020.5.28-2020.5.31" label:self.theoryTestEndTimeLabel];
    
    [self setNewText:@"2020.6.3-2020.6.8" label:self.skillTestStartTimeLabel];
    [self setNewText:@"2020.6.3-2020.6.8" label:self.skillTestEndTimeLabel];
    
    [self setNewText:SLLocalizedString(@"河南省郑州市登封市嵩山少林寺") label:self.positionLabel];
    
    if (arc4random()%2 == 0){
        self.stateLabel.text = SLLocalizedString(@"已结束");
        self.stateLabel.textColor = kMainYellow;
    } else {
        self.stateLabel.text = SLLocalizedString(@"进行中");
        self.stateLabel.textColor = KTextGray_999;
    }
}

#pragma mark - getter UI
- (UIView *)backView{
    if (!_backView){
        _backView = [[UIView alloc] init];
    }
    return _backView;
}

- (UIImageView *)imageV{
    if (!_imageV){
        _imageV = [[UIImageView alloc] init];
        _imageV = [[UIImageView alloc] init];
        _imageV.layer.masksToBounds = YES;
        _imageV.layer.cornerRadius = 4;
        _imageV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageV;
}

- (UILabel *)createLabel{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = KTextGray_333;
    label.font = kRegular(14);
    return label;
}

- (UILabel *)activityNameLabel{
    if (!_activityNameLabel){
        _activityNameLabel = [self createLabel];
        _activityNameLabel.textColor = [UIColor colorForHex:@"0A0809"];
        _activityNameLabel.text = SLLocalizedString(@"活动名称：");
    }
    return _activityNameLabel;
}

- (UILabel *)certificateLabel{
    if (!_certificateLabel){
        _certificateLabel = [self createLabel];
        _certificateLabel.text = SLLocalizedString(@"准考证号：");
    }
    return _certificateLabel;
}

- (UILabel *)nameLabel{
    if (!_nameLabel){
        _nameLabel = [self createLabel];
        _nameLabel.text = SLLocalizedString(@"联 系 人：");
    }
    return _nameLabel;
}

- (UILabel *)telephoneLabel{
    if (!_telephoneLabel){
        _telephoneLabel = [self createLabel];
        _telephoneLabel.text = SLLocalizedString(@"联系方式：");
    }
    return _telephoneLabel;
}

- (UILabel *)theoryTestStartTimeLabel{
    if (!_theoryTestStartTimeLabel){
        _theoryTestStartTimeLabel = [self createLabel];
        _theoryTestStartTimeLabel.text = SLLocalizedString(@"理论考试时间：");
    }
    return _theoryTestStartTimeLabel;
}

- (UILabel *)theoryTestEndTimeLabel{
    if (!_theoryTestEndTimeLabel){
        _theoryTestEndTimeLabel = [self createLabel];
        _theoryTestEndTimeLabel.text = SLLocalizedString(@"理论结束时间：");
    }
    return _theoryTestEndTimeLabel;
}

- (UILabel *)skillTestStartTimeLabel{
    if (!_skillTestStartTimeLabel){
        _skillTestStartTimeLabel = [self createLabel];
        _skillTestStartTimeLabel.text = SLLocalizedString(@"技术考试时间：");
    }
    return _skillTestStartTimeLabel;
}

- (UILabel *)skillTestEndTimeLabel{
    if (!_skillTestEndTimeLabel){
        _skillTestEndTimeLabel = [self createLabel];
        _skillTestEndTimeLabel.text = SLLocalizedString(@"技术结束时间：");
    }
    return _skillTestEndTimeLabel;
}

- (UILabel *)positionLabel{
    if (!_positionLabel){
        _positionLabel = [self createLabel];
        _positionLabel.text = SLLocalizedString(@"考试地点：");
    }
    return _positionLabel;
}

- (UILabel *)stateLabel{
    if (!_stateLabel){
        _stateLabel = [self createLabel];
        _stateLabel.font = kRegular(12);
    }
    return _stateLabel;
}
#pragma mark - setter
- (void)setModel:(ExaminationNoticeModel *)model{
    _model = model;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.mechanismImg] placeholderImage:nil];
    [self setNewText:model.activityName label:self.activityNameLabel];
    [self setNewText:model.accurateNumber label:self.certificateLabel];
    [self setNewText:model.contacts label:self.nameLabel];
    [self setNewText:model.phone label:self.telephoneLabel];
    
    [self setNewText:model.addressName label:self.positionLabel];
    
//    [self setNewText:model.writeExamStartTime label:self.theoryTestStartTimeLabel];
//    [self setNewText:model.writeExamEndTime label:self.theoryTestEndTimeLabel];
//
//    [self setNewText:model.skillExamStartTime label:self.skillTestStartTimeLabel];
//    [self setNewText:model.skillExamEndTime label:self.skillTestEndTimeLabel];
    
    
    
    [self setNewText:[self formatterTime:model.writeExamStartTime] label:self.theoryTestStartTimeLabel];
       [self setNewText:[self formatterTime:model.writeExamEndTime] label:self.theoryTestEndTimeLabel];
       
       [self setNewText:[self formatterTime:model.skillExamStartTime] label:self.skillTestStartTimeLabel];
       [self setNewText: [self formatterTime:model.skillExamEndTime] label:self.skillTestEndTimeLabel];
   

    if ([model.resultsApplication isEqualToString:@"2"]){
        self.stateLabel.text = SLLocalizedString(@"进行中");
        self.stateLabel.textColor = kMainYellow;
    } else {
        self.stateLabel.text = SLLocalizedString(@"已结束");
        self.stateLabel.textColor = KTextGray_999;
    }
}

- (void)setNewText:(NSString *)text label:(UILabel *)label{
    NSArray *array = [label.text componentsSeparatedByString:@"："];
    if (array.count > 1){
        label.text = [NSString stringWithFormat:@"%@：%@", array.firstObject, text];
    } else {
        label.text = text;
    }
}

-(NSString *)formatterTime:(NSString *)timeStr{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    NSDate *date = [formatter dateFromString:timeStr];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal fromDate:date];
    
    NSString *toTime =  [NSString stringWithFormat:@"%ld.%02ld.%02ld %02ld:%02ld",components.year,components.month,components.day, components.hour, components.minute];
    return toTime;
}



@end
