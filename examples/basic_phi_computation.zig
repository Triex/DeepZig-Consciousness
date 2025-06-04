// Basic Phi Computation Example
// This is a simplified example showing how Integrated Information Theory
// phi computation might be approached in Zig. This is for illustration only.

const std = @import("std");
const print = std.debug.print;

// Simple network state representation
const NetworkState = struct {
    nodes: []f32,
    connections: [][]f32,
    
    pub fn init(allocator: std.mem.Allocator, node_count: usize) !NetworkState {
        const nodes = try allocator.alloc(f32, node_count);
        const connections = try allocator.alloc([]f32, node_count);
        
        for (connections) |*row| {
            row.* = try allocator.alloc(f32, node_count);
        }
        
        return NetworkState{
            .nodes = nodes,
            .connections = connections,
        };
    }
    
    pub fn deinit(self: NetworkState, allocator: std.mem.Allocator) void {
        for (self.connections) |row| {
            allocator.free(row);
        }
        allocator.free(self.connections);
        allocator.free(self.nodes);
    }
};

// Simplified phi computation (not the full IIT formula)
pub fn computeSimplePhi(network: NetworkState) f32 {
    var total_integration: f32 = 0.0;
    var total_information: f32 = 0.0;
    
    // Simplified calculation - real IIT is much more complex
    for (network.nodes, 0..) |node_value, i| {
        total_information += node_value;
        
        // Sum connections to other nodes
        for (network.connections[i], 0..) |connection_weight, j| {
            if (i != j) {
                total_integration += connection_weight * network.nodes[j];
            }
        }
    }
    
    // Simplified phi = integration - information (very basic approximation)
    return @max(0.0, total_integration - total_information);
}

// Example usage
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    
    // Create a simple 3-node network
    var network = try NetworkState.init(allocator, 3);
    defer network.deinit(allocator);
    
    // Set some example node values
    network.nodes[0] = 0.8;
    network.nodes[1] = 0.6;
    network.nodes[2] = 0.4;
    
    // Set some example connections
    network.connections[0][1] = 0.5;
    network.connections[1][2] = 0.3;
    network.connections[2][0] = 0.7;
    
    const phi = computeSimplePhi(network);
    print("Computed phi value: {d:.3}\n", .{phi});
    
    if (phi > 0.5) {
        print("Network shows high integration (phi > 0.5)\n");
    } else {
        print("Network shows low integration (phi <= 0.5)\n");
    }
} 