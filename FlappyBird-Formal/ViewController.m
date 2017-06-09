//
//  ViewController.m
//  FlappyBird-Formal
//
//  Created by qianfeng on 14-10-27.
//  Copyright (c) 2014年 jyw. All rights reserved.
//

#import "ViewController.h"
static int _score=0;

@interface ViewController ()
{
    UIImageView *_planeView;
    UIImageView *_cloudView;
    UIImageView *_bigCloudView;
    UIImageView *_bgCViewA;
    UIImageView *_bgCViewB;
    UIScrollView *_birdView;
    CGFloat _speed;
    NSMutableArray *_wallArray;
    BOOL _isOver;
    
    UILabel *_scoreLabel;
}
@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isOver=YES;
    self.view.backgroundColor=[UIColor colorWithRed:0.2431 green:0.5647 blue:0.9451 alpha:1];
    [self uiconfig];
    [self animateConfig];
}

- (void)uiconfig
{
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];
    
    _wallArray=[[NSMutableArray alloc] init];
    
    _cloudView=[[UIImageView alloc] initWithFrame:CGRectMake(320, 100, 192, 35)];
    _cloudView.image=[UIImage imageNamed:@"cloud"];
    [self.view addSubview:_cloudView];
    
    _planeView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"plane1"]];
    _planeView.center=CGPointMake(40, 100);
    [self.view addSubview:_planeView];
    
    _bigCloudView=[[UIImageView alloc] initWithFrame:CGRectMake(350, 200, 384, 71)];
    _bigCloudView.image=[UIImage imageNamed:@"cloud"];
    [self.view addSubview:_bigCloudView];
    
    
    UIButton *startBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [startBtn setTitle:@"Tap here to Start!" forState:UIControlStateNormal];
    startBtn.tag=200;
    startBtn.layer.cornerRadius=10;
    startBtn.layer.masksToBounds=YES;
    startBtn.backgroundColor=[UIColor redColor];
    startBtn.frame=CGRectMake(0, 0, 150, 30);
    startBtn.center=CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2+40);
    [startBtn addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    
    _bgCViewA=[[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-99, 320, 99)];
    _bgCViewA.image=[UIImage imageNamed:@"background"];
    [self.view addSubview:_bgCViewA];
    [self.view bringSubviewToFront:_bgCViewA];
    
    _bgCViewB=[[UIImageView alloc] initWithFrame:CGRectMake(320, self.view.bounds.size.height-99, 320, 99)];
    _bgCViewB.image=[UIImage imageNamed:@"background_alt"];
    [self.view addSubview:_bgCViewB];
    
    _birdView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 36, 24)];
    _birdView.center=CGPointMake(self.view.bounds.size.width/2-40, self.view.bounds.size.height/2-40);
    UIImageView *flyImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flappy_fly"]];
    [_birdView addSubview:flyImage];
    [self.view addSubview:_birdView];
    [self.view bringSubviewToFront:_birdView];
    
    _scoreLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    _scoreLabel.backgroundColor=[UIColor lightGrayColor];
    _scoreLabel.alpha=0.7;
    _scoreLabel.center=CGPointMake(self.view.bounds.size.width/2, 40);
    _scoreLabel.font=[UIFont systemFontOfSize:24];
    _scoreLabel.textAlignment=NSTextAlignmentCenter;
    _scoreLabel.text=@"Score: 0";
    _scoreLabel.layer.cornerRadius=10;
    _scoreLabel.layer.masksToBounds=YES;
    [self.view addSubview:_scoreLabel];
}

- (void)startGame
{
    [[GameEngine sharedEngine]setValid:YES withName:@"flyAnimate"];
    [[GameEngine sharedEngine]setValid:YES withName:@"wall"];
    [self tapAction];
    [(UIButton *)[self.view viewWithTag:200] removeFromSuperview];
}

- (void)animateConfig
{
    [[GameEngine sharedEngine] addAnimate:^{
        _cloudView.center=CGPointMake(_cloudView.center.x-0.5, _cloudView.center.y);
        if (_cloudView.center.x<-_cloudView.frame.size.width/2) {
            _cloudView.frame=CGRectMake(320, 100+(arc4random()%200), 192, 35);
        }
    } withTime:2 withName:@"cloud"];
    
    [[GameEngine sharedEngine] addAnimate:^{
        _planeView.center=CGPointMake(_planeView.center.x-1, _planeView.center.y);
        if (_planeView.center.x<-_planeView.frame.size.width/2) {
            UIImage *img=[UIImage imageNamed:[NSString stringWithFormat:@"plane%d",(arc4random()%11)+1]];
            _planeView.image=img;
            _planeView.frame=CGRectMake(350, 50+(arc4random()%200), img.size.width, img.size.height);
        }
    } withTime:1 withName:@"plane"];
    
    [[GameEngine sharedEngine] addAnimate:^{
        _bigCloudView.center=CGPointMake(_bigCloudView.center.x-0.8, _bigCloudView.center.y);
        if (_bigCloudView.center.x<-_bigCloudView.frame.size.width/2) {
            _bigCloudView.frame=CGRectMake(350, 50+(arc4random()%300), 384, 71);
        }
    } withTime:1 withName:@"bigcloud"];
    
    [[GameEngine sharedEngine] addAnimate:^{
        _bgCViewA.center=CGPointMake(_bgCViewA.center.x-1, _bgCViewA.center.y);
        _bgCViewB.center=CGPointMake(_bgCViewB.center.x-1, _bgCViewB.center.y);
        if (_bgCViewA.frame.origin.x<=-320) {
            _bgCViewA.frame=CGRectMake(320, self.view.bounds.size.height-99, 320, 99);
        }
        if (_bgCViewB.frame.origin.x<=-320) {
            _bgCViewB.frame=CGRectMake(320, self.view.bounds.size.height-99, 320, 99);
        }
    } withTime:1 withName:@"bgCloud"];
    
    [[GameEngine sharedEngine] addAnimate:^{
        NSInteger contentOffsetX=_birdView.contentOffset.x+36;
        contentOffsetX=contentOffsetX>230?0:contentOffsetX;
        _birdView.contentOffset=CGPointMake(contentOffsetX, 0);
    } withTime:7 withName:@"birdfly"];
    
    [[GameEngine sharedEngine] addAnimate:^{
        _birdView.center=CGPointMake(_birdView.center.x, _birdView.center.y+_speed);
        _speed+=0.25;
    } withTime:1 withName:@"flyAnimate"];
    [[GameEngine sharedEngine]setValid:NO withName:@"flyAnimate"];
    
    [[GameEngine sharedEngine] addAnimate:^{
        for (int i=_wallArray.count-1; i>=0; i--) {
            UIImageView *imgv=_wallArray[i];
            imgv.center=CGPointMake(imgv.center.x-1.5, imgv.center.y);
            if (imgv.center.x==_birdView.center.x && i%2==0) {
                _score++;
                _scoreLabel.text=[NSString stringWithFormat:@"Score: %d",_score];
                //NSLog(@"score: %d",_score);
            }
            if (imgv.center.x<-40) {
                [imgv removeFromSuperview];
                [_wallArray removeObject:imgv];
            }
        }
        UIImageView *imgv=_wallArray.lastObject;
        if (_wallArray.count==0 || imgv.center.x<250) {
            [self addWalls];
        }
        
    } withTime:1 withName:@"wall"];
    [[GameEngine sharedEngine]setValid:NO withName:@"wall"];
    
    [[GameEngine sharedEngine] addAnimate:^{
        for (UIImageView *imgv in _wallArray) {
            if (CGRectIntersectsRect(_birdView.frame, imgv.frame) || _birdView.center.y>self.view.bounds.size.height+_birdView.bounds.size.height/2) {
                [self gameOver];
            }
        }
    } withTime:1 withName:@"gameover"];
}

- (void)gameOver
{
    if (_isOver) {
        NSLog(@"gameover");
        self.view.userInteractionEnabled=NO;
        [[GameEngine sharedEngine]setValid:NO withName:@"wall"];
        [self tapAction];
        [UIView animateWithDuration:1.2 delay:1.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _scoreLabel.frame=CGRectMake(160-_scoreLabel.frame.size.width/2, 200-_scoreLabel.frame.size.height/2, _scoreLabel.frame.size.width, _scoreLabel.frame.size.height);
        } completion:^(BOOL finished) {
            self.view.userInteractionEnabled=YES;
            UIButton *restartBtn=[UIButton buttonWithType:UIButtonTypeSystem];
            restartBtn.titleLabel.font=[UIFont systemFontOfSize:24];
            restartBtn.tintColor=[UIColor whiteColor];
            restartBtn.layer.cornerRadius=10;
            restartBtn.layer.masksToBounds=YES;
            [restartBtn setTitle:@"Restart" forState:UIControlStateNormal];
            restartBtn.frame=CGRectMake(0, 0, 90, 30);
            restartBtn.backgroundColor=[UIColor darkGrayColor];
            restartBtn.center=CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2+40);
            [restartBtn addTarget:self action:@selector(restartGame) forControlEvents:UIControlEventTouchUpInside];
            [self.view insertSubview:restartBtn aboveSubview:_bgCViewB];
        }];
        _isOver=NO;
    }
}

- (void)restartGame
{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha=0;
    }completion:^(BOOL finished) {
        NSLog(@"restart");
        _score=0;
        [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [[GameEngine sharedEngine] removeAllSuperAnimate];
        [self viewDidLoad];
        [UIView animateWithDuration:0.25 animations:^{
            self.view.alpha=1;
        }];
    }];
}

- (void)tapAction
{
    _speed=-5;
    
}

- (void)addWalls
{
    UIImageView *topWall=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_wall"]];
    UIImageView *bottomWall=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_wall"]];
    [self.view insertSubview:topWall belowSubview:_bgCViewA];
    [self.view insertSubview:bottomWall belowSubview:_bgCViewA];
    
    CGFloat y=(arc4random()%200);
    topWall.center=CGPointMake(450, y-200);
    bottomWall.center=CGPointMake(450, topWall.center.y+610);
    
    [_wallArray addObject:topWall];
    [_wallArray addObject:bottomWall];
}

//- (void)refreshView
//{
//    _score=0;
//    //[[GameEngine sharedEngine] removeAllSuperAnimate];
//    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    [self viewDidLoad];
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
