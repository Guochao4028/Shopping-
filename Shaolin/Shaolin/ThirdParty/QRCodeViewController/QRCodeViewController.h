//
//  QRCodeViewController.h
//  Shaolin
//
//  Created by 王精明 on 2020/10/12.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, QRCodeViewControllerToolBar){
    Flashlight  = 1 << 1,
    Photo       = 1 << 2,
    
    ALL         = Flashlight | Photo,
};

typedef void (^HandleSuccessBlock)(void);

@interface QRCodeViewController : RootViewController
@property (nonatomic) QRCodeViewControllerToolBar toolBar;
@property (nonatomic, copy) BOOL (^checkQRCodeString)(NSString *QRCodeString);
@property (nonatomic, copy) void (^scanSucceeded)(NSArray<NSString *> *QRCodeStringArray, HandleSuccessBlock handleSuccess);
@end

NS_ASSUME_NONNULL_END
