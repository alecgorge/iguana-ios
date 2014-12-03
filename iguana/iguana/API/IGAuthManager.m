//
//  IGAuthManager.m
//  iguana
//
//  Created by Alec Gorge on 11/3/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import <FXKeychain/FXKeychain.h>
#import <SVProgressHUD/SVProgressHUD.h>

#import "IGAPIClient.h"
#import "IGAuthManager.h"
#import "IGSignInViewController.h"
#import "IGSignUpViewController.h"

static NSString *kRelistenNetUsernameKeychainKey = @"relisten_u";
static NSString *kRelistenNetPasswordKeychainKey = @"relisten_p";

@interface IGAuthManager () <IGSignInDelegate, IGSignUpDelegate>

@property (nonatomic, copy) void (^signInBlock)(void);

@end

@implementation IGAuthManager

+ (instancetype)sharedInstance {
	static dispatch_once_t once;
	static id inst;
	dispatch_once(&once, ^ {
		inst = [self.alloc init];
	});
	return inst;
}

- (NSString *)username {
	return FXKeychain.defaultKeychain[kRelistenNetUsernameKeychainKey];
}

- (NSString *)password {
	return FXKeychain.defaultKeychain[kRelistenNetPasswordKeychainKey];
}

- (BOOL)hasCredentials {
	return self.username && self.username.length > 0 &&
      	   self.password && self.password.length > 0;
}

- (void)validateUsername:(NSString *)username
			withPassword:(NSString *)password
					save:(BOOL)shouldSave
				  result:(void (^)(BOOL))result {
	[IGAPIClient.sharedInstance validateUsername:username
									withPassword:password
										 success:^(BOOL validCombination) {
											 result(validCombination);
											 
											 if(shouldSave) {
												 FXKeychain.defaultKeychain[kRelistenNetUsernameKeychainKey] = username;
												 FXKeychain.defaultKeychain[kRelistenNetPasswordKeychainKey] = password;
											 }
										 }];
}

- (void)ensureSignedInFrom:(UIViewController *)baseViewController
				   success:(void (^)(void))success {
	if(self.hasCredentials) {
		success();
		return;
	}
	
	self.signInBlock = success;
	
	IGSignInViewController *vc = IGSignInViewController.alloc.init;
	vc.delegate = self;
	
	UINavigationController *nav = [UINavigationController.alloc initWithRootViewController:vc];
	
	[baseViewController presentViewController:nav
									 animated:YES
								   completion:NULL];
}

- (void)signUpFrom:(UIViewController *)baseViewController
                   success:(void (^)(void))success {
    if(self.hasCredentials) {
        success();
        return;
    }
    
    self.signInBlock = success;
    
    IGSignUpViewController *vc = IGSignUpViewController.alloc.init;
    vc.delegate = self;
    
    UINavigationController *nav = [UINavigationController.alloc initWithRootViewController:vc];
    
    [baseViewController presentViewController:nav
                                     animated:YES
                                   completion:NULL];
}


- (void)signInViewController:(IGSignInViewController *)vc
	tappedSignInWithUsername:(NSString *)username
				 andPassword:(NSString *)password {
	[SVProgressHUD showWithStatus:@"Contacting Relisten.net"
						 maskType:SVProgressHUDMaskTypeBlack];
	
	[self validateUsername:username
			  withPassword:password
					  save:YES
					result:^(BOOL valid) {
						[SVProgressHUD dismiss];
						
						if(valid) {
							[vc.presentingViewController dismissViewControllerAnimated:YES
																			completion:NULL];
							
							self.signInBlock();
						}
						else {
							UIAlertView *a = [UIAlertView.alloc initWithTitle:@"Relisten.net username or Password Incorrect"
																	  message:@"It would seem that your email or password is incorrect. You need to use the email and password you use on Relisten.net."
																	 delegate:nil
															cancelButtonTitle:@"OK"
															otherButtonTitles:nil];
							
							[a show];
						}
					}];
}

- (void)dismissTappedInSignInViewController:(IGSignInViewController *)vc {
	[vc.presentingViewController dismissViewControllerAnimated:YES
													completion:NULL];
	
	self.signInBlock = nil;
}

- (void)signUpViewController:(IGSignUpViewController *)vc
    tappedSignUpWithUsername:(NSString *)username
                 andPassword:(NSString *)password {
    [SVProgressHUD showWithStatus:@"Contacting Relisten.net"
                         maskType:SVProgressHUDMaskTypeBlack];
    
    [self validateUsername:username
              withPassword:password
                      save:YES
                    result:^(BOOL valid) {
                        [SVProgressHUD dismiss];
                        
                        if(valid) {
                            [vc.presentingViewController dismissViewControllerAnimated:YES
                                                                            completion:NULL];
                            
                            self.signInBlock();
                        }
                        else {
                            UIAlertView *a = [UIAlertView.alloc initWithTitle:@"Relisten.net username or Password Incorrect"
                                                                      message:@"It would seem that your email or password is incorrect. You need to use the email and password you use on Relisten.net."
                                                                     delegate:nil
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil];
                            
                            [a show];
                        }
                    }];

}

- (void)dismissTappedInSignUpViewController:(IGSignUpViewController *)vc {
    [vc.presentingViewController dismissViewControllerAnimated:YES
                                                    completion:NULL];
    
    self.signInBlock = nil;
}


- (void)signOut {
	FXKeychain.defaultKeychain[kRelistenNetUsernameKeychainKey] = nil;
	FXKeychain.defaultKeychain[kRelistenNetPasswordKeychainKey] = nil;
}

@end
