//
//  YandexAPIManager.m
//  YaTranslate
//
//  Created by Nikita Makarov on 08/10/15.
//  Copyright © 2015 Nikita Makarov. All rights reserved.
//

#import "YandexAPIManager.h"
#import "AFNetworking.h"
#import "Reachability.h"

static NSString * const reachabilityHostName = @"www.yandex.ru";
static NSString * const APIkey = @"trnsl.1.1.20150930T074032Z.cb21f79f9c2cb0c6.290b8003dc75a4edce017c8a5baa8103fb2471c5";
static NSString * const defaultLanguageCode = @"en";

@interface YandexAPIManager ()

@property (strong, nonatomic) AFHTTPRequestOperationManager *requestOperationManager;

@property (strong, nonatomic) NSMutableDictionary *languages;
@property (strong, nonatomic) NSMutableDictionary *errorDescriptions;

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *originalText;

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
        self.languagesLoaded = NO;
        [self initResponseCodes];
    }
    NSLog(@"%s", __FUNCTION__);
    return self;
}

- (void)initResponseCodes
{
    self.errorDescriptions = [NSMutableDictionary dictionary];
    [self.errorDescriptions setObject:@"Invalid API key" forKey:@"401"];
    [self.errorDescriptions setObject:@"Blocked API key" forKey:@"402"];
    [self.errorDescriptions setObject:@"Exceeded the daily limit on the number of requests" forKey:@"403"];
    [self.errorDescriptions setObject:@"Exceeded the daily limit on the amount of translated text" forKey:@"404"];
    [self.errorDescriptions setObject:@"Exceeded the maximum text size" forKey:@"413"];
    [self.errorDescriptions setObject:@"The text cannot be translated" forKey:@"422"];
    [self.errorDescriptions setObject:@"The specified translation direction is not supported" forKey:@"501"];
}

- (void)translateText:(NSString *)text fromLanguage:(NSString *)fromLang toLanguage:(NSString *)toLang
{
    self.text = text;
    self.originalText = [text copy];
    [self prepareTextToTranslate];
    
    void (^translate)(void) = ^{
        NSString *direction = [self translationDirectionFrom:fromLang to:toLang];
        
        NSDictionary *parameters = @{@"key": APIkey, @"text": text, @"lang": direction};
        
        NSLog(@"Lang: %@\n", direction);
        
        [self.requestOperationManager GET:@"translate" parameters:parameters
          success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
              id translations = [responseObject objectForKey:@"text"];
              
              NSString *translation = [translations firstObject]; // first translation
              
              NSString *direction = [responseObject objectForKey:@"lang"];
              NSArray *components = [direction componentsSeparatedByString:@"-"];
              NSString *detectedLangCode = [components firstObject];
              NSString *detectedLang = [self.languages objectForKey:detectedLangCode];
              
              NSLog(@"Translation success.");
              
              [self.delegate YandexAPIManager:self didSuccessTranslation:translation detectedLanguage:detectedLang];
          }
          failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
              NSLog(@"Translation error: %@", error);
              NSString *errorDescription = [self descriptionForErrorCode:operation.response.statusCode];
              [self.delegate YandexAPIManager:self didFailTranslationWithError:error description:errorDescription];
          }];
    };
    
    if ([self isLanguagesLoaded]) {
        translate();
    } else {
        [self loadSupportedLanguagesWithBlockOnSuccess:^(id arg) {
            translate();
        } onFailure:^{
            NSLog(@"loading languages error");
        }];
    }
}

- (void)prepareTextToTranslate
{
    NSLog(@"Text length: %li", (long)self.text.length);
    if (self.text.length > 1000) {
        self.text = [self.text substringToIndex:1000];
        [self.delegate YandexAPIManager:self didCutText:self.originalText cuttedText:self.text];
        NSLog(@"Text is too long, was cut to 1000 characters");
    }
}

- (NSString *)translationDirectionFrom:(NSString *)fromLang to:(NSString *)toLang
{
    NSMutableString *direction = [NSMutableString string];
    
    NSString *from = [[self.languages allKeysForObject:fromLang] firstObject];
    if (from.length > 0) { // check for autodetect language
        [direction appendFormat:@"%@-", from];
    }
    
    NSString *to = [[self.languages allKeysForObject:toLang] firstObject];
    [direction appendString:to];
    
    return direction;
}

- (void)loadSupportedLanguagesWithBlockOnSuccess:(void(^)(id arg))success onFailure:(void(^)(void))failure
{
    NSDictionary *parameters = @{@"key": APIkey, @"ui": defaultLanguageCode};
    
    [self.requestOperationManager GET:@"getLangs"
                           parameters:parameters
                              success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                                  self.languages = [responseObject objectForKey:@"langs"];
                                  self.languagesLoaded = YES;
                                  if (success) {
                                      success([self supportedLanguages]);
                                  }
                                  NSLog(@"Supported languages downloaded.");
                              }
                              failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                                  if (failure) {
                                      failure();
                                  }
                                  NSLog(@"Error %d: %@", (int)operation.response.statusCode, error);
                              }];
}

- (void)supportedLanguagesWithBlockOnSuccess:(void(^)(id arg))success onFailure:(void(^)(void))failure
{
    if ([self isLanguagesLoaded]) {
        success([self.languages allValues]);
    } else {
        [self loadSupportedLanguagesWithBlockOnSuccess:success onFailure:failure];
    }
}

- (NSArray *)supportedLanguages
{
    return [self.languages allValues];
}

- (NSString *)descriptionForErrorCode:(NSInteger)code
{
    NSString *statusCode = [NSString stringWithFormat:@"%li", (long)code];
    NSString *description = [self.errorDescriptions objectForKey:statusCode];
    return description;
}



#pragma mark - Reachability

- (void)checkInternetConnectionWithBlockOnSuccess:(void(^)(void))success onFailure:(void(^)(void))failure
{
    Reachability *reachability = [Reachability reachabilityWithHostName:reachabilityHostName];
    NetworkStatus status = [reachability currentReachabilityStatus];
    if (status != NotReachable) {
        if (success) {
            success();
        }
    } else {
        if (failure) {
            failure();
        }
    }
}

@end
