//
//  DrawingView.swift
//  29.10.2024
//

import MetalKit
import UIKit

final class DrawingView: UIView {
    
    // MARK: Private Properties
    private let device: MTLDevice
    private let commandQueue: MTLCommandQueue
    private let pipelineState: MTLComputePipelineState
    private var paintingsBuffer: MTLBuffer?
    private var paintingsCount: Int?
    
    // MARK: Visual Components
    private lazy var metalView: MTKView = {
        let view = MTKView(frame: .zero, device: device)
        view.delegate = self
        view.backgroundColor = .clear
        view.framebufferOnly = false
        view.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)
        view.isPaused = true
        view.enableSetNeedsDisplay = true
        
        return view
    }()
    
    // MARK: Initializers
    init(frame: CGRect, device: MTLDevice, functionName: String) {
        self.device = device
        commandQueue = device.makeCommandQueue()!
        let library = device.makeDefaultLibrary()!
        let function = library.makeFunction(name: functionName)!
        pipelineState = try! device.makeComputePipelineState(function: function)
        
#warning("REPLACE COUNT")
        paintingsBuffer = device.makeBuffer(length: MemoryLayout<Painting>.size * 1)
        paintingsCount = 1
        
        super.init(frame: frame)
        setupView()
        addSubviews()
    }
    
    convenience init(device: MTLDevice, functionName: String) {
        self.init(frame: .zero, device: device, functionName: functionName)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIView
    override func layoutSubviews() {
        super.layoutSubviews()
        
        metalView.frame = bounds
    }
    
    // MARK: Internal Methods
    func updatePaintings(_ paintings: [Painting]) {
        paintingsBuffer = device.makeBuffer(length: MemoryLayout<Painting>.size * paintings.count)
        memcpy(paintingsBuffer?.contents(), paintings, MemoryLayout<Painting>.size * paintings.count)
        paintingsCount = paintings.count
        metalView.setNeedsDisplay()
    }
}

// MARK: - MTKViewDelegate
extension DrawingView: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }
        guard let drawable = view.currentDrawable else { return }
        guard let commandEncoder = commandBuffer.makeComputeCommandEncoder() else { return }
        
        commandEncoder.setComputePipelineState(pipelineState)
        commandEncoder.setTexture(drawable.texture, index: 0)
        
        if let paintingsBuffer, let paintingsCount {
            commandEncoder.setBuffer(paintingsBuffer, offset: 0, index: 0)
            var count = paintingsCount
            commandEncoder.setBytes(&count, length: MemoryLayout<Int>.stride, index: 1)
        }
        
        let width = pipelineState.threadExecutionWidth
        let height = pipelineState.maxTotalThreadsPerThreadgroup / width
        
        let threadsPerGroup = MTLSize(width: width, height: height, depth: 1)
        let threadGroupsPerGrid = MTLSize(width: Int(view.drawableSize.width) / width, height: Int(view.drawableSize.height) / height, depth: 1)
        commandEncoder.dispatchThreadgroups(threadGroupsPerGrid, threadsPerThreadgroup: threadsPerGroup)
        
        commandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}

// MARK: - Private Methods
extension DrawingView {
    func setupView() {
        isUserInteractionEnabled = false
        backgroundColor = .clear
    }
    
    func addSubviews() {
        addSubview(metalView)
    }
}
