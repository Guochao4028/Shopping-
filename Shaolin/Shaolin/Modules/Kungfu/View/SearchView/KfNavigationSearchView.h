//
//  KfNavigationSearchView.h
//  Shaolin
//
//  Created by ws on 2020/5/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KfNavigationSearchView : UIView
@property (weak, nonatomic) IBOutlet UIButton *shopCarBtn;
@property (weak, nonatomic) IBOutlet UIImageView *shopCarIcon;

@property (weak, nonatomic) IBOutlet UIImageView *arrowIcon;
@property (weak, nonatomic) IBOutlet UIButton *classBtn;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@property (weak, nonatomic) IBOutlet UIButton *searchHandleBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;


@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIView *backBtnView;
@property (weak, nonatomic) IBOutlet UIView *searchBgView;
@property (weak, nonatomic) IBOutlet UILabel *searchLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UIButton *iconBtn;

///如果是在搜索界面界面，显示返回按钮，隐藏购物车，打开textField交互
@property (nonatomic, assign) BOOL isSearchResult;

@property (nonatomic,copy)void(^ shopCarHandle)(void);
@property (nonatomic,copy)void(^ searchTapHandle)(NSString * searchStr);
@property (nonatomic,copy)void(^ searchHandle)(void);
@property (nonatomic,copy)void(^ backHandle)(void);
@property (nonatomic,copy)void(^ filterHandle)(void);
@property (nonatomic,copy)void(^ tfBeginEditing) (void);

@end

NS_ASSUME_NONNULL_END
