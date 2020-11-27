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

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSMutableArray *imgDatasources;

@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat itemHeight;

@end

@implementation MorePhotoCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.itemWidth = (kScreenWidth - 30 - 20 - 8)/3;
        self.itemHeight = (106*75)/self.itemWidth;
        
        [self setupView];
    }
    return self;
}

-(void)setupView {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.titleL];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.collectionView];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(15);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleL);
        make.top.mas_equalTo(self.titleL.mas_bottom).mas_offset(14);
        make.height.mas_equalTo(self.itemHeight);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleL);
        make.top.mas_equalTo(self.collectionView.mas_bottom).offset(10);
        make.bottom.mas_equalTo(-15);
    }];
}

-(void)setFoundModel:(FoundModel *)f indexpath:(NSIndexPath *)indexPath
{
    self.imgDatasources = [NSMutableArray arrayWithArray:f.coverurlList];
    
    self.titleL.text = [NSString stringWithFormat:@"%@",f.title];

    NSDate *date= [self nsstringConversionNSDate:f.returnTime];
    NSString *timeStr = @"";//[NSString stringWithFormat:@"%@",[self compaareCurrentTime:date]];
    
    
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
}

#pragma mark - collection delegate&&dataSources
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

    return cell;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 4;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}

#pragma mark - getter

-(UILabel *)titleL {
    if (!_titleL) {
        _titleL = [[UILabelLeftTopAlign alloc]init];
        _titleL.font = kRegular(16);
        _titleL.numberOfLines = 2;
        _titleL.textAlignment = NSTextAlignmentLeft;
        _titleL.textColor = KTextGray_333;
        _titleL.text = @"";
    }
    return _titleL;
}

-(UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = kRegular(12);
        _nameLabel.numberOfLines = 1;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = KTextGray_999;
        _nameLabel.text = @"";
    }
    return _nameLabel;
}

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[MorePhotoCollectionViewCell class] forCellWithReuseIdentifier:@"MorePhotoCollectionViewCell"];
        [_collectionView setUserInteractionEnabled:NO];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [UICollectionViewFlowLayout new];
        _layout.minimumLineSpacing = .001;
        _layout.minimumInteritemSpacing = .001;
        
//        106 * 75
        _layout.itemSize = CGSizeMake(self.itemWidth, self.itemHeight);
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
