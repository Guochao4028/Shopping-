//
//  OrderLogisticsTableViewCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/6/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderLogisticsTableViewCell.h"

#import "OrderDetailsModel.h"
#import "OrdeItemImageCollectionViewCell.h"

@interface OrderLogisticsTableViewCell ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *logisticsLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *goodsNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *lookLogisticsButton;

@property(nonatomic, strong)NSArray *goodsImagesArray;
- (IBAction)lookLogisticsAction:(UIButton *)sender;


@end


@implementation OrderLogisticsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([OrdeItemImageCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"OrdeItemImageCollectionViewCell"];
    
    
    
    
    [self modifiedButton:self.lookLogisticsButton borderColor:[UIColor colorForHex:@"BE0B1F"] cornerRadius:15];
}


///装饰button
-(void)modifiedButton:(UIButton *)sender borderColor:(UIColor *)color cornerRadius:(CGFloat)radius{
    sender.layer.borderWidth = 1;
    sender.layer.borderColor = color.CGColor;
    sender.layer.cornerRadius = SLChange(radius);
    [sender.layer setMasksToBounds:YES];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.goodsImagesArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(110, 110);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    OrdeItemImageCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"OrdeItemImageCollectionViewCell" forIndexPath:indexPath];
    
    cell.imageStr = self.goodsImagesArray[indexPath.row];
    
    return cell;
}

#pragma mark - setter / getter

-(void)setGoodsModel:(OrderDetailsModel *)goodsModel{
    _goodsModel = goodsModel;
    
    NSString *statusStr = goodsModel.status;
    
    if ([statusStr isEqualToString:@"3"]) {
        [self.stateLabel setText:SLLocalizedString(@"待收货")];
    }else if ([statusStr isEqualToString:@"4"]) {
        [self.stateLabel setText:SLLocalizedString(@"已收货")];
    }
    
    
    [self.logisticsLabel setText:[NSString stringWithFormat:@"%@:%@", goodsModel.logistics_name, goodsModel.logistics_no]];
    
    [self.orderNumberLabel setText:[NSString stringWithFormat:SLLocalizedString(@"订单编号：%@"), goodsModel.order_sn]];
    
    [self.goodsNumberLabel setText:[NSString stringWithFormat:SLLocalizedString(@"共%ld件商品"), goodsModel.goods_image.count]];
    
    self.goodsImagesArray = goodsModel.goods_image;
    [self.collectionView reloadData];
}

- (IBAction)lookLogisticsAction:(UIButton *)sender {
    if (self.lookLogisticsBlock) {
        self.lookLogisticsBlock(self.goodsModel);
    }
    
}

@end
