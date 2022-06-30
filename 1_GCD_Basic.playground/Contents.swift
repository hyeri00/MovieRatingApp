import UIKit

/** Queue - Main, Global, Custom */

// - Main Queue
DispatchQueue.main.async {
    // UI Update
    let view = UIView()
    view.backgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
}


// - Global Queue
DispatchQueue.global(qos: .userInteractive).async {
    // 진짜 중요하거나 당장 해야하는 것에 사용
}

DispatchQueue.global(qos: .userInitiated).async {
    // 거의 바로 해줘야 하거나 사용자가 결과를 기다리는 것에 사용
}

DispatchQueue.global(qos: .default).async {
    // 굳이 해야하는 것에 사용
}

DispatchQueue.global(qos: .utility).async {
    // 시간이 좀 걸리는 일들이나 사용자가 당장 기다리지 않는 것(네트워킹, 큰 파일 불러올 때)에 사용
}

DispatchQueue.global(qos: .background).async {
    // 사용자한테 당장 인식 될 필요가 없을 때(뉴스 데이터 미리 받기, 위치 업데이트, 영상 다운 받을 때)에 사용
}


// - Custom Queue
let concurrentQueue = DispatchQueue(label: "concurrent", qos: .background, attributes: .concurrent)
let serialQueue = DispatchQueue(label: "serial", qos: .background)





/** 복합적인 상황 */
func downloadImageFromServer() -> UIImage {
    // Heavy Task
    return UIImage()
}

func updateUI(image: UIImage) {
    
}

DispatchQueue.global(qos: .background).async {
    // download
    let image = downloadImageFromServer()
    
    DispatchQueue.main.async {
        // updateUI
        updateUI(image: image)
    }
}





/** Sync, Async */

// Async
//DispatchQueue.global(qos: .background).async {
//    for i in 0...5 {
//        print("😈 \(i)")
//    }
//}
//
//DispatchQueue.global(qos: .userInteractive).async {
//    for i in 0...5 {
//        print("😥 \(i)")
//    }
//}


// Sync
DispatchQueue.global(qos: .background).sync {
    for i in 0...5 {
        print("😈 \(i)")
    }
}

DispatchQueue.global(qos: .userInteractive).async {
    for i in 0...5 {
        print("😥 \(i)")
    }
}
