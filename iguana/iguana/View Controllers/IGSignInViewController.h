//
//  PhishNetSignInViewController.h
//  PhishOD
//
//  Created by Alec Gorge on 7/31/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IGSignInViewController;

@protocol IGSignInDelegate <NSObject>

- (void)signInViewController:(IGSignInViewController *)vc
    tappedSignInWithUsername:(NSString *)username
                 andPassword:(NSString *)password;

- (void)dismissTappedInSignInViewController:(IGSignInViewController *)vc;

@end

@interface IGSignInViewController : UITableViewController

@property (nonatomic, weak) id<IGSignInDelegate> delegate;

@end

