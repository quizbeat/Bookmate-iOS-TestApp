//
//  TextSelectionViewController.m
//  YaTranslate
//
//  Created by Nikita Makarov on 09/10/15.
//  Copyright © 2015 Nikita Makarov. All rights reserved.
//

#import "TextSelectionViewController.h"

@interface TextSelectionViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *texts;

@end

@implementation TextSelectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.texts = [NSMutableArray array];
    
    // load all texts
    NSArray *textsPaths = [[NSBundle mainBundle] pathsForResourcesOfType:@"txt" inDirectory:@""];
    for (NSString *path in textsPaths) {
        NSString *textName = [[path lastPathComponent] stringByDeletingPathExtension];
        [self.texts addObject:textName];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}



#pragma mark - Actions

- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.texts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TextCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.textLabel.text = [self.texts objectAtIndex:indexPath.row];
    
    return cell;
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *textName = cell.textLabel.text;
    
    NSString *textPath = [[NSBundle mainBundle] pathForResource:textName ofType:@"txt"];
    NSString *text = [NSString stringWithContentsOfFile:textPath encoding:NSUTF8StringEncoding error:nil];
    
    [self.delegate textSelectionView:self didChangeTextToTextNamed:textName contents:text];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
