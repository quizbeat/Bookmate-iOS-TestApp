//
//  UIAlertController+ErrorAlert.m
//  YaTranslate
//
//  Created by Nikita Makarov on 27/10/15.
//  Copyright © 2015 Nikita Makarov. All rights reserved.
//

#import "UIAlertController+ErrorAlert.h"

@implementation UIAlertController (ErrorAlert)

+ (UIAlertController *)errorAlertWithMessage:(NSString *)message
{
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:action];
    return alert;
}

+ (UIAlertController *)warningAlertWithMessage:(NSString *)message
{
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:@"Warning" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:action];
    return alert;
}

@end
