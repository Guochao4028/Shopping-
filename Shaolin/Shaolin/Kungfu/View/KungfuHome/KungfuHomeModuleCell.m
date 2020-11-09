//
//  KungfuHomeModuleCell.m
//  Shaolin
//
//  Created by ws on 2020/5/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuHomeModuleCell.h"
#import "KungfuHomeModuleCollectionCell.h"
#import "SLRouteManager.h"

static NSString *const moduleCollectionCellId = @"KungfuHomeModuleCollectionCell";

@interface KungfuHomeModuleCell () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) NSArray * titleList;
@property (nonatomic, strong) NSArray * iconList;

@end

@implementation KungfuHomeModuleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.collectionView];
    }
    return self;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titleList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    KungfuHomeModuleCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:moduleCollectionCellId forIndexPath:indexPath];
         
     
    cell.imageIcon.image = [UIImage imageNamed:self.iconList[indexPath.row]];
    cell.nameLabel.text = self.titleList[indexPath.row];
    cell.messageNum = @"";
    
    if (indexPath.row == 5) {
//        cell.messageNum = @"99+ ";
        
        cell.messageNum = self.messageNum;
    }
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * title = self.titleList[indexPath.row];
    
    if ([title isEqualToString:SLLocalizedString(@"位阶教程")]) {
        [[SLAppInfoModel sharedInstance] postPageChangeNotification:KNotificationKungfuPageChange index:@"2"];
    }
    
    if ([title isEqualToString:SLLocalizedString(@"段品制介绍")]) {
        [[SLAppInfoModel sharedInstance] postPageChangeNotification:KNotificationKungfuPageChange index:@"4"];
    }
    
    NSString *vcStr = @"";
    NSDictionary *params = @{};
    if ([title isEqualToString:SLLocalizedString(@"报名查询")]) {
        vcStr = @"KungfuApplyCheckListViewController";
    }
    
    if ([title isEqualToString:SLLocalizedString(@"成绩查询")]) {
        vcStr = @"KungfuAllScoreViewController";
    }
    
    if ([title isEqualToString:SLLocalizedString(@"证书查询")]) {
        vcStr = @"KfCertificateCheckViewController";
        params = @{@"navigationBarWhiteTintColor" : @(YES)};
    }
    
    if ([title isEqualToString:SLLocalizedString(@"考点公告")]) {
        vcStr = @"KungfuExamNoticeViewController";
    }
    if (vcStr.length){
        SLRouteModel *model = [[SLRouteModel alloc] init];
        model.vcClass = NSClassFromString(vcStr);
        model.params = params;
        [SLRouteManager shaolinRouteByPush:nil model:model];
    }
}


//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//
//    return 3;
//}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//
//    return 15;
//}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
   
    return UIEdgeInsetsMake(0, self.layout.minimumInteritemSpacing, 0, self.layout.minimumInteritemSpacing);
    
}

#pragma mark - getter

-(NSArray *)iconList {
    return @[@"new_kungfu_classIcon"
             ,@"new_class_infoIcon"
             ,@"new_class_search"
             ,@"new_kungfu_Registrationquery"
             ,@"new_kungfu_certificate"
             ,@"new_class_notiIcon"];
}

-(NSArray *)titleList {
    return @[SLLocalizedString(@"位阶教程"),SLLocalizedString(@"段品制介绍"),SLLocalizedString(@"报名查询"),SLLocalizedString(@"成绩查询"),SLLocalizedString(@"证书查询"),SLLocalizedString(@"考点公告")];
}

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWidth,200) collectionViewLayout:self.layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[KungfuHomeModuleCollectionCell class] forCellWithReuseIdentifier:moduleCollectionCellId];
    }
    return _collectionView;
}
-(UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [UICollectionViewFlowLayout new];
        _layout.minimumLineSpacing = 1;
//        _layout.minimumInteritemSpacing = 6.5;
        _layout.itemSize = CGSizeMake(80, 94);
    }
    return _layout;
   
}

-(void)setMessageNum:(NSString *)messageNum{
    _messageNum = messageNum;
    [self.collectionView reloadData];
}

@end
