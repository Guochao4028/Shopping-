//
//  EnrollmentDanPop.m
//  Shaolin
//
//  Created by EDZ on 2020/5/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "EnrollmentDanPop.h"
#import "EnrollmentCollectionViewCell.h"

@interface EnrollmentDanPop()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cancelConstBottom;

@property (strong, nonatomic) IBOutlet UICollectionView *mCollectionView;


@property (nonatomic, strong) NSMutableArray *arraySelect;

@end

static NSString * const enrollmentIdentifier = @"EnrollmentCell";

@implementation EnrollmentDanPop

- (void)awakeFromNib {
    [super awakeFromNib];
    //点击半透明背景使界面自动消失
    [MMPopupWindow sharedWindow].touchWildToHide = YES;
    self.type = MMPopupTypeSheet;
//    self.backgroundColor = [UIColor clearColor];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 480));
    }];
    CGFloat radius = 12; // 圆角大小
    if (@available(iOS 11.0, *)) {
        self.layer.cornerRadius = radius;
        self.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    } else {
        [self layoutIfNeeded];
        UIRectCorner corner = UIRectCornerTopLeft | UIRectCornerTopRight; // 圆角位置，左上、右上
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = path.CGPath;
        maskLayer.fillColor = [UIColor whiteColor].CGColor;
        self.layer.mask = maskLayer;
    }
    self.cancelConstBottom.constant = IS_iphoneX ? 34.f : 0.f;
    
    self.arraySelect = [[NSMutableArray alloc] initWithCapacity:0];
    [self configSubviews];
}

- (void)configSubviews {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(SLChange(70), SLChange(33));
//    layout.minimumLineSpacing = 4; //竖间距
//    layout.minimumInteritemSpacing = 4; // 垂直间距
    self.mCollectionView.allowsSelection = NO;
    [self.mCollectionView setCollectionViewLayout:layout];
    
    [self.mCollectionView registerNib:[UINib nibWithNibName:@"EnrollmentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:enrollmentIdentifier];
}

// 上下间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 12;
}


- (void)setDatalist:(NSMutableArray *)datalist {
    _datalist = datalist;
    
//    NSInteger lineNum = [self calculateLineNumWithCount:4 datalist:datalist];
//    self.collectionHeight.constant = 33 * lineNum + 12 * lineNum;
    [self.mCollectionView reloadData];
}

#pragma mark - UICollectionViewDelegateFlowLayout & UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datalist.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    EnrollmentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:enrollmentIdentifier forIndexPath:indexPath];
    
    NSString *bean = [self.datalist objectAtIndex:indexPath.row];

    [cell.btnTitle setTitle:bean forState:UIControlStateNormal];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.arraySelect containsObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]) {
        for (int i = 0; i < self.arraySelect.count; i++) {
            if ([self.arraySelect[i] isEqualToString:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]) {
                [self.arraySelect removeObjectAtIndex:i];
            }
        }
    }else{
        [self.arraySelect addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    }
    
    if (self.blockArr) {
        self.blockArr(self.arraySelect);
    }
    [self.mCollectionView reloadData];
}

#pragma mark - 计算行数
- (NSInteger)calculateLineNumWithCount:(NSInteger)count datalist:(NSArray *)datalist {
    
    NSInteger lineNum = datalist.count / count;
    if (!lineNum) {
        lineNum = 1;
    }else{
        if (datalist.count % count == 0) {
            lineNum = datalist.count / count;
        }else{
            lineNum = datalist.count / count + 1;
        }
    }
    return lineNum;
}


- (IBAction)clearAction:(id)sender {
    [self hide];
}



@end
