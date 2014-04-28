//
//  MainViewController.h
//  WannaBeTheBatCoreSample
//
//  Created by renan veloso silva on 27/04/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) IBOutlet UITableView *comicStripTableView;

@end