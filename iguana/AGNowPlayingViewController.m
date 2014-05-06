//
//  AGNowPlayingViewController.m
//  iguana
//
//  Created by Alec Gorge on 3/3/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "AGNowPlayingViewController.h"

#import "AGMediaPlayerViewController.h"

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

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static AGNowPlayingViewController *sharedFoo;
    dispatch_once(&once, ^ {
		sharedFoo = [[self alloc] init];
	});
    return sharedFoo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
    
	self.view.backgroundColor = IG_COLOR_PLAYER_BG;
	
    [self startUpdates];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.view.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             self.view.alpha = 1;
                         });
                     }];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.navigationContainer.navigationController.navigationBar.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             self.navigationContainer.navigationController.navigationBar.alpha = 1;
                         });
                     }];

    [IGAppDelegate.sharedInstance presentMusicPlayer];
}

- (void)startUpdates {
    [self redrawUI];
    
    [self performSelector:@selector(startUpdates)
               withObject:nil
               afterDelay:0.5];
}

- (void)redrawUI {
    AGMediaPlayerViewController *media = AGMediaPlayerViewController.sharedInstance;
    if(media.playbackQueue.count == 0) {
        return;
    }
    
    self.uiPauseButton.hidden = !(media.playing || media.buffering);
    self.uiPlayButton.hidden = media.playing || media.buffering;
    
    self.uiBackwardsButton.enabled = media.currentIndex != 0;
    self.uiForwardButton.enabled = media.currentIndex < media.playbackQueue.count;
    
    self.uiTimeElapsedLabel.text = [IGDurationHelper formattedTimeWithInterval:media.audioPlayer.progress];
    self.uiTimeLeftLabel.text = [IGDurationHelper formattedTimeWithInterval:media.audioPlayer.duration];
    
    self.uiTitleLabel.text = media.currentItem.title;
    self.uiAlbumLabel.text = media.currentItem.album;
}

- (IBAction)pressedBackwards:(id)sender {
    [AGMediaPlayerViewController.sharedInstance backward];
}
- (IBAction)pressedPlay:(id)sender {
    [AGMediaPlayerViewController.sharedInstance play];
}
- (IBAction)pressedPause:(id)sender {
    [AGMediaPlayerViewController.sharedInstance pause];
}
- (IBAction)pressedForward:(id)sender {
    [AGMediaPlayerViewController.sharedInstance forward];
}

@end
