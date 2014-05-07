//
//  WBBDownloadManager.m
//  WannaBeTheBatCoreSample
//
//  Created by renan veloso silva on 01/05/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import "WBBDownloadManager.h"

@implementation WBBDownloadManager

SynthensizeSingleTon(WBBDownloadManager)

-(BOOL)downloadComicImage:(NSString*)imageUrl{
    
    NSURL *url = [NSURL URLWithString:imageUrl];
    
    NSString *directoryPath = [NSString stringWithFormat:@"%@/%@",[self getDocumentDirectory],comicImageDir];
    if (![self existThisPath:directoryPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",directoryPath,[url lastPathComponent]];
    
    if ([self existThisPath:filePath]) {
        return NO;
    }
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data) {
        [data writeToFile:filePath atomically:YES];
        return YES;
    }
    return NO;
}

-(BOOL)existThisPath:(NSString*)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL value = [fileManager fileExistsAtPath:path];
    return value;
}

-(NSString*)getDocumentDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths lastObject];
    return documentDirectory;
}

-(UIImage*)getThumbImageByModel:(ComicModel*)model{
    NSString *encoded = [NSString encodeToBase64:model.identifier];
    NSString *documentsDir = [self getDocumentDirectory];
    NSString *thumbPartialPath = [NSString stringWithFormat:@"thumb/%@",[model.thumbUrl lastPathComponent]];
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@/%@", documentsDir, encoded, thumbPartialPath];
    UIImage *image = [UIImage imageWithContentsOfFile:fullPath];
    
    return image;
}

-(UIImage*)getComicImageByModel:(ComicModel*)model{
    NSString *encoded = [NSString encodeToBase64:model.identifier];
    NSString *documentsDir = [self getDocumentDirectory];
    NSString *imagePartialPath = [NSString stringWithFormat:@"image/%@",[model.imagePath lastPathComponent]];
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@/%@", documentsDir, encoded, imagePartialPath];
    UIImage *image = [UIImage imageWithContentsOfFile:fullPath];
    
    return image;
}

-(void)createDirectoryAtPath:(NSString*)path{
    NSString *thumbPath = [NSString stringWithFormat:@"%@/thumb",path];
    NSString *imagePath = [NSString stringWithFormat:@"%@/image",path];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:thumbPath withIntermediateDirectories:YES attributes:nil error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:imagePath withIntermediateDirectories:YES attributes:nil error:nil];
}

-(void)downloadComicList:(NSArray*)list{
    for (ComicModel *comicModel in list) {
        NSString *encoded = [NSString encodeToBase64:comicModel.identifier];
        NSString *directoryToDownlaod = [NSString stringWithFormat:@"%@/%@",[self getDocumentDirectory],encoded];
        if ([self existThisPath:directoryToDownlaod]) {
            comicModel.downloaded = [NSNumber numberWithBool:NO];
            [self removeDirectoryAtPath:directoryToDownlaod];
            [self createDirectoryAtPath:directoryToDownlaod];
            [self downloadComicModel:comicModel toPath:directoryToDownlaod];
            comicModel.downloaded = [NSNumber numberWithBool:YES];
        }else{
            [self createDirectoryAtPath:directoryToDownlaod];
            [self downloadComicModel:comicModel toPath:directoryToDownlaod];
            comicModel.downloaded = [NSNumber numberWithBool:YES];
        }
    }
}

-(void)removeComicList:(NSArray*)list{
    for (ComicModel *comicModel in list) {
        NSString *encoded = [NSString encodeToBase64:comicModel.identifier];
        NSString *directoryToDownlaod = [NSString stringWithFormat:@"%@/%@",[self getDocumentDirectory],encoded];
        
        [self removeDirectoryAtPath:directoryToDownlaod];
        [[WBBDatabaseService sharedInstance] removeModelFromCoreData:comicModel];
    }
}

-(void)downloadComicModel:(ComicModel*)comicModel toPath:(NSString*)path{
    NSString *thumbPath = [NSString stringWithFormat:@"%@/thumb/%@",path,[comicModel.thumbUrl lastPathComponent]];
    NSString *imagePath = [NSString stringWithFormat:@"%@/image/%@",path,[comicModel.imagePath lastPathComponent]];
    
    NSURL *url = nil;
    NSData *data = nil;
    
    //thumb
    url = [NSURL URLWithString:comicModel.thumbUrl];
    data = [NSData dataWithContentsOfURL:url];
    NSString *log = [NSString stringWithFormat:@"download thumb: %@", [comicModel.identifier lastPathComponent]];
    if (data) {
        [data writeToFile:thumbPath atomically:YES];
    }
    dwLog(log);
    
    //image
    url = [NSURL URLWithString:comicModel.imagePath];
    log = [NSString stringWithFormat:@"download image: %@", [comicModel.identifier lastPathComponent]];
    data = [NSData dataWithContentsOfURL:url];
    if (data) {
        [data writeToFile:imagePath atomically:YES];
    }
    dwLog(log);
}

-(void)removeDirectoryAtPath:(NSString*)path{
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

@end
