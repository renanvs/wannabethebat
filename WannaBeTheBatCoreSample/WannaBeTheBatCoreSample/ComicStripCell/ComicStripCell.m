//
//  ComicStripCell.m
//  WannaBeTheBatCoreSample
//
//  Created by renan veloso silva on 27/04/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import "ComicStripCell.h"
#import "HTMLNode.h"
#import "HTMLParser.h"

@implementation ComicStripCell
@synthesize model;

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

-(void)setModel:(ComicModel *)_model{
    
    comicImageView.image = [[WBBService sharedInstance] getThumbImageWithComicModel:_model];
    comicTitleLabel.text = _model.title;
}

@end
