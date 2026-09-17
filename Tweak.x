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

// --- GIAO DIỆN TU LUYỆN ĐỈNH CAO ---
@interface TMCCultivationView : UIView
@property (nonatomic, strong) UIView *arrayContainer;
@property (nonatomic, strong) UIView *baguaLayer;
@property (nonatomic, strong) UIView *starLayer;
@property (nonatomic, strong) UIImageView *arrayImageView;
@property (nonatomic, strong) UIImageView *monkImageView;
@property (nonatomic, strong) UIImageView *lightningImageView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) CAEmitterLayer *qiEmitter;
@property (nonatomic, strong) UIView *flashView;
@property (nonatomic, strong) CAShapeLayer *outerRing;
@property (nonatomic, strong) CAShapeLayer *innerRing;
@property (nonatomic, strong) NSMutableArray *baguaLabels;
@property (nonatomic, strong) CAShapeLayer *square1;
@property (nonatomic, strong) CAShapeLayer *square2;
@property (nonatomic, assign) int lastBatteryLevel;
@property (nonatomic, assign) BOOL isBreakingThrough;
@property (nonatomic, strong) UIButton *testButton;
@property (nonatomic, strong) NSArray *testMilestones;
@property (nonatomic, assign) int testIndex;
@end

@implementation TMCCultivationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.isBreakingThrough = NO;
        self.userInteractionEnabled = YES; 
        
        CGFloat centerX = frame.size.width / 2.0;
        CGFloat centerY = frame.size.height / 2.0 - 30;
        
        self.flashView = [[UIView alloc] initWithFrame:frame];
        self.flashView.backgroundColor = [UIColor whiteColor];
        self.flashView.alpha = 0.0;
        [self addSubview:self.flashView];
        
        // 1. TRẬN PHÁP CHUYÊN SÂU
        self.arrayContainer = [[UIView alloc] initWithFrame:CGRectMake(centerX - 120, centerY - 120, 240, 240)];
        [self addSubview:self.arrayContainer];
        
        UIImage *tranPhapImg = [UIImage imageWithContentsOfFile:@"/var/jb/tran_phap.png"];
        if (tranPhapImg) {
            self.arrayImageView = [[UIImageView alloc] initWithFrame:self.arrayContainer.bounds];
            self.arrayImageView.image = tranPhapImg;
            self.arrayImageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.arrayContainer addSubview:self.arrayImageView];
            
            CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            spin.toValue = @(M_PI * 2.0);
            spin.duration = 20.0;
            spin.repeatCount = HUGE_VALF;
            [self.arrayContainer.layer addAnimation:spin forKey:@"spin"];
        } else {
            [self drawComplexBaguaArray];
        }
        
        // 2. NHÂN VẬT TU SĨ
        self.monkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(centerX - 55, centerY - 65, 110, 110)];
        self.monkImageView.contentMode = UIViewContentModeScaleAspectFit;
        UIImage *tuSiImg = [UIImage imageWithContentsOfFile:@"/var/jb/tu_si.png"];
        if (tuSiImg) {
            self.monkImageView.image = tuSiImg;
        } else {
            UILabel *fallbackMonk = [[UILabel alloc] initWithFrame:self.monkImageView.bounds];
            fallbackMonk.text = @"🧘🏻‍♂️";
            fallbackMonk.font = [UIFont systemFontOfSize:65];
            fallbackMonk.textAlignment = NSTextAlignmentCenter;
            fallbackMonk.layer.shadowColor = [UIColor cyanColor].CGColor;
            fallbackMonk.layer.shadowRadius = 15.0;
            fallbackMonk.layer.shadowOpacity = 1.0;
            [self.monkImageView addSubview:fallbackMonk];
        }
        [self addSubview:self.monkImageView];
        
        // 3. TIA SÉT ĐỘ KIẾP (Nằm trên cùng)
        self.lightningImageView = [[UIImageView alloc] initWithFrame:frame];
        self.lightningImageView.contentMode = UIViewContentModeScaleAspectFill;
        UIImage *lightningImg = [UIImage imageWithContentsOfFile:@"/var/jb/thien_loi.png"];
        if (lightningImg) {
            self.lightningImageView.image = lightningImg;
        }
        self.lightningImageView.alpha = 0.0;
        [self addSubview:self.lightningImageView];
        
        // 4. CHỮ CẢNH GIỚI
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(centerX - 150, centerY + 130, 300, 45)];
        self.statusLabel.numberOfLines = 2;
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        self.statusLabel.textColor = [UIColor whiteColor];
        self.statusLabel.font = [UIFont boldSystemFontOfSize:15];
        self.statusLabel.layer.shadowRadius = 6.0;
        self.statusLabel.layer.shadowOpacity = 1.0;
        self.statusLabel.layer.shadowOffset = CGSizeZero;
        [self addSubview:self.statusLabel];
        
        // 5. LINH KHÍ 4 PHƯƠNG 8 HƯỚNG
        [self setup360QiEmitter:CGPointMake(centerX, centerY)];
        
        // 6. NÚT TEST
        self.testMilestones = @[@10, @16, @21, @28, @37, @49, @63, @80, @95, @100];
        self.testIndex = 0;
        
        self.testButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.testButton.frame = CGRectMake(centerX - 45, centerY + 195, 90, 30);
        [self.testButton setTitle:@"⚡️ TEST" forState:UIControlStateNormal];
        [self.testButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        self.testButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        self.testButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.testButton.layer.cornerRadius = 15;
        self.testButton.layer.borderWidth = 1.0;
        self.testButton.layer.borderColor = [[UIColor yellowColor] colorWithAlphaComponent:0.8].CGColor;
        [self.testButton addTarget:self action:@selector(handleTestTap) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.testButton];
        
        self.lastBatteryLevel = -1;
    }
    return self;
}

- (void)drawComplexBaguaArray {
    UIColor *baseColor = [UIColor cyanColor];
    
    // Layer Xoay Thuận (Vòng ngoài + Bát Quái)
    self.baguaLayer = [[UIView alloc] initWithFrame:self.arrayContainer.bounds];
    [self.arrayContainer addSubview:self.baguaLayer];
    
    self.outerRing = [CAShapeLayer layer];
    self.outerRing.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(10, 10, 220, 220)].CGPath;
    self.outerRing.fillColor = [UIColor clearColor].CGColor;
    self.outerRing.lineWidth = 2.0;
    self.outerRing.strokeColor = baseColor.CGColor;
    self.outerRing.shadowRadius = 8.0;
    self.outerRing.shadowOpacity = 1.0;
    self.outerRing.shadowOffset = CGSizeZero;
    [self.baguaLayer.layer addSublayer:self.outerRing];
    
    NSArray *bagua = @[@"☰", @"☱", @"☲", @"☳", @"☴", @"☵", @"☶", @"☷"];
    self.baguaLabels = [NSMutableArray array];
    for (int i = 0; i < 8; i++) {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        lbl.center = CGPointMake(120, 120); 
        lbl.text = bagua[i];
        lbl.textColor = baseColor;
        lbl.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
        lbl.textAlignment = NSTextAlignmentCenter;
        CGAffineTransform t = CGAffineTransformMakeRotation(i * (M_PI / 4.0));
        t = CGAffineTransformTranslate(t, 0, -95);
        lbl.transform = t;
        [self.baguaLayer addSubview:lbl];
        [self.baguaLabels addObject:lbl];
    }
    
    CABasicAnimation *spinClockwise = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spinClockwise.toValue = @(M_PI * 2.0);
    spinClockwise.duration = 25.0;
    spinClockwise.repeatCount = HUGE_VALF;
    [self.baguaLayer.layer addAnimation:spinClockwise forKey:@"spinCW"];
    
    // Layer Xoay Ngược (Tinh đồ Bát Giác + Vòng trong)
    self.starLayer = [[UIView alloc] initWithFrame:self.arrayContainer.bounds];
    [self.arrayContainer addSubview:self.starLayer];
    
    CGRect squareRect = CGRectMake(70, 70, 100, 100);
    self.square1 = [CAShapeLayer layer];
    self.square1.path = [UIBezierPath bezierPathWithRect:squareRect].CGPath;
    self.square1.fillColor = [UIColor clearColor].CGColor;
    self.square1.strokeColor = baseColor.CGColor;
    self.square1.lineWidth = 1.0;
    self.square1.opacity = 0.6;
    [self.starLayer.layer addSublayer:self.square1];
    
    self.square2 = [CAShapeLayer layer];
    self.square2.path = [UIBezierPath bezierPathWithRect:squareRect].CGPath;
    self.square2.fillColor = [UIColor clearColor].CGColor;
    self.square2.strokeColor = baseColor.CGColor;
    self.square2.lineWidth = 1.0;
    self.square2.opacity = 0.6;
    self.square2.transform = CATransform3DMakeRotation(M_PI / 4.0, 0, 0, 1);
    self.square2.position = CGPointMake(120 - 120*cos(M_PI/4), 120 - 120*sin(M_PI/4)); // Căn tâm phức tạp bù trừ
    // Hack nhanh để căn tâm square 2: Đặt frame cho dễ
    self.square2.frame = CGRectMake(0, 0, 240, 240);
    self.square2.path = [UIBezierPath bezierPathWithRect:CGRectMake(70, 70, 100, 100)].CGPath;
    self.square2.position = CGPointMake(120, 120);
    self.square2.bounds = CGRectMake(0, 0, 240, 240);
    [self.starLayer.layer addSublayer:self.square2];
    
    self.innerRing = [CAShapeLayer layer];
    self.innerRing.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(45, 45, 150, 150)].CGPath;
    self.innerRing.fillColor = [UIColor clearColor].CGColor;
    self.innerRing.lineWidth = 1.5;
    self.innerRing.strokeColor = baseColor.CGColor;
    self.innerRing.lineDashPattern = @[@8, @6, @3, @6];
    [self.starLayer.layer addSublayer:self.innerRing];
    
    CABasicAnimation *spinCounter = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spinCounter.toValue = @(-M_PI * 2.0);
    spinCounter.duration = 18.0;
    spinCounter.repeatCount = HUGE_VALF;
    [self.starLayer.layer addAnimation:spinCounter forKey:@"spinCCW"];
}

- (void)setup360QiEmitter:(CGPoint)targetCenter {
    self.qiEmitter = [CAEmitterLayer layer];
    
    // Hình tròn siêu lớn bao quanh toàn màn hình
    CGFloat radius = MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) + 100;
    
    self.qiEmitter.emitterPosition = targetCenter;
    self.qiEmitter.emitterSize = CGSizeMake(radius, radius);
    self.qiEmitter.emitterShape = kCAEmitterLayerCircle;
    self.qiEmitter.emitterMode = kCAEmitterLayerOutline; // Chỉ sinh ra từ viền ngoài của hình tròn
    self.qiEmitter.renderMode = kCAEmitterLayerAdditive;
    
    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(4, 4), NO, 0);
    [[UIColor whiteColor] setFill];
    [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 4, 4)] fill];
    UIImage *qiDot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    cell.contents = (id)qiDot.CGImage;
    cell.birthRate = 60.0;
    cell.lifetime = 2.5; // Đủ thời gian bay vào tâm
    
    // Vận tốc âm sẽ ép hạt bay ngược từ viền vào tâm emitterPosition
    cell.velocity = -250.0; 
    cell.velocityRange = 50.0;
    
    // Góc bắn 360 độ (Bốn phương tám hướng)
    cell.emissionRange = M_PI * 2.0; 
    
    cell.alphaSpeed = -0.3;
    cell.scale = 0.8;
    cell.scaleSpeed = -0.1;
    
    self.qiEmitter.emitterCells = @[cell];
    [self.layer insertSublayer:self.qiEmitter below:self.arrayContainer.layer];
}

- (void)handleTestTap {
    if (self.isBreakingThrough) return;
    int fakeBattery = [self.testMilestones[self.testIndex] intValue];
    self.lastBatteryLevel = fakeBattery - 1; 
    [self updateTuVi:fakeBattery];
    self.testIndex++;
    if (self.testIndex >= self.testMilestones.count) self.testIndex = 0; 
}

- (void)applyRealmEffects:(int)majorLevel {
    UIColor *auraColor;
    
    if (majorLevel <= 2) { auraColor = [UIColor colorWithRed:0.5 green:0.8 blue:1.0 alpha:1.0]; } // Phàm/Luyện Khí
    else if (majorLevel <= 4) { auraColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0]; } // Trúc Cơ/Kim Đan
    else if (majorLevel <= 6) { auraColor = [UIColor colorWithRed:0.8 green:0.0 blue:1.0 alpha:1.0]; } // Nguyên Anh/Hóa Thần
    else if (majorLevel <= 8) { auraColor = [UIColor colorWithRed:1.0 green:0.2 blue:0.2 alpha:1.0]; } // Luyện Hư/Đại Thừa
    else { auraColor = [UIColor cyanColor]; } // Độ Kiếp
    
    if (self.outerRing) self.outerRing.strokeColor = auraColor.CGColor;
    if (self.outerRing) self.outerRing.shadowColor = auraColor.CGColor;
    if (self.innerRing) self.innerRing.strokeColor = auraColor.CGColor;
    if (self.square1) self.square1.strokeColor = auraColor.CGColor;
    if (self.square2) self.square2.strokeColor = auraColor.CGColor;
    self.statusLabel.layer.shadowColor = auraColor.CGColor;
    
    for (UILabel *lbl in self.baguaLabels) {
        lbl.textColor = auraColor;
    }
    
    CAEmitterCell *cell = [self.qiEmitter.emitterCells firstObject];
    cell.color = auraColor.CGColor;
    self.qiEmitter.emitterCells = @[cell];
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
        return;
    }
    
    if (![oldStatus.subRealm isEqualToString:newStatus.subRealm] || oldStatus.majorLevel != newStatus.majorLevel) {
        [self processBreakthroughFrom:oldStatus to:newStatus];
    } else {
        self.statusLabel.text = newStatus.subRealm.length > 0 ? [NSString stringWithFormat:@"%@\n· %@ ·", newStatus.realmName, newStatus.subRealm] : newStatus.realmName;
    }
    self.lastBatteryLevel = currentBattery;
}

// --- QUY TRÌNH ĐỘT PHÁ PHÂN CẤP ---
- (void)processBreakthroughFrom:(CultivationStatus)oldStatus to:(CultivationStatus)newStatus {
    self.isBreakingThrough = YES;
    self.statusLabel.text = @"— ĐỘT PHÁ —";
    self.statusLabel.textColor = [UIColor yellowColor];
    
    int level = newStatus.majorLevel;
    
    // 1. Buff Trận pháp xoay điên cuồng
    CABasicAnimation *fastSpin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    fastSpin.toValue = @(M_PI * 2.0);
    fastSpin.duration = (level >= 7) ? 0.4 : 0.8; // Cảnh giới cao xoay cực nhanh
    fastSpin.repeatCount = 5.0;
    [self.baguaLayer.layer addAnimation:fastSpin forKey:@"burstCW"];
    
    CABasicAnimation *fastSpinCCW = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    fastSpinCCW.toValue = @(-M_PI * 2.0);
    fastSpinCCW.duration = (level >= 7) ? 0.3 : 0.7;
    fastSpinCCW.repeatCount = 5.0;
    [self.starLayer.layer addAnimation:fastSpinCCW forKey:@"burstCCW"];
    
    // 2. Buff Linh khí hút cạn bầu trời
    CAEmitterCell *cell = [self.qiEmitter.emitterCells firstObject];
    cell.birthRate = (level >= 7) ? 400.0 : 200.0;
    cell.velocity = (level >= 7) ? -600.0 : -400.0;
    self.qiEmitter.emitterCells = @[cell];
    
    // 3. Hiệu ứng riêng biệt
    UIColor *flashColor = [UIColor whiteColor];
    float scaleSize = 1.25;
    
    if (level >= 4 && level <= 6) { // Kim Đan -> Hóa Thần
        flashColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0]; // Lóa vàng kim
        scaleSize = 1.35;
        [self shakeScreen:5];
    } else if (level >= 7 && level <= 8) { // Luyện Hư -> Đại Thừa
        flashColor = [UIColor redColor]; // Huyết quang
        scaleSize = 1.5;
        [self shakeScreen:10];
    } else if (level >= 9) { // ĐỘ KIẾP - THIÊN LÔI
        flashColor = [UIColor cyanColor];
        scaleSize = 1.6;
        [self shakeScreen:20];
        
        // Hiện ảnh sấm sét thật chớp giật liên hồi
        CAKeyframeAnimation *lightning = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        lightning.values = @[@0, @1.0, @0.2, @0.8, @0];
        lightning.keyTimes = @[@0, @0.1, @0.15, @0.25, @1.0];
        lightning.duration = 0.5;
        lightning.repeatCount = 4;
        [self.lightningImageView.layer addAnimation:lightning forKey:@"strike"];
    }
    
    // Phình to hấp thụ và kết thúc
    [UIView animateWithDuration:1.0 animations:^{
        self.arrayContainer.transform = CGAffineTransformMakeScale(scaleSize, scaleSize);
    } completion:^(BOOL finished) {
        self.flashView.backgroundColor = flashColor;
        [UIView animateWithDuration:0.3 animations:^{
            self.flashView.alpha = 0.9;
            self.arrayContainer.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                self.flashView.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.statusLabel.textColor = [UIColor whiteColor];
                self.statusLabel.text = newStatus.subRealm.length > 0 ? [NSString stringWithFormat:@"%@\n· %@ ·", newStatus.realmName, newStatus.subRealm] : newStatus.realmName;
                
                [self applyRealmEffects:level];
                
                // Trả linh khí về bình thường
                cell.birthRate = 60.0;
                cell.velocity = -250.0;
                self.qiEmitter.emitterCells = @[cell];
                
                self.isBreakingThrough = NO;
            }];
        }];
    }];
}

- (void)shakeScreen:(int)intensity {
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
    shake.duration = 0.05;
    shake.repeatCount = intensity;
    shake.autoreverses = YES;
    shake.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x - 8, self.center.y)];
    shake.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x + 8, self.center.y)];
    [self.layer addAnimation:shake forKey:@"shake"];
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
