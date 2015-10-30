//
//  TextViewController.m
//  YaTranslate
//
//  Created by Nikita Makarov on 08/10/15.
//  Copyright © 2015 Nikita Makarov. All rights reserved.
//

#import "TextViewController.h"
#import "TextSelectionViewController.h"
#import "TranslateViewController.h"
#import "YandexAPIManager.h"
#import "UIAlertController+ErrorAlert.h"

static NSString * const defaultText = @"Great Expectations";

@interface TextViewController () <TextSelectionDelegate>

@end

@implementation TextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setup default text
    NSString *filePath = [[NSBundle mainBundle] pathForResource:defaultText ofType:@"txt"];
    NSString *text = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    self.textView.text = text;
    self.navigationItem.title = defaultText;
    
    
    // setup text view settings
    self.textView.textContainerInset = UIEdgeInsetsMake(0, 8, 0, 8);
    self.textView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 2);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.textView scrollRangeToVisible:NSMakeRange(0, 1)]; // scroll text to top

    
    // setup menu controller
    UIMenuItem *translateItem = [[UIMenuItem alloc] initWithTitle:@"Translate" action:@selector(actionTranslateButtonClicked)];
    [[UIMenuController sharedMenuController] setMenuItems:@[translateItem]];
    
    
    // check internet connection
    TextViewController * __weak weakSelf = self;
    [[YandexAPIManager sharedManager]
     checkInternetConnectionWithBlockOnSuccess:nil
     onFailure:^{
         UIAlertController *warningAlert =
         [UIAlertController warningAlertWithMessage:@"Internet connection required. Please check your internet connection"];
         dispatch_async(dispatch_get_main_queue(), ^{
             [weakSelf presentViewController:warningAlert animated:YES completion:nil];
         });
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}



#pragma mark - Actions

- (void)actionTranslateButtonClicked
{
    // simulate click on hidden button to perform TranslateSegue
    [self.translateButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SelectTextSegue"]) {
        UINavigationController *navController = segue.destinationViewController;
        TextSelectionViewController *textSelectionView = navController.viewControllers.firstObject;
        textSelectionView.delegate = self;
    } else if ([segue.identifier isEqualToString:@"TranslateSegue"]) {
        NSRange selectedRange = [self.textView selectedRange];
        NSString *selectedText = [self.textView.text substringWithRange:selectedRange];
        TranslateViewController *translateView = segue.destinationViewController;
        translateView.originalText = selectedText;
    }
}



#pragma mark - TextSelectionDelegate

- (void)textSelectionView:(TextSelectionViewController *)textSelectionView didChangeTextToTextNamed:(NSString *)textName contents:(NSString *)text
{
    self.navigationItem.title = textName;
    self.textView.text = text;
}

@end
