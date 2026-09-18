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

// ==========================================
// INTERFACE
// ==========================================
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

// Tối ưu hóa: Dùng Emitter phần cứng thay vì Timer vẽ UIView gây Crash RAM
@property (nonatomic, strong) CAEmitterLayer *qiEmitter;
@property (nonatomic, strong) CAEmitterLayer *ascensionEmitter;

@end

// ==========================================
// IMPLEMENTATION
// ==========================================
@implementation TMCCultivationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES; // Để nhận nút Test

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

        // ============ TU SĨ ============
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
        self.goldenCoreLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-14, -14, 28, 28)].CGPath;
        self.goldenCoreLayer.fillColor = [UIColor colorWithRed:1.0 green:0.85 blue:0.15 alpha:1.0].CGColor;
        self.goldenCoreLayer.position = CGPointMake(centerX, centerY + 20);
        self.goldenCoreLayer.shadowColor = [UIColor yellowColor].CGColor;
        self.goldenCoreLayer.shadowRadius = 30.0;
        self.goldenCoreLayer.shadowOpacity = 1.0;
        self.goldenCoreLayer.shadowOffset = CGSizeZero;
        self.goldenCoreLayer.opacity = 0.0;
        [self.layer addSublayer:self.goldenCoreLayer];

        // KHỞI TẠO HỆ THỐNG HẠT PHẦN CỨNG (KHÔNG GÂY CRASH)
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

        self.testMilestones = @[@10, @14, @18, @24, @30, @40, @55, @70, @85, @97, @100];
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

// Hàm dọn dẹp chống rò rỉ bộ nhớ
- (void)removeFromSuperview {
    [self.qiEmitter removeFromSuperlayer];
    [self.ascensionEmitter removeFromSuperlayer];
    [super removeFromSuperview];
}

// ==========================================
// VẼ SILHOUETTE TU SĨ
// ==========================================
- (CAShapeLayer *)createSlimMonkPathWithSize:(CGFloat)size {
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat s = size / 100.0;
    [path moveToPoint:CGPointMake(0, -50*s)];
    // NỬA TRÁI
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
    // NỬA PHẢI
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

    // KHOÉT 2 BÀN TAY
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

// ==========================================
// VẼ TRẬN PHÁP VÀ MÔI TRƯỜNG
// ==========================================
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
    self.spaceFragmentsLayer.fillColor = [[UIColor purpleColor] colorWithAlphaComponent:0.7].CGColor;
    self.spaceFragmentsLayer.strokeColor = [UIColor cyanColor].CGColor;
    self.spaceFragmentsLayer.lineWidth = 1.0;
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
    CABasicAnimation *orbit = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    orbit.toValue = @(M_PI * 2.0);
    orbit.duration = 10.0;
    orbit.repeatCount = HUGE_VALF;
    [self.lawsLayer.layer addAnimation:orbit forKey:@"orbitLaws"];
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

// ==========================================
// THIẾT LẬP HỆ THỐNG HẠT PHẦN CỨNG (SỬA LỖI TRÀN RAM)
// ==========================================
- (void)setupEmitters:(CGPoint)targetCenter {
    // 1. Emitter hút Linh Khí (Cho cảnh giới 1 - 10)
    self.qiEmitter = [CAEmitterLayer layer];
    CGFloat radius = MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) + 50;
    self.qiEmitter.emitterPosition = targetCenter;
    self.qiEmitter.emitterSize = CGSizeMake(radius, radius);
    self.qiEmitter.emitterShape = kCAEmitterLayerCircle;
    self.qiEmitter.emitterMode = kCAEmitterLayerOutline;
    self.qiEmitter.renderMode = kCAEmitterLayerAdditive;

    CAEmitterCell *qiCell = [CAEmitterCell emitterCell];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(4, 4), NO, 0);
    [[UIColor whiteColor] setFill];
    [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 4, 4)] fill];
    UIImage *qiDot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    qiCell.contents = (id)qiDot.CGImage;
    qiCell.birthRate = 0;
    qiCell.lifetime = 2.0;
    qiCell.velocity = -250.0;
    qiCell.velocityRange = 50.0;
    qiCell.emissionRange = M_PI * 2.0;
    qiCell.alphaSpeed = -0.4;
    qiCell.scale = 0.8;
    self.qiEmitter.emitterCells = @[qiCell];
    [self.layer insertSublayer:self.qiEmitter below:self.arrayContainer.layer];

    // 2. Emitter Tiên Khí bay lên (Cho Phi Thăng)
    self.ascensionEmitter = [CAEmitterLayer layer];
    self.ascensionEmitter.emitterPosition = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height + 50);
    self.ascensionEmitter.emitterSize = CGSizeMake(self.bounds.size.width, 10);
    self.ascensionEmitter.emitterShape = kCAEmitterLayerLine;

    CAEmitterCell *ascCell = [CAEmitterCell emitterCell];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(6, 6), NO, 0);
    [[UIColor colorWithRed:1.0 green:0.9 blue:0.6 alpha:1.0] setFill];
    [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 6, 6)] fill];
    UIImage *ascDot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    ascCell.contents = (id)ascDot.CGImage;
    ascCell.birthRate = 0; // Sẽ bật khi Phi Thăng
    ascCell.lifetime = 4.0;
    ascCell.velocity = -100.0; // Bay lên trên
    ascCell.velocityRange = 30.0;
    ascCell.emissionLongitude = 0; // Thẳng lên
    ascCell.emissionRange = M_PI_4;
    ascCell.alphaSpeed = -0.2;
    ascCell.scale = 1.0;
    ascCell.scaleRange = 0.5;
    
    // Thêm shadow cho hạt tiên
    self.ascensionEmitter.shadowColor = [UIColor yellowColor].CGColor;
    self.ascensionEmitter.shadowRadius = 8.0;
    self.ascensionEmitter.shadowOpacity = 1.0;
    self.ascensionEmitter.shadowOffset = CGSizeZero;
    
    self.ascensionEmitter.emitterCells = @[ascCell];
    [self.layer insertSublayer:self.ascensionEmitter below:self.ascensionContainer.layer];
}

// Hàm dọn dẹp sạch sẽ mọi animation (FIX KẸT HIỆU ỨNG)
- (void)clearAllAnimationsAndRealms {
    [self.layer removeAllAnimations];
    [self.monkLayer removeAllAnimations];
    [self.robeLinesLayer removeAllAnimations];
    [self.goldenCoreLayer removeAllAnimations];
    [self.nascentSoulLayer removeAllAnimations];
    [self.dharmaIdolLayer removeAllAnimations];
    [self.lightningLayer removeAllAnimations];
    [self.spaceFragmentsLayer removeAllAnimations];
    [self.arrayContainer.layer removeAllAnimations];
    [self.flashView.layer removeAllAnimations];
    
    NSMutableArray *toRemove = [NSMutableArray array];
    for (CALayer *l in self.layer.sublayers) {
        if ([l.name hasPrefix:@"halo"]) [toRemove addObject:l];
    }
    for (CALayer *l in toRemove) [l removeFromSuperlayer];

    self.monkLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2 - 20);
    self.robeLinesLayer.position = self.monkLayer.position;
}

// ==========================================
// APPLY REALM EFFECTS
// ==========================================
- (void)applyRealmEffects:(int)majorLevel {
    UIColor *auraColor = [UIColor clearColor];
    float qiBirthRate = 0;
    float ascBirthRate = 0;
    NSString *absorbText = @"";
    NSString *statusText = @"";

    [CATransaction begin];
    [CATransaction setDisableActions:YES];

    [self clearAllAnimationsAndRealms];

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
    self.lightningLayer.opacity = 0.0;
    self.arrayContainer.transform = CGAffineTransformIdentity;
    self.arrayContainer.alpha = 1.0;
    self.monkLayer.opacity = 1.0;
    self.robeLinesLayer.opacity = 1.0;
    self.monkLayer.strokeColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9].CGColor;
    self.robeLinesLayer.strokeColor = [[UIColor whiteColor] colorWithAlphaComponent:0.85].CGColor;
    self.monkLayer.shadowColor = [UIColor cyanColor].CGColor;
    self.monkLayer.shadowRadius = 12.0;

    for (UIView *v in self.lawsLayer.subviews) {
        if ([v isKindOfClass:[UILabel class]]) ((UILabel *)v).textColor = [UIColor redColor];
    }

    CAEmitterCell *qiCell = [self.qiEmitter.emitterCells firstObject];
    qiCell.yAcceleration = 0;
    qiCell.velocity = -250.0;
    
    switch (majorLevel) {
        case 0:
            auraColor = [UIColor colorWithWhite:0.4 alpha:1.0];
            qiBirthRate = 0;
            self.arrayContainer.alpha = 0.15;
            statusText = @"CHƯA NHẬP ĐẠO";
            absorbText = @"Thể chất phàm nhân, chưa thể hấp thu linh khí.";
            break;

        case 1:
            auraColor = [UIColor lightGrayColor];
            qiBirthRate = 25.0;
            self.arrayContainer.alpha = 0.35;
            statusText = @"PHÀM NHÂN";
            absorbText = @"Tụ khí tẩy tủy, bắt đầu cảm nhận linh khí.";
            break;

        case 2:
            auraColor = [UIColor colorWithRed:0.6 green:0.9 blue:1.0 alpha:1.0];
            qiBirthRate = 60.0;
            self.arrayContainer.alpha = 0.7;
            statusText = @"LUYỆN KHÍ";
            absorbText = @"Linh khí vận chuyển quanh thân thể, kinh mạch khai thông.";
            break;

        case 3:
            auraColor = [UIColor colorWithRed:0.3 green:0.8 blue:1.0 alpha:1.0];
            qiBirthRate = 100.0;
            self.daoMarkLayer.opacity = 1.0;
            statusText = @"TRÚC CƠ";
            absorbText = @"Đạo cơ đúc thành, linh lực ngưng thực, đạo vận quanh thân.";
            break;

        case 4: {
            auraColor = [UIColor colorWithRed:1.0 green:0.85 blue:0.15 alpha:1.0];
            qiBirthRate = 180.0;
            self.goldenCoreLayer.opacity = 1.0;

            CABasicAnimation *coreRotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            coreRotate.toValue = @(M_PI * 2.0);
            coreRotate.duration = 3.0;
            coreRotate.repeatCount = HUGE_VALF;
            [self.goldenCoreLayer addAnimation:coreRotate forKey:@"coreRotate"];

            CABasicAnimation *corePulse = [CABasicAnimation animationWithKeyPath:@"opacity"];
            corePulse.fromValue = @0.5;
            corePulse.toValue = @1.0;
            corePulse.duration = 0.8;
            corePulse.autoreverses = YES;
            corePulse.repeatCount = HUGE_VALF;
            [self.goldenCoreLayer addAnimation:corePulse forKey:@"corePulse"];

            self.daoMarkLayer.opacity = 0.9;
            self.daoMarkLayer.lineWidth = 3.5;
            statusText = @"KIM ĐAN";
            absorbText = @"Ngưng tụ Kim Đan, thọ nguyên tăng mạnh, pháp lực bừng nở.";
            break;
        }

        case 5: {
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
            soulPulse.fromValue = @0.6;
            soulPulse.toValue = @1.0;
            soulPulse.duration = 1.2;
            soulPulse.autoreverses = YES;
            soulPulse.repeatCount = HUGE_VALF;
            [self.nascentSoulLayer addAnimation:soulPulse forKey:@"soulPulse"];

            statusText = @"NGUYÊN ANH";
            absorbText = @"Đan vỡ sinh Anh, thần hồn cường đại, ngưng tụ Nguyên Anh.";
            break;
        }

        case 6: {
            auraColor = [UIColor colorWithRed:1.0 green:0.25 blue:0.8 alpha:1.0];
            qiBirthRate = 320.0;
            self.nascentSoulLayer.opacity = 0.9;
            self.nascentSoulLayer.shadowColor = auraColor.CGColor;

            self.dharmaIdolLayer.strokeColor = auraColor.CGColor;
            self.dharmaIdolLayer.opacity = 0.75;
            self.dharmaIdolLayer.transform = CATransform3DMakeScale(1.7, 1.7, 1.0);

            CABasicAnimation *dharmaPulse = [CABasicAnimation animationWithKeyPath:@"opacity"];
            dharmaPulse.fromValue = @0.4;
            dharmaPulse.toValue = @0.9;
            dharmaPulse.duration = 1.5;
            dharmaPulse.autoreverses = YES;
            dharmaPulse.repeatCount = HUGE_VALF;
            [self.dharmaIdolLayer addAnimation:dharmaPulse forKey:@"dharmaPulse"];

            statusText = @"HÓA THẦN";
            absorbText = @"Thần thức bao trùm, thiên địa giao cảm, pháp tướng hiển thế.";
            break;
        }

        case 7: {
            auraColor = [UIColor colorWithRed:0.65 green:0.1 blue:0.9 alpha:1.0];
            qiBirthRate = 380.0;
            self.backgroundLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.55];
            self.spaceFragmentsLayer.opacity = 1.0;
            qiCell.yAcceleration = 80.0;

            UIBezierPath *frags = [UIBezierPath bezierPath];
            CGFloat cx = self.bounds.size.width/2;
            CGFloat cy = self.bounds.size.height/2 - 20;
            for (int i = 0; i < 30; i++) {
                CGFloat angle = (i / 30.0) * M_PI * 2 + ((arc4random_uniform(100) - 50) / 100.0);
                CGFloat r = 130 + arc4random_uniform(60);
                CGFloat x = cx + cos(angle) * r;
                CGFloat y = cy + sin(angle) * r;
                [frags moveToPoint:CGPointMake(x, y)];
                [frags addLineToPoint:CGPointMake(x + 22, y - 10)];
                [frags addLineToPoint:CGPointMake(x + 14, y + 18)];
                [frags closePath];
            }
            self.spaceFragmentsLayer.path = frags.CGPath;
            self.spaceFragmentsLayer.fillColor = [[UIColor purpleColor] colorWithAlphaComponent:0.85].CGColor;
            self.spaceFragmentsLayer.strokeColor = [UIColor cyanColor].CGColor;

            CABasicAnimation *fragSpin = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            fragSpin.fromValue = @0;
            fragSpin.toValue = @(M_PI * 2);
            fragSpin.duration = 15.0;
            fragSpin.repeatCount = HUGE_VALF;
            [self.spaceFragmentsLayer addAnimation:fragSpin forKey:@"fragSpin"];

            CABasicAnimation *fragPulse = [CABasicAnimation animationWithKeyPath:@"opacity"];
            fragPulse.fromValue = @0.3;
            fragPulse.toValue = @1.0;
            fragPulse.duration = 0.6;
            fragPulse.autoreverses = YES;
            fragPulse.repeatCount = HUGE_VALF;
            [self.spaceFragmentsLayer addAnimation:fragPulse forKey:@"fragPulse"];

            statusText = @"LUYỆN HƯ";
            absorbText = @"Không gian phá toái, nắm giữ hư vô, uy áp chấn động.";
            break;
        }

        case 8: {
            auraColor = [UIColor redColor];
            qiBirthRate = 450.0;
            self.arrayContainer.transform = CGAffineTransformMakeScale(1.25, 1.25);
            self.lawsLayer.alpha = 1.0;

            self.dharmaIdolLayer.strokeColor = auraColor.CGColor;
            self.dharmaIdolLayer.opacity = 0.6;
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

            statusText = @"ĐẠI THỪA";
            absorbText = @"Đại Thừa viên mãn, pháp tắc hiển hóa, tiếu ngạo nhân gian.";
            break;
        }

        case 9: {
            auraColor = [UIColor cyanColor];
            qiBirthRate = 550.0;
            self.cloudLayer.opacity = 1.0;
            self.arrayContainer.transform = CGAffineTransformMakeScale(1.35, 1.35);

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

            statusText = @"ĐỘ KIẾP";
            absorbText = @"Thiên địa biến sắc, mây đen vần vũ, chuẩn bị đón Lôi Kiếp.";
            break;
        }

        case 10: {
            auraColor = [UIColor cyanColor];
            qiBirthRate = 700.0;
            self.cloudLayer.opacity = 1.0;
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

            statusText = @"ĐỘ KIẾP · THIÊN KIẾP";
            absorbText = @"Cửu Trọng Thiên Lôi giáng lâm! Sinh tử nhất niệm!";
            break;
        }

        case 11: {
            auraColor = [UIColor colorWithRed:1.0 green:0.9 blue:0.6 alpha:1.0];
            qiBirthRate = 0;
            ascBirthRate = 25.0; // Bật hạt tiên khí bay lên
            
            self.arrayContainer.alpha = 0.0;
            self.ascensionContainer.alpha = 1.0;

            self.monkLayer.strokeColor = [[UIColor colorWithRed:1.0 green:0.9 blue:0.6 alpha:1.0] CGColor];
            self.robeLinesLayer.strokeColor = [[UIColor colorWithRed:1.0 green:0.9 blue:0.6 alpha:0.95] CGColor];
            self.monkLayer.shadowColor = [UIColor yellowColor].CGColor;
            self.monkLayer.shadowRadius = 45.0;

            CGFloat targetY = self.bounds.size.height * 0.4;
            
            // Bay lên an toàn bằng CABasicAnimation
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

            statusText = @"PHI THĂNG";
            absorbText = @"Bạch nhật phi thăng, vị liệt tiên ban, đại đạo viên mãn.";
            break;
        }
    }

    [CATransaction commit];

    // Cập nhật Emitters
    qiCell.color = auraColor.CGColor;
    self.qiEmitter.emitterCells = @[qiCell]; // Update settings
    self.qiEmitter.birthRate = qiBirthRate; // Trigger birthrate layer level
    
    CAEmitterCell *ascCell = [self.ascensionEmitter.emitterCells firstObject];
    self.ascensionEmitter.emitterCells = @[ascCell];
    self.ascensionEmitter.birthRate = ascBirthRate;

    // Đổi màu trận pháp vòng ngoài
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
    
    // Nếu text đột phá trống thì mới update text chuẩn
    if (!self.isBreakingThrough) {
        CultivationStatus st = getCultivationStatus(self.lastBatteryLevel);
        self.statusLabel.text = st.subRealm.length > 0 ? [NSString stringWithFormat:@"%@\n· %@ ·", st.realmName, st.subRealm] : st.realmName;
    }
}

// ==========================================
// ĐỘT PHÁ & THOÁI CẢNH GIỚI (CÓ BẢO VỆ CHỐNG SPAM)
// ==========================================
- (void)processBreakthroughFrom:(CultivationStatus)oldStatus to:(CultivationStatus)newStatus {
    self.isBreakingThrough = YES;
    self.statusLabel.text = @"— ĐỘT PHÁ —";
    self.statusLabel.textColor = [UIColor yellowColor];

    UIImpactFeedbackGenerator *hap = [[UIImpactFeedbackGenerator alloc] initWithStyle:(newStatus.majorLevel >= 6) ? UIImpactFeedbackStyleHeavy : UIImpactFeedbackStyleMedium];
    [hap impactOccurred];

    int level = newStatus.majorLevel;
    int expectedBattery = self.lastBatteryLevel; // Khóa mục tiêu để kiểm tra sau

    if (level == 11) {
        [UIView animateWithDuration:0.5 animations:^{
            self.flashView.backgroundColor = [UIColor whiteColor];
            self.flashView.alpha = 1.0;
        } completion:^(BOOL finished) {
            if (self.lastBatteryLevel != expectedBattery) return; // Hủy nếu user spam nút quá nhanh
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
        if (self.lastBatteryLevel != expectedBattery) { self.isBreakingThrough = NO; return; }
        
        [UIView animateWithDuration:0.2 animations:^{
            self.flashView.alpha = 0.95;
            self.arrayContainer.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (self.lastBatteryLevel != expectedBattery) { self.isBreakingThrough = NO; return; }
            
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
    int expectedBattery = self.lastBatteryLevel;

    UIImpactFeedbackGenerator *hap = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
    [hap impactOccurred];

    [UIView animateWithDuration:0.4 animations:^{
        self.arrayContainer.transform = CGAffineTransformMakeScale(0.85, 0.85);
        self.monkLayer.opacity = 0.35;
        self.robeLinesLayer.opacity = 0.35;
    } completion:^(BOOL finished) {
        if (self.lastBatteryLevel != expectedBattery) { self.isBreakingThrough = NO; return; }
        
        [self applyRealmEffects:newStatus.majorLevel];
        self.statusLabel.text = newStatus.subRealm.length > 0 ? [NSString stringWithFormat:@"%@\n· %@ ·", newStatus.realmName, newStatus.subRealm] : newStatus.realmName;

        [UIView animateWithDuration:0.4 animations:^{
            self.arrayContainer.transform = CGAffineTransformIdentity;
            self.monkLayer.opacity = 1.0;
            self.robeLinesLayer.opacity = 1.0;
        } completion:^(BOOL finished) {
            self.statusLabel.textColor = [UIColor whiteColor];
            self.isBreakingThrough = NO;
        }];
    }];
}

// ==========================================
// NÚT TEST — SPAM THOẢI MÁI KHÔNG LỖI
// ==========================================
- (void)handleTestTap {
    // Ép dọn dẹp các luồng đột phá cũ nếu user spam nút
    if (self.isBreakingThrough) {
        [self clearAllAnimationsAndRealms];
        self.flashView.alpha = 0.0;
        self.isBreakingThrough = NO;
    }

    int fakeBattery = [self.testMilestones[self.testIndex] intValue];
    self.lastBatteryLevel = fakeBattery - 1;
    [self updateTuVi:fakeBattery];

    self.testIndex++;
    if (self.testIndex >= self.testMilestones.count) self.testIndex = 0;
}

// ==========================================
// UPDATE THEO PIN
// ==========================================
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

// Chỉ nút test được nhận cảm ứng
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
// HOOK LOCK SCREEN - THÊM %new LÀ HẾT CRASH
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
            NSLog(@"[TMC_SAFE] EXCEPTION: %@", e);
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
        [cultivationView removeFromSuperview]; // Hàm này ta đã viết đè ở trên để xóa hạt
        cultivationView = nil;
    }
    UIView *v = [self.view viewWithTag:kTMCTag];
    if (v) [v removeFromSuperview];
}

// ĐÂY LÀ CHÌA KHÓA: Phải có %new để khai báo thêm Method mới, nếu không sẽ văng Safe Mode!
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
        @catch (NSException *e) {
            NSLog(@"[TMC_SAFE] EXCEPTION: %@", e);
        }
    });
}

%end
