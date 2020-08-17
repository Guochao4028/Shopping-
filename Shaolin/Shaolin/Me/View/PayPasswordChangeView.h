//
//  PayPasswordChangeView.h
//  Shaolin
//
//  Created by ws on 2020/5/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PayPasswordChangeView : UIView <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *firstPasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *checkPasswordTF;


@end

NS_ASSUME_NONNULL_END
