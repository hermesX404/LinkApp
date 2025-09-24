//
//  ShareProfileVIew.swift
//  Link
//
//  Created by KAON SOU on 2025/03/26.
//
import SwiftUI
import CoreImage.CIFilterBuiltins
import Photos

struct ShareProfileView: View {
    let user: User
    @State private var showEditProfile = false
    @State private var showSaveAlert = false
    @State private var saveSuccess = false
    
    // 用于生成 QR Code 的上下文与滤镜
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        VStack(spacing: 20) {
            // 正确生成并放大二维码图像
            if let qrImage = generateQRCode(from: userShareURL()) {
                Image(uiImage: qrImage)
                    .interpolation(.none) // 防止模糊
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .background(Color.white) // 背景防止黑色叠黑色
                    .cornerRadius(10)
            } else {
                Text("Could not generate QR Code")
                    .foregroundColor(.red)
            }
            
            Text("@\(user.fullname)")
                .font(.callout)
                .foregroundStyle(.cyan)
            
            HStack(spacing: 15) {
                Button(action: {
                    if let image = generateQRCode(from: userShareURL()) {
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        saveSuccess = true
                        showSaveAlert = true
                    } else {
                        saveSuccess = false
                        showSaveAlert = true
                    }
                }) {
                    VStack(spacing: 3) {
                        Image(systemName: "arrow.down.to.line")
                            .font(.title2)
                        Text("Save")
                            .font(.caption)
                    }
                    .foregroundColor(.black)
                    .frame(width: 190, height: 80)
                    .background(Color.white)
                    .cornerRadius(15)
                    
                }
                Button(action: {
                    
                }) {
                    VStack(spacing: 3) {
                        Image(systemName: "qrcode.viewfinder")
                            .font(.title2)
                        Text("Scan")
                            .font(.caption)
                    }
                    .foregroundColor(.black)
                    .frame(width: 190, height: 80)
                    .background(Color.white)
                    .cornerRadius(15)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color(red: 0.957, green: 0.957, blue: 0.957)
                .ignoresSafeArea()
        )
        .alert(isPresented: $showSaveAlert) {
            Alert(
                title: Text(saveSuccess ? "Save successfully" : "Save failed"),
                //message: Text(saveSuccess ? "二维码已保存到相册" : "二维码保存失败"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    /// 用户分享网址（这里你可以写任意网址）
    private func userShareURL() -> String {
        return "https://missav.ws/dm15/ja"
    }
    
    /// 生成高质量的二维码图像
    private func generateQRCode(from string: String) -> UIImage? {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("Q", forKey: "inputCorrectionLevel") // 容错率为 Q
        
        guard let outputImage = filter.outputImage else { return nil }
        
        // 缩放二维码（默认太小）
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledImage = outputImage.transformed(by: transform)
        
        // 渲染为 CGImage 后再转为 UIImage，确保兼容显示
        if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        
        return nil
    }
}
struct ShareProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ShareProfileView(user: dev.user)
    }
}

