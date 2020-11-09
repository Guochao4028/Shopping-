//
//  KfNavigationSearchView.m
//  Shaolin
//
//  Created by ws on 2020/5/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KfNavigationSearchView.h"

@interface KfNavigationSearchView () <UITextFieldDelegate>

@end

@implementation KfNavigationSearchView


-(void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.isSearchResult) {
        self.shopCarIcon.hidden = YES;
        self.shopCarBtn.hidden = YES;
        self.numberLabel.hidden = YES;
        self.backBtnView.hidden = NO;
        self.backBtn.hidden = NO;
        self.searchHandleBtn.hidden = NO;
    } else {
        self.shopCarIcon.hidden = NO;
        self.shopCarBtn.hidden = NO;
        self.numberLabel.hidden = NO;
        self.backBtn.hidden = YES;
        self.searchHandleBtn.hidden = YES;
    }
    
    NSString *carCountStr = [[ModelTool shareInstance] carCount];
    NSInteger carNumber = [carCountStr integerValue];
    
    if (carNumber > 0) {
        [self.numberLabel setHidden:NO];
        [self.numberLabel setText:carCountStr];
        self.numberLabel.layer.cornerRadius = 4.5;
        self.numberLabel.layer.borderWidth = 1;
        self.numberLabel.layer.borderColor = [UIColor hexColor:@"BE0B1F"].CGColor;
        [self.numberLabel.layer setMasksToBounds:YES];
    }else{
        [self.numberLabel setHidden:YES];
    }
    
    self.numberLabel.hidden = YES;
//    self.shopCarBtn.hidden = YES;
//    self.shopCarIcon.hidden = YES;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.searchBgView.layer.cornerRadius = 15;
    self.searchTF.delegate = self;
}


-(void)setIsSearchResult:(BOOL)isSearchResult {
    _isSearchResult = isSearchResult;
    
    if (self.isSearchResult) {
        self.shopCarIcon.hidden = YES;
        self.shopCarBtn.hidden = YES;
        self.numberLabel.hidden = YES;
        self.backBtnView.hidden = NO;
        self.backBtn.hidden = NO;
        self.searchHandleBtn.hidden = NO;
    } else {
        self.shopCarIcon.hidden = NO;
        self.shopCarBtn.hidden = NO;
        self.numberLabel.hidden = NO;
        self.backBtnView.hidden = YES;
        self.backBtn.hidden = YES;
        self.searchHandleBtn.hidden = YES;
    }
    
}

- (IBAction)shopCarHandle:(UIButton *)sender {
    if (self.shopCarHandle) {
        self.shopCarHandle();
    }
}

- (IBAction)typeBtnHandle:(UIButton *)sender {
    if (self.filterHandle) {
        self.filterHandle();
    }
}


- (IBAction)searchBtnHandle:(UIButton *)sender {
    if (self.searchHandle) {
        self.searchHandle();
    }
}

- (IBAction)backBtnHandle:(UIButton *)sender {
    if (self.backHandle) {
        self.backHandle();
    }
}


- (IBAction)searchHandle:(UIButton *)sender {
    if (self.searchTapHandle) {
        self.searchTapHandle(@"");
    }
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.tfBeginEditing) {
        self.tfBeginEditing();
    }
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self endEditing:YES];
    
    if (self.searchTapHandle) {
        self.searchTapHandle(self.searchTF.text);
    }
    
    return YES;
}


@end
