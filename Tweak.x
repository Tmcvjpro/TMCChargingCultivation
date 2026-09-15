#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>

@interface CSCoverSheetViewController : UIViewController
@end

@interface SBUIController : NSObject
@end

// --- HỆ THỐNG CẢNH GIỚI & TIỂU CẢNH GIỚI CHUẨN XÁC ---
typedef struct {
    NSString *realmName;
    NSString *subRealm;
} CultivationStatus;

CultivationStatus getCultivationStatus(int battery) {
    CultivationStatus status;
    if (battery < 10) {
        status.realmName = @"CHƯA NHẬP ĐẠO";
        status.subRealm = @"";
    } else if (battery <= 12) {
        status.realmName = @"PHÀM NHÂN";
        if (battery == 10) status.subRealm = @"Sơ Kỳ";
        else if (battery == 11) status.subRealm = @"Trung Kỳ";
        else status.subRealm = @"Hậu Kỳ";
    } else if (battery <= 15) {
        status.realmName = @"LUYỆN KHÍ";
        if (battery == 13) status.subRealm = @"Sơ Kỳ";
        else if (battery == 14) status.subRealm = @"Trung Kỳ";
        else status.subRealm = @"Hậu Kỳ";
    } else if (battery <= 20) {
        status.realmName = @"TRÚC CƠ";
        if (battery == 16) status.subRealm = @"Sơ Kỳ";
        else if (battery == 17) status.subRealm = @"Trung Kỳ";
        else if (battery <= 19) status.subRealm = @"Hậu Kỳ";
        else status.subRealm = @"Đỉnh Phong";
    } else if (battery <= 27) {
        status.realmName = @"KIM ĐAN";
        if (battery <= 22) status.subRealm = @"Sơ Kỳ";
        else if (battery <= 24) status.subRealm = @"Trung Kỳ";
        else if (battery <= 26) status.subRealm = @"Hậu Kỳ";
        else status.subRealm = @"Đỉnh Phong";
    } else if (battery <= 36) {
        status.realmName = @"NGUYÊN ANH";
        if (battery <= 29) status.subRealm = @"Sơ Kỳ";
        else if (battery <= 32) status.subRealm = @"Trung Kỳ";
        else if (battery <= 35) status.subRealm = @"Hậu Kỳ";
        else status.subRealm = @"Đỉnh Phong";
    } else if (battery <= 48) {
        status.realmName = @"HÓA THẦN";
        if (battery <= 39) status.subRealm = @"Sơ Kỳ";
        else if (battery <= 42) status.subRealm = @"Trung Kỳ";
        else if (battery <= 47) status.subRealm = @"Hậu Kỳ";
        else status.subRealm = @"Đỉnh Phong";
    } else if (battery <= 62) {
        status.realmName = @"LUYỆN HƯ";
        if (battery <= 52) status.subRealm = @"Sơ Kỳ";
        else if (battery <= 56) status.subRealm = @"Trung Kỳ";
        else if (battery <= 61) status.subRealm = @"Hậu Kỳ";
        else status.subRealm = @"Đỉnh Phong";
    } else if (battery <= 79) {
        status.realmName = @"ĐẠI THỪA";
        if (battery <= 66) status.subRealm = @"Sơ Kỳ";
        else if (battery <= 71) status.subRealm = @"Trung Kỳ";
        else if (battery <= 75) status.subRealm = @"Hậu Kỳ";
        else status.subRealm = @"Đỉnh Phong";
    } else if (battery <= 94) {
        status.realmName = @"ĐỘ KIẾP";
        if (battery <= 83) status.subRealm = @"Sơ Kỳ";
        else if (battery <= 87) status.subRealm = @"Trung Kỳ";
        else if (battery <= 91) status.subRealm = @"Hậu Kỳ";
        else status.subRealm = @"Đỉnh Phong";
    } else if (battery <= 99) {
        status.realmName = @"ĐỘ KIẾP · THIÊN KIẾP";
        status.subRealm = @"Thiên Lôi Giáng Lâm";
    } else {
        status.realmName = @"PHI THĂNG";
        status.subRealm = @"Đại Đạo Viên Mãn";
    }
    return status;
}

// --- GIAO DIỆN TU LUYỆN ĐÃ TỐI ƯU CÂN ĐỐI ---
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
        
        // Kích thước chuẩn gọn gàng, không bị to thô
        CGFloat centerX = frame.size.width / 2.0;
        CGFloat centerY = frame.size.height / 2.0 - 20;
        
        // 1. Trận pháp đặt chuẩn tâm tuyệt đối (Kích thước 200x200px)
        self.arrayView = [[UIView alloc] initWithFrame:CGRectMake(centerX - 100, centerY - 100, 200, 200)];
        [self addSubview:self.arrayView];
        [self setupPerfectArray];
        
        // 2. Nhân vật Tu sĩ đặt chuẩn tâm tuyệt đối (Kích thước 90x90px)
        self.monkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(centerX - 45, centerY - 45, 90, 90)];
        self.monkImageView.contentMode = UIViewContentModeScaleAspectFit;
        UIImage *tuSiImg = [UIImage imageWithContentsOfFile:@"/var/jb/tu_si.png"];
        if (tuSiImg) {
            self.monkImageView.image = tuSiImg;
        } else {
            UILabel *fallback = [[UILabel alloc] initWithFrame:self.monkImageView.bounds];
            fallback.text = @"🧘🏻‍♂️";
            fallback.font = [UIFont systemFontOfSize:55];
            fallback.textAlignment = NSTextAlignmentCenter;
            [self.monkImageView addSubview:fallback];
        }
        [self addSubview:self.monkImageView];
        
        // 3. Chữ cảnh giới & tiểu cảnh giới sắc nét nằm ngay bên dưới
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(centerX - 125, centerY + 105, 250, 45)];
        self.statusLabel.numberOfLines = 2;
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        self.statusLabel.textColor = [UIColor whiteColor];
        self.statusLabel.font = [UIColor.boldSystemFontOfSize:13];
        self.statusLabel.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.8 blue:1.0 alpha:1.0].CGColor;
        self.statusLabel.layer.shadowRadius = 6.0;
        self.statusLabel.layer.shadowOpacity = 1.0;
        self.statusLabel.layer.shadowOffset = CGSizeZero;
        [self addSubview:self.statusLabel];
        
        // 4. Linh khí từ viền màn hình hội tụ trực tiếp vào người nhân vật
        [self setupFocusedQiEmitter:CGPointMake(centerX, centerY)];
    }
    return self;
}

- (void)setupPerfectArray {
    UIColor *arrayColor = [UIColor colorWithRed:0.1 green:0.95 blue:1.0 alpha:1.0];
    
    // Vòng trận pháp ngoài
    CAShapeLayer *outerRing = [CAShapeLayer layer];
    outerRing.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(10, 10, 180, 180)].CGPath;
    outerRing.strokeColor = arrayColor.CGColor;
    outerRing.fillColor = [UIColor clearColor].CGColor;
    outerRing.lineWidth = 1.8;
    outerRing.shadowColor = arrayColor.CGColor;
    outerRing.shadowRadius = 8.0;
    outerRing.shadowOpacity = 0.8;
    [self.arrayView.layer addSublayer:outerRing];
    
    // Vòng bát quái đứt khúc bên trong
    CAShapeLayer *midRing = [CAShapeLayer layer];
    midRing.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(30, 30, 140, 140)].CGPath;
    midRing.strokeColor = arrayColor.CGColor;
    midRing.fillColor = [UIColor clearColor].CGColor;
    midRing.lineWidth = 1.5;
    midRing.lineDashPattern = @[@8, @6, @3, @6];
    [self.arrayView.layer addSublayer:midRing];
    
    // Ký tự cổ trận trung tâm
    UILabel *rune = [[UILabel alloc] initWithFrame:self.arrayView.bounds];
    rune.text = @"☸"; 
    rune.font = [UIFont systemFontOfSize:110 weight:UIFontWeightUltraLight];
    rune.textColor = [arrayColor colorWithAlphaComponent:0.25];
    rune.textAlignment = NSTextAlignmentCenter;
    [self.arrayView addSubview:rune];
    
    // Hoạt ảnh xoay
    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spin.toValue = @(M_PI * 2.0);
    spin.duration = 22.0;
    spin.repeatCount = HUGE_VALF;
    [self.arrayView.layer addAnimation:spin forKey:@"spinAnimation"];
}

- (void)setupFocusedQiEmitter:(CGPoint)targetCenter {
    self.screenEdgeQiEmitter = [CAEmitterLayer layer];
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGFloat screenW = screenBounds.size.width > 0 ? screenBounds.size.width : 390;
    CGFloat screenH = screenBounds.size.height > 0 ? screenBounds.size.height : 844;
    
    // Thiết lập nguồn linh khí từ viền màn hình hướng đúng tâm nhân vật
    self.screenEdgeQiEmitter.emitterPosition = targetCenter;
    self.screenEdgeQiEmitter.emitterSize = CGSizeMake(screenW - 30, screenH - 30);
    self.screenEdgeQiEmitter.emitterShape = kCAEmitterLayerRectangle;
    self.screenEdgeQiEmitter.renderMode = kCAEmitterLayerAdditive;
    
    CAEmitterCell *edgeCell = [CAEmitterCell emitterCell];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(7, 7), NO, 0);
    [[UIColor colorWithRed:0.2 green:1.0 blue:1.0 alpha:1.0] setFill];
    [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 7, 7)] fill];
    UIImage *qiDot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    edgeCell.contents = (id)qiDot.CGImage;
    edgeCell.birthRate = 40.0;
    edgeCell.lifetime = 2.0;
    edgeCell.velocity = -170.0; // Hút thẳng vào tâm
    edgeCell.velocityRange = 30.0;
    edgeCell.alphaSpeed = -0.3;
    edgeCell.scale = 0.8;
    
    self.screenEdgeQiEmitter.emitterCells = @[edgeCell];
    [self.layer addSublayer:self.screenEdgeQiEmitter];
}

- (void)updateTuVi:(int)currentBattery {
    if (self.lastBatteryLevel == -1) {
        self.lastBatteryLevel = currentBattery;
    }
    
    CultivationStatus status = getCultivationStatus(currentBattery);
    
    if (currentBattery >= 100) {
        self.statusLabel.text = @"PHI THĂNG\nĐại Đạo Viên Mãn";
        [self triggerAscension];
        return;
    }
    
    // Phát hiện đột phá khi % pin thay đổi
    if (currentBattery > self.lastBatteryLevel) {
        [self triggerBreakthroughEffect:currentBattery];
    }
    
    if (status.subRealm.length > 0) {
        self.statusLabel.text = [NSString stringWithFormat:@"%@\n· %@", status.realmName, status.subRealm];
    } else {
        self.statusLabel.text = status.realmName;
    }
    
    self.lastBatteryLevel = currentBattery;
}

- (void)triggerBreakthroughEffect:(int)battery {
    // Hiệu ứng linh khí tụ mạnh & trận pháp sáng lên khi đột phá
    [UIView animateWithDuration:0.4 animations:^{
        self.arrayView.transform = CGAffineTransformMakeScale(1.15, 1.15);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.2 animations:^{
            self.arrayView.transform = CGAffineTransformIdentity;
        }];
    }];
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

// --- HIỂN THỊ CHÍNH XÁC TRÊN LOCK SCREEN ---
static TMCCultivationView *cultivationView = nil;

%hook CSCoverSheetViewController 

- (void)viewWillAppear:(BOOL)animated {
    %orig;
    UIDevice *device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    
    if (device.batteryState == UIDeviceBatteryStateCharging || device.batteryState == UIDeviceBatteryStateFull) {
        if (!cultivationView) {
            CGRect screenBounds = [UIScreen mainScreen].bounds;
            // Khung vừa vặn, không bị to thô, đặt ở nửa dưới màn hình
            cultivationView = [[TMCCultivationView alloc] initWithFrame:screenBounds];
            
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
