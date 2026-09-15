#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>

@interface CSCoverSheetViewController : UIViewController
@end

@interface SBUIController : NSObject
@end

// --- KHAI BÁO CẢNH GIỚI ---
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

// --- GIAO DIỆN TU LUYỆN PHÓNG TO ---
@interface TMCCultivationView : UIView
@property (nonatomic, strong) UIImageView *monkImageView;
@property (nonatomic, strong) UIView *arrayView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) CAEmitterLayer *screenEdgeQiEmitter;
@property (nonatomic, assign) int lastBatteryLevel;
@property (nonatomic, strong) NSDate *lastBatteryChangeTime;
@end

@implementation TMCCultivationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        // 1. Trận pháp tiên hiệp phóng to 280x280px
        [self setupXianXiaArray];
        
        // 2. Nhân vật Tu sĩ 130x130px chính giữa
        self.monkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(75, 65, 130, 130)];
        self.monkImageView.contentMode = UIViewContentModeScaleAspectFit;
        UIImage *tuSiImg = [UIImage imageWithContentsOfFile:@"/var/jb/tu_si.png"];
        if (tuSiImg) {
            self.monkImageView.image = tuSiImg;
        } else {
            UILabel *fallback = [[UILabel alloc] initWithFrame:self.monkImageView.bounds];
            fallback.text = @"🧘🏻‍♂️";
            fallback.font = [UIFont systemFontOfSize:85];
            fallback.textAlignment = NSTextAlignmentCenter;
            [self.monkImageView addSubview:fallback];
        }
        [self addSubview:self.monkImageView];
        
        // 3. Chữ cảnh giới & ETA rõ nét
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(-20, 225, 320, 50)];
        self.statusLabel.numberOfLines = 2;
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        self.statusLabel.textColor = [UIColor whiteColor];
        self.statusLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
        self.statusLabel.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.9 blue:1.0 alpha:1.0].CGColor;
        self.statusLabel.layer.shadowRadius = 8.0;
        self.statusLabel.layer.shadowOpacity = 1.0;
        self.statusLabel.layer.shadowOffset = CGSizeZero;
        [self addSubview:self.statusLabel];
        
        // 4. Linh khí từ viền bay vào (Đã sửa lỗi không dùng keyWindow)
        [self setupEdgeQiEmitter];
        
        self.lastBatteryLevel = -1;
        self.lastBatteryChangeTime = [NSDate date];
    }
    return self;
}

- (void)setupXianXiaArray {
    self.arrayView = [[UIView alloc] initWithFrame:CGRectMake(-20, -25, 280, 280)];
    [self addSubview:self.arrayView];
    
    UIColor *arrayColor = [UIColor colorWithRed:0.1 green:0.95 blue:1.0 alpha:1.0];
    
    CAShapeLayer *outerRing = [CAShapeLayer layer];
    outerRing.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(10, 10, 260, 260)].CGPath;
    outerRing.strokeColor = arrayColor.CGColor;
    outerRing.fillColor = [UIColor clearColor].CGColor;
    outerRing.lineWidth = 2.5;
    outerRing.shadowColor = arrayColor.CGColor;
    outerRing.shadowRadius = 12.0;
    outerRing.shadowOpacity = 0.9;
    outerRing.shadowOffset = CGSizeZero;
    [self.arrayView.layer addSublayer:outerRing];
    
    CAShapeLayer *midRing = [CAShapeLayer layer];
    midRing.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(40, 40, 200, 200)].CGPath;
    midRing.strokeColor = arrayColor.CGColor;
    midRing.fillColor = [UIColor clearColor].CGColor;
    midRing.lineWidth = 2.0;
    midRing.lineDashPattern = @[@10, @8, @4, @8];
    midRing.shadowColor = arrayColor.CGColor;
    midRing.shadowRadius = 10.0;
    midRing.shadowOpacity = 1.0;
    midRing.shadowOffset = CGSizeZero;
    [self.arrayView.layer addSublayer:midRing];
    
    CAShapeLayer *innerRing = [CAShapeLayer layer];
    innerRing.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(70, 70, 140, 140)].CGPath;
    innerRing.strokeColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.9].CGColor;
    innerRing.fillColor = [UIColor clearColor].CGColor;
    innerRing.lineWidth = 1.2;
    [self.arrayView.layer addSublayer:innerRing];
    
    UILabel *rune = [[UILabel alloc] initWithFrame:self.arrayView.bounds];
    rune.text = @"☸"; 
    rune.font = [UIFont systemFontOfSize:150 weight:UIFontWeightUltraLight];
    rune.textColor = [arrayColor colorWithAlphaComponent:0.3];
    rune.textAlignment = NSTextAlignmentCenter;
    [self.arrayView addSubview:rune];
    
    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spin.toValue = @(M_PI * 2.0);
    spin.duration = 20.0;
    spin.repeatCount = HUGE_VALF;
    [self.arrayView.layer addAnimation:spin forKey:@"spinAnimation"];
}

- (void)setupEdgeQiEmitter {
    self.screenEdgeQiEmitter = [CAEmitterLayer layer];
    
    // Lấy kích thước màn hình an toàn không dùng keyWindow
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGFloat screenW = screenBounds.size.width > 0 ? screenBounds.size.width : 390;
    CGFloat screenH = screenBounds.size.height > 0 ? screenBounds.size.height : 844;
    
    self.screenEdgeQiEmitter.emitterPosition = CGPointMake(screenW / 2.0, screenH / 2.0);
    self.screenEdgeQiEmitter.emitterSize = CGSizeMake(screenW - 20, screenH - 20);
    self.screenEdgeQiEmitter.emitterShape = kCAEmitterLayerRectangle;
    self.screenEdgeQiEmitter.renderMode = kCAEmitterLayerAdditive;
    
    CAEmitterCell *edgeCell = [CAEmitterCell emitterCell];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(10, 10), NO, 0);
    [[UIColor colorWithRed:0.2 green:1.0 blue:1.0 alpha:1.0] setFill];
    [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 10, 10)] fill];
    UIImage *qiDot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    edgeCell.contents = (id)qiDot.CGImage;
    edgeCell.birthRate = 55.0;
    edgeCell.lifetime = 2.2;
    edgeCell.velocity = -200.0;
    edgeCell.velocityRange = 50.0;
    edgeCell.alphaSpeed = -0.25;
    edgeCell.scale = 0.9;
    edgeCell.scaleRange = 0.4;
    
    self.screenEdgeQiEmitter.emitterCells = @[edgeCell];
    [self.layer addSublayer:self.screenEdgeQiEmitter];
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
        self.arrayView.transform = CGAffineTransformMakeScale(1.25, 1.25);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0 animations:^{
            self.arrayView.transform = CGAffineTransformIdentity;
        }];
    }];
}

- (void)enableTribulationMode {
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
    shake.duration = 0.04;
    shake.repeatCount = 12;
    shake.autoreverses = YES;
    shake.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.arrayView.center.x - 4, self.arrayView.center.y)];
    shake.toValue = [NSValue valueWithCGPoint:CGPointMake(self.arrayView.center.x + 4, self.arrayView.center.y)];
    [self.arrayView.layer addAnimation:shake forKey:@"shake"];
}

- (void)triggerAscension {
    self.screenEdgeQiEmitter.birthRate = 0;
    [UIView animateWithDuration:1.5 animations:^{
        self.alpha = 0.0; 
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end

// --- VỊ TRÍ HIỂN THỊ TRÊN LOCK SCREEN ---
static TMCCultivationView *cultivationView = nil;

%hook CSCoverSheetViewController 

- (void)viewWillAppear:(BOOL)animated {
    %orig;
    UIDevice *device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    
    if (device.batteryState == UIDeviceBatteryStateCharging || device.batteryState == UIDeviceBatteryStateFull) {
        if (!cultivationView) {
            CGRect screenBounds = [UIScreen mainScreen].bounds;
            CGFloat screenW = screenBounds.size.width;
            CGFloat screenH = screenBounds.size.height;
            
            cultivationView = [[TMCCultivationView alloc] initWithFrame:CGRectMake(0, 0, 280, 290)];
            cultivationView.center = CGPointMake(screenW / 2.0, screenH * 0.64);
            
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
