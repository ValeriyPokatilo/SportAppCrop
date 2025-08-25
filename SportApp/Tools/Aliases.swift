import Foundation

typealias EmptyBlock = () -> Void
typealias ParameterBlock<T> = (T) -> Void
typealias DoubleParametersBlock<T, U> = (T, U) -> Void
typealias TripleParametersBlock<T, U, V> = (T, U, V) -> Void
