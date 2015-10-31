//
//  LanguageSelectionViewController.m
//  YaTranslate
//
//  Created by Nikita Makarov on 08/10/15.
//  Copyright © 2015 Nikita Makarov. All rights reserved.
//

#import "LanguageSelectionViewController.h"
#import "UIAlertController+ErrorAlert.h"
#import "YandexAPIManager.h"

@interface LanguageSelectionViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *languages;

@end

@implementation LanguageSelectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.languages = [NSArray array];
    
    LanguageSelectionViewController * __weak weakSelf = self;
    
    [[YandexAPIManager sharedManager] supportedLanguagesWithBlockOnSuccess:^(NSArray *languages) {
        weakSelf.languages = languages;
        [weakSelf sortLanguages];
        [weakSelf insertAutodetectLanguage];
        [weakSelf.tableView reloadData];
    } onFailure:^{
        UIAlertController *errorAlert = [UIAlertController errorAlertWithMessage:@"Can't load languages"];
        [weakSelf presentViewController:errorAlert animated:YES completion:nil];
        NSLog(@"can't load languages");
    }];
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

- (void)insertAutodetectLanguage
{
    NSMutableArray *languages = [self.languages mutableCopy];
    [languages insertObject:@"Auto" atIndex:0];
    self.languages = languages;
}

- (void)sortLanguages
{
    self.languages = [self.languages sortedArrayUsingComparator:^NSComparisonResult(NSString *lang1, NSString *lang2) {
        return [lang1 compare:lang2];
    }];
}

- (IBAction)actionDoneButtonPressed:(UIBarButtonItem *)sender
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
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    NSString *language = cell.textLabel.text;
    
    [self.delegate languageSelectionView:self didChangeLanguageTo:language forSender:self.sender];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
