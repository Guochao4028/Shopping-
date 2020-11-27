//
//  RealNameSuccessViewController.m
//  Shaolin
//
//  Created by 王精明 on 2020/9/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RealNameSuccessViewController.h"
#import "NSString+Tool.h"

@interface RealNameSuccessViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImageView *successImageView;
@property (nonatomic, strong) UILabel *successLabel;
@property (nonatomic, strong) UILabel *realNameLabel;
@property (nonatomic, strong) UILabel *idCardLabel;
@property (nonatomic, strong) UILabel *tipsLabel;
@end

@implementation RealNameSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabe.text = @"";
    NSString *idCardType = [self getIdCardType];
    if ([idCardType isEqualToString:@"1"]){
        self.titleLabe.text = SLLocalizedString(@"身份证认证");
    } else if ([idCardType isEqualToString:@"2"]){
        self.titleLabe.text = SLLocalizedString(@"护照认证");
    }
    [self setUI];
    [self reloadView];
    // Do any additional setup after loading the view.
}

- (void)setParams:(NSDictionary *)params{
    _params = params;
    [self reloadView];
}

- (void)reloadView{
    if (_collectionView){
        [self.collectionView reloadData];
    }
    NSString *idCardType = [self getIdCardType];
    NSString *idCard = [self getIdcard];
    NSString *realName = [self getRealname];
    if (!realName.length || !idCard.length || !idCardType.length) return;
    realName = [NSString nameDataMasking:realName];
    idCard = [NSString idCardDataMasking:idCard];
    NSString *idCardText = @"";
    if ([idCardType isEqualToString:@"1"]){
        idCardText = SLLocalizedString(@"身份证号码");
    } else {
        idCardText = SLLocalizedString(@"护照号码");
    }
    self.realNameLabel.text = [NSString stringWithFormat:@"%@：%@", SLLocalizedString(@"真实姓名"), realName];
    self.idCardLabel.text = [NSString stringWithFormat:@"%@：%@", idCardText, idCard];
}
#pragma mark - UI
- (void)setUI{
//    [self.view addSubview:self.collectionView];
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(0);
//    }];
    [self.view addSubview:self.successImageView];
    [self.view addSubview:self.successLabel];
    [self.view addSubview:self.realNameLabel];
    [self.view addSubview:self.idCardLabel];
    [self.view addSubview:self.tipsLabel];
    
    [self.successImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(147);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.successImageView.mas_bottom).mas_equalTo(22);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
    }];
    
    [self.realNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.successLabel.mas_bottom).mas_equalTo(32);
        make.left.right.mas_equalTo(self.successLabel);
    }];
    
    [self.idCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.realNameLabel.mas_bottom).mas_equalTo(10);
        make.left.right.mas_equalTo(self.successLabel);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.idCardLabel.mas_bottom).mas_equalTo(45);
        make.left.right.mas_equalTo(self.successLabel);
    }];
}

- (UILabel *)createLabel:(UIView *)parentView tag:(NSInteger)tag{
    UILabel *label = [[UILabel alloc] init];
    label.tag = tag;
    label.font = kRegular(15);
    label.textColor = KTextGray_333;
    if (parentView){
        [parentView addSubview:label];
    }
    return label;
}

- (UIView *)lineView:(UIView *)parentView tag:(NSInteger)tag{
    UIView *view = [[UIView alloc] init];
    view.tag = tag;
    view.backgroundColor = KTextGray_E5;
    [parentView addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.bottom.mas_equalTo(-0.5);
        make.height.mas_equalTo(0.5);
        make.right.mas_equalTo(0);
    }];
    return view;
}

#pragma mark - UICollectionView Delegate && dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger verifiedState = [[self getVerifiedState] integerValue];
    if (verifiedState == 1)//0未认证 1已认证 2认证中 3认证失败
        return 2;
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    NSInteger firstViewTag = 100, secondViewTag = firstViewTag+1, lineTag = secondViewTag+1;
    UILabel *firstLabel = [cell viewWithTag:firstViewTag];
    UILabel *secondLabel = [cell viewWithTag:secondViewTag];
    if (!firstLabel) {
        firstLabel = [self createLabel:cell tag:firstViewTag];
        firstLabel.textColor = KTextGray_999;
        [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.width.mas_equalTo(90);
            make.centerY.mas_equalTo(cell);
        }];
    }
    if (!secondLabel) {
        secondLabel = [self createLabel:cell tag:secondViewTag];
        [secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(firstLabel.mas_right).mas_equalTo(5);
            make.centerY.mas_equalTo(cell);
        }];
    }
    if (indexPath.row == 0){
        NSString *realName = [NSString nameDataMasking:[self getRealname]];
        firstLabel.text = [NSString stringWithFormat:@"%@：", SLLocalizedString(@"姓名")];
        secondLabel.text = realName;
        
    } else if (indexPath.row == 1){
        NSString *idCardType = [self getIdCardType];
        NSString *idCard = [NSString idCardDataMasking:[self getIdcard]];
        NSString *idCardText = @"";
        if ([idCardType isEqualToString:@"1"]){
            idCardText = [NSString stringWithFormat:@"%@：", SLLocalizedString(@"身份证号")];
        } else {
            idCardText = [NSString stringWithFormat:@"%@：", SLLocalizedString(@"护照号码")];
        }
        firstLabel.text = idCardText;
        secondLabel.text = idCard;
    }
    UIView *line = [cell viewWithTag:lineTag];
    if (!line) line = [self lineView:cell tag:lineTag];
    return cell;
}

#pragma mark - getter
- (NSString *)getVerifiedState{
    if (self.params && NotNilAndNull([self.params objectForKey:@"verifiedState"])){
        return [self.params objectForKey:@"verifiedState"];
    }
    return  [SLAppInfoModel sharedInstance].verifiedState;
}

- (NSString *)getIdCardType{
    if (self.params && NotNilAndNull([self.params objectForKey:@"idCard_type"])){
        return [self.params objectForKey:@"idCard_type"];
    }
    return  [SLAppInfoModel sharedInstance].idCard_type;
}

- (NSString *)getIdcard{
    if (self.params && NotNilAndNull([self.params objectForKey:@"idcard"])){
        return [self.params objectForKey:@"idcard"];
    }
    return  [SLAppInfoModel sharedInstance].idcard;
}

- (NSString *)getRealname{
    if (self.params && NotNilAndNull([self.params objectForKey:@"realname"])){
        return [self.params objectForKey:@"realname"];
    }
    return  [SLAppInfoModel sharedInstance].realname;
}

- (UICollectionView *)collectionView{
    if (!_collectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(self.view.width, 51);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.layer.backgroundColor = [UIColor whiteColor].CGColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    }
    return _collectionView;
}

- (UIImageView *)successImageView{
    if (!_successImageView){
        _successImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RealNameSuccessYellow"]];
        _successImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _successImageView;
}

- (UILabel *)successLabel{
    if (!_successLabel){
        _successLabel = [self createLabel:nil tag:-1];
        _successLabel.font = kRegular(20);
        _successLabel.textAlignment = NSTextAlignmentCenter;
        _successLabel.text = SLLocalizedString(@"实名认证已完成");
    }
    return _successLabel;
}

- (UILabel *)realNameLabel{
    if (!_realNameLabel){
        _realNameLabel = [self createLabel:nil tag:-1];
        _realNameLabel.font = kRegular(16);
        _realNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _realNameLabel;
}

- (UILabel *)idCardLabel{
    if (!_idCardLabel){
        _idCardLabel = [self createLabel:nil tag:-1];
        _idCardLabel.font = kRegular(16);
        _idCardLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _idCardLabel;
}

- (UILabel *)tipsLabel{
    if (!_tipsLabel){
        _tipsLabel = [self createLabel:nil tag:-1];
        _tipsLabel.font = kRegular(15);
        _tipsLabel.textColor = kMainYellow;
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.text = [NSString stringWithFormat:@"*%@", SLLocalizedString(@"实名认证后不可修改")];
    }
    return _tipsLabel;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
