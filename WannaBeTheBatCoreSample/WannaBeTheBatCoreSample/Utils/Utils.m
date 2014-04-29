//
//  Utils.m
//  PaleoProject
//
//  Created by renan veloso silva on 22/02/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import "Utils.h"

@implementation Utils

#pragma mark - initial method's

static id _instance;
+ (Utils *) sharedInstance{
    @synchronized(self){
        if (!_instance) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

#pragma mark - UIImage

//Verifica se existe no projeto, alguma imagem com esse nome
+(BOOL)existThisImage:(NSString*)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    if (image) {
        return YES;
    }
    return NO;
}

#pragma mark - NSString auxiliar

//retorna uma NSString minuscula e sem acento
-(NSString*)getSafeLiteralString:(NSString*)text{
    NSDictionary *typeA= [NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:@"ã", @"â", @"á", @"à", nil] forKey:@"a"];
    NSDictionary *typeE= [NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:@"é", @"ê", @"è", nil] forKey:@"e"];
    NSDictionary *typeI= [NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:@"í", @"î", @"ì", nil] forKey:@"i"];
    NSDictionary *typeO= [NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:@"ó", @"ô", @"ò", @"õ", nil] forKey:@"o"];
    NSDictionary *typeU= [NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:@"ú", @"û", @"ù", nil] forKey:@"u"];
    NSDictionary *typeC= [NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:@"ç", nil] forKey:@"c"];
    NSArray *listType = [NSArray arrayWithObjects:typeA, typeE, typeI, typeO, typeU, typeC, nil];
    
    text = [text lowercaseString];
    for (NSDictionary *dic in listType) {
        NSString *key = [[dic allKeys] lastObject];
        NSArray *array = [dic objectForKey:key];
        for (NSString *charValue in array) {
            NSRange range = [text rangeOfString:charValue];
            if (range.length > 0) {
                text = [text stringByReplacingOccurrencesOfString:charValue withString:key];
            }
            
        }
    }
    
    return text;
    
}

//Pega o tamanho da tela na orientação atual
+(CGRect) screenBoundsOnCurrentOrientation{
    CGRect screenBounds = [UIScreen mainScreen].bounds ;
    CGFloat width = CGRectGetWidth(screenBounds)  ;
    CGFloat height = CGRectGetHeight(screenBounds) ;
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if(UIInterfaceOrientationIsPortrait(interfaceOrientation)){
        screenBounds.size = CGSizeMake(width, height);
    }else if(UIInterfaceOrientationIsLandscape(interfaceOrientation)){
        screenBounds.size = CGSizeMake(height, width);
    }
    return screenBounds ;
}

//retorna a orientação atual do Device
+(UIInterfaceOrientation)getDeviceOrientation{
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    return interfaceOrientation;
}

//Chama um alert com a mensagem passada
+(void)debugAlert:(NSString*)message{
    [[[[UIAlertView alloc] initWithTitle:@"Debug" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease]show];
}

+(CGRect)getKeyboardRectWithNotification:(NSNotification*)notification{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    return keyboardFrameBeginRect;
}

//-(void)keepAnimationState:(UIView*)view{
//    CGRect rect = [self getBlankRect];
//    
//    rect = view.frame;
//    //CGRect screenRect = screenBounds();
//    //[foodTableView setY:-screenRect.size.height];
//}
//
//-(CGRect)getBlankRect{
//    if (animationRect0.size.width == 0) {
//        return animationRect0;
//    }else if (animationRect1.size.width == 0) {
//        return animationRect1;
//    }else if (animationRect2.size.width == 0) {
//        return animationRect2;
//    }else if (animationRect3.size.width == 0) {
//        return animationRect3;
//    }else if (animationRect4.size.width == 0) {
//        return animationRect4;
//    }else{
//        animationRect0 = CGRectMake(0, 0, 0, 0);
//        animationRect1 = CGRectMake(0, 0, 0, 0);
//        animationRect2 = CGRectMake(0, 0, 0, 0);
//        animationRect3 = CGRectMake(0, 0, 0, 0);
//        animationRect4 = CGRectMake(0, 0, 0, 0);
//    }
//    return animationRect0;
//}
//
//-(void)commitAnimetion:(UIView*)view{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:1.3];
//    [view setY:originaRect.origin.y];
//    [UIView commitAnimations];
//}

@end

@implementation UIView (Additions)

-(void)setX:(float)newX{
    CGRect frame = self.frame;
    frame.origin.x = newX;
    self.frame = frame;
}

-(float)x{
    return self.frame.origin.x;
}

-(void) setY:(float) newY{
    CGRect frame = self.frame;
    frame.origin.y = newY;
    self.frame = frame;
}
-(float)y{
    return self.frame.origin.y;
}

-(void) setWidth:(float) newWidth{
    CGRect frame = self.frame;
    frame.size.width = newWidth;
    self.frame = frame;
}
-(float)width{
    return self.frame.size.width;
}

-(void) setHeight:(float) newHeight{
    CGRect frame = self.frame;
    frame.size.height = newHeight;
    self.frame = frame;
}
-(float)height{
    return self.frame.size.height;
}

@end

@implementation UIResponder (Aditions)
-(UIViewController *) findTopRootViewController {
	UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
	
	if (topWindow.windowLevel != UIWindowLevelNormal) {
		NSArray *windows = [[UIApplication sharedApplication] windows];
		
		for(topWindow in windows) {
			if (topWindow.windowLevel == UIWindowLevelNormal) {
				break;
			}
		}
	}
	
    UIView *rootView = nil;
    
    if ([[topWindow subviews] count] != 0){
        rootView = [[topWindow subviews] objectAtIndex:0];
    }
    
	id nextResponder = [rootView nextResponder];
	
	return [nextResponder isKindOfClass:[UIViewController class]]
	? nextResponder
	: nil;
}
@end

@implementation NSString (JRAdditions)

+ (BOOL)isStringEmpty:(NSString *)string {
    if([string length] == 0) { //string is empty or nil
        return YES;
    }
    
    if(![[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
        //string is all whitespace
        return YES;
    }
    
    return NO;
}

+ (BOOL)isStringWithNumeric:(NSString*)string{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *number = [formatter numberFromString:string];
    bool status = number != nil;
    
    return status;
}

-(id)initWithStringNeverNil:(NSString *)aString{
    self = [super init];
    
    if (self) {
        if (aString == nil) {
            return @"";
        };
    }
    
    return [[NSString alloc] initWithString:aString];
    
}


@end