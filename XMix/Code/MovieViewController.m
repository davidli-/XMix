//
//  MovieViewController.m
//  XMix
//
//  Created by davidli on 15/7/23.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "MovieViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "BackButton.h"
#import "VideoSlider.h"
#import "XDateUtil.h"

NSString* const kUrl = @"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8";

@interface MovieViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (weak, nonatomic) IBOutlet UIView *movieBackView;
@property (weak, nonatomic) IBOutlet VideoSlider *progressSlider;
@property (weak, nonatomic) IBOutlet UILabel *timeLine;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@property (nonatomic) float videoDuration;
@property (nonatomic) float videoCurrentTime;

@property (nonatomic, strong) NSTimer *progressTimer;

@property (nonatomic) BOOL sliderValueEnable;    //点击进度滑块之后 禁止timer里再设置slider.value 防止按住时 滑块还在动的现象

@end

@implementation MovieViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    TraceS(@"+++++MovieViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUps];
    
    _videoDuration = NEGATIVE;
    
    //NOTICE
    _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:kUrl]];
    _moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
    _moviePlayer.controlStyle    = MPMovieControlStyleNone;
    _moviePlayer.scalingMode     = MPMovieScalingModeAspectFit;
    _moviePlayer.shouldAutoplay  = YES;
    
    [_moviePlayer prepareToPlay];
    [_moviePlayer pause];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self selector:@selector(moviePlayStateDidChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(movieLoadstateDidChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(movieDidFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(requestThumbNailImage:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:nil];
    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CGRect frame = _movieBackView.frame;
    frame.origin.y = NONE;
    [_moviePlayer.view setFrame:frame];
    [_movieBackView addSubview:_moviePlayer.view];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark -通知

-(void)moviePlayStateDidChange:(NSNotification*)notification{
    MPMoviePlayerController *player = notification.object;
    TraceS(@"++++视频直播状态:%ld++++",(long)player.playbackState);
}


-(void)movieLoadstateDidChange:(NSNotification*)notification {
    MPMoviePlayerController *player = notification.object;
    MPMovieLoadState state = player.loadState;
    
    _videoCurrentTime = player.currentPlaybackTime;
    if (NEGATIVE == _videoDuration) {
        _videoDuration = player.duration;
        NSString *string = [XDateUtil minutesFromTimestamp:(_videoDuration * MILLI)];
        _durationLabel.text = [NSString stringWithFormat:@"/%@",string];
    }
    float progress = _videoCurrentTime / _videoDuration;
    _progressSlider.value = progress;
    
    TraceS(@"\n\n\n视频加载状态:%lu;  \n视频时长:  %f; \n缓冲时间: %f; \n当前时间: %f\n\n\n;",(unsigned long)state,player.duration,player.playableDuration,player.currentPlaybackTime);
    
}


-(void)movieDidFinished:(NSNotification*)notification {
    [_moviePlayer pause];
    [_progressTimer invalidate];
    _progressTimer = nil;
    _timeLine.text = [XDateUtil minutesFromTimestamp:_videoDuration*MILLI];
    [self dismissMoviePlayerViewControllerAnimated];
}


-(void)requestThumbNailImage:(NSNotification*)notification {
    //NSDictionary *userInfo = [notification userInfo];
    //NSNumber *timecode =[userInfo objectForKey: @"MPMoviePlayerThumbnailTimeKey"];
    //UIImage *image =[userInfo objectForKey: @"MPMoviePlayerThumbnailImageKey"];
}


#pragma mark -acions
- (void)clickedBack:(id)sender{
    [_moviePlayer stop];
    
    [_progressTimer invalidate];
    _progressTimer = nil;
    _moviePlayer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)clickedCapture:(id)sender {
    //此方法不适合于HLS直播类型的视频  本地视频可以
    if ([_moviePlayer respondsToSelector:@selector(requestThumbnailImagesAtTimes:timeOption:)]) {
        NSLog(@"+++++");
    }
    [_moviePlayer requestThumbnailImagesAtTimes:@[@(1.0)] timeOption:MPMovieTimeOptionNearestKeyFrame];
}



- (IBAction)clickedStart:(id)sender {
    [_moviePlayer play];
    if (!_progressTimer) {
        _progressTimer = [NSTimer scheduledTimerWithTimeInterval:ONE target:self selector:@selector(progressChecker) userInfo:nil repeats:YES];
    }
}



- (IBAction)clickedPause:(id)sender {
    [_moviePlayer pause];
}


- (void)videoStartSlide:(id)sender{
    _sliderValueEnable = NO;
}


-(void)videoDidSlided:(id)sender {
    
    VideoSlider *slider = sender;
    float progress = slider.value;
    float dstTime = (progress * _videoDuration);
    
    [_moviePlayer setCurrentPlaybackTime:dstTime];
    
    _timeLine.text = [XDateUtil minutesFromTimestamp:dstTime * MILLI];
    
    _sliderValueEnable = YES;
    
    TraceS(@"+++++touchUpinside");
}



#pragma mark - 其他方法

-(void)progressChecker{
    
    if (NONE >= _moviePlayer.duration) {
        _videoDuration    = _moviePlayer.duration;
    }
    _videoCurrentTime = _moviePlayer.currentPlaybackTime;
    
    if (_sliderValueEnable) {
        _progressSlider.value = (_videoCurrentTime / _videoDuration);
        TraceS(@"++++\n\n\n\n slider值已自动变化+++");
    }
    
    _progressSlider.middleValue = ((_moviePlayer.playableDuration + 1000) / _videoDuration);
    
    _timeLine.text = [XDateUtil minutesFromTimestamp:(_videoCurrentTime * MILLI)];
    
    TraceS(@"++++++++++缓冲长度:%f",_moviePlayer.playableDuration);
}


-(void)panGestureAction:(UIPanGestureRecognizer*)gesture {
    
    TraceS(@"PAN Gesture++");
    
}

-(NSArray<id<UIPreviewActionItem>> *)previewActionItems
{
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"分享" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        TraceS(@"已分享");
    }];

    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"收藏" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        TraceS(@"已收藏");
    }];
    return @[action1,action2];
}



-(void)setUps{

    UIButton *back = [[BackButton alloc] initWithBackType:BACK_BTN_TYPE_IMAGE images:nil text:@"" target:self selector:@selector(clickedBack:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    
    UIButton *start = [[BackButton alloc] initWithBackType:BACK_BTN_TYPE_TEXT images:nil text:@"截图" target:self selector:@selector(clickedCapture:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:start];

    [_progressSlider addTarget:self action:@selector(videoDidSlided:) forControlEvents:UIControlEventTouchUpInside];
    [_progressSlider addTarget:self action:@selector(videoStartSlide:) forControlEvents:UIControlEventTouchDown];
    
    _sliderValueEnable = YES;
    
    _progressSlider.value = ONE;
    _progressSlider.middleValue = NONE;
    
    _progressSlider.minimumTrackTintColor = [UIColor yellowColor];
    _progressSlider.maximumTrackTintColor = [UIColor blackColor];
    _progressSlider.middleTrackTintColor  = [UIColor whiteColor];
    [_progressSlider setThumbImage:[UIImage imageNamed:@"player-progress-point"] forState:UIControlStateNormal];
    
    //UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    //panGesture.delegate = self;
    //[_movieBackView addGestureRecognizer:panGesture];
}

@end
