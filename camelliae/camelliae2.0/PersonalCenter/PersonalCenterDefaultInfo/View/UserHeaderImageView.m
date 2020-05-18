//
//  UserHeaderImageView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/2/28.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "UserHeaderImageView.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "VCManger.h"

#define UserImageWidth        60
#define ImageSpace            20

@interface UserHeaderImageView ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UIImageView *userHeaderImage;

@end

@implementation UserHeaderImageView

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setContent:@"头像"];
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{

    self.userHeaderImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.selectImage.frame.origin.x - ImageSpace*Proportion - UserImageWidth*Proportion,
                                                                         self.frame.size.height/2.0 - UserImageWidth*Proportion/2.0,
                                                                         UserImageWidth*Proportion,
                                                                         UserImageWidth*Proportion)];
    self.userHeaderImage.layer.cornerRadius = UserImageWidth*Proportion/2.0;
    self.userHeaderImage.clipsToBounds = YES;
    self.userHeaderImage.backgroundColor = [UIColor CMLUserGrayColor];
    self.userHeaderImage.userInteractionEnabled = YES;
    [self addSubview:self.userHeaderImage];
    
    UIButton *selectBtn = [[UIButton alloc] initWithFrame:self.bounds];
    selectBtn.backgroundColor = [UIColor clearColor];
    [selectBtn addTarget:selectBtn action:@selector(showCHangeImageStyle) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:selectBtn];
    
}

- (void) showCHangeImageStyle{

    UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil
                                                                message:nil
                                                         preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"图片库选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imagePicker.delegate = self;
        //        imagePicker.allowsEditing = YES;
        [[VCManger mainVC] presentVC:imagePicker animated:YES];
        
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"摄像头拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            //设置拍照后的图片可被编辑
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            [[VCManger mainVC] presentVC:picker animated:YES];
        }
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [vc addAction:action1];
    [vc addAction:action2];
    [vc addAction:action3];
    [[VCManger mainVC] presentVC:vc animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
//    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
//    
//    //当选择的类型是图片
//    if ([type isEqualToString:@"public.image"]){
//        //先把图片转成NSData
//        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//        
//        self.currentImage = [UIImage CropImage:image];
//        
//        NSData *data;
//        if (UIImagePNGRepresentation(image) == nil){
//            data = UIImageJPEGRepresentation(self.currentImage, 1.0);
//        }else{
//            data = UIImagePNGRepresentation(self.currentImage);
//        }
//        
//        /**压缩并获取大小*/
//        self.uploadImage = [UIImage scaleToSize:self.currentImage size:CGSizeMake(300, 300)];
//        UIImage *image2 = [UIImage scaleToSize:self.currentImage size:CGSizeMake(200, 200)];
//        UIImage *image3 = [UIImage scaleToSize:self.currentImage size:CGSizeMake(500, 500)];
//        NSData *compressImageData = UIImageJPEGRepresentation(self.uploadImage, 1.0);
//        self.imageSize = (int)compressImageData.length;
//        
//        NSPUIImageType imageType = NSPUIImageTypeFromData(data);
//        
//        
//        if (imageType == NSPUIImageType_JPEG) {
//            
//            self.uploaderData = UIImageJPEGRepresentation(self.uploadImage, 1.0);
//            self.uploaderData2 = UIImageJPEGRepresentation(image2, 1.0);
//            self.uploaderData3 = UIImageJPEGRepresentation(image3, 1.0);
//            NSLog(@"该图片格式为jpeg");
//            [self sendImageWithType:@"jpg"];
//        }else{
//            NSLog(@"该图片格式为png");
//            
//            self.uploaderData = UIImagePNGRepresentation(self.uploadImage);
//            self.uploaderData2 = UIImagePNGRepresentation(image2);
//            self.uploaderData3 = UIImagePNGRepresentation(image3);
//            [self sendImageWithType:@"png"];
//            
//        }
//        //关闭相册界面
//        
//        [picker dismissViewControllerAnimated:YES completion:^{
//            
//        }];
//    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
//    [picker dismissViewControllerAnimated:YES completion:^{
//        
//    }];
}
@end
