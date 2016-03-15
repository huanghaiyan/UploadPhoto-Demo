//
//  ViewController.m
//  UploadPhoto-Demo
//
//  Created by huanghy on 16/3/15.
//  Copyright © 2016年 huanghy. All rights reserved.
//

#import "ViewController.h"

#define HEIGHT [[UIScreen mainScreen]bounds].size.height
#define KWIDTH [[UIScreen mainScreen]bounds].size.width

@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIView *_bgView;
    UIView *_view;
    UIImagePickerControllerSourceType _sourceType;
    BOOL isChange;
    BOOL isCamrea;
    UIImage *_image;
    CGSize  imageSize;

}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}
- (IBAction)addSelectPhoto:(id)sender {
    
    [self addSelectPicture];
}

-(void)addSelectPicture
{
    UIView *view = [[UIView alloc] init];
    view.frame = self.view.bounds;
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.7;
    _view = view;
    [self.view addSubview:view];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.center = CGPointMake(KWIDTH * 0.5, HEIGHT * 0.5);
    bgView.bounds = CGRectMake(0, 0, KWIDTH - 80, 120);
    bgView.backgroundColor = [UIColor whiteColor];
    _bgView = bgView;
    [self.view addSubview:bgView];
    
    UIButton *paizhao = [UIButton buttonWithType:UIButtonTypeCustom];
    paizhao.frame = CGRectMake(bgView.frame.origin.x, 0, KWIDTH - 80, 60);
    [paizhao setTitle:@"拍照" forState:UIControlStateNormal];
    [paizhao setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, bgView.frame.size.width * 0.35)];
    paizhao.titleLabel.textAlignment = NSTextAlignmentCenter;
    [paizhao setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    paizhao.titleLabel.font = [UIFont systemFontOfSize:14];
    [paizhao addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:paizhao];
    
    
    UIButton *xiangce = [UIButton buttonWithType:UIButtonTypeCustom];
    xiangce.frame = CGRectMake(bgView.frame.origin.x, 60, KWIDTH - 80, 60);
    [xiangce setTitle:@"相册" forState:UIControlStateNormal];
    xiangce.titleLabel.textAlignment = NSTextAlignmentCenter;
    [xiangce setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    xiangce.titleLabel.textAlignment = NSTextAlignmentCenter;
    xiangce.titleLabel.font = [UIFont systemFontOfSize:14];
    [xiangce setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, bgView.frame.size.width * 0.35)];
    
    [xiangce addTarget:self action:@selector(selectPicture) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:xiangce];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 60, KWIDTH - 80, 1)];
    line.backgroundColor  = [UIColor lightGrayColor];
    [bgView addSubview:line];

}

- (void)takePhoto
{
    // 拍照
    _sourceType = UIImagePickerControllerSourceTypeCamera;
    [self selectPhoto];
}

- (void)selectPicture
{
    // 相册
    _sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self selectPhoto];
    
}

#pragma mark - 照片选择
- (void)selectPhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:_sourceType]) {
        // 照片的选择工作
        
        // 实例化照片选择控制器
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        // 设置选择控制器的属性
        // 允许编辑
        [picker setAllowsEditing:YES];
        // 设置照片源
        [picker setSourceType:_sourceType];
        [picker setDelegate:self];
        
        // 显示选择控制器
        [self presentViewController:picker animated:YES completion:nil];
        
    } else {
        NSLog(@"照片源不可用");
    }
}

#pragma mark - 照片选择代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    isChange = YES;
    
    [_view removeFromSuperview];
    [_bgView removeFromSuperview];
    
    // 关闭
    [self dismissViewControllerAnimated:YES completion:^{
        // 从字典中取出照片
        _image = info[@"UIImagePickerControllerEditedImage"];
        
        [self.headImage setBackgroundImage:_image forState:UIControlStateNormal];
        
        // 获取原始图片size
        imageSize = _image.size;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    isChange = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)saveSelectImage:(id)sender {
    if (isChange == YES) {
        [self upLoadPicture];
    }
}

#pragma mark - 上传到服务器
- (void)upLoadPicture
{
    
    _image = [self scaleFromImage:_image toSize:CGSizeMake(200, 200)];
    NSData *data = UIImagePNGRepresentation(_image);
    
    
}


- (UIImage *)scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
