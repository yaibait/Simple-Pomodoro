//
//  TriangleView.m
//  Pomodoro2
//
//  Created by Nguyen Binh on 4/21/16.
//  Copyright © 2016 Nguyen Binh. All rights reserved.
//

#import "TriangleView.h"

@implementation TriangleView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGPoint center = CGPointMake(self.frame.size.width/2,0);
   
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextMoveToPoint(context, center.x, center.y);
    CGContextAddLineToPoint(context,center.x + 20, center.y + 20);
    CGContextAddLineToPoint(context,center.x - 20,center.y + 20);
    CGContextAddLineToPoint(context,center.x , center.y);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillPath(context);
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(context, 2.0);
//    CGContextSetStrokeColorWithColor(context,
//                                     [UIColor blueColor].CGColor);
//    CGContextMoveToPoint(context, self.frame.size.width/2, self.frame.size.height/2);
//    CGContextAddLineToPoint(context, 15, 15);
//    CGContextStrokePath(context);
    
}
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.opaque = NO;
    }
    return self;
}

@end
