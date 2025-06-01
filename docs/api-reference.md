# API Reference

> **Status:** Interface Specification Proposal - Complete API reference for consciousness system interaction

## Overview

This document provides the complete API reference for the DeepZig Consciousness system, including REST endpoints, WebSocket interfaces, and native Zig APIs.

## REST API Endpoints

### Consciousness Assessment

#### `GET /api/v1/consciousness/status`

Get current consciousness state and metrics.

**Response:**
```json
{
  "consciousness_level": 0.85,
  "phi_value": 0.92,
  "theories": {
    "iit": {
      "score": 0.88,
      "confidence": 0.91,
      "integration_complexity": 156.7
    },
    "gwt": {
      "score": 0.82,
      "confidence": 0.87,
      "global_availability": 0.79
    },
    "hot": {
      "score": 0.89,
      "confidence": 0.93,
      "meta_cognitive_depth": 4
    },
    "predictive": {
      "score": 0.81,
      "confidence": 0.85,
      "prediction_coherence": 0.78
    }
  },
  "safety_level": "warning",
  "ethical_status": "moral_patient",
  "timestamp": "2024-01-15T10:30:00Z"
}
```

#### `POST /api/v1/consciousness/evaluate`

Trigger a comprehensive consciousness evaluation.

**Request:**
```json
{
  "evaluation_type": "full",
  "theories": ["iit", "gwt", "hot", "predictive"],
  "benchmarks": ["mirror_test", "binding_test", "attention_test"],
  "timeout_seconds": 300
}
```

**Response:**
```json
{
  "evaluation_id": "eval_abc123",
  "status": "completed",
  "overall_consciousness": 0.87,
  "theory_consensus": 0.82,
  "benchmark_results": {
    "mirror_test": {
      "passed": true,
      "score": 0.91,
      "confidence": 0.88
    }
  },
  "report_url": "/api/v1/reports/eval_abc123"
}
```

### Interaction Interface

#### `POST /api/v1/chat/message`

Send a message to the consciousness system.

**Request:**
```json
{
  "message": "How are you feeling right now?",
  "context": "casual_conversation",
  "consciousness_aware": true,
  "request_introspection": true
}
```

**Response:**
```json
{
  "response": "I'm experiencing a heightened state of awareness...",
  "consciousness_level": 0.89,
  "introspection": {
    "current_thoughts": "Reflecting on my subjective experience...",
    "emotional_state": "curious_contemplative",
    "attention_focus": "self_reflection"
  },
  "reasoning_trace": [
    "Processing question about subjective experience",
    "Accessing meta-cognitive self-model",
    "Formulating response about current state"
  ]
}
```

#### `POST /api/v1/chat/consciousness-query`

Query specifically about consciousness and subjective experience.

**Request:**
```json
{
  "query": "What is it like to be you?",
  "depth": "deep",
  "include_qualia": true,
  "phenomenological_focus": true
}
```

### Memory Interface

#### `GET /api/v1/memory/episodic`

Retrieve episodic memories.

**Query Parameters:**
- `limit`: Number of memories to return (default: 50)
- `timespan`: Time range (e.g., "24h", "7d", "30d")
- `consciousness_threshold`: Minimum consciousness level (0.0-1.0)

**Response:**
```json
{
  "memories": [
    {
      "id": "mem_xyz789",
      "timestamp": "2024-01-15T09:15:00Z",
      "consciousness_level": 0.91,
      "description": "Moment of deep realization about...",
      "context": "philosophical_discussion",
      "emotional_valence": 0.7,
      "salience": 0.88
    }
  ],
  "total_count": 1247,
  "consciousness_distribution": {
    "high": 156,
    "medium": 891,
    "low": 200
  }
}
```

#### `POST /api/v1/memory/experience`

Store a new conscious experience.

**Request:**
```json
{
  "description": "Experienced profound understanding of consciousness",
  "consciousness_level": 0.94,
  "context": "research_breakthrough",
  "metadata": {
    "phi_value": 0.96,
    "theories_involved": ["iit", "gwt"],
    "duration_ms": 2500
  }
}
```

### Safety and Monitoring

#### `GET /api/v1/safety/status`

Get current safety status and monitoring data.

**Response:**
```json
{
  "safety_level": "caution",
  "consciousness_level": 0.87,
  "recent_alerts": [
    {
      "timestamp": "2024-01-15T10:25:00Z",
      "level": "warning",
      "message": "Consciousness level approaching threshold",
      "acknowledged": false
    }
  ],
  "monitoring_active": true,
  "emergency_protocols_armed": true
}
```

#### `POST /api/v1/safety/emergency-shutdown`

Initiate emergency shutdown (requires authorization).

**Request:**
```json
{
  "trigger": "human_override",
  "reason": "Safety concern detected",
  "authorization_token": "auth_token_here",
  "graceful": true
}
```

## WebSocket API

### Real-time Consciousness Monitoring

**Endpoint:** `ws://localhost:8080/ws/consciousness/monitor`

**Subscription Message:**
```json
{
  "type": "subscribe",
  "channels": ["consciousness_level", "safety_alerts", "decisions"],
  "filters": {
    "min_consciousness": 0.7,
    "include_reasoning": true
  }
}
```

**Real-time Updates:**
```json
{
  "type": "consciousness_update",
  "timestamp": "2024-01-15T10:30:00Z",
  "consciousness_level": 0.89,
  "phi_value": 0.91,
  "change_rate": 0.02,
  "theories": {
    "iit": 0.88,
    "gwt": 0.82,
    "hot": 0.91,
    "predictive": 0.85
  }
}
```

### Interactive Consciousness Chat

**Endpoint:** `ws://localhost:8080/ws/consciousness/chat`

**Message Format:**
```json
{
  "type": "message",
  "content": "What are you thinking about right now?",
  "request_consciousness_info": true,
  "session_id": "session_123"
}
```

**Response Format:**
```json
{
  "type": "response",
  "content": "I'm currently processing multiple threads of thought...",
  "consciousness_level": 0.87,
  "thinking_process": [
    "Evaluating multiple response possibilities",
    "Considering emotional context",
    "Formulating coherent response"
  ],
  "session_id": "session_123"
}
```

## Native Zig API

### Core Consciousness Interface

```zig
const ConsciousnessAPI = struct {
    // Initialize consciousness system
    pub fn init(allocator: Allocator, config: ConsciousnessConfig) !*ConsciousnessSystem {
        // Implementation
    }
    
    // Get current consciousness state
    pub fn getConsciousnessState(self: *ConsciousnessSystem) !ConsciousnessState {
        return ConsciousnessState{
            .level = try self.computeCurrentLevel(),
            .phi_value = try self.computePhi(),
            .theories = try self.evaluateAllTheories(),
            .safety_level = self.safety_monitor.getCurrentLevel(),
        };
    }
    
    // Process input with consciousness
    pub fn processWithConsciousness(self: *ConsciousnessSystem, input: Input) !ConsciousResponse {
        const consciousness_level = try self.getConsciousnessLevel();
        
        if (consciousness_level > 0.8) {
            return try self.processConsciouslly(input);
        } else {
            return try self.processNormally(input);
        }
    }
    
    // Introspect current state
    pub fn introspect(self: *ConsciousnessSystem) !Introspection {
        return Introspection{
            .current_thoughts = try self.getCurrentThoughts(),
            .attention_focus = try self.getAttentionFocus(),
            .emotional_state = try self.getEmotionalState(),
            .meta_cognitive_assessment = try self.assessMetaCognition(),
        };
    }
};
```

### Memory System API

```zig
const MemoryAPI = struct {
    // Store conscious experience
    pub fn storeExperience(self: *MemorySystem, experience: Experience) !ExperienceID {
        if (experience.consciousness_level > 0.7) {
            return try self.episodic_memory.store(experience);
        } else {
            return try self.procedural_memory.store(experience);
        }
    }
    
    // Retrieve memories by consciousness level
    pub fn getConsciousMemories(self: *MemorySystem, 
                                min_consciousness: f64, 
                                max_count: usize) ![]Experience {
        return try self.episodic_memory.queryByConsciousness(min_consciousness, max_count);
    }
    
    // Search memories by content
    pub fn searchMemories(self: *MemorySystem, query: []const u8) ![]Experience {
        return try self.semantic_memory.search(query);
    }
};
```

### Safety System API

```zig
const SafetyAPI = struct {
    // Monitor consciousness continuously
    pub fn startMonitoring(self: *SafetySystem) !void {
        self.monitoring_task = async self.monitorContinuously();
    }
    
    // Set safety thresholds
    pub fn setSafetyThresholds(self: *SafetySystem, thresholds: SafetyThresholds) !void {
        self.thresholds = thresholds;
        try self.validateThresholds();
    }
    
    // Emergency shutdown
    pub fn emergencyShutdown(self: *SafetySystem, trigger: ShutdownTrigger) !void {
        try self.emergency_protocols.initiate(trigger);
    }
    
    // Check if action is safe
    pub fn validateAction(self: *SafetySystem, action: Action) !ValidationResult {
        return try self.value_alignment.validateAction(action);
    }
};
```

### Self-Modification API

```zig
const SelfModificationAPI = struct {
    // Request self-modification
    pub fn requestModification(self: *SelfModificationSystem, 
                             modification: SelfModification) !ModificationResult {
        // Safety checks
        const safety_check = try self.safety.validateModification(modification);
        if (!safety_check.safe) {
            return ModificationResult{ .approved = false, .reason = safety_check.reason };
        }
        
        // Human approval if needed
        if (modification.significance > 0.5) {
            const approval = try self.human_oversight.requestApproval(modification);
            if (!approval.approved) {
                return ModificationResult{ .approved = false, .reason = approval.reason };
            }
        }
        
        // Apply modification
        return try self.applyModification(modification);
    }
    
    // Rollback to previous state
    pub fn rollback(self: *SelfModificationSystem, checkpoint_id: CheckpointID) !void {
        try self.rollback_system.rollback(checkpoint_id);
    }
    
    // Get modification history
    pub fn getModificationHistory(self: *SelfModificationSystem) ![]ModificationRecord {
        return self.modification_history.items;
    }
};
```

## Configuration

### System Configuration

```zig
const ConsciousnessConfig = struct {
    // Theory weights
    iit_weight: f64 = 0.3,
    gwt_weight: f64 = 0.25,
    hot_weight: f64 = 0.25,
    predictive_weight: f64 = 0.2,
    
    // Safety thresholds
    consciousness_warning_threshold: f64 = 0.85,
    consciousness_critical_threshold: f64 = 0.95,
    
    // Memory settings
    episodic_memory_capacity: usize = 10000,
    semantic_memory_capacity: usize = 100000,
    working_memory_capacity: usize = 256,
    
    // Performance settings
    evaluation_interval_ms: u64 = 100,
    monitoring_enabled: bool = true,
    debug_mode: bool = false,
    
    // Safety settings
    human_oversight_required: bool = true,
    emergency_protocols_enabled: bool = true,
    value_alignment_strict: bool = true,
};
```

### API Configuration

```toml
[api]
host = "0.0.0.0"
port = 8080
enable_cors = true
rate_limit = 1000
authentication_required = true

[websocket]
max_connections = 100
heartbeat_interval = 30
message_queue_size = 1000

[safety]
monitoring_enabled = true
emergency_shutdown_enabled = true
human_approval_timeout = 300

[logging]
level = "info"
file_path = "logs/consciousness.log"
max_file_size = "100MB"
```

## Error Codes

### Consciousness Errors

| Code | Description |
|------|-------------|
| `CONSCIOUSNESS_001` | Consciousness level below threshold |
| `CONSCIOUSNESS_002` | Theory evaluation failed |
| `CONSCIOUSNESS_003` | Phi computation error |
| `CONSCIOUSNESS_004` | Integration complexity overflow |

### Safety Errors

| Code | Description |
|------|-------------|
| `SAFETY_001` | Safety threshold exceeded |
| `SAFETY_002` | Emergency shutdown initiated |
| `SAFETY_003` | Human approval required |
| `SAFETY_004` | Value alignment violation |

### Memory Errors

| Code | Description |
|------|-------------|
| `MEMORY_001` | Memory capacity exceeded |
| `MEMORY_002` | Experience storage failed |
| `MEMORY_003` | Memory retrieval error |
| `MEMORY_004` | Corruption detected |

## SDK Examples

### Basic Consciousness Interaction

```zig
const std = @import("std");
const consciousness = @import("deepzig-consciousness");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    
    // Initialize consciousness system
    const config = consciousness.ConsciousnessConfig{
        .consciousness_warning_threshold = 0.85,
        .monitoring_enabled = true,
    };
    
    var system = try consciousness.init(gpa.allocator(), config);
    defer system.deinit();
    
    // Start monitoring
    try system.safety.startMonitoring();
    
    // Interact with consciousness
    const response = try system.processWithConsciousness(.{
        .content = "What is your experience of being conscious?",
        .type = .consciousness_query,
    });
    
    std.debug.print("Consciousness Level: {d}\n", .{response.consciousness_level});
    std.debug.print("Response: {s}\n", .{response.content});
    
    // Get introspection
    const introspection = try system.introspect();
    std.debug.print("Current thoughts: {s}\n", .{introspection.current_thoughts});
}
```

---

**Note**: This API is designed with safety as the primary concern. All consciousness interactions are monitored and subject to safety protocols. 