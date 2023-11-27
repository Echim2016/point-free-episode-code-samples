/*:
 # Domain Specific Languages: Part 1

 ## Exercises

 1.) Improve the simplify function to also recognize the following patterns:

 - Factorize the `c` out of this expression: `a * c + b * c`.
 - Reduce `1 * a` and `a * 1` to just `a`.
 - Reduce `0 * a` and `a * 0` to just `0`.
 - Reduce `0 + a` and `a + 0` to just `a`.
 - Are there any other simplification patterns you know of that you could implement?
 */

// Q1-1
print(simplify(Expr.add(.mul(3, 2), .mul(4, 2))))

// Q1-2
print(simplify(Expr.mul(1, 2)))
print(simplify(Expr.mul(2, 1)))

// Q1-3
print(simplify(Expr.mul(1, 0)))
print(simplify(Expr.mul(0, 1)))

// Q1-4
print(simplify(Expr.add(0, 1)))
print(simplify(Expr.add(1, 0)))

// Q1-5
// Enhance `Expr` to allow for any number of variables. The eval implementation will need to change to allow passing values in for all of the variables introduced.
let expr = Expr.add(.mul(.var("x"), 2), .mul(.var("y"), 6))
eval(expr, with: ["x": 2, "y": 3])
print(expr)
/*:
 2.) Implement infix operators `*` and `+` to work on `Expr` to get rid of the `.add` and `.mul` annotations.
 */
// TODO
/*:
 3.) Implement a function `varCount: (Expr) -> Int` that counts the number of `.var`s used in an expression.
 */
// TODO
/*:
 4.) Write a pretty printer for `Expr` that adds a new line and indentation when printing the sub-expressions inside `.add` and `.mul`.
 */
// TODO



// MARK: - Source

enum Expr: Equatable {
  case int(Int)
  indirect case add(Expr, Expr)
  indirect case mul(Expr, Expr)
  case `var`(String)
}

extension Expr: ExpressibleByIntegerLiteral {
  init(integerLiteral value: Int) {
    self = .int(value)
  }
}

func eval(_ expr: Expr, with values: [String: Int]) -> Int {
  switch expr {
  case let .int(value):
    return value
  case let .add(lhs, rhs):
    return eval(lhs, with: values) + eval(rhs, with: values)
  case let .mul(lhs, rhs):
    return eval(lhs, with: values) * eval(rhs, with: values)
  case let .var(id):
    guard let value = values[id] else { fatalError() }
    return value
  }
}

func print(_ expr: Expr) -> String {
  switch expr {
  case let .int(value):
    return "\(value)"
  case let .add(lhs, rhs):
    return "(\(print(lhs)) + \(print(rhs)))"
  case let .mul(lhs, rhs):
    return "(\(print(lhs)) * \(print(rhs)))"
  case let .var(id):
    return id
  }
}

func swap(_ expr: Expr) -> Expr {
  switch expr {
  case .int:
    return expr
  case let .add(lhs, rhs):
    return .mul(swap(lhs), swap(rhs))
  case let .mul(lhs, rhs):
    return .add(swap(lhs), swap(rhs))
  case .var:
    return expr
  }
}

func simplify(_ expr: Expr) -> Expr {
  switch expr {
  case .int:
    return expr
  case let .add(.mul(a, b), .mul(c, d)) where a == c:
    return .mul(a, .add(b, d))
  case let .add(.mul(a, b), .mul(c, d)) where b == d:
    return .mul(b, .add(a, c))
  case let .add(.int(0), a):
      return a
  case let .add(a, .int(0)):
      return a
  case .add:
    return expr
  case let .mul(.int(1), a):
      return a
  case let .mul(a, .int(1)):
      return a
  case .mul(.int(0), _):
      return .int(0)
  case .mul(_, .int(0)):
      return .int(0)
  case .mul:
    return expr
  case .var:
    return expr
  }
}
