//
//  IGAppDelegate.m
//  The Dead On Demand
//
//  Created by Alec Gorge on 3/1/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGAppDelegate.h"

#import <FlurrySDK/Flurry.h>
#import <JBKenBurnsView/JBKenBurnsView.h>
#import <ColorUtils/ColorUtils.h>

#import "IGEchoNestImages.h"

#import "IGHomeViewController.h"

@interface IGAppDelegate ()

@property (nonatomic) UINavigationController *navigationController;

@end

static IGAppDelegate *shared;

@implementation IGAppDelegate

+ (instancetype)sharedInstance {
    return shared;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    shared = self;
    
    [self setupLibs];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self setupAppearance];
    
    IGHomeViewController *vc = [[IGHomeViewController alloc] init];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    
    self.window.rootViewController = self.navigationController;
    
    [self setupSlideshow];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)setupLibs {
    [Flurry setCrashReportingEnabled:NO];
    [Flurry startSession:@"4RGRH573MCY85Z5RJC2X"];
}

- (void)setupSlideshow {
    UIView *container = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    UIView *colorOverlay = [[UIView alloc] initWithFrame:container.bounds];
    self.kenBurnsView = [[JBKenBurnsView alloc] initWithFrame:container.bounds];
    self.kenBurnsView.backgroundColor = UIColor.blackColor;
    container.backgroundColor = UIColor.blackColor;
    
    colorOverlay.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:IG_SLIDESHOW_OVERLAY_ALPHA];
    
    [container addSubview:self.kenBurnsView];
    [container addSubview:colorOverlay];
    
    self.colorOverlay = colorOverlay;
    
    [IGEchoNestImages.sharedInstance images:^(NSArray *images) {
        [self.kenBurnsView stopAnimation];
        [self.kenBurnsView animateWithImages:images
                          transitionDuration:IG_SLIDESHOW_DURATION
                                        loop:YES
                                 isLandscape:YES];
    }];
    
    [self.window addSubview:container];
    [self.window sendSubviewToBack:container];
}

- (void)setupAppearance {
    UINavigationBar.appearance.shadowImage = [UIImage new];
//    UINavigationBar.appearance.translucent = YES;
    [UINavigationBar.appearance setBackgroundImage:[self imageWithColor:IG_COLOR_NAVBAR_BG]
                                     forBarMetrics:UIBarMetricsDefault];
    
    UINavigationBar.appearance.tintColor = IG_COLOR_NAVBAR_BACK;
    UINavigationBar.appearance.titleTextAttributes = @{
                                                       NSForegroundColorAttributeName: IG_COLOR_NAVBAR_TITLE
                                                       };
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"RemoteControlEventReceived"
														object:event];
}

- (void)presentMusicPlayer {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[AGMediaPlayerViewController sharedInstance]];
    [self.navigationController presentViewController:nav
                                            animated:YES
                                          completion:NULL];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
