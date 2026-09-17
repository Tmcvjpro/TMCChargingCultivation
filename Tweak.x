#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import <math.h>

@interface CSCoverSheetViewController : UIViewController
@end
@interface SBUIController : NSObject
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

// --- VIEW TU LUYỆN (CODE DRAW 100%) ---
@interface TMCCultivationView : UIView
@property (nonatomic, strong) UIView *backgroundLayer;
@property (nonatomic, strong) CAShapeLayer *cloudLayer;
@property (nonatomic, strong) CAShapeLayer *lightningLayer;
@property (nonatomic, strong) UIView *arrayContainer;
@property (nonatomic, strong) CAShapeLayer *dharmaIdolLayer; // Pháp tướng Hóa Thần
@property (nonatomic, strong) CAShapeLayer *monkLayer; // Nhân vật chính
@property (nonatomic, strong) CAShapeLayer *goldenCoreLayer; // Kim Đan
@property (nonatomic, strong) CAEmitterLayer *qiEmitter;
@property (nonatomic, strong) UIView *flashView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *absorbingLabel; // Dòng chữ luyện hóa
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
        [self addSubview:self.backgroundLayer];

        // 1. VẼ MÂY ĐEN BẰNG CODE (Ẩn, chỉ hiện khi Độ Kiếp)
        [self drawClouds];

        // 2. VẼ TIA SÉT BẰNG CODE (Ẩn, chỉ chớp khi Độ Kiếp)
        [self drawLightning];
        
        self.flashView = [[UIView alloc] initWithFrame:frame];
        self.flashView.backgroundColor = [UIColor whiteColor];
        self.flashView.alpha = 0.0;
        [self addSubview:self.flashView];

        // 3. VẼ TRẬN PHÁP DÀY & KHỦNG
        self.arrayContainer = [[UIView alloc] initWithFrame:CGRectMake(centerX - 130, centerY - 130, 260, 260)];
        [self addSubview:self.arrayContainer];
        [self drawThickBaguaArray];

        // 4. VẼ PHÁP TƯỚNG (Nguyên Anh / Hóa Thần)
        self.dharmaIdolLayer = [self createMonkVectorPathWithSize:200];
        self.dharmaIdolLayer.position = CGPointMake(centerX, centerY - 30);
        self.dharmaIdolLayer.fillColor = [UIColor clearColor].CGColor;
        self.dharmaIdolLayer.opacity = 0.0; // Ẩn mặc định
        [self.layer addSublayer:self.dharmaIdolLayer];

        // 5. VẼ NHÂN VẬT CỔ TRANG CHÍNH BẰNG CODE
        self.monkLayer = [self createMonkVectorPathWithSize:100];
        self.monkLayer.position = CGPointMake(centerX, centerY);
        self.monkLayer.fillColor = [UIColor whiteColor].CGColor;
        self.monkLayer.shadowColor = [UIColor cyanColor].CGColor;
        self.monkLayer.shadowRadius = 15.0;
        self.monkLayer.shadowOpacity = 1.0;
        [self.layer addSublayer:self.monkLayer];

        // 6. VẼ KIM ĐAN TẠI ĐAN ĐIỀN
        self.goldenCoreLayer = [CAShapeLayer layer];
        self.goldenCoreLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-6, 5, 12, 12)].CGPath;
        self.goldenCoreLayer.fillColor = [UIColor yellowColor].CGColor;
        self.goldenCoreLayer.position = CGPointMake(centerX, centerY + 15); // Vị trí bụng
        self.goldenCoreLayer.shadowColor = [UIColor yellowColor].CGColor;
        self.goldenCoreLayer.shadowRadius = 8.0;
        self.goldenCoreLayer.shadowOpacity = 1.0;
        self.goldenCoreLayer.opacity = 0.0; // Ẩn mặc định
        [self.layer addSublayer:self.goldenCoreLayer];

        // 7. LINH KHÍ 4 PHƯƠNG TỤ HỘI
        [self setupQiEmitter:CGPointMake(centerX, centerY)];

        // 8. CHỮ CẢNH GIỚI
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(centerX - 160, centerY + 130, 320, 50)];
        self.statusLabel.numberOfLines = 2;
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        self.statusLabel.textColor = [UIColor whiteColor];
        self.statusLabel.font = [UIFont boldSystemFontOfSize:17];
        self.statusLabel.layer.shadowRadius = 6.0;
        self.statusLabel.layer.shadowOpacity = 1.0;
        [self addSubview:self.statusLabel];

        // 9. DÒNG CHỮ LUYỆN HÓA LINH KHÍ
        self.absorbingLabel = [[UILabel alloc] initWithFrame:CGRectMake(centerX - 150, centerY + 180, 300, 20)];
        self.absorbingLabel.text = @"Đang luyện hóa thiên địa linh khí...";
        self.absorbingLabel.textAlignment = NSTextAlignmentCenter;
        self.absorbingLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        self.absorbingLabel.font = [UIFont italicSystemFontOfSize:11];
        [self addSubview:self.absorbingLabel];
        
        CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"opacity"];
        pulse.fromValue = @0.3;
        pulse.toValue = @1.0;
        pulse.duration = 1.5;
        pulse.autoreverses = YES;
        pulse.repeatCount = HUGE_VALF;
        [self.absorbingLabel.layer addAnimation:pulse forKey:@"pulsingText"];

        // 10. NÚT TEST
        self.testMilestones = @[@10, @14, @18, @24, @30, @40, @55, @70, @85, @97, @100];
        self.testIndex = 0;
        self.testButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.testButton.frame = CGRectMake(centerX - 40, frame.size.height - 100, 80, 30);
        [self.testButton setTitle:@"⚡️ TEST" forState:UIControlStateNormal];
        [self.testButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        self.testButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        self.testButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.testButton.layer.cornerRadius = 15;
        self.testButton.layer.borderWidth = 1.0;
        self.testButton.layer.borderColor = [UIColor yellowColor].CGColor;
        [self.testButton addTarget:self action:@selector(handleTestTap) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.testButton];

        self.lastBatteryLevel = -1;
    }
    return self;
}

// --- VẼ THUẬT TOÁN ---

- (void)drawThickBaguaArray {
    UIView *spinLayer = [[UIView alloc] initWithFrame:self.arrayContainer.bounds];
    [self.arrayContainer addSubview:spinLayer];
    
    // Vòng ngoài dày
    CAShapeLayer *outerThick = [CAShapeLayer layer];
    outerThick.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(10, 10, 240, 240)].CGPath;
    outerThick.fillColor = [UIColor clearColor].CGColor;
    outerThick.strokeColor = [UIColor cyanColor].CGColor;
    outerThick.lineWidth = 4.0; // Làm dày lên
    [spinLayer.layer addSublayer:outerThick];

    // Vòng trong đôi
    CAShapeLayer *innerDouble = [CAShapeLayer layer];
    innerDouble.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(35, 35, 190, 190)].CGPath;
    innerDouble.fillColor = [UIColor clearColor].CGColor;
    innerDouble.strokeColor = [UIColor cyanColor].CGColor;
    innerDouble.lineWidth = 1.5;
    innerDouble.lineDashPattern = @[@12, @6];
    [spinLayer.layer addSublayer:innerDouble];
    
    // Vẽ Bát Quái
    NSArray *bagua = @[@"☰", @"☱", @"☲", @"☳", @"☴", @"☵", @"☶", @"☷"];
    for (int i = 0; i < 8; i++) {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        lbl.center = CGPointMake(130, 130);
        lbl.text = bagua[i];
        lbl.textColor = [UIColor cyanColor];
        lbl.font = [UIFont boldSystemFontOfSize:20];
        lbl.textAlignment = NSTextAlignmentCenter;
        CGAffineTransform t = CGAffineTransformMakeRotation(i * (M_PI / 4.0));
        t = CGAffineTransformTranslate(t, 0, -105);
        lbl.transform = t;
        [spinLayer addSubview:lbl];
    }
    
    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spin.toValue = @(M_PI * 2.0);
    spin.duration = 20.0;
    spin.repeatCount = HUGE_VALF;
    [spinLayer.layer addAnimation:spin forKey:@"spinCW"];
}

// Thuật toán vẽ nhân vật mặc đạo bào đả tọa
- (CAShapeLayer *)createMonkVectorPathWithSize:(CGFloat)size {
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGFloat s = size / 100.0; 
    
    // Búi tóc (Đặc trưng cổ trang)
    [path addArcWithCenter:CGPointMake(0, -40*s) radius:8*s startAngle:0 endAngle:M_PI*2 clockwise:YES];
    // Đầu
    [path addArcWithCenter:CGPointMake(0, -20*s) radius:15*s startAngle:0 endAngle:M_PI*2 clockwise:YES];
    // Thân và áo bào rộng
    [path moveToPoint:CGPointMake(-10*s, -8*s)];
    [path addLineToPoint:CGPointMake(10*s, -8*s)];
    [path addLineToPoint:CGPointMake(45*s, 30*s)]; // Tay áo rộng phải
    [path addLineToPoint:CGPointMake(25*s, 35*s)]; 
    [path addLineToPoint:CGPointMake(15*s, 15*s)]; 
    [path addLineToPoint:CGPointMake(-15*s, 15*s)];
    [path addLineToPoint:CGPointMake(-25*s, 35*s)];
    [path addLineToPoint:CGPointMake(-45*s, 30*s)]; // Tay áo rộng trái
    [path closePath];
    
    // Đế ngồi khoanh chân
    [path moveToPoint:CGPointMake(-35*s, 35*s)];
    [path addQuadCurveToPoint:CGPointMake(35*s, 35*s) controlPoint:CGPointMake(0, 50*s)];
    [path addQuadCurveToPoint:CGPointMake(-35*s, 35*s) controlPoint:CGPointMake(0, 25*s)];
    
    layer.path = path.CGPath;
    return layer;
}

- (void)drawClouds {
    self.cloudLayer = [CAShapeLayer layer];
    UIBezierPath *cloudPath = [UIBezierPath bezierPath];
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    
    // Vẽ các vòng tròn nối tiếp tạo thành mây
    [cloudPath addArcWithCenter:CGPointMake(0, 50) radius:60 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    [cloudPath addArcWithCenter:CGPointMake(w/4, 30) radius:80 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    [cloudPath addArcWithCenter:CGPointMake(w/2, 60) radius:90 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    [cloudPath addArcWithCenter:CGPointMake(w*0.75, 20) radius:70 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    [cloudPath addArcWithCenter:CGPointMake(w, 50) radius:60 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    
    self.cloudLayer.path = cloudPath.CGPath;
    self.cloudLayer.fillColor = [[UIColor blackColor] colorWithAlphaComponent:0.8].CGColor;
    self.cloudLayer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.cloudLayer.shadowRadius = 20.0;
    self.cloudLayer.shadowOpacity = 1.0;
    self.cloudLayer.opacity = 0.0; // Ẩn khi chưa đến Độ Kiếp
    [self.backgroundLayer.layer addSublayer:self.cloudLayer];
}

- (void)drawLightning {
    self.lightningLayer = [CAShapeLayer layer];
    UIBezierPath *lightning = [UIBezierPath bezierPath];
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    
    // Vẽ nét tia sét Ziczac
    [lightning moveToPoint:CGPointMake(w/2 + 20, 80)];
    [lightning addLineToPoint:CGPointMake(w/2 - 40, h/3)];
    [lightning addLineToPoint:CGPointMake(w/2 + 30, h/2)];
    [lightning addLineToPoint:CGPointMake(w/2 - 50, h/1.2)];
    
    self.lightningLayer.path = lightning.CGPath;
    self.lightningLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.lightningLayer.fillColor = [UIColor clearColor].CGColor;
    self.lightningLayer.lineWidth = 6.0;
    self.lightningLayer.shadowColor = [UIColor cyanColor].CGColor;
    self.lightningLayer.shadowRadius = 15.0;
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
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(3, 3), NO, 0);
    [[UIColor whiteColor] setFill];
    [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 3, 3)] fill];
    UIImage *qiDot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    cell.contents = (id)qiDot.CGImage;
    cell.birthRate = 0; // Mặc định chưa nhập đạo không có
    cell.lifetime = 2.0; 
    cell.velocity = -250.0; 
    cell.velocityRange = 40.0;
    cell.emissionRange = M_PI * 2.0; 
    cell.alphaSpeed = -0.3;
    
    self.qiEmitter.emitterCells = @[cell];
    [self.layer insertSublayer:self.qiEmitter below:self.arrayContainer.layer];
}

// --- LOGIC ĐẶC TRƯNG TỪNG CẢNH GIỚI ---

- (void)applyRealmEffects:(int)majorLevel {
    UIColor *auraColor = [UIColor cyanColor];
    float qiBirthRate = 0;
    
    // Tắt các hiệu ứng đặc biệt trước
    self.goldenCoreLayer.opacity = 0.0;
    self.dharmaIdolLayer.opacity = 0.0;
    self.cloudLayer.opacity = 0.0;
    [self.lightningLayer removeAnimationForKey:@"strike"];
    self.lightningLayer.opacity = 0.0;
    
    if (majorLevel == 1) { // 1. Phàm Nhân
        auraColor = [UIColor lightGrayColor];
        qiBirthRate = 5.0; // Gần như không có
        self.arrayContainer.alpha = 0.3;
        self.monkLayer.shadowOpacity = 0.2;
    } 
    else if (majorLevel == 2) { // 2. Luyện Khí
        auraColor = [UIColor colorWithRed:0.5 green:0.8 blue:1.0 alpha:1.0];
        qiBirthRate = 30.0;
        self.arrayContainer.alpha = 0.7;
        self.monkLayer.shadowOpacity = 0.5;
    } 
    else if (majorLevel == 3) { // 3. Trúc Cơ
        auraColor = [UIColor colorWithRed:0.3 green:0.9 blue:1.0 alpha:1.0];
        qiBirthRate = 60.0;
        self.arrayContainer.alpha = 1.0;
        self.monkLayer.shadowOpacity = 0.8;
    } 
    else if (majorLevel == 4) { // 4. Kim Đan
        auraColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0];
        qiBirthRate = 80.0;
        self.goldenCoreLayer.opacity = 1.0; // Hiện Kim Đan
    } 
    else if (majorLevel == 5) { // 5. Nguyên Anh
        auraColor = [UIColor colorWithRed:0.8 green:0.0 blue:1.0 alpha:1.0];
        qiBirthRate = 120.0;
        self.dharmaIdolLayer.fillColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2].CGColor;
        self.dharmaIdolLayer.strokeColor = auraColor.CGColor;
        self.dharmaIdolLayer.lineWidth = 1.0;
        self.dharmaIdolLayer.opacity = 1.0;
        self.dharmaIdolLayer.transform = CATransform3DMakeScale(0.6, 0.6, 1.0); // Nguyên Anh nhỏ lơ lửng
    } 
    else if (majorLevel >= 6 && majorLevel <= 8) { // 6-8. Hóa Thần, Luyện Hư, Đại Thừa
        auraColor = (majorLevel == 6) ? [UIColor purpleColor] : [UIColor redColor];
        qiBirthRate = 180.0;
        self.dharmaIdolLayer.fillColor = [UIColor clearColor].CGColor;
        self.dharmaIdolLayer.strokeColor = auraColor.CGColor;
        self.dharmaIdolLayer.lineWidth = 2.0;
        self.dharmaIdolLayer.opacity = 0.5;
        self.dharmaIdolLayer.transform = CATransform3DMakeScale(1.8, 1.8, 1.0); // Pháp Tướng Khổng Lồ
    } 
    else if (majorLevel >= 9) { // 9-10. ĐỘ KIẾP
        auraColor = [UIColor cyanColor];
        qiBirthRate = 300.0; // Hỗn loạn
        self.cloudLayer.opacity = 1.0; // Hiện mây đen
        
        CAKeyframeAnimation *strike = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        strike.values = @[@0, @1, @0.2, @1, @0];
        strike.keyTimes = @[@0, @0.05, @0.1, @0.2, @1.0];
        strike.duration = 2.5; // Chu kỳ sét đánh
        strike.repeatCount = HUGE_VALF;
        [self.lightningLayer addAnimation:strike forKey:@"strike"];
    }

    // Đổi màu toàn hệ thống
    self.monkLayer.shadowColor = auraColor.CGColor;
    self.statusLabel.layer.shadowColor = auraColor.CGColor;
    for (CALayer *layer in [self.arrayContainer.layer.sublayers[0] sublayers]) {
        if ([layer isKindOfClass:[CAShapeLayer class]]) {
            ((CAShapeLayer *)layer).strokeColor = auraColor.CGColor;
        } else if ([layer isKindOfClass:[UILabel class]]) {
            ((UILabel *)layer).textColor = auraColor;
        }
    }
    
    CAEmitterCell *cell = [self.qiEmitter.emitterCells firstObject];
    cell.color = auraColor.CGColor;
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
        self.absorbingLabel.text = @"Đã phi thăng thoát tục.";
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
    cell.birthRate = 500.0;
    cell.velocity = -600.0;
    self.qiEmitter.emitterCells = @[cell];
    
    if (level >= 9) {
        CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
        shake.duration = 0.05;
        shake.repeatCount = 30;
        shake.autoreverses = YES;
        shake.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x - 10, self.center.y)];
        shake.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x + 10, self.center.y)];
        [self.layer addAnimation:shake forKey:@"shake"];
    }
    
    [UIView animateWithDuration:1.2 animations:^{
        self.arrayContainer.transform = CGAffineTransformMakeScale(1.3, 1.3);
    } completion:^(BOOL finished) {
        self.flashView.backgroundColor = (level >= 9) ? [UIColor cyanColor] : [UIColor whiteColor];
        [UIView animateWithDuration:0.2 animations:^{
            self.flashView.alpha = 0.9;
            self.arrayContainer.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.6 animations:^{
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
