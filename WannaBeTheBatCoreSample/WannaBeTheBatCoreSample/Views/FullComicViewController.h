//
//  FullComicViewController.h
//  WannaBeTheBatCoreSample
//
//  Created by renan veloso silva on 29/04/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullComicViewController : UIViewController<UIScrollViewDelegate>{
    ComicModel *currentComicModel;
    IBOutlet UIScrollView *scrollView;
}

-(id)initWithComicModel:(ComicModel*)comicModel;
-(IBAction)voltar:(id)sender;

@end
