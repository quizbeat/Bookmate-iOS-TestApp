//
//  LanguageSelectionViewController.m
//  YaTranslate
//
//  Created by Nikita Makarov on 08/10/15.
//  Copyright © 2015 Nikita Makarov. All rights reserved.
//

#import "LanguageSelectionViewController.h"
#import "YandexAPIManager.h"

@interface LanguageSelectionViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *languages;
@property (weak, nonatomic) UITableViewCell *selectedCell;

@end

@implementation LanguageSelectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    YandexAPIManager *manager = [YandexAPIManager sharedManager];
    
    NSMutableArray *languages = [[manager supportedLanguages] mutableCopy];
    [languages insertObject:@"Авто" atIndex:0];
    
    [languages sortUsingComparator:^NSComparisonResult(NSString *lang1, NSString *lang2) {
        return [lang1 compare:lang2];
    }];
    
    self.languages = languages;
    
    NSLog(@"LanguageSelectionViewController didLoad");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.languages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"LanguageCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.textLabel.text = [self.languages objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectedCell.accessoryType = UITableViewCellAccessoryNone;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [self.delegate updateLanguageTo:cell.textLabel.text forSender:self.sender];
    self.selectedCell = cell;
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
