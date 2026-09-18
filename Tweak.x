#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import <math.h>

@interface CSCoverSheetViewController : UIViewController
- (void)tmc_batteryChanged:(NSNotification *)note;
@end

// ==========================================
// HỆ THỐNG CẢNH GIỚI
// ==========================================
typedef struct {
    int majorLevel;
    NSString *realmName;
    NSString *subRealm;
} CultivationStatus;

CultivationStatus getCultivationStatus(int battery) {
    CultivationStatus status;
    if (battery < 10) { status.majorLevel = 0; status.realmName = @"CHƯA NHẬP ĐẠO"; status.subRealm = @""; }
    else if (battery <= 12) { status.majorLevel = 1; status.realmName = @"PHÀM NHÂN"; status.subRealm = (battery == 10) ? @"Sơ Kỳ" : (battery == 11) ? @"Trung Kỳ" : @"Hậu Kỳ"; }
    else if (battery <= 15) { status.majorLevel = 2; status.realmName = @"LUYỆN KHÍ"; status.subRealm = (battery == 13) ? @"Sơ Kỳ" : (battery == 14) ? @"Trung Kỳ" : @"Hậu Kỳ"; }
    else if (battery <= 20) { status.majorLevel = 3; status.realmName = @"TRÚC CƠ"; status.subRealm = (battery == 16) ? @"Sơ Kỳ" : (battery == 17) ? @"Trung Kỳ" : (battery <= 19) ? @"Hậu Kỳ" : @"Đỉnh Phong"; }
    else if (battery <= 27) { status.majorLevel = 4; status.realmName = @"KIM ĐAN"; status.subRealm = (battery <= 22) ? @"Sơ Kỳ" : (battery <= 24) ? @"Trung Kỳ" : (battery <= 26) ? @"Hậu Kỳ" : @"Đỉnh Phong"; }
    else if (battery <= 36) { status.majorLevel = 5; status.realmName = @"NGUYÊN ANH"; status.subRealm = (battery <= 29) ? @"Sơ Kỳ" : (battery <= 32) ? @"Trung Kỳ" : (battery <= 35) ? @"Hậu Kỳ" : @"Đỉnh Phong"; }
    else if (battery <= 48) { status.majorLevel = 6; status.realmName = @"HÓA THẦN"; status.subRealm = (battery <= 39) ? @"Sơ Kỳ" : (battery <= 42) ? @"Trung Kỳ" : (battery <= 47) ? @"Hậu Kỳ" : @"Đỉnh Phong"; }
    else if (battery <= 62) { status.majorLevel = 7; status.realmName = @"LUYỆN HƯ"; status.subRealm = (battery <= 52) ? @"Sơ Kỳ" : (battery <= 56) ? @"Trung Kỳ" : (battery <= 61) ? @"Hậu Kỳ" : @"Đỉnh Phong"; }
    else if (battery <= 79) { status.majorLevel = 8; status.realmName = @"ĐẠI THỪA"; status.subRealm = (battery <= 66) ? @"Sơ Kỳ" : (battery <= 71) ? @"Trung Kỳ" : (battery <= 75) ? @"Hậu Kỳ" : @"Đỉnh Phong"; }
    else if (battery <= 94) { status.majorLevel = 9; status.realmName = @"ĐỘ KIẾP"; status.subRealm = (battery <= 83) ? @"Sơ Kỳ" : (battery <= 87) ? @"Trung Kỳ" : (battery <= 91) ? @"Hậu Kỳ" : @"Đỉnh Phong"; }
    else if (battery <= 99) { status.majorLevel = 10; status.realmName = @"ĐỘ KIẾP · THIÊN KIẾP"; status.subRealm = @"Thiên Lôi Giáng Lâm"; }
    else { status.majorLevel = 11; status.realmName = @"PHI THĂNG"; status.subRealm = @"Đại Đạo Viên Mãn"; }
    return status;
}

static id tmc_qiImage = nil;
static id tmc_ascImage = nil;

@interface TMCCultivationView : UIView

@property (nonatomic, strong) UIView *backgroundLayer;
@property (nonatomic, strong) UIView *arrayContainer;
@property (nonatomic, strong) UIView *spinLayerCW;
@property (nonatomic, strong) UIView *spinLayerCCW;
@property (nonatomic, strong) CAShapeLayer *daoMarkLayer;
@property (nonatomic, strong) CAShapeLayer *monkLayer;
@property (nonatomic, strong) CAShapeLayer *robeLinesLayer;
@property (nonatomic, strong) CAShapeLayer *goldenCoreLayer;
@property (nonatomic, strong) CAShapeLayer *nascentSoulLayer;
@property (nonatomic, strong) CAShapeLayer *dharmaIdolLayer;
@property (nonatomic, strong) CAShapeLayer *cloudLayer;
@property (nonatomic, strong) CAShapeLayer *lightningLayer;
@property (nonatomic, strong) CAShapeLayer *spaceFragmentsLayer;
@property (nonatomic, strong) UIView *lawsLayer;
@property (nonatomic, strong) UIView *ascensionContainer;
@property (nonatomic, strong) CAShapeLayer *lotusBaseLayer;
@property (nonatomic, strong) CAShapeLayer *heavenlyGateLayer;
@property (nonatomic, strong) CAShapeLayer *immortalBeamLayer;
@property (nonatomic, strong) UIView *flashView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *absorbingLabel;
@property (nonatomic, assign) int lastBatteryLevel;
@property (nonatomic, assign) BOOL isBreakingThrough;
@property (nonatomic, strong) UIButton *testButton;
@property (nonatomic, strong) NSArray *testMilestones;
@property (nonatomic, assign) int testIndex;
@property (nonatomic, strong) CAEmitterLayer *qiEmitter;
@property (nonatomic, strong) CAEmitterLayer *ascensionEmitter;

- (void)addContinuousAnimations;

@end

@implementation TMCCultivationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES; 

        if (!tmc_qiImage) {
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(4,4), NO, 0);
            [[UIColor whiteColor] setFill];
            [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,4,4)] fill];
            tmc_qiImage = (id)UIGraphicsGetImageFromCurrentImageContext().CGImage;
            UIGraphicsEndImageContext();
            
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(6,6), NO, 0);
            [[UIColor colorWithRed:1.0 green:0.9 blue:0.6 alpha:1.0] setFill];
            [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,6,6)] fill];
            tmc_ascImage = (id)UIGraphicsGetImageFromCurrentImageContext().CGImage;
            UIGraphicsEndImageContext();
        }

        CGFloat centerX = frame.size.width / 2.0;
        CGFloat centerY = frame.size.height / 2.0 - 20;

        self.backgroundLayer = [[UIView alloc] initWithFrame:frame];
        self.backgroundLayer.userInteractionEnabled = NO;
        [self addSubview:self.backgroundLayer];
        
        [self drawClouds];
        [self drawMultiBranchLightning];
        [self drawSpaceFragments:CGPointMake(centerX, centerY)];

        self.flashView = [[UIView alloc] initWithFrame:frame];
        self.flashView.backgroundColor = [UIColor whiteColor];
        self.flashView.alpha = 0.0;
        self.flashView.userInteractionEnabled = NO;
        [self addSubview:self.flashView];

        self.arrayContainer = [[UIView alloc] initWithFrame:CGRectMake(centerX - 140, centerY - 140, 280, 280)];
        self.arrayContainer.userInteractionEnabled = NO;
        [self addSubview:self.arrayContainer];
        [self drawUltimateBaguaArray];

        self.nascentSoulLayer = [self createSlimMonkPathWithSize:75];
        self.nascentSoulLayer.position = CGPointMake(centerX, centerY - 70);
        self.nascentSoulLayer.fillColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
        self.nascentSoulLayer.opacity = 0.0;
        [self.layer addSublayer:self.nascentSoulLayer];

        self.dharmaIdolLayer = [self createSlimMonkPathWithSize:210];
        self.dharmaIdolLayer.position = CGPointMake(centerX, centerY - 20);
        self.dharmaIdolLayer.fillColor = [UIColor clearColor].CGColor;
        self.dharmaIdolLayer.opacity = 0.0;
        [self.layer addSublayer:self.dharmaIdolLayer];

        self.lawsLayer = [[UIView alloc] initWithFrame:CGRectMake(centerX - 120, centerY - 120, 240, 240)];
        self.lawsLayer.alpha = 0.0;
        self.lawsLayer.userInteractionEnabled = NO;
        [self addSubview:self.lawsLayer];
        [self drawLawsOrbit];

        self.ascensionContainer = [[UIView alloc] initWithFrame:frame];
        self.ascensionContainer.alpha = 0.0;
        self.ascensionContainer.userInteractionEnabled = NO;
        [self addSubview:self.ascensionContainer];
        [self drawAscensionSystem:CGPointMake(centerX, centerY)];

        self.monkLayer = [self createSlimMonkPathWithSize:150];
        self.monkLayer.position = CGPointMake(centerX, centerY);
        self.monkLayer.fillColor = [UIColor blackColor].CGColor;
        self.monkLayer.strokeColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9].CGColor;
        self.monkLayer.lineWidth = 1.5;
        self.monkLayer.lineJoin = kCALineJoinRound;
        self.monkLayer.shadowColor = [UIColor cyanColor].CGColor;
        self.monkLayer.shadowRadius = 12.0;
        self.monkLayer.shadowOpacity = 1.0;
        self.monkLayer.shadowOffset = CGSizeZero;
        [self.layer addSublayer:self.monkLayer];

        self.robeLinesLayer = [CAShapeLayer layer];
        self.robeLinesLayer.path = [self createRobeLinesPathWithSize:150].CGPath;
        self.robeLinesLayer.position = CGPointMake(centerX, centerY);
        self.robeLinesLayer.fillColor = [UIColor clearColor].CGColor;
        self.robeLinesLayer.strokeColor = [[UIColor whiteColor] colorWithAlphaComponent:0.85].CGColor;
        self.robeLinesLayer.lineWidth = 1.3;
        self.robeLinesLayer.lineCap = kCALineCapRound;
        [self.layer addSublayer:self.robeLinesLayer];

        self.goldenCoreLayer = [CAShapeLayer layer];
        self.goldenCoreLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-15, -15, 30, 30)].CGPath;
        self.goldenCoreLayer.fillColor = [UIColor colorWithRed:1.0 green:0.85 blue:0.15 alpha:1.0].CGColor;
        self.goldenCoreLayer.position = CGPointMake(centerX, centerY + 25);
        self.goldenCoreLayer.shadowColor = [UIColor yellowColor].CGColor;
        self.goldenCoreLayer.shadowRadius = 25.0;
        self.goldenCoreLayer.shadowOpacity = 1.0;
        self.goldenCoreLayer.shadowOffset = CGSizeZero;
        self.goldenCoreLayer.opacity = 0.0;
        [self.layer addSublayer:self.goldenCoreLayer];

        [self setupEmitters:CGPointMake(centerX, centerY)];

        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(centerX - 160, centerY + 145, 320, 50)];
        self.statusLabel.numberOfLines = 2;
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        self.statusLabel.textColor = [UIColor whiteColor];
        self.statusLabel.font = [UIFont boldSystemFontOfSize:18];
        self.statusLabel.layer.shadowColor = [UIColor cyanColor].CGColor;
        self.statusLabel.layer.shadowRadius = 6.0;
        self.statusLabel.layer.shadowOpacity = 1.0;
        self.statusLabel.layer.shadowOffset = CGSizeZero;
        self.statusLabel.userInteractionEnabled = NO;
        [self addSubview:self.statusLabel];

        self.absorbingLabel = [[UILabel alloc] initWithFrame:CGRectMake(centerX - 150, centerY + 200, 300, 20)];
        self.absorbingLabel.text = @"Đang hội tụ linh khí...";
        self.absorbingLabel.textAlignment = NSTextAlignmentCenter;
        self.absorbingLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.85];
        self.absorbingLabel.font = [UIFont italicSystemFontOfSize:12];
        self.absorbingLabel.userInteractionEnabled = NO;
        [self addSubview:self.absorbingLabel];

        CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"opacity"];
        pulse.fromValue = @0.4;
        pulse.toValue = @1.0;
        pulse.duration = 1.5;
        pulse.autoreverses = YES;
        pulse.repeatCount = HUGE_VALF;
        [self.absorbingLabel.layer addAnimation:pulse forKey:@"pulsingText"];

        self.testMilestones = @[@12, @15, @20, @27, @36, @48, @62, @79, @94, @99, @100];
        self.testIndex = 0;
        
        self.testButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.testButton.frame = CGRectMake(centerX - 45, frame.size.height - 120, 90, 34);
        [self.testButton setTitle:@"⚡ TEST" forState:UIControlStateNormal];
        [self.testButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        self.testButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        self.testButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
        self.testButton.layer.cornerRadius = 17;
        self.testButton.layer.borderWidth = 1.5;
        self.testButton.layer.borderColor = [UIColor yellowColor].CGColor;
        self.testButton.userInteractionEnabled = YES;
        self.testButton.exclusiveTouch = YES;
        [self.testButton addTarget:self action:@selector(handleTestTap) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.testButton];

        self.lastBatteryLevel = -1;
    }
    return self;
}

- (void)removeFromSuperview {
    [self.qiEmitter removeFromSuperlayer];
    [self.ascensionEmitter removeFromSuperlayer];
    [super removeFromSuperview];
}

- (CAShapeLayer *)createSlimMonkPathWithSize:(CGFloat)size {
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat s = size / 100.0;
    [path moveToPoint:CGPointMake(0, -50*s)];
    [path addCurveToPoint:CGPointMake(-8*s, -42*s) controlPoint1:CGPointMake(-8*s, -51*s) controlPoint2:CGPointMake(-11*s, -46*s)];
    [path addCurveToPoint:CGPointMake(-14*s, -30*s) controlPoint1:CGPointMake(-12*s, -38*s) controlPoint2:CGPointMake(-14*s, -34*s)];
    [path addCurveToPoint:CGPointMake(-9*s, -19*s) controlPoint1:CGPointMake(-14*s, -25*s) controlPoint2:CGPointMake(-11*s, -21*s)];
    [path addCurveToPoint:CGPointMake(-10*s, -15*s) controlPoint1:CGPointMake(-7*s, -18*s) controlPoint2:CGPointMake(-9*s, -16*s)];
    [path addCurveToPoint:CGPointMake(-27*s, -6*s) controlPoint1:CGPointMake(-14*s, -13*s) controlPoint2:CGPointMake(-21*s, -9*s)];
    [path addCurveToPoint:CGPointMake(-31*s, 12*s) controlPoint1:CGPointMake(-31*s, 2*s) controlPoint2:CGPointMake(-33*s, 7*s)];
    [path addCurveToPoint:CGPointMake(-29*s, 22*s) controlPoint1:CGPointMake(-32*s, 16*s) controlPoint2:CGPointMake(-32*s, 20*s)];
    [path addCurveToPoint:CGPointMake(-15*s, 26*s) controlPoint1:CGPointMake(-25*s, 26*s) controlPoint2:CGPointMake(-20*s, 27*s)];
    [path addCurveToPoint:CGPointMake(-9*s, 21*s) controlPoint1:CGPointMake(-12*s, 25*s) controlPoint2:CGPointMake(-10*s, 23*s)];
    [path addCurveToPoint:CGPointMake(-12*s, 4*s) controlPoint1:CGPointMake(-7*s, 16*s) controlPoint2:CGPointMake(-10*s, 10*s)];
    [path addCurveToPoint:CGPointMake(-15*s, -3*s) controlPoint1:CGPointMake(-13*s, 0*s) controlPoint2:CGPointMake(-14*s, -2*s)];
    [path addCurveToPoint:CGPointMake(-21*s, 14*s) controlPoint1:CGPointMake(-17*s, 3*s) controlPoint2:CGPointMake(-19*s, 8*s)];
    [path addCurveToPoint:CGPointMake(-29*s, 26*s) controlPoint1:CGPointMake(-23*s, 19*s) controlPoint2:CGPointMake(-26*s, 23*s)];
    [path addCurveToPoint:CGPointMake(-46*s, 38*s) controlPoint1:CGPointMake(-34*s, 30*s) controlPoint2:CGPointMake(-44*s, 33*s)];
    [path addCurveToPoint:CGPointMake(0, 47*s) controlPoint1:CGPointMake(-40*s, 45*s) controlPoint2:CGPointMake(-22*s, 48*s)];
    [path addCurveToPoint:CGPointMake(46*s, 38*s) controlPoint1:CGPointMake(22*s, 48*s) controlPoint2:CGPointMake(40*s, 45*s)];
    [path addCurveToPoint:CGPointMake(29*s, 26*s) controlPoint1:CGPointMake(44*s, 33*s) controlPoint2:CGPointMake(34*s, 30*s)];
    [path addCurveToPoint:CGPointMake(21*s, 14*s) controlPoint1:CGPointMake(26*s, 23*s) controlPoint2:CGPointMake(23*s, 19*s)];
    [path addCurveToPoint:CGPointMake(15*s, -3*s) controlPoint1:CGPointMake(19*s, 8*s) controlPoint2:CGPointMake(17*s, 3*s)];
    [path addCurveToPoint:CGPointMake(12*s, 4*s) controlPoint1:CGPointMake(14*s, -2*s) controlPoint2:CGPointMake(13*s, 0*s)];
    [path addCurveToPoint:CGPointMake(9*s, 21*s) controlPoint1:CGPointMake(10*s, 10*s) controlPoint2:CGPointMake(7*s, 16*s)];
    [path addCurveToPoint:CGPointMake(15*s, 26*s) controlPoint1:CGPointMake(10*s, 23*s) controlPoint2:CGPointMake(12*s, 25*s)];
    [path addCurveToPoint:CGPointMake(29*s, 22*s) controlPoint1:CGPointMake(20*s, 27*s) controlPoint2:CGPointMake(25*s, 26*s)];
    [path addCurveToPoint:CGPointMake(31*s, 12*s) controlPoint1:CGPointMake(32*s, 20*s) controlPoint2:CGPointMake(32*s, 16*s)];
    [path addCurveToPoint:CGPointMake(27*s, -6*s) controlPoint1:CGPointMake(33*s, 7*s) controlPoint2:CGPointMake(31*s, 2*s)];
    [path addCurveToPoint:CGPointMake(10*s, -15*s) controlPoint1:CGPointMake(21*s, -9*s) controlPoint2:CGPointMake(14*s, -13*s)];
    [path addCurveToPoint:CGPointMake(9*s, -19*s) controlPoint1:CGPointMake(9*s, -16*s) controlPoint2:CGPointMake(7*s, -18*s)];
    [path addCurveToPoint:CGPointMake(14*s, -30*s) controlPoint1:CGPointMake(11*s, -21*s) controlPoint2:CGPointMake(14*s, -25*s)];
    [path addCurveToPoint:CGPointMake(8*s, -42*s) controlPoint1:CGPointMake(14*s, -34*s) controlPoint2:CGPointMake(12*s, -38*s)];
    [path addCurveToPoint:CGPointMake(0, -50*s) controlPoint1:CGPointMake(11*s, -46*s) controlPoint2:CGPointMake(8*s, -51*s)];
    [path closePath];

    UIBezierPath *handL = [UIBezierPath bezierPath];
    [handL moveToPoint:CGPointMake(-15*s, 12*s)];
    [handL addCurveToPoint:CGPointMake(-10*s, 24*s) controlPoint1:CGPointMake(-17*s, 17*s) controlPoint2:CGPointMake(-13*s, 24*s)];
    [handL addCurveToPoint:CGPointMake(-7*s, 16*s) controlPoint1:CGPointMake(-8*s, 21*s) controlPoint2:CGPointMake(-6*s, 19*s)];
    [handL addCurveToPoint:CGPointMake(-12*s, 10*s) controlPoint1:CGPointMake(-9*s, 13*s) controlPoint2:CGPointMake(-10*s, 11*s)];
    [handL closePath];
    [path appendPath:handL];

    UIBezierPath *handR = [UIBezierPath bezierPath];
    [handR moveToPoint:CGPointMake(15*s, 12*s)];
    [handR addCurveToPoint:CGPointMake(10*s, 24*s) controlPoint1:CGPointMake(17*s, 17*s) controlPoint2:CGPointMake(13*s, 24*s)];
    [handR addCurveToPoint:CGPointMake(7*s, 16*s) controlPoint1:CGPointMake(8*s, 21*s) controlPoint2:CGPointMake(6*s, 19*s)];
    [handR addCurveToPoint:CGPointMake(12*s, 10*s) controlPoint1:CGPointMake(9*s, 13*s) controlPoint2:CGPointMake(10*s, 11*s)];
    [handR closePath];
    [path appendPath:handR];

    layer.path = path.CGPath;
    layer.fillRule = kCAFillRuleEvenOdd;
    return layer;
}

- (UIBezierPath *)createRobeLinesPathWithSize:(CGFloat)size {
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat s = size / 100.0;
    [path moveToPoint:CGPointMake(-10*s, -15*s)];
    [path addQuadCurveToPoint:CGPointMake(-3*s, -2*s) controlPoint:CGPointMake(-8*s, -8*s)];
    [path moveToPoint:CGPointMake(10*s, -15*s)];
    [path addQuadCurveToPoint:CGPointMake(3*s, -2*s) controlPoint:CGPointMake(8*s, -8*s)];
    [path moveToPoint:CGPointMake(-3*s, -2*s)];
    [path addLineToPoint:CGPointMake(3*s, -2*s)];
    [path moveToPoint:CGPointMake(-25*s, -3*s)];
    [path addQuadCurveToPoint:CGPointMake(-27*s, 22*s) controlPoint:CGPointMake(-29*s, 10*s)];
    [path moveToPoint:CGPointMake(-16*s, 4*s)];
    [path addQuadCurveToPoint:CGPointMake(-13*s, 20*s) controlPoint:CGPointMake(-15*s, 12*s)];
    [path moveToPoint:CGPointMake(25*s, -3*s)];
    [path addQuadCurveToPoint:CGPointMake(27*s, 22*s) controlPoint:CGPointMake(29*s, 10*s)];
    [path moveToPoint:CGPointMake(16*s, 4*s)];
    [path addQuadCurveToPoint:CGPointMake(13*s, 20*s) controlPoint:CGPointMake(15*s, 12*s)];
    [path moveToPoint:CGPointMake(-24*s, 24*s)];
    [path addQuadCurveToPoint:CGPointMake(-40*s, 35*s) controlPoint:CGPointMake(-34*s, 26*s)];
    [path moveToPoint:CGPointMake(24*s, 24*s)];
    [path addQuadCurveToPoint:CGPointMake(40*s, 35*s) controlPoint:CGPointMake(34*s, 26*s)];
    [path moveToPoint:CGPointMake(-14*s, 7*s)];
    [path addQuadCurveToPoint:CGPointMake(14*s, 7*s) controlPoint:CGPointMake(0, 11*s)];
    [path moveToPoint:CGPointMake(0, 7*s)];
    [path addLineToPoint:CGPointMake(0, 20*s)];
    return path;
}

- (void)drawUltimateBaguaArray {
    self.spinLayerCW = [[UIView alloc] initWithFrame:self.arrayContainer.bounds];
    self.spinLayerCCW = [[UIView alloc] initWithFrame:self.arrayContainer.bounds];
    [self.arrayContainer addSubview:self.spinLayerCW];
    [self.arrayContainer addSubview:self.spinLayerCCW];

    CAShapeLayer *outerThick = [CAShapeLayer layer];
    outerThick.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(10, 10, 260, 260)].CGPath;
    outerThick.fillColor = [UIColor clearColor].CGColor;
    outerThick.strokeColor = [UIColor cyanColor].CGColor;
    outerThick.lineWidth = 3.0;
    [self.spinLayerCW.layer addSublayer:outerThick];

    NSArray *bagua = @[@"☰", @"☱", @"☲", @"☳", @"☴", @"☵", @"☶", @"☷"];
    for (int i = 0; i < 8; i++) {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        lbl.center = CGPointMake(140, 140);
        lbl.text = bagua[i];
        lbl.textColor = [UIColor cyanColor];
        lbl.font = [UIFont boldSystemFontOfSize:20];
        lbl.textAlignment = NSTextAlignmentCenter;
        CGAffineTransform t = CGAffineTransformMakeRotation(i * (M_PI / 4.0));
        t = CGAffineTransformTranslate(t, 0, -112);
        lbl.transform = t;
        [self.spinLayerCW addSubview:lbl];
    }

    CAShapeLayer *starLayer = [CAShapeLayer layer];
    UIBezierPath *starPath = [UIBezierPath bezierPath];
    for (int i=0; i<3; i++) {
        UIBezierPath *sq = [UIBezierPath bezierPathWithRect:CGRectMake(50, 50, 180, 180)];
        [sq applyTransform:CGAffineTransformMakeTranslation(-140, -140)];
        [sq applyTransform:CGAffineTransformMakeRotation(i * (M_PI / 6.0))];
        [sq applyTransform:CGAffineTransformMakeTranslation(140, 140)];
        [starPath appendPath:sq];
    }
    starLayer.path = starPath.CGPath;
    starLayer.fillColor = [UIColor clearColor].CGColor;
    starLayer.strokeColor = [[UIColor cyanColor] colorWithAlphaComponent:0.6].CGColor;
    starLayer.lineWidth = 1.0;
    [self.spinLayerCCW.layer addSublayer:starLayer];

    self.daoMarkLayer = [CAShapeLayer layer];
    self.daoMarkLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(70, 70, 140, 140)].CGPath;
    self.daoMarkLayer.fillColor = [UIColor clearColor].CGColor;
    self.daoMarkLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.daoMarkLayer.lineWidth = 2.0;
    self.daoMarkLayer.lineDashPattern = @[@4, @12];
    self.daoMarkLayer.opacity = 0.0;
    [self.spinLayerCCW.layer addSublayer:self.daoMarkLayer];
}

- (void)drawClouds {
    self.cloudLayer = [CAShapeLayer layer];
    UIBezierPath *cloudPath = [UIBezierPath bezierPath];
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    [cloudPath addArcWithCenter:CGPointMake(-20, 40) radius:70 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    [cloudPath addArcWithCenter:CGPointMake(w/4, 20) radius:90 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    [cloudPath addArcWithCenter:CGPointMake(w/2, 50) radius:100 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    [cloudPath addArcWithCenter:CGPointMake(3*w/4, 10) radius:80 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    [cloudPath addArcWithCenter:CGPointMake(w+20, 50) radius:70 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    self.cloudLayer.path = cloudPath.CGPath;
    self.cloudLayer.fillColor = [[UIColor blackColor] colorWithAlphaComponent:0.9].CGColor;
    self.cloudLayer.opacity = 0.0;
    [self.backgroundLayer.layer addSublayer:self.cloudLayer];
}

- (void)drawMultiBranchLightning {
    self.lightningLayer = [CAShapeLayer layer];
    self.lightningLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.lightningLayer.fillColor = [UIColor clearColor].CGColor;
    self.lightningLayer.lineWidth = 4.0;
    self.lightningLayer.shadowColor = [UIColor cyanColor].CGColor;
    self.lightningLayer.shadowRadius = 20.0;
    self.lightningLayer.shadowOpacity = 1.0;
    self.lightningLayer.shadowOffset = CGSizeZero;
    self.lightningLayer.opacity = 0.0;
    self.lightningLayer.lineCap = kCALineCapRound;
    self.lightningLayer.lineJoin = kCALineJoinRound;
    [self.backgroundLayer.layer addSublayer:self.lightningLayer];
}

- (void)drawSpaceFragments:(CGPoint)center {
    self.spaceFragmentsLayer = [CAShapeLayer layer];
    self.spaceFragmentsLayer.opacity = 0.0;
    [self.backgroundLayer.layer addSublayer:self.spaceFragmentsLayer];
}

- (void)drawLawsOrbit {
    NSArray *laws = @[@"Luân", @"Hồi", @"Sinh", @"Diệt", @"Đạo", @"Hư", @"Pháp", @"Tắc"];
    for (int i = 0; i < laws.count; i++) {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        lbl.center = CGPointMake(120, 120);
        lbl.text = laws[i];
        lbl.textColor = [UIColor redColor];
        lbl.font = [UIFont boldSystemFontOfSize:16];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.layer.shadowColor = [UIColor redColor].CGColor;
        lbl.layer.shadowRadius = 6.0;
        lbl.layer.shadowOpacity = 1.0;
        lbl.layer.shadowOffset = CGSizeZero;
        CGAffineTransform t = CGAffineTransformMakeRotation(i * (M_PI * 2 / laws.count));
        t = CGAffineTransformTranslate(t, 0, -100);
        lbl.transform = t;
        [self.lawsLayer addSubview:lbl];
    }
}

- (void)drawAscensionSystem:(CGPoint)center {
    CGFloat gw = [UIScreen mainScreen].bounds.size.width;

    self.heavenlyGateLayer = [CAShapeLayer layer];
    UIBezierPath *gatePath = [UIBezierPath bezierPath];
    [gatePath appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(gw/2 - 70, 50, 15, 100)]];
    [gatePath appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(gw/2 + 55, 50, 15, 100)]];
    [gatePath appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(gw/2 - 85, 150, 170, 10)]];
    [gatePath moveToPoint:CGPointMake(gw/2 - 90, 50)];
    [gatePath addQuadCurveToPoint:CGPointMake(gw/2 + 90, 50) controlPoint:CGPointMake(gw/2, -10)];
    [gatePath addQuadCurveToPoint:CGPointMake(gw/2 - 90, 50) controlPoint:CGPointMake(gw/2, 20)];
    self.heavenlyGateLayer.path = gatePath.CGPath;
    self.heavenlyGateLayer.fillColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
    self.heavenlyGateLayer.shadowColor = [UIColor whiteColor].CGColor;
    self.heavenlyGateLayer.shadowRadius = 20.0;
    self.heavenlyGateLayer.shadowOpacity = 1.0;
    self.heavenlyGateLayer.shadowOffset = CGSizeZero;
    [self.ascensionContainer.layer addSublayer:self.heavenlyGateLayer];

    self.immortalBeamLayer = [CAShapeLayer layer];
    UIBezierPath *beamPath = [UIBezierPath bezierPath];
    [beamPath moveToPoint:CGPointMake(gw/2 - 50, 60)];
    [beamPath addLineToPoint:CGPointMake(gw/2 + 50, 60)];
    [beamPath addLineToPoint:CGPointMake(gw/2 + 120, center.y + 80)];
    [beamPath addLineToPoint:CGPointMake(gw/2 - 120, center.y + 80)];
    [beamPath closePath];
    self.immortalBeamLayer.path = beamPath.CGPath;
    self.immortalBeamLayer.fillColor = [[UIColor yellowColor] colorWithAlphaComponent:0.18].CGColor;
    [self.ascensionContainer.layer addSublayer:self.immortalBeamLayer];

    self.lotusBaseLayer = [CAShapeLayer layer];
    UIBezierPath *lotusPath = [UIBezierPath bezierPath];
    for(int i=-2; i<=2; i++) {
        CGFloat xOffset = i * 20;
        CGFloat yOffset = center.y + 40 + abs(i)*5;
        [lotusPath moveToPoint:CGPointMake(center.x + xOffset, yOffset)];
        [lotusPath addQuadCurveToPoint:CGPointMake(center.x + xOffset - 15, yOffset - 25) controlPoint:CGPointMake(center.x + xOffset - 20, yOffset - 10)];
        [lotusPath addQuadCurveToPoint:CGPointMake(center.x + xOffset, yOffset) controlPoint:CGPointMake(center.x + xOffset - 5, yOffset - 15)];
        [lotusPath moveToPoint:CGPointMake(center.x + xOffset, yOffset)];
        [lotusPath addQuadCurveToPoint:CGPointMake(center.x + xOffset + 15, yOffset - 25) controlPoint:CGPointMake(center.x + xOffset + 20, yOffset - 10)];
        [lotusPath addQuadCurveToPoint:CGPointMake(center.x + xOffset, yOffset) controlPoint:CGPointMake(center.x + xOffset + 5, yOffset - 15)];
    }
    self.lotusBaseLayer.path = lotusPath.CGPath;
    self.lotusBaseLayer.fillColor = [[UIColor yellowColor] colorWithAlphaComponent:0.5].CGColor;
    self.lotusBaseLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.lotusBaseLayer.lineWidth = 1.0;
    self.lotusBaseLayer.shadowColor = [UIColor yellowColor].CGColor;
    self.lotusBaseLayer.shadowRadius = 15.0;
    self.lotusBaseLayer.shadowOpacity = 1.0;
    self.lotusBaseLayer.shadowOffset = CGSizeZero;
    [self.ascensionContainer.layer addSublayer:self.lotusBaseLayer];
}

- (void)setupEmitters:(CGPoint)targetCenter {
    self.qiEmitter = [CAEmitterLayer layer];
    CGFloat radius = MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) + 50;
    self.qiEmitter.emitterPosition = targetCenter;
    self.qiEmitter.emitterSize = CGSizeMake(radius, radius);
    self.qiEmitter.emitterShape = kCAEmitterLayerCircle;
    self.qiEmitter.emitterMode = kCAEmitterLayerOutline;
    self.qiEmitter.renderMode = kCAEmitterLayerUnordered;
    [self.layer insertSublayer:self.qiEmitter below:self.arrayContainer.layer];

    CAEmitterCell *qiCell = [CAEmitterCell emitterCell];
    qiCell.name = @"qiCell";
    qiCell.contents = tmc_qiImage; 
    qiCell.birthRate = 0;
    qiCell.lifetime = 2.0;
    qiCell.velocity = -250.0;
    qiCell.velocityRange = 50.0;
    qiCell.emissionRange = M_PI * 2.0;
    qiCell.alphaSpeed = -0.4;
    qiCell.scale = 0.8;
    self.qiEmitter.emitterCells = @[qiCell];

    self.ascensionEmitter = [CAEmitterLayer layer];
    self.ascensionEmitter.emitterPosition = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height + 50);
    self.ascensionEmitter.emitterSize = CGSizeMake(self.bounds.size.width, 10);
    self.ascensionEmitter.emitterShape = kCAEmitterLayerLine;
    self.ascensionEmitter.shadowColor = [UIColor yellowColor].CGColor;
    self.ascensionEmitter.shadowRadius = 8.0;
    self.ascensionEmitter.shadowOpacity = 1.0;
    self.ascensionEmitter.shadowOffset = CGSizeZero;
    [self.layer insertSublayer:self.ascensionEmitter below:self.ascensionContainer.layer];

    CAEmitterCell *ascCell = [CAEmitterCell emitterCell];
    ascCell.name = @"ascCell";
    ascCell.contents = tmc_ascImage;
    ascCell.birthRate = 0; 
    ascCell.lifetime = 4.0;
    ascCell.velocity = -100.0; 
    ascCell.velocityRange = 30.0;
    ascCell.emissionLongitude = 0; 
    ascCell.emissionRange = M_PI_4;
    ascCell.alphaSpeed = -0.2;
    ascCell.scale = 1.0;
    ascCell.scaleRange = 0.5;
    self.ascensionEmitter.emitterCells = @[ascCell];
}

- (void)addContinuousAnimations {
    if (![self.spinLayerCW.layer animationForKey:@"spinCW"]) {
        CABasicAnimation *spin1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        spin1.toValue = @(M_PI * 2.0);
        spin1.duration = 24.0;
        spin1.repeatCount = HUGE_VALF;
        [self.spinLayerCW.layer addAnimation:spin1 forKey:@"spinCW"];
    }
    if (![self.spinLayerCCW.layer animationForKey:@"spinCCW"]) {
        CABasicAnimation *spin2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        spin2.toValue = @(-M_PI * 2.0);
        spin2.duration = 18.0;
        spin2.repeatCount = HUGE_VALF;
        [self.spinLayerCCW.layer addAnimation:spin2 forKey:@"spinCCW"];
    }
    if (![self.lawsLayer.layer animationForKey:@"orbitLaws"]) {
        CABasicAnimation *orbit = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        orbit.toValue = @(M_PI * 2.0);
        orbit.duration = 10.0;
        orbit.repeatCount = HUGE_VALF;
        [self.lawsLayer.layer addAnimation:orbit forKey:@"orbitLaws"];
    }
}

// ==========================================
// APPLY REALM EFFECTS
// ==========================================
- (void)applyRealmEffects:(int)majorLevel {
    UIColor *auraColor = [UIColor clearColor];
    float qiBirthRate = 0;
    float ascBirthRate = 0;
    float qiAccelY = 0;
    NSString *absorbText = @"";

    [CATransaction begin];
    [CATransaction setDisableActions:YES];

    self.goldenCoreLayer.opacity = 0.0;
    self.nascentSoulLayer.opacity = 0.0;
    self.dharmaIdolLayer.opacity = 0.0;
    self.dharmaIdolLayer.transform = CATransform3DIdentity;
    self.daoMarkLayer.opacity = 0.0;
    self.cloudLayer.opacity = 0.0;
    self.spaceFragmentsLayer.opacity = 0.0;
    self.lawsLayer.alpha = 0.0;
    self.ascensionContainer.alpha = 0.0;
    self.lightningLayer.opacity = 0.0;
    self.backgroundLayer.backgroundColor = [UIColor clearColor];
    
    [self.lightningLayer removeAllAnimations];
    [self.spaceFragmentsLayer removeAllAnimations];
    [self.goldenCoreLayer removeAllAnimations];
    [self.nascentSoulLayer removeAllAnimations];
    [self.dharmaIdolLayer removeAllAnimations];
    [self.monkLayer removeAllAnimations];

    self.arrayContainer.alpha = 1.0;
    self.arrayContainer.transform = CGAffineTransformIdentity;
    self.monkLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2 - 20);
    self.robeLinesLayer.position = self.monkLayer.position;
    
    NSMutableArray *toRemove = [NSMutableArray array];
    for (CALayer *l in self.layer.sublayers) {
        if ([l.name hasPrefix:@"halo"]) [toRemove addObject:l];
    }
    for (CALayer *l in toRemove) [l removeFromSuperlayer];

    self.monkLayer.strokeColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9].CGColor;
    self.robeLinesLayer.strokeColor = [[UIColor whiteColor] colorWithAlphaComponent:0.85].CGColor;
    self.monkLayer.shadowColor = [UIColor cyanColor].CGColor;

    for (UIView *v in self.lawsLayer.subviews) {
        if ([v isKindOfClass:[UILabel class]]) ((UILabel *)v).textColor = [UIColor redColor];
    }
    
    switch (majorLevel) {
        case 0:
            auraColor = [UIColor colorWithWhite:0.4 alpha:1.0];
            qiBirthRate = 0;
            self.arrayContainer.alpha = 0.15;
            absorbText = @"Thể chất phàm nhân, chưa thể hấp thu linh khí.";
            break;

        case 1:
            auraColor = [UIColor lightGrayColor];
            qiBirthRate = 25.0;
            self.arrayContainer.alpha = 0.35;
            absorbText = @"Tụ khí tẩy tủy, bắt đầu cảm nhận linh khí.";
            break;

        case 2:
            auraColor = [UIColor colorWithRed:0.6 green:0.9 blue:1.0 alpha:1.0];
            qiBirthRate = 60.0;
            self.arrayContainer.alpha = 0.7;
            absorbText = @"Linh khí vận chuyển quanh thân thể, kinh mạch khai thông.";
            break;

        case 3:
            auraColor = [UIColor colorWithRed:0.3 green:0.8 blue:1.0 alpha:1.0];
            qiBirthRate = 100.0;
            self.daoMarkLayer.opacity = 1.0;
            absorbText = @"Đạo cơ đúc thành, linh lực ngưng thực, đạo vận quanh thân.";
            break;

        case 4: { // KIM ĐAN
            auraColor = [UIColor colorWithRed:1.0 green:0.85 blue:0.15 alpha:1.0];
            qiBirthRate = 180.0;
            self.goldenCoreLayer.opacity = 1.0;
            
            CABasicAnimation *corePulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            corePulse.fromValue = @0.85;
            corePulse.toValue = @1.2;
            corePulse.duration = 0.8;
            corePulse.autoreverses = YES;
            corePulse.repeatCount = HUGE_VALF;
            [self.goldenCoreLayer addAnimation:corePulse forKey:@"corePulse"];

            self.daoMarkLayer.opacity = 0.9;
            self.daoMarkLayer.lineWidth = 3.5;
            absorbText = @"Ngưng tụ Kim Đan, thọ nguyên tăng mạnh, pháp lực bừng nở.";
            break;
        }

        case 5: { // NGUYÊN ANH
            auraColor = [UIColor colorWithRed:0.85 green:0.4 blue:1.0 alpha:1.0];
            qiBirthRate = 240.0;
            self.nascentSoulLayer.opacity = 1.0;
            self.nascentSoulLayer.shadowColor = auraColor.CGColor;

            CABasicAnimation *soulFloat = [CABasicAnimation animationWithKeyPath:@"position.y"];
            soulFloat.fromValue = @(self.nascentSoulLayer.position.y);
            soulFloat.toValue = @(self.nascentSoulLayer.position.y - 18);
            soulFloat.duration = 2.0;
            soulFloat.autoreverses = YES;
            soulFloat.repeatCount = HUGE_VALF;
            [self.nascentSoulLayer addAnimation:soulFloat forKey:@"soulFloat"];

            CABasicAnimation *soulPulse = [CABasicAnimation animationWithKeyPath:@"opacity"];
            soulPulse.fromValue = @0.5;
            soulPulse.toValue = @1.0;
            soulPulse.duration = 1.2;
            soulPulse.autoreverses = YES;
            soulPulse.repeatCount = HUGE_VALF;
            [self.nascentSoulLayer addAnimation:soulPulse forKey:@"soulPulse"];

            absorbText = @"Đan vỡ sinh Anh, thần hồn cường đại, ngưng tụ Nguyên Anh.";
            break;
        }

        case 6: { // HÓA THẦN
            auraColor = [UIColor colorWithRed:1.0 green:0.25 blue:0.8 alpha:1.0];
            qiBirthRate = 320.0;
            self.nascentSoulLayer.opacity = 0.9;
            self.nascentSoulLayer.shadowColor = auraColor.CGColor;

            self.dharmaIdolLayer.opacity = 0.8;
            self.dharmaIdolLayer.strokeColor = auraColor.CGColor;
            self.dharmaIdolLayer.transform = CATransform3DMakeScale(1.7, 1.7, 1.0);

            CABasicAnimation *dharmaPulse = [CABasicAnimation animationWithKeyPath:@"opacity"];
            dharmaPulse.fromValue = @0.3;
            dharmaPulse.toValue = @0.9;
            dharmaPulse.duration = 1.5;
            dharmaPulse.autoreverses = YES;
            dharmaPulse.repeatCount = HUGE_VALF;
            [self.dharmaIdolLayer addAnimation:dharmaPulse forKey:@"dharmaPulse"];

            absorbText = @"Thần thức bao trùm, thiên địa giao cảm, pháp tướng hiển thế.";
            break;
        }

        // ========================================================
        // ĐÃ CHỈNH SỬA DUY NHẤT CASE 7 (LUYỆN HƯ) NHƯ YÊU CẦU
        // ========================================================
        case 7: { 
            auraColor = [UIColor colorWithRed:0.65 green:0.1 blue:0.9 alpha:1.0];
            qiBirthRate = 380.0;
            self.backgroundLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.55];
            self.spaceFragmentsLayer.opacity = 1.0;
            qiAccelY = 80.0;

            UIBezierPath *cracks = [UIBezierPath bezierPath];
            CGFloat w = self.bounds.size.width;
            CGFloat h = self.bounds.size.height;
            CGFloat cx = w / 2.0;
            CGFloat cy = h / 2.0;
            
            // Tạo 20 đường nứt chính tủa ra từ tâm
            for (int i = 0; i < 20; i++) {
                CGFloat angle = (i / 20.0) * M_PI * 2 + (arc4random_uniform(100)/100.0 * 0.3);
                CGFloat curX = cx + (arc4random_uniform(40) - 20); // Tâm nứt hơi lệch xíu cho tự nhiên
                CGFloat curY = cy + (arc4random_uniform(40) - 20);
                [cracks moveToPoint:CGPointMake(curX, curY)];
                
                CGFloat length = 0;
                CGFloat maxLength = MAX(w, h) + 100;
                while (length < maxLength) {
                    CGFloat step = 20 + arc4random_uniform(40);
                    length += step;
                    angle += (arc4random_uniform(100) - 50) / 100.0 * 0.4; // Đổi hướng lởm chởm
                    curX += cos(angle) * step;
                    curY += sin(angle) * step;
                    [cracks addLineToPoint:CGPointMake(curX, curY)];
                    
                    // Nhánh nứt phụ dày đặc
                    if (arc4random_uniform(100) > 40) {
                        CGFloat subAngle = angle + (arc4random_uniform(100) > 50 ? 0.7 : -0.7);
                        CGFloat subStep = 15 + arc4random_uniform(30);
                        [cracks moveToPoint:CGPointMake(curX, curY)];
                        [cracks addLineToPoint:CGPointMake(curX + cos(subAngle)*subStep, curY + sin(subAngle)*subStep)];
                        [cracks moveToPoint:CGPointMake(curX, curY)]; // Quay lại nhánh chính
                    }
                }
            }
            
            self.spaceFragmentsLayer.path = cracks.CGPath;
            self.spaceFragmentsLayer.fillColor = [UIColor clearColor].CGColor;
            self.spaceFragmentsLayer.strokeColor = [[UIColor cyanColor] colorWithAlphaComponent:0.9].CGColor;
            self.spaceFragmentsLayer.lineWidth = 1.5;
            self.spaceFragmentsLayer.shadowColor = [UIColor purpleColor].CGColor;
            self.spaceFragmentsLayer.shadowRadius = 8.0;
            self.spaceFragmentsLayer.shadowOpacity = 1.0;
            self.spaceFragmentsLayer.shadowOffset = CGSizeZero;
            self.spaceFragmentsLayer.lineJoin = kCALineJoinMiter;
            
            // Hiệu ứng chớp nháy (Glitch/Flicker) của không gian vỡ
            CABasicAnimation *crackFlicker = [CABasicAnimation animationWithKeyPath:@"opacity"];
            crackFlicker.fromValue = @0.2;
            crackFlicker.toValue = @1.0;
            crackFlicker.duration = 0.15;
            crackFlicker.autoreverses = YES;
            crackFlicker.repeatCount = HUGE_VALF;
            [self.spaceFragmentsLayer addAnimation:crackFlicker forKey:@"crackFlicker"];

            absorbText = @"Không gian phá toái, nắm giữ hư vô, uy áp chấn động.";
            break;
        }

        case 8: { // ĐẠI THỪA
            auraColor = [UIColor redColor];
            qiBirthRate = 450.0;
            self.arrayContainer.transform = CGAffineTransformMakeScale(1.25, 1.25);
            self.lawsLayer.alpha = 1.0;

            self.dharmaIdolLayer.opacity = 0.7;
            self.dharmaIdolLayer.strokeColor = auraColor.CGColor;
            self.dharmaIdolLayer.transform = CATransform3DMakeScale(2.6, 2.6, 1.0);

            CABasicAnimation *dharmaPulse2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
            dharmaPulse2.fromValue = @0.3;
            dharmaPulse2.toValue = @0.85;
            dharmaPulse2.duration = 1.2;
            dharmaPulse2.autoreverses = YES;
            dharmaPulse2.repeatCount = HUGE_VALF;
            [self.dharmaIdolLayer addAnimation:dharmaPulse2 forKey:@"dharmaPulse2"];

            for (UIView *v in self.lawsLayer.subviews) {
                if ([v isKindOfClass:[UILabel class]]) {
                    UILabel *lbl = (UILabel *)v;
                    lbl.textColor = [UIColor redColor];
                    lbl.font = [UIFont boldSystemFontOfSize:18];
                    lbl.layer.shadowRadius = 10.0;
                    lbl.layer.shadowOpacity = 1.0;
                }
            }
            absorbText = @"Đại Thừa viên mãn, pháp tắc hiển hóa, tiếu ngạo nhân gian.";
            break;
        }

        case 9: { // ĐỘ KIẾP
            auraColor = [UIColor cyanColor];
            qiBirthRate = 550.0;
            self.cloudLayer.opacity = 1.0;
            self.arrayContainer.transform = CGAffineTransformMakeScale(1.35, 1.35);
            self.lightningLayer.opacity = 1.0;

            UIBezierPath *lt = [UIBezierPath bezierPath];
            CGFloat w = self.bounds.size.width;
            CGFloat h = self.bounds.size.height;
            for (int b = 0; b < 3; b++) {
                CGFloat sx = w * (0.25 + b * 0.25) + (arc4random_uniform(60) - 30);
                [lt moveToPoint:CGPointMake(sx, 0)];
                CGFloat curX = sx;
                for (int seg = 1; seg <= 8; seg++) {
                    curX += (arc4random_uniform(60) - 30);
                    [lt addLineToPoint:CGPointMake(curX, h * seg / 8.0)];
                }
            }
            self.lightningLayer.path = lt.CGPath;
            self.lightningLayer.lineWidth = 4.0;

            CAKeyframeAnimation *storm = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
            storm.values = @[@0, @1, @0.2, @0.9, @0.1, @1, @0];
            storm.keyTimes = @[@0, @0.05, @0.15, @0.25, @0.4, @0.6, @1.0];
            storm.duration = 1.5;
            storm.repeatCount = HUGE_VALF;
            [self.lightningLayer addAnimation:storm forKey:@"stormFX"];

            absorbText = @"Thiên địa biến sắc, mây đen vần vũ, chuẩn bị đón Lôi Kiếp.";
            break;
        }

        case 10: { // THIÊN KIẾP
            auraColor = [UIColor cyanColor];
            qiBirthRate = 700.0;
            self.cloudLayer.opacity = 1.0;
            self.lightningLayer.opacity = 1.0;
            self.arrayContainer.transform = CGAffineTransformMakeScale(1.4, 1.4);

            UIBezierPath *lt = [UIBezierPath bezierPath];
            CGFloat w = self.bounds.size.width;
            CGFloat h = self.bounds.size.height;
            for (int b = 0; b < 6; b++) {
                CGFloat sx = w * (0.15 + b * 0.14) + (arc4random_uniform(50) - 25);
                [lt moveToPoint:CGPointMake(sx, 0)];
                CGFloat curX = sx;
                for (int seg = 1; seg <= 10; seg++) {
                    curX += (arc4random_uniform(70) - 35);
                    [lt addLineToPoint:CGPointMake(curX, h * seg / 10.0)];
                }
            }
            self.lightningLayer.path = lt.CGPath;
            self.lightningLayer.lineWidth = 6.0;

            CAKeyframeAnimation *storm = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
            storm.values = @[@0, @1, @0, @1, @0, @0.9, @0, @1, @0];
            storm.keyTimes = @[@0, @0.05, @0.1, @0.15, @0.2, @0.3, @0.4, @0.5, @1.0];
            storm.duration = 0.4;
            storm.repeatCount = HUGE_VALF;
            [self.lightningLayer addAnimation:storm forKey:@"stormFX"];

            CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position.x"];
            shake.fromValue = @(self.monkLayer.position.x - 5);
            shake.toValue = @(self.monkLayer.position.x + 5);
            shake.duration = 0.05;
            shake.autoreverses = YES;
            shake.repeatCount = HUGE_VALF;
            [self.monkLayer addAnimation:shake forKey:@"shaking"];

            absorbText = @"Cửu Trọng Thiên Lôi giáng lâm! Sinh tử nhất niệm!";
            break;
        }

        case 11: { // PHI THĂNG
            auraColor = [UIColor colorWithRed:1.0 green:0.9 blue:0.6 alpha:1.0];
            qiBirthRate = 0;
            ascBirthRate = 25.0; 
            
            self.arrayContainer.alpha = 0.0;
            self.ascensionContainer.alpha = 1.0;

            self.monkLayer.strokeColor = [[UIColor colorWithRed:1.0 green:0.9 blue:0.6 alpha:1.0] CGColor];
            self.robeLinesLayer.strokeColor = [[UIColor colorWithRed:1.0 green:0.9 blue:0.6 alpha:0.95] CGColor];
            self.monkLayer.shadowColor = [UIColor yellowColor].CGColor;
            self.monkLayer.shadowRadius = 45.0;

            CGFloat targetY = self.bounds.size.height * 0.4;
            
            CABasicAnimation *flyUp = [CABasicAnimation animationWithKeyPath:@"position.y"];
            flyUp.fromValue = @(self.bounds.size.height / 2.0 - 20);
            flyUp.toValue = @(targetY);
            flyUp.duration = 2.0;
            flyUp.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            flyUp.fillMode = kCAFillModeForwards;
            flyUp.removedOnCompletion = NO;
            [self.monkLayer addAnimation:flyUp forKey:@"flyUpAnim"];
            [self.robeLinesLayer addAnimation:flyUp forKey:@"flyUpAnim"];

            for (int i = 0; i < 3; i++) {
                CAShapeLayer *halo = [CAShapeLayer layer];
                CGFloat radius = 80 + i * 45;
                halo.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-radius, -radius, radius*2, radius*2)].CGPath;
                halo.fillColor = [UIColor clearColor].CGColor;
                halo.strokeColor = [[UIColor colorWithRed:1.0 green:0.9 blue:0.6 alpha:(0.55 - i*0.15)] CGColor];
                halo.lineWidth = 2.5;
                halo.position = CGPointMake(self.bounds.size.width/2, targetY);
                halo.name = [NSString stringWithFormat:@"halo%d", i];
                [self.layer addSublayer:halo];

                CABasicAnimation *haloPulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                haloPulse.fromValue = @1.0;
                haloPulse.toValue = @(1.3 + i * 0.2);
                haloPulse.duration = 2.5 + i * 0.5;
                haloPulse.autoreverses = YES;
                haloPulse.repeatCount = HUGE_VALF;
                [halo addAnimation:haloPulse forKey:@"haloPulse"];

                CABasicAnimation *haloOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
                haloOpacity.fromValue = @0.3;
                haloOpacity.toValue = @0.8;
                haloOpacity.duration = 1.8 + i * 0.3;
                haloOpacity.autoreverses = YES;
                haloOpacity.repeatCount = HUGE_VALF;
                [halo addAnimation:haloOpacity forKey:@"haloOpacity"];
            }

            absorbText = @"Bạch nhật phi thăng, vị liệt tiên ban, đại đạo viên mãn.";
            break;
        }
    }

    [CATransaction commit];

    [self.qiEmitter setValue:@(qiBirthRate) forKeyPath:@"emitterCells.qiCell.birthRate"];
    [self.qiEmitter setValue:(id)auraColor.CGColor forKeyPath:@"emitterCells.qiCell.color"];
    [self.qiEmitter setValue:@(qiAccelY) forKeyPath:@"emitterCells.qiCell.yAcceleration"];
    
    [self.ascensionEmitter setValue:@(ascBirthRate) forKeyPath:@"emitterCells.ascCell.birthRate"];

    [self addContinuousAnimations];
    
    if (majorLevel != 11) {
        for (CALayer *l in self.spinLayerCW.layer.sublayers) {
            if ([l isKindOfClass:[CAShapeLayer class]]) ((CAShapeLayer *)l).strokeColor = auraColor.CGColor;
        }
        for (UIView *v in self.spinLayerCW.subviews) {
            if ([v isKindOfClass:[UILabel class]]) ((UILabel *)v).textColor = auraColor;
        }
        for (CALayer *l in self.spinLayerCCW.layer.sublayers) {
            if ([l isKindOfClass:[CAShapeLayer class]]) ((CAShapeLayer *)l).strokeColor = auraColor.CGColor;
        }
    }

    self.statusLabel.layer.shadowColor = auraColor.CGColor;
    self.absorbingLabel.text = absorbText;
    
    if (!self.isBreakingThrough) {
        CultivationStatus st = getCultivationStatus(self.lastBatteryLevel);
        self.statusLabel.text = st.subRealm.length > 0 ? [NSString stringWithFormat:@"%@\n· %@ ·", st.realmName, st.subRealm] : st.realmName;
    }
}

- (void)processBreakthroughFrom:(CultivationStatus)oldStatus to:(CultivationStatus)newStatus {
    self.isBreakingThrough = YES;
    self.statusLabel.text = @"— ĐỘT PHÁ —";
    self.statusLabel.textColor = [UIColor yellowColor];

    UIImpactFeedbackGenerator *hap = [[UIImpactFeedbackGenerator alloc] initWithStyle:(newStatus.majorLevel >= 6) ? UIImpactFeedbackStyleHeavy : UIImpactFeedbackStyleMedium];
    [hap impactOccurred];

    int level = newStatus.majorLevel;

    if (level == 11) {
        [UIView animateWithDuration:0.5 animations:^{
            self.flashView.backgroundColor = [UIColor whiteColor];
            self.flashView.alpha = 1.0;
        } completion:^(BOOL finished) {
            [self applyRealmEffects:level];
            self.statusLabel.textColor = [UIColor colorWithRed:1.0 green:0.9 blue:0.6 alpha:1.0];
            [UIView animateWithDuration:2.5 animations:^{
                self.flashView.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.isBreakingThrough = NO;
            }];
        }];
        return;
    }

    self.flashView.backgroundColor = (level >= 9) ? [UIColor cyanColor] : (level == 4 ? [UIColor yellowColor] : [UIColor whiteColor]);

    if (level >= 6) {
        CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position.x"];
        shake.duration = 0.04;
        shake.repeatCount = (level >= 9) ? 20 : 10;
        shake.autoreverses = YES;
        shake.fromValue = @(self.center.x - 10);
        shake.toValue = @(self.center.x + 10);
        [self.layer addAnimation:shake forKey:@"breakthroughShake"];
    }

    [UIView animateWithDuration:0.35 animations:^{
        self.arrayContainer.transform = CGAffineTransformMakeScale(1.35, 1.35);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.flashView.alpha = 0.95;
            self.arrayContainer.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
            [self applyRealmEffects:level];
            self.statusLabel.text = newStatus.subRealm.length > 0 ? [NSString stringWithFormat:@"%@\n· %@ ·", newStatus.realmName, newStatus.subRealm] : newStatus.realmName;

            [UIView animateWithDuration:0.6 animations:^{
                self.flashView.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.statusLabel.textColor = [UIColor whiteColor];
                self.isBreakingThrough = NO;
            }];
        }];
    }];
}

- (void)processRealmDropFrom:(CultivationStatus)oldStatus to:(CultivationStatus)newStatus {
    self.isBreakingThrough = YES;
    self.statusLabel.text = @"— THOÁI CẢNH GIỚI —";
    self.statusLabel.textColor = [UIColor colorWithWhite:0.65 alpha:1.0];

    UIImpactFeedbackGenerator *hap = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
    [hap impactOccurred];

    [UIView animateWithDuration:0.4 animations:^{
        self.arrayContainer.transform = CGAffineTransformMakeScale(0.85, 0.85);
    } completion:^(BOOL finished) {
        [self applyRealmEffects:newStatus.majorLevel];
        self.statusLabel.text = newStatus.subRealm.length > 0 ? [NSString stringWithFormat:@"%@\n· %@ ·", newStatus.realmName, newStatus.subRealm] : newStatus.realmName;

        [UIView animateWithDuration:0.4 animations:^{
            self.arrayContainer.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.statusLabel.textColor = [UIColor whiteColor];
            self.isBreakingThrough = NO;
        }];
    }];
}

- (void)handleTestTap {
    if (self.isBreakingThrough) { return; }

    int fakeBattery = [self.testMilestones[self.testIndex] intValue];
    self.lastBatteryLevel = fakeBattery - 1;
    [self updateTuVi:fakeBattery];

    self.testIndex++;
    if (self.testIndex >= self.testMilestones.count) self.testIndex = 0;
}

- (void)updateTuVi:(int)currentBattery {
    if (self.lastBatteryLevel == -1) {
        self.lastBatteryLevel = currentBattery;
        [self applyRealmEffects:getCultivationStatus(currentBattery).majorLevel];
        return;
    }
    if (self.isBreakingThrough) return;

    CultivationStatus oldStatus = getCultivationStatus(self.lastBatteryLevel);
    CultivationStatus newStatus = getCultivationStatus(currentBattery);

    if (currentBattery >= 100) {
        if (oldStatus.majorLevel != 11) {
            self.lastBatteryLevel = currentBattery;
            [self processBreakthroughFrom:oldStatus to:getCultivationStatus(100)];
        } else {
            self.statusLabel.text = @"PHI THĂNG\n· Đại Đạo Viên Mãn ·";
            self.absorbingLabel.text = @"Bạch nhật phi thăng, vị liệt tiên ban.";
        }
        return;
    }

    BOOL changed = ![oldStatus.subRealm isEqualToString:newStatus.subRealm]
                 || oldStatus.majorLevel != newStatus.majorLevel;

    if (changed) {
        self.lastBatteryLevel = currentBattery;
        if (newStatus.majorLevel > oldStatus.majorLevel) {
            [self processBreakthroughFrom:oldStatus to:newStatus];
        } else if (newStatus.majorLevel < oldStatus.majorLevel) {
            [self processRealmDropFrom:oldStatus to:newStatus];
        } else {
            [self processBreakthroughFrom:oldStatus to:newStatus];
        }
    } else {
        self.lastBatteryLevel = currentBattery;
        self.statusLabel.text = newStatus.subRealm.length > 0 ? [NSString stringWithFormat:@"%@\n· %@ ·", newStatus.realmName, newStatus.subRealm] : newStatus.realmName;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint p = [self.testButton convertPoint:point fromView:self];
    return [self.testButton pointInside:p withEvent:event];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self pointInside:point withEvent:event]) { return self.testButton; }
    return nil;
}

@end

// ==========================================
// HOOK LOCK SCREEN
// ==========================================
static TMCCultivationView *cultivationView = nil;
static BOOL tmcInitializing = NO;
static NSInteger const kTMCTag = 999999;

%hook CSCoverSheetViewController

- (void)viewWillAppear:(BOOL)animated {
    %orig;
    UIDevice *device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;

    [[NSNotificationCenter defaultCenter] removeObserver:self
        name:UIDeviceBatteryLevelDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
        name:UIDeviceBatteryStateDidChangeNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(tmc_batteryChanged:)
        name:UIDeviceBatteryLevelDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(tmc_batteryChanged:)
        name:UIDeviceBatteryStateDidChangeNotification object:nil];

    dispatch_async(dispatch_get_main_queue(), ^{
        if (tmcInitializing || cultivationView) return;
        UIView *host = self.view;
        if (!host) return;
        if ([host viewWithTag:kTMCTag]) return;

        UIDevice *d = [UIDevice currentDevice];
        if (d.batteryState != UIDeviceBatteryStateCharging &&
            d.batteryState != UIDeviceBatteryStateFull) return;

        tmcInitializing = YES;
        @try {
            cultivationView = [[TMCCultivationView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            cultivationView.tag = kTMCTag;
            [host addSubview:cultivationView];
            [cultivationView updateTuVi:(int)(d.batteryLevel * 100)];
        }
        @catch (NSException *e) {
            if(cultivationView) [cultivationView removeFromSuperview];
            cultivationView = nil;
        }
        @finally {
            tmcInitializing = NO;
        }
    });
}

- (void)viewDidDisappear:(BOOL)animated {
    %orig;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (cultivationView) {
        [cultivationView removeFromSuperview];
        cultivationView = nil;
    }
    UIView *v = [self.view viewWithTag:kTMCTag];
    if (v) [v removeFromSuperview];
}

%new
- (void)tmc_batteryChanged:(NSNotification *)note {
    dispatch_async(dispatch_get_main_queue(), ^{
        @try {
            UIDevice *d = [UIDevice currentDevice];
            if (!cultivationView) {
                if (d.batteryState == UIDeviceBatteryStateCharging ||
                    d.batteryState == UIDeviceBatteryStateFull) {
                    UIView *host = self.view;
                    if (!host) return;
                    if ([host viewWithTag:kTMCTag]) return;
                    cultivationView = [[TMCCultivationView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                    cultivationView.tag = kTMCTag;
                    [host addSubview:cultivationView];
                    [cultivationView updateTuVi:(int)(d.batteryLevel * 100)];
                }
            } else {
                if (d.batteryState == UIDeviceBatteryStateUnplugged) {
                    [UIView animateWithDuration:0.4 animations:^{
                        cultivationView.alpha = 0;
                    } completion:^(BOOL finished) {
                        [cultivationView removeFromSuperview];
                        cultivationView = nil;
                    }];
                } else {
                    [cultivationView updateTuVi:(int)(d.batteryLevel * 100)];
                }
            }
        }
        @catch (NSException *e) {}
    });
}

%end
