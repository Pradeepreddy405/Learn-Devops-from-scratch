from flask import Flask, render_template, request, jsonify
import ast
import operator
import math

app = Flask(__name__)

OPERATORS = {
    ast.Add: operator.add,
    ast.Sub: operator.sub,
    ast.Mult: operator.mul,
    ast.Div: operator.truediv,
    ast.USub: operator.neg,
    ast.UAdd: operator.pos,
    ast.Mod: operator.mod
}


def safe_calculate(expression):
    if not expression or len(expression) > 100:
        raise ValueError("Invalid expression")

    tree = ast.parse(expression, mode="eval")

    if sum(1 for _ in ast.walk(tree)) > 50:
        raise ValueError("Expression too complex")

    def evaluate(node):
        if isinstance(node, ast.Constant):
            if type(node.value) not in (int, float):
                raise ValueError("Invalid number")
            return node.value

        if isinstance(node, ast.BinOp):
            operation = OPERATORS.get(type(node.op))

            if operation is None:
                raise ValueError("Invalid operator")

            left = evaluate(node.left)
            right = evaluate(node.right)

            if isinstance(node.op, ast.Div) and right == 0:
                raise ZeroDivisionError

            result = operation(left, right)

            if not isinstance(result, (int, float)) or not math.isfinite(result):
                raise ValueError("Invalid result")

            if abs(result) > 1e100:
                raise ValueError("Result too large")

            return result

        if isinstance(node, ast.UnaryOp):
            operation = OPERATORS.get(type(node.op))

            if operation is None:
                raise ValueError("Invalid operator")

            return operation(evaluate(node.operand))

        raise ValueError("Invalid expression")

    return evaluate(tree.body)


@app.route("/")
def home():
    return render_template("index.html")


@app.route("/calculate", methods=["POST"])
def calculate():
    try:
        data = request.get_json(silent=True) or {}
        expression = data.get("expression", "")

        if not isinstance(expression, str):
            raise ValueError("Invalid expression")

        result = safe_calculate(expression)

        return jsonify({
            "success": True,
            "result": result
        })

    except ZeroDivisionError:
        return jsonify({
            "success": False,
            "error": "Cannot divide by zero"
        }), 400

    except (ValueError, SyntaxError, TypeError, OverflowError):
        return jsonify({
            "success": False,
            "error": "Invalid calculation"
        }), 400


@app.route("/health")
def health():
    return jsonify({"status": "healthy"})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False)