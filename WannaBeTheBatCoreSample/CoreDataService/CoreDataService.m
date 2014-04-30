//
//  CoreDataService.m
//  WannaBeTheBatCoreSample
//
//  Created by renan veloso silva on 29/04/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import "CoreDataService.h"

@implementation CoreDataService

@synthesize context;

SynthensizeSingleTon(CoreDataService)

#pragma mark - coreData
-(void)saveContext{
    NSError *error;
    if (![context save:&error]) {
        NSDictionary *informacoes = [error userInfo];
        NSArray *multiplosError = [informacoes objectForKey:NSDetailedErrorsKey];
        if (multiplosError) {
            for (NSError *error in multiplosError) {
                NSLog(@"Problema: %@", [error userInfo]);
            }
        }else{
            NSLog(@"Problema: %@", informacoes);
        }
    }else{
        ///
    }
}

-(NSManagedObjectModel*)managedObjectModel{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreDataModel" withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return managedObjectModel;
}

-(NSPersistentStoreCoordinator *)coordinator{
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSURL *pastaDocuments = [self applicationDocumentsDirectory];
    NSURL *localBancoDados = [pastaDocuments URLByAppendingPathComponent:@"ComicDataBase.sqlite"];
    
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:localBancoDados options:nil error:nil];
    return coordinator;
}

-(NSURL*)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(NSManagedObjectContext *)context{
    if (context != nil) {
        return context;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self coordinator];
    context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:coordinator];
    return context;
}

@end
