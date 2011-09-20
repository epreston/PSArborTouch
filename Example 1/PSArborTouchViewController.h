//
//  PSArborTouchViewController.h
//  PSArborTouch - Example 1
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <dispatch/dispatch.h>


@class ATPhysics;
@class ATParticle;
@class ATSpring;

@interface PSArborTouchViewController : UIViewController <UIGestureRecognizerDelegate>
{

@private
    ATPhysics   *_integrator;
    ATParticle  *_particle1;
    ATParticle  *_particle2;
    ATParticle  *_particle3;
    ATParticle  *_particle4;
    ATSpring    *_spring1;
    ATSpring    *_spring2;
    ATSpring    *_spring3;
    ATSpring    *_spring4;
    ATSpring    *_spring5;
    
    
    dispatch_source_t   _timer;
    NSInteger           _counter;
    BOOL                _running;
    
    UIView *pieceForReset;
    
    
    UILabel *_sumLabel;
    UILabel *_p1Name;
    UILabel *_p1Mass;
    UILabel *_p1Position;
    UILabel *_p1Fixed;
    UILabel *_p2Name;
    UILabel *_p2Mass;
    UILabel *_p2Position;
    UILabel *_p2Fixed;
    UIView *_viewPort;
    UIView *_particleView1;
    UIView *_particleView2;
    UIView *_particleView3;
    UIView *_particleView4;
    UILabel *_statusLabel;
    UILabel *_counterLabel;
    UILabel *_maxLabel;
    UILabel *_meanLabel;
    UILabel *_countLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *maxLabel;
@property (nonatomic, retain) IBOutlet UILabel *meanLabel;
@property (nonatomic, retain) IBOutlet UILabel *countLabel;
@property (nonatomic, retain) IBOutlet UILabel *sumLabel;

@property (nonatomic, retain) IBOutlet UILabel *p1Name;
@property (nonatomic, retain) IBOutlet UILabel *p1Mass;
@property (nonatomic, retain) IBOutlet UILabel *p1Position;
@property (nonatomic, retain) IBOutlet UILabel *p1Fixed;

@property (nonatomic, retain) IBOutlet UILabel *p2Name;
@property (nonatomic, retain) IBOutlet UILabel *p2Mass;
@property (nonatomic, retain) IBOutlet UILabel *p2Position;
@property (nonatomic, retain) IBOutlet UILabel *p2Fixed;

@property (nonatomic, retain) IBOutlet UIView *viewPort;
@property (nonatomic, retain) IBOutlet UIView *particleView1;
@property (nonatomic, retain) IBOutlet UIView *particleView2;
@property (nonatomic, retain) IBOutlet UIView *particleView3;
@property (nonatomic, retain) IBOutlet UIView *particleView4;


@property (nonatomic, retain) IBOutlet UILabel *statusLabel;
@property (nonatomic, retain) IBOutlet UILabel *counterLabel;


- (IBAction) start:(id)sender;
- (IBAction) stop:(id)sender;
- (IBAction) reset:(id)sender;

- (void) stepPhysics;
- (IBAction) doPhysicsUpdate:(id)sender;
- (CGPoint) fromScreen:(CGPoint)p;
- (CGPoint) toScreen:(CGPoint)p;

- (void)addGestureRecognizersToPiece:(UIView *)piece;
@end
