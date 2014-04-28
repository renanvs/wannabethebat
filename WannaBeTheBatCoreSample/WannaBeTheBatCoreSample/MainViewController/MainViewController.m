//
//  MainViewController.m
//  WannaBeTheBatCoreSample
//
//  Created by renan veloso silva on 27/04/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import "MainViewController.h"
#import "ComicStripCell.h"

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
    // Do any additional setup after loading the view from its nib.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ComicStripCell *cell = [tableView dequeueReusableCellWithIdentifier:ComicCell];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:ComicCell owner:self options:nil] lastObject];
    }
    
    cell.comicTitle = @"Teste";
    cell.comicImagePath = @"empty.png";
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 9;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}

@end
