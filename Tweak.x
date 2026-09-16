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
@property (nonatomic, strong) UIImageView *monkImageView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *fallbackMonk;
@property (nonatomic, strong) CAEmitterLayer *qiEmitter;
@property (nonatomic, strong) UIView *flashView;
@property (nonatomic, strong) CAShapeLayer *outerRing;
@property (nonatomic, strong) CAShapeLayer *innerRing;
@property (nonatomic, strong) NSMutableArray *baguaLabels;
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
        CGFloat centerY = frame.size.height / 2.0 - 20;
        
        self.flashView = [[UIView alloc] initWithFrame:frame];
        self.flashView.backgroundColor = [UIColor whiteColor];
        self.flashView.alpha = 0.0;
        [self addSubview:self.flashView];
        
        self.arrayContainer = [[UIView alloc] initWithFrame:CGRectMake(centerX - 95, centerY - 95, 190, 190)];
        [self addSubview:self.arrayContainer];
        [self drawBaguaMagicArray];
        
        self.monkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(centerX - 40, centerY - 40, 80, 80)];
        self.monkImageView.contentMode = UIViewContentModeScaleAspectFit;
        UIImage *tuSiImg = [UIImage imageWithContentsOfFile:@"/var/jb/tu_si.png"];
        if (tuSiImg) {
            self.monkImageView.image = tuSiImg;
        } else {
            self.fallbackMonk = [[UILabel alloc] initWithFrame:self.monkImageView.bounds];
            self.fallbackMonk.text = @"🧘🏻‍♂️";
            self.fallbackMonk.font = [UIFont systemFontOfSize:55];
            self.fallbackMonk.textAlignment = NSTextAlignmentCenter;
            self.fallbackMonk.layer.shadowColor = [UIColor cyanColor].CGColor;
            self.fallbackMonk.layer.shadowRadius = 15.0;
            self.fallbackMonk.layer.shadowOpacity = 1.0;
            self.fallbackMonk.layer.shadowOffset = CGSizeZero;
            [self.monkImageView addSubview:self.fallbackMonk];
        }
        [self addSubview:self.monkImageView];
        
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(centerX - 130, centerY + 105, 260, 45)];
        self.statusLabel.numberOfLines = 2;
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        self.statusLabel.textColor = [UIColor whiteColor];
        self.statusLabel.font = [UIFont boldSystemFontOfSize:14];
        self.statusLabel.layer.shadowRadius = 5.0;
        self.statusLabel.layer.shadowOpacity = 1.0;
        self.statusLabel.layer.shadowOffset = CGSizeZero;
        [self addSubview:self.statusLabel];
        
        [self setupQiEmitter:CGPointMake(centerX, centerY)];
        
        self.testMilestones = @[@10, @16, @21, @28, @37, @49, @63, @80, @95, @100];
        self.testIndex = 0;
        
        self.testButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.testButton.frame = CGRectMake(centerX - 45, centerY + 160, 90, 28);
        [self.testButton setTitle:@"⚡️ TEST" forState:UIControlStateNormal];
        [self.testButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        self.testButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        self.testButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.testButton.layer.cornerRadius = 14;
        self.testButton.layer.borderWidth = 1.0;
        self.testButton.layer.borderColor = [[UIColor yellowColor] colorWithAlphaComponent:0.5].CGColor;
        [self.testButton addTarget:self action:@selector(handleTestTap) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.testButton];
        
        self.lastBatteryLevel = -1;
    }
    return self;
}

- (void)drawBaguaMagicArray {
    self.outerRing = [CAShapeLayer layer];
    self.outerRing.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(5, 5, 180, 180)].CGPath;
    self.outerRing.fillColor = [UIColor clearColor].CGColor;
    self.outerRing.lineWidth = 2.0;
    self.outerRing.shadowRadius = 8.0;
    self.outerRing.shadowOpacity = 1.0;
    self.outerRing.shadowOffset = CGSizeZero;
    [self.arrayContainer.layer addSublayer:self.outerRing];
    
    self.innerRing = [CAShapeLayer layer];
    self.innerRing.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(25, 25, 140, 140)].CGPath;
    self.innerRing.fillColor = [UIColor clearColor].CGColor;
    self.innerRing.lineWidth = 1.5;
    self.innerRing.lineDashPattern = @[@12, @6, @4, @6];
    self.innerRing.shadowRadius = 5.0;
    self.innerRing.shadowOpacity = 1.0;
    self.innerRing.shadowOffset = CGSizeZero;
    [self.arrayContainer.layer addSublayer:self.innerRing];
    
    NSArray *bagua = @[@"☰", @"☱", @"☲", @"☳", @"☴", @"☵", @"☶", @"☷"];
    self.baguaLabels = [NSMutableArray array];
    for (int i = 0; i < 8; i++) {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        lbl.center = CGPointMake(95, 95); 
        lbl.text = bagua[i];
        lbl.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
        lbl.textAlignment = NSTextAlignmentCenter;
        
        CGAffineTransform t = CGAffineTransformMakeRotation(i * (M_PI / 4.0));
        t = CGAffineTransformTranslate(t, 0, -75);
        lbl.transform = t;
        
        [self.arrayContainer addSubview:lbl];
        [self.baguaLabels addObject:lbl];
    }
    
    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spin.toValue = @(M_PI * 2.0);
    spin.duration = 20.0;
    spin.repeatCount = HUGE_VALF;
    [self.arrayContainer.layer addAnimation:spin forKey:@"spin"];
}

- (void)setupQiEmitter:(CGPoint)targetCenter {
    self.qiEmitter = [CAEmitterLayer layer];
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    self.qiEmitter.emitterPosition = targetCenter;
    self.qiEmitter.emitterSize = CGSizeMake(screenBounds.size.width + 50, screenBounds.size.height + 50);
    self.qiEmitter.emitterShape = kCAEmitterLayerRectangle;
    self.qiEmitter.renderMode = kCAEmitterLayerAdditive;
    
    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(4, 4), NO, 0);
    [[UIColor whiteColor] setFill];
    [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 4, 4)] fill];
    UIImage *qiDot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    cell.contents = (id)qiDot.CGImage;
    cell.birthRate = 45.0;
    cell.lifetime = 1.8;
    cell.velocity = -250.0;
    cell.velocityRange = 40.0;
    cell.alphaSpeed = -0.5;
    cell.scale = 0.8;
    
    self.qiEmitter.emitterCells = @[cell];
    [self.layer insertSublayer:self.qiEmitter below:self.arrayContainer.layer];
}

- (void)handleTestTap {
    if (self.isBreakingThrough) return;
    
    int fakeBattery = [self.testMilestones[self.testIndex] intValue];
    self.lastBatteryLevel = fakeBattery - 1; 
    [self updateTuVi:fakeBattery];
    
    self.testIndex++;
    if (self.testIndex >= self.testMilestones.count) {
        self.testIndex = 0; 
    }
}

- (void)applyRealmEffects:(int)majorLevel {
    UIColor *auraColor;
    float spinSpeed = 20.0;
    [self.flashView.layer removeAnimationForKey:@"lightning"]; 
    
    if (majorLevel <= 2) { 
        auraColor = [UIColor colorWithRed:0.5 green:0.8 blue:1.0 alpha:1.0]; 
    } else if (majorLevel <= 4) { 
        auraColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0]; 
        spinSpeed = 15.0;
    } else if (majorLevel <= 6) { 
        auraColor = [UIColor colorWithRed:0.8 green:0.0 blue:1.0 alpha:1.0]; 
        spinSpeed = 10.0;
    } else if (majorLevel <= 8) { 
        auraColor = [UIColor colorWithRed:1.0 green:0.2 blue:0.2 alpha:1.0]; 
        spinSpeed = 7.0;
    } else { 
        auraColor = [UIColor cyanColor]; 
        spinSpeed = 4.0; 
        
        CAKeyframeAnimation *lightning = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        lightning.values = @[@0, @0.8, @0, @0.4, @0];
        lightning.keyTimes = @[@0, @0.05, @0.1, @0.15, @1.0];
        lightning.duration = 2.0; 
        lightning.repeatCount = HUGE_VALF;
        [self.flashView.layer addAnimation:lightning forKey:@"lightning"];
    }
    
    self.outerRing.strokeColor = auraColor.CGColor;
    self.outerRing.shadowColor = auraColor.CGColor;
    self.innerRing.strokeColor = auraColor.CGColor;
    self.innerRing.shadowColor = auraColor.CGColor;
    self.statusLabel.layer.shadowColor = auraColor.CGColor;
    if (self.fallbackMonk) self.fallbackMonk.layer.shadowColor = auraColor.CGColor;
    
    for (UILabel *lbl in self.baguaLabels) {
        lbl.textColor = auraColor;
    }
    
    CAEmitterCell *cell = [self.qiEmitter.emitterCells firstObject];
    cell.color = auraColor.CGColor;
    if (majorLevel >= 7) cell.birthRate = 100.0; 
    else cell.birthRate = 45.0;
    self.qiEmitter.emitterCells = @[cell];
    
    [self.arrayContainer.layer removeAnimationForKey:@"spin"];
    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spin.toValue = @(M_PI * 2.0);
    spin.duration = spinSpeed;
    spin.repeatCount = HUGE_VALF;
    [self.arrayContainer.layer addAnimation:spin forKey:@"spin"];
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
        [self processBreakthroughFrom:oldStatus to:newStatus battery:currentBattery];
    } else {
        if (newStatus.subRealm.length > 0) {
            self.statusLabel.text = [NSString stringWithFormat:@"%@\n· %@ ·", newStatus.realmName, newStatus.subRealm];
        } else {
            self.statusLabel.text = newStatus.realmName;
        }
    }
    
    self.lastBatteryLevel = currentBattery;
}

- (void)processBreakthroughFrom:(CultivationStatus)oldStatus to:(CultivationStatus)newStatus battery:(int)battery {
    self.isBreakingThrough = YES;
    self.statusLabel.text = @"— ĐỘT PHÁ —";
    self.statusLabel.textColor = [UIColor yellowColor];
    
    [self.arrayContainer.layer removeAnimationForKey:@"spin"];
    CABasicAnimation *fastSpin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    fastSpin.toValue = @(M_PI * 2.0);
    fastSpin.duration = 0.8; 
    fastSpin.repeatCount = 3.0;
    [self.arrayContainer.layer addAnimation:fastSpin forKey:@"fastSpin"];
    
    CAEmitterCell *cell = [self.qiEmitter.emitterCells firstObject];
    // Đã xóa biến thừa oldBirth ở đây!
    cell.birthRate = 250.0;
    cell.velocity = -400.0; 
    self.qiEmitter.emitterCells = @[cell];
    
    if (newStatus.majorLevel >= 9) { 
        [self simulateThunderStrike];
    }
    
    [UIView animateWithDuration:1.0 animations:^{
        self.arrayContainer.transform = CGAffineTransformMakeScale(1.3, 1.3);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.flashView.alpha = 0.9;
            self.arrayContainer.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                self.flashView.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.statusLabel.textColor = [UIColor whiteColor];
                if (newStatus.subRealm.length > 0) {
                    self.statusLabel.text = [NSString stringWithFormat:@"%@\n· %@ ·", newStatus.realmName, newStatus.subRealm];
                } else {
                    self.statusLabel.text = newStatus.realmName;
                }
                
                [self applyRealmEffects:newStatus.majorLevel];
                
                cell.birthRate = 45.0;
                cell.velocity = -250.0;
                self.qiEmitter.emitterCells = @[cell];
                
                self.isBreakingThrough = NO;
            }];
        }];
    }];
}

- (void)simulateThunderStrike {
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
    shake.duration = 0.05;
    shake.repeatCount = 20;
    shake.autoreverses = YES;
    shake.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x - 6, self.center.y)];
    shake.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x + 6, self.center.y)];
    [self.layer addAnimation:shake forKey:@"shake"];
    
    self.flashView.backgroundColor = [UIColor cyanColor];
    [UIView animateWithDuration:0.1 animations:^{
        self.flashView.alpha = 0.8;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.flashView.alpha = 0.0;
            self.flashView.backgroundColor = [UIColor whiteColor];
        }];
    }];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self.testButton) {
        return hitView;
    }
    return nil;
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
