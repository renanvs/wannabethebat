//
//  MainViewController.m
//  WannaBeTheBatCoreSample
//
//  Created by renan veloso silva on 27/04/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import "MainViewController.h"
#import "ComicStripCell.h"
#import "FullComicViewController.h"

#define ComicCell @"ComicStripCell"

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(comicListUpdated) name:notificationComicListUpdated object:nil];
    // Do any additional setup after loading the view from its nib.
}

-(void)comicListUpdated{
    [self.comicStripTableView reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ComicStripCell *cell = [tableView dequeueReusableCellWithIdentifier:ComicCell];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:ComicCell owner:self options:nil] lastObject];
    }
    
    ComicModel *comicModel = [[[WBBService sharedInstance] getComicList] objectAtIndex:indexPath.row];
    cell.model = comicModel;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[WBBService sharedInstance] getComicList].count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ComicModel *model = [[[WBBService sharedInstance] getComicList]objectAtIndex:indexPath.row];
    FullComicViewController *fullVC = [[FullComicViewController alloc] initWithComicModel:model];
    [self presentViewController:fullVC animated:YES completion:nil];
}

@end
