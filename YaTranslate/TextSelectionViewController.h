//
//  TextSelectionViewController.h
//  YaTranslate
//
//  Created by Nikita Makarov on 09/10/15.
//  Copyright © 2015 Nikita Makarov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TextSelectionDelegate;

@interface TextSelectionViewController : UITableViewController

@property (weak, nonatomic) id <TextSelectionDelegate> delegate;

- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender;

@end


@protocol TextSelectionDelegate <NSObject>

@required

- (void)textSelectionView:(TextSelectionViewController *)textSelectionView didChangeTextToTextNamed:(NSString *)textName contents:(NSString *)text;

@end