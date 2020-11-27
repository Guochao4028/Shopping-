//
//  CreateAddressView.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CreateAddressViewDelegate;

@class AddressListModel;

@interface CreateAddressView : UIView

@property(nonatomic, strong)AddressListModel *addressListModel;



@property(nonatomic, weak)id<CreateAddressViewDelegate> delegate;

@property(nonatomic, assign)BOOL isEnabled;


@end

 @protocol CreateAddressViewDelegate <NSObject>

-(void)createAddressView:(CreateAddressView *)view tapSave:(NSDictionary *)model;

@end

NS_ASSUME_NONNULL_END
