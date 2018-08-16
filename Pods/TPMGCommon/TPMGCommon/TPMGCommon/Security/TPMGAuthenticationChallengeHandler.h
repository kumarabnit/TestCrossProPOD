//
//  TPMGAuthenticationChallengeHandler.h
//  KaiserPermanente
//
//  Created by Jak Jonnalagadda on 4/3/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//


@interface TPMGAuthenticationChallengeHandler : NSObject

+ (TPMGAuthenticationChallengeHandler *)sharedAuthenticationChallengeHandler;

- (void)handleAuthenticationChallenge:(NSURLAuthenticationChallenge *)iChallenge;

@end
