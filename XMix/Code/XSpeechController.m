//
//  XSpeechController.m
//  XMix
//
//  Created by davidli on 15/12/28.
//  Copyright © 2015年 X. All rights reserved.
//

#import "XSpeechController.h"
#import <AVFoundation/AVFoundation.h>

@interface XSpeechController ()<AVSpeechSynthesizerDelegate>

@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer;
@property (strong, nonatomic) NSArray *voices;
@property (strong, nonatomic) NSArray *speechStrings;

@end

@implementation XSpeechController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSpeech];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark -AVSpeech Delegate
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance
{
    TraceS(@"+++didStartSpeechUtterance");
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
    TraceS(@"+++didFinishSpeechUtterance");
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance
{
    TraceS(@"+++didPauseSpeechUtterance");
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance
{
    TraceS(@"+++didContinueSpeechUtterance");
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance
{
    TraceS(@"+++didCancelSpeechUtterance");
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance
{
}


#pragma mark -Actions

- (IBAction)onHandleStart:(id)sender {
    [self startSpeech];
}

- (IBAction)onHandlePause:(id)sender {
    if (!_synthesizer.paused) {
        [_synthesizer pauseSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }
}

- (IBAction)onHandleResume:(id)sender {
    if (_synthesizer.paused) {
        [_synthesizer continueSpeaking];
    }
}


- (void)setUpSpeech
{
    //TraceS(@"+++++%@",[AVSpeechSynthesisVoice speechVoices]);

    _synthesizer = [[AVSpeechSynthesizer alloc] init];
    _synthesizer.delegate = self;
    _voices = @[[AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"],[AVSpeechSynthesisVoice voiceWithLanguage:@"en-GB"]];
    _speechStrings = @[@"Hello There,Welcome to the AV Foundation!",
                       @"It's a new world",
                       @"Are you exited about this?",
                       @"aha",
                       @"opps",
                       @"I LOVE YOU",
                       @"Stay hungery stay foolish"
                       ];
}


- (void)startSpeech
{
    if (_synthesizer.speaking) {
        return;
    }
    NSInteger count = _speechStrings.count;
    for (NSInteger i = NONE; i < count; i++) {
        NSString *string = _speechStrings[i];
        AVSpeechUtterance *utten = [[AVSpeechUtterance alloc] initWithString:string];
        utten.voice = _voices[i % 2];
        utten.rate = 0.2;
        utten.pitchMultiplier = 0.8;
        utten.postUtteranceDelay = ONE;
        [_synthesizer speakUtterance:utten];
    }
}

@end
