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

@interface TextViewController () <TextSelectionDelegate>

@property (strong, nonatomic) TranslateViewController *translateView;
@property (strong, nonatomic) UINavigationController *textSelectionNavigationController;

@end

@implementation TextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setup text view settings
    self.textView.textContainerInset = UIEdgeInsetsMake(0, 8, 0, 8);
    self.textView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 2);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.textView scrollRangeToVisible:NSMakeRange(0, 1)]; // scroll text to begin

    
    // setup menu controller
    UIMenuItem *translateItem = [[UIMenuItem alloc] initWithTitle:@"Translate" action:@selector(showTranslateView)];
    [[UIMenuController sharedMenuController] setMenuItems:@[translateItem]];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // load manager and properties
        [YandexAPIManager sharedManager];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (void)showTranslateView
{
    NSRange selectedRange = [self.textView selectedRange];
    NSString *selectedText = [self.textView.text substringWithRange:selectedRange];
    NSLog(@"%@", selectedText);
    
    if (!self.translateView) {
        self.translateView = [self.storyboard instantiateViewControllerWithIdentifier:@"TranslationScreen"];
    }
    
    self.translateView.originalText = selectedText;
    
    [self.navigationController pushViewController:self.translateView animated:YES];
}


- (IBAction)selectTextButtonPressed:(UIBarButtonItem *)sender
{
    if (!self.textSelectionNavigationController) {
        self.textSelectionNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"TextSelectionScreen"];
        TextSelectionViewController *textSelectionView = self.textSelectionNavigationController.viewControllers.firstObject;
        textSelectionView.delegate = self;
        textSelectionView.modalPresentationStyle = UIModalPresentationPopover;
    }
    [self presentViewController:self.textSelectionNavigationController animated:YES completion:nil];
}

#pragma mark - TextSelectionDelegate

- (void)setNewText:(NSString *)text
{
    if (text.length > 0) {
        [self.textView setText:text];
    }
}

@end
