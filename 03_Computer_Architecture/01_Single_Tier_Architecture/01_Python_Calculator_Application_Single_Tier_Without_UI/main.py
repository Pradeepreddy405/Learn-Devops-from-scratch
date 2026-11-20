
"""
Project: Calculator
Architecture: Single-Tier
Language: Python

UI, Business Logic, and Data Management
are implemented within one application.
"""

# ----------------------------------
# DATA MANAGEMENT
# ----------------------------------

calculation_history = []


# ----------------------------------
# BUSINESS LOGIC
# ----------------------------------

def add(a, b):
    return a + b


def subtract(a, b):
    return a - b


def multiply(a, b):
    return a * b


def divide(a, b):
    if b == 0:
        raise ZeroDivisionError("Cannot divide by zero")
    return a / b


def modulus(a, b):
    if b == 0:
        raise ZeroDivisionError("Cannot calculate modulus by zero")
    return a % b


def power(a, b):
    return a ** b


# ----------------------------------
# PRESENTATION LAYER
# ----------------------------------

def display_menu():
    print("\n========== PYTHON CALCULATOR ==========")
    print("1. Addition")
    print("2. Subtraction")
    print("3. Multiplication")
    print("4. Division")
    print("5. Modulus")
    print("6. Power")
    print("7. View History")
    print("8. Clear History")
    print("9. Exit")
    print("=======================================")


def get_numbers():
    try:
        a = float(input("Enter first number: "))
        b = float(input("Enter second number: "))
        return a, b
    except ValueError:
        print("Invalid input! Please enter numeric values.")
        return None


def display_history():
    print("\n========== CALCULATION HISTORY ==========")

    if not calculation_history:
        print("No calculation history available.")
        return

    for index, item in enumerate(calculation_history, start=1):
        print(f"{index}. {item}")

    print("=========================================")


def clear_history():
    calculation_history.clear()
    print("Calculation history cleared successfully.")


# ----------------------------------
# APPLICATION CONTROLLER
# ----------------------------------

def run_calculator():

    operations = {
        "1": ("Addition", "+", add),
        "2": ("Subtraction", "-", subtract),
        "3": ("Multiplication", "*", multiply),
        "4": ("Division", "/", divide),
        "5": ("Modulus", "%", modulus),
        "6": ("Power", "**", power)
    }

    while True:

        display_menu()

        choice = input("Select an option (1-9): ").strip()

        if choice == "9":
            print("Thank you for using Python Calculator!")
            break

        elif choice == "7":
            display_history()
            continue

        elif choice == "8":
            clear_history()
            continue

        elif choice not in operations:
            print("Invalid choice! Please select a valid option.")
            continue

        numbers = get_numbers()

        if numbers is None:
            continue

        a, b = numbers

        operation_name, symbol, operation = operations[choice]

        try:
            result = operation(a, b)

            expression = f"{a:g} {symbol} {b:g} = {result:g}"

            print(f"\nOperation: {operation_name}")
            print(f"Result: {result:g}")

            calculation_history.append(expression)

        except (ZeroDivisionError, OverflowError, ValueError) as error:
            print(f"Calculation Error: {error}")


# ----------------------------------
# APPLICATION ENTRY POINT
# ----------------------------------

if __name__ == "__main__":
    run_calculator()
