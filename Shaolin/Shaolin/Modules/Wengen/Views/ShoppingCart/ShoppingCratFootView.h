//
//  ShoppingCratFootView.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/6.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShoppingCratFootView : UIView
//全选按钮上的方法
- (void)selectedAllTarget:(nullable id)target action:(SEL)action;

//结算按钮上的方法
- (void)settlementTarget:(nullable id)target action:(SEL)action;

//删除按钮上的方法
- (void)deleteTarget:(nullable id)target action:(SEL)action;
//是否全选
@property(nonatomic, assign)BOOL isAll;
//选中的商品数量
@property(nonatomic, assign)NSInteger goodsNumber;
//合计价格
@property(nonatomic, assign)float totalPrice;

//是否显示删除按钮
@property(nonatomic, assign)BOOL isDelete;

@end

NS_ASSUME_NONNULL_END
