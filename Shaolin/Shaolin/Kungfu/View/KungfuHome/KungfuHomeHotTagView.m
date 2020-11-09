//
//  KungfuHomeHotTagView.m
//  Shaolin
//
//  Created by ws on 2020/5/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuHomeHotTagView.h"
#import "HotClassModel.h"

/** 字体离边框的水平距离 */
#define HORIZONTAL_PADDING 10.0f
/** 字体离边框的竖直距离 */
#define VERTICAL_PADDING   5.0f
/** tagLab之间的水平间距 */
#define HORIZONTAL_MARGIN  15.0f
/** tagLab之间的竖直间距 */
#define VERTICAL_MARGIN    5.0f

@implementation KungfuHomeHotTagView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        totalHeight=0;
        self.userInteractionEnabled = YES;
        self.frame = frame;
    }
    return self;
}
-(void)setTagWithTagArray:(NSArray*)arr{


    /**
     *  防止放于cell上时复用重复创建
     *  让第之后创建totalHeight重新置为0
     *  删除之前存在的subView
     */
//    totalHeight = 0;
//    NSMutableArray * tagLabels = [NSMutableArray new];
//    CGFloat minFont  = 100;
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    /***************************************/
    
    previousFrame = CGRectZero;
    
    for (int i = 0; i < arr.count; i++) {
        HotClassModel * classModel = arr[i];
        classModel.isFire = i<3;
        NSString * className = classModel.className;
        
        UIView * tagBgView = [self creatBgView];
        UIImageView * fireIcon = [self creatFireIcon];
        UILabel *tagLabel = [self creatNameLabel];
        
        tagLabel.text = className;
        
       
        
//        CGSize textStrSize = [className sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
//        textStrSize.height = 32;
        
//        textStrSize.height += VERTICAL_PADDING*2;
//        if (classModel.isFire) {
//            // 有火的icon
//            textStrSize.width += HORIZONTAL_PADDING*2 + 28;
//        } else {
//            textStrSize.width += HORIZONTAL_PADDING*2 + 10;
//        }
        
        
        CGRect newRect = CGRectMake(16+((20 + (kWidth - 72 - 32)/3)*(i%3)), 10+(15 + 32)*(i/3), (kWidth - 72 - 32)/3, 32);
        
        /** 如果新的tagLab超出屏幕边界 */
//        if (previousFrame.origin.x + previousFrame.size.width + textStrSize.width + HORIZONTAL_MARGIN > self.bounds.size.width) {
//            newRect.origin = CGPointMake(15, previousFrame.origin.y + textStrSize.height + VERTICAL_MARGIN);
//            totalHeight += textStrSize.height + VERTICAL_MARGIN;
//        }
//        else {
//            newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + HORIZONTAL_MARGIN, previousFrame.origin.y);
//        }
        
        [tagBgView setFrame:newRect];
        tagBgView.layer.cornerRadius = 16;
        
        if (classModel.isFire) {
            // 有火的icon
            [tagLabel setFrame:CGRectMake(CGRectGetMaxX(fireIcon.frame) + 5, 0, tagBgView.width - 18 - 12 - 5, tagBgView.height)];
            tagLabel.textAlignment = NSTextAlignmentLeft;
            [tagBgView addSubview:fireIcon];
        } else {
            [tagLabel setFrame:CGRectMake(0, 0, tagBgView.width, tagBgView.height)];
            tagLabel.textAlignment =  NSTextAlignmentCenter;
        }
        
        previousFrame = tagBgView.frame;
        [self setHight:self andHight:arr.count/3 * 32 + 20];
        [tagBgView addSubview:tagLabel];
        [self addSubview:tagBgView];

        UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchSubTagView:)];
        tapOne.delegate = self;
        tapOne.numberOfTapsRequired = 1.0;
        [tagLabel addGestureRecognizer:tapOne];

    }

    if(_BigBGColor){
        self.backgroundColor=_BigBGColor;
    }else{
        self.backgroundColor=[UIColor whiteColor];
    }
}

- (UILabel *) creatNameLabel {
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.userInteractionEnabled = YES;
    label.frame = CGRectZero;
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor hexColor:@"333333"];
    
    if (kWidth <= 375) {
        label.font = kRegular(11);
    } else {
        label.font = kRegular(13);
    }

//    label.font = kRegular(13);
    label.clipsToBounds = YES;
    
    return label;
}

- (UIImageView *) creatFireIcon {
    UIImageView * fire = [[UIImageView alloc] initWithFrame:CGRectMake(11, 9, 12, 14)];
    fire.image = [UIImage imageNamed:@"kungfu_fire"];
    
    return fire;
}

- (UIView *) creatBgView {
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectZero];
    bgView.backgroundColor = [UIColor hexColor:@"f6f6f6"];
    
    return bgView;
}

-(void)touchSubTagView:(UITapGestureRecognizer*)tapOne
{
    UILabel *lab = (UILabel *)tapOne.view;
//    NSLog(@"%@",lab.text);
    if (self.delegate && [self.delegate respondsToSelector:@selector(WTagView:fetchWordToTextFiled:)]) {
        [self.delegate WTagView:self fetchWordToTextFiled:lab.text];
    }
}
#pragma mark-改变子tag控件高度
- (void)setHight:(UIView *)view andHight:(CGFloat)hight
{
    CGRect tempFrame = view.frame;
    tempFrame.size.height = hight;
    view.frame = tempFrame;
}

@end
