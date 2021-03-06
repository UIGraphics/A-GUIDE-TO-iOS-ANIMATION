//
//  ViewController.m
//  DynamicActionBlockDemo
//
//  Created by Kitten Yang on 9/27/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong,nonatomic) UIDynamicAnimator *animator;
@property (strong,nonatomic) UIGravityBehavior *panGravity;
@property (strong,nonatomic) UIGravityBehavior *viewsGravity;
@property (strong,nonatomic) CAShapeLayer *layer;
@property (strong,nonatomic) UIView *panView;
@property (strong,nonatomic) UIImageView *ballImageView;;
@property (strong,nonatomic) UIView *middleView;
@property (strong,nonatomic) UIView *topView;
@property (strong,nonatomic) UIView *bottomView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _panView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height/2)];
    [_panView setAlpha:0.5];
    [self.view addSubview:_panView];
    [_panView.layer setShadowOffset:CGSizeMake(-1, 2)];
    [_panView.layer setShadowOpacity:0.5];
    [_panView.layer setShadowRadius:5.0];
    [_panView.layer setShadowColor:[UIColor blackColor].CGColor];
    [_panView.layer setMasksToBounds:NO];
    [_panView.layer setShadowPath:[UIBezierPath bezierPathWithRect:_panView.bounds].CGPath];
    
    
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(PanTheView:)];
    [_panView addGestureRecognizer:pan];
    
    
    CAGradientLayer *grd=[[CAGradientLayer alloc] init];
    [grd setFrame:_panView.frame];
    grd.colors = [[NSArray alloc] initWithObjects:(__bridge id)([UIColor colorWithRed:0.0 green:191.0/255.0 blue:255.0/255.0 alpha:1].CGColor),(__bridge id)([UIColor whiteColor].CGColor), nil];
    [_panView.layer addSublayer:grd];
    
    
    
    _ballImageView=[[UIImageView alloc] initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width/2)-30, [[UIScreen mainScreen] bounds].size.height/1.5, 60, 60)];
    
    [_ballImageView setImage:[UIImage imageNamed:@"ball"]];
    [self.view addSubview:_ballImageView];
    [_ballImageView.layer setShadowOffset:CGSizeMake(-4, 4)];
    [_ballImageView.layer setShadowOpacity:0.5];
    [_ballImageView.layer setShadowRadius:5.0];
    [_ballImageView.layer setShadowColor:[UIColor blackColor].CGColor];
    [_ballImageView.layer setMasksToBounds:NO];
    
    
    //1
    _middleView = [[UIView alloc] initWithFrame:CGRectMake(_ballImageView.center.x-15, 200, 30, 30)];
    [_middleView setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:_middleView];
    [_middleView setCenter:CGPointMake(_middleView.center.x, (_ballImageView.center.y-_panView.center.y)+15)];
    
    //2
    _topView = [[UIView alloc] initWithFrame:CGRectMake(_ballImageView.center.x-15, 200, 30, 30)];
    [_topView setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:_topView];
    [_topView setCenter:CGPointMake(_topView.center.x, (_middleView.center.y-_panView.center.y)+_panView.center.y/2)];
    
    
    //3
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(_ballImageView.center.x-15, 200, 30, 30)];
    [_bottomView setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:_bottomView];
    [_bottomView setCenter:CGPointMake(_bottomView.center.x, (_middleView.center.y-_panView.center.y)+_panView.center.y*1.5)];
    
    [self setUpBehaviors];
    

}

-(void)setUpBehaviors{
    
    
    _animator=[[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    _panGravity=[[UIGravityBehavior alloc] initWithItems:@[_panView]];
    [_animator addBehavior:_panGravity];
    
    _viewsGravity=[[UIGravityBehavior alloc] initWithItems:@[_ballImageView,_topView,_bottomView]];
    [_animator addBehavior:_viewsGravity];
    
    __weak ViewController *weakSelf = self;
    
    _viewsGravity.action=^{
        
        NSLog(@"acting");
        UIBezierPath *path=[[UIBezierPath alloc] init];
        [path moveToPoint:weakSelf.panView.center];
        [path addCurveToPoint:weakSelf.ballImageView.center controlPoint1:weakSelf.topView.center controlPoint2:weakSelf.bottomView.center];
        
        if (!weakSelf.layer) {
            weakSelf.layer=[[CAShapeLayer alloc] init];
            weakSelf.layer.fillColor = [UIColor clearColor].CGColor;
            weakSelf.layer.strokeColor = [UIColor colorWithRed:224.0/255.0 green:0.0/255.0 blue:35.0/255.0 alpha:1.0].CGColor;
            weakSelf.layer.lineWidth = 5.0;
            
            //Shadow
            [weakSelf.layer setShadowOffset:CGSizeMake(-1, 2)];
            [weakSelf.layer setShadowOpacity:0.5];
            [weakSelf.layer setShadowRadius:5.0];
            [weakSelf.layer setShadowColor:[UIColor blackColor].CGColor];
            [weakSelf.layer setMasksToBounds:NO];
            
            [weakSelf.view.layer insertSublayer:weakSelf.layer below:weakSelf.ballImageView.layer];
            
        }
        
        weakSelf.layer.path=path.CGPath;
        
    };
    
    //UICollisionBehavior
    UICollisionBehavior *Collision=[[UICollisionBehavior alloc] initWithItems:@[_panView]];
    [Collision addBoundaryWithIdentifier:@"Left" fromPoint:CGPointMake(-1, 0) toPoint:CGPointMake(-1, [[UIScreen mainScreen] bounds].size.height)];
    [Collision addBoundaryWithIdentifier:@"Right" fromPoint:CGPointMake([[UIScreen mainScreen] bounds].size.width+1,0) toPoint:CGPointMake([[UIScreen mainScreen] bounds].size.width+1, [[UIScreen mainScreen] bounds].size.height)];
    [Collision addBoundaryWithIdentifier:@"Middle" fromPoint:CGPointMake(0, [[UIScreen mainScreen] bounds].size.height/2) toPoint:CGPointMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height/2)];
    [_animator addBehavior:Collision];
    
    
    //3 UIAttachmentBehaviors
    UIAttachmentBehavior *attach1=[[UIAttachmentBehavior alloc]initWithItem:_panView attachedToItem:_topView];
    [_animator addBehavior:attach1];
    
    UIAttachmentBehavior *attach2=[[UIAttachmentBehavior alloc] initWithItem:_topView attachedToItem:_bottomView];
    [_animator addBehavior:attach2];
    
    
    UIAttachmentBehavior *attach3=[[UIAttachmentBehavior alloc] initWithItem:_bottomView offsetFromCenter:UIOffsetMake(0, 0) attachedToItem:_ballImageView offsetFromCenter:UIOffsetMake(0, -_ballImageView.bounds.size.height/2)];
    [_animator addBehavior:attach3];
    
    //UIDynamicItemBehavior
    UIDynamicItemBehavior *PanItem=[[UIDynamicItemBehavior alloc] initWithItems:@[_panView,_topView,_bottomView,_ballImageView]];
    PanItem.elasticity=0.5;
    [_animator addBehavior:PanItem];
    
    
}


-(void)PanTheView:(UIPanGestureRecognizer *)pan{
    
    
    CGPoint translation = [pan translationInView:pan.view];
    
    if (!(pan.view.center.y+ translation.y>([[UIScreen mainScreen] bounds].size.height/2)-(pan.view.bounds.size.height/2))) {
        
        pan.view.center=CGPointMake(pan.view.center.x, pan.view.center.y+ translation.y);
        
        [pan setTranslation:CGPointMake(0, 0) inView:pan.view];
        
    }
    
    
    if (pan.state==UIGestureRecognizerStateBegan) {
        
        [_animator removeBehavior:_panGravity];
        
    }
    else if (pan.state==UIGestureRecognizerStateChanged){
        
        
        
    }
    else if (pan.state==UIGestureRecognizerStateEnded) {
        
        [_animator addBehavior:_panGravity];
        
    }
    
    
    
    [_animator updateItemUsingCurrentState:pan.view];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
