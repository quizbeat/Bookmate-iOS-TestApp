//
//  LanguageSelectionViewController.h
//  YaTranslate
//
//  Created by Nikita Makarov on 08/10/15.
//  Copyright © 2015 Nikita Makarov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LanguageSelectionDelegate <NSObject>

@required

- (void)updateLanguageTo:(NSString *)language forSender:(id)sender;

@end

@interface LanguageSelectionViewController : UITableViewController

@property (weak, nonatomic) id <LanguageSelectionDelegate> delegate;
@property (weak, nonatomic) id sender;

@end
