//
//  TextSelectionViewController.h
//  YaTranslate
//
//  Created by Nikita Makarov on 09/10/15.
//  Copyright © 2015 Nikita Makarov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TextSelectionDelegate <NSObject>

@required

- (void)setNewText:(NSString *)text;

@end

@interface TextSelectionViewController : UITableViewController

@property (weak, nonatomic) id <TextSelectionDelegate> delegate;

- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender;

@end
