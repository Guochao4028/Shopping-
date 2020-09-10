//
//  SelectAuthenticationMethodCollectionViewCell.h
//  Shaolin
//
//  Created by 王精明 on 2020/9/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SelectAuthenticationMethod) {
    Authentication_Person,      //实人认证
    Authentication_Passport,    //护照认证
};

@interface SelectAuthenticationMethodCollectionViewCell : UICollectionViewCell
@property (nonatomic) SelectAuthenticationMethod cellStyle;
@property (nonatomic, strong) UILabel *verifiedStateLabel;
@end

NS_ASSUME_NONNULL_END
