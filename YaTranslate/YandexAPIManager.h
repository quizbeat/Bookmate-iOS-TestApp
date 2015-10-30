//
//  YandexAPIManager.h
//  YaTranslate
//
//  Created by Nikita Makarov on 08/10/15.
//  Copyright © 2015 Nikita Makarov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YandexAPIManagerDelegate;

@interface YandexAPIManager : NSObject

@property (nonatomic, assign, getter=isLanguagesLoaded) BOOL languagesLoaded;
@property (weak, nonatomic) id <YandexAPIManagerDelegate> delegate;

+ (YandexAPIManager *)sharedManager;

- (void)translateText:(NSString *)text fromLanguage:(NSString *)fromLang toLanguage:(NSString *)toLang;
- (void)supportedLanguagesWithBlockOnSuccess:(void(^)(id arg))success onFailure:(void(^)(void))failure;
- (void)checkInternetConnectionWithBlockOnSuccess:(void(^)(void))success onFailure:(void(^)(void))failure;

@end


@protocol YandexAPIManagerDelegate <NSObject>

@optional

- (void)YandexAPIManager:(YandexAPIManager *)manager didSuccessTranslation:(NSString *)translation detectedLanguage:(NSString *)detectedLang;
- (void)YandexAPIManager:(YandexAPIManager *)manager didFailTranslationWithError:(NSError *)error description:(NSString *)description;
- (void)YandexAPIManager:(YandexAPIManager *)manager didCutText:(NSString *)text cuttedText:(NSString *)cuttedText;

@end