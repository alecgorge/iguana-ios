//
//  AGNowPlayingViewController.m
//  iguana
//
//  Created by Alec Gorge on 3/3/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "AGNowPlayingViewController.h"

@interface AGNowPlayingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *uiTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *uiAlbumLabel;
@property (weak, nonatomic) IBOutlet UIButton *uiBackwardsButton;
@property (weak, nonatomic) IBOutlet UIButton *uiPlayButton;
@property (weak, nonatomic) IBOutlet UIButton *uiPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *uiForwardButton;
@property (weak, nonatomic) IBOutlet UILabel *uiTimeElapsedLabel;
@property (weak, nonatomic) IBOutlet UILabel *uiTimeLeftLabel;

@end

@implementation AGNowPlayingViewController

+ (instancetype)sharedNowPlayingBar {
    static dispatch_once_t once;
    static AGNowPlayingViewController *sharedFoo;
    dispatch_once(&once, ^ {
		sharedFoo = [[self alloc] init];
	});
    return sharedFoo;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressedBackwards:(id)sender {
}
- (IBAction)pressedPlay:(id)sender {
}
- (IBAction)pressedPause:(id)sender {
}
- (IBAction)pressedForward:(id)sender {
}

@end
