//
//  SLLocalizedHelper.m
//  Shaolin
//
//  Created by 王精明 on 2020/7/20.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "SLLocalizedHelper.h"
static NSBundle *_bundle;

static NSString *const kUserLanguage = @"kUserLanguage";

@implementation SLLocalizedHelper

+ (instancetype)standardHelper {
    static SLLocalizedHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[SLLocalizedHelper alloc] init];
    });
    return helper;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        if (!_bundle) {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            NSString *userLanguage = [defaults valueForKey:kUserLanguage];
            
            //用户未手动设置过语言
            if (userLanguage.length == 0) {
                
                NSArray *languages = [[NSBundle mainBundle] preferredLocalizations];
                
                NSString *systemLanguage = languages.firstObject;
                
                userLanguage = systemLanguage;
            }
            
            if ([userLanguage isEqualToString:@"zh-HK"] || [userLanguage isEqualToString:@"zh-TW"]) {
                userLanguage = @"zh-Hant";
            }
            
            NSString *path = [[NSBundle mainBundle] pathForResource:userLanguage ofType:@"lproj"];
            
            _bundle = [NSBundle bundleWithPath:path];
        }
        
    }
    return self;
}

- (NSBundle *)bundle {
    return _bundle;
}

- (NSString *)currentLanguage {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userLanguage = [defaults valueForKey:kUserLanguage];
    
    if (userLanguage.length == 0) {
        
        NSArray *languages = [[NSBundle mainBundle] preferredLocalizations];
        
        NSString *systemLanguage = languages.firstObject;
        
        return systemLanguage;
    }
    
    return userLanguage;
}

- (void)setUserLanguage:(NSString *)language {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
    
    _bundle = [NSBundle bundleWithPath:path];
    
    [defaults setValue:language forKey:kUserLanguage];
    
    [defaults synchronize];
}

- (NSString *)stringWithKey:(NSString *)key {
    
    if (_bundle) {
        return [_bundle localizedStringForKey:key value:nil table:@"Localizable"];
    }else {
        return NSLocalizedString(key, nil);
    }
}
@end
