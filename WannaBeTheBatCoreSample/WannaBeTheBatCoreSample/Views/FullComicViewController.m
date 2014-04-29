//
//  FullComicViewController.m
//  WannaBeTheBatCoreSample
//
//  Created by renan veloso silva on 29/04/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import "FullComicViewController.h"

@implementation FullComicViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id)initWithComicModel:(ComicModel*)comicModel{
    self = [super init];
    
    if (self) {
        currentComicModel = comicModel;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:currentComicModel.imagePath]]]];
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    [imgView setFrame:scrollView.frame];
    [scrollView addSubview:imgView];
    CGFloat x1 = [imgView width];
    CGSize x2 = [imgView.image size];
    scrollView.delegate = self;
    scrollView.scrollEnabled = NO;
    scrollView.minimumZoomScale = 1;
    scrollView.maximumZoomScale = 100;
    [scrollView setContentSize:imgView.frame.size];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    id x = [[scrollView subviews]lastObject];
    return x;
}

- (void)dealloc {
    [scrollView release];
    [super dealloc];
}
@end