# FP_divider_SP
IEEE 754 Compliant Floating Point Divider (Verilog)
Implements single-precision (32-bit) floating point division with proper handling of special cases, normalization, rounding, and subnormal numbers.

📦 Project Structure
bash
Copy
Edit
fp_divider/
│
├── src/
│   ├── fp_divider.v         # Top module: full division + exception handling
│   ├── div.v                # Core shift-subtract division logic
│   ├── normalize            # Normalizes quotient (includes priority encoder)
│   ├── priority_encoder.v   # Finds leading one position
│   ├── rounding             # IEEE 754 rounding (nearest-even)
│   └── special_case         # NaN, Zero, Inf, Subnormal handling
│ 
│
├── tb/
│   └── FP_divider_tb.v      # Testbench
│
└── README.md                # This file
🔍 Features
✅ Shift-subtract division algorithm (integer-style)

✅ Normalization via left-shifting + priority encoder

✅ Rounding (round to nearest even using G, R, S bits)

✅ Special Cases:

NaN propagation

Division by zero

Infinity handling

Zero handling

Subnormal (Denormal) support for both input and output
coming soon but u can notice that its just has no hidden one when dividend is lower that the divisor 
✅ Fully synthesizable and modular design

🔧 How It Works
1. Input Decomposition
Splits input FP numbers into sign, exponent, and fraction

Handles hidden 1 for normalized inputs

2. Special Case Detection
Detects and handles:

NaN = exponent = 255, fraction ≠ 0

Infinity = exponent = 255, fraction = 0

Zero = exponent = 0, fraction = 0

Subnormal = exponent = 0, fraction ≠ 0

3. Preprocessing
Normalize subnormals before division

Converts all inputs to normalized form for division

4. Division Core
Performs 26-bit shift-subtract division

Generates 23-bit mantissa + 3 bits (Guard, Round, Sticky)

5. Normalization
Detects leading 1 in quotient

Left-shifts and adjusts exponent accordingly

6. Rounding
Rounds according to IEEE 754 (round to nearest even)

Uses GRS bits for decision

7. Final Assembly
Reconstructs 32-bit result: sign, exponent, mantissa

Applies correct exponent bias and corner cases

🧪 Simulation
Run the testbench using your preferred Verilog simulator (e.g., ModelSim, Vivado, Icarus Verilog):


📘 References
IEEE 754-2008 Standard for Floating-Point Arithmetic

Patterson & Hennessy – Computer Organization and Design
behroze prahimi
MIT 6.375 Digital Systems Architecture Notes

David Goldberg – What Every Computer Scientist Should Know About Floating-Point Arithmetic

