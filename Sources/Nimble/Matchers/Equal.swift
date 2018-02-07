import Foundation

/// A Nimble matcher that succeeds when the actual value is equal to the expected value.
/// Values can support equal by supporting the Equatable protocol.
///
/// @see beCloseTo if you want to match imprecise types (eg - floats, doubles).
public func equal<T: Equatable>(_ expectedValue: T?) -> Predicate<T> {
    return Predicate.define("equal <\(stringify(expectedValue))>") { actualExpression, msg in
        let actualValue = try actualExpression.evaluate()
        let matches = actualValue == expectedValue && expectedValue != nil
        if expectedValue == nil || actualValue == nil {
            if expectedValue == nil && actualValue != nil {
                return PredicateResult(
                    status: .fail,
                    message: msg.appendedBeNilHint()
                )
            }
            return PredicateResult(status: .fail, message: msg)
        }
        return PredicateResult(status: PredicateStatus(bool: matches), message: msg)
    }
}

/// A Nimble matcher that succeeds when the actual value is equal to the expected value.
/// Values can support equal by supporting the Equatable protocol.
///
/// @see beCloseTo if you want to match imprecise types (eg - floats, doubles).
public func equal<T, C: Equatable>(_ expectedValue: [T: C]?) -> Predicate<[T: C]> {
    return Predicate.define("equal <\(stringify(expectedValue))>") { actualExpression, msg in
        let actualValue = try actualExpression.evaluate()
        if expectedValue == nil || actualValue == nil {
            if expectedValue == nil && actualValue != nil {
                return PredicateResult(
                    status: .fail,
                    message: msg.appendedBeNilHint()
                )
            }
            return PredicateResult(status: .fail, message: msg)
        }
        return PredicateResult(
            status: PredicateStatus(bool: expectedValue! == actualValue!),
            message: msg
        )
    }
}

public func ==<T: Equatable>(lhs: Expectation<T>, rhs: T?) {
    lhs.to(equal(rhs))
}

public func !=<T: Equatable>(lhs: Expectation<T>, rhs: T?) {
    lhs.toNot(equal(rhs))
}

// TODO: remove
public func ==<T, C: Equatable>(lhs: Expectation<[T: C]>, rhs: [T: C]?) {
    lhs.to(equal(rhs))
}

public func !=<T, C: Equatable>(lhs: Expectation<[T: C]>, rhs: [T: C]?) {
    lhs.toNot(equal(rhs))
}

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
extension NMBObjCMatcher {
    @objc public class func equalMatcher(_ expected: NSObject) -> NMBMatcher {
        return NMBObjCMatcher(canMatchNil: false) { actualExpression, failureMessage in
            return try! equal(expected).matches(actualExpression, failureMessage: failureMessage)
        }
    }
}
#endif
