//
//  GameEngine.h
//  FlappyBird-Formal
//
//  Created by qianfeng on 14-10-27.
//  Copyright (c) 2014年 jyw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimateElement : NSObject

@property(nonatomic,copy)void(^animate)();
@property(nonatomic,copy)NSString *name;
@property(nonatomic,assign)NSInteger time;
@property(nonatomic,assign)BOOL valid;

@end


@interface GameEngine : NSObject

+(id)sharedEngine;

-(void)addAnimate:(void(^)())animate withTime:(NSInteger)time withName:(NSString *)name;
-(void)setValid:(BOOL)valid withName:(NSString *)name;
-(void)removeAllSuperAnimate;

@end
