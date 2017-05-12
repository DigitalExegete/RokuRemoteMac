//
//  RokuRemoteCrosshairView.m
//
//  Code generated using QuartzCode 1.55.0 on 5/9/17.
//  www.quartzcodeapp.com
//

#import "RokuRemoteCrosshairView.h"
#import "RokuRemoteNetworkInterface.h"
#import "QCMethod.h"

NSString * const kRokuRemoteActionKey = @"rokuAction";

@interface RokuRemoteCrosshairView ()

@property (nonatomic, strong) NSMutableDictionary * layers;
@property (nonatomic, strong) NSMapTable * completionBlocks;
@property (nonatomic, assign) BOOL  updateLayerValueForCompletedAnimation;



@end

@implementation RokuRemoteCrosshairView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self setupProperties];
		[self setupLayers];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		[self setupProperties];
		[self setupLayers];
	}
	return self;
}



- (void)setupProperties{
	self.completionBlocks = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsOpaqueMemory valueOptions:NSPointerFunctionsStrongMemory];;
	self.layers = [NSMutableDictionary dictionary];
	
}

- (void)setupLayers{
	[self setWantsLayer:YES];
	
	CALayer * RokuCrossLayer = [CALayer layer];
	RokuCrossLayer.frame = CGRectMake(0, 0, 350, 350);
	RokuCrossLayer.sublayerTransform = CATransform3DConcat(CATransform3DMakeScale(0.714285, 0.714285, 1), CATransform3DMakeTranslation(-49.5, -49.5, 1));

	[self.layer addSublayer:RokuCrossLayer];
	self.layers[@"RokuCrossLayer"] = RokuCrossLayer;
	{
		CALayer * Group = [CALayer layer];
		Group.frame = CGRectMake(49.5, 49.5, 251, 251);
		[RokuCrossLayer addSublayer:Group];
		self.layers[@"Group"] = Group;
		{
			CAShapeLayer * path = [CAShapeLayer layer];
			path.frame = CGRectMake(0, 0, 251, 251);
			path.path = [self pathPath].quartzPath;
			[Group addSublayer:path];
			self.layers[@"path"] = path;
			CAShapeLayer * oval = [CAShapeLayer layer];
			oval.frame = CGRectMake(82, 82, 87, 87);
			oval.path = [self ovalPath].quartzPath;
			CAGradientLayer * ovalGradient = [CAGradientLayer layer];
			[oval addSublayer:ovalGradient];
			[Group addSublayer:oval];
			self.layers[@"oval"] = oval;
			self.layers[@"ovalGradient"] = ovalGradient;
			CATextLayer * text = [CATextLayer layer];
			text.frame = CGRectMake(100, 111.23, 50.99, 28.53);
			[Group addSublayer:text];
			self.layers[@"text"] = text;
		}
		
		CALayer * okayButtonLayer = [CALayer layer];
		okayButtonLayer.frame = CGRectMake(129.9, 130.44, 89.51, 89.48);
		[RokuCrossLayer addSublayer:okayButtonLayer];
		self.layers[@"okayButtonLayer"] = okayButtonLayer;
		[okayButtonLayer setValue:@(RokuRemoteOkay) forKey:kRokuRemoteActionKey];
		[okayButtonLayer setName:@"okayButtonLayer"];
		
		CALayer * leftArrowLayer = [CALayer layer];
		leftArrowLayer.frame = CGRectMake(48.4, 127.89, 82.15, 93.87);
		[leftArrowLayer setValue:@(RokuRemoteLeft) forKey:kRokuRemoteActionKey];
		[leftArrowLayer setName:@"leftArrowLayer"];
		[RokuCrossLayer addSublayer:leftArrowLayer];
		
		self.layers[@"leftArrowLayer"] = leftArrowLayer;
		{
			CAShapeLayer * text2 = [CAShapeLayer layer];
			[text2 setValue:@(RokuRemoteLeft) forKey:kRokuRemoteActionKey];
			text2.frame = CGRectMake(16.1, 19.44, 23.53, 55.35);
			text2.path = [self text2Path].quartzPath;
			[leftArrowLayer addSublayer:text2];
			self.layers[@"text2"] = text2;
		}
		
		CALayer * rightArrowLayer = [CALayer layer];
		rightArrowLayer.frame = CGRectMake(219, 128.06, 82.15, 93.87);
		[RokuCrossLayer addSublayer:rightArrowLayer];
		[rightArrowLayer setValue:@(RokuRemoteRight) forKey:kRokuRemoteActionKey];
		[rightArrowLayer setName:@"rightArrowLayer"];
		self.layers[@"rightArrowLayer"] = rightArrowLayer;
		{
			CAShapeLayer * text5 = [CAShapeLayer layer];
			[text5 setValue:@(RokuRemoteRight) forKey:kRokuRemoteActionKey];
			text5.frame = CGRectMake(47.72, 19.36, 23.53, 55.35);
			text5.path = [self text5Path].quartzPath;
			[rightArrowLayer addSublayer:text5];
			self.layers[@"text5"] = text5;
		}
		
		CALayer * upArrowLayer = [CALayer layer];
		upArrowLayer.frame = CGRectMake(127.91, 221.94, 94.19, 79.4);
		[upArrowLayer setValue:@(RokuRemoteUp) forKey:kRokuRemoteActionKey];

		[RokuCrossLayer addSublayer:upArrowLayer];
		self.layers[@"upArrowLayer"] = upArrowLayer;
		{
			CAShapeLayer * text6 = [CAShapeLayer layer];
			text6.frame = CGRectMake(35.33, 27.66, 23.53, 55.35);
			text6.path = [self text6Path].quartzPath;
			[upArrowLayer addSublayer:text6];
			self.layers[@"text6"] = text6;
		}
		
		CALayer * downArrowLayer = [CALayer layer];
		downArrowLayer.frame = CGRectMake(127.91, 48.66, 94.19, 79.23);
		[RokuCrossLayer addSublayer:downArrowLayer];
		self.layers[@"downArrowLayer"] = downArrowLayer;
		{
			CAShapeLayer * text7 = [CAShapeLayer layer];
			text7.frame = CGRectMake(35.33, -2.16, 23.53, 55.35);
			text7.path = [self text7Path].quartzPath;
			[downArrowLayer addSublayer:text7];
			self.layers[@"text7"] = text7;
		}
		
	}
	
	
	CAShapeLayer * path2 = [CAShapeLayer layer];
	path2.frame = CGRectMake(0, 0, 0, 0);
	path2.path = [self path2Path].quartzPath;
	[self.layer addSublayer:path2];
	self.layers[@"path2"] = path2;
	
	[self resetLayerPropertiesForLayerIdentifiers:nil];
}

- (void)resetLayerPropertiesForLayerIdentifiers:(NSArray *)layerIds{
	[CATransaction begin];
	[CATransaction setDisableActions:YES];
	
	if(!layerIds || [layerIds containsObject:@"RokuCrossLayer"]){
		CALayer * RokuCrossLayer = self.layers[@"RokuCrossLayer"];
		RokuCrossLayer.backgroundColor = [NSColor colorWithRed:1 green: 1 blue:1 alpha:0].CGColor;
	}
	if(!layerIds || [layerIds containsObject:@"path"]){
		CAShapeLayer * path = self.layers[@"path"];
		path.fillRule    = kCAFillRuleEvenOdd;
		path.fillColor   = [NSColor colorWithRed:0.922 green: 0.922 blue:0.922 alpha:1].CGColor;
		path.strokeColor = [NSColor colorWithRed:0.702 green: 0.702 blue:0.702 alpha:1].CGColor;
	}
	if(!layerIds || [layerIds containsObject:@"oval"]){
		CAShapeLayer * oval = self.layers[@"oval"];
		oval.fillColor                  = nil;
		oval.strokeColor                = [NSColor colorWithRed:0.329 green: 0.329 blue:0.329 alpha:1].CGColor;
		
		CAGradientLayer * ovalGradient = self.layers[@"ovalGradient"];
		CAShapeLayer * ovalMask         = [CAShapeLayer layer];
		ovalMask.path                   = oval.path;
		ovalGradient.mask               = ovalMask;
		ovalGradient.frame              = oval.bounds;
		ovalGradient.colors             = @[(id)[NSColor colorWithRed:0.8 green: 0.8 blue:0.8 alpha:1].CGColor, (id)[NSColor whiteColor].CGColor];
		ovalGradient.startPoint         = CGPointMake(0.5, 0);
		ovalGradient.endPoint           = CGPointMake(0.5, 1);
	}
	if(!layerIds || [layerIds containsObject:@"text"]){
		CATextLayer * text = self.layers[@"text"];
		text.contentsScale   = [[NSScreen mainScreen] backingScaleFactor];
		text.string          = @"OK";
		text.font            = (__bridge CFTypeRef)@"HelveticaNeue";
		text.fontSize        = 25;
		text.alignmentMode   = kCAAlignmentCenter;
		text.foregroundColor = [NSColor blackColor].CGColor;
	}
	if(!layerIds || [layerIds containsObject:@"okayButtonLayer"]){
		CALayer * okayButtonLayer = self.layers[@"okayButtonLayer"];
		okayButtonLayer.backgroundColor = [NSColor colorWithRed:1 green: 1 blue:1 alpha:0.05].CGColor;
	}
	if(!layerIds || [layerIds containsObject:@"leftArrowLayer"]){
		CALayer * leftArrowLayer = self.layers[@"leftArrowLayer"];
		leftArrowLayer.backgroundColor = [NSColor colorWithRed:1 green: 1 blue:1 alpha:0.05].CGColor;
	}
	if(!layerIds || [layerIds containsObject:@"text2"]){
		CAShapeLayer * text2 = self.layers[@"text2"];
		text2.strokeColor = [NSColor colorWithRed:0.329 green: 0.329 blue:0.329 alpha:1].CGColor;
	}
	if(!layerIds || [layerIds containsObject:@"rightArrowLayer"]){
		CALayer * rightArrowLayer = self.layers[@"rightArrowLayer"];
		rightArrowLayer.backgroundColor = [NSColor colorWithRed:1 green: 1 blue:1 alpha:0.05].CGColor;
	}
	if(!layerIds || [layerIds containsObject:@"text5"]){
		CAShapeLayer * text5 = self.layers[@"text5"];
		[text5 setValue:@(179.55 * M_PI/180) forKeyPath:@"transform.rotation"];
		text5.strokeColor = [NSColor colorWithRed:0.329 green: 0.329 blue:0.329 alpha:1].CGColor;
	}
	if(!layerIds || [layerIds containsObject:@"upArrowLayer"]){
		CALayer * upArrowLayer = self.layers[@"upArrowLayer"];
		upArrowLayer.backgroundColor = [NSColor colorWithRed:1 green: 1 blue:1 alpha:0.025].CGColor;
	}
	if(!layerIds || [layerIds containsObject:@"text6"]){
		CAShapeLayer * text6 = self.layers[@"text6"];
		[text6 setValue:@(-90 * M_PI/180) forKeyPath:@"transform.rotation"];
		text6.strokeColor = [NSColor colorWithRed:0.329 green: 0.329 blue:0.329 alpha:1].CGColor;
	}
	if(!layerIds || [layerIds containsObject:@"downArrowLayer"]){
		CALayer * downArrowLayer = self.layers[@"downArrowLayer"];
		downArrowLayer.backgroundColor = [NSColor colorWithRed:1 green: 1 blue:1 alpha:0.025].CGColor;
	}
	if(!layerIds || [layerIds containsObject:@"text7"]){
		CAShapeLayer * text7 = self.layers[@"text7"];
		[text7 setValue:@(90 * M_PI/180) forKeyPath:@"transform.rotation"];
		text7.strokeColor = [NSColor colorWithRed:0.329 green: 0.329 blue:0.329 alpha:1].CGColor;
	}
	if(!layerIds || [layerIds containsObject:@"path2"]){
		CAShapeLayer * path2 = self.layers[@"path2"];
		path2.fillColor   = nil;
		path2.strokeColor = [NSColor blackColor].CGColor;
	}
	
	[CATransaction commit];
}



#pragma mark - Animation Cleanup

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
	void (^completionBlock)(BOOL) = [self.completionBlocks objectForKey:anim];;
	if (completionBlock){
		[self.completionBlocks removeObjectForKey:anim];
		if ((flag && self.updateLayerValueForCompletedAnimation) || [[anim valueForKey:@"needEndAnim"] boolValue]){
			[self updateLayerValuesForAnimationId:[anim valueForKey:@"animId"]];
			[self removeAnimationsForAnimationId:[anim valueForKey:@"animId"]];
		}
		completionBlock(flag);
	}
}

- (void)updateLayerValuesForAnimationId:(NSString *)identifier{
	
}

- (void)removeAnimationsForAnimationId:(NSString *)identifier{
	
}

- (void)removeAllAnimations{
	[self.layers enumerateKeysAndObjectsUsingBlock:^(id key, CALayer *layer, BOOL *stop) {
		[layer removeAllAnimations];
	}];
}

#pragma mark - Bezier Path

- (NSBezierPath*)pathPath{
	NSBezierPath *pathPath = [NSBezierPath bezierPath];
	[pathPath moveToPoint:CGPointMake(80.723, 170.277)];
	[pathPath lineToPoint:CGPointMake(80.723, 231)];
	[pathPath curveToPoint:CGPointMake(100.723, 251) controlPoint1:CGPointMake(80.723, 242.046) controlPoint2:CGPointMake(89.677, 251)];
	[pathPath lineToPoint:CGPointMake(150.277, 251)];
	[pathPath curveToPoint:CGPointMake(170.277, 231) controlPoint1:CGPointMake(161.323, 251) controlPoint2:CGPointMake(170.277, 242.046)];
	[pathPath lineToPoint:CGPointMake(170.277, 170.277)];
	[pathPath lineToPoint:CGPointMake(231, 170.277)];
	[pathPath curveToPoint:CGPointMake(251, 150.277) controlPoint1:CGPointMake(242.046, 170.277) controlPoint2:CGPointMake(251, 161.323)];
	[pathPath lineToPoint:CGPointMake(251, 100.723)];
	[pathPath curveToPoint:CGPointMake(231, 80.723) controlPoint1:CGPointMake(251, 89.677) controlPoint2:CGPointMake(242.046, 80.723)];
	[pathPath lineToPoint:CGPointMake(170.277, 80.723)];
	[pathPath lineToPoint:CGPointMake(170.277, 20)];
	[pathPath curveToPoint:CGPointMake(150.277, 0) controlPoint1:CGPointMake(170.277, 8.954) controlPoint2:CGPointMake(161.323, 0)];
	[pathPath lineToPoint:CGPointMake(100.723, 0)];
	[pathPath curveToPoint:CGPointMake(80.723, 20) controlPoint1:CGPointMake(89.677, 0) controlPoint2:CGPointMake(80.723, 8.954)];
	[pathPath lineToPoint:CGPointMake(80.723, 80.723)];
	[pathPath lineToPoint:CGPointMake(20, 80.723)];
	[pathPath curveToPoint:CGPointMake(0, 100.723) controlPoint1:CGPointMake(8.954, 80.723) controlPoint2:CGPointMake(0, 89.677)];
	[pathPath lineToPoint:CGPointMake(0, 150.277)];
	[pathPath curveToPoint:CGPointMake(20, 170.277) controlPoint1:CGPointMake(0, 161.323) controlPoint2:CGPointMake(8.954, 170.277)];
	[pathPath lineToPoint:CGPointMake(80.723, 170.277)];
	[pathPath closePath];
	[pathPath moveToPoint:CGPointMake(80.723, 170.277)];
	
	return pathPath;
}

- (NSBezierPath*)ovalPath{
	NSBezierPath * ovalPath = [NSBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 87, 87)];
	return ovalPath;
}

- (NSBezierPath*)text2Path{
	NSBezierPath *text2Path = [NSBezierPath bezierPath];
	[text2Path moveToPoint:CGPointMake(23.531, 55.347)];
	[text2Path lineToPoint:CGPointMake(23.531, 44.522)];
	[text2Path lineToPoint:CGPointMake(5.766, 27.626)];
	[text2Path lineToPoint:CGPointMake(23.531, 10.731)];
	[text2Path lineToPoint:CGPointMake(23.531, 0)];
	[text2Path lineToPoint:CGPointMake(0, 23.061)];
	[text2Path lineToPoint:CGPointMake(0, 32.333)];
	[text2Path closePath];
	[text2Path moveToPoint:CGPointMake(23.531, 55.347)];
	
	return text2Path;
}

- (NSBezierPath*)text5Path{
	NSBezierPath *text5Path = [NSBezierPath bezierPath];
	[text5Path moveToPoint:CGPointMake(23.531, 55.347)];
	[text5Path lineToPoint:CGPointMake(23.531, 44.522)];
	[text5Path lineToPoint:CGPointMake(5.766, 27.626)];
	[text5Path lineToPoint:CGPointMake(23.531, 10.731)];
	[text5Path lineToPoint:CGPointMake(23.531, 0)];
	[text5Path lineToPoint:CGPointMake(0, 23.061)];
	[text5Path lineToPoint:CGPointMake(0, 32.333)];
	[text5Path closePath];
	[text5Path moveToPoint:CGPointMake(23.531, 55.347)];
	
	return text5Path;
}

- (NSBezierPath*)text6Path{
	NSBezierPath *text6Path = [NSBezierPath bezierPath];
	[text6Path moveToPoint:CGPointMake(23.531, 55.347)];
	[text6Path lineToPoint:CGPointMake(23.531, 44.522)];
	[text6Path lineToPoint:CGPointMake(5.766, 27.626)];
	[text6Path lineToPoint:CGPointMake(23.531, 10.731)];
	[text6Path lineToPoint:CGPointMake(23.531, 0)];
	[text6Path lineToPoint:CGPointMake(0, 23.061)];
	[text6Path lineToPoint:CGPointMake(0, 32.333)];
	[text6Path closePath];
	[text6Path moveToPoint:CGPointMake(23.531, 55.347)];
	
	return text6Path;
}

- (NSBezierPath*)text7Path{
	NSBezierPath *text7Path = [NSBezierPath bezierPath];
	[text7Path moveToPoint:CGPointMake(23.531, 55.347)];
	[text7Path lineToPoint:CGPointMake(23.531, 44.522)];
	[text7Path lineToPoint:CGPointMake(5.766, 27.626)];
	[text7Path lineToPoint:CGPointMake(23.531, 10.731)];
	[text7Path lineToPoint:CGPointMake(23.531, 0)];
	[text7Path lineToPoint:CGPointMake(0, 23.061)];
	[text7Path lineToPoint:CGPointMake(0, 32.333)];
	[text7Path closePath];
	[text7Path moveToPoint:CGPointMake(23.531, 55.347)];
	
	return text7Path;
}

- (NSBezierPath*)path2Path{
	
	
	return nil;
}

- (void)prepareForInterfaceBuilder
{
	
	CALayer *crossLayer = self.layers[@"RokuCrossLayer"];
	crossLayer.sublayerTransform = CATransform3DConcat(CATransform3DMakeScale(0.714285, 0.714285, 1), CATransform3DMakeTranslation(-49.5, -49.5, 1));

	
}

@end
