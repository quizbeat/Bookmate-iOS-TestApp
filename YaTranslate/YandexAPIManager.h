//
//  YandexAPIManager.h
//  YaTranslate
//
//  Created by Nikita Makarov on 08/10/15.
//  Copyright © 2015 Nikita Makarov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YandexAPIManager : NSObject

+ (YandexAPIManager *)sharedManager;

- (void)translateText:(NSString *)text
         fromLanguage:(NSString *)fromLang
           toLanguage:(NSString *)toLang
            onSuccess:(void(^)(NSString *translation))success
            onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure;
- (NSArray *)supportedLanguages;

@end
