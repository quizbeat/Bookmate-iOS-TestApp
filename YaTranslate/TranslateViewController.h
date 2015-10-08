//
//  TranslateViewController.h
//  YaTranslate
//
//  Created by Nikita Makarov on 08/10/15.
//  Copyright © 2015 Nikita Makarov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TranslateViewController : UIViewController

@property (strong, nonatomic) NSString *originalText;
@property (strong, nonatomic) NSString *translatedText;

@property (weak, nonatomic) IBOutlet UITextView *originalTextView;
@property (weak, nonatomic) IBOutlet UITextView *translatedTextView;

@property (weak, nonatomic) IBOutlet UIButton *arrowButton;
@property (weak, nonatomic) IBOutlet UIButton *fromLangButton;
@property (weak, nonatomic) IBOutlet UIButton *toLangButton;

- (IBAction)selectLanguageButtonPressed:(UIButton *)sender;

@end
