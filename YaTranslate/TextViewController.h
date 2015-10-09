//
//  TextViewController.h
//  YaTranslate
//
//  Created by Nikita Makarov on 08/10/15.
//  Copyright © 2015 Nikita Makarov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *textView;

- (IBAction)selectTextButtonPressed:(UIBarButtonItem *)sender;

@end
