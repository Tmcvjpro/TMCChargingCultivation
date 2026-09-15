#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>

// --- KHAI BÁO CLASS HỆ THỐNG ĐỂ FIX LỖI ---
@interface CSCoverSheetViewController : UIViewController
@end

@interface SBUIController : NSObject
@end

// --- KHAI BÁO CÁC CẢNH GIỚI ---
NSString* getRealmName(int batteryLevel) {
    if (batteryLevel <= 4) return @"PHÀM NHÂN";
    if (batteryLevel <= 9) return @"LUYỆN KHÍ";
    if (batteryLevel <= 19) return @"TRÚC CƠ";
    if (batteryLevel <= 39) return @"KIM ĐAN";
    if (batteryLevel <= 59) return @"NGUYÊN ANH";
    if (batteryLevel <= 74) return @"HÓA THẦN";
    if (batteryLevel <= 84) return @"LUYỆN HƯ";
    if (batteryLevel <= 94) return @"ĐẠI THỪA";
    if (batteryLevel <= 99) return @"ĐỘ KIẾP";
    return @"PHI THĂNG";
}

int getNextRealmThreshold(int batteryLevel) {
    if (batteryLevel <= 4) return 5;
    if (batteryLevel <= 9) return 10;
    if (batteryLevel <= 19) return 20;
    if (batteryLevel <= 39) return 40;
    if (batteryLevel <= 59) return 60;
    if (batteryLevel <= 74) return 75;
    if (batteryLevel <= 84) return 85;
    if (batteryLevel <= 94) return 95;
    if (batteryLevel <= 99) return 100;
    return 100;
}

// --- GIAO DIỆN TU LUYỆN (UIView) ---
@interface TMCCultivationView : UIView
@property (nonatomic, strong) UILabel *monkLabel;
@property (nonatomic, strong) UIView *arrayView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) CAEmitterLayer *qiEmitter;
@property (nonatomic, assign) int lastBatteryLevel;
@property (nonatomic, strong) NSDate *lastBatteryChangeTime;
@end

@implementation TMCCultivationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        // 1. Vẽ Trận pháp
        [self setupMagicArray];
        
        // 2. Tu sĩ đả tọa
        self.monkLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 40, 80, 80)];
        self.monkLabel.text = @"🧘🏻‍♂️";
        self.monkLabel.font = [UIFont systemFontOfSize:55];
        self.monkLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.monkLabel];
        
        // 3. Chữ cảnh giới & ETA
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 165, 180, 40)];
        self.statusLabel.numberOfLines = 2;
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        self.statusLabel.textColor = [UIColor colorWithWhite:0.9 alpha:0.9];
        self.statusLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightThin];
        [self addSubview:self.statusLabel];
        
        // 4. Hệ thống hạt Linh khí bay vào
        self.qiEmitter = [CAEmitterLayer layer];
        self.qiEmitter.emitterPosition = CGPointMake(90, 80);
        self.qiEmitter.emitterSize = CGSizeMake(130, 130);
        self.qiEmitter.emitterShape = kCAEmitterLayerCircle;
        self.qiEmitter.renderMode = kCAEmitterLayerAdditive;
        [self.layer addSublayer:self.qiEmitter];
        
        [self setupQiParticles];
        
        self.lastBatteryLevel = -1;
        self.lastBatteryChangeTime = [NSDate date];
    }
    return self;
}

- (void)setupMagicArray {
    self.arrayView = [[UIView alloc] initWithFrame:CGRectMake(20, 10, 140, 140)];
    [self addSubview:self.arrayView];
    
    CAShapeLayer *outerCircle = [CAShapeLayer layer];
    outerCircle.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(5, 5, 130, 130)].CGPath;
    outerCircle.strokeColor = [UIColor colorWithWhite:0.8 alpha:0.4].CGColor;
    outerCircle.fillColor = [UIColor clearColor].CGColor;
    outerCircle.lineWidth = 1.0;
    [self.arrayView.layer addSublayer:outerCircle];
    
    CAShapeLayer *dashedCircle = [CAShapeLayer layer];
    dashedCircle.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(20, 20, 100, 100)].CGPath;
    dashedCircle.strokeColor = [UIColor colorWithWhite:0.9 alpha:0.3].CGColor;
    dashedCircle.fillColor = [UIColor clearColor].CGColor;
    dashedCircle.lineWidth = 1.0;
    dashedCircle.lineDashPattern = @[@3, @5];
    [self.arrayView.layer addSublayer:dashedCircle];
    
    UILabel *runeLabel = [[UILabel alloc] initWithFrame:self.arrayView.bounds];
    runeLabel.text = @"۞"; 
    runeLabel.font = [UIFont systemFontOfSize:90 weight:UIFontWeightUltraLight];
    runeLabel.textColor = [UIColor colorWithWhite:0.9 alpha:0.2];
    runeLabel.textAlignment = NSTextAlignmentCenter;
    [self.arrayView addSubview:runeLabel];
    
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.toValue = @(M_PI * 2.0);
    rotation.duration = 25.0; 
    rotation.repeatCount = HUGE_VALF;
    [self.arrayView.layer addAnimation:rotation forKey:@"rotationAnimation"];
}

- (void)setupQiParticles {
    CAEmitterCell *qiCell = [CAEmitterCell emitterCell];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(4, 4), NO, 0);
    [[UIColor colorWithRed:0.7 green:0.9 blue:1.0 alpha:0.6] setFill];
    [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 4, 4)] fill];
    UIImage *particleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    qiCell.contents = (id)particleImage.CGImage;
    qiCell.birthRate = 6.0; 
    qiCell.lifetime = 4.0;
    qiCell.velocity = -15.0; 
    qiCell.alphaSpeed = -0.2; 
    qiCell.scale = 0.5;
    qiCell.scaleRange = 0.2;
    
    self.qiEmitter.emitterCells = @[qiCell];
}

- (void)updateTuVi:(int)currentBattery {
    if (self.lastBatteryLevel == -1) {
        self.lastBatteryLevel = currentBattery;
    }
    
    NSString *currentRealm = getRealmName(currentBattery);
    
    if (currentBattery == 100) {
        self.statusLabel.text = @"PHI THĂNG";
        [self triggerAscension];
        return;
    }
    
    if (currentBattery > self.lastBatteryLevel && ![currentRealm isEqualToString:getRealmName(self.lastBatteryLevel)]) {
        [self triggerBreakthrough];
    }
    
    int nextThreshold = getNextRealmThreshold(currentBattery);
    NSString *nextRealm = getRealmName(nextThreshold);
    
    if (currentBattery > self.lastBatteryLevel) {
        NSTimeInterval timeTakenForOnePercent = [[NSDate date] timeIntervalSinceDate:self.lastBatteryChangeTime] / (currentBattery - self.lastBatteryLevel);
        int percentToNextRealm = nextThreshold - currentBattery;
        int minutesLeft = (int)((timeTakenForOnePercent * percentToNextRealm) / 60.0);
        
        if (minutesLeft > 0) {
            self.statusLabel.text = [NSString stringWithFormat:@"%@\n↓ %d phút · %@", currentRealm, minutesLeft, nextRealm];
        } else {
            self.statusLabel.text = [NSString stringWithFormat:@"%@\nĐang hấp thu linh khí...", currentRealm];
        }
        
        self.lastBatteryChangeTime = [NSDate date];
        self.lastBatteryLevel = currentBattery;
    } else {
        self.statusLabel.text = [NSString stringWithFormat:@"%@\nĐang hấp thu linh khí...", currentRealm];
    }
    
    if (currentBattery >= 95 && currentBattery < 100) {
        [self enableTribulationMode];
    }
}

- (void)triggerBreakthrough {
    [UIView animateWithDuration:0.5 animations:^{
        self.arrayView.alpha = 1.0;
        self.arrayView.transform = CGAffineTransformMakeScale(1.15, 1.15);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0 animations:^{
            self.arrayView.alpha = 1.0;
            self.arrayView.transform = CGAffineTransformIdentity;
        }];
    }];
}

- (void)enableTribulationMode {
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
    shake.duration = 0.05;
    shake.repeatCount = 10;
    shake.autoreverses = YES;
    shake.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.arrayView.center.x - 1, self.arrayView.center.y)];
    shake.toValue = [NSValue valueWithCGPoint:CGPointMake(self.arrayView.center.x + 1, self.arrayView.center.y)];
    [self.arrayView.layer addAnimation:shake forKey:@"shake"];
}

- (void)triggerAscension {
    self.qiEmitter.birthRate = 0;
    [UIView animateWithDuration:1.5 animations:^{
        self.alpha = 0.0; 
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end

// --- CAN THIỆP VÀO LOCK SCREEN ---
static TMCCultivationView *cultivationView = nil;

%hook CSCoverSheetViewController 

- (void)viewWillAppear:(BOOL)animated {
    %orig;
    UIDevice *device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    
    if (device.batteryState == UIDeviceBatteryStateCharging || device.batteryState == UIDeviceBatteryStateFull) {
        if (!cultivationView) {
            cultivationView = [[TMCCultivationView alloc] initWithFrame:CGRectMake(0, 0, 180, 210)];
            cultivationView.center = self.view.center; 
            [self.view addSubview:cultivationView];
            
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
            [UIView animateWithDuration:0.5 animations:^{
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
