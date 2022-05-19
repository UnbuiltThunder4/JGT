//
//  NeuralNetworkModel.swift
//  JGT
//
//  Created by Eugenio Raja on 05/05/22.
//

import Foundation

public enum DataSizeType: Int, Codable {
    case oneD = 1
    case twoD
    case threeD
}

public struct DataSize: Codable {
    var type: DataSizeType
    var width: Int
    var height: Int?
    var depth: Int?
    
    public init(width: Int) {
        type = .oneD
        self.width = width
    }
    
    public init(width: Int, height: Int) {
        type = .twoD
        self.width = width
        self.height = height
    }
    
    public init(width: Int, height: Int, depth: Int) {
        type = .threeD
        self.width = width
        self.height = height
        self.depth = depth
    }
    
}

public struct DataPiece: Equatable {
    public static func == (lhs: DataPiece, rhs: DataPiece) -> Bool {
        return lhs.body == rhs.body
    }
    
    public var size: DataSize
    public var body: [Float]
    
    func get(x: Int) -> Float {
        return body[x]
    }
    
    func get(x: Int, y: Int) -> Float {
        return body[x+y*size.width]
    }
    
    func get(x: Int, y: Int, z: Int) -> Float {
        return body[z+(x+y*size.width)*size.depth!]
    }
    
    public init(size: DataSize, body: [Float]) {
        var flatSize = size.width
        if let height = size.height {
            flatSize *= height
        }
        if let depth = size.depth {
            flatSize *= depth
        }
        if flatSize != body.count {
            fatalError("DataPiece body does not conform to DataSize.")
        }
        self.size = size
        self.body = body
    }
    
}

public struct DataItem {
    var input: DataPiece
    var output: DataPiece
    
    public init(input: DataPiece, output: DataPiece) {
        self.input = input
        self.output = output
    }
    
    public init(input: [Float], inputSize: DataSize, output: [Float], outputSize: DataSize) {
        self.input = DataPiece(size: inputSize, body: input)
        self.output = DataPiece(size: outputSize, body: output)
    }
}

final public class NeuralNetwork {
    public var layers: [DenseLayer] = []
    
    public init(layers: [DenseLayer]) {
        self.layers = layers
    }
    
    public func predict(input:DataPiece) -> [Float] {
        return forward(networkInput: input).body
    }
    
    public func mutate(mutationRate: Int) {
        for i in (0..<layers.count) {
            layers[i].mutate(mutationRate: mutationRate)
        }
    }
    
    public func merge(other: NeuralNetwork) -> NeuralNetwork {
        let new = NeuralNetwork(
            layers: [
                DenseLayer(inputSize: 2, neuronsCount: 2, functionRaw: .sigmoid),
                DenseLayer(inputSize: 2, neuronsCount: 4, functionRaw: .sigmoid),
                DenseLayer(inputSize: 4, neuronsCount: 2, functionRaw: .sigmoid)
            ])
        for i in (0..<layers.count) {
            layers[i].merge(new: &new.layers[i], other: other.layers[i])
        }
        return new
    }
    
    public func summary() -> String {
        var summary: String = ""
        for layer in layers {
            summary += "Layer\n"
            for neuron in layer.neurons {
                summary += "Neuron Weights: \(neuron.weights)\nNeuron Bias: \(neuron.bias)\n"
            }
        }
        return summary
    }
    
    private func forward(networkInput: DataPiece) -> DataPiece {
        var input = networkInput
        for i in 0..<layers.count {
            input = layers[i].forward(input: input)
        }
        return input
    }
}

struct Neuron {
    var weights: [Float]
    var bias: Float
}

public class DenseLayer {
    var neurons: [Neuron] = []
    var function: ActivationFunction
    var output: DataPiece?
    private let queue = DispatchQueue.global(qos: .userInitiated)
    
    init(inputSize: Int, neuronsCount: Int, functionRaw: ActivationFunctionRaw) {
        let function = getActivationFunction(rawValue: functionRaw.rawValue)
        self.function = function
        output = .init(size: .init(width: neuronsCount), body: Array(repeating: Float.zero, count: neuronsCount))
        
        for _ in 0..<neuronsCount {
            var weights = [Float]()
            for _ in 0..<inputSize {
                weights.append(Float.random(in: -1.0 ... 1.0))
            }
            neurons.append(Neuron(weights: weights, bias: 0.0))
        }
    }
    
    func forward(input: DataPiece) -> DataPiece {
        input.body.withUnsafeBufferPointer { inputPtr in
            output?.body.withUnsafeMutableBufferPointer { outputPtr in
                neurons.withUnsafeBufferPointer { neuronsPtr in
                    DispatchQueue.concurrentPerform(iterations: neuronsPtr.count, execute: { i in
                        var out = neuronsPtr[i].bias
                        neuronsPtr[i].weights.withUnsafeBufferPointer { weightsPtr in
                            DispatchQueue.concurrentPerform(iterations: neuronsPtr[i].weights.count, execute: { i in
                                out += weightsPtr[i] * inputPtr[i]
                            })
                        }
                        outputPtr[i] = function.activation(input: out)
                    })
                }
            }
        }
        return output!
    }
    
    func merge(new: inout DenseLayer, other: DenseLayer) {
        for i in 0..<new.neurons.count {
            if (Int.random(in: 0...1) == 0) {
                new.neurons[i] = self.neurons[i]
            }
            else {
                new.neurons[i] = other.neurons[i]
            }
        }
    }
    
    func mutate(mutationRate: Int) {
        let neuronsCount = neurons.count
        neurons.withUnsafeMutableBufferPointer { neuronsPtr in
            DispatchQueue.concurrentPerform(iterations: neuronsCount, execute: { i in
                if (Int.random(in: 0...100) < mutationRate) {
                    var weights = [Float]()
                    neuronsPtr[i].weights.withUnsafeMutableBufferPointer { weightsPtr in
                        let weightsCount = weightsPtr.count
                        DispatchQueue.concurrentPerform(iterations: weightsCount, execute: { j in
                            weights.append(Float.random(in: -1.0 ... 1.0))
                        })
                    }
                    neuronsPtr[i].weights = weights
                    neuronsPtr[i].bias = Float.random(in: -1.0 ... 1.0)
                }
            })
        }
    }
}

func getActivationFunction(rawValue: Int) -> ActivationFunction {
    switch rawValue {
    case ActivationFunctionRaw.reLU.rawValue:
        return ReLU()
    case ActivationFunctionRaw.sigmoid.rawValue:
        return Sigmoid()
    default:
        return Plain()
    }
}

public enum ActivationFunctionRaw: Int {
    case sigmoid = 0
    case reLU
    case plain
}

protocol ActivationFunction {
    var rawValue: Int { get }
    func activation(input: Float) -> Float
    func derivative(output: Float) -> Float
}

struct ReLU: ActivationFunction {
    public var rawValue: Int = 1
    
    public func activation(input: Float) -> Float {
        return max(Float.zero, input)
    }
    
    public func derivative(output: Float) -> Float {
        return output < 0 ? 0 : 1
    }
}

struct Sigmoid: ActivationFunction {
    public var rawValue: Int = 0
    
    public func activation(input: Float) -> Float {
        return 1.0/(1.0+exp(-input))
    }
    
    public func derivative(output: Float) -> Float {
        return output * (1.0-output)
    }
}

struct Plain: ActivationFunction {
    public var rawValue: Int = 2
    
    public func activation(input: Float) -> Float {
        return input
    }
    
    public func derivative(output: Float) -> Float {
        return 1
    }
}

