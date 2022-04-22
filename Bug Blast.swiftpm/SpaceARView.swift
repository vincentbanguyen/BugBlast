import SwiftUI
import RealityKit
import ARKit
import Combine
struct SpaceARView: UIViewRepresentable {
    
    @Binding var isPropelling: Bool
    @Binding var isReversing: Bool
    @Binding var isShooting: Bool
    var arView = ARView(frame: .zero)
    let anchor = AnchorEntity()
    let cameraAnchor = AnchorEntity(.camera)
    func makeUIView(context: Context) -> ARView {
        // Start AR Session
        let session = arView.session
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        session.run(config)
        // configure AR View
        session.delegate = context.coordinator
        
        let oceanColor = UIColor.hexStringToUIColor(hex: "#101444")
        
        arView.environment.background = .color(oceanColor)
        arView.renderOptions.insert(.disableGroundingShadows)
        // Coaching AR Set up Overlay
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.session = session
        coachingOverlay.goal = .horizontalPlane
        arView.addSubview(coachingOverlay)
        
        // Add anchor
        arView.scene.addAnchor(anchor)
        arView.scene.addAnchor(cameraAnchor)
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        context.coordinator.isShooting = isShooting
        context.coordinator.isPropelling = isPropelling
        context.coordinator.isReversing = isReversing
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, arView, anchor, cameraAnchor)
    }
    
    class Coordinator: NSObject, ARSessionDelegate {
        
        var parent: SpaceARView
        private let arView: ARView
        private let anchor: AnchorEntity
        private let cameraAnchor: AnchorEntity
        var isPropelling = false
        var isReversing = false
        var didShoot = false
        var isShooting = false
        var entities = [Entity]()
        var didAddAnchor = false
        var shouldUpdateState = true
        let bugExplosionPlayer = MusicPlayer(audioName: "bugExplosion", volume: 0.5, fileType: "wav", playInfinite: false)
        
        var subscriptions: [Cancellable] = []
        
        let planetURL = Bundle.main.url(forResource: "ApplePlanet", withExtension: "usdz")!
        let bugURL = Bundle.main.url(forResource: "Bug", withExtension: "usdz")!
        let bulletURL = Bundle.main.url(forResource: "bullet", withExtension: "usdz")!
        
        init(_ parent: SpaceARView, _ arView: ARView, _ anchor: AnchorEntity, _ cameraAnchor: AnchorEntity) {
            self.parent = parent
            self.arView = arView
            self.anchor = anchor
            self.cameraAnchor = cameraAnchor
            super.init()
            arView.session.delegate = self
        }
        
        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            debugPrint("Anchors added to the scene: ", anchors)
            if !didAddAnchor {
                didAddAnchor = true
                guard let arCamera = session.currentFrame?.camera else { return }
                self.setUpObjects(arCamera: arCamera)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                    moveBugs()
                }
            }
        }
        
        func session(_ session: ARSession, didUpdate frame: ARFrame) {
            
            guard let arCamera = session.currentFrame?.camera else { return }
            
            // handle shoot
            if isShooting {
                if didAddAnchor {
                    if didShoot == false {
                        didShoot = true
                        let box = shoot(arCamera: arCamera)
                        cameraAnchor.addChild(box)
                    }
                }
            }
            
            // handle objects when propel
            if isPropelling {
                let yaw = arCamera.eulerAngles[1]
                let pitch = arCamera.eulerAngles[0]
                let x = cos(yaw)*cos(pitch) * 0.02
                let y = -sin(pitch) * 0.02
                let z = sin(yaw)*cos(pitch) * 0.02
                let bugTranslation = SIMD3<Float>(z,y,x)
                
                for entity in entities {
                    entity.transform.translation += bugTranslation
                }
            }
            
            // handle objects when reverse
            if isReversing {
                let yaw = arCamera.eulerAngles[1]
                let pitch = arCamera.eulerAngles[0]
                let x = -cos(yaw)*cos(pitch) * 0.02
                let y = sin(pitch) * 0.02
                let z = -sin(yaw)*cos(pitch) * 0.02
                let bugTranslation = SIMD3<Float>(z,y,x)
                
                for entity in entities {
                    entity.transform.translation += bugTranslation
                }
            }
        }
        
        func moveBugs() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [self] in
                for entity in entities {
                    if entity.name == "bug" {
                        entity.transform.translation += entity.transformMatrix(relativeTo: nil).forward * 0.005
                    }
                }
                moveBugs()
            }
        }
        
        func setUpObjects(arCamera: ARCamera) {
            
            // add planet
            let planet = try! ModelEntity.loadModel(contentsOf: planetURL)
            
            let yaw = arCamera.eulerAngles[1]
            let pitch = arCamera.eulerAngles[0]
            let x = -cos(yaw)*cos(pitch) * 2
            let z = -sin(yaw)*cos(pitch) * 2
            let bugTranslation = SIMD3<Float>(z,0,x)
            
            let planetradians = 350 * Float.pi / 180.0
            
            planet.transform.rotation *= simd_quatf(angle: planetradians, axis: SIMD3<Float>(1,0,0))
            planet.transform.translation += bugTranslation
            planet.position += SIMD3<Float>(0,-3,0)
            planet.setScale(SIMD3<Float>(0.002, 0.002, 0.002), relativeTo: nil)
            anchor.addChild(planet)
            entities.append(planet)
            
            // add bugs
            
            for _ in 1...22 {
                let bug = try! ModelEntity.loadModel(contentsOf: bugURL)  as (Entity & HasCollision & HasPhysicsBody)
                bug.setScale(SIMD3<Float>(0.0007, 0.0007, 0.0007), relativeTo: nil)
                bug.transform.translation += SIMD3.spawnPoint(from: SIMD3.zero, lowerRadius: 1.2, upperRadius: 1.4)
                entities.append(bug)
                bug.transform.translation += bugTranslation
                anchor.addChild(bug)
                bug.name = "bug"
                bug.generateCollisionShapes(recursive: false)
                bug.look(at: entities[0].position, from: bug.position, relativeTo: nil)
                
                let sub = arView.scene.subscribe(to: CollisionEvents.Began.self,
                                                 on: bug) { [self] event in
                    // Get both of the entities from the event
                    let entityA = event.entityA
                    let entityB = event.entityB
                      if (entityA.name == "bug" && entityB.name == "bullet") {
                          
                          let bugTransform = entityA.transform.translation
                          // remove entities
                          entityA.removeFromParent()
                          entityB.removeFromParent()
                          
                          // update score
                          let current = UserDefaults.standard.value(forKey: "numbugs")
                          UserDefaults.standard.set(current as! Int + 1, forKey: "numbugs")
                          
                          // show explosion
                          let url = Bundle.main.url(forResource: "Explosion", withExtension: "usdz")!
                      //    print("trying to load explosion")
                          let explosion = try! ModelEntity.loadModel(contentsOf: url)
                          print("loaded explosion")
                       //   explosion.generateCollisionShapes(recursive: true)
                          bugExplosionPlayer.play()
                          explosion.transform.translation = bugTransform
                          explosion.setScale(SIMD3<Float>(0.0005, 0.0005, 0.0005), relativeTo: nil)
                          anchor.addChild(explosion)
                          DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                              explosion.removeFromParent()
                          }
                      }
                }
                subscriptions.append(sub)
            }
            let starMesh = MeshResource.generateSphere(radius: 0.1)
            let material = SimpleMaterial(color: .white, isMetallic: false)
            // add stars
            for _ in 1...100 {
                let star = ModelEntity(mesh: starMesh, materials: [material])
                star.transform.translation = SIMD3.spawnPoint(from: SIMD3.zero, lowerRadius: 5, upperRadius: 7)
                anchor.addChild(star)
                star.setScale(SIMD3<Float>(0.2, 0.2, 0.2), relativeTo: nil)
            }
        }
        
        func shoot(arCamera: ARCamera) -> ModelEntity {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                didShoot = false
            }
            let bullet = try! ModelEntity.loadModel(contentsOf: bulletURL)  as (Entity & HasCollision & HasPhysicsBody)
            bullet.name = "bullet"
            let yaw = arCamera.eulerAngles[1]
            let pitch = arCamera.eulerAngles[0]
            let x = -cos(yaw)*cos(pitch) * 3
            let y = sin(pitch) * 3
            let z = -sin(yaw)*cos(pitch) * 3
            bullet.components.set(PhysicsBodyComponent(massProperties: .init(mass: 0), material: .default, mode: .dynamic))
            bullet.generateCollisionShapes(recursive: false)
            bullet.components.set(PhysicsMotionComponent(linearVelocity: [z,y,x]))
            bullet.setScale(SIMD3<Float>(0.0005, 0.0005, 0.0005), relativeTo: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                bullet.removeFromParent()
            }
            entities.append(bullet)
            return bullet as! ModelEntity
        }
    }
}



