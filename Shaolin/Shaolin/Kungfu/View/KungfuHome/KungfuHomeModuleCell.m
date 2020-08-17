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

@property(nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UICollectionViewFlowLayout *layout;

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
  
    return 4;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    KungfuHomeModuleCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:moduleCollectionCellId forIndexPath:indexPath];
         
    NSArray *arr=@[@"kungfu_allClass",@"kungfu_huodong",@"kungfu_kaoshi",@"kungfu_baoming"];
     
    cell.imageIcon.image = [UIImage imageNamed:arr[indexPath.row]];
    NSArray *arrTitle = @[SLLocalizedString(@"全部课程"),SLLocalizedString(@"活动报名"),SLLocalizedString(@"理论考试"),SLLocalizedString(@"报名查询")];
    cell.nameLabel.text = arrTitle[indexPath.row];
   
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        [[SLAppInfoModel sharedInstance] postPageChangeNotification:KNotificationKungfuPageChange index:@"3"];
    }
    
    if (indexPath.row == 1) {
        [[SLAppInfoModel sharedInstance] postPageChangeNotification:KNotificationKungfuPageChange index:@"2"];
    }
    
    if (indexPath.row == 2) {
        [[SLAppInfoModel sharedInstance] postPageChangeNotification:KNotificationKungfuPageChange index:@"1"];
    }
    
    if (indexPath.row == 3) {
        [[SLAppInfoModel sharedInstance] postPageChangeNotification:KNotificationKungfuPageChange index:@"4"];
    }
    
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.01;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.01;
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
   
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(SLChange(16), 5, kWidth-SLChange(32),95) collectionViewLayout:self.layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[KungfuHomeModuleCollectionCell class] forCellWithReuseIdentifier:moduleCollectionCellId];
    }
    return _collectionView;
}
-(UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
            _layout = [UICollectionViewFlowLayout new];
            _layout.minimumLineSpacing = 0;
            _layout.minimumInteritemSpacing = 0;
            _layout.itemSize = CGSizeMake((kWidth-SLChange(32))/4 - 1, 95);
        }
        return _layout;
   
}

@end
