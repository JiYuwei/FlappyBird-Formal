//
//  ViewController.h
//  FlappyBird-Formal
//
//  Created by qianfeng on 14-10-27.
//  Copyright (c) 2014年 jyw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameEngine.h"

//@protocol RefreshViewDelegate <NSObject>
//
//-(void)refreshView;
//
//@end


@interface ViewController : UIViewController

- (void)startGame;
- (void)tapAction;
- (void)restartGame;

@end
