//
//  KungfuClassHeaderView.m
//  Shaolin
//
//  Created by ws on 2020/5/15.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuClassHeaderView.h"
#import "ClassDetailModel.h"
#import "SDCycleScrollView.h"
#import "KungfuClassMoreCollectionViewCell.h"

@interface KungfuClassHeaderView() <SDCycleScrollViewDelegate>



@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;

@property (weak, nonatomic) IBOutlet UIView *alphaView;

@property (weak, nonatomic) IBOutlet UIImageView *playIconImgc;

@property (nonatomic, strong) SDCycleScrollView *sdcScrollView;

@property (weak, nonatomic) IBOutlet UILabel *freeLabel;

@end

@implementation KungfuClassHeaderView


-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.alphaView.hidden = YES;
    self.userInteractionEnabled = YES;
    self.classImgv.userInteractionEnabled = YES;
    
    [self setUI];
}

- (void)setUI{
    [self.classImgv addSubview:self.sdcScrollView];
    [self.sdcScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}


#pragma mark - cyclyScrollerDelegate
-(Class)customCollectionViewCellClassForCycleScrollView:(SDCycleScrollView *)view
{
    return [KungfuClassMoreCollectionViewCell class];
}

-(void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view {
    
    KungfuClassMoreCollectionViewCell * moreCell = (KungfuClassMoreCollectionViewCell *)cell;
    
    NSArray *imageDatas = self.model.img_data;
    NSString * photoUrlStr = imageDatas[index];
    
    [moreCell.imageV sd_setImageWithURL:[NSURL URLWithString:photoUrlStr] placeholderImage:[UIImage imageNamed:@"default_big"]];
}


#pragma mark - setter && getter

- (SDCycleScrollView *)sdcScrollView {
    if (!_sdcScrollView) {
        _sdcScrollView = [[SDCycleScrollView alloc] init];
        _sdcScrollView.placeholderImage = [UIImage imageNamed:@"default_banner"];
        _sdcScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
//        _sdcScrollView.delegate = self;
    }
    return _sdcScrollView;
}

- (void)setModel:(ClassDetailModel *)model{
    _model = model;
    [self reloadView];
}

- (void)reloadView{
    if (!self.model) return;
    self.classNameLabel.text = self.model.classDetailName;
    
    NSString * priceString = [NSString stringWithFormat:@"¥%@", self.model.old_price];
    NSArray <NSString *>*array = [self.model.old_price componentsSeparatedByString:@"."];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:priceString attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC" size: 16],NSForegroundColorAttributeName: KPriceRed}];
    [string addAttributes:@{NSForegroundColorAttributeName: KPriceRed} range:NSMakeRange(0, 1)];
    if (array.count == 2){
        NSRange range = [priceString rangeOfString:array.firstObject];
        [string addAttributes:@{NSFontAttributeName: kBoldFont(19), NSForegroundColorAttributeName: KPriceRed} range:range];
        [string addAttributes:@{NSFontAttributeName: kBoldFont(17), NSForegroundColorAttributeName: KPriceRed} range:NSMakeRange(NSMaxRange(range), priceString.length - NSMaxRange(range))];
    } else {
        [string addAttributes:@{NSFontAttributeName: kBoldFont(19), NSForegroundColorAttributeName: KPriceRed} range:NSMakeRange(1, 1)];
        [string addAttributes:@{NSFontAttributeName: kBoldFont(17), NSForegroundColorAttributeName: KPriceRed} range:NSMakeRange(2, priceString.length - 2)];
    }
    self.priceLabel.attributedText = string;
    
    if ([self.model.old_price floatValue] == 0.00) {
        self.freeLabel.hidden = NO;
    } else {
        self.freeLabel.hidden = YES;
        
    }
    
    NSArray *imageDatas = self.model.img_data;

    self.sdcScrollView.imageURLStringsGroup = imageDatas;// self.model.img_data;
    
    [self showSdcScrollView];
}

- (void)showSdcScrollView{
    self.playBtn.hidden = YES;
    self.sdcScrollView.hidden = NO;
}

- (void)hideSdcScrollView{
    self.sdcScrollView.hidden = YES;
}

- (IBAction)playHandle:(UIButton *)sender {
    if (self.playCallback) {
        self.playCallback();
    }
}

@end
