//
//  UIColor+SDExspand.m
//  CAMELLIAE
//
//  Created by 张越 on 16/3/23.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "UIColor+SDExspand.h"

@implementation UIColor (SDExspand)

+ (UIColor *)colorWithHex:(NSString *)color{
    
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6){
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"]){
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"]){
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6){
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:1.0];
}

+ (UIColor *) getLvlColor:(NSNumber *) lvl{

    UIColor *currentColor;
    switch ([lvl intValue]) {
        case 1:
            currentColor = [self CMLPinkColor];
            break;
        case 2:
            currentColor = [self CMLBlackPigmentColor];
            break;
        case 3:
            currentColor = [self CMLGoldColor];
            break;
        case 4:
            currentColor = [self CMLGrayColor];
            break;
            
        default:
            break;
    }
    
    return currentColor;
}

+ (UIColor *)CMLLineGrayColor{

    return [self colorWithHex:@"666666"];
}

+ (UIColor *)CMLtextInputGrayColor{

    return [self colorWithHex:@"999999"];
}

/*黄色**/
+ (UIColor *)CMLYellowColor{

    return [self colorWithHex:@"ffbc07"];
}

+ (UIColor *) CMLNewYellowColor{
    
    return [self colorWithHex:@"#EEC174"];
}

+ (UIColor *)CMLYellowE5C68DColor {
    
    return [self colorWithHex:@"E5C68D"];
}

+ (UIColor *)CMLYellowD9AB5EColor {
    
    return [self colorWithHex:@"D9AB5E"];
}

+ (UIColor *)CMLFBE3AFColor {
    
    return [self colorWithHex:@"FBE3AF"];
}

+ (UIColor *)CMLF3E9D3Color {
    
    return [self colorWithHex:@"F3E9D3"];
}

+ (UIColor *)CMLFFF3DFColor {
    
    return [self colorWithHex:@"FFF3DF"];
}


/**黑色*/
+ (UIColor *)CMLBlackColor{

    return [self colorWithHex:@"333333"];
}

+ (UIColor *) CMLNewBlackColor{
    
    return [self colorWithHex:@"272727"];
}

+ (UIColor *)CMLTitleBlackColor {
    
    return [self colorWithHex:@"020202"];
}

/**白色*/
+ (UIColor *)CMLWhiteColor{

    return [self colorWithHex:@"ffffff"];
}

/**个人中心黑字*/
+ (UIColor *)CMLUserBlackColor{

    return [self colorWithHex:@"333333"];
}

+ (UIColor *)CMLUserGrayColor{

    return [self colorWithHex:@"f4f4f4"];
}

+ (UIColor *) CMLNewUserGrayColor{
    
    return [self colorWithHex:@"f6f6f6"];
}

/**提示数字*/
+ (UIColor *)CMLPromptGrayColor{

    return [self colorWithHex:@"CCCCCC"];
}

/**粉色*/
+ (UIColor *)CMLPinkColor{

    return [self colorWithHex:@"ff758a"];
}

/**黛*/
+ (UIColor *) CMLBlackPigmentColor{

    return [self colorWithHex:@"5920a6"];
}

/**金*/
+ (UIColor *) CMLGoldColor{
    
    return [self colorWithHex:@"ffbc07"];
}

/**墨*/
+ (UIColor *) CMLGrayColor{
    
    return [self colorWithHex:@"3f3f3f"];
}

/**newLineGray*/
+ (UIColor *) CMLNewGrayColor{

    return [self colorWithHex:@"eeeeee"];
}

+ (UIColor *)CMLNewCenterGrayColor{
    
    return [self colorWithHex:@"e4e4e4"];
}

+ (UIColor *)CMLFAFAFAColor {
    
    return [self colorWithHex:@"FAFAFA"];
}

+ (UIColor *)CML909090Color {
    
    return [self colorWithHex:@"909090"];
}


+ (UIColor *) CMLPurpleColor{

    return [self colorWithHex:@"5920A6"];
}

+ (UIColor *) CMLRedColor{
    
    return [self colorWithHex:@"FF0000"];
}

+ (UIColor *) CMLGreeenColor{
    
    return [self colorWithHex:@"07c58b"];
}

+ (UIColor *) CMLBrownColor{

    return [self colorWithHex:@"D9AB5E"];
}

+ (UIColor *) CMLUpGradeGreenColor{

    return [self colorWithHex:@"00B877"];
}

+ (UIColor *) CMLOrangeColor{

    return [self colorWithHex:@"EAB254"];
}

+ (UIColor *) CMLDarkOrangeColor{
    
    return [self colorWithHex:@"D9AB5E"];
}

+ (UIColor *) CMLPromRedColor{
    
    return [self colorWithHex:@"E90000"];
}

+ (UIColor *) CMLDrakBlueColor{
    
    return [self colorWithHex:@"49547b"];
}

+ (UIColor *)CMLCalendarBlackColor{
    
    return [self colorWithHex:@"A77A00"];
}

+ (UIColor *)CMLOrderCellBgGrayColor{
    
    return [self colorWithHex:@"f6f6f6"];
}

+ (UIColor *) CMLSerachLineGrayColor{

    return [self colorWithHex:@"DDDDDD"];
}

+ (UIColor *) CMLScrollLineWhiterColor{
    
    return [self colorWithHex:@"D7D7D7"];
}

+ (UIColor *) CMLNewPinkColor{
    
    return [self colorWithHex:@"E91E63"];
}

/*灰色*/
+ (UIColor *)CMLNewLineGrayColor{

    return [self colorWithHex:@"C1B497"];
}

+ (UIColor *) CMLNewActivityGrayColor{

    return [self colorWithHex:@"FAFAFA"];
}

+ (UIColor *) CMLBtnTitleNewGrayColor{


    return  [self colorWithHex:@"BBBBBB"];
}

+ (UIColor *)CMLVIPBtnGrayColor{

    return  [self colorWithHex:@"C1B497"];
}

+ (UIColor *)CMLGray8C8C8CColor {
    
    return  [self colorWithHex:@"8C8C8C"];
}

+ (UIColor *)CMLGrayD8D8D8Color {
    
    return  [self colorWithHex:@"D8D8D8"];
}

+ (UIColor *)CMLGrayB4B4B4Color {
    
    return  [self colorWithHex:@"B4B4B4"];
}

+ (UIColor *)CMLGrayF2F2F4Color {
    
    return  [self colorWithHex:@"F2F2F4"];
}

/********/
+ (UIColor *) CMLGovernmentBgColor{
    
    return [self colorWithHex:@"FAF7F5"];
}
+ (UIColor *) CMLCollegeBgColor{
    
    return [self colorWithHex:@"F8F9FB"];
}
+ (UIColor *) CMLVIPBgColor{
    
    return [self colorWithHex:@"FDF9FA"];
}
+ (UIColor *) CMLHealthyBgColor{
    
    return [self colorWithHex:@"F7F9F8"];
}
+ (UIColor *) CMLTravelBgColor{
    
    return [self colorWithHex:@"F8FAFB"];
}
+ (UIColor *) CMLFashionBgColor{
    
    return [self colorWithHex:@"FCFAF7"];
}

+ (UIColor *) CMLLightBrownColor{
  
    return [self colorWithHex:@"C1B497"];
}

+ (UIColor *) CMLInvoiceBlackColor{
    
    return [self colorWithHex:@"25211E"];
}

+ (UIColor *) CMLNewbgBrownColor{
    
    return [self colorWithHex:@"C1B497"];
}

+ (UIColor *) CMLGray1Color{
    
    return [self colorWithHex:@"B9B9B9"];
    
}

+ (UIColor *) CMLGray2Color{
    
    return [self colorWithHex:@"B2B2B2"];
    
}

+ (UIColor *) CMLGray3Color{
    
    return [self colorWithHex:@"AFAFAF"];
    
}

+ (UIColor *)CMLIntroGrayColor {
    
    return [self colorWithHex:@"3D3D3D"];
    
}

+ (UIColor *)CMLGray979797Color {
    
    return [self colorWithHex:@"979797"];
    
}

+ (UIColor *)CMLF1F1F1Color {
    
    return [self colorWithHex:@"F1F1F1"];
    
}

+ (UIColor *)CMLF6F6F6Color {
    
    return [self colorWithHex:@"F6F6F6"];
    
}

+ (UIColor *)CMLE5C48AColor {
    
    return [self colorWithHex:@"E5C48A"];
    
}

+ (UIColor *)CMLA2A2A2Color {
    
    return [self colorWithHex:@"A2A2A2"];
    
}

+ (UIColor *)CML7B7B7BColor {
    
    return [self colorWithHex:@"7B7B7B"];
    
}

+ (UIColor *)CML7C7C7CColor {
    
    return [self colorWithHex:@"7C7C7C"];
    
}

+ (UIColor *)CMLDCB167Color {
    
    return [self colorWithHex:@"DCB167"];
    
}

+ (UIColor *)CMLA6A6A6Color {
    
    return [self colorWithHex:@"A6A6A6"];
    
}

+ (UIColor *)CMLEA3F3FColor {
    
    return [self colorWithHex:@"EA3F3F"];
    
}

/*灰色时间颜色*/
+ (UIColor *)CML9E9E9EColor {
    
    return [self colorWithHex:@"9E9E9E"];
    
}

+ (UIColor *)CML686868Color {
    
    return [self colorWithHex:@"686868"];
    
}

+ (UIColor *)CMLDBDBDBColor {
    
    return [self colorWithHex:@"DBDBDB"];
    
}

+ (UIColor *)CML888888Color {
    
    return [self colorWithHex:@"888888"];
    
}

+ (UIColor *)CMLGrayF3F3F3Color {
    
    return [self colorWithHex:@"F3F3F3"];
    
}

+ (UIColor *)CMLGray515151Color {
    
    return [self colorWithHex:@"515151"];
    
}

+ (UIColor *)CMLGrayD5D5D5Color {
    
    return [self colorWithHex:@"D5D5D5"];
    
}


/*黑色*/
+ (UIColor *)CML383838Color {
    
    return [self colorWithHex:@"383838"];
    
}

+ (UIColor *)CMLBlack393939Color {
    
    return [self colorWithHex:@"393939"];
    
}

+ (UIColor *)CML25211EColor {
    
    return [self colorWithHex:@"25211E"];
    
}

+ (UIColor *)CMLBlack1C1C1EColor {
    
    return [self colorWithHex:@"1C1C1E"];
    
}

+ (UIColor *)CMLBlack2D2D2DColor {
    
    return [self colorWithHex:@"2D2D2D"];
    
}

+ (UIColor *)CMLBlack010101Color {
    
    return [self colorWithHex:@"010101"];
    
}

/*橘色*/
+ (UIColor *)CMLOrangerFFA465Color {
    
    return [self colorWithHex:@"FFA465"];
    
}

@end
