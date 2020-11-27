//
//  GoodsDetailsHeardView.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "GoodsDetailsHeardView.h"

@interface GoodsDetailsHeardView ()
@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation GoodsDetailsHeardView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"GoodsDetailsHeardView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

-(void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
    
}

@end
