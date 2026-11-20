const display = document.getElementById("display");
const message = document.getElementById("message");
const historyList = document.getElementById("history");

let justCalculated = false;

function appendValue(value) {
    message.textContent = "";

    if (justCalculated) {
        if (/^[0-9.]$/.test(value)) {
            display.value = "";
        }
        justCalculated = false;
    }

    display.value += value;
}

function clearDisplay() {
    display.value = "";
    message.textContent = "";
    justCalculated = false;
}

function deleteLast() {
    display.value = display.value.slice(0, -1);
    message.textContent = "";
    justCalculated = false;
}

async function calculateResult() {
    const expression = display.value.trim();

    if (!expression) return;

    message.textContent = "";

    try {
        const response = await fetch("/calculate", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({ expression: expression })
        });

        const data = await response.json();

        if (!response.ok || !data.success) {
            throw new Error(data.error || "Calculation failed");
        }

        const result = Number(data.result.toPrecision(12));

        const item = document.createElement("li");
        item.textContent = `${expression} = ${result}`;
        historyList.prepend(item);

        display.value = String(result);
        justCalculated = true;

    } catch (error) {
        message.textContent = error.message;
    }
}

function clearHistory() {
    historyList.replaceChildren();
}

document.addEventListener("keydown", function(event) {
    if (/^[0-9.+*/%()-]$/.test(event.key)) {
        appendValue(event.key);
    } else if (event.key === "Enter" || event.key === "=") {
        event.preventDefault();
        calculateResult();
    } else if (event.key === "Backspace") {
        deleteLast();
    } else if (event.key === "Escape") {
        clearDisplay();
    }
});