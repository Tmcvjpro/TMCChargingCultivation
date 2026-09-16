#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>

@interface CSCoverSheetViewController : UIViewController
@end

@interface SBUIController : NSObject
@end

// --- HỆ THỐNG CẢNH GIỚI ĐỘC TÔN ---
typedef struct {
    int majorLevel; // Dùng để xác định hiệu ứng đột phá lớn
    NSString *realmName;
    NSString *subRealm;
} CultivationStatus;

CultivationStatus getCultivationStatus(int battery) {
    CultivationStatus status;
    
    if (battery < 10) {
        status.majorLevel = 0; status.realmName = @"CHƯA NHẬP ĐẠO"; status.subRealm = @"";
    } 
    else if (battery <= 12) {
        status.majorLevel = 1; status.realmName = @"PHÀM NHÂN";
        if (battery == 10) status.subRealm = @"Sơ Kỳ";
        else if (battery == 11) status.subRealm = @"Trung Kỳ";
        else status.subRealm = @"Hậu Kỳ";
    } 
    else if (battery <= 15) {
        status.majorLevel = 2; status.realmName = @"LUYỆN KHÍ";
        if (battery == 13) status.subRealm = @"Sơ Kỳ";
        else if (battery == 14) status.subRealm = @"Trung Kỳ";
        else status.subRealm = @"Hậu Kỳ";
    } 
    else if (battery <= 20) {
        status.majorLevel = 3; status.realmName = @"TRÚC CƠ";
        if (battery == 16) status.subRealm = @"Sơ Kỳ";
        else if (battery == 17) status.subRealm = @"Trung Kỳ";
        else if (battery <= 19) status.subRealm = @"Hậu Kỳ";
        else status.subRealm = @"Đỉnh Phong";
    } 
    else if (battery <= 27) {
        status.majorLevel = 4; status.realmName = @"KIM ĐAN";
        if (battery <= 22) status.subRealm = @"Sơ Kỳ";
        else if (battery <= 24) status.subRealm = @"Trung Kỳ";
        else if (battery <= 26) status.subRealm = @"Hậu Kỳ";
        else status.subRealm = @"Đỉnh Phong";
    } 
    else if (battery <= 36) {
        status.majorLevel = 5; status.realmName = @"NGUYÊN ANH";
        if (battery <= 29) status.subRealm = @"Sơ Kỳ";
        else if (battery <= 32) status.subRealm = @"Trung Kỳ";
        else if (battery <= 35) status.subRealm = @"Hậu Kỳ";
        else status.subRealm = @"Đỉnh Phong";
    } 
    else if (battery <= 48) {
        status.majorLevel = 6; status.realmName = @"HÓA THẦN";
        if (battery <= 39) status.subRealm = @"Sơ Kỳ";
        else if (battery <= 42) status.subRealm = @"Trung Kỳ";
        else if (battery <= 45) status.subRealm = @"Hậu Kỳ";
        else status.subRealm = @"Đỉnh Phong";
    } 
    else if (battery <= 62) {
        status.majorLevel = 7; status.realmName = @"LUYỆN HƯ";
        if (battery <= 52) status.subRealm = @"Sơ Kỳ";
        else if (battery <= 56) status.subRealm = @"Trung Kỳ";
        else if (battery <= 59) status.subRealm = @"Hậu Kỳ";
        else status.subRealm = @"Đỉnh Phong";
    } 
    else if (battery <= 79) {
        status.majorLevel = 8; status.realmName = @"ĐẠI THỪA";
        if (battery <= 66) status.subRealm = @"Sơ Kỳ";
        else if (battery <= 71) status.subRealm = @"Trung Kỳ";
        else if (battery <= 75) status.subRealm = @"Hậu Kỳ";
        else status.subRealm = @"Đỉnh Phong";
    } 
    else if (battery <= 94) {
        status.majorLevel = 9; status.realmName = @"ĐỘ KIẾP";
        if (battery <= 83) status.subRealm = @"Sơ Kỳ";
        else if (battery <= 87) status.subRealm = @"Trung Kỳ";
        else if (battery <= 91) status.subRealm = @"Hậu Kỳ";
        else status.subRealm = @"Đỉnh Phong";
    } 
    else if (battery <= 99) {
        status.majorLevel = 10; status.realmName = @"ĐỘ KIẾP · THIÊN KIẾP";
        status.subRealm = @"Thiên Lôi Giáng Lâm";
    } 
    else {
        status.majorLevel = 11; status.realmName = @"PHI THĂNG";
        status.subRealm = @"Đại Đạo Viên Mãn";
    }
    return status;
}

// --- GIAO DIỆN TU LUYỆN ĐỈNH CAO ---
@interface TMCCultivationView : UIView
@property (nonatomic, strong) UIImageView *monkImageView;
@property (nonatomic, strong) UIImageView *arrayImageView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) CAEmitterLayer *screenEdgeQiEmitter;
@property (nonatomic, strong) UIView *flashView; // Dùng cho hiệu ứng lóa sáng
@property (nonatomic, assign) int lastBatteryLevel;
@property (nonatomic, assign) BOOL isBreakingThrough;
@end

@implementation TMCCultivationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.isBreakingThrough = NO;
        
        CGFloat centerX = frame.size.width / 2.0;
        CGFloat centerY = frame.size.height / 2.0 - 15;
        
        // Flash View ẩn (Dùng cho chớp sáng lôi kiếp/đột phá)
        self.flashView = [[UIView alloc] initWithFrame:frame];
        self.flashView.backgroundColor = [UIColor whiteColor];
        self.flashView.alpha = 0.0;
        [self addSubview:self.flashView];
        
        // 1. Trận pháp
        self.arrayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(centerX - 90, centerY - 90, 180, 180)];
        self.arrayImageView.contentMode = UIViewContentModeScaleAspectFit;
        UIImage *tranPhapImg = [UIImage imageWithContentsOfFile:@"/var/jb/tran_phap.png"];
        if (tranPhapImg) self.arrayImageView.image = tranPhapImg;
        [self addSubview:self.arrayImageView];
        [self startNormalArraySpin];
        
        // 2. Tu sĩ
        self.monkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(centerX - 40, centerY - 40, 80, 80)];
        self.monkImageView.contentMode = UIViewContentModeScaleAspectFit;
        UIImage *tuSiImg = [UIImage imageWithContentsOfFile:@"/var/jb/tu_si.png"];
        if (tuSiImg) self.monkImageView.image = tuSiImg;
        [self addSubview:self.monkImageView];
        
        // 3. Chữ cảnh giới
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(centerX - 120, centerY + 95, 240, 45)];
        self.statusLabel.numberOfLines = 2;
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        self.statusLabel.textColor = [UIColor whiteColor];
        self.statusLabel.font = [UIFont boldSystemFontOfSize:13];
        self.statusLabel.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.8 blue:1.0 alpha:1.0].CGColor;
        self.statusLabel.layer.shadowRadius = 5.0;
        self.statusLabel.layer.shadowOpacity = 1.0;
        self.statusLabel.layer.shadowOffset = CGSizeZero;
        [self addSubview:self.statusLabel];
        
        // 4. Linh khí
        [self setupQiEmitter:CGPointMake(centerX, centerY)];
    }
    return self;
}

- (void)startNormalArraySpin {
    [self.arrayImageView.layer removeAnimationForKey:@"spinAnimation"];
    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spin.toValue = @(M_PI * 2.0);
    spin.duration = 25.0; // Quay chậm tĩnh tâm
    spin.repeatCount = HUGE_VALF;
    [self.arrayImageView.layer addAnimation:spin forKey:@"spinAnimation"];
}

- (void)setupQiEmitter:(CGPoint)targetCenter {
    self.screenEdgeQiEmitter = [CAEmitterLayer layer];
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    self.screenEdgeQiEmitter.emitterPosition = targetCenter;
    self.screenEdgeQiEmitter.emitterSize = CGSizeMake(screenBounds.size.width, screenBounds.size.height);
    self.screenEdgeQiEmitter.emitterShape = kCAEmitterLayerRectangle;
    self.screenEdgeQiEmitter.renderMode = kCAEmitterLayerAdditive;
    
    CAEmitterCell *edgeCell = [CAEmitterCell emitterCell];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(3, 3), NO, 0);
    [[UIColor colorWithRed:0.2 green:0.9 blue:1.0 alpha:1.0] setFill];
    [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 3, 3)] fill];
    UIImage *qiDot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    edgeCell.contents = (id)qiDot.CGImage;
    edgeCell.birthRate = 40.0;
    edgeCell.lifetime = 1.8;
    edgeCell.velocity = -200.0; 
    edgeCell.velocityRange = 30.0;
    edgeCell.alphaSpeed = -0.4;
    edgeCell.scale = 0.6;
    
    self.screenEdgeQiEmitter.emitterCells = @[edgeCell];
    [self.layer insertSublayer:self.screenEdgeQiEmitter below:self.arrayImageView.layer];
}

- (void)updateTuVi:(int)currentBattery {
    if (self.lastBatteryLevel == -1) {
        self.lastBatteryLevel = currentBattery;
    }
    
    if (self.isBreakingThrough) return; // Đang đột phá thì bỏ qua cập nhật
    
    CultivationStatus oldStatus = getCultivationStatus(self.lastBatteryLevel);
    CultivationStatus newStatus = getCultivationStatus(currentBattery);
    
    if (currentBattery >= 100) {
        self.statusLabel.text = @"PHI THĂNG\nĐại Đạo Viên Mãn";
        return;
    }
    
    // Nếu có sự chuyển biến tiểu cảnh giới hoặc đại cảnh giới
    if (![oldStatus.subRealm isEqualToString:newStatus.subRealm] || oldStatus.majorLevel != newStatus.majorLevel) {
        [self processBreakthroughFrom:oldStatus to:newStatus battery:currentBattery];
    } else {
        // Bình thường
        [self setStatusText:newStatus];
    }
    
    self.lastBatteryLevel = currentBattery;
}

- (void)setStatusText:(CultivationStatus)status {
    if (status.subRealm.length > 0) {
        self.statusLabel.text = [NSString stringWithFormat:@"%@\n· %@ ·", status.realmName, status.subRealm];
    } else {
        self.statusLabel.text = status.realmName;
    }
}

// --- QUY TRÌNH ĐỘT PHÁ NGHỊCH THIÊN ---
- (void)processBreakthroughFrom:(CultivationStatus)oldStatus to:(CultivationStatus)newStatus battery:(int)battery {
    self.isBreakingThrough = YES;
    
    // 1. Chữ chuyển sang trạng thái đột phá
    self.statusLabel.text = @"— ĐANG ĐỘT PHÁ —";
    self.statusLabel.textColor = [UIColor yellowColor];
    
    // 2. Trận pháp xoay cuồng bạo
    [self.arrayImageView.layer removeAnimationForKey:@"spinAnimation"];
    CABasicAnimation *fastSpin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    fastSpin.toValue = @(M_PI * 2.0);
    fastSpin.duration = 1.0; 
    fastSpin.repeatCount = 3.0;
    [self.arrayImageView.layer addAnimation:fastSpin forKey:@"fastSpin"];
    
    // 3. Linh khí tụ mạnh (Nhập thể)
    CAEmitterCell *cell = [self.screenEdgeQiEmitter.emitterCells firstObject];
    cell.birthRate = 150.0;
    cell.velocity = -400.0; // Rút linh khí cực nhanh
    self.screenEdgeQiEmitter.emitterCells = @[cell];
    
    // 4. Hiệu ứng riêng theo từng Đại Cảnh Giới mới
    if (newStatus.majorLevel == 4) { // Lên Kim Đan (Ánh kim)
        self.arrayImageView.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.3];
        self.arrayImageView.layer.cornerRadius = 90;
    } 
    else if (newStatus.majorLevel >= 9) { // Độ Kiếp (Thiên Lôi)
        [self simulateThunderStrike];
    }
    
    // Trận pháp phình to hấp thu
    [UIView animateWithDuration:1.0 animations:^{
        self.arrayImageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        
        // 5. Ánh sáng lóe nhẹ (Hoàn thành đột phá)
        [UIView animateWithDuration:0.2 animations:^{
            self.flashView.alpha = 0.8;
            self.arrayImageView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                self.flashView.alpha = 0.0;
                self.arrayImageView.backgroundColor = [UIColor clearColor];
            } completion:^(BOOL finished) {
                
                // 6. Cảnh giới mới ổn định, trở lại bình thường
                self.statusLabel.textColor = [UIColor whiteColor];
                [self setStatusText:newStatus];
                
                // Trả linh khí về tĩnh lặng
                cell.birthRate = 40.0;
                cell.velocity = -200.0;
                self.screenEdgeQiEmitter.emitterCells = @[cell];
                
                [self startNormalArraySpin];
                self.isBreakingThrough = NO;
            }];
        }];
    }];
}

- (void)simulateThunderStrike {
    // Rung chuyển thiên địa
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
    shake.duration = 0.05;
    shake.repeatCount = 20;
    shake.autoreverses = YES;
    shake.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x - 5, self.center.y)];
    shake.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x + 5, self.center.y)];
    [self.layer addAnimation:shake forKey:@"shake"];
    
    // Chớp nháy lôi kiếp
    self.flashView.backgroundColor = [UIColor cyanColor];
    [UIView animateWithDuration:0.1 animations:^{
        self.flashView.alpha = 0.7;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.flashView.alpha = 0.0;
            self.flashView.backgroundColor = [UIColor whiteColor];
        }];
    }];
}

@end

// --- VỊ TRÍ HIỂN THỊ ---
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
