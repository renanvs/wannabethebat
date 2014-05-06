//
//  FullComicViewController.m
//  WannaBeTheBatCoreSample
//
//  Created by renan veloso silva on 29/04/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import "FullComicViewController.h"

@implementation FullComicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(id)initWithComicModel:(ComicModel*)comicModel{
    self = [super init];
    
    if (self) {
        currentComicModel = comicModel;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    UIImage *image = [[WBBService sharedInstance] getComicImageWithComicModel:currentComicModel];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    
//    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:currentComicModel.imagePath]]]];
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    [imgView setFrame:scrollView.frame];
    imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [scrollView addSubview:imgView];
    scrollView.delegate = self;
    scrollView.scrollEnabled = NO;
    scrollView.minimumZoomScale = 1;
    scrollView.maximumZoomScale = 100;
    [scrollView setContentSize:imgView.frame.size];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)_scrollView{
    return [[scrollView subviews]lastObject];
}

- (void)dealloc {
    [scrollView release];
    [super dealloc];
}

-(IBAction)voltar:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
