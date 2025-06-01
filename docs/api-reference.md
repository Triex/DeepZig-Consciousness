# DeepZig Consciousness API Reference

## Overview

This document provides a comprehensive proposed API reference for the DeepZig Consciousness system, built with Zig (version 0.14.0 at time of writing). The API is designed for cross-platform deployment including native execution, WebAssembly (WASM), and WASI environments.

## Core Consciousness API

### Initialization and Configuration

```zig
// Using decl literals for cleaner initialization
pub const ConsciousnessConfig = struct {
    neuron_count: u32,
    layer_count: u8,
    learning_rate: f64,
    integration_threshold: f64,
    
    // Default configurations using decl literals
    pub const minimal: ConsciousnessConfig = .{
        .neuron_count = 1000,
        .layer_count = 3,
        .learning_rate = 0.01,
        .integration_threshold = 0.3,
    };
    
    pub const standard: ConsciousnessConfig = .{
        .neuron_count = 10000,
        .layer_count = 7,
        .learning_rate = 0.001,
        .integration_threshold = 0.5,
    };
    
    pub const advanced: ConsciousnessConfig = .{
        .neuron_count = 100000,
        .layer_count = 12,
        .learning_rate = 0.0001,
        .integration_threshold = 0.7,
    };
};

/// Initialize consciousness system with configuration
pub fn initConsciousness(allocator: std.mem.Allocator, config: ConsciousnessConfig) !*Consciousness {
    var consciousness = try allocator.create(Consciousness);
    errdefer allocator.destroy(consciousness);
    
    consciousness.* = try .init(allocator, config);
    
    return consciousness;
}

/// Initialize with default configuration using decl literals
pub fn initDefault(allocator: std.mem.Allocator) !*Consciousness {
    return initConsciousness(allocator, .standard);
}
```

### Core Consciousness Structure

```zig
pub const Consciousness = struct {
    allocator: std.mem.Allocator,
    config: ConsciousnessConfig,
    
    // Using unmanaged containers for optimal performance
    neurons: std.ArrayListUnmanaged(Neuron) = .empty,
    connections: std.HashMapUnmanaged(NeuronId, ConnectionMatrix) = .empty,
    layers: std.ArrayListUnmanaged(Layer) = .empty,
    
    // Consciousness state tracking
    phi_measure: f64 = 0.0,
    integration_level: f64 = 0.0,
    awareness_state: AwarenessState = .dormant,
    
    const Self = @This();
    
    /// Initialize consciousness system
    pub fn init(allocator: std.mem.Allocator, config: ConsciousnessConfig) !Self {
        var self = Self{
            .allocator = allocator,
            .config = config,
        };
        
        try self.initializeNeuralNetwork();
        try self.initializeConnections();
        
        return self;
    }
    
    /// Clean up consciousness system
    pub fn deinit(self: *Self) void {
        self.neurons.deinit(self.allocator);
        self.connections.deinit(self.allocator);
        self.layers.deinit(self.allocator);
    }
    
    // ... additional methods
};
```

### Neuron and Network Components

```zig
pub const NeuronId = u32;
pub const ActivationLevel = f32;

pub const Neuron = struct {
    id: NeuronId,
    activation: ActivationLevel = 0.0,
    bias: f32 = 0.0,
    layer_index: u8,
    neuron_type: NeuronType = .regular,
    
    // Input connections with weights
    inputs: std.ArrayListUnmanaged(Connection) = .empty,
    
    const Self = @This();
    
    pub fn init(id: NeuronId, layer_index: u8) Self {
        return .{
            .id = id,
            .layer_index = layer_index,
        };
    }
    
    pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
        self.inputs.deinit(allocator);
    }
    
    /// Compute neuron activation using sigmoid function
    pub fn computeActivation(self: *Self) void {
        var sum: f32 = self.bias;
        
        for (self.inputs.items) |connection| {
            sum += connection.weight * connection.source_activation;
        }
        
        // Sigmoid activation with @branchHint optimization
        if (sum > 0) {
            @branchHint(.likely);
            self.activation = 1.0 / (1.0 + @exp(-sum));
        } else {
            @branchHint(.unlikely);
            self.activation = @exp(sum) / (1.0 + @exp(sum));
        }
    }
};

pub const NeuronType = enum {
    regular,
    sensory,
    motor,
    integrative,
    metacognitive,
};

pub const Connection = struct {
    source_id: NeuronId,
    source_activation: ActivationLevel,
    weight: f32,
    plasticity: f32 = 1.0,
    
    /// Update connection weight based on Hebbian learning
    pub fn updateWeight(self: *Connection, learning_rate: f64, pre_activity: f32, post_activity: f32) void {
        const delta = learning_rate * pre_activity * post_activity * self.plasticity;
        self.weight += @floatCast(delta);
        
        // Clamp weights to prevent explosion
        self.weight = std.math.clamp(self.weight, -10.0, 10.0);
    }
};
```

## Integrated Information Theory (IIT) Implementation

### Φ (Phi) Computation

```zig
pub const PhiMeasure = struct {
    phi_value: f64,
    computation_time: u64,
    partition_count: usize,
    
    pub const invalid: PhiMeasure = .{
        .phi_value = 0.0,
        .computation_time = 0,
        .partition_count = 0,
    };
};

/// Compute Φ measure for given network state
pub fn computePhi(consciousness: *Consciousness, state: NetworkState) !PhiMeasure {
    const start_time = std.time.microTimestamp();
    
    var max_phi: f64 = 0.0;
    const partitions = try generatePartitions(consciousness.allocator, state);
    defer consciousness.allocator.free(partitions);
    
    for (partitions) |partition| {
        const phi = try computePartitionPhi(state, partition);
        max_phi = @max(max_phi, phi);
    }
    
    const end_time = std.time.microTimestamp();
    
    return PhiMeasure{
        .phi_value = max_phi,
        .computation_time = @intCast(end_time - start_time),
        .partition_count = partitions.len,
    };
}

/// Efficient Φ computation using SIMD optimization
pub fn computePhiSIMD(consciousness: *Consciousness, state: NetworkState) !PhiMeasure {
    const VectorSize = 8;
    const FloatVector = @Vector(VectorSize, f32);
    
    // Vectorized computation for large networks
    const start_time = std.time.microTimestamp();
    
    var phi_accumulator: f64 = 0.0;
    const vector_count = state.activations.len / VectorSize;
    
    for (0..vector_count) |i| {
        const base_idx = i * VectorSize;
        const activation_vec: FloatVector = state.activations[base_idx..base_idx + VectorSize][0..VectorSize].*;
        
        // Compute information and integration in parallel
        const info_vec = computeInformationVector(activation_vec);
        const integration_vec = computeIntegrationVector(activation_vec, state);
        
        const phi_vec = integration_vec - info_vec;
        
        // Reduce vector to scalar
        phi_accumulator += @reduce(.Add, phi_vec);
    }
    
    const end_time = std.time.microTimestamp();
    
    return PhiMeasure{
        .phi_value = phi_accumulator,
        .computation_time = @intCast(end_time - start_time),
        .partition_count = vector_count,
    };
}
```

### Network State Management

```zig
pub const NetworkState = struct {
    activations: []f32,
    connections: []ConnectionWeight,
    timestamp: u64,
    
    const Self = @This();
    
    pub fn init(allocator: std.mem.Allocator, neuron_count: usize) !Self {
        return Self{
            .activations = try allocator.alloc(f32, neuron_count),
            .connections = try allocator.alloc(ConnectionWeight, neuron_count * neuron_count),
            .timestamp = std.time.milliTimestamp(),
        };
    }
    
    pub fn deinit(self: Self, allocator: std.mem.Allocator) void {
        allocator.free(self.activations);
        allocator.free(self.connections);
    }
    
    /// Capture current state of consciousness network
    pub fn capture(consciousness: *Consciousness) !NetworkState {
        var state = try NetworkState.init(consciousness.allocator, consciousness.neurons.items.len);
        
        // Copy current activations
        for (consciousness.neurons.items, 0..) |neuron, i| {
            state.activations[i] = neuron.activation;
        }
        
        // Copy connection weights
        var idx: usize = 0;
        for (consciousness.neurons.items) |neuron| {
            for (neuron.inputs.items) |connection| {
                state.connections[idx] = connection.weight;
                idx += 1;
            }
        }
        
        return state;
    }
};
```

## Global Workspace Theory (GWT) Implementation

### Workspace Management

```zig
pub const GlobalWorkspace = struct {
    allocator: std.mem.Allocator,
    
    // Workspace contents using unmanaged containers
    conscious_contents: std.ArrayListUnmanaged(WorkspaceContent) = .empty,
    competing_coalitions: std.ArrayListUnmanaged(Coalition) = .empty,
    broadcast_threshold: f64 = 0.6,
    
    const Self = @This();
    
    pub fn init(allocator: std.mem.Allocator) Self {
        return .{ .allocator = allocator };
    }
    
    pub fn deinit(self: *Self) void {
        for (self.conscious_contents.items) |*content| {
            content.deinit(self.allocator);
        }
        self.conscious_contents.deinit(self.allocator);
        
        for (self.competing_coalitions.items) |*coalition| {
            coalition.deinit(self.allocator);
        }
        self.competing_coalitions.deinit(self.allocator);
    }
    
    /// Process competition and select conscious content
    pub fn processCompetition(self: *Self) !?WorkspaceContent {
        if (self.competing_coalitions.items.len == 0) return null;
        
        // Find winning coalition using labeled switch (Zig 0.14.0 feature)
        var winner: ?*Coalition = null;
        var max_strength: f64 = self.broadcast_threshold;
        
        competition: for (self.competing_coalitions.items) |*coalition| {
            switch (coalition.state) {
                .competing => {
                    if (coalition.strength > max_strength) {
                        max_strength = coalition.strength;
                        winner = coalition;
                        continue :competition;
                    }
                },
                .dominant => {
                    // Already dominant, check if still above threshold
                    if (coalition.strength < self.broadcast_threshold) {
                        coalition.state = .fading;
                    }
                    continue :competition;
                },
                .fading => {
                    // Remove from competition
                    continue :competition;
                },
            }
        }
        
        if (winner) |w| {
            w.state = .dominant;
            return w.getContent();
        }
        
        return null;
    }
};

pub const WorkspaceContent = struct {
    data: []u8,
    strength: f64,
    source_module: ModuleId,
    content_type: ContentType,
    
    const Self = @This();
    
    pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
        allocator.free(self.data);
    }
    
    pub fn init(allocator: std.mem.Allocator, data: []const u8, source: ModuleId) !Self {
        const owned_data = try allocator.dupe(u8, data);
        return .{
            .data = owned_data,
            .strength = 0.5,
            .source_module = source,
            .content_type = .perceptual,
        };
    }
};

pub const ContentType = enum {
    perceptual,
    conceptual,
    emotional,
    motor,
    metacognitive,
};
```

### Broadcasting and Module Communication

```zig
pub const ModuleId = u16;

pub const CognitiveModule = struct {
    id: ModuleId,
    allocator: std.mem.Allocator,
    
    // Module-specific processors
    processors: std.ArrayListUnmanaged(Processor) = .empty,
    input_buffer: std.ArrayListUnmanaged(ModuleInput) = .empty,
    output_buffer: std.ArrayListUnmanaged(ModuleOutput) = .empty,
    
    // Attention and activation
    attention_level: f64 = 0.0,
    activation_threshold: f64 = 0.3,
    
    const Self = @This();
    
    pub fn init(allocator: std.mem.Allocator, id: ModuleId) Self {
        return .{
            .id = id,
            .allocator = allocator,
        };
    }
    
    pub fn deinit(self: *Self) void {
        self.processors.deinit(self.allocator);
        
        for (self.input_buffer.items) |*input| {
            input.deinit(self.allocator);
        }
        self.input_buffer.deinit(self.allocator);
        
        for (self.output_buffer.items) |*output| {
            output.deinit(self.allocator);
        }
        self.output_buffer.deinit(self.allocator);
    }
    
    /// Process broadcast from global workspace
    pub fn receiveBroadcast(self: *Self, content: WorkspaceContent) !void {
        if (self.attention_level < self.activation_threshold) {
            @branchHint(.unlikely);
            return; // Module not attending
        }
        
        @branchHint(.likely);
        const input = try ModuleInput.fromWorkspaceContent(self.allocator, content);
        try self.input_buffer.append(self.allocator, input);
        
        // Trigger processing
        try self.processInputs();
    }
    
    fn processInputs(self: *Self) !void {
        for (self.input_buffer.items) |input| {
            const output = try self.processInput(input);
            try self.output_buffer.append(self.allocator, output);
        }
        
        // Clear processed inputs
        for (self.input_buffer.items) |*input| {
            input.deinit(self.allocator);
        }
        self.input_buffer.clearRetainingCapacity();
    }
};
```

## Higher-Order Thought (HOT) Implementation

### Metacognitive Processing

```zig
pub const MetacognitiveProcessor = struct {
    allocator: std.mem.Allocator,
    
    // Self-awareness components
    self_model: SelfModel,
    thought_monitor: ThoughtMonitor,
    metacognitive_beliefs: std.HashMapUnmanaged(BeliefId, MetaBelief) = .empty,
    
    const Self = @This();
    
    pub fn init(allocator: std.mem.Allocator) !Self {
        return .{
            .allocator = allocator,
            .self_model = try SelfModel.init(allocator),
            .thought_monitor = try ThoughtMonitor.init(allocator),
        };
    }
    
    pub fn deinit(self: *Self) void {
        self.self_model.deinit();
        self.thought_monitor.deinit();
        
        var iterator = self.metacognitive_beliefs.iterator();
        while (iterator.next()) |entry| {
            entry.value_ptr.deinit(self.allocator);
        }
        self.metacognitive_beliefs.deinit(self.allocator);
    }
    
    /// Generate higher-order thought about current mental state
    pub fn generateHOT(self: *Self, mental_state: MentalState) !HigherOrderThought {
        const confidence = self.assessConfidence(mental_state);
        const certainty = self.assessCertainty(mental_state);
        
        // Create meta-representation of current state
        const meta_rep = try MetaRepresentation.create(
            self.allocator, 
            mental_state, 
            confidence, 
            certainty
        );
        
        return HigherOrderThought{
            .meta_representation = meta_rep,
            .timestamp = std.time.milliTimestamp(),
            .consciousness_level = self.computeConsciousnessLevel(meta_rep),
        };
    }
    
    /// Monitor and evaluate ongoing thoughts
    pub fn monitorThoughts(self: *Self, thought_stream: []const Thought) !MonitoringResult {
        var coherence_score: f64 = 0.0;
        var contradiction_count: u32 = 0;
        
        // Analyze thought coherence and consistency
        for (thought_stream, 0..) |thought, i| {
            for (thought_stream[i + 1..]) |other_thought| {
                const coherence = self.assessCoherence(thought, other_thought);
                coherence_score += coherence;
                
                if (coherence < -0.5) {
                    contradiction_count += 1;
                }
            }
        }
        
        return MonitoringResult{
            .coherence_score = coherence_score / @as(f64, @floatFromInt(thought_stream.len)),
            .contradiction_count = contradiction_count,
            .recommendation = if (contradiction_count > 3) .resolve_contradictions else .continue_processing,
        };
    }
};

pub const HigherOrderThought = struct {
    meta_representation: MetaRepresentation,
    timestamp: u64,
    consciousness_level: f64,
    
    /// Check if this HOT indicates conscious awareness
    pub fn isConscious(self: HigherOrderThought) bool {
        return self.consciousness_level > 0.7 and 
               self.meta_representation.confidence > 0.6;
    }
};
```

## Predictive Processing Implementation

### Predictive Hierarchies

```zig
pub const PredictiveLayer = struct {
    level: u8,
    allocator: std.mem.Allocator,
    
    // Predictions and errors
    predictions: std.ArrayListUnmanaged(Prediction) = .empty,
    prediction_errors: std.ArrayListUnmanaged(PredictionError) = .empty,
    
    // Hierarchical connections
    lower_layer: ?*PredictiveLayer = null,
    upper_layer: ?*PredictiveLayer = null,
    
    const Self = @This();
    
    pub fn init(allocator: std.mem.Allocator, level: u8) Self {
        return .{
            .level = level,
            .allocator = allocator,
        };
    }
    
    pub fn deinit(self: *Self) void {
        self.predictions.deinit(self.allocator);
        self.prediction_errors.deinit(self.allocator);
    }
    
    /// Generate predictions based on current priors
    pub fn generatePredictions(self: *Self, priors: []const Prior) !void {
        for (priors) |prior| {
            const prediction = try self.computePrediction(prior);
            try self.predictions.append(self.allocator, prediction);
        }
    }
    
    /// Compute prediction error and propagate
    pub fn computePredictionError(self: *Self, sensory_input: SensoryInput) !void {
        for (self.predictions.items, 0..) |prediction, i| {
            const error = sensory_input.data[i] - prediction.value;
            const weighted_error = error * prediction.precision;
            
            const pred_error = PredictionError{
                .error_magnitude = @abs(weighted_error),
                .prediction_id = prediction.id,
                .layer_level = self.level,
            };
            
            try self.prediction_errors.append(self.allocator, pred_error);
        }
        
        // Propagate errors up the hierarchy
        if (self.upper_layer) |upper| {
            try upper.receivePredictionErrors(self.prediction_errors.items);
        }
    }
    
    /// Update priors based on prediction errors
    pub fn updatePriors(self: *Self) !void {
        for (self.prediction_errors.items) |error| {
            try self.adjustPrior(error);
        }
        
        // Clear processed errors
        self.prediction_errors.clearRetainingCapacity();
    }
};

pub const Prediction = struct {
    id: u32,
    value: f32,
    precision: f32,
    confidence: f64,
    timestamp: u64,
};

pub const PredictionError = struct {
    error_magnitude: f32,
    prediction_id: u32,
    layer_level: u8,
    
    /// Determine if error requires attention
    pub fn requiresAttention(self: PredictionError) bool {
        return self.error_magnitude > 0.8;
    }
};
```

## WebAssembly Integration

### WASM Export Interface

```zig
// WebAssembly exports for consciousness system
const wasm_allocator = std.heap.page_allocator;
var global_consciousness: ?*Consciousness = null;

/// Initialize consciousness system (WASM export)
export fn wasm_init_consciousness(config_ptr: [*]const u8, config_len: u32) i32 {
    const config_data = config_ptr[0..config_len];
    
    // Parse configuration from JSON/bytes
    const config = parseConsciousnessConfig(config_data) catch |err| {
        std.log.err("Failed to parse config: {}", .{err});
        return -1;
    };
    
    global_consciousness = initConsciousness(wasm_allocator, config) catch |err| {
        std.log.err("Failed to initialize consciousness: {}", .{err});
        return -1;
    };
    
    return 0; // Success
}

/// Process thought input (WASM export)
export fn wasm_process_thought(input_ptr: [*]const f32, input_len: u32, output_ptr: [*]f32) i32 {
    if (global_consciousness == null) return -1;
    
    const input = input_ptr[0..input_len];
    var output = output_ptr[0..input_len];
    
    // Process through consciousness system
    const consciousness = global_consciousness.?;
    consciousness.processInput(input, output) catch |err| {
        std.log.err("Processing failed: {}", .{err});
        return -1;
    };
    
    return 0;
}

/// Compute and return Φ measure (WASM export)
export fn wasm_compute_phi() f64 {
    if (global_consciousness == null) return 0.0;
    
    const state = consciousness.captureState() catch return 0.0;
    defer state.deinit(wasm_allocator);
    
    const phi_result = computePhi(global_consciousness.?, state) catch return 0.0;
    return phi_result.phi_value;
}

/// Get consciousness state as JSON (WASM export)
export fn wasm_get_state(output_ptr: [*]u8, max_len: u32) u32 {
    if (global_consciousness == null) return 0;
    
    const output_buffer = output_ptr[0..max_len];
    const json_state = serializeConsciousnessState(global_consciousness.?, output_buffer) catch return 0;
    
    return @intCast(json_state.len);
}

/// Cleanup consciousness system (WASM export)
export fn wasm_cleanup_consciousness() void {
    if (global_consciousness) |consciousness| {
        consciousness.deinit();
        wasm_allocator.destroy(consciousness);
        global_consciousness = null;
    }
}
```

### JavaScript Interface

```javascript
// JavaScript wrapper for WASM consciousness system
class ConsciousnessSystem {
    constructor() {
        this.wasm = null;
        this.initialized = false;
    }
    
    async init(wasmModule, config = {}) {
        this.wasm = wasmModule;
        
        // Default configuration
        const defaultConfig = {
            neuron_count: 10000,
            layer_count: 7,
            learning_rate: 0.001,
            integration_threshold: 0.5
        };
        
        const finalConfig = { ...defaultConfig, ...config };
        const configBytes = new TextEncoder().encode(JSON.stringify(finalConfig));
        
        // Allocate memory for config
        const configPtr = this.wasm._malloc(configBytes.length);
        const configBuffer = new Uint8Array(this.wasm.HEAPU8.buffer, configPtr, configBytes.length);
        configBuffer.set(configBytes);
        
        const result = this.wasm._wasm_init_consciousness(configPtr, configBytes.length);
        this.wasm._free(configPtr);
        
        if (result === 0) {
            this.initialized = true;
            console.log('Consciousness system initialized successfully');
        } else {
            throw new Error('Failed to initialize consciousness system');
        }
    }
    
    processThought(inputArray) {
        if (!this.initialized) throw new Error('System not initialized');
        
        const inputPtr = this.wasm._malloc(inputArray.length * 4);
        const outputPtr = this.wasm._malloc(inputArray.length * 4);
        
        const inputBuffer = new Float32Array(this.wasm.HEAPF32.buffer, inputPtr / 4, inputArray.length);
        inputBuffer.set(inputArray);
        
        const result = this.wasm._wasm_process_thought(inputPtr, inputArray.length, outputPtr);
        
        if (result === 0) {
            const outputBuffer = new Float32Array(this.wasm.HEAPF32.buffer, outputPtr / 4, inputArray.length);
            const output = Array.from(outputBuffer);
            
            this.wasm._free(inputPtr);
            this.wasm._free(outputPtr);
            
            return output;
        } else {
            this.wasm._free(inputPtr);
            this.wasm._free(outputPtr);
            throw new Error('Failed to process thought');
        }
    }
    
    computePhi() {
        if (!this.initialized) throw new Error('System not initialized');
        return this.wasm._wasm_compute_phi();
    }
    
    getState() {
        if (!this.initialized) throw new Error('System not initialized');
        
        const maxLen = 65536; // 64KB buffer
        const outputPtr = this.wasm._malloc(maxLen);
        
        const actualLen = this.wasm._wasm_get_state(outputPtr, maxLen);
        
        if (actualLen > 0) {
            const outputBuffer = new Uint8Array(this.wasm.HEAPU8.buffer, outputPtr, actualLen);
            const jsonString = new TextDecoder().decode(outputBuffer);
            this.wasm._free(outputPtr);
            
            return JSON.parse(jsonString);
        } else {
            this.wasm._free(outputPtr);
            return null;
        }
    }
    
    destroy() {
        if (this.initialized) {
            this.wasm._wasm_cleanup_consciousness();
            this.initialized = false;
        }
    }
}

// Usage example
async function demonstrateConsciousness() {
    const consciousness = new ConsciousnessSystem();
    
    // Load WASM module (implementation specific)
    const wasmModule = await loadWasmModule('./deepzig-consciousness.wasm');
    
    await consciousness.init(wasmModule, {
        neuron_count: 5000,
        learning_rate: 0.01
    });
    
    // Process some thoughts
    const thoughtInput = new Array(100).fill(0).map(() => Math.random());
    const thoughtOutput = consciousness.processThought(thoughtInput);
    
    console.log('Thought processed:', thoughtOutput);
    
    // Measure consciousness
    const phi = consciousness.computePhi();
    console.log('Φ measure:', phi);
    
    // Get system state
    const state = consciousness.getState();
    console.log('Consciousness state:', state);
    
    consciousness.destroy();
}
```

## Error Handling

### Consciousness-Specific Error Types

```zig
pub const ConsciousnessError = error{
    InitializationFailed,
    NetworkTopologyInvalid,
    PhiComputationFailed,
    WorkspaceOverflow,
    MetacognitionError,
    PredictionError,
    InsufficientActivation,
    MemoryAllocationFailed,
    ConfigurationInvalid,
    StateCorrupted,
};

/// Enhanced error context for consciousness operations
pub const ErrorContext = struct {
    operation: []const u8,
    timestamp: u64,
    system_state: SystemState,
    phi_level: f64,
    
    pub fn create(operation: []const u8, consciousness: *Consciousness) ErrorContext {
        return .{
            .operation = operation,
            .timestamp = std.time.milliTimestamp(),
            .system_state = consciousness.getSystemState(),
            .phi_level = consciousness.phi_measure,
        };
    }
    
    pub fn log(self: ErrorContext, err: anyerror) void {
        std.log.err("Consciousness operation '{}' failed: {} (Φ={d:.3}, state={})", .{
            self.operation, err, self.phi_level, self.system_state
        });
    }
};

/// Safe consciousness operation wrapper
pub fn safeConsciousnessOp(
    consciousness: *Consciousness,
    operation: []const u8,
    op_func: fn(*Consciousness) anyerror!void
) void {
    const context = ErrorContext.create(operation, consciousness);
    
    op_func(consciousness) catch |err| {
        context.log(err);
        
        // Attempt graceful degradation
        switch (err) {
            ConsciousnessError.PhiComputationFailed => {
                consciousness.fallbackToSimplePhi();
            },
            ConsciousnessError.WorkspaceOverflow => {
                consciousness.clearWorkspace();
            },
            ConsciousnessError.StateCorrupted => {
                consciousness.resetToSafeState();
            },
            else => {
                consciousness.enterSafeMode();
            },
        }
    };
}
```

This comprehensive API reference provides the foundation for building consciousness systems with Zig 0.14.0, incorporating the latest language features and best practices for cross-platform deployment. 