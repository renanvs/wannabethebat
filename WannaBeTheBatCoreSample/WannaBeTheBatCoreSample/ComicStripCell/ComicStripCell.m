//
//  ComicStripCell.m
//  WannaBeTheBatCoreSample
//
//  Created by renan veloso silva on 27/04/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import "ComicStripCell.h"

@implementation ComicStripCell
@synthesize comicImagePath, comicTitle;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setComicTitle:(NSString *)_comicTitle{
    comicTitleLabel.text = _comicTitle;
}

-(void)setComicImagePath:(NSString *)_comicImagePath{
    comicImageView.image = [UIImage imageNamed:_comicImagePath];
}

@end
