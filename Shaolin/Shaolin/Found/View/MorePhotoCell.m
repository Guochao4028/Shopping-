//
//  MorePhotoCell.m
//  Shaolin
//
//  Created by edz on 2020/3/6.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "MorePhotoCell.h"
#import "MorePhotoCollectionViewCell.h"
@interface MorePhotoCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSMutableArray *imgDatasources;
@end
@implementation MorePhotoCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}


-(void)setFoundModel:(FoundModel *)f indexpath:(NSIndexPath *)indexPath
{
    
    
    self.imgDatasources = [NSMutableArray arrayWithArray:f.coverurlList];
    
    self.titleL.text = [NSString stringWithFormat:@"%@",f.title];
    
    CGFloat width = [UILabel getWidthWithTitle:self.titleL.text font:self.titleL.font];
    
    if ( width < kWidth-SLChange(32)) {
        [self.titleL mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(SLChange(16));
        }];
        
        CGRect frame = self.collectionView.frame;
        frame.origin.y = SLChange(48);
        self.collectionView.frame = frame;
        f.cellHeight =  SLChange(174);
    }else
    {
        f.cellHeight =  SLChange(203);
        
    }
    NSDate *date= [self nsstringConversionNSDate:f.returnTime];
    NSString *timeStr = [NSString stringWithFormat:@"%@",[self compaareCurrentTime:date]];
    
    
    NSString *strCount = f.clicks;
    if (strCount.integerValue <= 0) {
        strCount = [NSString stringWithFormat:@"0"];
    }else if(strCount.integerValue < 10000){
        strCount = [NSString stringWithFormat:@"%@", strCount];
    }else{
        double d = strCount.doubleValue;
        double num = d / 10000;
        strCount = [NSString stringWithFormat:SLLocalizedString(@"%.1f万"), num];
    }
    
    self.nameLabel.text = [NSString stringWithFormat:SLLocalizedString(@"%@  %@人浏览  %@  "),f.author,strCount,timeStr];
    [self.collectionView reloadData];
    //    CGSize nameSize = [self.nameLabel.text sizeWithFont:self.nameLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    //
    //    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.width.mas_equalTo(nameSize.width+5);
    //    }];
}





-(void)setupView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.titleL];
    //    [self.contentView addSubview:self.imageV];
    
    [self.contentView addSubview:self.nameLabel];
    //    [self.contentView addSubview:self.lookLabel];
    [self.contentView addSubview:self.collectionView];
    //    [self.contentView addSubview:self.timeLabel];
}
/// collectinView section header 在高版本存在系统BUG，需要设置zPosition = 0.0
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    view.layer.zPosition = 0.0;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.imgDatasources.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    MorePhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MorePhotoCollectionViewCell" forIndexPath:indexPath];
    [cell configCellUrl:self.imgDatasources indexPath:indexPath];
    
    //         NSArray *arr = @[@"me_certificate_icon",@"me_tutorial_icon",@"me_activity_icon",@"me_test_icon"];
    ////         cell.numberLabel.text = arr[indexPath.row];
    //        cell.logoView.image = [UIImage imageNamed:arr[indexPath.row]];
    //         NSArray *arrTitle = @[SLLocalizedString(@"我的证书"),SLLocalizedString(@"我的课程"),SLLocalizedString(@"我的活动"),SLLocalizedString(@"考试管理")];
    //            cell.nameLabel.text = arrTitle[indexPath.row];
    //
    return cell;
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return SLChange(8);//Item之间的最小间隔
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}
//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(16));
        make.right.mas_equalTo(-SLChange(16));
        make.height.mas_equalTo(SLChange(45));
        make.top.mas_equalTo(SLChange(18));
    }];
    
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleL);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-SLChange(18));
        make.height.mas_equalTo(SLChange(16.5));
    }];
    //    [self.lookLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //              make.left.mas_equalTo(self.nameLabel.mas_right).offset(SLChange(10));
    //              make.centerY.mas_equalTo(self.nameLabel);
    //              make.width.mas_equalTo(SLChange(68));
    //              make.height.mas_equalTo(SLChange(16.5));
    //          }];
    //    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(self.lookLabel.mas_right).offset(SLChange(10));
    //        make.centerY.mas_equalTo(self.nameLabel);
    //        make.width.mas_equalTo(SLChange(52));
    //        make.height.mas_equalTo(SLChange(16.5));
    //    }];
}
-(UILabel *)titleL
{
    if (!_titleL) {
        _titleL = [[UILabelLeftTopAlign alloc]init];
        _titleL.font = kRegular(16);
        _titleL.numberOfLines = 0;
        _titleL.textAlignment = NSTextAlignmentLeft;
        _titleL.textColor = [UIColor colorForHex:@"333333"];
        _titleL.text = @"";
    }
    return _titleL;
}

-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = kRegular(12);
        _nameLabel.numberOfLines = 1;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = [UIColor colorForHex:@"999999"];
        _nameLabel.text = @"";
    }
    return _nameLabel;
}
//-(UILabel *)lookLabel
//{
//    if (!_lookLabel) {
//           _lookLabel = [[UILabel alloc]init];
//           _lookLabel.font = kRegular(12);
//           _lookLabel.numberOfLines = 1;
//           _lookLabel.textAlignment = NSTextAlignmentLeft;
//           _lookLabel.textColor = [UIColor colorForHex:@"999999"];
//           _lookLabel.text = @"";
//       }
//       return _lookLabel;
//}
//
//-(UILabel *)timeLabel
//{
//    if (!_timeLabel) {
//           _timeLabel = [[UILabel alloc]init];
//           _timeLabel.font = kRegular(12);
//           _timeLabel.numberOfLines = 1;
//           _timeLabel.textAlignment = NSTextAlignmentLeft;
//           _timeLabel.textColor = [UIColor colorForHex:@"999999"];
//           _timeLabel.text = @"";
//        
//       }
//       return _timeLabel;
//}
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(SLChange(16), SLChange(77), kWidth-SLChange(32), SLChange(76)) collectionViewLayout:self.layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[MorePhotoCollectionViewCell class] forCellWithReuseIdentifier:@"MorePhotoCollectionViewCell"];
        [_collectionView setUserInteractionEnabled:NO];
    }
    return _collectionView;
}
-(UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        _layout = [UICollectionViewFlowLayout new];
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 0;
        _layout.itemSize = CGSizeMake(SLChange(109), SLChange(76));
        //            _layout.sectionInset = UIEdgeInsetsMake(SLChange(32) ,0 , 0,0);
    }
    return _layout;
    
}

- (UIImage *)getShowImage{
    MorePhotoCollectionViewCell *cell = [self.collectionView visibleCells].firstObject;
    return cell.imageV.image;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
