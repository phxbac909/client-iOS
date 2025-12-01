import SwiftUI
import SwiftUIJoystick
import SceneKit
import Combine



// MARK: - Model3DView
struct Model3DView: View {
    @StateObject private var viewModel = RemoteViewModel.shared
    @State private var scene: SCNScene?
    @State private var modelNode: SCNNode?
//    @Environment(\.horizontalSizeClass) var horizontalSizeClass
//    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    // Thông số góc lật và di chuyển ban đầu
    private let initialSystemRotateX: Float = 24.0
    private let initialSystemRotateY: Float = -3.0
    private let initialPosX: Float = 0 //-120.0
    private let initialPosY: Float = -2//-115.0
    private let initialPosZ: Float = 0//100.0
    private let initialRotateX: Float = -91.0  // Pitch
    private let initialRotateY: Float = -0.5   // Yaw
    private let initialRotateZ: Float = -1.4   // Roll
    private let modelScale: Float = 0.0013
    
    var body: some View {
        
            
        VStack(spacing: 0) {
            VStack(alignment: .leading){
                Text("Tư thế ")
                    .foregroundStyle(.white)
                    .padding(.top, 70)
                    .padding(.horizontal)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.primaryColor)
            GeometryReader { geometry in
                ZStack {
                    SceneView(
                        scene: scene,
                        options: [.allowsCameraControl, .autoenablesDefaultLighting]
                    )
                    .background(Color(red: 220/255, green: 220/255, blue: 220/255))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
            .onAppear {
                setupScene()
                setupBindings()
            }
        }
        .frame(maxWidth :.infinity)
        .background(Color.primary.opacity(0.05))
        .edgesIgnoringSafeArea(.all)
      
    }
    
    // Setup binding giữa ViewModel và SceneKit node
    private func setupBindings() {
        // Lắng nghe thay đổi từ ViewModel và cập nhật node
        viewModel.$pitch
            .combineLatest(viewModel.$roll)
            .sink { [weak modelNode] pitch, roll in
                self.updateModelRotation(pitch: pitch, roll: roll, node: modelNode)
            }
            .store(in: &cancellables)
    }
    
    @State private var cancellables = Set<AnyCancellable>()
    
    private func setupScene() {
        // Tạo scene
        let newScene = SCNScene()
        
        // Load STL model
        if let modelScene = loadSTLModel(named: "quadcopter") {
            let model = modelScene.rootNode.childNodes.first ?? modelScene.rootNode
            
            // Debug: In ra thông tin model
            print("=== MODEL LOADED ===")
            print("Child nodes count: \(modelScene.rootNode.childNodes.count)")
            print("Model bounding box: \(model.boundingBox)")
            print("Model position: \(model.position)")
            
            // Thiết lập material với màu sáng để dễ thấy
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.lightGray
            material.specular.contents = UIColor.white
            material.lightingModel = .phong
            
            // Áp dụng material cho tất cả geometry
            model.enumerateChildNodes { (node, _) in
                node.geometry?.materials = [material]
            }
            if let geometry = model.geometry {
                geometry.materials = [material]
            }
            
            model.scale = SCNVector3(modelScale, modelScale, modelScale)
            model.position = SCNVector3(initialPosX, initialPosY, initialPosZ) // Đặt ở gốc tọa độ
            
            // Thêm model vào scene
            newScene.rootNode.addChildNode(model)
            modelNode = model
            
            print("Model added to scene")
        } else {
            print("FAILED to load model!")
        }
        
        // Tạo mặt phẳng nền để làm reference
        let groundPlane = SCNPlane(width: 10, height: 10)
        let groundMaterial = SCNMaterial()
        groundMaterial.diffuse.contents = UIColor.blue.withAlphaComponent(0.2)
        groundMaterial.isDoubleSided = true
        groundPlane.materials = [groundMaterial]
        
        let groundNode = SCNNode(geometry: groundPlane)
        groundNode.position = SCNVector3(0, 0, 0)
        groundNode.eulerAngles = SCNVector3(-Float.pi / 2, 0, 0)
        newScene.rootNode.addChildNode(groundNode)
        
        print("Ground plane added")
        
        // Thiết lập camera đơn giản để test
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.fieldOfView = 60
        cameraNode.camera?.zNear = 0.1
        cameraNode.camera?.zFar = 10000.0
        cameraNode.position = SCNVector3(0, 7, 15) // Camera gần hơn
        cameraNode.look(at: SCNVector3(0, 0, 0)) // Nhìn vào gốc tọa độ
        
        newScene.rootNode.addChildNode(cameraNode)
        
        print("Camera position: \(cameraNode.position)")
        
        // Thêm ánh sáng ambient
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        ambientLight.light?.color = UIColor(white: 0.3, alpha: 1.0)
        newScene.rootNode.addChildNode(ambientLight)
        
        // Thêm point light
        let pointLight = SCNNode()
        pointLight.light = SCNLight()
        pointLight.light?.type = .omni
        pointLight.light?.color = UIColor.white
        pointLight.position = SCNVector3(0, -600, 0)
        newScene.rootNode.addChildNode(pointLight)
        
        scene = newScene
    }
    
    // Cập nhật rotation của model dựa trên giá trị từ ViewModel
    private func updateModelRotation(pitch: Float, roll: Float, node: SCNNode?) {
        guard let model = node else { return }
        
        // Do khác biệt giữa model và thực tế:
        // Roll thực tế -> Yaw của model
        // Pitch thực tế -> Pitch của model
        
        let newYaw = initialRotateY + roll
        let newPitch = initialRotateX + pitch
        
        model.eulerAngles = SCNVector3(
            degreesToRadians(newPitch),
            degreesToRadians(newYaw),
            degreesToRadians(initialRotateZ)
        )
        
    }
    
    // Load STL file
    private func loadSTLModel(named name: String) -> SCNScene? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "stl") else {
            print("Không thể tìm thấy file STL: \(name).stl")
            return nil
        }
        
        do {
            let scene = try SCNScene(url: url, options: [
                .flattenScene: true,
                .convertUnitsToMeters: 1.0
            ])
            return scene
        } catch {
            print("Không thể load file STL: \(error.localizedDescription)")
            return nil
        }
    }
    
    // Chuyển đổi từ degrees sang radians
    private func degreesToRadians(_ degrees: Float) -> Float {
        return degrees * .pi / 180.0
    }
}

// MARK: - Extension để truy cập ViewModel
extension Model3DView {
    func getViewModel() -> RemoteViewModel {
        return viewModel
    }
}

// MARK: - Preview
#Preview {
    Model3DView()
}
