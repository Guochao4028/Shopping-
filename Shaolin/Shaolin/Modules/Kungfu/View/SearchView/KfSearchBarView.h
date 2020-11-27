//
//  KfSearchBarView.h
//  Shaolin
//
//  Created by ws on 2020/5/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    KfSearchClass = 1,
    KfSearchActivity,
    KfSearchEnrollment,
} KfSearchType;


@interface KfSearchBarView : UIView
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeIcon;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UIView *verLine;

//@property (nonatomic, assign) KfSearchType searchType;


@property (nonatomic,copy)void(^ searchHandle)(NSString * searchStr);
@property (nonatomic,copy)void(^ backHandle) (void);
@property (nonatomic,copy)void(^ filterHandle) (void);
@property (nonatomic,copy)void(^ tfBeginEditing) (void);


@end

NS_ASSUME_NONNULL_END
