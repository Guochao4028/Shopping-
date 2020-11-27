//
//  ShoppingCratHeadView.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/6.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ShoppingCratHeadView.h"

#import "GoodsStoreInfoModel.h"

@interface ShoppingCratHeadView ()

@property(nonatomic, assign)ShoppingCartHeadViewType type;
@property (strong, nonatomic) IBOutlet UIView *stroeHeadView;
@property (weak, nonatomic) IBOutlet UILabel *stroeTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;


@property (weak, nonatomic) IBOutlet UIImageView *selectCourseImageView;


- (IBAction)selectButtonAction:(UIButton *)sender;

- (IBAction)jumpStoreAction:(UIButton *)sender;


@property (strong, nonatomic) IBOutlet UIView *titleHeadView;

@property(nonatomic, weak)UIView *contentView;

@end

@implementation ShoppingCratHeadView

-(instancetype)initWithFrame:(CGRect)frame ViewType:(ShoppingCartHeadViewType)type{
    
    self = [self initWithFrame:frame];
    if (self != nil) {
        self.type = type;
         [self initUI];
    }
    
    return self;
}


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"ShoppingCratHeadView" owner:self options:nil];
    }
    return self;
}

/// 初始化UI
-(void)initUI{
    
    if (self.type == ShoppingCartHeadViewStoreType) {
        self.contentView = self.stroeHeadView;
    }else{
        self.contentView = self.titleHeadView;
    }
    
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
}

/// 重写系统方法
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self.contentView setFrame:self.bounds];
}

+ (CGFloat)getCartHeaderHeight{
    return 40;
}

#pragma mark - action
- (IBAction)selectButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(shoppingCratHeadView:lcotion:model:)] == YES) {
        [self.delegate shoppingCratHeadView:self lcotion:self.section model:self.model];
    }
}

- (IBAction)jumpStoreAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(shoppingCratHeadView:jumpStoreModel:)] == YES) {
        [self.delegate shoppingCratHeadView:self jumpStoreModel:self.model];
    }
}

#pragma mark - setter / getter
-(void)setModel:(GoodsStoreInfoModel *)model{
    _model = model;
    [self.stroeTitleLabel setText:model.name];
}

-(void)setIsSelected:(BOOL)isSelected{
    
    if (isSelected) {
        [self.selectImageView setImage:[UIImage imageNamed:@"Shoppinged"]];
        
        [self.selectCourseImageView setImage:[UIImage imageNamed:@"Shoppinged"]];
        
    }else{
        [self.selectImageView setImage:[UIImage imageNamed:@"unShopping"]];
        
        [self.selectCourseImageView setImage:[UIImage imageNamed:@"unShopping"]];
    }
}

//-(void)setType:(ShoppingCartHeadViewType)type{
//    [self.contentView removeFromSuperview];
//    self.contentView = nil;
//    if (self.type == ShoppingCartHeadViewStoreType) {
//           self.contentView = self.stroeHeadView;
//       }else{
//           self.contentView = self.titleHeadView;
//       }
//       
//       [self addSubview:self.contentView];
//       [self.contentView setFrame:self.bounds];
//}




@end
