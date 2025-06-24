from flask import Flask, request, render_template
import subprocess
import os

app = Flask(__name__)
@app.route("/", methods=["GET", "POST"])
def index():
    result = None
    k_value = None
    ell_result = None
    result_success = False
    html_output = None

    if request.method == "POST":
        action = request.form.get("action")

        if action == "ell_options":
            k = request.form.get("k")
            k_value = k

            sage_code = f"""
load('utils.sage')
print("\\\\( \\ell = " + latex(ell_options({k}))[6:-7] + " \\\\)")
"""
            #print(str(latex(\ell)) + '=' + str(latex(ell_options({k})))[6:-7])

            process = subprocess.run(["sage", "-c", sage_code],
                                     capture_output=True, text=True)

            ell_result = process.stdout.strip() if process.returncode == 0 else "Error: " + process.stderr.strip()
   
        elif action == "ap_euc":
            num1 = request.form.get("num1")
            num2 = request.form.get("num2")

            # Build the Sage code string
            sage_code = f"""
load('utils.sage')
load('template_euc.sage')
print(ap_euc({num1}, {num2}))
"""

            # Run the Sage command
            process = subprocess.run(
                ["sage", "-c", sage_code],
                capture_output=True,
                text=True
            )

            result = process.stdout.strip()    
            if process.returncode != 0:
                result = "Error: " + process.stderr.strip()
            else:
                result = "The proof has been generated successfully, and can be found below."
                result_success = True
            # Read generated HTML (if it exists)
            output_file = "proof_euc.html"
            if os.path.exists(output_file):
                with open(output_file, "r") as f:
                    html_output = f.read()

    return render_template("index.html", result=result, ell_result=ell_result, html_output=html_output, k_value=k_value, result_success = result_success)

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=5001)
