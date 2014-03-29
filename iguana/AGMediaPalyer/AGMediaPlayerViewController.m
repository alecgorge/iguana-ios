//
//  AGMediaPlayerViewController.m
//  iguana
//
//  Created by Alec Gorge on 3/3/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "AGMediaPlayerViewController.h"

#import <QuartzCore/QuartzCore.h>

#import <FBKVOController.h>
#import <AVFoundation/AVFoundation.h>
#import <StreamingKit/STKAudioPlayer.h>
#import <StreamingKit/STKAutoRecoveringHTTPDataSource.h>
#import <DOUAudioStreamer/DOUAudioStreamer.h>
#import <DOUAudioStreamer/DOUAudioVisualizer.h>

#import <MediaPlayer/MediaPlayer.h>

#import "IGTrackCell.h"
#import "IGMediaItem.h"

@interface AGMediaPlayerViewController ()

@property (weak, nonatomic) IBOutlet UIButton *uiPlayButton;
@property (weak, nonatomic) IBOutlet UIButton *uiPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *uiForwardButton;
@property (weak, nonatomic) IBOutlet UIButton *uiBackwardButton;
@property (weak, nonatomic) IBOutlet UISlider *uiProgressSlider;
@property (weak, nonatomic) IBOutlet UILabel *uiTimeLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *uiTimeElapsedLabel;
@property (weak, nonatomic) IBOutlet UIButton *uiLoopButton;
@property (weak, nonatomic) IBOutlet UIButton *uiShuffleButton;
@property (weak, nonatomic) IBOutlet UITableView *uiPlaybackQueueTable;
@property (weak, nonatomic) IBOutlet DOUAudioVisualizer *uiAudioVisualizer;
@property (weak, nonatomic) IBOutlet UILabel *uiStatusLabel;
@property (weak, nonatomic) IBOutlet UIView *uiBottomBar;
@property (weak, nonatomic) IBOutlet UIView *uiTopBar;

@property BOOL doneAppearance;

@property (strong, nonatomic) CAGradientLayer *uiPlaybackQueueMask;

@property (strong, nonatomic) STKAudioPlayer *audioPlayer;
@property (strong, nonatomic) DOUAudioStreamer *streamer;

@property (nonatomic, assign) BOOL seeking;

@property (strong, nonatomic) FBKVOController *KVOController;

- (IBAction)pressedPaused:(id)sender;
- (IBAction)pressedForward:(id)sender;
- (IBAction)pressedBackward:(id)sender;
- (IBAction)pressedLoop:(id)sender;
- (IBAction)pressedShuffle:(id)sender;
- (IBAction)pressedPlay:(id)sender;

@end

@implementation AGMediaPlayerViewController

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] initWithNibName:@"AGMediaPlayerViewController"
                                                bundle:nil];
    });
    return sharedInstance;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil
                               bundle:nibBundleOrNil]) {
        self.playbackQueue = [NSMutableArray array];
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        
        self.audioPlayer = [[STKAudioPlayer alloc] initWithOptions:(STKAudioPlayerOptions){
            .flushQueueOnSeek = YES,
            .enableVolumeMixer = NO,
            .equalizerBandFrequencies = {50, 100, 200, 400, 800, 1600, 2600, 16000}
        }];
    }
    
    return self;
}

- (void)setupObservers {
    // create KVO controller with observer
    self.KVOController = [FBKVOController controllerWithObserver:self];
    
    [self.KVOController observe:self.streamer
                        keyPath:@"status"
                        options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                          block:^(AGMediaPlayerViewController *observer, DOUAudioStreamer *streamer, NSDictionary *change) {
                              NSLog(@"status: %@", change[NSKeyValueChangeNewKey]);
                              
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  if(self.streamer.status == DOUAudioStreamerFinished) {
                                      [self forward];
                                  }
                                  
                                  [self updateStatusBar];
                              });
                          }];
    
    [self.KVOController observe:self.streamer
                        keyPath:@"duration"
                        options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                          block:^(AGMediaPlayerViewController *observer, DOUAudioStreamer *streamer, NSDictionary *change) {
                              NSLog(@"duration: %@", change[NSKeyValueChangeNewKey]);
                          }];
    
    [self.KVOController observe:self.streamer
                        keyPath:@"bufferingRatio"
                        options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                          block:^(AGMediaPlayerViewController *observer, DOUAudioStreamer *streamer, NSDictionary *change) {
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self updateStatusBar];
                              });
                          }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.uiPlaybackQueueTable registerNib:[UINib nibWithNibName:@"IGTrackCell"
                                                          bundle:nil]
                    forCellReuseIdentifier:@"track"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(remoteControlReceivedWithEvent:)
												 name:@"RemoteControlEventReceived"
											   object:nil];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    [self startUpdates];
}

- (void)startUpdates {
    [self redrawUI];
    
    [self performSelector:@selector(startUpdates)
               withObject:nil
               afterDelay:0.5];
}

- (void)setupAppearance {
    [self setupBar];
    [self maskPlaybackQueue];
    
    self.uiTopBar.backgroundColor = IG_COLOR_PLAYER_BG;
    self.uiBottomBar.backgroundColor = IG_COLOR_PLAYER_BG;
    self.uiStatusLabel.backgroundColor = IG_COLOR_PLAYER_BG;
    
    self.uiPlaybackQueueTable.backgroundColor = IG_COLOR_TABLE_BG;
    self.uiPlaybackQueueTable.separatorColor = IG_COLOR_TABLE_SEP;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.uiPlaybackQueueMask.position = CGPointMake(0, scrollView.contentOffset.y);
    [CATransaction commit];
}

- (void)maskPlaybackQueue {
    self.uiPlaybackQueueMask = [CAGradientLayer layer];
    CGColorRef outerColor = [UIColor colorWithWhite:1.0 alpha:0.0].CGColor;
    CGColorRef innerColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
    
    self.uiPlaybackQueueMask.colors = @[(__bridge id)outerColor, (__bridge id)innerColor,
                                        (__bridge id)innerColor, (__bridge id)outerColor];
    
    self.uiPlaybackQueueMask.locations = @[@0.05, @0.25, @0.75, @0.95];
    
    self.uiPlaybackQueueMask.bounds = CGRectMake(0, 0,
                                                 self.uiPlaybackQueueTable.frame.size.width,
                                                 self.uiPlaybackQueueTable.frame.size.height);
    
    self.uiPlaybackQueueMask.anchorPoint = CGPointZero;
    
    self.uiPlaybackQueueTable.layer.mask = self.uiPlaybackQueueMask;
}

- (void)setupBar {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 2;
    label.font = [UIFont boldSystemFontOfSize: 14.0f];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = [NSString stringWithFormat:@"%@\n%@", self.currentItem.displayText, self.currentItem.displaySubText];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:20.0f/255.0f
                                                                           green:20.0f/255.0f
                                                                            blue:20.0f/255.0f
                                                                           alpha:1.0];
    
    self.navigationController.navigationBar.tintColor = UIColor.whiteColor;

    self.navigationItem.titleView = label;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"glyphicons_halflings_113_chevron-down"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(dismiss)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                          target:self
                                                                                          action:@selector(share)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;

    if(!self.doneAppearance) {
        [self setupAppearance];
        
        self.doneAppearance = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDefault;
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES
                             completion:NULL];
}

//Make sure we can recieve remote control events
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)remoteControlReceivedWithEvent:(NSNotification *)note {
    UIEvent *event = note.object;
    
    //if it is a remote control event handle it correctly
    if (event.type == UIEventTypeRemoteControl) {
        if (event.subtype == UIEventSubtypeRemoteControlPlay) {
            [self play];
        }
        else if (event.subtype == UIEventSubtypeRemoteControlPause) {
            [self pause];
        }
        else if (event.subtype == UIEventSubtypeRemoteControlTogglePlayPause) {
            [self togglePlayPause];
        }
        else if(event.subtype == UIEventSubtypeRemoteControlNextTrack) {
            [self forward];
        }
        else if(event.subtype == UIEventSubtypeRemoteControlPreviousTrack) {
            [self backward];
        }
    }
}

#pragma mark - Public Interface

- (DOUAudioStreamerStatus)state {
    return self.streamer.status;
}

- (BOOL)playing {
    return self.state == DOUAudioStreamerPlaying
        || self.state == DOUAudioStreamerBuffering;
}

- (AGMediaItem *)currentItem {
    return self.playbackQueue[self.currentIndex];
}

- (NSUInteger) nextIndex {
    if(self.loop || self.playbackQueue.count == 1) {
        return self.currentIndex;
    }
    else if(self.shuffle) {
        NSInteger randomIndex = -1;
        while(randomIndex == -1 || randomIndex == self.currentIndex)
            randomIndex = arc4random_uniform((u_int32_t)self.playbackQueue.count);
        return randomIndex;
    }
    
    if(self.currentIndex + 1 >= self.playbackQueue.count) {
        return 0;
    }
    
    return self.currentIndex + 1;
}

- (AGMediaItem *)nextItem {
    return self.playbackQueue[self.nextIndex];
}

- (IGTrack *)currentTrack {
    if(self.currentIndex >= self.playbackQueue.count) {
        return nil;
    }
    
    return ((IGMediaItem *)self.playbackQueue[self.currentIndex]).track;
}

- (void)setCurrentIndex:(NSUInteger)currentIndex {
    _currentIndex = currentIndex;
    
    self.streamer = [DOUAudioStreamer streamerWithAudioFile:self.currentItem];
    [DOUAudioStreamer setHintWithAudioFile:self.nextItem];
    [self setupObservers];
    
    [self play];
    [self.uiPlaybackQueueTable reloadData];
    [self redrawUI];
}

- (float)progress {
    if(self.streamer.duration == 0.0) {
        return 0;
    }
    
    return self.streamer.currentTime / self.streamer.duration;
}

- (void)setProgress:(float)progress {
    self.streamer.currentTime = progress * self.streamer.duration;
    self.uiProgressSlider.value = progress;
}

- (void)forward {
    self.currentIndex = self.nextIndex;
}

- (void)backward {
    self.currentIndex--;
}

- (void)play {
    [self.streamer play];
    [self redrawUI];
}

- (void)pause {
    [self.streamer pause];
    [self redrawUI];
}

- (void)togglePlayPause {
    if(!self.playing) {
        [self play];
    }
    else {
        [self pause];
    }
}

- (void)addItemsToQueue:(NSArray *)queue {
    [self.playbackQueue addObjectsFromArray:queue];
}

- (void)replaceQueueWithItems:(NSArray *)queue startIndex:(NSUInteger)index {
    self.playbackQueue = [queue mutableCopy];
    self.currentIndex = index;
}

#pragma mark - Tableview Stuff

- (IGTrack *)trackForIndexPath:(NSIndexPath *)indexPath {
    return ((IGMediaItem *)self.playbackQueue[indexPath.row]).track;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.playbackQueue.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"track";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    
    IGTrackCell *c = [[IGTrackCell alloc] initWithCell:cell];
    [c updateCellWithTrack:[self trackForIndexPath:indexPath]
               inTableView:tableView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
    self.currentIndex = indexPath.row;
    
    // show correct playback indicator
    [tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"track"];
    
    IGTrackCell *c = [[IGTrackCell alloc] initWithCell:cell];
    
    return [c heightForCellWithTrack:[self trackForIndexPath:indexPath]
                         inTableView:tableView];
}

#pragma mark - UI Stuff

- (NSString *)stringForStatus:(DOUAudioStreamerStatus)status {
    switch (status) {
        case DOUAudioStreamerPlaying:
            return @"Playing";
        case DOUAudioStreamerPaused:
            return @"Paused";
        case DOUAudioStreamerIdle:
            return @"Idle";
        case DOUAudioStreamerFinished:
            return @"Finished";
        case DOUAudioStreamerBuffering:
            return @"Buffering";
        case DOUAudioStreamerError:
            return @"Error";
    }
}

- (void)updateStatusBar {
    self.uiStatusLabel.text = [NSString stringWithFormat:@"%@: %.0f%% loaded, %.0f KB/s", [self stringForStatus:self.state], self.streamer.bufferingRatio * 100.0, self.streamer.downloadSpeed / 1024.0];
}

// no expensive calculations, just make UI is synced
- (void)redrawUI {
    self.uiPauseButton.hidden = !self.playing;
    self.uiPlayButton.hidden = self.playing;
    
    self.uiBackwardButton.enabled = self.currentIndex != 0;
    
    self.uiTimeElapsedLabel.text = [IGDurationHelper formattedTimeWithInterval:self.streamer.currentTime];
    self.uiTimeLeftLabel.text = [IGDurationHelper formattedTimeWithInterval:self.streamer.duration];
    
    self.uiProgressSlider.value = self.progress;
    
    [self setupBar];
}

- (IBAction)pressedPaused:(id)sender {
    [self pause];
}

- (IBAction)pressedForward:(id)sender {
    [self forward];
}

- (IBAction)pressedBackward:(id)sender {
    [self backward];
}

- (IBAction)pressedLoop:(id)sender {
    self.loop = !self.loop;
}

- (IBAction)pressedShuffle:(id)sender {
    self.shuffle = !self.shuffle;
}

- (IBAction)pressedPlay:(id)sender {
    [self play];
}

- (IBAction)seekingStarted:(id)sender {
    self.seeking = YES;
}

- (IBAction)seekingEndedOutside:(id)sender {
    self.seeking = NO;
    self.progress = self.uiProgressSlider.value;
}

- (IBAction)seekingEndedInside:(id)sender {
    [self seekingEndedOutside:sender];
}

@end
