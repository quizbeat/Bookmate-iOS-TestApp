//
//  LanguageSelectionViewController.h
//  YaTranslate
//
//  Created by Nikita Makarov on 08/10/15.
//  Copyright © 2015 Nikita Makarov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LanguageSelectionDelegate;

@interface LanguageSelectionViewController : UITableViewController

@property (weak, nonatomic) id <LanguageSelectionDelegate> delegate;
@property (weak, nonatomic) id sender;

- (IBAction)actionDoneButtonPressed:(UIBarButtonItem *)sender;

@end


@protocol LanguageSelectionDelegate <NSObject>

@required

- (void)languageSelectionView:(LanguageSelectionViewController *)languageSelectionView didChangeLanguageTo:(NSString *)language forSender:(id)sender;

@end