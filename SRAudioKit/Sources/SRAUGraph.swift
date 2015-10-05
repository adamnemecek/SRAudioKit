//
//  SRAUGraph.swift
//  SRAudioKit
//
//  Created by Heeseung Seo on 2015. 9. 24..
//  Copyright © 2015년 Seorenn. All rights reserved.
//

import Foundation
import CoreAudio
import AudioToolbox
import SRAudioKitPrivates

public class SRAUGraph {
    let graph: AUGraph
    var callbackHelpers = [SRAudioCallbackHelper]()
    
    public init() {
        var graph = AUGraph()
        NewAUGraph(&graph)
        self.graph = graph
    }
    
    public var running: Bool {
        var value = DarwinBoolean(false)
        let res = AUGraphIsRunning(self.graph, &value)
        if res == noErr { return value.boolValue }
        return false
    }
    
    public func clearConnections() throws {
        let res = AUGraphClearConnections(self.graph)
        if res != noErr {
            throw SRAudioError.OSStatusError(status: res, description: "SRAUGraph.clearConnections()")
        }
    }
    
    public func addNode(componentDescription: AudioComponentDescription) throws -> SRAUNode {
        var node = AUNode()
        var desc = componentDescription
        let res = AUGraphAddNode(self.graph, &desc, &node)
        if res != noErr {
            throw SRAudioError.OSStatusError(status: res, description: "SRAUGraph.addNode()")
        }
        
        return SRAUNode(node: node)
    }
    
    public func open() throws {
        let res = AUGraphOpen(self.graph)
        if res != noErr {
            throw SRAudioError.OSStatusError(status: res, description: "SRAUGraph.open()")
        }
    }
    
    public func nodeInfo(node: SRAUNode) throws -> SRAudioUnit {
        var audioUnit = AudioUnit()
        let res = AUGraphNodeInfo(self.graph, node.node, nil, &audioUnit)
        if res != noErr {
            throw SRAudioError.OSStatusError(status: res, description: "SRAUGraph.nodeInfo()")
        }
        
        return SRAudioUnit(audioUnit: audioUnit)
    }
    
    public func connect(sourceNode sourceNode: SRAUNode, sourceOutputNumber: UInt32, destNode: SRAUNode, destInputNumber: UInt32) throws {
        let res = AUGraphConnectNodeInput(self.graph, sourceNode.node, sourceOutputNumber, destNode.node, destInputNumber)
        if res != noErr {
            throw SRAudioError.OSStatusError(status: res, description: "SRAUGraph.connect()")
        }
    }
    
    public func setNodeInputCallback(destNode: SRAUNode, destInputNumber: UInt32, userData: AnyObject, callback: SRAudioUnitRenderCallback) throws {
        let helper = SRAudioCallbackHelper()
        helper.userData = userData
        helper.callback = callback
        
        let res = helper.AUGraphSetNodeInputCallback(self.graph, node: destNode.node, inputNumber: destInputNumber)
        
        if res != noErr {
            throw SRAudioError.OSStatusError(status: res, description: "SRAUGraph.setNodeInputCallback()")
        }
        
        self.callbackHelpers.append(helper)
    }
    
    public func addRenderNotify(userData procRefCon: UnsafePointer<Void>, callback: AURenderCallback) throws {
        var ref = procRefCon
        let res = AUGraphAddRenderNotify(self.graph, callback, &ref)
        if res != noErr {
            throw SRAudioError.OSStatusError(status: res, description: "SRAUGraph.addRenderNotify()")
        }
    }
    
    public func initialize() throws {
        let res = AUGraphInitialize(self.graph)
        if res != noErr {
            throw SRAudioError.OSStatusError(status: res, description: "SRAUGraph.initialize()")
        }
    }
    
    public func update(sync: Bool = true) throws {
        let res: OSStatus
        
        if sync {
            res = AUGraphUpdate(self.graph, nil)
        } else {
            var updateValue = DarwinBoolean(false)
            res = AUGraphUpdate(self.graph, &updateValue)
        }

        if res != noErr {
            throw SRAudioError.OSStatusError(status: res, description: "SRAUGraph.update()")
        }
    }
    
    public func start() throws {
        let res = AUGraphStart(self.graph)
        if res != noErr {
            throw SRAudioError.OSStatusError(status: res, description: "SRAUGraph.start()")
        }
    }
    
    public func stop() throws {
        let res = AUGraphStop(self.graph)
        if res != noErr {
            throw SRAudioError.OSStatusError(status: res, description: "SRAUGraph.stop()")
        }
    }
    
    public func dispose() throws {
        let res = DisposeAUGraph(self.graph)
        if res != noErr {
            throw SRAudioError.OSStatusError(status: res, description: "SRAUGraph.dispose()")
        }
    }
    
    public func CAShow() {
        SRAudioCAShow(self.graph)
    }
}
