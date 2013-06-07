//
//  ViewController.m
//  CATransform3DDemo
//
//  Created by Daniate on 13-6-6.
//  Copyright (c) 2013年 ChinaEBI. All rights reserved.
//

#import "ViewController.h"
#define kRandomFloatNumber ((arc4random()%255+1)/255.0f)
#define kRandomColor [UIColor colorWithRed:kRandomFloatNumber green:kRandomFloatNumber blue:kRandomFloatNumber alpha:1.0f]
#define kBorderWidth (25.0f)
#define kOpacity (0.7f)
#define kDistance (300.0f)
#define kCornerRadius (20.0f)

@interface ViewController ()
@property (nonatomic, retain) CATransformLayer *layer;
@end

@implementation ViewController

- (void)dealloc {
	[_layer removeFromSuperlayer];
	[_layer release];
	
	[super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	self.layer = [CATransformLayer layer];
	self.layer.bounds = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
	self.layer.position = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
	
	[self.view.layer addSublayer:self.layer];
	
	CGRect rect = CGRectMake(0, 0, 2*kDistance/3, 2*kDistance/3);
	CGPoint p = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
	
	// 前面(front)
	CALayer *sublayer1 = [CALayer layer];
	sublayer1.cornerRadius = kCornerRadius;
	sublayer1.borderWidth = kBorderWidth;
	sublayer1.borderColor = kRandomColor.CGColor;
	sublayer1.opacity = kOpacity;
	sublayer1.backgroundColor = kRandomColor.CGColor;
	sublayer1.bounds = rect;
	sublayer1.position = p;
	CATransform3D t3d1 = CATransform3DIdentity;
	t3d1 = CATransform3DTranslate(t3d1, 0, 0, kDistance/3);
	sublayer1.transform = t3d1;
	// 后面(back)
	CALayer *sublayer2 = [CALayer layer];
	sublayer2.cornerRadius = kCornerRadius;
	sublayer2.borderWidth = kBorderWidth;
	sublayer2.borderColor = kRandomColor.CGColor;
	sublayer2.opacity = kOpacity;
	sublayer2.backgroundColor = kRandomColor.CGColor;
	sublayer2.bounds = rect;
	sublayer2.position = p;
	CATransform3D t3d2 = CATransform3DIdentity;
	t3d2 = CATransform3DTranslate(t3d2, 0, 0, -kDistance/3);
	sublayer2.transform = t3d2;
	// 左面(left)
	CALayer *sublayer3 = [CALayer layer];
	sublayer3.cornerRadius = kCornerRadius;
	sublayer3.borderWidth = kBorderWidth;
	sublayer3.borderColor = kRandomColor.CGColor;
	sublayer3.opacity = kOpacity;
	sublayer3.backgroundColor = kRandomColor.CGColor;
	sublayer3.bounds = rect;
	sublayer3.position = p;
	CATransform3D t3d3 = CATransform3DIdentity;
	t3d3 = CATransform3DTranslate(t3d3, -kDistance/3, 0, 0);
	t3d3 = CATransform3DRotate(t3d3, M_PI_2, 0, -1, 0);
	sublayer3.transform = t3d3;
	// 右面(right)
	CALayer *sublayer4 = [CALayer layer];
	sublayer4.cornerRadius = kCornerRadius;
	sublayer4.borderWidth = kBorderWidth;
	sublayer4.borderColor = kRandomColor.CGColor;
	sublayer4.opacity = kOpacity;
	sublayer4.backgroundColor = kRandomColor.CGColor;
	sublayer4.bounds = rect;
	sublayer4.position = p;
	CATransform3D t3d4 = CATransform3DIdentity;
	t3d4 = CATransform3DTranslate(t3d4, kDistance/3, 0, 0);
	t3d4 = CATransform3DRotate(t3d4, M_PI_2, 0, -1, 0);
	sublayer4.transform = t3d4;
	
	[self.layer addSublayer:sublayer1];
	[self.layer addSublayer:sublayer2];
	[self.layer addSublayer:sublayer3];
	[self.layer addSublayer:sublayer4];
	
	CATransform3D t3d = CATransform3DIdentity;
	t3d.m34 = -1.0f/kDistance;
	self.layer.transform = t3d;
	
	CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(rotate)];
	[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)rotate {
	self.layer.transform = CATransform3DRotate(self.layer.transform, 0.02f, 0, 1, 0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
