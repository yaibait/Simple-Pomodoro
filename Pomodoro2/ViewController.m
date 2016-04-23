//
//  ViewController.m
//  Pomodoro2
//
//  Created by Nguyen Binh on 4/12/16.
//  Copyright © 2016 Nguyen Binh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
    
@end

@implementation ViewController{
    NSTimer *timer;
    NSDate * backgroundTime;
    float storeDistantBG;
    UILocalNotification *pomodoroNotify;
    BOOL light;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self drawPomodoro];

    
    pos = 0;
    speed = (float) 626/(25*60);
   // NSLog(@"%f",speed);

    NSString *ringFile = [[NSBundle mainBundle] pathForResource:@"pomodoro_ring" ofType:@"mp3"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:ringFile];
    ringPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    ringPlayer.numberOfLoops = 1;
    
    NSString *tickFile = [[NSBundle mainBundle] pathForResource:@"pomodoro_tick" ofType:@"mp3"];
     soundFileURL = [NSURL fileURLWithPath:tickFile];
    tickPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    //tickPlayer.numberOfLoops = 1;
    
    NSString *turnFile = [[NSBundle mainBundle] pathForResource:@"pomodoro_turn" ofType:@"mp3"];
    soundFileURL = [NSURL fileURLWithPath:turnFile];
    turnPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    tickPlayer.numberOfLoops = 1;
    
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//    NSError *setCategoryError = nil;
//    BOOL success = [audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
//    if (!success) { /* handle the error condition */ }
//    
//    NSError *activationError = nil;
//    success = [audioSession setActive:YES error:&activationError];
//    if (!success) { /* handle the error condition */ }
    
    soundPlay = TRUE;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(backgroundStart)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:[UIApplication sharedApplication]];
   
   
    light = NO;
    
    
};

-(void)createNotify:(NSTimeInterval)time{
    
    pomodoroNotify = [[UILocalNotification alloc] init];
    pomodoroNotify.fireDate = [[NSDate date] dateByAddingTimeInterval:time];
    pomodoroNotify.alertBody = @"Pomodoro Done";
    pomodoroNotify.applicationIconBadgeNumber = 0;
    [pomodoroNotify setSoundName:@"ring.caf"];
    pomodoroNotify.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:pomodoroNotify];
};

-(void)removeNotify{
    NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications] ;
    
    for (UILocalNotification *localNotification in arrayOfLocalNotifications) {
        
        if ([localNotification.alertBody isEqualToString:@"Pomodoro Done"]) {
        
            [[UIApplication sharedApplication] cancelLocalNotification:localNotification] ; // delete the notification from the system
            
            return;
        }
        
    }
}


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateGUI)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:[UIApplication sharedApplication]];
}

-(void)updateGUI{
    
    NSTimeInterval diff = fabs([backgroundTime timeIntervalSinceNow]);
    float distant = (float) diff * speed;
    float space = storeDistantBG - distant;
    
    if(space >= 0){
        
        [_scrollPomodoro scrollRectToVisible:CGRectMake(space, 0, _scrollPomodoro.frame.size.width, _scrollPomodoro.frame.size.height) animated:YES];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeCountDown) userInfo:nil repeats:YES];
    }else{
        if(timer){
            [timer invalidate];
            timer = nil;
        }
        [_scrollPomodoro scrollRectToVisible:CGRectMake(0, 0, _scrollPomodoro.frame.size.width, _scrollPomodoro.frame.size.height) animated:YES];
    };
    //[self removeNotify];
    
    
}
-(void)backgroundStart{
    backgroundTime = [NSDate date];
    storeDistantBG = _scrollPomodoro.contentOffset.x;
    NSTimeInterval time = (_scrollPomodoro.contentOffset.x * 25*60) / 626;
    if(time > 0)
        [self createNotify: time];
    if(timer){
        [timer invalidate];
        timer = nil;
    }

}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

- (void) drawPomodoro{
    
    UIImage *pomodoroImg = [UIImage imageNamed:@"pomodoro.png"];
    //CGSize currentImgSize = pomodoroImg.size;
    
    CGSize newsize = CGSizeMake(676, 50);
    
    
    
    UIGraphicsBeginImageContextWithOptions(newsize, NO, 0.0);
    [pomodoroImg drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    UIImage * resizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *pomodoroImgView = [[UIImageView alloc] initWithImage:resizeImage];
    CGRect pomodoroImgViewFrame = pomodoroImgView.frame;
    
    CGRect currentFrame = _scrollPomodoro.frame;
    pomodoroImgView.frame = CGRectMake(pomodoroImgViewFrame.origin.x + currentFrame.size.width/2, pomodoroImgViewFrame.origin.y, pomodoroImgViewFrame.size.width, pomodoroImgViewFrame.size.height);
    
    [_scrollPomodoro setFrame:CGRectMake(currentFrame.origin.x, currentFrame.origin.y, currentFrame.size.width, 100)];
    
    [_scrollPomodoro addSubview:pomodoroImgView];
    scrollSize = newsize.width + currentFrame.size.width - 50;
    [_scrollPomodoro setContentSize:CGSizeMake(scrollSize, newsize.height)];
    [_scrollPomodoro setShowsHorizontalScrollIndicator:false];
    _scrollPomodoro.alwaysBounceHorizontal = NO;
    _scrollPomodoro.bounces = false;
    _scrollPomodoro.decelerationRate = UIScrollViewDecelerationRateFast;
    
    [self drawTriangle];

}


- (void) drawTriangle{
    
    
    CGRect viewRect = CGRectMake(self.view.center.x - 48, self.view.center.y + 35, 100, 100);
    TriangleView *tri = [[TriangleView alloc] initWithFrame:viewRect];
    
    [self.view addSubview:tri];
    
};

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    tempPos = _scrollPomodoro.contentOffset.x;
};

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if(tempPos < _scrollPomodoro.contentOffset.x){
        if(soundPlay)
            [turnPlayer play];
    }
    //CGPoint point = [scrollView contentOffset];
    //float time = (point.x * 25) / 626;

     //NSLog(@"%f",point.x);
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    if(timer){
        [timer invalidate];
        timer = nil;
    }
    if(scrollView.contentOffset.x == 0) return;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeCountDown) userInfo:nil repeats:YES];
}


- (void)timeCountDown{
    if(_scrollPomodoro.contentOffset.x == 0){
        if(soundPlay)
            [ringPlayer play];
         AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [timer invalidate];
        timer = nil;
    }
    [_scrollPomodoro scrollRectToVisible:CGRectMake(_scrollPomodoro.contentOffset.x - speed, 0, _scrollPomodoro.frame.size.width, _scrollPomodoro.frame.size.height) animated:YES];
    if(soundPlay)
        [tickPlayer play];
    
};


- (IBAction)btnLightAction:(id)sender {
    if(light){
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        light = NO;
        [sender setImage:[UIImage imageNamed:@"lightoff.png"] forState:UIControlStateNormal];
    }else{
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        light = YES;
        [sender setImage:[UIImage imageNamed:@"lighton.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)soundBtn:(id)sender {
    if(soundPlay){
        soundPlay = NO;
        [sender setImage:[UIImage imageNamed:@"volumeoff.png"] forState:UIControlStateNormal];
    }else{
        soundPlay = YES;
        [sender setImage:[UIImage imageNamed:@"volumeon.png"] forState:UIControlStateNormal];
    }
}
@end
