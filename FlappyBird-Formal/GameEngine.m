//
//  GameEngine.m
//  FlappyBird-Formal
//
//  Created by qianfeng on 14-10-27.
//  Copyright (c) 2014年 jyw. All rights reserved.
//

#import "GameEngine.h"

@implementation AnimateElement

@end


@implementation GameEngine
{
    NSTimer *_timer;
    NSMutableArray *_animateArray;
}

+(id)sharedEngine
{
    static GameEngine *_m=nil;
    if (!_m) {
        _m=[[GameEngine alloc] init];
    }
    return _m;
}

-(id)init
{
    if (self=[super init]) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        _animateArray=[[NSMutableArray alloc] init];
    }
    return self;
}

static NSInteger n=0;
-(void)timerAction
{
    n++;
    for (AnimateElement *ani in _animateArray) {
        if (ani.valid && n%ani.time==0) {
            ani.animate();
        }
    }
}

-(void)addAnimate:(void (^)())animate withTime:(NSInteger)time withName:(NSString *)name
{
    AnimateElement *ani=[[AnimateElement alloc] init];
    ani.animate=animate;
    ani.time=time;
    ani.name=name;
    ani.valid=YES;
    [_animateArray addObject:ani];
}

-(void)setValid:(BOOL)valid withName:(NSString *)name
{
    for (AnimateElement *ani in _animateArray) {
        if ([ani.name isEqualToString:name]) {
            ani.valid=valid;
        }
    }
}

-(void)removeAllSuperAnimate
{
    [_animateArray removeAllObjects];
}

@end
