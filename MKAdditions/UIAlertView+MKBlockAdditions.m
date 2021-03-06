//
//  UIAlertView+MKBlockAdditions.m
//  UIKitCategoryAdditions
//
//  Created by Mugunth on 21/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIAlertView+MKBlockAdditions.h"
#import <objc/runtime.h>

static char DISMISS_IDENTIFER;
static char CANCEL_IDENTIFER;
static char WILL_DISMISS_IDENTIFER;
static char WILL_CANCEL_IDENTIFER;

@implementation UIAlertView (Block)

@dynamic cancelBlock;
@dynamic dismissBlock;
@dynamic willCancelBlock;
@dynamic willDismissBlock;

- (void)setDismissBlock:(DismissBlock)dismissBlock
{
    objc_setAssociatedObject(self, &DISMISS_IDENTIFER, dismissBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (DismissBlock)dismissBlock
{
    return objc_getAssociatedObject(self, &DISMISS_IDENTIFER);
}

- (void)setCancelBlock:(CancelBlock)cancelBlock
{
    objc_setAssociatedObject(self, &CANCEL_IDENTIFER, cancelBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CancelBlock)cancelBlock
{
    return objc_getAssociatedObject(self, &CANCEL_IDENTIFER);
}

- (void)setWillDismissBlock:(DismissBlock)willDismissBlock
{
    objc_setAssociatedObject(self, &WILL_DISMISS_IDENTIFER, willDismissBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (DismissBlock)willDismissBlock
{
    return objc_getAssociatedObject(self, &WILL_DISMISS_IDENTIFER);
}

- (void)setWillCancelBlock:(CancelBlock)willCancelBlock
{
    objc_setAssociatedObject(self, &WILL_CANCEL_IDENTIFER, willCancelBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CancelBlock)willCancelBlock
{
    return objc_getAssociatedObject(self, &WILL_CANCEL_IDENTIFER);
}

+ (UIAlertView*) alertViewWithTitle:(NSString*) title                    
                    message:(NSString*) message 
          cancelButtonTitle:(NSString*) cancelButtonTitle
          otherButtonTitles:(NSArray*) otherButtons
                  onDismiss:(DismissBlock) dismissed                   
                   onCancel:(CancelBlock) cancelled {
        
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:[self class]
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:nil];
    
    [alert setDismissBlock:dismissed];
    [alert setCancelBlock:cancelled];
    
    for(NSString *buttonTitle in otherButtons)
        [alert addButtonWithTitle:buttonTitle];
    
    [alert show];
    return [alert autorelease];
}

+ (UIAlertView*) alertViewWithTitle:(NSString*) title
                            message:(NSString*) message
                  cancelButtonTitle:(NSString*) cancelButtonTitle
                  otherButtonTitles:(NSArray*) otherButtons
                          onDismiss:(DismissBlock) dismissed
                           onCancel:(CancelBlock) cancelled
                        willDismiss:(DismissBlock)willDismissed
                         willCancel:(CancelBlock)willCancelled {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:[self class]
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:nil];
    
    [alert setDismissBlock:dismissed];
    [alert setCancelBlock:cancelled];
    [alert setWillDismissBlock:willDismissed];
    [alert setWillCancelBlock:willCancelled];
    
    for(NSString *buttonTitle in otherButtons)
        [alert addButtonWithTitle:buttonTitle];
    
    [alert show];
    return [alert autorelease];
}

+ (UIAlertView*) alertViewWithTitle:(NSString*) title 
                    message:(NSString*) message {
    
    return [UIAlertView alertViewWithTitle:title 
                                   message:message 
                         cancelButtonTitle:NSLocalizedString(@"Dismiss", @"")];
}

+ (UIAlertView*) alertViewWithTitle:(NSString*) title 
                    message:(NSString*) message
          cancelButtonTitle:(NSString*) cancelButtonTitle {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles: nil];
    [alert show];
    return [alert autorelease];
}

+ (void)alertView:(UIAlertView*) alertView didDismissWithButtonIndex:(NSInteger) buttonIndex {
    
	if(buttonIndex == [alertView cancelButtonIndex])
	{
		if (alertView.cancelBlock) {
            alertView.cancelBlock();
        }
	}
    else
    {
        if (alertView.dismissBlock) {
            alertView.dismissBlock((int)buttonIndex - 1); // cancel button is button 0
        }
    }
}

+ (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex == [alertView cancelButtonIndex])
	{
		if (alertView.willCancelBlock) {
            alertView.willCancelBlock();
        }
	}
    else
    {
        if (alertView.willDismissBlock) {
            alertView.willDismissBlock((int)buttonIndex - 1); // cancel button is button 0
        }
    }
}

@end