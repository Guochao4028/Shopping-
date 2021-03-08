//
//  NSData+AES256.h
//  Shaolin
//
//  Created by 郭超 on 2020/12/1.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (AES256)

- (NSData *)aes256_encrypt:(NSString *)key;
- (NSData *)aes256_decrypt:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
