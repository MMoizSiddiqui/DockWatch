"""Tiny demo API for the DockWatch test stack. It only exists so the image builds and runs."""

import os

from flask import Flask, jsonify

app = Flask(__name__)


@app.get("/health")
def health():
    return jsonify(status="ok")


@app.get("/")
def index():
    return jsonify(service="shop-api", database=os.environ.get("DATABASE_URL", "unset"))


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
