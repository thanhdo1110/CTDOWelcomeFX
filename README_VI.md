# 🚀 CTDOWelcomeFX

<div align="right">
  <a href="README.md">🇬🇧 English</a>
</div>

<div align="center">

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)
![iOS](https://img.shields.io/badge/iOS-13.0+-blue.svg)

</div>

<div align="center">
  <img src="https://raw.githubusercontent.com/thanhdo1110/CTDOWelcomeFX/main/Resources/demo.gif" alt="Demo Chế Độ Tối" width="300"/>
  <img src="https://raw.githubusercontent.com/thanhdo1110/CTDOWelcomeFX/main/Resources/demo1.gif" alt="Demo Chế Độ Sáng" width="300"/>
</div>

## 📱 Giới Thiệu

Thư viện tạo trải nghiệm WelcomeFX đẹp mắt và có thể tùy chỉnh cho các ứng dụng iOS. Thư viện này cung cấp cách hiện đại và hấp dẫn để giới thiệu các tính năng của ứng dụng cho người dùng mới.

## ✨ Tính Năng

- 🎨 Thiết kế UI hiện đại và sạch sẽ
- 📱 Hỗ trợ cả iPhone và iPad
- 🔄 Hiệu ứng và chuyển động mượt mà
- 🎯 Nội dung và giao diện có thể tùy chỉnh
- 🔒 Tùy chọn hiển thị một lần hoặc mỗi lần khởi động
- 🌐 Hỗ trợ liên kết trong văn bản mô tả
- 🖼️ Tự động sử dụng SF Symbols khi không có hình ảnh

## 🛠 Cài Đặt

### Git Clone
```bash
git clone https://github.com/thanhdo1110/CTDOWelcomeFX.git
```

### Thủ Công
Chỉ cần thêm `CTDOWelcomeFX.h` và `CTDOWelcomeFX.m` vào dự án của bạn.

## 📖 Cách Sử Dụng

### Triển Khai Cơ Bản

```obj-c++
#import "CTDOWelcomeFX/CTDOWelcomeFX.h"
#import "CTDOWelcomeFX/CTDOWelcomeFXImages.h"

@interface CTDOWelcomeFXTweak : NSObject
+ (void)load;
@end

@implementation CTDOWelcomeFXTweak

+ (void)load {
    @autoreleasepool {
        // --- 1. Khởi tạo cấu hình ---
        CTDOWelcomeFXConfiguration *config = [CTDOWelcomeFXConfiguration defaultConfiguration];

        // --- 2. Config tuỳ chỉnh ---
        config.appIcon = [CTDOWelcomeFXImages appIconImage];
        config.appName = @"ctdotech";
        config.welcomeTitle = @"Welcome to";
        config.continueButtonText = @"continue";
        config.descriptionText = @"Please join my community here...";
        config.linkText = @"here...";
        config.linkURL = [NSURL URLWithString:@"https://ctdo.net"];
        config.userDefaultsKey = @"hasShownMyTweakctdowelcomefx";
        config.showEveryLaunch = YES;
        config.appNameColor = [UIColor colorWithRed:0.0 green:0.7137 blue:0.7255 alpha:1.0]; // Màu xanh dương
        // config.appNameColor = [UIColor colorWithRed:0.0/255.0 green:201.0/255.0 blue:167.0/255.0 alpha:1.0]; 

        // Tạo các features của bạn
        CTDOWelcomeFXFeature *feature1 = [[CTDOWelcomeFXFeature alloc] 
                                            initWithIcon:[CTDOWelcomeFXImages feature1Image]
                                            title:@"Privacy policy" 
                                            subtitle:@"We do not collect any of your information.\nYour security is guaranteed."];
                                            
        CTDOWelcomeFXFeature *feature2 = [[CTDOWelcomeFXFeature alloc] 
                                            initWithIcon:[CTDOWelcomeFXImages feature2Image]
                                            title:@"Interface" 
                                            subtitle:@"Smooth, easy, and friendly to use."];

        CTDOWelcomeFXFeature *feature3 = [[CTDOWelcomeFXFeature alloc] 
                                            initWithIcon:[CTDOWelcomeFXImages feature3Image]
                                            title:@"Features" 
                                            subtitle:@"Diverse and innovative for a better experience."];
                                            
        config.features = @[feature1, feature2, feature3];
        
        // --- 3. Gọi để hiển thị  ---
        dispatch_async(dispatch_get_main_queue(), ^{
            [CTDOWelcomeFXViewController showctdowelcomefxIfNeededWithConfiguration:config 
                                                                  inViewController:nil
                                                                        completion:^{
                NSLog(@"MyTweak by ctdoteam || @dothanh1110");
            }];
        });
    }
}

@end
```

## 🎨 Hướng Dẫn Sử Dụng Ảnh

### 1. App Icon
- Kích thước khuyến nghị: 1024x1024px
- Định dạng: PNG
- Có thể tải từ Assets.xcassets hoặc file PNG
- Có sẵn SF Symbols làm fallback

### 2. Feature Icons
- Kích thước khuyến nghị: 60x60px
- Định dạng: PNG
- Có thể tải từ Assets.xcassets hoặc file PNG
- Có sẵn SF Symbols làm fallback

### 3. SF Symbols
- Sẵn sàng làm fallback khi không có ảnh
- Tự động điều chỉnh kích thước cho các màn hình khác nhau
- Hỗ trợ màu động và chế độ tối
- Ví dụ: "star.fill", "lock.shield.fill", "paintbrush.pointed.fill"

## ⚙️ Cấu Hình

| Thuộc tính | Mô tả |
|------------|--------|
| `appIcon` | Icon của ứng dụng (UIImage hoặc SF Symbol) |
| `welcomeTitle` | Lời chào (ví dụ: "Welcome to") |
| `appName` | Tên ứng dụng |
| `appNameColor` | Màu sắc cho tên ứng dụng |
| `features` | Mảng các tính năng cần hiển thị |
| `descriptionText` | Văn bản mô tả ở dưới cùng |
| `linkText` | Văn bản cần liên kết |
| `linkURL` | URL cho liên kết |
| `continueButtonText` | Văn bản cho nút tiếp tục |
| `userDefaultsKey` | Khóa lưu trạng thái hiển thị |
| `showEveryLaunch` | Có hiển thị mỗi lần khởi động hay không |

## 📋 Yêu Cầu

- iOS 13.0+
- Xcode 11.0+/Theos
- Objective-C/C++

## 📄 Giấy Phép

Dự án này được cung cấp dưới giấy phép MIT. Xem file [LICENSE](LICENSE) để biết thêm chi tiết.

## 👥 Tác Giả

<div align="center">
  <img src="https://raw.githubusercontent.com/thanhdo1110/CTDOWelcomeFX/main/Resources/logo.png" alt="CTDOTECH Logo" width="200"/>
  
  **CTDOTECH Team** - [@thanhdo1110](https://github.com/thanhdo1110)

</div>

---
<div align="center">
  <sub>Built with ❤️ by <a href="https://github.com/thanhdo1110">CTDOTECH Team</a></sub>
</div> 