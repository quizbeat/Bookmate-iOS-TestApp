//
//  TextViewController.m
//  YaTranslate
//
//  Created by Nikita Makarov on 08/10/15.
//  Copyright © 2015 Nikita Makarov. All rights reserved.
//

#import "TextViewController.h"
#import "TranslateViewController.h"
#import "YandexAPIManager.h"

@interface TextViewController ()

@property (strong, nonatomic) TranslateViewController *translateView;

@end

@implementation TextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setup text view settings
    NSLog(@"%@", NSStringFromCGRect(self.textView.frame));
    self.textView.textContainerInset = UIEdgeInsetsMake(0, 8, 0, 8);
    self.textView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 2);
    [self.textView scrollRangeToVisible:NSMakeRange(0, 1)]; // scroll text to begin ??
    
    
    // setup menu controller
    UIMenuItem *translateItem = [[UIMenuItem alloc] initWithTitle:@"Translate" action:@selector(showTranslateView)];
    [[UIMenuController sharedMenuController] setMenuItems:@[translateItem]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // load manager and properties
        [YandexAPIManager sharedManager];
    });
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

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    //NSLog(@"canPerformAction");
    if (action == @selector(showTranslateView)) {
        return YES;
    }
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
