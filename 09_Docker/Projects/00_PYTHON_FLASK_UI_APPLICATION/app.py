from flask import Flask, render_template, request, make_response
import os
import socket
import random
import logging

# Options (can be overridden using env vars)
option_a = os.getenv('OPTION_A', "Linux")
option_b = os.getenv('OPTION_B', "Docker")
option_c = os.getenv('OPTION_C', "Kubernetes")

hostname = socket.gethostname()

app = Flask(__name__)

# Gunicorn logging support
gunicorn_error_logger = logging.getLogger('gunicorn.error')
if gunicorn_error_logger.handlers:
    app.logger.handlers.extend(gunicorn_error_logger.handlers)
app.logger.setLevel(logging.INFO)

@app.route("/", methods=["GET", "POST"])
def index():
    voter_id = request.cookies.get('voter_id')
    if not voter_id:
        voter_id = hex(random.getrandbits(64))[2:]

    vote = None

    if request.method == "POST":
        vote = request.form.get("vote")
        app.logger.info("Vote received: %s", vote)

    resp = make_response(render_template(
        "index.html",
        option_a=option_a,
        option_b=option_b,
        option_c=option_c,
        hostname=hostname,
        vote=vote
    ))

    resp.set_cookie("voter_id", voter_id)
    return resp


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80, debug=True)