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

static NSString *defaultToLanguage = @"Русский";
static NSString *autoDetectLanguage = @"Авто";

@interface TranslateViewController () <LanguageSelectionDelegate>

@property (strong, nonatomic) LanguageSelectionViewController *languageSelectionView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation TranslateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setup text views frames
    self.originalTextView.layer.borderWidth = 2.0;
    self.originalTextView.layer.borderColor = [[[UIColor blueColor] colorWithAlphaComponent:0.5] CGColor];
    self.originalTextView.layer.cornerRadius = 5;
    self.originalTextView.clipsToBounds = YES;
    // self.originalTextView.textContainerInset = UIEdgeInsetsMake(0, 2, 0, 2);
    
    self.translatedTextView.layer.borderWidth = 2.0;
    self.translatedTextView.layer.borderColor = [[[UIColor blueColor] colorWithAlphaComponent:0.5] CGColor];
    self.translatedTextView.layer.cornerRadius = 5;
    self.translatedTextView.clipsToBounds = YES;
    
    // init buttons
    [self.fromLangButton setTitle:@"Авто" forState:UIControlStateNormal];
    [self.toLangButton setTitle:@"Русский" forState:UIControlStateNormal];
    
    // init activity indicator
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.center = self.view.center;
    [self.view addSubview:self.activityIndicator];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // setup original text
    self.originalTextView.text = self.originalText;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [self.activityIndicator startAnimating];
    [self translateText];
    //NSLog(@"viewWillAppear");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Translation

- (void)translateText
{
    [[YandexAPIManager sharedManager] translateText:self.originalTextView.text
                                       fromLanguage:self.fromLangButton.currentTitle
                                         toLanguage:self.toLangButton.currentTitle
                                          onSuccess:^(NSString *translation) {
                                              self.translatedTextView.text = translation;
                                              [self.activityIndicator stopAnimating];
                                              [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                                          } onFailure:^(NSError *error, NSInteger statusCode) {
                                              self.translatedTextView.text = @"Error";
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
