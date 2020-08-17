//
//  PayPasswordSetupView.h
//  Shaolin
//
//  Created by ws on 2020/5/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PayPasswordSetupView : UIView <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *pinTF;

@property (weak, nonatomic) IBOutlet UITextField *firstPasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *checkPasswordTF;

@property (weak, nonatomic) IBOutlet UIButton *sendPinBtn;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;


@property (nonatomic, copy) void(^ sendPinBlock)(void);

@end

NS_ASSUME_NONNULL_END
