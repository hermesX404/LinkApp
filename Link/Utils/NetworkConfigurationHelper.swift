//
//  NetworkConfigurationHelper.swift
//  Link
//
//  Created by Assistant on 2025/01/27.
//

import Foundation
import Network

class NetworkConfigurationHelper {
    static let shared = NetworkConfigurationHelper()
    
    private init() {}
    
    /// 检查网络连接状态
    func checkNetworkStatus() {
        print("=== Network Status Check ===")
        
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                print("Network Status: \(path.status)")
                print("Interface Types: \(path.availableInterfaces.map { $0.type })")
                print("Is Expensive: \(path.isExpensive)")
                print("Is Constrained: \(path.isConstrained)")
                
                if path.status == .satisfied {
                    print("✅ Network is available")
                } else {
                    print("❌ Network is unavailable")
                }
            }
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
        
        // 延迟停止监控
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            monitor.cancel()
        }
    }
    
    /// 创建自定义URLSession配置
    func createCustomURLSession() -> URLSession {
        let config = URLSessionConfiguration.default
        
        // 设置超时时间
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        
        // 设置缓存策略
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        // 设置HTTP头部
        config.httpAdditionalHeaders = [
            "User-Agent": "LinkApp/1.0 iOS",
            "Accept": "image/*, */*"
        ]
        
        // 创建自定义URLSession
        let session = URLSession(configuration: config)
        
        print("DEBUG: Created custom URLSession with configuration")
        return session
    }
    
    /// 测试Firebase服务连接
    func testFirebaseConnection(completion: @escaping (Bool, Error?) -> Void) {
        let testURL = "https://firebaseapp.com"
        
        guard let url = URL(string: testURL) else {
            completion(false, NSError(domain: "NetworkConfigurationHelper", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid test URL"]))
            return
        }
        
        let session = createCustomURLSession()
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("DEBUG: Firebase connection test failed: \(error.localizedDescription)")
                completion(false, error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("DEBUG: Firebase connection test response: \(httpResponse.statusCode)")
                completion(httpResponse.statusCode == 200, nil)
            } else {
                completion(false, NSError(domain: "NetworkConfigurationHelper", code: 500, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
            }
        }
        
        task.resume()
    }
    
    /// 获取网络配置建议
    func getNetworkConfigurationAdvice() -> String {
        var advice = "网络配置建议:\n"
        
        advice += "1. 检查是否启用了代理软件 (Clash, V2Ray, Shadowsocks等)\n"
        advice += "2. 检查是否启用了VPN连接\n"
        advice += "3. 尝试关闭代理/VPN后重新运行应用\n"
        advice += "4. 如果必须使用代理，请配置Firebase服务直连规则\n"
        advice += "5. 检查设备网络设置中的代理配置\n"
        
        return advice
    }
    
    /// 打印详细的网络诊断信息
    func printNetworkDiagnostics() {
        print("=== Network Diagnostics ===")
        print(getNetworkConfigurationAdvice())
        
        // 检查网络状态
        checkNetworkStatus()
        
        // 测试Firebase连接
        testFirebaseConnection { success, error in
            if success {
                print("✅ Firebase connection test: SUCCESS")
            } else {
                print("❌ Firebase connection test: FAILED")
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
        
        print("==========================")
    }
} 