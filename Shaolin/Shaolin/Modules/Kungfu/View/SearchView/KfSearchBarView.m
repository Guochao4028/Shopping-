//
//  KfSearchBarView.m
//  Shaolin
//
//  Created by ws on 2020/5/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KfSearchBarView.h"
#import "NSString+Tool.h"

@interface KfSearchBarView() <UITextFieldDelegate>

@end

@implementation KfSearchBarView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.searchTF setDelegate:self];
    [self.searchTF setReturnKeyType:UIReturnKeySearch];
}


- (IBAction)backEvent:(UIButton *)sender {
    if (self.backHandle) {
        self.backHandle();
    }
}

- (IBAction)searEvent:(UIButton *)sender {
    if (self.searchHandle) {
        self.searchHandle(self.searchTF.text);
    }
}

- (IBAction)filterEvent:(UIButton *)sender {
    if (self.filterHandle) {
        self.filterHandle();
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.tfBeginEditing) {
        self.tfBeginEditing();
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (self.searchHandle) {
        self.searchHandle(self.searchTF.text);
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([NSString isContainsEmoji:string]) {
        return NO;
    }
    return YES;
}

//- (void)setSearchType:(KfSearchType)searchType {
//    _searchType = searchType;
//}

@end
