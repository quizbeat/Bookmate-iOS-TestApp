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

static NSString *autoDetectLanguage = @"Авто";
static NSString *defaultFromLanguage = @"Авто";
static NSString *defaultToLanguage = @"Русский";

@interface TranslateViewController () <LanguageSelectionDelegate>

@property (strong, nonatomic) LanguageSelectionViewController *languageSelectionView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation TranslateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // fix for empty space in UITextView
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    // setup text views frames
    self.originalTextView.layer.borderWidth = 2.0;
    self.originalTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.originalTextView.layer.cornerRadius = 5;
    self.originalTextView.clipsToBounds = YES;
    
    self.translatedTextView.layer.borderWidth = 2.0;
    self.translatedTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.translatedTextView.layer.cornerRadius = 5;
    self.translatedTextView.clipsToBounds = YES;
    
    
    // init buttons
    [self.fromLangButton setTitle:defaultFromLanguage forState:UIControlStateNormal];
    [self.toLangButton setTitle:defaultToLanguage forState:UIControlStateNormal];
    
    self.fromLangButton.layer.borderWidth = 1.0;
    self.fromLangButton.layer.borderColor = [self.fromLangButton.tintColor CGColor];
    self.fromLangButton.layer.cornerRadius = 5;
    self.fromLangButton.titleLabel.numberOfLines = 1;
    self.fromLangButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.fromLangButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
    
    self.toLangButton.layer.borderWidth = 1.0;
    self.toLangButton.layer.borderColor = [self.toLangButton.tintColor CGColor];
    self.toLangButton.layer.cornerRadius = 5;
    self.toLangButton.titleLabel.numberOfLines = 1;
    self.toLangButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.toLangButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
    
    self.arrowButton.userInteractionEnabled = NO;
    
    
    // init activity indicator
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    self.activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
                                              UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    self.activityIndicator.frame = CGRectMake(0, 0, 70, 70);
    self.activityIndicator.center = self.view.center;
    
    self.activityIndicator.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.activityIndicator.layer.cornerRadius = 10;
    self.activityIndicator.clipsToBounds = YES;
    
    [self.view addSubview:self.activityIndicator];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // setup original text
    [self.originalTextView setText:self.originalText];
    
    [self.originalTextView scrollRangeToVisible:NSMakeRange(0, 1)]; // scroll text to top
    [self.translatedTextView scrollRangeToVisible:NSMakeRange(0, 1)];
    
    [self translateText];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Translation

- (void)translateText
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [self.activityIndicator startAnimating];
    [[YandexAPIManager sharedManager] translateText:self.originalTextView.text
                                       fromLanguage:self.fromLangButton.currentTitle
                                         toLanguage:self.toLangButton.currentTitle
                                          onSuccess:^(NSString *translation) {
                                              self.translatedTextView.text = translation;
                                              [self.activityIndicator stopAnimating];
                                              [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                                          } onFailure:^(NSError *error, NSInteger statusCode) {
                                              self.translatedTextView.text = [NSString stringWithFormat:@"Error %ld: %@", (long)statusCode, error];
                                              [self.activityIndicator stopAnimating];
                                              [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                                          }];
}

#pragma mark - Actions

- (IBAction)selectLanguageButtonPressed:(UIButton *)sender
{
    if (!self.languageSelectionView) {
        self.languageSelectionView =
        [self.storyboard instantiateViewControllerWithIdentifier:@"LanguageSelectionScreen"];
    }
    
    self.languageSelectionView.delegate = self;
    self.languageSelectionView.sender = sender;
    
    [self.navigationController pushViewController:self.languageSelectionView animated:YES];
}

#pragma mark - LanguageSelectionDelegate

- (void)updateLanguageTo:(NSString *)language forSender:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    NSLog(@"Begin updating language...");
    NSLog(@"Language arg: %@", language);
    NSLog(@"Old: %@ -> %@", self.fromLangButton.currentTitle, self.toLangButton.currentTitle); // not works with .titleLabel.text WAT
    
    if (sender == self.toLangButton && [language isEqualToString:autoDetectLanguage]) {
        [button setTitle:defaultToLanguage forState:UIControlStateNormal];
    } else {
        [button setTitle:language forState:UIControlStateNormal];
    }
    
    NSLog(@"New: %@ -> %@", self.fromLangButton.currentTitle, self.toLangButton.currentTitle);
    NSLog(@"End updating language.\n");
}

@end
