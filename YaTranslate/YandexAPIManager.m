//
//  YandexAPIManager.m
//  YaTranslate
//
//  Created by Nikita Makarov on 08/10/15.
//  Copyright © 2015 Nikita Makarov. All rights reserved.
//

#import "YandexAPIManager.h"
#import "AFNetworking.h"

static const NSString *APIkey = @"trnsl.1.1.20150930T074032Z.cb21f79f9c2cb0c6.290b8003dc75a4edce017c8a5baa8103fb2471c5";

@interface YandexAPIManager ()

@property (strong, nonatomic) AFHTTPRequestOperationManager *requestOperationManager;
@property (strong, nonatomic) NSMutableDictionary *languages;

@end

@implementation YandexAPIManager

+ (YandexAPIManager *)sharedManager
{
    static YandexAPIManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YandexAPIManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURL *baseURL = [NSURL URLWithString:@"https://translate.yandex.net/api/v1.5/tr.json/"];
        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
        [self loadLanguagesListForLanguageCode:@"ru"];
    }
    return self;
}

- (void)translateText:(NSString *)text
         fromLanguage:(NSString *)fromLang
           toLanguage:(NSString *)toLang
            onSuccess:(void(^)(NSString *translation))success
            onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure
{
    NSMutableString *lang = [NSMutableString string];
    NSString *from = [[self.languages allKeysForObject:fromLang] firstObject];
    // check for autodetect language
    if (from.length > 0) {
        [lang appendFormat:@"%@-", from];
    }
    NSString *to = [[self.languages allKeysForObject:toLang] firstObject];
    [lang appendString:to];
    
    NSDictionary *parameters = @{@"key": APIkey,
                                 @"text": text,
                                 @"lang": lang};
    
    NSLog(@"Begin translating...");
    NSLog(@"Text length: %d", text.length);
    NSLog(@"Lang: %@\n", lang);
    
    [self.requestOperationManager GET:@"translate"
                           parameters:parameters
                              success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                                  id translations = [responseObject objectForKey:@"text"];
                                  NSString *translation = [translations firstObject];
                                  
                                  NSLog(@"Success");
                                  NSLog(@"Translate: %@\n", translation);
                                  
                                  if (success) {
                                      success(translation);
                                  }
                              }
                              failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                                  NSLog(@"Error: %@", error);
                                  if (failure) {
                                      failure(error, operation.response.statusCode);
                                  }
                              }];
}

- (void)loadLanguagesListForLanguageCode:(NSString *)languageCode
{
    NSDictionary *parameters = @{@"key": APIkey,
                                 @"ui": languageCode};
    
    [self.requestOperationManager GET:@"getLangs"
                           parameters:parameters
                              success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                                  self.languages = [responseObject objectForKey:@"langs"];
                                  NSLog(@"Supported languages downloaded.\n");
                              }
                              failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                                  NSLog(@"Error %d: %@", operation.response.statusCode, error);
                              }];
}

- (NSArray *)supportedLanguages
{
#pragma mark - FIXME: self.languages is nil, if loading languages not ended
    //NSArray *allLangs = [self.languages allValues];
    //NSLog(@"%@", allLangs);
    return [self.languages allValues];
}

@end
