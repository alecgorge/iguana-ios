//
//  IGAppDelegate.m
//  The Dead On Demand
//
//  Created by Alec Gorge on 3/1/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGAppDelegate.h"

#import <Crashlytics/Crashlytics.h>
#import <LastFm/LastFm.h>

#import <JBKenBurnsView/JBKenBurnsView.h>
#import <ColorUtils/ColorUtils.h>

#import <FRLayeredNavigationController/FRLayeredNavigationController.h>
#import <FRLayeredNavigationController/FRLayeredNavigationItem.h>
#import <FRLayeredNavigationController/UIViewController+FRLayeredNavigationController.h>

#import "IGThirdPartyKeys.h"
#import "IGEchoNestImages.h"

#import "IGHomeViewController.h"
#import "IGArtistsViewController.h"
#import "AFNetworkActivityLogger.h"

void push_vc(UIViewController *obj, UIViewController *vc, BOOL maximumWidth) {
    if(IS_IPAD()) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];		
        [obj.layeredNavigationController pushViewController: nav
                                                  inFrontOf: obj
                                               maximumWidth: maximumWidth
                                                   animated: YES
                                              configuration:^(FRLayeredNavigationItem *item) {
                                                  item.hasBorder = NO;
                                                  item.hasChrome = NO;
                                              }];
    }
    else {
        [obj.navigationController pushViewController: vc
                                            animated: YES];
    }
}


@interface IGAppDelegate ()

@property (nonatomic) UIViewController *navigationController;

@end

static IGAppDelegate *shared;

@implementation IGAppDelegate

+ (instancetype)sharedInstance {
    return shared;
}

extern CFNotificationCenterRef CFNotificationCenterGetDistributedCenter(void);

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    shared = self;
    
    [self setupLibs];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self setupAppearance];
    [AFNetworkActivityLogger.sharedLogger startLogging];
    
    IGArtistsViewController *vc = [[IGArtistsViewController alloc] init];
    
    self.autoshrinker = [[IGNowPlayingAutoShrinker alloc] init];
    
    if(IS_IPAD()) {
        FRLayeredNavigationController *nav = [[FRLayeredNavigationController alloc] initWithRootViewController:vc configuration:^(FRLayeredNavigationItem *item) {
            item.hasChrome = NO;
            item.hasBorder = NO;
        }];
        nav.dropLayersWhenPulledRight = YES;
		nav.delegate = self.autoshrinker;
        self.navigationController = nav;
    }
    else {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        nav.delegate = self.autoshrinker;
        self.navigationController = nav;
    }
    
    self.window.rootViewController = self.navigationController;
    
    [self setupSlideshow];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)setupLibs {
    if(NO && IGThirdPartyKeys.sharedInstance.isFlurryEnabled) {
//        [Flurry setCrashReportingEnabled:NO];
//        [Flurry startSession:IGThirdPartyKeys.sharedInstance.flurryApiKey];
    }
    
    if(IGThirdPartyKeys.sharedInstance.isLastFmEnabled) {
        [LastFm sharedInstance].apiKey = IGThirdPartyKeys.sharedInstance.lastFmApiKey;
        [LastFm sharedInstance].apiSecret = IGThirdPartyKeys.sharedInstance.lastFmApiSecret;
        [LastFm sharedInstance].session = [NSUserDefaults.standardUserDefaults stringForKey:@"lastfm_session_key"];
        [LastFm sharedInstance].username = [NSUserDefaults.standardUserDefaults stringForKey:@"lastfm_username_key"];
    }
    
    if(IGThirdPartyKeys.sharedInstance.isCrashlyticsEnabled) {
        [Crashlytics startWithAPIKey:IGThirdPartyKeys.sharedInstance.crashlyticsApiKey];
        [Crashlytics setObjectValue:IGIguanaAppConfig.artistSlug
                             forKey:@"artist"];
    }
    
//    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"7daac925db1ef3557a249f71e5018c68"];
//    [[BITHockeyManager sharedHockeyManager] startManager];
//    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
}

- (void)setupSlideshow {
    UIView *container = [[UIView alloc] initWithFrame:[self screenRotatedRect]];
    UIView *colorOverlay = [[UIView alloc] initWithFrame:container.bounds];
    container.backgroundColor = UIColor.blackColor;
    
    colorOverlay.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:IG_SLIDESHOW_OVERLAY_ALPHA];
    self.colorOverlay = colorOverlay;
	
//	container.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	self.randomImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	self.container = container;

	if(!IS_IPAD()) {
		self.kenBurnsView = [[JBKenBurnsView alloc] initWithFrame:container.bounds];
		self.kenBurnsView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		self.kenBurnsView.backgroundColor = UIColor.blackColor;
		[container addSubview:self.kenBurnsView];
		[container addSubview:colorOverlay];

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
	else {
		self.randomImageView = [[UIImageView alloc] initWithFrame:container.bounds];
		self.randomImageView.backgroundColor = UIColor.blackColor;
		self.randomImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		self.randomImageView.contentMode = UIViewContentModeScaleAspectFill;
		
		[container addSubview:self.randomImageView];

		__block BOOL called = NO;
		[IGEchoNestImages.sharedInstance images:^(NSArray *images) {
			self.randomImages = images;
			
			if(!called) {
				[self displayRandomImage];
				called = YES;
			}
		}];

        [self.window.rootViewController.view addSubview:container];
        [self.window.rootViewController.view sendSubviewToBack:container];
	}
}

- (CGRect)screenRotatedRect {
	return [self screenRotatedRectForOrientation:UIApplication.sharedApplication.statusBarOrientation];
}

- (CGRect)screenRotatedRectForOrientation:(UIInterfaceOrientation)orientation {
	CGRect bounds = UIScreen.mainScreen.bounds; // portrait bounds
	if (UIInterfaceOrientationIsLandscape(orientation)) {
		bounds.size = CGSizeMake(bounds.size.height, bounds.size.width);
	}
	return bounds;
}

- (void)application:(UIApplication *)application
willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation
		   duration:(NSTimeInterval)duration {
	[UIView animateWithDuration:duration
					 animations:^{
						 self.container.frame = [self screenRotatedRectForOrientation:newStatusBarOrientation];
					 }];
}

- (void)displayRandomImage {
	self.randomImageView.image = self.randomImages[arc4random_uniform((unsigned int)self.randomImages.count)];
	
	[self performSelector:@selector(displayRandomImage)
			   withObject:nil
			   afterDelay:IG_SLIDESHOW_DURATION];
}

- (UIImage*)currentImage {
	if(self.kenBurnsView) {
		return self.kenBurnsView.currentImage;
	}
	
	return self.randomImageView.image;
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

@end
