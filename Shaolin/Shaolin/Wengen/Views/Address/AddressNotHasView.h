//
//  AddressView.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol AddressNotHasViewDelegate;

@interface AddressNotHasView : UIView

@property(nonatomic, weak)id<AddressNotHasViewDelegate>delegagte;

@end


@protocol AddressNotHasViewDelegate <NSObject>

-(void)notHasView:(AddressNotHasView *)view tapAddress:(BOOL)istap;


@end

NS_ASSUME_NONNULL_END
