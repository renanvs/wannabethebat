//
//  Utils.h
//  PaleoProject
//
//  Created by renan veloso silva on 22/02/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>

#define debugAlert(message) \
[Utils debugAlert:(message)]

#define keyboardRect(notification) \
[Utils getKeyboardRectWithNotification:(notification)]

#define screenBounds() \
[Utils screenBoundsOnCurrentOrientation]

#define PI 3.14159265358979 /* pi */
#define Degrees_To_Radians(angle) (angle / 180.0 * PI)

@interface Utils : NSObject

+ (Utils *) sharedInstance;

-(NSString*)getSafeLiteralString:(NSString*)text;

+(CGRect) screenBoundsOnCurrentOrientation;

+(UIInterfaceOrientation)getDeviceOrientation;

+(void)debugAlert:(NSString*)message;

+(BOOL)existThisImage:(NSString*)imageName;

+(CGRect)getKeyboardRectWithNotification:(NSNotification*)notification;

@end

@interface NSString (custom)

+ (BOOL)isStringEmpty:(NSString *)string;
+ (BOOL)isStringWithNumeric:(NSString*)string;
-(id)initWithStringNeverNil:(NSString *)aString;

@end

@interface UIView (Additions)

-(void) setX:(float) newX;
-(float)x;

-(void) setY:(float) newY;
-(float)y;

-(void) setWidth:(float) newWidth;
-(float)width;

-(void) setHeight:(float) newHeight;
-(float)height;


@end

@interface UIResponder (Aditions)
-(UIViewController *) findTopRootViewController;
@end