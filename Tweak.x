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

// --- GIAO DIỆN TU LUYỆN ĐÃ THU NHỎ VÀ CÂN ĐỐI ---
@interface TMCCultivationView : UIView
@property (nonatomic, strong) UIImageView *monkImageView;
@property (nonatomic, strong) UIView *arrayView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) CAEmitterLayer *screenEdgeQiEmitter;
@property (nonatomic, assign) int lastBatteryLevel;
@end

@implementation TMCCultivationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        CGFloat centerX = frame.size.width / 2.0;
        CGFloat centerY = frame.size.height / 2.0 - 15;
        
        // 1. Trận pháp gọn gàng cân đối (Kích thước 170x170px)
        self.arrayView = [[UIView alloc] initWithFrame:CGRectMake(centerX - 85, centerY - 85, 170, 170)];
        [self addSubview:self.arrayView];
        [self setupPerfectArray];
        
        // 2. Nhân vật Tu sĩ chuẩn tâm tuyệt đối (Kích thước 75x75px - Thu nhỏ vừa vặn)
        self.monkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(centerX - 37.5, centerY - 37.5, 75, 75)];
        self.monkImageView.contentMode = UIViewContentModeScaleAspectFit;
        UIImage *tuSiImg = [UIImage imageWithContentsOfFile:@"/var/jb/tu_si.png"];
        if (tuSiImg) {
            self.monkImageView.image = tuSiImg;
        } else {
            UILabel *fallback = [[UILabel alloc] initWithFrame:self.monkImageView.bounds];
            fallback.text = @"🧘🏻‍♂️";
            fallback.font = [UIFont systemFontOfSize:45];
            fallback.textAlignment = NSTextAlignmentCenter;
            [self.monkImageView addSubview:fallback];
        }
        [self addSubview:self.monkImageView];
        
        // 3. Chữ cảnh giới sắc nét nằm ngay dưới
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(centerX - 110, centerY + 92, 220, 45)];
        self.statusLabel.numberOfLines = 2;
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        self.statusLabel.textColor = [UIColor whiteColor];
        self.statusLabel.font = [UIFont boldSystemFontOfSize:12]; // Đã fix lỗi cú pháp font
        self.statusLabel.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.8 blue:1.0 alpha:1.0].CGColor;
        self.statusLabel.layer.shadowRadius = 5.0;
        self.statusLabel.layer.shadowOpacity = 1.0;
        self.statusLabel.layer.shadowOffset = CGSizeZero;
        [self addSubview:self.statusLabel];
        
        // 4. Linh khí từ viền hội tụ thẳng vào nhân vật
        [self setupFocusedQiEmitter:CGPointMake(centerX, centerY)];
    }
    return self;
}

- (void)setupPerfectArray {
    UIColor *arrayColor = [UIColor colorWithRed:0.1 green:0.95 blue:1.0 alpha:1.0];
    
    CAShapeLayer *outerRing = [CAShapeLayer layer];
    outerRing.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(5, 5, 160, 160)].CGPath;
    outerRing.strokeColor = arrayColor.CGColor;
    outerRing.fillColor = [UIColor clearColor].CGColor;
    outerRing.lineWidth = 1.5;
    outerRing.shadowColor = arrayColor.CGColor;
    outerRing.shadowRadius = 6.0;
    outerRing.shadowOpacity = 0.8;
    [self.arrayView.layer addSublayer:outerRing];
    
    CAShapeLayer *midRing = [CAShapeLayer layer];
    midRing.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(25, 25, 120, 120)].CGPath;
    midRing.strokeColor = arrayColor.CGColor;
    midRing.fillColor = [UIColor clearColor].CGColor;
    midRing.lineWidth = 1.2;
    midRing.lineDashPattern = @[@7, @5, @3, @5];
    [self.arrayView.layer addSublayer:midRing];
    
    UILabel *rune = [[UILabel alloc] initWithFrame:self.arrayView.bounds];
    rune.text = @"☸"; 
    rune.font = [UIFont systemFontOfSize:95 weight:UIFontWeightUltraLight];
    rune.textColor = [arrayColor colorWithAlphaComponent:0.25];
    rune.textAlignment = NSTextAlignmentCenter;
    [self.arrayView addSubview:rune];
    
    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spin.toValue = @(M_PI * 2.0);
    spin.duration = 24.0;
    spin.repeatCount = HUGE_VALF;
    [self.arrayView.layer addAnimation:spin forKey:@"spinAnimation"];
}

- (void)setupFocusedQiEmitter:(CGPoint)targetCenter {
    self.screenEdgeQiEmitter = [CAEmitterLayer layer];
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGFloat screenW = screenBounds.size.width > 0 ? screenBounds.size.width : 390;
    CGFloat screenH = screenBounds.size.height > 0 ? screenBounds.size.height : 844;
    
    self.screenEdgeQiEmitter.emitterPosition = targetCenter;
    self.screenEdgeQiEmitter.emitterSize = CGSizeMake(screenW - 20, screenH - 20);
    self.screenEdgeQiEmitter.emitterShape = kCAEmitterLayerRectangle;
    self.screenEdgeQiEmitter.renderMode = kCAEmitterLayerAdditive;
    
    CAEmitterCell *edgeCell = [CAEmitterCell emitterCell];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(6, 6), NO, 0);
    [[UIColor colorWithRed:0.2 green:1.0 blue:1.0 alpha:1.0] setFill];
    [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 6, 6)] fill];
    UIImage *qiDot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    edgeCell.contents = (id)qiDot.CGImage;
    edgeCell.birthRate = 45.0;
    edgeCell.lifetime = 1.8;
    edgeCell.velocity = -190.0;
    edgeCell.velocityRange = 25.0;
    edgeCell.alphaSpeed = -0.35;
    edgeCell.scale = 0.7;
    
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
    
    if (currentBattery > self.lastBatteryLevel) {
        [self triggerBreakthroughEffect];
    }
    
    if (status.subRealm.length > 0) {
        self.statusLabel.text = [NSString stringWithFormat:@"%@\n· %@", status.realmName, status.subRealm];
    } else {
        self.statusLabel.text = status.realmName;
    }
    
    self.lastBatteryLevel = currentBattery;
}

- (void)triggerBreakthroughEffect {
    [UIView animateWithDuration:0.3 animations:^{
        self.arrayView.transform = CGAffineTransformMakeScale(1.12, 1.12);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 animations:^{
            self.arrayView.transform = CGAffineTransformIdentity;
        }];
    }];
}

- (void)triggerAscension {
    self.screenEdgeQiEmitter.birthRate = 0;
    [UIView animateWithDuration:1.2 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
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
            CGRect screenBounds = [UIScreen mainScreen].bounds;
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
