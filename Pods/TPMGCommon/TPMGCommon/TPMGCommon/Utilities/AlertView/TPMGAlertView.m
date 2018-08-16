//
//  TPMGAlertView.m
//  TPMGCommon
//
//  Created by GK on 5/21/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

#import "TPMGAlertView.h"
#import "TPMGServiceConstants.h"


#define kAlertViewTag 369;

@interface TPMGAlertView ()

@property (nonatomic, strong) void(^didTapActionButtonBlock)(BOOL iDidTapButton);
@property (nonatomic, strong) UIAlertController* alertController;
@property (nonatomic, strong) UIWindow *alertWindow;


- (void)showAlertWithMessage:(NSString *)iAlertMessage title:(NSString *)iAlertTitle cancelButtonTitle:(TPMGAlertViewCancelButtonTitle)iCancelButtonTitle actionButtonTitle:(NSString *)iActionButtonTitle completionBlock:(TPMGDidTapActionButtonBlock)iCompletionBlock;

- (void)showAlertWithMessage:(NSString *)iAlertMessage title:(NSString *)iAlertTitle cancelButtonTitle:(TPMGAlertViewCancelButtonTitle)iCancelButtonTitle actionButtonTitle:(NSString *)iActionButtonTitle inViewController:(UIViewController*)iViewController completionBlock:(TPMGDidTapActionButtonBlock)iCompletionBlock;

@end

@implementation TPMGAlertView


#pragma mark - Show only a message with cancel button.

+ (TPMGAlertView *)showAlertWithMessage:(NSString *)iAlertMessage title:(NSString *)iAlertTitle cancelButtonTitle:(TPMGAlertViewCancelButtonTitle)iCancelButtonTitle {
    return [TPMGAlertView showAlertWithMessage:iAlertMessage title:iAlertTitle cancelButtonTitle:iCancelButtonTitle actionButtonTitle:nil inViewController:nil completionBlock:nil];
}

+ (instancetype)showAlertWithMessage:(NSString *)iAlertMessage title:(NSString *)iAlertTitle cancelButtonTitle:(TPMGAlertViewCancelButtonTitle)iCancelButtonTitle completionBlock:(TPMGDidTapActionButtonBlock)iCompletionBlock {
    return [TPMGAlertView showAlertWithMessage:iAlertMessage title:iAlertTitle cancelButtonTitle:iCancelButtonTitle actionButtonTitle:nil inViewController:nil completionBlock:iCompletionBlock];
}


#pragma mark - Show a message with cancel button and other buttons.

+ (TPMGAlertView *)showAlertWithMessage:(NSString *)iAlertMessage title:(NSString *)iAlertTitle cancelButtonTitle:(TPMGAlertViewCancelButtonTitle)iCancelButtonTitle actionButtonTitle:(NSString *)iActionButtonTitle completionBlock:(TPMGDidTapActionButtonBlock)iCompletionBlock {
    
    return [TPMGAlertView showAlertWithMessage:iAlertMessage title:iAlertTitle cancelButtonTitle:iCancelButtonTitle actionButtonTitle:iActionButtonTitle inViewController:nil completionBlock:iCompletionBlock];
}

+ (instancetype)showAlertWithMessage:(NSString *)iAlertMessage title:(NSString *)iAlertTitle cancelButtonTitle:(TPMGAlertViewCancelButtonTitle)iCancelButtonTitle actionButtonTitle:(NSString *)iActionButtonTitle inViewController:(UIViewController*)iViewController completionBlock:(TPMGDidTapActionButtonBlock)iCompletionBlock {
    TPMGAlertView *anAlertView = [[[self class] alloc] init];
    
    [anAlertView showAlertWithMessage:iAlertMessage title:iAlertTitle cancelButtonTitle:iCancelButtonTitle actionButtonTitle:iActionButtonTitle inViewController:iViewController completionBlock:iCompletionBlock];
    return anAlertView;

}


#pragma mark - Private methods

- (void)showAlertWithMessage:(NSString *)iAlertMessage title:(NSString *)iAlertTitle cancelButtonTitle:(TPMGAlertViewCancelButtonTitle)iCancelButtonTitle actionButtonTitle:(NSString *)iActionButtonTitle completionBlock:(TPMGDidTapActionButtonBlock)iCompletionBlock {
    
    [self showAlertWithMessage:iAlertMessage title:iAlertTitle cancelButtonTitle:iCancelButtonTitle actionButtonTitle:iActionButtonTitle inViewController:nil completionBlock:iCompletionBlock];
    
}

- (void)showAlertWithMessage:(NSString *)iAlertMessage title:(NSString *)iAlertTitle cancelButtonTitle:(TPMGAlertViewCancelButtonTitle)iCancelButtonTitle actionButtonTitle:(NSString *)iActionButtonTitle inViewController:(UIViewController*)iViewController completionBlock:(TPMGDidTapActionButtonBlock)iCompletionBlock {
	self.didTapActionButtonBlock = iCompletionBlock;
    [self showAlertControllerWithMessage:iAlertMessage
                         alertTittle:iAlertTitle
                   actionButtonTitle:iActionButtonTitle
                    cancelButtonTile:[self cancelButtonTitleStringWithType:iCancelButtonTitle]
                          controller:iViewController
                     completionBlock:iCompletionBlock];
}

- (NSString *)cancelButtonTitleStringWithType:(TPMGAlertViewCancelButtonTitle)iCancelButtonTitle {
	NSString *aCancelButtonTitleString = @"";
	
	switch (iCancelButtonTitle) {
		case TPMGAlertViewCancelButtonTitleOK: {
			aCancelButtonTitleString = kAlertViewCancelButtonTitleOK;
			break;
		}
			
		case TPMGAlertViewCancelButtonTitleCancel: {
			aCancelButtonTitleString = kAlertViewCancelButtonTitleCancel;
			break;
		}
			
		case TPMGAlertViewCancelButtonTitleClose: {
			aCancelButtonTitleString = kAlertViewCancelButtonTitleClose;
			break;
		}
        case TPMGAlertViewCancelButtonTitleNO: {
            aCancelButtonTitleString = kAlertViewCancelButtonTitleNO;
            break;
        }
            
        case TPMGAlertViewCancelButtonTitleActivate :{
            aCancelButtonTitleString = kAlertViewCancelButtonTitleActivate;
            break;
        }
        case TPMGAlertViewCancelButtonTitleUpdateNow :{
            aCancelButtonTitleString = kAlertViewCancelButtonTitleUpdateNow;
            break;
        }
			
		default: {
			break;
		}
	}

	return aCancelButtonTitleString;
}


- (void)dismissAlert {
    if (self.alertController != nil) {
        [self.alertController dismissViewControllerAnimated:NO completion:nil];
        self.alertController = nil;
    }
    if ( self.alertWindow != nil) {
        self.alertWindow.windowLevel = 0;
        self.alertWindow = nil;
        [[[[UIApplication sharedApplication] delegate] window] makeKeyWindow];
    }
}

#pragma mark - UIAlertController
- (void)showAlertControllerWithMessage:(NSString *)iAlertMessage
                           alertTittle:(NSString *)iAlertTittle
                     actionButtonTitle:(NSString *)iActionButtonTitle
                      cancelButtonTile:(NSString *)iCancelButtonTitle
                            controller:(UIViewController *)iController
                       completionBlock:(TPMGDidTapActionButtonBlock)iCompletionBlock {
    
    self.alertController = [UIAlertController
                            alertControllerWithTitle:iAlertTittle
                            message:iAlertMessage
                            preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *aCancelAction = [UIAlertAction actionWithTitle:iCancelButtonTitle
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {
                                                              LOG("cancel Pressed");
                                                              if (self.didTapActionButtonBlock) {
                                                                  self.didTapActionButtonBlock(NO);
                                                              }
                                                              self.alertWindow = nil;
                                                          }];
    [self.alertController addAction:aCancelAction];

    
    if (iActionButtonTitle != nil) {
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:iActionButtonTitle
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  if (self.didTapActionButtonBlock) {
                                                                      self.didTapActionButtonBlock(YES);
                                                                  }
                                                                  self.alertWindow = nil;
                                                              }];
        [self.alertController addAction:defaultAction];
    }
    
    UIViewController* tempViewController;
    if (iController == nil) {
        self.alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.alertWindow.rootViewController = [[UIViewController alloc] init];
        
        id<UIApplicationDelegate> delegate = [UIApplication sharedApplication].delegate;
        // Applications that does not load with UIMainStoryboardFile might not have a window property:
        if ([delegate respondsToSelector:@selector(window)]) {
            // we inherit the main window's tintColor
            self.alertWindow.tintColor = delegate.window.tintColor;
        }
        // window level is above the top window (this makes the alert, if it's a sheet, show over the keyboard)
        UIWindow *topWindow = [UIApplication sharedApplication].windows.lastObject;
        self.alertWindow.windowLevel = topWindow.windowLevel + 1;
        
        [self.alertWindow makeKeyAndVisible];
        [self.alertWindow.rootViewController presentViewController:self.alertController animated:YES completion:nil];
    } else {
        tempViewController = iController;
    }
    
    [tempViewController presentViewController:self.alertController animated:YES completion:nil];
}

#pragma mark - Clean up
- (void)dealloc {
    self.alertController = nil;
    self.alertWindow = nil;
}


@end
