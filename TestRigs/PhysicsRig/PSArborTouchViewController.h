//
//  PSArborTouchViewController.h
//  PSArborTouch - Physics Test / Debug Rig
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <dispatch/dispatch.h>


@class ATPhysics;
@class ATParticle;
@class ATSpring;

@class ATPhysicsDebugView;


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
    ATPhysicsDebugView *_viewPort;
    UIView *_particleView1;
    UIView *_particleView2;
    UIView *_particleView3;
    UIView *_particleView4;
    UILabel *_statusLabel;
    UILabel *_counterLabel;
    UISwitch *_barnesHutSwitch;
    UILabel *_maxLabel;
    UILabel *_meanLabel;
    UILabel *_countLabel;
}

@property (nonatomic, strong) IBOutlet UILabel *maxLabel;
@property (nonatomic, strong) IBOutlet UILabel *meanLabel;
@property (nonatomic, strong) IBOutlet UILabel *countLabel;
@property (nonatomic, strong) IBOutlet UILabel *sumLabel;

@property (nonatomic, strong) IBOutlet UILabel *p1Name;
@property (nonatomic, strong) IBOutlet UILabel *p1Mass;
@property (nonatomic, strong) IBOutlet UILabel *p1Position;
@property (nonatomic, strong) IBOutlet UILabel *p1Fixed;

@property (nonatomic, strong) IBOutlet UILabel *p2Name;
@property (nonatomic, strong) IBOutlet UILabel *p2Mass;
@property (nonatomic, strong) IBOutlet UILabel *p2Position;
@property (nonatomic, strong) IBOutlet UILabel *p2Fixed;

@property (nonatomic, strong) IBOutlet UIView *particleView1;
@property (nonatomic, strong) IBOutlet UIView *particleView2;
@property (nonatomic, strong) IBOutlet UIView *particleView3;
@property (nonatomic, strong) IBOutlet UIView *particleView4;

@property (nonatomic, strong) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) IBOutlet UILabel *counterLabel;

@property (nonatomic, strong) IBOutlet UISwitch *barnesHutSwitch;

@property (nonatomic, strong) IBOutlet ATPhysicsDebugView *viewPort;

@end
