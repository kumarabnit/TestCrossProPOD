//
//  TPMGLoadingOverlay.m
//  TPMGCommon
//
//  Created by GK on 5/21/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

#import "TPMGLoadingOverlay.h"


#define kActivityIndicatorViewTag 777
#define kActivityIndicatorViewSize 30.0
#define kActivityIndicatorViewCornerRadius 3.0

@implementation TPMGLoadingOverlay


+ (void)showLoadingOverlay {
    UIActivityIndicatorView *anActivityIndicatorView = (UIActivityIndicatorView *)[[[[UIApplication sharedApplication] delegate] window] viewWithTag:kActivityIndicatorViewTag];
    if (anActivityIndicatorView == nil) {
        
        UIActivityIndicatorView *anActivityIndicatorView = [[UIActivityIndicatorView alloc] init];
        anActivityIndicatorView.tag = kActivityIndicatorViewTag;
        anActivityIndicatorView.backgroundColor = [UIColor blackColor];
        anActivityIndicatorView.layer.cornerRadius = kActivityIndicatorViewCornerRadius;
        CGRect aSuperViewFrame = [[[UIApplication sharedApplication] delegate] window].rootViewController.view.frame;
        anActivityIndicatorView.frame = CGRectMake((aSuperViewFrame.size.width - kActivityIndicatorViewSize) / 2, (aSuperViewFrame.size.height - kActivityIndicatorViewSize) / 2, kActivityIndicatorViewSize, kActivityIndicatorViewSize);
        
        [[[[UIApplication sharedApplication] delegate] window] addSubview:anActivityIndicatorView];
        [[[[UIApplication sharedApplication] delegate] window] bringSubviewToFront:anActivityIndicatorView];
        [anActivityIndicatorView startAnimating];
    }
}


+ (void)hideLoadingOverlay {
    void (^removeOverlayBlock)(void) = ^void(void) {
        UIActivityIndicatorView *anActivityIndicatorView = (UIActivityIndicatorView *)[[[[UIApplication sharedApplication] delegate] window] viewWithTag:kActivityIndicatorViewTag];
        if (anActivityIndicatorView != nil) {
            [anActivityIndicatorView stopAnimating];
            [anActivityIndicatorView removeFromSuperview];
        }
    };
    
    if ([NSThread isMainThread] == NO) {
        dispatch_async(dispatch_get_main_queue(), removeOverlayBlock);
    } else {
        removeOverlayBlock();
    }
}


@end
