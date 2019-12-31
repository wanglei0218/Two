//
//  FontAndColor.h
//  TaoYouDan
//
//  Created by LY on 2018/9/18.
//  Copyright © 2018年 LY. All rights reserved.
//

#ifndef FontAndColor_h
#define FontAndColor_h

//颜色工具
#define COLOR_With_Hex(rgbValue)     [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define COLOR_WITH_HEX(rgbValue)     [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


//自定义颜色
#define ColorBlack222          COLOR_With_Hex(0x222222)
#define ColorZhuTiHongSe       COLOR_WITH_HEX(0x0964F6)
#define ColorWithUnableClick   COLOR_With_Hex(0xAECCFA)
#define GrayLineColor          COLOR_With_Hex(0xdbdbdb)
#define GrayColor666           COLOR_With_Hex(0x666666)
#define ColorBlack343434       COLOR_With_Hex(0x343434)
#define ColorBackground_Line   COLOR_With_Hex(0xf3f3f3)
#define ColorBlack999          COLOR_With_Hex(0x999999)
#define ColorBlack333          COLOR_With_Hex(0x333333)
#define Colorf9f3dd            COLOR_With_Hex(0xf9f3dd)
#define Color000               COLOR_With_Hex(0x000000)
#define Colorffb5b7            COLOR_With_Hex(0xffb5b7)
#define Colorfefefe            COLOR_With_Hex(0xfefefe)
#define Colorf8f8f8            COLOR_With_Hex(0xf8f8f8)
#define Coloree4c4f            COLOR_With_Hex(0xee4c4f)
#define Colorde3235            COLOR_With_Hex(0xde3235)
#define Colordddddd            COLOR_With_Hex(0xdddddd)
#define Colorf3a3a5            COLOR_With_Hex(0xf3a3a5)
#define Color878787            COLOR_With_Hex(0x878787)
#define Colore5e5e5            COLOR_With_Hex(0xe5e5e5)
#define Colorbdbdbd            COLOR_With_Hex(0xbdbdbd)
#define Colorffffff            COLOR_With_Hex(0xffffff)
#define ColorLineeee           COLOR_With_Hex(0xeeeeee)
//系统颜色
#define COLORWHITE             [UIColor whiteColor]

//支付超时黄色
#define ColorF9f3dd COLOR_With_Hex(0xf9f3dd)
//支付红色
#define ColorE63c3f COLOR_With_Hex(0xe63c3f)
#define ColorFdd9da COLOR_With_Hex(0xfdd9da)

#define SecondCarMainThumsColor COLOR_With_Hex(0xed7d45)

//字体工具
#define UIFONTTOOL(font)        [UIFont systemFontOfSize:font]
#define UIFONTTOOL16            UIFONTTOOL(16)
#define UIFONTTOOL15            UIFONTTOOL(15)
#define UIFONTTOOL14            UIFONTTOOL(14)
#define UIFONTTOOL13            UIFONTTOOL(13)
#define UIFONTTOOL12            UIFONTTOOL(12)
#define UIFONTTOOL22            UIFONTTOOL(22)
#define UIFONTTOOL17            UIFONTTOOL(17)
#define UIFONTTOOL24            UIFONTTOOL(24)
#define UIFONTTOOL20            UIFONTTOOL(20)
#define UIFONTTOOL19            UIFONTTOOL(19)
#define UIFONTTOOL10           UIFONTTOOL(10)


#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

//字体

#endif /* FontAndColor_h */
