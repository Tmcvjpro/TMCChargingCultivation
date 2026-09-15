#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>

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
@property (nonatomic, strong) UIImageView *monkView;
@property (nonatomic, strong) UIImageView *arrayView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) CAEmitterLayer *qiEmitter;
@property (nonatomic, strong) CAEmitterLayer *lightningEmitter;

@property (nonatomic, assign) int lastBatteryLevel;
@property (nonatomic, strong) NSDate *lastBatteryChangeTime;
@end

@implementation TMCCultivationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        // 1. Trận pháp (Xoay nhẹ nhàng)
        self.arrayView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 140, 140)];
        self.arrayView.contentMode = UIViewContentModeScaleAspectFit;
        // Đạo hữu Tmc cần bỏ file hinh tran_phap.png vào thư mục /var/jb/Library/Application Support/TMCChargingCultivation/
        self.arrayView.image = [UIImage imageWithContentsOfFile:@"/var/jb/Library/Application Support/TMCChargingCultivation/tran_phap.png"]; 
        self.arrayView.alpha = 0.6;
        [self addSubview:self.arrayView];
        
        // 2. Tu sĩ đả tọa (Tĩnh)
        self.monkView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 40, 80, 80)];
        self.monkView.contentMode = UIViewContentModeScaleAspectFit;
        self.monkView.image = [UIImage imageWithContentsOfFile:@"/var/jb/Library/Application Support/TMCChargingCultivation/tu_si.png"];
        [self addSubview:self.monkView];
        
        // 3. Chữ cảnh giới & ETA
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 165, 180, 40)];
        self.statusLabel.numberOfLines = 2;
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        self.statusLabel.textColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        self.statusLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightThin];
        [self addSubview:self.statusLabel];
        
        // 4. Hệ thống hạt Linh khí (CAEmitterLayer)
        self.qiEmitter = [CAEmitterLayer layer];
        self.qiEmitter.emitterPosition = CGPointMake(90, 90);
        self.qiEmitter.emitterSize = CGSizeMake(120, 120);
        self.qiEmitter.emitterShape = kCAEmitterLayerCircle;
        self.qiEmitter.renderMode = kCAEmitterLayerAdditive;
        [self.layer addSublayer:self.qiEmitter];
        
        [self setupQiParticles];
        
        self.lastBatteryLevel = -1;
        self.lastBatteryChangeTime = [NSDate date];
    }
    return self;
}

- (void)setupQiParticles {
    CAEmitterCell *qiCell = [CAEmitterCell emitterCell];
    // Dùng ký tự tròn mờ làm hạt linh khí, không cần ảnh
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(4, 4), NO, 0);
    [[UIColor colorWithRed:0.6 green:0.9 blue:1.0 alpha:0.8] setFill];
    [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 4, 4)] fill];
    UIImage *particleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    qiCell.contents = (id)particleImage.CGImage;
    qiCell.birthRate = 8.0; 
    qiCell.lifetime = 3.0;
    qiCell.velocity = -20.0; // Bay ngược về tâm (tu sĩ)
    qiCell.alphaSpeed = -0.3; // Mờ dần khi tới gần
    qiCell.scale = 0.5;
    qiCell.scaleRange = 0.3;
    
    self.qiEmitter.emitterCells = @[qiCell];
}

- (void)updateTuVi:(int)currentBattery {
    if (self.lastBatteryLevel == -1) {
        self.lastBatteryLevel = currentBattery;
    }
    
    NSString *currentRealm = getRealmName(currentBattery);
    
    // Xử lý Phi Thăng (100%)
    if (currentBattery == 100) {
        self.statusLabel.text = @"PHI THĂNG";
        [self triggerAscension];
        return;
    }
    
    // Xử lý đột phá cảnh giới (Pin tăng và qua ngưỡng)
    if (currentBattery > self.lastBatteryLevel && ![currentRealm isEqualToString:getRealmName(self.lastBatteryLevel)]) {
        [self triggerBreakthrough];
    }
    
    // Tính toán ETA
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
        // Lần đầu cắm sạc, chưa có data để tính ETA
        self.statusLabel.text = [NSString stringWithFormat:@"%@\nĐang hấp thu linh khí...", currentRealm];
    }
    
    // Xử lý Độ Kiếp (95 - 99%)
    if (currentBattery >= 95 && currentBattery < 100) {
        [self enableTribulationMode];
    }
}

- (void)triggerBreakthrough {
    // Xung năng lượng nhẹ (tỏa sáng trận pháp)
    [UIView animateWithDuration:0.5 animations:^{
        self.arrayView.alpha = 1.0;
        self.arrayView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.5 animations:^{
            self.arrayView.alpha = 0.6;
            self.arrayView.transform = CGAffineTransformIdentity;
        }];
    }];
}

- (void)enableTribulationMode {
    // Thêm hiệu ứng rung nhẹ và tia chớp (Độ Kiếp)
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
    shake.duration = 0.05;
    shake.repeatCount = 10;
    shake.autoreverses = YES;
    shake.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.arrayView.center.x - 1, self.arrayView.center.y)];
    shake.toValue = [NSValue valueWithCGPoint:CGPointMake(self.arrayView.center.x + 1, self.arrayView.center.y)];
    [self.arrayView.layer addAnimation:shake forKey:@"shake"];
}

- (void)triggerAscension {
    // Linh khí bùng nổ nhẹ rồi biến mất
    self.qiEmitter.birthRate = 0; // Ngừng linh khí
    [UIView animateWithDuration:1.0 animations:^{
        self.alpha = 0.0; // Tan biến
    } completion:^(BOOL finished) {
        [self removeFromSuperview]; // Xóa hoàn toàn khỏi Lock Screen
    }];
}

@end


// --- CAN THIỆP VÀO LOCK SCREEN CỦA IOS ---

static TMCCultivationView *cultivationView = nil;

%hook CSCoverSheetViewController // Đây là class quản lý Lock Screen trên iOS 16

- (void)viewWillAppear:(BOOL)animated {
    %orig;
    
    UIDevice *device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    
    // Nếu đang cắm sạc
    if (device.batteryState == UIDeviceBatteryStateCharging || device.batteryState == UIDeviceBatteryStateFull) {
        if (!cultivationView) {
            // Khởi tạo view kích thước 180x200, đặt giữa màn hình
            cultivationView = [[TMCCultivationView alloc] initWithFrame:CGRectMake(0, 0, 180, 200)];
            cultivationView.center = self.view.center; 
            [self.view addSubview:cultivationView];
            
            // Cập nhật tu vi ngay lập tức
            [cultivationView updateTuVi:(int)(device.batteryLevel * 100)];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    %orig;
    // Khi người dùng mở khóa máy -> Hủy tu luyện
    if (cultivationView) {
        [cultivationView removeFromSuperview];
        cultivationView = nil;
    }
}

%end


// Lắng nghe sự kiện cắm/rút sạc theo thời gian thực ngay trên LockScreen
%hook SBUIController 

- (void)updateBatteryState:(id)arg1 {
    %orig;
    
    UIDevice *device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    
    if (cultivationView) {
        if (device.batteryState == UIDeviceBatteryStateUnplugged) {
            // Rút sạc -> Tu luyện kết thúc, view biến mất
            [UIView animateWithDuration:0.5 animations:^{
                cultivationView.alpha = 0;
            } completion:^(BOOL finished) {
                [cultivationView removeFromSuperview];
                cultivationView = nil;
            }];
        } else {
            // Đang sạc -> Cập nhật % pin liên tục
            [cultivationView updateTuVi:(int)(device.batteryLevel * 100)];
        }
    }
}

%end
