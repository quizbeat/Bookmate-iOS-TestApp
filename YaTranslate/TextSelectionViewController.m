//
//  TextSelectionViewController.m
//  YaTranslate
//
//  Created by Nikita Makarov on 09/10/15.
//  Copyright © 2015 Nikita Makarov. All rights reserved.
//

#import "TextSelectionViewController.h"

static const NSString *kChineseText = @"Chinese";
static const NSString *kEnglishText = @"English";
static const NSString *kFrenchText = @"French";
static const NSString *kGermanText = @"German";
static const NSString *kRussianText = @"Russian";

@interface TextSelectionViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableDictionary *texts;
@property (weak, nonatomic) UITableViewCell *selectedCell;

@end

@implementation TextSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.texts = [NSMutableDictionary dictionary];
    [self.texts setObject:@"我上大学的时候，我没想到有机会学东方语言 – 中文。我先自己觉得很难过，是因为听说中文非常难，有很多字，怎么办？我怕连一字也记不住。教师告诉我别的大学中文系竞争比我们的激烈多了，所以我决定在这个大学学中文。可是我还是不放心，那妈妈就跟我说，学中文的人很少，可是他们都是非常需要的专家。从那时起我才有一点放心了。 我觉得最难的就是开始学语言，是因为大家都先得学好写字，念中文的课文什么的，这些事情都花很多时间。虽然我学习中文已经学了两年多了，但是我还是得每天写字，复习学过的东西，跟同学练习。我认为为了学好中文，别的方法都没有用。对我来说，学汉字是最大的困难。不过我的成绩越来越好，我开始喜欢我做的。当然我明白我现在什么做的都是为了将来的丰富生活，所以我更努力学习！ “语言都是文化，经验的累积与传承，都是人类宝贵的资产”。" forKey:kChineseText];
    [self.texts setObject:@"A young dog, a reddish mongrel, between a dachshund and a 'yard-dog', very like a fox in face, was running up and down the pavement looking uneasily from side to side. From time to time she stopped and, whining and lifting first one chilled paw and then another, tried to make up her mind how it could have happened that she was lost. She remembered very well how she had passed the day, and how, in the end, she had found herself on this unfamiliar pavement." forKey:kEnglishText];
    [self.texts setObject:@"Plusieurs jours avant Noël, les villes et les villages de France prennent un air de fête. On décore la façade des mairies. On dresse un immense sapin sur les grandes places. Les rues principales et les arbres sont recouverts de guirlandes lumineuses. Les grands magasins font de très belles vitrines ou certains mettent en scène des automates. Les enfants se font photographier en compagnie du Père Noël. Les écoles maternelles décorent leurs classes. Le 24 au soir les familles font un diner de réveillon composé de mets savoureux tels que des huitres et du foie gras. Les plus pratiquants vont ensuite en famille à la messe de minuit. Le Père Noël vient déposer les cadeaux pendant la nuit et les enfants les découvrent le matin de Noël au pied su sapin. Le jour de Noël, ils se rassemblent en famille autour de la table de Noël. Le repas de Noël est souvent composé d'une dinde ou d'un chapon roti et se termine par une bûche glacée ou en gâteau. En Provence, dans certaines églises du  bord de la mer, à la fin de la messe de minuit, une procession de pêcheurs et de poissonniers déposent au pied de l'hôtel un panier rempli de poissons, en signe d'affection et de reconnaissance envers le petit Jésus. La tradition veut que le repas du réveillon se termine  par treize desserts qui symbolisent le Christ et les douze apôtres. Ces desserts rassemblent tous les fruits et les confiseries de la région." forKey:kFrenchText];
    [self.texts setObject:@"Kräuter und Gewürze werden seit Jahren für die Verbesserung des Geschmacks und des Aromas von diversen Gerichten und für die Behandlung von verschiedenen Krankheiten verwendet. Auf der Erde existieren Hunderte von Arten von verschiedenen Kräutern und jede Art hat ihre ganz besondere Eigenschaften. Was die Pflanzen anbetrifft, so nimmt man üblicherweise Blätter, Stämme, Wurzeln oder Blumen. Unter den Gewürzen versteht man Speisewürzen, die aus der Borke, Samen und Wurzeln mit einem spezifischen Aroma gemacht werden. Üblicherweise werden sie pulverisiert und in diverse Gerichte eingemischt." forKey:kGermanText];
    [self.texts setObject:@"«Что это? я падаю! у меня ноги подкашиваются», — подумал он и упал на спину. Он раскрыл глаза, надеясь увидать, чем кончилась борьба французов с артиллеристами, и желая знать, убит или нет рыжий артиллерист, взяты или спасены пушки. Но он ничего не видал. Над ним не было ничего уже, кроме неба, — высокого неба, не ясного, но все-таки неизмеримо высокого, с тихо ползущими по нем серыми облаками. «Как тихо, спокойно и торжественно, совсем не так, как я бежал, — подумал князь Андрей, — не так, как мы бежали, кричали и дрались; совсем не так, как с озлобленными и испуганными лицами тащили друг у друга банник француз и артиллерист, — совсем не так ползут облака по этому высокому бесконечному небу. Как же я не видал прежде этого высокого неба? И как я счастлив, что узнал его наконец. Да! все пустое, все обман, кроме этого бесконечного неба. Ничего, ничего нет, кроме его. Но и того даже нет, ничего нет, кроме тишины, успокоения. И слава Богу!..»" forKey:kRussianText];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender
{
    NSString *text = @"";
    if (self.selectedCell) {
        NSString *key = self.selectedCell.textLabel.text;
        text = [self.texts objectForKey:key];
    }
    [self.delegate setNewText:text];
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
    static NSArray *textsKeys = nil;
    
    if (!textsKeys) {
        textsKeys = [self.texts allKeys];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.textLabel.text = [textsKeys objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (self.selectedCell) {
        self.selectedCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.selectedCell = cell;
}

@end
