//
//  ViewController.m
//  CATransform3DDemo
//
//  Created by Daniate on 13-6-6.
//  Copyright (c) 2013年 ChinaEBI. All rights reserved.
//

#import "ViewController.h"

#define kRandomFloatNumber (arc4random()%256/255.0f)
#define kRandomColor [UIColor colorWithRed:kRandomFloatNumber green:kRandomFloatNumber blue:kRandomFloatNumber alpha:1.0f]
#define kBorderWidth (25.0f)
#define kOpacity (0.7f)
#define kDistance (300.0f)
#define kCornerRadius (20.0f)

typedef NS_ENUM(NSUInteger, LayerIdentifier) {
	kLayerIdentifierFront = 0,
	kLayerIdentifierBack,
	kLayerIdentifierLeft,
	kLayerIdentifierRight,
	kLayerIdentifierCount,
};

static NSString *texts[kLayerIdentifierCount] = {@"Front", @"Back", @"Left", @"Right"};

@interface ViewController ()
@property (nonatomic, retain) CATransformLayer *layer;
@end

@implementation ViewController

- (void)dealloc {
	[super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	self.layer = [CATransformLayer layer];
	self.layer.bounds = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
	self.layer.position = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
	
	[self.view.layer addSublayer:self.layer];
	
	CGRect rect = CGRectMake(0, 0, 2*kDistance/3, 2*kDistance/3);
	CGPoint p = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
	
	for (NSUInteger i = kLayerIdentifierFront; i < kLayerIdentifierCount; i++) {
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.bounds = rect;
		label.center = p;
		label.textAlignment = NSTextAlignmentCenter;
		label.text = texts[i];
		CALayer *sublayer = label.layer;
		sublayer.cornerRadius = kCornerRadius;
		sublayer.borderWidth = kBorderWidth;
		sublayer.borderColor = kRandomColor.CGColor;
		sublayer.opacity = kOpacity;
		sublayer.backgroundColor = kRandomColor.CGColor;
		sublayer.bounds = rect;
		sublayer.position = p;
		[self.layer addSublayer:sublayer];
		
		CATransform3D t3d = CATransform3DIdentity;
		switch (i) {
			case kLayerIdentifierFront:
			{
				t3d = CATransform3DTranslate(t3d, 0, 0, kDistance/3);
				break;
			}
			case kLayerIdentifierBack:
			{
				t3d = CATransform3DTranslate(t3d, 0, 0, -kDistance/3);
				t3d = CATransform3DRotate(t3d, M_PI, 0, -1, 0);
				break;
			}
			case kLayerIdentifierLeft:
			{
				t3d = CATransform3DTranslate(t3d, -kDistance/3, 0, 0);
				t3d = CATransform3DRotate(t3d, M_PI_2, 0, -1, 0);
				break;
			}
			case kLayerIdentifierRight:
			{
				t3d = CATransform3DTranslate(t3d, kDistance/3, 0, 0);
				t3d = CATransform3DRotate(t3d, M_PI_2, 0, 1, 0);
				break;
			}
		}
		sublayer.transform = t3d;
	}
	
	CATransform3D t3d = CATransform3DIdentity;
	t3d.m34 = -1.0f/kDistance;
	
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
	animation.duration = 5.0f;
	animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
	animation.toValue = [NSValue valueWithCATransform3D:t3d];
	[self.layer addAnimation:animation forKey:@"transform"];
	
	self.layer.transform = t3d;
	
	double delayInSeconds = animation.duration + 5.0;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(rotate)];
		[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
	});
}

- (void)viewDidDisappear:(BOOL)animated {
	[_layer removeFromSuperlayer];
	[_layer release];
	_layer = nil;
	
	[super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (void)rotate {
	self.layer.transform = CATransform3DRotate(self.layer.transform, 0.02f, 0, 1, 0);
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

- (BOOL)shouldAutorotate {
	return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskPortraitUpsideDown;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
	return UIInterfaceOrientationPortrait;
}

@end
