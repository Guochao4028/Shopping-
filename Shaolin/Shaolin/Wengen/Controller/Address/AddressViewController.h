//
//  AddressViewController.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class  AddressListModel;

@protocol AddressViewControllerDelegate;

@interface AddressViewController : UIViewController

@property(nonatomic, assign)BOOL isHiddenNav;

@property(nonatomic, strong)AddressListModel *addressListModel;

@property(nonatomic, weak)id<AddressViewControllerDelegate> delegate;

@property(nonatomic, assign)BOOL isAutoBack;


@end

@protocol AddressViewControllerDelegate <NSObject>

@optional
-(void)addressViewController:(AddressViewController *)vc tapList:(AddressListModel *)model;

-(void)addressViewController:(AddressViewController *)vc tapBack:(AddressListModel *)model;



@end

NS_ASSUME_NONNULL_END
