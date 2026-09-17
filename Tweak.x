#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import <math.h>

@interface CSCoverSheetViewController : UIViewController
@end
@interface SBUIController : NSObject
@end

// --- HỆ THỐNG CẢNH GIỚI CHUẨN XÁC ---
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

// --- VIEW TU LUYỆN ĐỈNH CAO ---
@interface TMCCultivationView : UIView
@property (nonatomic, strong) UIView *backgroundLayer;
@property (nonatomic, strong) CAShapeLayer *cloudLayer;
@property (nonatomic, strong) CAShapeLayer *lightningLayer;
@property (nonatomic, strong) UIView *arrayContainer;
@property (nonatomic, strong) UIView *spinLayerCW;
@property (nonatomic, strong) UIView *spinLayerCCW;
@property (nonatomic, strong) CAShapeLayer *daoMarkLayer; 
@property (nonatomic, strong) CAShapeLayer *dharmaIdolLayer; 
@property (nonatomic, strong) CAShapeLayer *monkLayer; 
@property (nonatomic, strong) CAShapeLayer *goldenCoreLayer; 
@property (nonatomic, strong) CAEmitterLayer *qiEmitter;
@property (nonatomic, strong) UIView *flashView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *absorbingLabel;
@property (nonatomic, assign) int lastBatteryLevel;
@property (nonatomic, assign) BOOL isBreakingThrough;

// Test Tool
@property (nonatomic, strong) UIButton *testButton;
@property (nonatomic, strong) NSArray *testMilestones;
@property (nonatomic, assign) int testIndex;
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
        self.backgroundLayer.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backgroundLayer];

        // 1. MÂY ĐEN & TIA SÉT ĐA NHÁNH
        [self drawClouds];
        [self drawMultiBranchLightning];
        
        self.flashView = [[UIView alloc] initWithFrame:frame];
        self.flashView.backgroundColor = [UIColor whiteColor];
        self.flashView.alpha = 0.0;
        [self addSubview:self.flashView];

        // 2. TRẬN PHÁP SIÊU DÀY & PHỨC TẠP
        self.arrayContainer = [[UIView alloc] initWithFrame:CGRectMake(centerX - 140, centerY - 140, 280, 280)];
        [self addSubview:self.arrayContainer];
        [self drawUltimateBaguaArray];

        // 3. PHÁP TƯỚNG
        self.dharmaIdolLayer = [self createMonkVectorPathWithSize:220];
        self.dharmaIdolLayer.position = CGPointMake(centerX, centerY - 20);
        self.dharmaIdolLayer.fillColor = [UIColor clearColor].CGColor;
        self.dharmaIdolLayer.opacity = 0.0; 
        [self.layer addSublayer:self.dharmaIdolLayer];

        // 4. NHÂN VẬT TU SĨ CỔ TRANG CHUẨN XÁC
        self.monkLayer = [self createMonkVectorPathWithSize:110];
        self.monkLayer.position = CGPointMake(centerX, centerY);
        self.monkLayer.fillColor = [UIColor blackColor].CGColor; 
        self.monkLayer.shadowColor = [UIColor cyanColor].CGColor;
        self.monkLayer.shadowRadius = 12.0;
        self.monkLayer.shadowOpacity = 1.0;
        [self.layer addSublayer:self.monkLayer];

        // 5. KIM ĐAN
        self.goldenCoreLayer = [CAShapeLayer layer];
        self.goldenCoreLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-8, 5, 16, 16)].CGPath;
        self.goldenCoreLayer.fillColor = [UIColor colorWithRed:1.0 green:0.9 blue:0.2 alpha:1.0].CGColor;
        self.goldenCoreLayer.position = CGPointMake(centerX, centerY + 18);
        self.goldenCoreLayer.shadowColor = [UIColor yellowColor].CGColor;
        self.goldenCoreLayer.shadowRadius = 10.0;
        self.goldenCoreLayer.shadowOpacity = 1.0;
        self.goldenCoreLayer.opacity = 0.0; 
        [self.layer addSublayer:self.goldenCoreLayer];

        // 6. LINH KHÍ 4 PHƯƠNG TÁM HƯỚNG
        [self setupQiEmitter:CGPointMake(centerX, centerY)];

        // 7. CHỮ CẢNH GIỚI VÀ DÒNG TRẠNG THÁI
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(centerX - 160, centerY + 140, 320, 50)];
        self.statusLabel.numberOfLines = 2;
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        self.statusLabel.textColor = [UIColor whiteColor];
        self.statusLabel.font = [UIFont boldSystemFontOfSize:18];
        self.statusLabel.layer.shadowRadius = 6.0;
        self.statusLabel.layer.shadowOpacity = 1.0;
        [self addSubview:self.statusLabel];

        self.absorbingLabel = [[UILabel alloc] initWithFrame:CGRectMake(centerX - 150, centerY + 195, 300, 20)];
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

        // 8. NÚT TEST CHUẨN MỐC
        self.testMilestones = @[@10, @13, @16, @21, @28, @37, @49, @63, @80, @95, @100];
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

// --- THUẬT TOÁN VẼ ĐỈNH CAO ---

- (void)drawUltimateBaguaArray {
    self.spinLayerCW = [[UIView alloc] initWithFrame:self.arrayContainer.bounds];
    self.spinLayerCCW = [[UIView alloc] initWithFrame:self.arrayContainer.bounds];
    [self.arrayContainer addSubview:self.spinLayerCW];
    [self.arrayContainer addSubview:self.spinLayerCCW];
    
    // 1. Vòng ngoài cùng siêu dày
    CAShapeLayer *outerThick = [CAShapeLayer layer];
    outerThick.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(10, 10, 260, 260)].CGPath;
    outerThick.fillColor = [UIColor clearColor].CGColor;
    outerThick.strokeColor = [UIColor cyanColor].CGColor;
    outerThick.lineWidth = 5.0; 
    [self.spinLayerCW.layer addSublayer:outerThick];

    // 2. Bát Quái
    NSArray *bagua = @[@"☰", @"☱", @"☲", @"☳", @"☴", @"☵", @"☶", @"☷"];
    for (int i = 0; i < 8; i++) {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        lbl.center = CGPointMake(140, 140);
        lbl.text = bagua[i];
        lbl.textColor = [UIColor cyanColor];
        lbl.font = [UIFont boldSystemFontOfSize:22];
        lbl.textAlignment = NSTextAlignmentCenter;
        CGAffineTransform t = CGAffineTransformMakeRotation(i * (M_PI / 4.0));
        t = CGAffineTransformTranslate(t, 0, -112);
        lbl.transform = t;
        [self.spinLayerCW addSubview:lbl];
    }
    
    // 3. Tinh Đồ 12 Cánh
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

    // 4. Đạo Văn Trúc Cơ
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

// Vẽ Silhouette Tu sĩ bám sát hoàn toàn image_14.png
- (CAShapeLayer *)createMonkVectorPathWithSize:(CGFloat)size {
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat s = size / 100.0; 
    
    [path addArcWithCenter:CGPointMake(0, -42*s) radius:6*s startAngle:0 endAngle:M_PI*2 clockwise:YES];
    
    [path moveToPoint:CGPointMake(0, -36*s)];
    [path addQuadCurveToPoint:CGPointMake(10*s, -22*s) controlPoint:CGPointMake(12*s, -32*s)];
    [path addQuadCurveToPoint:CGPointMake(5*s, -14*s) controlPoint:CGPointMake(10*s, -18*s)];
    [path addQuadCurveToPoint:CGPointMake(-5*s, -14*s) controlPoint:CGPointMake(0, -12*s)]; 
    [path addQuadCurveToPoint:CGPointMake(-10*s, -22*s) controlPoint:CGPointMake(-10*s, -18*s)];
    [path addQuadCurveToPoint:CGPointMake(0, -36*s) controlPoint:CGPointMake(-12*s, -32*s)];
    
    [path moveToPoint:CGPointMake(-6*s, -14*s)];
    [path addLineToPoint:CGPointMake(-10*s, -8*s)]; 
    [path addQuadCurveToPoint:CGPointMake(-35*s, 8*s) controlPoint:CGPointMake(-25*s, -8*s)]; 
    
    [path addQuadCurveToPoint:CGPointMake(-50*s, 25*s) controlPoint:CGPointMake(-45*s, 15*s)];
    [path addQuadCurveToPoint:CGPointMake(-60*s, 35*s) controlPoint:CGPointMake(-55*s, 30*s)];
    
    [path addQuadCurveToPoint:CGPointMake(-45*s, 38*s) controlPoint:CGPointMake(-55*s, 42*s)]; 
    [path addLineToPoint:CGPointMake(-35*s, 30*s)]; 
    
    [path addQuadCurveToPoint:CGPointMake(0, 48*s) controlPoint:CGPointMake(-20*s, 50*s)]; 
    
    [path addQuadCurveToPoint:CGPointMake(35*s, 30*s) controlPoint:CGPointMake(20*s, 50*s)]; 
    
    [path addLineToPoint:CGPointMake(45*s, 38*s)]; 
    [path addQuadCurveToPoint:CGPointMake(60*s, 35*s) controlPoint:CGPointMake(55*s, 42*s)]; 
    
    [path addQuadCurveToPoint:CGPointMake(50*s, 25*s) controlPoint:CGPointMake(55*s, 30*s)];
    [path addQuadCurveToPoint:CGPointMake(35*s, 8*s) controlPoint:CGPointMake(45*s, 15*s)];
    
    [path addQuadCurveToPoint:CGPointMake(10*s, -8*s) controlPoint:CGPointMake(25*s, -8*s)]; 
    [path addLineToPoint:CGPointMake(6*s, -14*s)]; 
    [path closePath];
    
    [path moveToPoint:CGPointMake(-55*s, 40*s)];
    [path addQuadCurveToPoint:CGPointMake(55*s, 40*s) controlPoint:CGPointMake(0, 60*s)];
    [path addQuadCurveToPoint:CGPointMake(-55*s, 40*s) controlPoint:CGPointMake(0, 30*s)];
    
    layer.path = path.CGPath;
    return layer;
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
    self.cloudLayer.fillColor = [[UIColor blackColor] colorWithAlphaComponent:0.85].CGColor;
    self.cloudLayer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.cloudLayer.shadowRadius = 25.0;
    self.cloudLayer.shadowOpacity = 1.0;
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
    [lightning addLineToPoint:CGPointMake(w/2 + 10, h/2)];
    [lightning addLineToPoint:CGPointMake(w/2 - 40, 3*h/4)];
    [lightning addLineToPoint:CGPointMake(w/2 + 20, h)];
    
    [lightning moveToPoint:CGPointMake(w/2 - 30, h/4)];
    [lightning addLineToPoint:CGPointMake(w/4 - 10, h/2 - 30)];
    [lightning addLineToPoint:CGPointMake(w/4 - 50, 2*h/3)];
    
    [lightning moveToPoint:CGPointMake(w/2 + 10, h/2)];
    [lightning addLineToPoint:CGPointMake(3*w/4 + 20, 2*h/3 + 20)];
    [lightning addLineToPoint:CGPointMake(3*w/4 + 40, h)];
    
    [lightning moveToPoint:CGPointMake(w/2 + 20, 0)];
    [lightning addLineToPoint:CGPointMake(3*w/4 + 10, h/5)];
    
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

// --- LOGIC ĐẶC TRƯNG TỪNG CẢNH GIỚI (ĐÃ FIX LỖI ĐỔI MÀU) ---
- (void)applyRealmEffects:(int)majorLevel {
    UIColor *auraColor = [UIColor clearColor];
    float qiBirthRate = 0;
    NSString *absorbText = @"Đang hấp thu thiên địa linh khí...";
    
    self.goldenCoreLayer.opacity = 0.0;
    self.dharmaIdolLayer.opacity = 0.0;
    self.daoMarkLayer.opacity = 0.0;
    self.cloudLayer.opacity = 0.0;
    self.backgroundLayer.backgroundColor = [UIColor clearColor];
    [self.lightningLayer removeAnimationForKey:@"storm"];
    self.lightningLayer.opacity = 0.0;
    self.arrayContainer.transform = CGAffineTransformIdentity;
    
    if (majorLevel == 0) {
        absorbText = @"Thể chất phàm nhân, chưa thể hấp thu.";
    }
    else if (majorLevel == 1) { // PHÀM NHÂN
        auraColor = [UIColor lightGrayColor];
        qiBirthRate = 10.0; 
        self.arrayContainer.alpha = 0.3;
        self.monkLayer.shadowOpacity = 0.2;
        absorbText = @"Tụ khí tẩy tủy, bắt đầu cảm nhận linh khí.";
    } 
    else if (majorLevel == 2) { // LUYỆN KHÍ
        auraColor = [UIColor colorWithRed:0.6 green:0.9 blue:1.0 alpha:1.0];
        qiBirthRate = 35.0;
        self.arrayContainer.alpha = 0.7;
        self.monkLayer.shadowOpacity = 0.5;
        absorbText = @"Linh khí vận chuyển quanh thân thể.";
    } 
    else if (majorLevel == 3) { // TRÚC CƠ
        auraColor = [UIColor colorWithRed:0.3 green:0.8 blue:1.0 alpha:1.0];
        qiBirthRate = 70.0;
        self.arrayContainer.alpha = 1.0;
        self.monkLayer.shadowOpacity = 0.9;
        self.daoMarkLayer.opacity = 1.0; 
        absorbText = @"Đạo cơ đúc thành, linh lực ngưng thực.";
    } 
    else if (majorLevel == 4) { // KIM ĐAN
        auraColor = [UIColor colorWithRed:1.0 green:0.85 blue:0.1 alpha:1.0];
        qiBirthRate = 100.0;
        self.goldenCoreLayer.opacity = 1.0; 
        absorbText = @"Kết thành Kim Đan, thọ nguyên tăng mạnh.";
    } 
    else if (majorLevel == 5) { // NGUYÊN ANH
        auraColor = [UIColor colorWithRed:0.8 green:0.3 blue:1.0 alpha:1.0];
        qiBirthRate = 150.0;
        self.goldenCoreLayer.opacity = 1.0;
        self.dharmaIdolLayer.fillColor = [[UIColor whiteColor] colorWithAlphaComponent:0.15].CGColor;
        self.dharmaIdolLayer.strokeColor = auraColor.CGColor;
        self.dharmaIdolLayer.lineWidth = 1.0;
        self.dharmaIdolLayer.opacity = 0.8;
        self.dharmaIdolLayer.transform = CATransform3DMakeScale(0.7, 0.7, 1.0); 
        absorbText = @"Đan vỡ sinh Anh, thần hồn cường đại.";
    } 
    else if (majorLevel == 6) { // HÓA THẦN
        auraColor = [UIColor colorWithRed:1.0 green:0.2 blue:0.8 alpha:1.0];
        qiBirthRate = 200.0;
        self.dharmaIdolLayer.fillColor = [UIColor clearColor].CGColor;
        self.dharmaIdolLayer.strokeColor = auraColor.CGColor;
        self.dharmaIdolLayer.lineWidth = 2.0;
        self.dharmaIdolLayer.opacity = 0.5;
        self.dharmaIdolLayer.transform = CATransform3DMakeScale(1.8, 1.8, 1.0); 
        absorbText = @"Thần thức bao trùm, thiên địa giao cảm.";
    } 
    else if (majorLevel == 7) { // LUYỆN HƯ
        auraColor = [UIColor colorWithRed:0.6 green:0.0 blue:0.8 alpha:1.0]; 
        qiBirthRate = 250.0;
        self.backgroundLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3]; 
        self.dharmaIdolLayer.strokeColor = auraColor.CGColor;
        self.dharmaIdolLayer.opacity = 0.4;
        self.dharmaIdolLayer.transform = CATransform3DMakeScale(2.2, 2.2, 1.0);
        absorbText = @"Phá toái hư không, nắm giữ pháp tắc.";
    } 
    else if (majorLevel == 8) { // ĐẠI THỪA
        auraColor = [UIColor redColor]; 
        qiBirthRate = 350.0;
        self.arrayContainer.transform = CGAffineTransformMakeScale(1.2, 1.2); 
        absorbText = @"Đại Thừa viên mãn, tiếu ngạo nhân gian.";
    } 
    else if (majorLevel >= 9 && majorLevel <= 10) { // ĐỘ KIẾP & THIÊN KIẾP
        auraColor = [UIColor cyanColor];
        qiBirthRate = 450.0; 
        self.cloudLayer.opacity = 1.0; 
        self.arrayContainer.transform = CGAffineTransformMakeScale(1.3, 1.3);
        
        CAKeyframeAnimation *storm = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        if (majorLevel == 10) { 
            storm.values = @[@0, @1, @0, @0.8, @0];
            storm.keyTimes = @[@0, @0.1, @0.2, @0.3, @1.0];
            storm.duration = 1.0; 
            absorbText = @"Cửu Trọng Thiên Lôi giáng lâm! Sinh tử nhất niệm!";
        } else { 
            storm.values = @[@0, @1, @0.2, @1, @0];
            storm.keyTimes = @[@0, @0.05, @0.1, @0.2, @1.0];
            storm.duration = 2.5;
            absorbText = @"Thiên địa biến sắc, chuẩn bị nghênh đón Lôi Kiếp.";
        }
        storm.repeatCount = HUGE_VALF;
        [self.lightningLayer addAnimation:storm forKey:@"storm"];
    }
    else if (majorLevel == 11) { // PHI THĂNG
        auraColor = [UIColor whiteColor];
        qiBirthRate = 300.0;
        self.cloudLayer.opacity = 0.5; 
        self.cloudLayer.fillColor = [UIColor whiteColor].CGColor;
        self.arrayContainer.transform = CGAffineTransformMakeScale(1.5, 1.5);
        absorbText = @"Bạch nhật phi thăng, vị liệt tiên ban.";
    }

    self.monkLayer.shadowColor = auraColor.CGColor;
    self.statusLabel.layer.shadowColor = auraColor.CGColor;
    self.absorbingLabel.text = absorbText;
    
    // --- ĐÂY LÀ PHẦN CODE ĐÃ ĐƯỢC FIX LỖI COMPILER ---
    for (CALayer *layer in self.spinLayerCW.layer.sublayers) {
        if ([layer isKindOfClass:[CAShapeLayer class]]) {
            ((CAShapeLayer *)layer).strokeColor = auraColor.CGColor;
        }
    }
    for (UIView *view in self.spinLayerCW.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            ((UILabel *)view).textColor = auraColor;
        }
    }
    
    for (CALayer *layer in self.spinLayerCCW.layer.sublayers) {
        if ([layer isKindOfClass:[CAShapeLayer class]]) {
            ((CAShapeLayer *)layer).strokeColor = auraColor.CGColor;
        }
    }
    for (UIView *view in self.spinLayerCCW.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            ((UILabel *)view).textColor = auraColor;
        }
    }
    // ----------------------------------------------------
    
    CAEmitterCell *cell = [self.qiEmitter.emitterCells firstObject];
    cell.color = auraColor.CGColor;
    
    if (majorLevel == 11) {
        cell.velocity = 200.0;
        self.qiEmitter.emitterPosition = CGPointMake(self.bounds.size.width/2, -50);
        self.qiEmitter.emitterShape = kCAEmitterLayerLine;
        self.qiEmitter.emitterSize = CGSizeMake(self.bounds.size.width, 10);
        cell.emissionRange = 0;
    } else {
        self.qiEmitter.emitterPosition = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2 - 20);
        self.qiEmitter.emitterShape = kCAEmitterLayerCircle;
        CGFloat radius = MAX(self.bounds.size.width, self.bounds.size.height) + 50;
        self.qiEmitter.emitterSize = CGSizeMake(radius, radius);
        cell.velocity = -250.0;
        cell.emissionRange = M_PI * 2.0;
    }
    
    cell.birthRate = qiBirthRate;
    self.qiEmitter.emitterCells = @[cell];
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
    }
    if (self.isBreakingThrough) return;
    
    CultivationStatus oldStatus = getCultivationStatus(self.lastBatteryLevel);
    CultivationStatus newStatus = getCultivationStatus(currentBattery);
    
    if (currentBattery >= 100) {
        self.statusLabel.text = @"PHI THĂNG\n· Đại Đạo Viên Mãn ·";
        if (oldStatus.majorLevel != 11) [self applyRealmEffects:11];
        return;
    }
    
    if (![oldStatus.subRealm isEqualToString:newStatus.subRealm] || oldStatus.majorLevel != newStatus.majorLevel) {
        [self processBreakthroughFrom:oldStatus to:newStatus];
    } else {
        self.statusLabel.text = newStatus.subRealm.length > 0 ? [NSString stringWithFormat:@"%@\n· %@ ·", newStatus.realmName, newStatus.subRealm] : newStatus.realmName;
    }
    self.lastBatteryLevel = currentBattery;
}

- (void)processBreakthroughFrom:(CultivationStatus)oldStatus to:(CultivationStatus)newStatus {
    self.isBreakingThrough = YES;
    self.statusLabel.text = @"— ĐỘT PHÁ —";
    self.statusLabel.textColor = [UIColor yellowColor];
    
    int level = newStatus.majorLevel;
    CAEmitterCell *cell = [self.qiEmitter.emitterCells firstObject];
    cell.birthRate = 600.0; 
    cell.velocity = -700.0;
    self.qiEmitter.emitterCells = @[cell];
    
    if (level >= 6) {
        CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
        shake.duration = 0.04;
        shake.repeatCount = (level >= 9) ? 40 : 20; 
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
            [UIView animateWithDuration:0.8 animations:^{
                self.flashView.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.statusLabel.textColor = [UIColor whiteColor];
                self.statusLabel.text = newStatus.subRealm.length > 0 ? [NSString stringWithFormat:@"%@\n· %@ ·", newStatus.realmName, newStatus.subRealm] : newStatus.realmName;
                [self applyRealmEffects:level]; 
                self.isBreakingThrough = NO;
            }];
        }];
    }];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    return (hitView == self.testButton) ? hitView : nil;
}

@end

static TMCCultivationView *cultivationView = nil;

%hook CSCoverSheetViewController 
- (void)viewWillAppear:(BOOL)animated {
    %orig;
    UIDevice *device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    if (device.batteryState == UIDeviceBatteryStateCharging || device.batteryState == UIDeviceBatteryStateFull) {
        if (!cultivationView) {
            cultivationView = [[TMCCultivationView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            [self.view addSubview:cultivationView];
            [self.view bringSubviewToFront:cultivationView];
            [cultivationView updateTuVi:(int)(device.batteryLevel * 100)];
        }
    }
}
- (void)viewDidDisappear:(BOOL)animated {
    %orig;
    if (cultivationView) {
        [cultivationView removeFromSuperview];
        cultivationView = nil;
    }
}
%end

%hook SBUIController 
- (void)updateBatteryState:(id)arg1 {
    %orig;
    UIDevice *device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    if (cultivationView) {
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
}
%end
