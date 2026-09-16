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

// --- GIAO DIỆN TU LUYỆN (CODE DRAW 100%) ---
@interface TMCCultivationView : UIView
@property (nonatomic, strong) UIView *arrayContainer;
@property (nonatomic, strong) UIImageView *monkImageView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *fallbackMonk;
@property (nonatomic, strong) CAEmitterLayer *qiEmitter;
@property (nonatomic, strong) UIView *flashView; // Sấm sét
@property (nonatomic, strong) CAShapeLayer *outerRing;
@property (nonatomic, strong) CAShapeLayer *innerRing;
@property (nonatomic, strong) NSMutableArray *baguaLabels;
@property (nonatomic, assign) int lastBatteryLevel;
@end

@implementation TMCCultivationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        CGFloat centerX = frame.size.width / 2.0;
        CGFloat centerY = frame.size.height / 2.0 - 20;
        
        // 1. Flash View (Dành riêng cho Thiên Lôi)
        self.flashView = [[UIView alloc] initWithFrame:frame];
        self.flashView.backgroundColor = [UIColor whiteColor];
        self.flashView.alpha = 0.0;
        [self addSubview:self.flashView];
        
        // 2. Trận Pháp Vẽ Bằng Code (Không cần ảnh png)
        self.arrayContainer = [[UIView alloc] initWithFrame:CGRectMake(centerX - 95, centerY - 95, 190, 190)];
        [self addSubview:self.arrayContainer];
        [self drawBaguaMagicArray];
        
        // 3. Nhân vật Tu sĩ (Đã có phương án dự phòng cực xịn nếu không có ảnh)
        self.monkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(centerX - 40, centerY - 40, 80, 80)];
        self.monkImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        // Đọc ảnh Tusi (Nếu đạo hữu tải ảnh chép vào var/jb/)
        UIImage *tuSiImg = [UIImage imageWithContentsOfFile:@"/var/jb/tu_si.png"];
        if (tuSiImg) {
            self.monkImageView.image = tuSiImg;
        } else {
            // Nếu không có ảnh, hiện ngay ông sư đang thiền cực chất
            self.fallbackMonk = [[UILabel alloc] initWithFrame:self.monkImageView.bounds];
            self.fallbackMonk.text = @"🧘🏻‍♂️";
            self.fallbackMonk.font = [UIFont systemFontOfSize:55];
            self.fallbackMonk.textAlignment = NSTextAlignmentCenter;
            
            // Hào quang tỏa ra quanh người tu sĩ
            self.fallbackMonk.layer.shadowColor = [UIColor cyanColor].CGColor;
            self.fallbackMonk.layer.shadowRadius = 15.0;
            self.fallbackMonk.layer.shadowOpacity = 1.0;
            self.fallbackMonk.layer.shadowOffset = CGSizeZero;
            [self.monkImageView addSubview:self.fallbackMonk];
        }
        [self addSubview:self.monkImageView];
        
        // 4. Chữ Cảnh Giới
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(centerX - 130, centerY + 105, 260, 45)];
        self.statusLabel.numberOfLines = 2;
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        self.statusLabel.textColor = [UIColor whiteColor];
        self.statusLabel.font = [UIFont boldSystemFontOfSize:14];
        self.statusLabel.layer.shadowRadius = 5.0;
        self.statusLabel.layer.shadowOpacity = 1.0;
        self.statusLabel.layer.shadowOffset = CGSizeZero;
        [self addSubview:self.statusLabel];
        
        // 5. Hệ thống Linh khí
        [self setupQiEmitter:CGPointMake(centerX, centerY)];
        
        self.lastBatteryLevel = -1;
    }
    return self;
}

- (void)drawBaguaMagicArray {
    // Vòng ngoài
    self.outerRing = [CAShapeLayer layer];
    self.outerRing.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(5, 5, 180, 180)].CGPath;
    self.outerRing.fillColor = [UIColor clearColor].CGColor;
    self.outerRing.lineWidth = 2.0;
    self.outerRing.shadowRadius = 8.0;
    self.outerRing.shadowOpacity = 1.0;
    self.outerRing.shadowOffset = CGSizeZero;
    [self.arrayContainer.layer addSublayer:self.outerRing];
    
    // Vòng trong
    self.innerRing = [CAShapeLayer layer];
    self.innerRing.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(25, 25, 140, 140)].CGPath;
    self.innerRing.fillColor = [UIColor clearColor].CGColor;
    self.innerRing.lineWidth = 1.5;
    self.innerRing.lineDashPattern = @[@12, @6, @4, @6];
    self.innerRing.shadowRadius = 5.0;
    self.innerRing.shadowOpacity = 1.0;
    self.innerRing.shadowOffset = CGSizeZero;
    [self.arrayContainer.layer addSublayer:self.innerRing];
    
    // Vẽ Bát Quái
    NSArray *bagua = @[@"☰", @"☱", @"☲", @"☳", @"☴", @"☵", @"☶", @"☷"];
    self.baguaLabels = [NSMutableArray array];
    for (int i = 0; i < 8; i++) {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        lbl.center = CGPointMake(95, 95); // Tâm trận pháp
        lbl.text = bagua[i];
        lbl.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
        lbl.textAlignment = NSTextAlignmentCenter;
        
        // Thuật toán đẩy chữ ra thành vòng tròn
        CGAffineTransform t = CGAffineTransformMakeRotation(i * (M_PI / 4.0));
        t = CGAffineTransformTranslate(t, 0, -75);
        lbl.transform = t;
        
        [self.arrayContainer addSubview:lbl];
        [self.baguaLabels addObject:lbl];
    }
    
    // Xoay vĩnh cửu
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
    cell.velocity = -250.0; // Hút thẳng vào nhân vật
    cell.velocityRange = 40.0;
    cell.alphaSpeed = -0.5;
    cell.scale = 0.8;
    
    self.qiEmitter.emitterCells = @[cell];
    [self.layer insertSublayer:self.qiEmitter below:self.arrayContainer.layer];
}

// --- XỬ LÝ HIỆU ỨNG TĨNH CHO TỪNG CẢNH GIỚI ---
- (void)applyRealmEffects:(int)majorLevel {
    UIColor *auraColor;
    float spinSpeed = 20.0;
    [self.flashView.layer removeAnimationForKey:@"lightning"]; // Tắt lôi kiếp mặc định
    
    // Tùy chỉnh hào quang theo cảnh giới
    if (majorLevel <= 2) { // Phàm Nhân, Luyện Khí
        auraColor = [UIColor colorWithRed:0.5 green:0.8 blue:1.0 alpha:1.0];
    } else if (majorLevel <= 4) { // Trúc Cơ, Kim Đan
        auraColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0]; // Ánh Kim
        spinSpeed = 15.0;
    } else if (majorLevel <= 6) { // Nguyên Anh, Hóa Thần
        auraColor = [UIColor colorWithRed:0.8 green:0.0 blue:1.0 alpha:1.0]; // Tím Huyền Ảo
        spinSpeed = 10.0;
    } else if (majorLevel <= 8) { // Luyện Hư, Đại Thừa
        auraColor = [UIColor colorWithRed:1.0 green:0.2 blue:0.2 alpha:1.0]; // Huyết Sắc Uy Áp
        spinSpeed = 7.0;
    } else { // Độ Kiếp, Phi Thăng
        auraColor = [UIColor cyanColor]; // Lôi Điện
        spinSpeed = 4.0; // Xoay cực nhanh
        
        // Gọi Thiên Lôi
        CAKeyframeAnimation *lightning = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        lightning.values = @[@0, @0.8, @0, @0.4, @0];
        lightning.keyTimes = @[@0, @0.05, @0.1, @0.15, @1.0];
        lightning.duration = 2.0; // Cứ 2s giật 1 phát
        lightning.repeatCount = HUGE_VALF;
        [self.flashView.layer addAnimation:lightning forKey:@"lightning"];
    }
    
    // Cập nhật màu Trận pháp & Hạt linh khí
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
    if (majorLevel >= 7) cell.birthRate = 100.0; // Đại thừa linh khí siêu dày
    else cell.birthRate = 45.0;
    self.qiEmitter.emitterCells = @[cell];
    
    // Cập nhật tốc độ quay
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
        // Áp dụng hiệu ứng tĩnh ngay khi vừa cắm sạc
        [self applyRealmEffects:getCultivationStatus(currentBattery).majorLevel];
    }
    
    CultivationStatus status = getCultivationStatus(currentBattery);
    
    if (currentBattery >= 100) {
        self.statusLabel.text = @"PHI THĂNG\n· Đại Đạo Viên Mãn ·";
        return;
    }
    
    // Phát hiện ĐỘT PHÁ
    if (currentBattery > self.lastBatteryLevel) {
        [self triggerBreakthrough:status];
    } else {
        if (status.subRealm.length > 0) {
            self.statusLabel.text = [NSString stringWithFormat:@"%@\n· %@ ·", status.realmName, status.subRealm];
        } else {
            self.statusLabel.text = status.realmName;
        }
    }
    self.lastBatteryLevel = currentBattery;
}

- (void)triggerBreakthrough:(CultivationStatus)newStatus {
    self.statusLabel.text = @"— ĐỘT PHÁ —";
    self.statusLabel.textColor = [UIColor yellowColor];
    
    // Linh khí tràn ngập
    CAEmitterCell *cell = [self.qiEmitter.emitterCells firstObject];
    float oldBirth = cell.birthRate;
    cell.birthRate = 250.0;
    self.qiEmitter.emitterCells = @[cell];
    
    // Trận pháp phình to
    [UIView animateWithDuration:1.5 animations:^{
        self.arrayContainer.transform = CGAffineTransformMakeScale(1.3, 1.3);
    } completion:^(BOOL finished) {
        // Lóa sáng đột phá
        [UIView animateWithDuration:0.2 animations:^{
            self.flashView.alpha = 0.9;
            self.arrayContainer.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                self.flashView.alpha = 0.0;
            } completion:^(BOOL finished) {
                // Đột phá thành công, áp dụng hiệu ứng cảnh giới mới
                self.statusLabel.textColor = [UIColor whiteColor];
                self.statusLabel.text = [NSString stringWithFormat:@"%@\n· %@ ·", newStatus.realmName, newStatus.subRealm];
                [self applyRealmEffects:newStatus.majorLevel];
            }];
        }];
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
