//
//  PhishNetSignInViewController.h
//  PhishOD
//
//  Created by Alec Gorge on 7/31/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IGSignUpViewController;

@protocol IGSignUpDelegate <NSObject>

- (void)signUpViewController:(IGSignUpViewController *)vc
    tappedSignUpWithUsername:(NSString *)username
                 andPassword:(NSString *)password;

- (void)dismissTappedInSignUpViewController:(IGSignUpViewController *)vc;

@end

@interface IGSignUpViewController : UITableViewController

@property (nonatomic, weak) id<IGSignUpDelegate> delegate;

@end

