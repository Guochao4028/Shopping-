//
//  SearchNavgationView.h
//  Shaolin
//
//  Created by 郭超 on 2020/5/6.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SearchNavgationViewDelegate;

@interface SearchNavgationView : UIView

@property(nonatomic, weak)id<SearchNavgationViewDelegate> delegate;

- (void)becomeFirstResponder;

- (void)resignFirstResponder;

@property(nonatomic, copy)NSString *titleStr;

@end

@protocol SearchNavgationViewDelegate <NSObject>

@optional

- (void)tapBack;

- (void)searchNavgationView:(SearchNavgationView *)navgationView searchWord:(NSString *)text;



@end

NS_ASSUME_NONNULL_END
