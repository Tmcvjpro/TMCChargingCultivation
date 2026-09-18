#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import <math.h>

@interface CSCoverSheetViewController : UIViewController
@end

// --- HỆ THỐNG CẢNH GIỚI ---
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

@interface TMCCultivationView : UIView
@property (nonatomic, strong) UIView *backgroundLayer;
@property (nonatomic, strong) UIView *arrayContainer;
@property (nonatomic, strong) UIView *spinLayerCW;
@property (nonatomic, strong) UIView *spinLayerCCW;
@property (nonatomic, strong) CAShapeLayer *daoMarkLayer;
@property (nonatomic, strong) CAShapeLayer *monkLayer;
@property (nonatomic, strong) CAShapeLayer *monkHandsLayer;
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
@property (nonatomic, strong) CAEmitterLayer *qiEmitter;
@property (nonatomic, strong) UIView *flashView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *absorbingLabel;
@property (nonatomic, assign) int lastBatteryLevel;
@property (nonatomic, assign) BOOL isBreakingThrough;
@property (nonatomic, strong) UIButton *testButton;
@property (nonatomic, strong) NSArray *testMilestones;
@property (nonatomic, assign) int testIndex;

// ✅ Khai báo trước các method để tránh "no visible @interface"
- (CAShapeLayer *)createSlimMonkPathWithSize:(CGFloat)size;
- (UIBezierPath *)createHandsPathWithSize:(CGFloat)size;
- (void)drawAscensionSystem:(CGPoint)center;
- (void)drawUltimateBaguaArray;
- (void)drawClouds;
- (void)drawMultiBranchLightning;
- (void)drawSpaceFragments:(CGPoint)center;
- (void)drawLawsOrbit;
- (void)setupQiEmitter:(CGPoint)targetCenter;
- (void)applyRealmEffects:(int)majorLevel;
- (void)processBreakthroughFrom:(CultivationStatus)oldStatus to:(CultivationStatus)newStatus;
- (void)processRealmDropFrom:(CultivationStatus)oldStatus to:(CultivationStatus)newStatus;
- (void)updateTuVi:(int)currentBattery;
- (void)handleTestTap;
@end

@implementation TMCCultivationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        CGFloat centerX = frame.size.width / 2.0;
        CGFloat centerY = frame.size.height / 2.0 - 20;

        self.backgroundLayer = [[UIView alloc] initWithFrame:frame];
        [self addSubview:self.backgroundLayer];

        [self drawClouds];
        [self drawMultiBranchLightning];
        [self drawSpaceFragments:CGPointMake(centerX, centerY)];

        self.flashView = [[UIView alloc] initWithFrame:frame];
        self.flashView.backgroundColor = [UIColor whiteColor];
        self.flashView.alpha = 0.0;
        [self addSubview:self.flashView];

        self.arrayContainer = [[UIView alloc] initWithFrame:CGRectMake(centerX - 140, centerY - 140, 280, 280)];
        [self addSubview:self.arrayContainer];
        [self drawUltimateBaguaArray];

        self.nascentSoulLayer = [self createSlimMonkPathWithSize:55];
        self.nascentSoulLayer.position = CGPointMake(centerX, centerY - 50);
        self.nascentSoulLayer.fillColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4].CGColor;
        self.nascentSoulLayer.opacity = 0.0;
        [self.layer addSublayer:self.nascentSoulLayer];

        self.dharmaIdolLayer = [self createSlimMonkPathWithSize:200];
        self.dharmaIdolLayer.position = CGPointMake(centerX, centerY - 20);
        self.dharmaIdolLayer.fillColor = [UIColor clearColor].CGColor;
        self.dharmaIdolLayer.opacity = 0.0;
        [self.layer addSublayer:self.dharmaIdolLayer];

        self.lawsLayer = [[UIView alloc] initWithFrame:CGRectMake(centerX - 120, centerY - 120, 240, 240)];
        self.lawsLayer.alpha = 0.0;
        [self addSubview:self.lawsLayer];
        [self drawLawsOrbit];

        self.ascensionContainer = [[UIView alloc] initWithFrame:frame];
        self.ascensionContainer.alpha = 0.0;
        [self addSubview:self.ascensionContainer];
        [self drawAscensionSystem:CGPointMake(centerX, centerY)];

        // === TU SĨ ===
        self.monkHandsLayer = [CAShapeLayer layer];
        self.monkHandsLayer.path = [self createHandsPathWithSize:105].CGPath;
        self.monkHandsLayer.position = CGPointMake(centerX, centerY);
        self.monkHandsLayer.fillColor = [[UIColor whiteColor] colorWithAlphaComponent:0.55].CGColor;
        [self.layer addSublayer:self.monkHandsLayer];

        self.monkLayer = [self createSlimMonkPathWithSize:105];
        self.monkLayer.position = CGPointMake(centerX, centerY);
        self.monkLayer.fillColor = [UIColor blackColor].CGColor;
        self.monkLayer.shadowColor = [UIColor cyanColor].CGColor;
        self.monkLayer.shadowRadius = 12.0;
        self.monkLayer.shadowOpacity = 1.0;
        [self.layer addSublayer:self.monkLayer];

        self.goldenCoreLayer = [CAShapeLayer layer];
        self.goldenCoreLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-6, 0, 12, 12)].CGPath;
        self.goldenCoreLayer.fillColor = [UIColor yellowColor].CGColor;
        self.goldenCoreLayer.position = CGPointMake(centerX, centerY + 10);
        self.goldenCoreLayer.shadowColor = [UIColor yellowColor].CGColor;
        self.goldenCoreLayer.shadowRadius = 12.0;
        self.goldenCoreLayer.shadowOpacity = 1.0;
        self.goldenCoreLayer.opacity = 0.0;
        [self.layer addSublayer:self.goldenCoreLayer];

        [self setupQiEmitter:CGPointMake(centerX, centerY)];

        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(centerX - 160, centerY + 130, 320, 50)];
        self.statusLabel.numberOfLines = 2;
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        self.statusLabel.textColor = [UIColor whiteColor];
        self.statusLabel.font = [UIFont boldSystemFontOfSize:18];
        self.statusLabel.layer.shadowRadius = 6.0;
        self.statusLabel.layer.shadowOpacity = 1.0;
        [self addSubview:self.statusLabel];

        self.absorbingLabel = [[UILabel alloc] initWithFrame:CGRectMake(centerX - 150, centerY + 185, 300, 20)];
        self.absorbingLabel.text = @"Đang hội tụ linh khí...";
        self.absorbingLabel.textAlignment = NSTextAlignmentCenter;
        self.absorbingLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        self.absorbingLabel.font = [UIFont italicSystemFontOfSize:12];
        [self addSubview:self.absorbingLabel];

        CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"opacity"];
        pulse.fromValue = @0.4;
        pulse.toValue = @1.0;
        pulse.duration = 1.5;
        pulse.autoreverses = YES;
        pulse.repeatCount = HUGE_VALF;
        [self.absorbingLabel.layer addAnimation:pulse forKey:@"pulsingText"];

        self.testMilestones = @[@10, @14, @18, @24, @30, @40, @55, @70, @85, @97, @100];
        self.testIndex = 0;
        self.testButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.testButton.frame = CGRectMake(centerX - 40, frame.size.height - 110, 80, 30);
        [self.testButton setTitle:@"⚡️ TEST" forState:UIControlStateNormal];
        [self.testButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        self.testButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        self.testButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.testButton.layer.cornerRadius = 15;
        self.testButton.layer.borderWidth = 1.0;
        self.testButton.layer.borderColor = [UIColor yellowColor].CGColor;
        [self.testButton addTarget:self action:@selector(handleTestTap) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.testButton];

        self.lastBatteryLevel = -1;
    }
    return self;
}

// ==========================================
// VẼ SILHOUETTE TU SĨ
// ==========================================
- (CAShapeLayer *)createSlimMonkPathWithSize:(CGFloat)size {
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat s = size / 100.0;

    [path moveToPoint:CGPointMake(0, -50*s)];

    [path addCurveToPoint:CGPointMake(-7*s, -42*s)
            controlPoint1:CGPointMake(-8*s, -50*s)
            controlPoint2:CGPointMake(-9*s, -46*s)];
    [path addCurveToPoint:CGPointMake(-12*s, -33*s)
            controlPoint1:CGPointMake(-10*s, -40*s)
            controlPoint2:CGPointMake(-12*s, -37*s)];
    [path addCurveToPoint:CGPointMake(-7*s, -21*s)
            controlPoint1:CGPointMake(-12*s, -28*s)
            controlPoint2:CGPointMake(-11*s, -23*s)];
    [path addCurveToPoint:CGPointMake(-9*s, -16*s)
            controlPoint1:CGPointMake(-6*s, -20*s)
            controlPoint2:CGPointMake(-8*s, -17*s)];
    [path addCurveToPoint:CGPointMake(-28*s, -7*s)
            controlPoint1:CGPointMake(-17*s, -13*s)
            controlPoint2:CGPointMake(-24*s, -9*s)];
    [path addCurveToPoint:CGPointMake(-34*s, 5*s)
            controlPoint1:CGPointMake(-33*s, -2*s)
            controlPoint2:CGPointMake(-35*s, 1*s)];
    [path addCurveToPoint:CGPointMake(-41*s, 22*s)
            controlPoint1:CGPointMake(-35*s, 12*s)
            controlPoint2:CGPointMake(-39*s, 17*s)];
    [path addCurveToPoint:CGPointMake(-48*s, 36*s)
            controlPoint1:CGPointMake(-44*s, 27*s)
            controlPoint2:CGPointMake(-49*s, 32*s)];
    [path addCurveToPoint:CGPointMake(0, 48*s)
            controlPoint1:CGPointMake(-44*s, 45*s)
            controlPoint2:CGPointMake(-22*s, 49*s)];

    [path addCurveToPoint:CGPointMake(48*s, 36*s)
            controlPoint1:CGPointMake(22*s, 49*s)
            controlPoint2:CGPointMake(44*s, 45*s)];
    [path addCurveToPoint:CGPointMake(41*s, 22*s)
            controlPoint1:CGPointMake(49*s, 32*s)
            controlPoint2:CGPointMake(44*s, 27*s)];
    [path addCurveToPoint:CGPointMake(34*s, 5*s)
            controlPoint1:CGPointMake(39*s, 17*s)
            controlPoint2:CGPointMake(35*s, 12*s)];
    [path addCurveToPoint:CGPointMake(28*s, -7*s)
            controlPoint1:CGPointMake(35*s, 1*s)
            controlPoint2:CGPointMake(33*s, -2*s)];
    [path addCurveToPoint:CGPointMake(9*s, -16*s)
            controlPoint1:CGPointMake(24*s, -9*s)
            controlPoint2:CGPointMake(17*s, -13*s)];
    [path addCurveToPoint:CGPointMake(7*s, -21*s)
            controlPoint1:CGPointMake(8*s, -17*s)
            controlPoint2:CGPointMake(6*s, -20*s)];
    [path addCurveToPoint:CGPointMake(12*s, -33*s)
            controlPoint1:CGPointMake(11*s, -23*s)
            controlPoint2:CGPointMake(12*s, -28*s)];
    [path addCurveToPoint:CGPointMake(7*s, -42*s)
            controlPoint1:CGPointMake(12*s, -37*s)
            controlPoint2:CGPointMake(10*s, -40*s)];
    [path addCurveToPoint:CGPointMake(0, -50*s)
            controlPoint1:CGPointMake(9*s, -46*s)
            controlPoint2:CGPointMake(8*s, -50*s)];

    [path closePath];

    UIBezierPath *handL = [UIBezierPath bezierPath];
    [handL moveToPoint:CGPointMake(-29*s, 8*s)];
    [handL addCurveToPoint:CGPointMake(-19*s, 21*s)
             controlPoint1:CGPointMake(-33*s, 15*s)
             controlPoint2:CGPointMake(-25*s, 23*s)];
    [handL addCurveToPoint:CGPointMake(-13*s, 15*s)
             controlPoint1:CGPointMake(-15*s, 20*s)
             controlPoint2:CGPointMake(-12*s, 18*s)];
    [handL addCurveToPoint:CGPointMake(-23*s, 7*s)
             controlPoint1:CGPointMake(-16*s, 11*s)
             controlPoint2:CGPointMake(-20*s, 7*s)];
    [handL closePath];
    [path appendPath:handL];

    UIBezierPath *handR = [UIBezierPath bezierPath];
    [handR moveToPoint:CGPointMake(29*s, 8*s)];
    [handR addCurveToPoint:CGPointMake(19*s, 21*s)
             controlPoint1:CGPointMake(33*s, 15*s)
             controlPoint2:CGPointMake(25*s, 23*s)];
    [handR addCurveToPoint:CGPointMake(13*s, 15*s)
             controlPoint1:CGPointMake(15*s, 20*s)
             controlPoint2:CGPointMake(12*s, 18*s)];
    [handR addCurveToPoint:CGPointMake(23*s, 7*s)
             controlPoint1:CGPointMake(16*s, 11*s)
             controlPoint2:CGPointMake(20*s, 7*s)];
    [handR closePath];
    [path appendPath:handR];

    layer.path = path.CGPath;
    layer.fillRule = kCAFillRuleEvenOdd;
    return layer;
}

- (UIBezierPath *)createHandsPathWithSize:(CGFloat)size {
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat s = size / 100.0;

    UIBezierPath *handL = [UIBezierPath bezierPath];
    [handL moveToPoint:CGPointMake(-29*s, 8*s)];
    [handL addCurveToPoint:CGPointMake(-19*s, 21*s)
             controlPoint1:CGPointMake(-33*s, 15*s)
             controlPoint2:CGPointMake(-25*s, 23*s)];
    [handL addCurveToPoint:CGPointMake(-13*s, 15*s)
             controlPoint1:CGPointMake(-15*s, 20*s)
             controlPoint2:CGPointMake(-12*s, 18*s)];
    [handL addCurveToPoint:CGPointMake(-23*s, 7*s)
             controlPoint1:CGPointMake(-16*s, 11*s)
             controlPoint2:CGPointMake(-20*s, 7*s)];
    [handL closePath];
    [path appendPath:handL];

    UIBezierPath *handR = [UIBezierPath bezierPath];
    [handR moveToPoint:CGPointMake(29*s, 8*s)];
    [handR addCurveToPoint:CGPointMake(19*s, 21*s)
             controlPoint1:CGPointMake(33*s, 15*s)
             controlPoint2:CGPointMake(25*s, 23*s)];
    [handR addCurveToPoint:CGPointMake(13*s, 15*s)
             controlPoint1:CGPointMake(15*s, 20*s)
             controlPoint2:CGPointMake(12*s, 18*s)];
    [handR addCurveToPoint:CGPointMake(23*s, 7*s)
             controlPoint1:CGPointMake(16*s, 11*s)
             controlPoint2:CGPointMake(20*s, 7*s)];
    [handR closePath];
    [path appendPath:handR];

    return path;
}

// ==========================================
// VẼ ĐẠI ĐIỆN PHI THĂNG
// ==========================================
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
    self.heavenlyGateLayer.fillColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4].CGColor;
    self.heavenlyGateLayer.shadowColor = [UIColor whiteColor].CGColor;
    self.heavenlyGateLayer.shadowRadius = 20.0;
    self.heavenlyGateLayer.shadowOpacity = 1.0;
    [self.ascensionContainer.layer addSublayer:self.heavenlyGateLayer];

    self.immortalBeamLayer = [CAShapeLayer layer];
    UIBezierPath *beamPath = [UIBezierPath bezierPath];
    [beamPath moveToPoint:CGPointMake(gw/2 - 50, 60)];
    [beamPath addLineToPoint:CGPointMake(gw/2 + 50, 60)];
    [beamPath addLineToPoint:CGPointMake(gw/2 + 120, center.y + 80)];
    [beamPath addLineToPoint:CGPointMake(gw/2 - 120, center.y + 80)];
    [beamPath closePath];
    self.immortalBeamLayer.path = beamPath.CGPath;
    self.immortalBeamLayer.fillColor = [[UIColor yellowColor] colorWithAlphaComponent:0.15].CGColor;
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
    [self.ascensionContainer.layer addSublayer:self.lotusBaseLayer];
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

    CABasicAnimation *spin1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spin1.toValue = @(M_PI * 2.0);
    spin1.duration = 24.0;
    spin1.repeatCount = HUGE_VALF;
    [self.spinLayerCW.layer addAnimation:spin1 forKey:@"spinCW"];

    CABasicAnimation *spin2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spin2.toValue = @(-M_PI * 2.0);
    spin2.duration = 18.0;
    spin2.repeatCount = HUGE_VALF;
    [self.spinLayerCCW.layer addAnimation:spin2 forKey:@"spinCCW"];
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
    UIBezierPath *lightning = [UIBezierPath bezierPath];
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;

    [lightning moveToPoint:CGPointMake(w/2 + 20, 0)];
    [lightning addLineToPoint:CGPointMake(w/2 - 30, h/4)];
    [lightning addLineToPoint:CGPointMake(w/2 + 25, h/2.5)];
    [lightning addLineToPoint:CGPointMake(w/2 - 40, 3*h/4)];
    [lightning addLineToPoint:CGPointMake(w/2 + 10, h)];
    [lightning moveToPoint:CGPointMake(w/2 - 30, h/4)];
    [lightning addLineToPoint:CGPointMake(w/4, h/3)];
    [lightning moveToPoint:CGPointMake(w/2 + 25, h/2.5)];
    [lightning addLineToPoint:CGPointMake(3*w/4, h/2)];

    self.lightningLayer.path = lightning.CGPath;
    self.lightningLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.lightningLayer.fillColor = [UIColor clearColor].CGColor;
    self.lightningLayer.lineWidth = 5.0;
    self.lightningLayer.shadowColor = [UIColor cyanColor].CGColor;
    self.lightningLayer.shadowRadius = 20.0;
    self.lightningLayer.shadowOpacity = 1.0;
    self.lightningLayer.opacity = 0.0;
    self.lightningLayer.lineCap = kCALineCapRound;
    self.lightningLayer.lineJoin = kCALineJoinRound;
    [self.backgroundLayer.layer addSublayer:self.lightningLayer];
}

- (void)drawSpaceFragments:(CGPoint)center {
    self.spaceFragmentsLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int i = 0; i < 15; i++) {
        CGFloat x = center.x + (arc4random_uniform(220) - 110);
        CGFloat y = center.y + (arc4random_uniform(220) - 110);
        [path moveToPoint:CGPointMake(x, y)];
        [path addLineToPoint:CGPointMake(x + 15, y - 5)];
        [path addLineToPoint:CGPointMake(x + 10, y + 10)];
        [path closePath];
    }
    self.spaceFragmentsLayer.path = path.CGPath;
    self.spaceFragmentsLayer.fillColor = [[UIColor purpleColor] colorWithAlphaComponent:0.6].CGColor;
    self.spaceFragmentsLayer.strokeColor = [UIColor cyanColor].CGColor;
    self.spaceFragmentsLayer.lineWidth = 1.0;
    self.spaceFragmentsLayer.opacity = 0.0;
    [self.backgroundLayer.layer addSublayer:self.spaceFragmentsLayer];
}

- (void)drawLawsOrbit {
    NSArray *laws = @[@"Luân", @"Hồi", @"Sinh", @"Diệt", @"Đạo", @"Hư", @"Pháp", @"Tắc"];
    for (int i = 0; i < laws.count; i++) {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        lbl.center = CGPointMake(120, 120);
        lbl.text = laws[i];
        lbl.textColor = [UIColor redColor];
        lbl.font = [UIFont boldSystemFontOfSize:14];
        CGAffineTransform t = CGAffineTransformMakeRotation(i * (M_PI * 2 / laws.count));
        t = CGAffineTransformTranslate(t, 0, -100);
        lbl.transform = t;
        [self.lawsLayer addSubview:lbl];
    }
    CABasicAnimation *orbit = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    orbit.toValue = @(M_PI * 2.0);
    orbit.duration = 10.0;
    orbit.repeatCount = HUGE_VALF;
    [self.lawsLayer.layer addAnimation:orbit forKey:@"orbitLaws"];
}

- (void)setupQiEmitter:(CGPoint)targetCenter {
    self.qiEmitter = [CAEmitterLayer layer];
    CGFloat radius = MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) + 50;
    self.qiEmitter.emitterPosition = targetCenter;
    self.qiEmitter.emitterSize = CGSizeMake(radius, radius);
    self.qiEmitter.emitterShape = kCAEmitterLayerCircle;
    self.qiEmitter.emitterMode = kCAEmitterLayerOutline;
    self.qiEmitter.renderMode = kCAEmitterLayerAdditive;

    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(4, 4), NO, 0);
    [[UIColor whiteColor] setFill];
    [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 4, 4)] fill];
    UIImage *qiDot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    cell.contents = (id)qiDot.CGImage;
    cell.birthRate = 0;
    cell.lifetime = 2.5;
    cell.velocity = -250.0;
    cell.velocityRange = 50.0;
    cell.emissionRange = M_PI * 2.0;
    cell.alphaSpeed = -0.3;
    cell.scale = 0.8;
    self.qiEmitter.emitterCells = @[cell];
    [self.layer insertSublayer:self.qiEmitter below:self.arrayContainer.layer];
}

// ==========================================
// APPLY REALM EFFECTS
// ==========================================
- (void)applyRealmEffects:(int)majorLevel {
    UIColor *auraColor = [UIColor clearColor];
    float qiBirthRate = 0;
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
    self.backgroundLayer.backgroundColor = [UIColor clearColor];
    [self.lightningLayer removeAllAnimations];
    self.lightningLayer.opacity = 0.0;
    [self.spaceFragmentsLayer removeAllAnimations];
    self.arrayContainer.transform = CGAffineTransformIdentity;
    self.arrayContainer.alpha = 1.0;
    self.monkHandsLayer.fillColor = [[UIColor whiteColor] colorWithAlphaComponent:0.55].CGColor;

    CGFloat radius = MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) + 50;
    CGPoint baseCenter = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0 - 20);
    self.qiEmitter.emitterPosition = baseCenter;
    self.qiEmitter.emitterSize = CGSizeMake(radius, radius);
    self.qiEmitter.emitterShape = kCAEmitterLayerCircle;
    self.qiEmitter.emitterMode = kCAEmitterLayerOutline;

    CAEmitterCell *cell = [self.qiEmitter.emitterCells firstObject];
    cell.yAcceleration = 0;
    cell.velocity = -250.0;
    cell.velocityRange = 50.0;

    if (majorLevel == 0) {
        absorbText = @"Thể chất phàm nhân, chưa thể hấp thu.";
    } else if (majorLevel == 1) {
        auraColor = [UIColor lightGrayColor];
        qiBirthRate = 10.0;
        self.arrayContainer.alpha = 0.3;
        absorbText = @"Tụ khí tẩy tủy, bắt đầu cảm nhận linh khí.";
    } else if (majorLevel == 2) {
        auraColor = [UIColor colorWithRed:0.6 green:0.9 blue:1.0 alpha:1.0];
        qiBirthRate = 35.0;
        self.arrayContainer.alpha = 0.7;
        absorbText = @"Linh khí vận chuyển quanh thân thể.";
    } else if (majorLevel == 3) {
        auraColor = [UIColor colorWithRed:0.3 green:0.8 blue:1.0 alpha:1.0];
        qiBirthRate = 70.0;
        self.daoMarkLayer.opacity = 1.0;
        absorbText = @"Đạo cơ đúc thành, linh lực ngưng thực.";
    } else if (majorLevel == 4) {
        auraColor = [UIColor colorWithRed:1.0 green:0.85 blue:0.1 alpha:1.0];
        qiBirthRate = 100.0;
        self.goldenCoreLayer.opacity = 1.0;
        absorbText = @"Kết thành Kim Đan, thọ nguyên tăng mạnh.";
    } else if (majorLevel == 5) {
        auraColor = [UIColor colorWithRed:0.8 green:0.3 blue:1.0 alpha:1.0];
        qiBirthRate = 150.0;
        self.nascentSoulLayer.opacity = 1.0;
        absorbText = @"Đan vỡ sinh Anh, thần hồn cường đại.";
    } else if (majorLevel == 6) {
        auraColor = [UIColor colorWithRed:1.0 green:0.2 blue:0.8 alpha:1.0];
        qiBirthRate = 200.0;
        self.dharmaIdolLayer.fillColor = [UIColor clearColor].CGColor;
        self.dharmaIdolLayer.strokeColor = auraColor.CGColor;
        self.dharmaIdolLayer.lineWidth = 1.5;
        self.dharmaIdolLayer.opacity = 0.7;
        self.dharmaIdolLayer.transform = CATransform3DMakeScale(1.6, 1.6, 1.0);
        absorbText = @"Thần thức bao trùm, thiên địa giao cảm.";
    } else if (majorLevel == 7) {
        auraColor = [UIColor colorWithRed:0.6 green:0.0 blue:0.8 alpha:1.0];
        qiBirthRate = 250.0;
        self.backgroundLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4].CGColor;
        self.spaceFragmentsLayer.opacity = 1.0;
        CABasicAnimation *pulseSp = [CABasicAnimation animationWithKeyPath:@"opacity"];
        pulseSp.fromValue = @0.2;
        pulseSp.toValue = @1.0;
        pulseSp.duration = 0.5;
        pulseSp.autoreverses = YES;
        pulseSp.repeatCount = HUGE_VALF;
        [self.spaceFragmentsLayer addAnimation:pulseSp forKey:@"pulseSpaceFx"];
        cell.yAcceleration = 80.0;
        absorbText = @"Không gian phá toái, nắm giữ hư vô.";
    } else if (majorLevel == 8) {
        auraColor = [UIColor redColor];
        qiBirthRate = 350.0;
        self.arrayContainer.transform = CGAffineTransformMakeScale(1.2, 1.2);
        self.lawsLayer.alpha = 1.0;
        self.dharmaIdolLayer.strokeColor = auraColor.CGColor;
        self.dharmaIdolLayer.opacity = 0.3;
        self.dharmaIdolLayer.transform = CATransform3DMakeScale(2.2, 2.2, 1.0);
        absorbText = @"Đại Thừa viên mãn, tiếu ngạo nhân gian.";
    } else if (majorLevel >= 9 && majorLevel <= 10) {
        auraColor = [UIColor cyanColor];
        qiBirthRate = 450.0;
        self.cloudLayer.opacity = 1.0;
        self.arrayContainer.transform = CGAffineTransformMakeScale(1.3, 1.3);

        CAKeyframeAnimation *storm = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        if (majorLevel == 10) {
            storm.values = @[@0, @1, @0, @0.9, @0];
            storm.keyTimes = @[@0, @0.1, @0.2, @0.3, @1.0];
            storm.duration = 0.5;
            absorbText = @"Cửu Trọng Thiên Lôi giáng lâm! Sinh tử nhất niệm!";
        } else {
            storm.values = @[@0, @1, @0.2, @0.8, @0];
            storm.keyTimes = @[@0, @0.05, @0.1, @0.2, @1.0];
            storm.duration = 2.0;
            absorbText = @"Thiên địa biến sắc, chuẩn bị nghênh đón Lôi Kiếp.";
        }
        storm.repeatCount = HUGE_VALF;
        [self.lightningLayer addAnimation:storm forKey:@"stormFX"];
    } else if (majorLevel == 11) {
        auraColor = [UIColor colorWithRed:1.0 green:0.9 blue:0.6 alpha:1.0];
        qiBirthRate = 30.0;
        self.arrayContainer.alpha = 0.0;
        self.ascensionContainer.alpha = 1.0;
        self.monkHandsLayer.fillColor = [[UIColor colorWithRed:1.0 green:0.9 blue:0.6 alpha:0.8] CGColor];

        cell.velocity = 50.0;
        cell.yAcceleration = -40.0;
        self.qiEmitter.emitterPosition = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0 + 80);
        self.qiEmitter.emitterSize = CGSizeMake(150, 20);
        self.qiEmitter.emitterShape = kCAEmitterLayerRectangle;

        absorbText = @"Bạch nhật phi thăng, vị liệt tiên ban.";
    }

    [CATransaction commit];

    self.monkLayer.shadowColor = auraColor.CGColor;
    if (majorLevel != 11) {
        for (CALayer *layer in self.spinLayerCW.layer.sublayers) {
            if ([layer isKindOfClass:[CAShapeLayer class]]) ((CAShapeLayer *)layer).strokeColor = auraColor.CGColor;
        }
        for (UIView *view in self.spinLayerCW.subviews) {
            if ([view isKindOfClass:[UILabel class]]) ((UILabel *)view).textColor = auraColor;
        }
        for (CALayer *layer in self.spinLayerCCW.layer.sublayers) {
            if ([layer isKindOfClass:[CAShapeLayer class]]) ((CAShapeLayer *)layer).strokeColor = auraColor.CGColor;
        }
    }

    self.statusLabel.layer.shadowColor = auraColor.CGColor;
    self.absorbingLabel.text = absorbText;

    cell.color = auraColor.CGColor;
    cell.birthRate = qiBirthRate;
    self.qiEmitter.emitterCells = @[cell];
}

- (void)processBreakthroughFrom:(CultivationStatus)oldStatus to:(CultivationStatus)newStatus {
    self.isBreakingThrough = YES;
    self.statusLabel.text = @"— ĐỘT PHÁ —";
    self.statusLabel.textColor = [UIColor yellowColor];

    UIImpactFeedbackGenerator *hap = [[UIImpactFeedbackGenerator alloc] initWithStyle:(newStatus.majorLevel >= 6) ? UIImpactFeedbackStyleHeavy : UIImpactFeedbackStyleMedium];
    [hap impactOccurred];

    int level = newStatus.majorLevel;

    if (level == 11) {
        [UIView animateWithDuration:1.0 animations:^{
            self.flashView.backgroundColor = [UIColor whiteColor];
            self.flashView.alpha = 1.0;
        } completion:^(BOOL finished) {
            [self applyRealmEffects:level];
            self.statusLabel.textColor = [UIColor colorWithRed:1.0 green:0.9 blue:0.6 alpha:1.0];
            self.statusLabel.text = @"PHI THĂNG\n· Đại Đạo Viên Mãn ·";

            [UIView animateWithDuration:3.0 animations:^{
                self.flashView.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.isBreakingThrough = NO;
            }];
        }];
        return;
    }

    CAEmitterCell *cell = [self.qiEmitter.emitterCells firstObject];
    cell.birthRate = 600.0;
    cell.velocity = -800.0;
    self.qiEmitter.emitterCells = @[cell];

    if (level >= 6) {
        CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
        shake.duration = 0.04;
        shake.repeatCount = (level >= 9) ? 40 : 15;
        shake.autoreverses = YES;
        shake.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x - 12, self.center.y)];
        shake.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x + 12, self.center.y)];
        [self.layer addAnimation:shake forKey:@"shake"];
    }

    [UIView animateWithDuration:1.5 animations:^{
        self.arrayContainer.transform = CGAffineTransformMakeScale(1.4, 1.4);
    } completion:^(BOOL finished) {
        self.flashView.backgroundColor = (level >= 9) ? [UIColor cyanColor] : (level == 4 ? [UIColor yellowColor] : [UIColor whiteColor]);
        [UIView animateWithDuration:0.2 animations:^{
            self.flashView.alpha = 0.95;
            self.arrayContainer.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [self applyRealmEffects:level];
            [UIView animateWithDuration:0.8 animations:^{
                self.flashView.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.statusLabel.textColor = [UIColor whiteColor];
                self.statusLabel.text = newStatus.subRealm.length > 0 ? [NSString stringWithFormat:@"%@\n· %@ ·", newStatus.realmName, newStatus.subRealm] : newStatus.realmName;
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

    [UIView animateWithDuration:0.9 animations:^{
        self.arrayContainer.transform = CGAffineTransformMakeScale(0.85, 0.85);
        self.monkLayer.opacity = 0.35;
        self.monkHandsLayer.opacity = 0.35;
    } completion:^(BOOL finished) {
        [self applyRealmEffects:newStatus.majorLevel];
        [UIView animateWithDuration:0.7 animations:^{
            self.arrayContainer.transform = CGAffineTransformIdentity;
            self.monkLayer.opacity = 1.0;
            self.monkHandsLayer.opacity = 1.0;
        } completion:^(BOOL finished) {
            self.statusLabel.textColor = [UIColor whiteColor];
            self.statusLabel.text = newStatus.subRealm.length > 0 ? [NSString stringWithFormat:@"%@\n· %@ ·", newStatus.realmName, newStatus.subRealm] : newStatus.realmName;
            self.isBreakingThrough = NO;
        }];
    }];
}

- (void)handleTestTap {
    if (self.isBreakingThrough) return;
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
        CultivationStatus st = getCultivationStatus(currentBattery);
        self.statusLabel.text = st.subRealm.length > 0 ? [NSString stringWithFormat:@"%@\n· %@ ·", st.realmName, st.subRealm] : st.realmName;
        return;
    }
    if (self.isBreakingThrough) return;

    CultivationStatus oldStatus = getCultivationStatus(self.lastBatteryLevel);
    CultivationStatus newStatus = getCultivationStatus(currentBattery);

    if (currentBattery >= 100) {
        if (oldStatus.majorLevel != 11) [self processBreakthroughFrom:oldStatus to:getCultivationStatus(100)];
        else self.statusLabel.text = @"PHI THĂNG\n· Đại Đạo Viên Mãn ·";
        self.lastBatteryLevel = currentBattery;
        return;
    }

    BOOL changed = ![oldStatus.subRealm isEqualToString:newStatus.subRealm]
                 || oldStatus.majorLevel != newStatus.majorLevel;

    if (changed) {
        if (newStatus.majorLevel > oldStatus.majorLevel) {
            [self processBreakthroughFrom:oldStatus to:newStatus];
        } else if (newStatus.majorLevel < oldStatus.majorLevel) {
            [self processRealmDropFrom:oldStatus to:newStatus];
        } else {
            [self processBreakthroughFrom:oldStatus to:newStatus];
        }
    } else {
        self.statusLabel.text = newStatus.subRealm.length > 0 ? [NSString stringWithFormat:@"%@\n· %@ ·", newStatus.realmName, newStatus.subRealm] : newStatus.realmName;
    }
    self.lastBatteryLevel = currentBattery;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hit = [super hitTest:point withEvent:event];
    if (hit == self.testButton) return hit;
    if (hit == self) return nil;
    return hit;
}

@end

static TMCCultivationView *cultivationView = nil;

%hook CSCoverSheetViewController

- (void)viewWillAppear:(BOOL)animated {
    %orig;
    UIDevice *device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(tmc_handleBatteryNotification:)
        name:UIDeviceBatteryLevelDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(tmc_handleBatteryNotification:)
        name:UIDeviceBatteryStateDidChangeNotification object:nil];

    dispatch_async(dispatch_get_main_queue(), ^{
        UIDevice *d = [UIDevice currentDevice];
        if (d.batteryState == UIDeviceBatteryStateCharging || d.batteryState == UIDeviceBatteryStateFull) {
            if (!cultivationView) {
                cultivationView = [[TMCCultivationView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                [self.view addSubview:cultivationView];
                [self.view bringSubviewToFront:cultivationView];
                [cultivationView updateTuVi:(int)(d.batteryLevel * 100)];
            }
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
}

- (void)tmc_handleBatteryNotification:(NSNotification *)note {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIDevice *device = [UIDevice currentDevice];
        if (!cultivationView) {
            if (device.batteryState == UIDeviceBatteryStateCharging ||
                device.batteryState == UIDeviceBatteryStateFull) {
                cultivationView = [[TMCCultivationView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                [self.view addSubview:cultivationView];
                [self.view bringSubviewToFront:cultivationView];
                [cultivationView updateTuVi:(int)(device.batteryLevel * 100)];
            }
        } else {
            if (device.batteryState == UIDeviceBatteryStateUnplugged) {
                [UIView animateWithDuration:0.4 animations:^{
                    cultivationView.alpha = 0;
                } completion:^(BOOL finished) {
                    [cultivationView removeFromSuperview];
                    cultivationView = nil;
                }];
            } else {
                [cultivationView updateTuVi:(int)(device.batteryLevel * 100)];
            }
        }
    });
}

%end
