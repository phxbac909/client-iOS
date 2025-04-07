import SwiftUI
import SceneKit

struct SCNViewContainer: UIViewRepresentable {
    let scene: SCNScene
    
    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.scene = scene
        scnView.allowsCameraControl = false
        scnView.autoenablesDefaultLighting = true
        scnView.backgroundColor = .gray
            
        return scnView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {}
    
}

struct Content3DView {
    
    static func loadMultipleObjModels() -> SCNScene {
        let scene = SCNScene()
        
        guard let firstScene = SCNScene(named: "mohinhvetinhv2.obj") else {
            print("Failed to load yourModel1.obj")
            return scene
        }
        let firstNode = firstScene.rootNode.clone()
        firstNode.position = SCNVector3(x: 0, y: 0, z: 0) // Đặt obj1 tại gốc
        scene.rootNode.addChildNode(firstNode)
        
        // Load obj2
      
        
        // Tính tâm của obj1
        let (min, max) = firstNode.boundingBox
        let centerX = (min.x + max.x) / 2
        let centerY = (min.y + max.y) / 2
        let centerZ = (min.z + max.z) / 2
        let centerOfObj = SCNVector3(centerX, centerY, centerZ)
        
        let axesNode = createCoordinateAxes(length: 20) // Độ dài trục = 1 đơn vị
        axesNode.position = centerOfObj // Đặt hệ trục tại trung tâm obj
        scene.rootNode.addChildNode(axesNode)
        scene.rootNode.rotation = SCNVector4(0, 1, 0, -Float.pi / 15)
        return scene
    }
    
    static func createCoordinateAxes(length: Float) -> SCNNode {
            let axesNode = SCNNode()
            
            // Trục X (đỏ)
            let xAxis = SCNCylinder(radius: 0.05, height: CGFloat(length))
            let xMaterial = SCNMaterial()
            xMaterial.diffuse.contents = UIColor.red
            xAxis.materials = [xMaterial]
            let xNode = SCNNode(geometry: xAxis)
            xNode.position = SCNVector3(length / 2, 0, 0) // Dịch nửa chiều dài theo X
            xNode.rotation = SCNVector4(0, 0, 1, Float.pi / 2) // Xoay nằm ngang
            axesNode.addChildNode(xNode)
            
            // Trục Y (xanh lá)
            let yAxis = SCNCylinder(radius: 0.05, height: CGFloat(length))
            let yMaterial = SCNMaterial()
            yMaterial.diffuse.contents = UIColor.green
            yAxis.materials = [yMaterial]
            let yNode = SCNNode(geometry: yAxis)
            yNode.position = SCNVector3(0, length / 2, 0) // Dịch nửa chiều dài theo Y
            axesNode.addChildNode(yNode)
            
            // Trục Z (xanh dương)
            let zAxis = SCNCylinder(radius: 0.05, height: CGFloat(length))
            let zMaterial = SCNMaterial()
            zMaterial.diffuse.contents = UIColor.blue
            zAxis.materials = [zMaterial]
            let zNode = SCNNode(geometry: zAxis)
            zNode.position = SCNVector3(0, 0, length / 2) // Dịch nửa chiều dài theo Z
            zNode.rotation = SCNVector4(1, 0, 0, Float.pi / 2) // Xoay nằm dọc
            axesNode.addChildNode(zNode)
            
            return axesNode
        }
}

#Preview(body: {
    VStack (alignment : .leading){
        Text("Posture Satellite ").fontWeight(.bold).padding(.top).padding(.horizontal)
        SCNViewContainer(scene: Content3DView.loadMultipleObjModels())
            .frame(height: 300).padding()
        VStack (alignment : .leading){

            LazyVGrid(columns: [ GridItem(.flexible()),
                                 GridItem(.flexible())],spacing: 20,  content: {
//                Text("Largest   : ").font(.body)
//                Text(formattedNumber(largest))
//                    .fontWeight(.semibold).font(.headline)
//                Text("Smallest : ").font(.body)
//                Text(formattedNumber(smallest))
//                    .fontWeight(.semibold).font(.headline)
//                Text("Average : ").font(.body)
//                Text(formattedNumber(average))
//                    .fontWeight(.semibold).font(.headline)

            }).padding()
        }
        Spacer()
    }
    .background(.white)
    .cornerRadius(10)
    .padding(.top, 16)
    .padding(.bottom, 40)
    .padding(.horizontal)
    .shadow(radius: 0.3)
})
