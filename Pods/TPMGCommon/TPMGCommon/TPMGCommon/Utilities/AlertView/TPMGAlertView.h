//
//  TPMGAlertView.h
//  TPMGCommon
//
//  Created by GK on 5/21/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

typedef enum {
	TPMGAlertViewCancelButtonTitleOK,
	TPMGAlertViewCancelButtonTitleCancel,
	TPMGAlertViewCancelButtonTitleClose,
    TPMGAlertViewCancelButtonTitleNO,
    TPMGAlertViewCancelButtonTitleActivate,
    TPMGAlertViewCancelButtonTitleUpdateNow
} TPMGAlertViewCancelButtonTitle;

// This block will contain the actions to perform on tapping the other button in the alert.

typedef void (^TPMGDidTapActionButtonBlock)(BOOL iDidTapButton);

@interface TPMGAlertView : NSObject

/* This method can be called to display an alertview with title and message and a cancel button title.
 * The implementing application should capture the returned instance to dismiss it as desired.
 */
+ (instancetype)showAlertWithMessage:(NSString *)iAlertMessage title:(NSString *)iAlertTitle cancelButtonTitle:(TPMGAlertViewCancelButtonTitle)iCancelButtonTitle;

/* This method can be called to display an alertview with title and message and a cancel button title and a non-cancel button action enclosed in the completion block.
 */
+ (instancetype)showAlertWithMessage:(NSString *)iAlertMessage title:(NSString *)iAlertTitle cancelButtonTitle:(TPMGAlertViewCancelButtonTitle)iCancelButtonTitle completionBlock:(TPMGDidTapActionButtonBlock)iCompletionBlock;

/* This method can be called to display an alertview with a title, message, cancel button title, action button title and a non-cancel button action enclosed in the completion block.
 * This can be invoked only if the alert has to display two buttons in it.
 * Calls the following method with a viewController of NIL. If this routine has trouble displaying the alert, call the next routine with the current viewController.
 * The implementing application should capture the returned instance to dismiss it as desired.
 */
+ (instancetype)showAlertWithMessage:(NSString *)iAlertMessage title:(NSString *)iAlertTitle cancelButtonTitle:(TPMGAlertViewCancelButtonTitle)iCancelButtonTitle actionButtonTitle:(NSString *)iActionButtonTitle completionBlock:(TPMGDidTapActionButtonBlock)iCompletionBlock;

/* This method can be called to display an alertview with a title, message, cancel button title, action button title and a non-cancel button action enclosed in the completion block.
 * This can be invoked only if the alert has to display two buttons in it.
 * The implementing application should capture the returned instance to dismiss it as desired.
 */

+ (instancetype)showAlertWithMessage:(NSString *)iAlertMessage title:(NSString *)iAlertTitle cancelButtonTitle:(TPMGAlertViewCancelButtonTitle)iCancelButtonTitle actionButtonTitle:(NSString *)iActionButtonTitle inViewController:(UIViewController*)iViewController completionBlock:(TPMGDidTapActionButtonBlock)iCompletionBlock;

/* This method can be called to dismiss the alert as applicable in the implementing application.
 * This method can be invoked on the retained instance of the TPMGAlertView in the implementing application.
 */
- (void)dismissAlert;

// TODO: We would want to add more action buttons into one alertview, at which time we might have to add additional logic

@end
