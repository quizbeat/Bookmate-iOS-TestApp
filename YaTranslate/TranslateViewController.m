//
//  TranslateViewController.m
//  YaTranslate
//
//  Created by Nikita Makarov on 08/10/15.
//  Copyright © 2015 Nikita Makarov. All rights reserved.
//

#import "TranslateViewController.h"
#import "LanguageSelectionViewController.h"
#import "YandexAPIManager.h"
#import "Reachability.h"
#import "UIAlertController+ErrorAlert.h"

static NSString * const autoDetectLanguage = @"Auto";
static NSString * const defaultFromLanguage = @"Auto";
static NSString * const defaultToLanguage = @"Russian";

@interface TranslateViewController () <LanguageSelectionDelegate, YandexAPIManagerDelegate>

@end

@implementation TranslateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[YandexAPIManager sharedManager] setDelegate:self];
    
    // fix for empty space in UITextView
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initTextViews];
    [self initButtons];
    
    // setup text views
    [self.originalTextView setText:self.originalText];
    [self.originalTextView scrollRangeToVisible:NSMakeRange(0, 1)]; // scroll text to top
    [self.translatedTextView scrollRangeToVisible:NSMakeRange(0, 1)];
    
    [self translateText];
}

- (void)initTextViews
{
    UIColor *borderColor = [UIColor colorWithRed:(163.0 / 255) green:(117.0 / 255) blue:(71.0 / 255) alpha:1.0];
    
    self.originalTextView.layer.borderWidth = 1.0;
    self.originalTextView.layer.borderColor = [borderColor CGColor];
    self.originalTextView.layer.cornerRadius = 5;
    self.originalTextView.clipsToBounds = YES;
    
    self.translatedTextView.layer.borderWidth = 1.0;
    self.translatedTextView.layer.borderColor = [borderColor CGColor];
    self.translatedTextView.layer.cornerRadius = 5;
    self.translatedTextView.clipsToBounds = YES;
}

- (void)initButtons
{
    [self.fromLanguageButton setTitle:defaultFromLanguage forState:UIControlStateNormal];
    [self.toLanguageButton setTitle:defaultToLanguage forState:UIControlStateNormal];
    
    self.fromLanguageButton.layer.borderWidth = 1.0;
    self.fromLanguageButton.layer.borderColor = [self.fromLanguageButton.tintColor CGColor];
    self.fromLanguageButton.layer.cornerRadius = 5;
    self.fromLanguageButton.titleLabel.numberOfLines = 1;
    self.fromLanguageButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.fromLanguageButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
    
    self.toLanguageButton.layer.borderWidth = 1.0;
    self.toLanguageButton.layer.borderColor = [self.toLanguageButton.tintColor CGColor];
    self.toLanguageButton.layer.cornerRadius = 5;
    self.toLanguageButton.titleLabel.numberOfLines = 1;
    self.toLanguageButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.toLanguageButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
    
    self.arrowButton.userInteractionEnabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}



#pragma mark - Translation

- (void)translateText
{
    self.translatedTextView.text = @"";
    [self.activityIndicator startAnimating];
    
    TranslateViewController * __weak weakSelf = self;
    
    NSString *text = self.originalTextView.text;
    NSString *fromLang = self.fromLanguageButton.currentTitle;
    NSString *toLang = self.toLanguageButton.currentTitle;
    
    [[YandexAPIManager sharedManager] checkInternetConnectionWithBlockOnSuccess:^{
        [[YandexAPIManager sharedManager] translateText:text fromLanguage:fromLang toLanguage:toLang];
    } onFailure:^{
        [weakSelf.activityIndicator stopAnimating];
        UIAlertController *errorAlert = [UIAlertController errorAlertWithMessage:@"Please check your internet connection"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf presentViewController:errorAlert animated:YES completion:nil];
        });
    }];
}



#pragma mark - LanguageSelectionDelegate

- (void)languageSelectionView:(LanguageSelectionViewController *)languageSelectionView didChangeLanguageTo:(NSString *)language forSender:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    NSLog(@"Translation direction changed:");
    NSLog(@"from direction: %@ -> %@", self.fromLanguageButton.currentTitle, self.toLanguageButton.currentTitle); // doesn't work with .titleLabel.text WAT
    
    if (sender == self.toLanguageButton && [language isEqualToString:autoDetectLanguage]) {
        [button setTitle:defaultToLanguage forState:UIControlStateNormal];
    } else {
        [button setTitle:language forState:UIControlStateNormal];
    }
    
    NSLog(@"to direction: %@ -> %@", self.fromLanguageButton.currentTitle, self.toLanguageButton.currentTitle);
    
    [self translateText];
}



#pragma mark - YandexAPIManagerDelegate

- (void)YandexAPIManager:(YandexAPIManager *)manager didSuccessTranslation:(NSString *)translation detectedLanguage:(NSString *)detectedLang
{
    [self.activityIndicator stopAnimating];
    self.translatedTextView.text = translation;
    if ([self.fromLanguageButton.titleLabel.text isEqualToString:autoDetectLanguage]) {
        [self.fromLanguageButton setTitle:detectedLang forState:UIControlStateNormal];
    }
}

- (void)YandexAPIManager:(YandexAPIManager *)manager didFailTranslationWithError:(NSError *)error description:(NSString *)description
{
    [self.activityIndicator stopAnimating];
    [[YandexAPIManager sharedManager]
     checkInternetConnectionWithBlockOnSuccess:^{
         UIAlertController *errorAlert = [UIAlertController errorAlertWithMessage:description];
         [self presentViewController:errorAlert animated:YES completion:nil];
     } onFailure:^{
         UIAlertController *errorAlert = [UIAlertController errorAlertWithMessage:@"Please check your internet connection"];
         [self presentViewController:errorAlert animated:YES completion:nil];
     }];
}

- (void)YandexAPIManager:(YandexAPIManager *)manager didCutText:(NSString *)text cuttedText:(NSString *)cuttedText
{
    self.originalTextView.text = cuttedText;
    NSString *message = @"Text is too long, was cut to 1000 characters";
    UIAlertController *warningAler = [UIAlertController warningAlertWithMessage:message];
    [self presentViewController:warningAler animated:YES completion:nil];
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SelectFromLanguageSegue"] ||
        [segue.identifier isEqualToString:@"SelectToLanguageSegue"]) {
        UINavigationController *navController = segue.destinationViewController;
        LanguageSelectionViewController *languageSelectionView = navController.viewControllers.firstObject;
        languageSelectionView.delegate = self;
        languageSelectionView.sender = sender;
    }
}

@end
