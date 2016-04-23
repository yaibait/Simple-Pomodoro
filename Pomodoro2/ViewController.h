//
//  ViewController.h
//  Pomodoro2
//
//  Created by Nguyen Binh on 4/12/16.
//  Copyright © 2016 Nguyen Binh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TriangleView.h"
@import AVFoundation;
@import AudioToolbox;

@interface ViewController : UIViewController <UIScrollViewDelegate>{
    float scrollSize;
    float pos;
    float speed;
    AVAudioPlayer *ringPlayer;
    AVAudioPlayer *tickPlayer;
    AVAudioPlayer *turnPlayer;
    float tempPos;
    BOOL soundPlay;
}
@property (weak, nonatomic) IBOutlet UIButton *soundBtnUI;
- (IBAction)btnLightAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnLightUI;

- (IBAction)soundBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollPomodoro;

@end

