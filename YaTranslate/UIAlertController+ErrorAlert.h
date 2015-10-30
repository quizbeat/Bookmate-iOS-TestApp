//
//  UIAlertController+ErrorAlert.h
//  YaTranslate
//
//  Created by Nikita Makarov on 27/10/15.
//  Copyright © 2015 Nikita Makarov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (ErrorAlert)

+ (UIAlertController *)errorAlertWithMessage:(NSString *)message;
+ (UIAlertController *)warningAlertWithMessage:(NSString *)message;

@end
