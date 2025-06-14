# 🚀 CTDOWelcomeFX

<div align="right">
  <a href="README_VI.md">🇻🇳 Tiếng Việt</a>
</div>

<div align="center">

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)
![iOS](https://img.shields.io/badge/iOS-13.0+-blue.svg)

</div>

<div align="center">
  <img src="https://raw.githubusercontent.com/thanhdo1110/CTDOWelcomeFX/main/Resources/demo.gif" alt="Dark Mode Demo" width="300"/>
  <img src="https://raw.githubusercontent.com/thanhdo1110/CTDOWelcomeFX/main/Resources/demo1.gif" alt="Light Mode Demo" width="300"/>
</div>

## 📱 Introduction

A beautiful, customizable WelcomeFX experience library for iOS applications. This library provides a modern and engaging way to introduce your app's features to new users.

## ✨ Features

- 🎨 Modern and clean UI design
- 📱 Supports both iPhone and iPad
- 🔄 Smooth animations and transitions
- 🎯 Customizable content and styling
- 🔒 Optional one-time or every-launch display
- 🌐 Link support in description text
- 🖼️ SF Symbols fallback for missing images

## 🛠 Installation

### Git Clone
```bash
git clone https://github.com/thanhdo1110/CTDOWelcomeFX.git
```

### Manual
Simply add `CTDOWelcomeFX.h` and `CTDOWelcomeFX.m` to your project.

## 📖 Usage

### Basic Implementation

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
        config.appName = @"CertApple.com";
        config.welcomeTitle = @"Welcome to";
        config.welcomeTitleFontSize = 45.0;  // Customize welcome title size
        config.appNameFontSize = 30.0;       // Customize app name size
        config.continueButtonText = @"continue";
        config.descriptionText = @"Please join my community here...";
        config.linkText = @"here...";
        config.linkURL = [NSURL URLWithString:@"https://certapple.com/"];
        config.userDefaultsKey = @"hasShownMyTweakOnboarding";
        config.showEveryLaunch = YES;
        config.appNameColor = [UIColor colorWithRed:0.7804 green:0.2941 blue:0.5804 alpha:1.0];

        // config.appNameColor = [UIColor colorWithRed:0.0 green:0.7137 blue:0.7255 alpha:1.0]; // Màu xanh dương
        // config.appNameColor = [UIColor colorWithRed:0.0/255.0 green:201.0/255.0 blue:167.0/255.0 alpha:1.0];  // màu hồng thẫm
        config.appNameColor = [UIColor colorWithRed:0.8706 green:0.2745 blue:0.2980 alpha:1.0]; // màu đỏ


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

## 🎨 Image Guidelines

### 1. App Icon
- Recommended size: 1024x1024px
- Format: PNG
- Can be loaded from Assets.xcassets or PNG file
- SF Symbols fallback available

### 2. Feature Icons
- Recommended size: 60x60px
- Format: PNG
- Can be loaded from Assets.xcassets or PNG file
- SF Symbols fallback available

### 3. SF Symbols
- Available as fallback when images are missing
- Automatically scales for different screen sizes
- Supports dynamic colors and dark mode
- Example: "star.fill", "lock.shield.fill", "paintbrush.pointed.fill"

## ⚙️ Configuration

| Property | Description |
|----------|-------------|
| `appIcon` | Your app's icon (UIImage or SF Symbol) |
| `welcomeTitle` | Welcome message (e.g., "Welcome to") |
| `appName` | Your app's name |
| `appNameColor` | Color for app name |
| `features` | Array of features to display |
| `descriptionText` | Bottom description text |
| `linkText` | Text to be linked |
| `linkURL` | URL for the link |
| `continueButtonText` | Text for continue button |
| `userDefaultsKey` | Key for storing display state |
| `showEveryLaunch` | Whether to show on every launch |
| `welcomeTitleFontSize` | Customize welcome title size |
| `appNameFontSize` | Customize app name size |

## 📋 Requirements

- iOS 13.0+
- Xcode 11.0+/Theos
- Objective-C/C++

## 📄 License

This project is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

## 👥 Author

<div align="center">
  <img src="https://raw.githubusercontent.com/thanhdo1110/CTDOWelcomeFX/main/Resources/logo.png" alt="CTDOTECH Logo" width="200"/>
  
  **CTDOTECH Team** - [@thanhdo1110](https://github.com/thanhdo1110)
  
</div>

---
<div align="center">
  <sub>Built with ❤️ by <a href="https://github.com/thanhdo1110">CTDOTECH Team</a></sub>
</div> 
