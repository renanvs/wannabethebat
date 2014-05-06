//
//  ComicStripCell.h
//  WannaBeTheBatCoreSample
//
//  Created by renan veloso silva on 27/04/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComicStripCell : UITableViewCell{
    IBOutlet UILabel *comicTitleLabel;
    IBOutlet UIImageView *comicImageView;
    
    ComicModel *model;
}

@property (assign, nonatomic) ComicModel *model;

@end
