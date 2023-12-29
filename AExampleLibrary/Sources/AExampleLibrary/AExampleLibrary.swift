// The Swift Programming Language
// https://docs.swift.org/swift-book

import ComposableArchitecture

public struct ImportableType: Reducer {
    public init(property: String = "Some Property") {
        self.property = property
    }
    
    public var property: String = "Some Property"
    
    public struct State: Equatable {
        public var stateA: String = ""
    }
    
    public enum Action {
        case task
    }
    
    public var body: some Reducer<State, Action> {
        EmptyReducer()
    }
}
