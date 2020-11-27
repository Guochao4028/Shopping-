//
//  WengenSearchView.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WengenSearchViewDelegate <NSObject>

@optional

-(void)tapShopping;
-(void)tapBack;
-(void)tapSearch;

@end

@interface WengenSearchView : UIView

@property(nonatomic, weak)id<WengenSearchViewDelegate> delegate;

@property(nonatomic, assign)BOOL isHiddenBack;
@property(nonatomic, assign)BOOL isHiddeIcon;

@property(nonatomic, copy)NSString *titleStr;

@end

NS_ASSUME_NONNULL_END
