//
//  StoreNavgationView.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/13.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol StoreNavgationViewDelege;

@interface StoreNavgationView : UIView

@property(nonatomic, assign)BOOL isWhite;

-(void)backTarget:(nullable id)target action:(SEL)action;

@property(nonatomic, weak)id<StoreNavgationViewDelege>delegate;

@end

@protocol StoreNavgationViewDelege <NSObject>

-(void)tapSearch;

@end

NS_ASSUME_NONNULL_END
