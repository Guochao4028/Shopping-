//
//  KungfuHomeModuleCell.m
//  Shaolin
//
//  Created by ws on 2020/5/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuHomeModuleCell.h"
#import "KungfuHomeModuleCollectionCell.h"

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
  
    return 6;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    KungfuHomeModuleCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:moduleCollectionCellId forIndexPath:indexPath];
         
     
    cell.imageIcon.image = [UIImage imageNamed:self.iconList[indexPath.row]];
    cell.nameLabel.text = self.titleList[indexPath.row];
   
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
    
    if ([title isEqualToString:SLLocalizedString(@"报名查询")]) {
        Class vcClass = NSClassFromString(@"KungfuApplyCheckListViewController");
        [[SLAppInfoModel sharedInstance] pushController:[vcClass new]];
    }
    
    if ([title isEqualToString:SLLocalizedString(@"成绩查询")]) {
        Class vcClass = NSClassFromString(@"KungfuAllScoreViewController");
        [[SLAppInfoModel sharedInstance] pushController:[vcClass new]];
    }
    
    if ([title isEqualToString:SLLocalizedString(@"证书查询")]) {
        Class vcClass = NSClassFromString(@"KfCertificateCheckViewController");
        [[SLAppInfoModel sharedInstance] pushController:[vcClass new]];
    }
    
    if ([title isEqualToString:SLLocalizedString(@"考点公告")]) {
        Class vcClass = NSClassFromString(@"KungfuExamNoticeViewController");
        [[SLAppInfoModel sharedInstance] pushController:[vcClass new]];
    }
    
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 3;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 15;
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
   
    return UIEdgeInsetsMake(15, 16, 0, 16);
    
}

#pragma mark - getter

-(NSArray *)iconList {
    return @[@"kungfu_classIcon"
             ,@"class_infoIcon"
             ,@"class_search"
             ,@"kungfu_Registrationquery"
             ,@"kungfu_certificate"
             ,@"class_notiIcon"];
}

-(NSArray *)titleList {
    return @[SLLocalizedString(@"位阶教程"),SLLocalizedString(@"段品制介绍"),SLLocalizedString(@"报名查询"),SLLocalizedString(@"成绩查询"),SLLocalizedString(@"证书查询"),SLLocalizedString(@"考点公告")];
}

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWidth,305) collectionViewLayout:self.layout];
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
        _layout.minimumLineSpacing = 15;
        _layout.minimumInteritemSpacing = 6.5;
        _layout.itemSize = CGSizeMake((kWidth - 32 - 8)/3 - 1, 130);
    }
    return _layout;
   
}

@end
