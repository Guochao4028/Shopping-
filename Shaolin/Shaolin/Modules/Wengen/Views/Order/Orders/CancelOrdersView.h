//
//  CancelOrdersView.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/26.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CancelOrdersViewSelectedBlock)(NSString * cause);

@class OrderDetailsModel;

@interface CancelOrdersView : UIView

@property(nonatomic, copy)CancelOrdersViewSelectedBlock selectedBlock;
@property(nonatomic,strong)NSArray * cellArr;

- (instancetype)initWithFrame:(CGRect)frame reasonList:(NSArray *)list;
///标题
@property(nonatomic, copy)NSString *titleStr;
///是否隐藏副标题
@property(nonatomic, assign)BOOL isHiddenSubtitle;

@property(nonatomic, strong)OrderDetailsNewModel *detailsModel;

@property(nonatomic, assign)BOOL isFromKungfuOrder;

- (void)disappear;



@end

NS_ASSUME_NONNULL_END
